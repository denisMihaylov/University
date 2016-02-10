#include<stdlib.h>
#include<stdio.h>
#include<errno.h>

int main(void) {
    errno = EACCES;
    perror("Test EACCES Message");
    exit(0);
}
