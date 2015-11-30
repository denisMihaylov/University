#include<stdio.h>
#include<unistd.h>
#include<fcntl.h>
#include<string.h>
#include<sys/types.h>
#include<sys/wait.h>
#include<stdlib.h>
int main(int argc, char *argv[])
{
    int i;
    printf("%s\n", getenv("USER")); 
    printf("\n");
    return 0;
}
