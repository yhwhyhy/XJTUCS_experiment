#include <stdio.h>
#include <pthread.h>

typedef struct
{
    int flag;
}spinlock_t;

void spinlock_init(spinlock_t* lock)
{
    lock->flag=0;
}

void spinlock_lock(spinlock_t* lock)
{
    while (__sync_lock_test_and_set(&lock->flag,1)) 
    {

    }//自旋等待
}

void spinlock_unlock(spinlock_t* lock)
{
    __sync_lock_release(&lock->flag);
}

int shared_value=0;

void* thread_function(void* arg)
{
    spinlock_t* lock=(spinlock_t*)arg;
    for (int i=0;i<5000;i++)
    {
        spinlock_lock(lock);
        shared_value++;
        spinlock_unlock(lock);
    }
    return NULL;
}

int main()
{
    pthread_t thread1,thread2;
    spinlock_t lock;
    printf("The initial shared value:%d\n",shared_value);
    spinlock_init(&lock);
    pthread_create(&thread1,NULL,thread_function,(void*)&lock);
    pthread_create(&thread2,NULL,thread_function,(void*)&lock);
    pthread_join(thread1,NULL);
    pthread_join(thread2,NULL);
    printf("After thr operation of two threads,the shared value:%d\n",shared_value);
    return 0;
}