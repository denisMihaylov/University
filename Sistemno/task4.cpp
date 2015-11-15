#include<unistd.h>
#include<fcntl.h>
#include<stdio.h>

int main() {
    int fdw, fdr, fdrw, l1, l2, wb1, wb2;
    char buf[25];
    fdw = open("f1", O_WRONLY);
    fdr = open("f1", O_RDONLY);
    fdrw = open("f1", O_RDWR);
    write(fdw, "Panda eats bamboo", 17);
    lseek(fdr, -6, SEEK_END);
    if (read(fdr, buf, 6) != -1) {
        write(1, buf, 6);
    }
    lseek(fdrw, 5, SEEK_SET);
    if(read(fdrw, buf, 5) != -1) {
        write(1, buf, 5);
    }
    lseek(fdr, -15, SEEK_END);
    if(read(fdr, buf, 5) != -1) {
        write(1, buf, 5);
    }
    return 0;
}
