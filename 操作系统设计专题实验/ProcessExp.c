#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>

//int value=0;
int main()
{
    pid_t pid,pid1;
    pid=fork();
    
    if (pid<0)
    {
        fprintf(stderr,"Fork Failed");
        return 1;
    }
    else if (pid==0)
    {
        pid1=getpid();
        //value++;
        //printf("child:pid=%d\n",pid);
        printf("child:pid1=%d\n",pid1);
        //execlp("/home/hvye/文档/system_call","ls",NULL);
        system("/home/hvye/文档/system_call");
        //printf("child:value=%d\n",value);
    }
    else
    {
        pid1=getpid();
        //value--;
        //printf("parent:pid=%d\n",pid);
        printf("parent:pid1=%d\n",pid1);
        //printf("parent:value=%d\n",value);
        wait(NULL);
    }
    // value=408;
    // printf("It's time to return,value=%d,address=%d\n",value,&value);
    return 0;
}