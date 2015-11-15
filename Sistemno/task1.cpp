#include<stdio.h>
#include<unistd.h>
#include<fcntl.h>
#include<string.h>

int main(int argc, char* argv[]) {
    if (argc < 2) {
        char error[35] = "Error: usage is with file name\n";
        write(2, error, strlen(error));
        return 0;
    }
    char* filename = argv[1];
    int fd = open(filename, O_RDONLY);
    if (fd == -1) {
        char error[30] = "Error: cannot open file\n";
        write(2, error, strlen(error));
        return 0;
    }
    int fd1 = open(filename, O_WRONLY | O_APPEND);
    char symbol[1];
    bool after_digit = false;
    while (read(fd, symbol, 1) == 1) {
        if (after_digit == false && symbol[0] >= '0' && symbol[0] <= '9')
            after_digit = true;
        if (after_digit)
            write(1, symbol, 1);
        else
            write(fd1, symbol, 1);
    }
    return 0;
}
