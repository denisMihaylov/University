#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <sys/wait.h>
#include <signal.h>
#include <sys/stat.h>
#include <fcntl.h>

#define PORT 5557
#define MAXDATASIZE 65536
#define BACKLOG 10
#define FILES_PATH "../"

char* pwd[256];

void send_directories(const int sock_fd, const char* path);

void send_file(const int sock_fd, const int file_fd);

int send_file_size(char* file_path, int sock_fd);

void escape_spaces(char* input);

int occurrances_in_string(char* input, char search);

void open_new_connection();

int main() {
    char buf[MAXDATASIZE];
    struct in_addr my_addr;
    struct sockaddr_in my_sock;
    memset(&my_sock, 0, sizeof(my_sock));
    my_sock.sin_family = AF_INET;
    my_sock.sin_addr.s_addr = INADDR_ANY;
    if (fork()) {//listen for new connections
        my_sock.sin_port = htons(PORT);

        int my_fd, new_fd, numbytes;

        if ((my_fd = socket(AF_INET, SOCK_STREAM, 0)) == -1) {
            perror("socket");
            return 0;
        }

        if(bind(my_fd, (struct sockaddr *)&my_sock, sizeof my_sock) == -1) {
            perror("bind");
            return 0;
        }

        if (listen(my_fd, BACKLOG) == -1) {
            perror("listen");
            return 0;
        }
        struct sockaddr_storage their_addr;
        socklen_t sin_size = sizeof(their_addr);

        while(1){
            new_fd = accept(my_fd, (struct sockaddr *)&their_addr, &sin_size);
            if (new_fd == -1) {
              perror("accept");
              return 1;
            }
            if (!fork()) {
                char path[] = "../";
                send_directories(new_fd, path);
                while ((numbytes = recv(new_fd, buf, MAXDATASIZE, 0)) != 0) {
                    if (numbytes == -1) {
                        perror("recv");
                        return 1;
                    }
                    if(!strncmp(buf, "cd", 2)) {
                        escape_spaces(&buf[3]);
                        strcat(path, &buf[3]);
                        strcat(path, "/");
                        send_directories(new_fd, path);
                    } else if (!strncmp(buf, "down", 4)) {
                        char file_path[MAXDATASIZE];
                        strcpy(file_path, path);
                        strcat(file_path, &buf[5]);
                        int file_fd = send_file_size(file_path, new_fd);
                    }
                    memset(buf, 0, sizeof(buf));
                }
                //handle closing of the connection from the client
                close(my_fd);
                close(new_fd);
                return 0; 
            }
        }

        return 0;
    } else {//listen for new download requests
        my_sock.sin_port = htons(PORT + 1);
        int my_fd, new_fd, numbytes;
        if ((my_fd = socket(AF_INET, SOCK_STREAM, 0)) == -1) {
            perror("socket");
            return 0;
        }

        if(bind(my_fd, (struct sockaddr *)&my_sock, sizeof my_sock) == -1) {
            perror("bind");
            return 0;
        }

        if (listen(my_fd, BACKLOG) == -1) {
            perror("listen");
            return 0;
        }
        struct sockaddr_storage their_addr;
        socklen_t sin_size = sizeof(their_addr);
        while(1){
            new_fd = accept(my_fd, (struct sockaddr *)&their_addr, &sin_size);
            if (new_fd == -1) {
              perror("accept");
              return 1;
            }
            if (!fork()) {
                char file_path[MAXDATASIZE];
                if(recv(new_fd, file_path, sizeof(file_path), 0) == -1) {
                    perror("recv");
                    return 1;
                }
                printf("Request: %s\n", file_path);
                int fd = open(file_path, O_RDONLY); 
                send_file(new_fd, fd);
                return 0; 
            }
        }
    }
}

int send_file_size(char* file_path, int sock_fd) {
    int file_fd = open(file_path, O_RDONLY);
    struct stat st;
    struct response {
        size_t size;
        char path[400];
    };
    response result;
    fstat(file_fd, &st);
    strcpy(result.path, file_path);
    result.size = st.st_size;
    if (send(sock_fd, &(result), sizeof(response), 0) == -1) {
        perror("send");
        close(file_fd);
        exit(1);
    }
    return file_fd;
}

int occurrances_in_string(char* input, char search) {
    int result = 0;
    for (int i = 0; i < strlen(input); i++)
        if (search == input[i])
            result++;
    return result;
}

void send_directories(const int sock_fd, const char* path) {
    int fd[2];
    pipe(fd);
    if (fork()) {
        close(fd[0]);
        close(1);
        dup(fd[1]);
        execlp("ls", "ls", "-1", path, (char*)NULL);
    } else {
        close(fd[1]);
        send_file(sock_fd, fd[0]);
    }    
}

void send_file(const int sock_fd, const int file_fd) {
    if(fork()) {
        char buffer[MAXDATASIZE + 1];
        memset(buffer, 0, sizeof(buffer));
        while(read(file_fd, buffer, MAXDATASIZE) != 0) {
            if (send(sock_fd, buffer, strlen(buffer), 0) == -1) {
                perror("send");
                close(file_fd);
                exit(0);
            }
            memset(buffer, 0, sizeof(buffer));
        }
        close(file_fd);
        exit(0);
    }
}

void escape_spaces(char* input) {
    char* result = (char*)malloc(strlen(input) + occurrances_in_string(input, ' ') + 1); 
    for(int i = 0, j = 0; i < strlen(input); i++, j++) {
        if(input[i] == ' ')
            result[j++] = '\\';
        result[j] = input[i];
    }
    input = result;
}
