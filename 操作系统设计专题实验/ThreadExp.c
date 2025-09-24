#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>
#include <semaphore.h>

int value=0;
sem_t signal;


void* Thread1()
{
    printf("Thread1 is created successfully,\n");
    for (int i=0;i<500000;i++)
    {
        sem_wait(&signal);
        value++;
        sem_post(&signal);
        
    }
    pthread_t tid1;
    tid1=pthread_self();
    pid_t pid;
    pid=getpid();
    //printf("tid1=%d,pid1=%d\n",tid1,pid);
    //system("/home/hvye/文档/system_call");
    //execlp("/home/hvye/文档/system_call","ls",NULL);
    pthread_exit(0);
    return NULL;
}

void* Thread2()
{
    printf("Thread2 is created successfully.\n");
    for (int i=0;i<500000;i++)
    {
        sem_wait(&signal);
        value--;
        sem_post(&signal);
    }
     pthread_t tid2;
    tid2=pthread_self();
    pid_t pid;
    pid=getpid();
    //printf("tid2=%d,pid2=%d\n",tid2,pid);
    //system("/home/hvye/文档/system_call");
    //execlp("/home/hvye/文档/system_call","ls",NULL);
    pthread_exit(0);
    return NULL;
    
}


int main()
{
    pthread_t tid1,tid2;
    sem_init(&signal,0,1);
    pthread_create(&tid1,NULL,Thread1,NULL);
    pthread_create(&tid2,NULL,Thread2,NULL);
    pthread_join(tid1,NULL);
    pthread_join(tid2,NULL);
    printf("value=%d\n",value);
    return 0;
}