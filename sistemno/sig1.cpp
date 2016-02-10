#include <signal.h>
#include <unistd.h>
#include <stdio.h>
void sig_usr(int);

int main()
{
    if (signal(SIGUSR1, sig_usr) == SIG_ERR)
        perror("sig1");
    if (signal(SIGUSR2, sig_usr) == SIG_ERR)
        perror("sig2");
    for (int i = 0; i < 2;i++ )
        pause();
    return 0;
}
void sig_usr(int sig)
{
    if (sig == SIGUSR1)
        printf("received SIGUSR1\n");
    else if (sig == SIGUSR2)
        printf("received SIGUSR2\n");
    else
        printf("received signal %d\n", sig);
    return;
}
