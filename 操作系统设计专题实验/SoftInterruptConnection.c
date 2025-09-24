#include <stdio.h>
#include <unistd.h>
#include <sys/wait.h>
#include <stdlib.h>
#include <signal.h>
int flag=0;

void inter_handler(int signal)
{
    printf("\n%d stop test\n",signal);
}

void waiting()
{
    signal(2,SIG_IGN);
    signal(3,SIG_IGN);
    pause();
}

int main()
{   
    pid_t pid1=-1,pid2=-1;
    while (pid1==-1) pid1=fork();
    if (pid1>0)
    {
        while (pid2==-1) pid2=fork();
        if (pid2>0)
        {
            
            signal(14,inter_handler);
            signal(2,inter_handler);
            signal(3,inter_handler);
            alarm(5);
            pause();
            kill(pid2,17);
            kill(pid1,16);
            wait(NULL);
            wait(NULL);
            printf("\nParent process is killed.\n");
        }
        else
        {
            signal(17,inter_handler);
            waiting();
            printf("\nChile process2 is killed by parent.\n");
            return 0;
        }
    }
    else
    {
        signal(16,inter_handler);
        waiting();
        printf("\nChild process1 is killed by parent.\n");
        return 0;
    }
    return 0;
}