#include <unistd.h>
#include <signal.h>
#include <stdio.h>
#include <string.h>
#include <sys/wait.h>
#include <stdlib.h>

int pid1,pid2;

int main()
{
    int fd[2];
    char InPipe[30000];
    char* c1="Child process1 is sending message.\n";
    char* c2="Child process2 is senging message.\n";
    char in1='1';
    char in2='2';
    pipe(fd);
    while ((pid1=fork())==-1) ;
    if (pid1==0)
    {
        lockf(fd[1],1,0);
        //write(fd[1],c1,strlen(c1));
        for (int i=0;i<14000;i++)
        {
            write(fd[1],&in1,1);
        }
        sleep(5);
        lockf(fd[1],0,0);
        exit(0);
    }
    else
    {
        while((pid2=fork())==-1) ;
        if (pid2==0)
        {
            lockf(fd[1],1,0);
            //write(fd[1],c2,strlen(c2)+1);
            for (int i=0;i<14000;i++)
            {
                write(fd[1],&in2,1);
            }
            sleep(5);
            lockf(fd[1],0,0);
            exit(0);
        }
        else
        {
            wait(0);
            wait(0);
            //read(fd[0],InPipe,strlen(c1)+strlen(c2)+1);
            read(fd[0],InPipe,28000);
            InPipe[28001]='\0';
            printf("%s\n",InPipe);
        }
    

    }
    return 0;
}