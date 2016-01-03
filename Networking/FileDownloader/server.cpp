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

#define PORT 4441
#define MAXDATASIZE 1452
#define BACKLOG 10
#define FILES_PATH "../"

void send_file(const char *path = "../client.cpp") {
    int fd = open(path, O_RDONLY);
    
}

int main() {
    printf("Initializing server...\n");
    char buf[MAXDATASIZE];
    struct in_addr my_addr;
    struct sockaddr_in my_sock;
    memset(&my_sock, 0, sizeof(my_sock));
    my_sock.sin_family = AF_INET;
    my_sock.sin_addr.s_addr = INADDR_ANY;
    my_sock.sin_port = htons(PORT);

    int my_fd, new_fd, numbytes;

    if ((my_fd = socket(AF_INET, SOCK_STREAM, 0)) == -1) {
        perror("socket");
        return 0;
    }

    printf("Binding...\n");
    if(bind(my_fd, (struct sockaddr *)&my_sock, sizeof my_sock) == -1) {
        perror("bind");
        return 0;
    }

    printf("Listening on port %d\n", PORT);
    if (listen(my_fd, BACKLOG) == -1) {
        perror("listen");
        return 0;
    }
    struct sockaddr_storage their_addr;
    socklen_t sin_size = sizeof(their_addr);

    while(1){
        printf("Accepting...\n");
        new_fd = accept(my_fd, (struct sockaddr *)&their_addr, &sin_size);
        if (new_fd == -1) {
          perror("accept");
          return 1;
        }
        if (!fork()) {
            printf("Receiving...\n");
            while ((numbytes = recv(new_fd, buf, MAXDATASIZE, 0)) != 0) {
                if (numbytes == -1) {
                    perror("recv");
                    return 1;
                }
                if (send(new_fd, buf, MAXDATASIZE, 0) == -1) {
                    perror("send");
                    return 0;
                }
            }
            //handle closing of the connection from the client
            close(my_fd);
            close(new_fd);
            return 0; 
        }
    }

    return 0;
}
