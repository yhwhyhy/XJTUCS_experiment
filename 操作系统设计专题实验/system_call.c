#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>

int main()
{
    pid_t new_pid;
    new_pid=getpid();
    printf("After exec/system, the pid is %d\n",new_pid);
    return 0;
}