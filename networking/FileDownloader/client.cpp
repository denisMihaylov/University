#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <netdb.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <sys/wait.h>
#include <sys/ipc.h>
#include <sys/shm.h>

#include <arpa/inet.h>

#define PORT 5557
#define MAXDATASIZE 65536
#define INET_ADDR "192.168.1.104"
#define MAX_DOWNLOADS 10
#define COLOR "\x1B[35m"
#define RESET "\033[0m"

int my_fd, numbytes;
int shmkey_start = 100;
char buf[MAXDATASIZE + 1];
char* directory[50];
int directory_count;
size_t file_size[MAX_DOWNLOADS];
char download_file_name[MAX_DOWNLOADS][50];
char* input;
char* progress[MAX_DOWNLOADS];
int download = 0;
size_t size;

int split_string(char* string, char** result, char split);

void print_help();

void send_to_server(int my_fd, char* input);

int recv_from_server(int my_fd, void *buf);

void print_directories();

void reset_directories();

void handle_input();

bool is_directory_valid(char* directory);

void start_download();

int connect_to_port(int port);

int main() {
    system("clear");
    printf("Welcome to the " COLOR "File Downloader" RESET "!\n\tCreated by: " COLOR "Denis Mihaylov\n" RESET);
    my_fd = connect_to_port(PORT);
    
    input = (char *)malloc(MAXDATASIZE * sizeof(char));
    printf("\nHere is the complete list of available directories\n"
              "Note: Files have extensions, directories do not!\n");
    recv_from_server(my_fd, buf);
    print_directories();
    while(strcmp(input, "exit")) {
        printf("\nCommand (for help type \"help\"): ");
        memset(input, 0, sizeof(input));
        getline(&input, &size, stdin);
        input[strlen(input) - 1] = '\0';
        if (!strcmp(input, "help")) {
            print_help();
        } else if (strcmp(input, "exit")) {
            handle_input();
        }
    }

    return 0;
}

int connect_to_port(int port) {
    int my_fd;
    struct sockaddr_in my_sock;
    my_sock.sin_family = AF_INET;
    if (inet_pton(AF_INET, INET_ADDR, &(my_sock.sin_addr)) != 1) {
        perror("Invalid address");
        return 1;
    }
    my_sock.sin_port = htons(port);

    if((my_fd = socket(AF_INET, SOCK_STREAM, 0)) == -1) {
        perror("socket");
        return 1;
    }

    if(connect(my_fd, (struct sockaddr *)&my_sock, sizeof my_sock) == -1) {
        close(my_fd);
        perror("client: connect");
        return 1;
    }
    return my_fd;
}

void handle_input() {
    if (!strncmp(input, "cd", 2)) {
        if (strlen(input) <=4 || strcmp(&input[3], "..") && !is_directory_valid(&input[3])) {
            printf("No such directory\n");
            return;
        }
        send_to_server(my_fd, input);
        reset_directories();
        recv_from_server(my_fd, buf);
        printf("Directories:\n");
        print_directories();
    } else if (!strncmp(input, "down", 4)) {
        if (strlen(input) <= 6 || !is_directory_valid(&input[5])) {
            printf("No such file in the directory\n");
            return;
        }
        int i;
        for (i = 5; i < strlen(input); i++)
            if (input[i] == '.')
                break;
        if (i == strlen(input)) {
            printf("Wanted resource is not a file!\n");
            return;
        }
        start_download();
        printf("The downloading of file '%s' has started\n"
               "To check the status of the downloading use the status command\n", &input[5]);
    } else if (!strncmp(input, "status", 6)) {
        if (download == 0) {
            printf("No active downloads\n");
        } else {
            int i, j;
            for (i = 0, j = 0; i < download; i++) {
                printf("%s: %s%%\n", download_file_name[i], progress[i]);
                if (strcmp(progress[i], "100")) {
                    j++;
                    if (j < i) {
                        progress[j] = progress[i];
                        memset(download_file_name[j], 0, sizeof(download_file_name[j]));
                        strcpy(download_file_name[j], download_file_name[i]);
                    }
                } else if (shmdt(progress[i]) == -1) {
                    perror("shmdt parent");
                }
            }
            download = j;
        }
    } else if(!strncmp(input, "ls", 2)) {
        for(int i = 0; i < directory_count; i++)
            printf("%d. %s\n", i, directory[i]);
    } else {
        printf("No such command\n");
    }
}

void start_download() {
    int current_download = download++;
    memset(download_file_name[current_download], 0, sizeof(download_file_name[current_download]));
    strcpy(download_file_name[current_download], &input[5]);
    // starting download and getting file size
    send_to_server(my_fd, input);
    struct response {
        size_t size;
        char path[400];
    };
    response result;
    recv_from_server(my_fd, &result);
    file_size[current_download] = result.size;
    int shmid;
    int key = shmkey_start++;
    if ((shmid = shmget(key, 10, IPC_CREAT | SHM_R | SHM_W)) < 0) {
        perror("shmget");
        exit(0);
    }
    if ((progress[current_download] = (char*)shmat(shmid, NULL, 0)) == (char*) -1) {
        perror("shmat 1");
        exit(0);
    }
    if (!fork()) {
        char* prog;
        if ((prog = (char*)shmat(shmid, NULL, 0)) == (char*) -1) {
            perror("shmat 2");
            exit(0);
        }
        int download_fd = connect_to_port(PORT + 1);
        char buffer[MAXDATASIZE + 1];
        int bytes;
        send_to_server(download_fd, result.path);
        int file_fd = creat(download_file_name[current_download], 0744);
        size_t total_bytes = 0;
        int progress = 0;
        while(progress < 100) {
            bytes = recv_from_server(download_fd, buffer);
            total_bytes += bytes;
            progress = total_bytes*100/file_size[current_download];
            if (write(file_fd, buffer, bytes) == -1) {
                perror("download to file");
                exit(0);
            }
            char tmp[12]={0x0};
            if (sprintf(tmp,"%d", progress) < 0) {
                perror("sprintf");
                exit(0);
            }
            memset(prog, 0, sizeof(prog));
            strcpy(prog, tmp);
        }
        close(file_fd);
        if (shmdt(prog) == -1) {
            perror("shmdt child");
        }
        exit(0);
    }
}

void reset_directories() {
    for (int i = 0; i < directory_count; i++) {
        memset(directory[i], 0, sizeof(directory[i]));
    }
}

bool is_directory_valid(char* checked_directory) {
    for (int i = 0; i < directory_count; i++) {
        if (!strncmp(directory[i], checked_directory, strlen(checked_directory))) {
            if (strlen(checked_directory) < strlen(directory[i])) {
                strcat(checked_directory, &directory[i][strlen(checked_directory)]);
            }
            return true;
        }
    }
    return false;
}

void print_directories() {
    directory_count = split_string(buf, directory, '\n');
    for (int i = 0; i < directory_count; i++)
        printf("%d. %s\n", i, directory[i]);
}

int split_string(char* string, char** result, char split) {
    char* pch;
    int i = 0;
    pch = strtok(string, &split);
    while (pch != NULL) {
        result[i++] = pch;
        pch = strtok(NULL, &split);
    }
    return i;
}

void send_to_server(int my_fd, char* input) {
    if(send(my_fd, input, strlen(input), 0) == -1) {
        perror("send");
        exit(1);
    }
}

int recv_from_server(int my_fd, void* buf) {
    if ((numbytes = recv(my_fd, buf, MAXDATASIZE, 0)) == -1) {
        perror("recv");
        exit(1);
    }
    return numbytes;
}

void print_help() {
    printf("Available Commands:\n\t" COLOR "help" RESET " - shows all available commands\n"
           "\t" COLOR "ls" RESET " - lists all possible directories\n"
           "\t" COLOR "cd DIR" RESET " - changes the directory to the one defined by DIR. "
           "Using \"cd ..\" will navigate to the parent directory(There is " COLOR "autocompletion!" RESET ")\n"
           "\t" COLOR "down file_name" RESET " - downloads the file\n"
           "\t" COLOR "status" RESET " - checks the status of all the downloads\n"
           "\t" COLOR "exit" RESET " - leaves the application\n");
}
