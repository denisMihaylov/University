#include<fcntl.h>
#include<stdio.h>
#include<unistd.h>
#include<stdlib.h>
#include<sys/wait.h>

int main(int argc, char* argv[]) {
    int pid, fd;
    char buf[5];
    if((pid = fork()) == 1) {
        write(2, "Fork failed\n", 13);
        return 0;
    }

    if (pid != 0) {
        int* status;
        wait(status);
        fd = open("file.txt", O_RDWR | O_APPEND);
        write(fd, "7", 1);
        lseek(fd, 0, SEEK_SET);
        int n = read(fd, buf, 5);
        write(1, buf, n);
    } else {
        fd = open("file.txt", O_TRUNC | O_CREAT | O_WRONLY, 0644);
        dup2(fd, 1);
        close(fd);
        execlp("echo", "echo", "123456", NULL);
    }
    return 0;
}
