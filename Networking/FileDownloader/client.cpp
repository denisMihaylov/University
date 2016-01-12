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

#include <arpa/inet.h>

#define PORT 5557
#define MAXDATASIZE 65536
#define INET_ADDR "192.168.0.107"
#define MAX_DOWNLOADS 10

int my_fd, numbytes;
char buf[MAXDATASIZE + 1];
char* directory[50];
int directory_count;
size_t file_size[MAX_DOWNLOADS];
char download_file_name[MAX_DOWNLOADS][50];
char* input;
int pipes[MAX_DOWNLOADS][2];
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
    printf("Welcome to the File Downloader!\n\tCreated by: Denis Mihaylov\n");
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
        start_download();
        printf("The downloading has started\n"
               "To check the status of the downloading use the status command\n");
    } else if (!strncmp(input, "status", 6)) {
        if (download == 0) {
            printf("No active downloads\n");
        } else {
            int i, j;
            printf("%d\n", download);
            for (i = 0, j = 0; i < download; i++) {
                char progress[5];
                lseek(pipes[i][0], 0, SEEK_SET);
                int a = read(pipes[i][0], progress, 5);
                progress[a] = '\0';
                printf("%s: %s%%\n", download_file_name[i], progress);
                if (strcmp(progress, "100")) {
                    j++;
                    if (j < i) {
                        pipes[j][0] = pipes[i][0];
                        pipes[j][1] = pipes[i][1];
                        memset(download_file_name[j], 0, sizeof(download_file_name[j]));
                        strcpy(download_file_name[j], download_file_name[i]);
                    }
                }
            }
            download = j;
        }
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
    pipe(pipes[current_download]);
    if (!fork()) {
        close(pipes[current_download][0]);
        int download_fd = connect_to_port(PORT + 1);
        char buffer[MAXDATASIZE + 1];
        int bytes;
        send_to_server(download_fd, result.path);
        int file_fd = creat(download_file_name[current_download], 0744);
        size_t total_bytes = 0;
        int progress = 0;
        while(progress < 100) {
            bytes = recv_from_server(download_fd, buffer);
            lseek(pipes[current_download][1], 0, SEEK_SET);
            total_bytes += bytes;
            progress = total_bytes*100/file_size[current_download];
            write(file_fd, buffer, bytes);
            char tmp[12]={0x0};
            sprintf(tmp,"%d", progress);
            write(pipes[current_download][1], tmp, strlen(tmp));
            printf("%d, %s\n", (int)strlen(tmp), tmp);
            char a[5];
        }
        close(file_fd);
        exit(0);
    }
    close(pipes[current_download][1]);
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
    printf("Available Commands:\n\thelp - shows all available commands\n"
           "\tcd DIR - changes the directory to the one defined by DIR. "
           "Using \"cd ..\" will navigate to the parent directory(There is autocompletion!)\n"
           "\tdown file_name path - downloads the file\n"
           "\tstatus - checks the status of all the downloads\n"
           "\texit - leaves the application");
}
