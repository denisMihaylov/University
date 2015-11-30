#include<unistd.h>
#include<fcntl.h>
#include<stdio.h>

int main(int argc, char* argv[]) {
    int fd = open("file.hole", O_WRONLY|O_CREAT|O_TRUNC , 0640);
    char buff1[] = "Text1";
    char buff2[] = "Text2";
    write(fd, buff1, 5);
    printf("%d\n", (int)lseek(fd, 10, SEEK_CUR));
    write(fd, buff2, 5);
    return 0;
}
