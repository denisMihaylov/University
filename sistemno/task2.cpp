#include<stdio.h>
#include<unistd.h>
#include<fcntl.h>
#include<string.h>
#include<sys/types.h>
#include<sys/wait.h>

int main(int argc, char* argv[]) {
    if (argc < 2) {
        printf("Error: usage with username.\n");
        return 0;
    }
    int fd1 = open("temp_file", O_TRUNC | O_CREAT | O_RDONLY, 0644);
    int fd2 = open("temp_file", O_WRONLY);
    if(fork()) {
        int status;
        wait(NULL);
        dup2(fd1, 0);
        char buffer[20];
        int number;
        while (number = scanf("%s", buffer) > 0) {
            if (strcmp(buffer, argv[1]) == 0) {
                printf("YES\n");
                return 0;
            }
        }
        printf("NO\n");
    } else {
        dup2(fd2, 1);
        execlp("who", "who", "-q", NULL);
    }
    return 0;
}
