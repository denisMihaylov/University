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

#define PORT 4444
#define MAXDATASIZE 65536
#define INET_ADDR "10.255.3.96"

int split_string(char* message, char** result) {
    char* pch;
    int i = 0;
    pch = strtok(message, "\n");
    while (pch != NULL) {
        result[i++] = pch;
        pch = strtok(NULL, "\n");
    }
    return i;
}

void printHelp();

int main() {
    system("clear");
    printf("Welcome to the File Downloader!\n\tCreated by: Denis Mihaylov\n");
    int my_fd, numbytes;
    char buf[MAXDATASIZE + 1];
    struct sockaddr_in my_sock;
    my_sock.sin_family = AF_INET;
    if (inet_pton(AF_INET, INET_ADDR, &(my_sock.sin_addr)) != 1) {
        fprintf(stderr, "Invalid address\n");
        return 1;
    }
    my_sock.sin_port = htons(PORT);

    if((my_fd = socket(AF_INET, SOCK_STREAM, 0)) == -1) {
        perror("socket");
        return 1;
    }

    if(connect(my_fd, (struct sockaddr *)&my_sock, sizeof my_sock) == -1) {
        close(my_fd);
        perror("client: connect");
        return 1;
    }
    
    char input[MAXDATASIZE];
    printf("\nHere is the complete list of available directories\n"
              "Note: Files have extensions, directories do not!\n");
    if ((numbytes = recv(my_fd, buf, MAXDATASIZE, 0)) == -1) {
        perror("recv");
        exit(1);
    }
    char* directory[15];
    int n = split_string(buf, directory);
    for (int i = 0; i < n; i++)
        printf("%d. %s\n", i, directory[i]);
    while(strcmp(input, "exit") != 0) {
        printf("\nCommand (for help type \"help\"): ");
        scanf("%s", input);
        if (!strcmp(input, "help")) {
            printHelp();
        }
        if (send(my_fd, input, strlen(input), 0) == -1)
           perror("send");
        
        
    }

    return 0;
}

void printHelp() {
    printf("Available Commands:\n\thelp - shows all available commands\n"
           "\tcd _ - changes the directory to the one defined by _. Using \"cd ..\" will navigate to the parent directory\n"
           "\t\n");
}
