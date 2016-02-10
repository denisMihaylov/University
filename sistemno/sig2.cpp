#include <signal.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/stat.h>
#include <stdio.h>

void wakeup(int);
void quit(int);

int main(int argc, char*argv[]) {
    struct stat st;
    time_t atime;
    if (argc != 2)
        perror("usage: a.out filename");
    if (stat(argv[1], &st) == -1)
        perror("stat error");
    atime = st.st_atime;
    signal(SIGINT, quit);
    signal(SIGTERM, quit);
    signal(SIGALRM, wakeup);
    for(;;) {
        if (stat(argv[1], &st) == -1)
            perror("stat error");
        if (atime != st.st_atime) {
            printf("%s: accessed\n", argv[1]);
            atime = st.st_atime;
        }
        alarm(60);
        pause();
    }
    return 0;
}

void quit(int sig) {
    printf("Termination of process %d on signal %d\n", getpid(), sig);
    exit(0);
}

void wakeup(int sig)
{
    signal(SIGALRM, wakeup); /*for safety in all version of UNIX systems */
}
