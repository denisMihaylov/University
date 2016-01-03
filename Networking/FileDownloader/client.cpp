#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <netdb.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <sys/socket.h>

#include <arpa/inet.h>

#define PORT 4441
#define MAXDATASIZE 65536
#define INET_ADDR "192.168.100.2"

int split_message(string message, string[] result);

int main() {
    printf("Initializing client...\n");
    int my_fd, numbytes;
    char buf[MAXDATASIZE + 1];
    struct sockaddr_in my_sock;
    my_sock.sin_family = AF_INET;
    if (inet_pton(AF_INET, INET_ADDR, &(my_sock.sin_addr)) != 1) {
        fprintf(stderr, "Invalid address\n");
        return 1;
    }
    my_sock.sin_port = htons(PORT);

    printf("Creating socket...\n");
    if((my_fd = socket(AF_INET, SOCK_STREAM, 0)) == -1) {
        perror("socket");
        return 1;
    }

    printf("Connecting to server...\n");
    if(connect(my_fd, (struct sockaddr *)&my_sock, sizeof my_sock) == -1) {
        close(my_fd);
        perror("client: connect");
        return 1;
    }
    
    char input[MAXDATASIZE];
    while(strcmp(input, "exit") != 0) {
        //if (send(my_fd, input, MAXDATASIZE, 0) == -1)
           //perror("send");
        if ((numbytes = recv(my_fd, buf, MAXDATASIZE, 0)) == -1) {
            perror("recv");
            exit(1);
        }
        string directory[15];
        int n = split_string(buf, directory);
        for (int i = 0; i < n; i++) {
            printf("%d. %s\n", i, directory[i])
        //printf("Command:");
        //scanf("%s", input);
    }

    return 0;
}

int split_message(string message, string[] result) {
    
}
