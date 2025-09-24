#include <stdio.h>
#include "string.h"
#include "stdlib.h"
#include "time.h"
#include <sys/ioctl.h>
#include <termios.h>
#include <unistd.h>
#define blocks 4611 //总块数
#define blocksiz 512 //块大小
#define inodesiz 64 //索引节点长度
#define data_begin_block 515 //数据开始块
#define dirsiz 32 //目录长度
#define EXT2_NAME_LEN 15 //文件名长度
#define PATH "vdisk"  //文件系统

typedef struct ext2_group_desc
{
    char bg_volumn_name[16];
    int bg_block_bitmap; //块位图的块号
    int bg_inode_bitmap; //索引位图块号
    int bg_inode_table; //索引节点表的起始地址
    int bg_free_blocks_count;
    int bg_free_inodes_count;
    int bg_used_dirs_count;
    char psw[16];
    char bg_pad[24];
}ext2_group_desc;

typedef struct ext2_inode
{
    int i_mode; //文件类型和权限
    int i_blocks; //文件数据块个数
    int i_size; //大小
    time_t i_atime;
    time_t i_ctime;
    time_t i_mtime;
    time_t i_dtime;
    int i_block[8]; //指向数据块的指针
    char i_pad[24];
}ext2_inode;

typedef struct  ext2_dir_entry
{
    int inode;
    int rec_len; //目录项长度
    int name_len; //文件名长度
    int file_type;
    char name[EXT2_NAME_LEN];
    char dir_pad;
}ext2_dir_entry;

ext2_group_desc group_desc;
ext2_inode inode;
ext2_dir_entry dir;
FILE* f;
unsigned int last_alloc_inode=0;
unsigned int last_alloc_block=0;

int getch() //读取键盘输入字符，不回显
{
    int ch;
    struct termios oldt,newt;
    tcgetattr(STDIN_FILENO,&oldt);
    newt=oldt;//保存终端设置
    newt.c_lflag&=~(ECHO|ICANON);//更改终端设置，俄读输入不回显
    tcsetattr(STDIN_FILENO,TCSANOW,&newt);
    ch=getchar();
    tcsetattr(STDIN_FILENO,TCSANOW,&oldt);//恢复终端设置
    return ch;
}

//在当前目录建立一个vdisk文件，模拟磁盘
int format()
{
    FILE* fp=NULL;
    int i;
    unsigned int zero[blocksiz/4];
    time_t now;
    time(&now); //计算当前日历时间，并把它编码成 time_t 格式。
    //初始化整个磁盘里所有块，全0
    while (fp==NULL)
    {
        fp=fopen(PATH,"w+");
    }
    for (i=0;i<blocksiz/4;i++)
    {
        zero[i]=0;
    }
    for (i=0;i<blocks;i++)
    {
        fseek(fp,i*blocksiz,SEEK_SET);
        fwrite(&zero,blocksiz,1,fp);
    }
    //初始化组描述符
    strcpy(group_desc.bg_volumn_name,"user");
    group_desc.bg_block_bitmap=1;
    group_desc.bg_inode_bitmap=2;
    group_desc.bg_inode_table=3;
    group_desc.bg_free_blocks_count=4095;
    group_desc.bg_free_inodes_count=4095;
    group_desc.bg_used_dirs_count=1;
    strcpy(group_desc.psw,"123");
    fseek(fp,0,SEEK_SET);
    fwrite(&group_desc,sizeof(ext2_group_desc),1,fp);
    //初始化索引节点和块的不位图
    zero[0]=0x80000000;
    fseek(fp,1*blocksiz,SEEK_SET);
    fwrite(&zero,blocksiz,1,fp);
    fseek(fp,2*blocksiz,SEEK_SET);
    fwrite(&zero,blocksiz,1,fp);
    //初始化第一个索引节点
    inode.i_mode=2;
    inode.i_blocks=1;
    inode.i_size=64;
    inode.i_ctime=now;
    inode.i_atime=now;
    inode.i_mtime=now;
    inode.i_dtime=0;
    fseek(fp,3*blocksiz,SEEK_SET);
    fwrite(&inode,sizeof(ext2_inode),1,fp);
    //第一个数据块写当前目录
    dir.inode=0;
    dir.rec_len=32;
    dir.name_len=1;
    dir.file_type=2;
    strcpy(dir.name,".");
    fseek(fp,blocksiz*data_begin_block,SEEK_SET);
    fwrite(&dir,sizeof(ext2_dir_entry),1,fp);
    //当前目录块之后 是上一级目录
    dir.inode=0;
    dir.rec_len=32;
    dir.name_len=2;
    dir.file_type=2;
    strcpy(dir.name,"..");
    fseek(fp,blocksiz*data_begin_block+dirsiz,SEEK_SET);
    fwrite(&dir,sizeof(ext2_dir_entry),1,fp);

    fclose(fp);
    return 0;
}

//将一个目录相对数据块的起始址（当前目录）转换为绝对地址
int dir_entry_position(int dir_entry_begin,int i_block[8])
{
    int dir_blocks=dir_entry_begin/512;
    int block_offset=dir_entry_begin%512;
    int a;
    FILE* fp=NULL;
    if (dir_blocks<=6)
    {
        return data_begin_block*blocksiz+i_block[dir_blocks]*blocksiz+block_offset;
    }
    else
    {
        while(fp==NULL)
        {
            fp=fopen(PATH,"r+");
        }
        dir_blocks-=6;
        if (dir_blocks<=128)
        {
            int a;
            fseek(fp,data_begin_block*blocksiz+i_block[6]*blocksiz+dir_blocks*4,SEEK_SET);
            fread(&a,sizeof(int),1,fp);
            return data_begin_block*blocksiz+a*blocksiz+block_offset;
        }
        else
        {
            dir_blocks-=128;
            fseek(fp,data_begin_block*blocksiz+i_block[7]*blocksiz+dir_blocks/128*4,SEEK_SET);
            fread(&a,sizeof(int),1,fp);
            fseek(fp,data_begin_block*blocksiz+a*blocksiz+dir_blocks%128*4,SEEK_SET);
            fread(&a,sizeof(int),1,fp);
            return data_begin_block*blocksiz+a*blocksiz+block_offset;
        }
    }
    fclose(fp);
}
//在当前目录打开一个目录项，current将成为该目录的inode
int Open(ext2_inode* current,char* name)
{
    FILE* fp=NULL;
    int i;
    while (fp==NULL)
    {
        fp=fopen(PATH,"r+");
    }
    for (i=0;i<(current->i_size/32);i++)
    {
        fseek(fp,dir_entry_position(i*32,current->i_block),SEEK_SET);
        fread(&dir,sizeof(ext2_dir_entry),1,fp);
        if (!strcmp(dir.name,name))
        {
            if (dir.file_type==2)
            {
                //如果要打开的三名是目录体，将current指向其inode
                fseek(fp,3*blocksiz+dir.inode*sizeof(ext2_inode),SEEK_SET);
                fread(current,sizeof(ext2_inode),1,fp);
                fclose(fp);
                return 0;
            }
        }
    }
    fclose(fp);
    return 1;
}

int Close(ext2_inode* current)
{
    time_t now;
    ext2_dir_entry bentry;
    FILE* fout;
    fout=fopen(PATH,"r+");
    time(&now);
    current->i_atime=now;
    fseek(fout,(data_begin_block+current->i_block[0]*blocksiz),SEEK_SET);
    fread(&bentry,sizeof(ext2_dir_entry),1,fout);
    fseek(fout,3*blocksiz+(bentry.inode)*sizeof(ext2_inode),SEEK_SET);
    fwrite(current,sizeof(ext2_inode),1,fout);
    fclose(fout);
    return Open(current,"..");
}

int Read(ext2_inode* current,char* name)
{
    FILE* fp=NULL;
    int i;
    while (fp==NULL)
    {
        fp=fopen(PATH,"r+");
    }
    for (i=0;i<(current->i_size/32);i++)
    {
        fseek(fp,dir_entry_position(i*32,current->i_block),SEEK_SET);
        fread(&dir,sizeof(ext2_dir_entry),1,fp);
        if (!strcmp(dir.name,name))
        {
            if (dir.file_type==1)
            {
                time_t now;
                ext2_inode node;
                char content_char;
                fseek(fp,3*blocksiz+dir.inode*sizeof(ext2_inode),SEEK_SET);
                fread(&node,sizeof(ext2_inode),1,fp);
                i=0;
                for (i=0;i<node.i_size;i++)
                {
                    fseek(fp,dir_entry_position(i,node.i_block),SEEK_SET);
                    fread(&content_char,sizeof(char),1,fp);
                    if (content_char==0xD) printf("\n");
                    else printf("%c",content_char);
                }
                printf("\n");
                time(&now);
                node.i_atime=now;
                fseek(fp,3*blocksiz+dir.inode*sizeof(ext2_inode),SEEK_SET);
                fwrite(&node,sizeof(ext2_inode),1,fp);
                fclose(fp);
                return 0;
            }
        }
    }
    fclose(fp);
    return 1;
}
//查找空inode，返回在bitmap中的位置
int FindInode()
{
    FILE* fp=NULL;
    unsigned int zero[blocksiz/4];
    int i;
    while (fp==NULL)
    {
        fp=fopen(PATH,"r+");
    }
    fseek(fp,2*blocksiz,SEEK_SET);
    fread(zero,blocksiz,1,fp);
    for (i=last_alloc_inode;i<(last_alloc_inode+blocksiz/4);i++)
    {
        if (zero[i%(blocksiz/4)]!=0xffffffff)
        {
            unsigned int j=0x80000000,k=zero[i%(blocksiz/4)],l=i;
            for (i=0;i<32;i++)
            {
                if (!(k&j))
                {
                    zero[l%(blocksiz/4)]=zero[l%(blocksiz/4)]|j;
                    group_desc.bg_free_inodes_count-=1;
                    fseek(fp,0,0);
                    fwrite(&group_desc,sizeof(ext2_group_desc),1,fp);
                    fseek(fp,2*blocksiz,SEEK_SET);
                    fwrite(zero,blocksiz,1,fp);
                    last_alloc_inode=l%(blocksiz/4);
                    fclose(fp);
                    return l%(blocksiz/4)*32+i;
                }
                else
                {
                    j=j/2;
                }
            }
        }
    }
    fclose(fp);
    return -1;
}
//查找空block，返回在bitmap中的位置
int FindBlock()
{
    FILE* fp=NULL;
    unsigned int zero[blocksiz/4];
    int i;
    while (fp==NULL)
    {
        fp=fopen(PATH,"r+");
    }
    fseek(fp,1*blocksiz,SEEK_SET);
    fread(zero,blocksiz,1,fp);
    for (i=last_alloc_block;i<(last_alloc_block+blocksiz/4);i++)
    {
        if (zero[i%(blocksiz/4)]!=0xffffffff)
        {
            unsigned int j=0x80000000,k=zero[i%(blocksiz/4)],l=i;
            for (i=0;i<32;i++)
            {
                if (!(k&j))
                {
                    zero[l%(blocksiz/4)]=zero[l%(blocksiz/4)]|j;
                    group_desc.bg_free_blocks_count-=1;
                    fseek(fp,0,0);
                    fwrite(&group_desc,sizeof(ext2_group_desc),1,fp);
                    fseek(fp,1*blocksiz,SEEK_SET);
                    fwrite(zero,blocksiz,1,fp);
                    last_alloc_block=l%(blocksiz/4);
                    fclose(fp);
                    return l%(blocksiz/4)*32+i;
                }
                else
                {
                    j=j/2;
                }
            }
        }
    }
    fclose(fp);
    return -1;
}

void DelInode(int len)
{
    unsigned int zero[blocksiz/4],i;
    int j;
    f=fopen(PATH,"r+");
    fseek(f,2*blocksiz,SEEK_SET);
    fread(zero,blocksiz,1,f);
    i=0x80000000;
    for (j=0;j<len%32;j++)
    {
        i=i/2;
    }
    zero[len/32]=zero[len/32]^i;
    fseek(f,2*blocksiz,SEEK_SET);
    fwrite(zero,blocksiz,1,f);
    fclose(f);
}

void DelBlock(int len)
{
    unsigned int zero[blocksiz/4],i;
    int j;
    f=fopen(PATH,"r+");
    fseek(f,1*blocksiz,SEEK_SET);
    fread(zero,blocksiz,1,f);
    i=0x80000000;
    for (j=0;j<len%32;j++)
    {
        i=i/2;
    }
    zero[len/32]=zero[len/32]^i;
    fseek(f,1*blocksiz,SEEK_SET);
    fwrite(zero,blocksiz,1,f);
    fclose(f);
}

void add_block(ext2_inode* current,int i,int j)
{
    FILE* fp=NULL;
    while (fp==NULL)
    {
        fp=fopen(PATH,"r+");
    }
        if (i<6)
        {
            current->i_block[i]=j;
        }
        else
        {
            i-=6;
            if (i==0)
            {
                current->i_block[6]==FindBlock();
                fseek(fp,data_begin_block*blocksiz+current->i_block[6]*blocksiz,SEEK_SET);
                fwrite(&j,sizeof(int),1,fp);
            }
            else if (i<128)
            {
                fseek(fp,data_begin_block*blocksiz+current->i_block[6]*blocksiz+i*4,SEEK_SET);
                fwrite(&j,sizeof(int),1,fp);
            }
            else
            {
                i-=128;
                if (i==0)
                {
                    current->i_block[7]=FindBlock();
                    fseek(fp,data_begin_block*blocksiz+current->i_block[7]*blocksiz,SEEK_SET);
                    i=FindBlock();
                    fwrite(&i,sizeof(int),1,fp);
                    fseek(fp,data_begin_block*blocksiz+i*blocksiz,SEEK_SET);
                    fwrite(&j,sizeof(int),1,fp);
                }
                if (i%128==0)
                {
                    fseek(fp,data_begin_block*blocksiz+current->i_block[7]*blocksiz+i/128*4,SEEK_SET);
                    i=FindBlock();
                    fwrite(&i,sizeof(int),1,fp);
                    fseek(fp,data_begin_block*blocksiz+i*blocksiz,SEEK_SET);
                    fwrite(&j,sizeof(int),1,fp);
                }
                else
                {
                    fseek(fp,data_begin_block*blocksiz+current->i_block[7]*blocksiz+i/128*4,SEEK_SET);
                    fread(&i,sizeof(int),1,fp);
                    fseek(fp,data_begin_block*blocksiz+i*blocksiz+i%128*4,SEEK_SET);
                    fwrite(&j,sizeof(int),1,fp);
                }
            }
        }
    
}


//存疑
int FindEntry(ext2_inode* current)
{
    FILE* fout=NULL;
    int location;
    int block_location;
    int temp;
    int remain_block;
    location=data_begin_block*blocksiz;
    temp=blocksiz/sizeof(int);
    fout=fopen(PATH,"r+");
    if (current->i_size%blocksiz==0)
    {
        add_block(current,current->i_blocks,FindBlock());
        current->i_blocks++;
    }
    if (current->i_blocks<6)
    {
        location+=current->i_block[current->i_blocks-1]*blocksiz;
        location+=current->i_size%blocksiz;
    }
    else if (current->i_blocks<temp+5)
    {
        block_location=current->i_block[6];
        fseek(fout,(data_begin_block+block_location)*blocksiz+(current->i_blocks-6)*sizeof(int),SEEK_SET);
        fread(&block_location,sizeof(int),1,fout);
        location+=block_location*blocksiz;
        location+=current->i_size%blocksiz;
    }
    else
    {
        block_location=current->i_block[7];
        remain_block=current->i_blocks-6-temp;
        fseek(fout,(data_begin_block+block_location)*blocksiz+(int)((remain_block-1)/temp+1)*sizeof(int),SEEK_SET);
        fread(&block_location,sizeof(int),1,fout);
        remain_block=remain_block%temp;
        fseek(fout,(data_begin_block+block_location)*blocksiz+remain_block*sizeof(int),SEEK_SET);
        fread(&block_location,sizeof(int),1,fout);
        location+=block_location*blocksiz;
        location+=current->i_size%blocksiz+dirsiz;
    }
    current->i_size+=dirsiz;
    fclose(fout);
    return location;
}

int Create(int type,ext2_inode* current,char* name)
{
    FILE* fout=NULL;
    int i;
    int block_location;
    int node_location;
    int dir_entry_location;

    time_t now;
    ext2_inode ainode;
    ext2_dir_entry aentry,bentry;
    time(&now);
    fout=fopen(PATH,"r+");
    node_location=FindInode();
    for (i=0;i<current->i_size/dirsiz;i++)
    {
        fseek(fout,dir_entry_position(i*sizeof(ext2_dir_entry),current->i_block),SEEK_SET);
        fread(&aentry,sizeof(ext2_dir_entry),1,fout);
        if (aentry.file_type==type&&!strcmp(aentry.name,name)) return 1;
    }
    fseek(fout,(data_begin_block+current->i_block[0])*blocksiz,SEEK_SET);
    fread(&bentry,sizeof(ext2_dir_entry),1,fout);
    if (type==1)
    {
        ainode.i_mode=1;
        ainode.i_blocks=0;
        ainode.i_size=0;
        ainode.i_ctime=now;
        ainode.i_atime=now;
        ainode.i_mtime=now;
        ainode.i_dtime=0;
        for (i=0;i<8;i++) ainode.i_block[i]=0;
        for (i=0;i<24;i++) ainode.i_pad[i]=0;
    }
    else
    {
        ainode.i_mode=2;
        ainode.i_blocks=1;
        ainode.i_size=64;
        ainode.i_ctime=now;
        ainode.i_atime=now;
        ainode.i_mtime=now;
        ainode.i_dtime=0;
        block_location=FindBlock();
        ainode.i_block[0]=block_location;
        for (i=1;i<8;i++) ainode.i_block[i]=0;
        for (i=0;i<24;i++) ainode.i_pad[i]=(char)(0xff);
        aentry.inode=node_location;
        aentry.rec_len=sizeof(ext2_dir_entry);
        aentry.name_len=1;
        aentry.file_type=2;
        strcpy(aentry.name,".");
        aentry.dir_pad=0;
        fseek(fout,(data_begin_block+block_location)*blocksiz,SEEK_SET);
        fwrite(&aentry,sizeof(ext2_dir_entry),1,fout);
        aentry.inode=bentry.inode;
        aentry.rec_len=sizeof(ext2_dir_entry);
        aentry.name_len=2;
        aentry.file_type=2;
        strcpy(aentry.name,"..");
        aentry.dir_pad=0;
        fwrite(&aentry,sizeof(ext2_dir_entry),1,fout);
        aentry.inode=0;
        aentry.rec_len=sizeof(ext2_dir_entry);
        aentry.name_len=0;
        aentry.file_type=0;
        aentry.name[EXT2_NAME_LEN]=0;
        aentry.dir_pad=0;
        fwrite(&aentry,sizeof(ext2_dir_entry),14,fout);
    }
    fseek(fout,3*blocksiz+(node_location)*sizeof(ext2_inode),SEEK_SET);
    fwrite(&ainode,sizeof(ext2_inode),1,fout);
    aentry.inode=node_location;
    aentry.rec_len=dirsiz;
    aentry.name_len=strlen(name);
    if (type==1) aentry.file_type=1;
    else aentry.file_type=2;
    strcpy(aentry.name,name);
    aentry.dir_pad=0;
    dir_entry_location=FindEntry(current);
    fseek(fout,dir_entry_location,SEEK_SET);
    fwrite(&aentry,sizeof(ext2_dir_entry),1,fout);
    fseek(fout,3*blocksiz+(bentry.inode)*sizeof(ext2_inode),SEEK_SET);
    //printf("When create,size:%d\n",current->i_size);
    fwrite(current,sizeof(ext2_inode),1,fout);
    fclose(fout);
    return 0;
}

int Write(ext2_inode* current,char* name)
{
    FILE* fp=NULL;
    ext2_dir_entry dir;
    ext2_inode node;
    time_t now;
    char str;
    int i;
    while (fp==NULL)
    {
        fp=fopen(PATH,"r+");
    }
    while (1)
    {
        for (i=0;i<(current->i_size/32);i++)
        {
            fseek(fp,dir_entry_position(i*32,current->i_block),SEEK_SET);
            fread(&dir,sizeof(ext2_dir_entry),1,fp);
            if (!strcmp(dir.name,name))
            {
                if (dir.file_type==1)
                {
                    fseek(fp,3*blocksiz+dir.inode*sizeof(ext2_inode),SEEK_SET);
                    fread(&node,sizeof(ext2_inode),1,fp);

                    break;
                }
            }
        }
        if (i<current->i_size/32)
        {
            break;
        }
        //Create(1,current,name);
        printf("There is not such a file,creaate it first.\n");
        return 0;
    }
    str=getch();
    while (str!=27)
    {
        printf("%c",str);
        if (!(node.i_size%512))
        {
            add_block(&node,node.i_size/512,FindBlock());
            node.i_blocks+=1; 
        }
        fseek(fp,dir_entry_position(node.i_size,node.i_block),SEEK_SET);
        fwrite(&str,sizeof(char),1,fp);
        node.i_size+=sizeof(char);
        if (str==0x0d) printf("%c",0x0a);
        str=getch();
        if (str==27) break;
    }
    time(&now);
    node.i_mtime=now;
    node.i_atime=now;
    fseek(fp,3*blocksiz+dir.inode*sizeof(ext2_inode),SEEK_SET);
    fwrite(&node,sizeof(ext2_inode),1,fp);
    fclose(fp);
    printf("\n");
    return 0;
}

void Ls(ext2_inode* current)
{
    ext2_dir_entry dir;
    int i,j;
    char timestr[150];
    ext2_inode node;
    f=fopen(PATH,"r+");
    printf("Type\tFileName\tCreateTime\tLastAccessTime\tModifyTime\n");
    for (int i=0;i<(current->i_size/32);i++)
    {
        fseek(f,dir_entry_position(i*32,current->i_block),SEEK_SET);
        fread(&dir,sizeof(ext2_dir_entry),1,f);
        fseek(f,3*blocksiz+dir.inode*sizeof(ext2_inode),SEEK_SET);
        fread(&node,sizeof(ext2_inode),1,f);
        strcpy(timestr," ");
        strcat(timestr,asctime(localtime(&node.i_ctime)));
        strcat(timestr,asctime(localtime(&node.i_atime)));
        strcat(timestr,asctime(localtime(&node.i_mtime)));
        for (j=0;j<strlen(timestr)-1;j++)
        {
            if (timestr[j]=='\n') timestr[j]='\t';
        }
        if (dir.file_type==1) printf("File %s\t%s",dir.name,timestr);
        else printf("Directory %s\t%s",dir.name,timestr);
        
    }
    fclose(f);
}

int initialize(ext2_inode* cu)
{
    f=fopen(PATH,"r+");
    fseek(f,3*blocksiz,0);
    fread(cu,sizeof(ext2_inode),1,f);
    fclose(f);
    return 0;
}

int Password()
{
    char psw[16],ch[0],new[16];
    printf("Input old password:\n");
    scanf("%s",psw);
    if (strcmp(psw,group_desc.psw)!=0)
    {
        printf("Password erreo.\n");
        return 1;
    }
    while (1)
    {
        printf("Input new password:\n");
        scanf("%s",new);
        while (1)
        {
            printf("Modify passworld?[Y/N]");
            scanf("%s",ch);
            if (ch[0]=='N'||ch[0]=='n')
            {
                printf("Cancel.\n");
                return 1;
            }
            else if(ch[0]=='Y'||ch[0]=='y')
            {
                strcpy(group_desc.psw,new);
                f=fopen(PATH,"r+");
                fseek(f,0,0);
                fwrite(&group_desc,sizeof(ext2_group_desc),1,f);
                fclose(f);
                return 0;
            }
            else printf("Meaningless command.\n");
        }
    }
    
}
//登陆 无bug
int login()
{
    char psw[16];
    printf("Input password(init:123):");
    scanf("%s",psw);
    return strcmp(group_desc.psw,psw);
}

void exitdisplay()
{
    printf("bye~\n");
    return ;
}

int initfs(ext2_inode* cu)
{
    f=fopen(PATH,"r+");
    if (f==NULL)
    {
        char ch;
        int i;
        printf("File system:Not Found.Create one?\n[Y/N]");
        i=1;
        while(i)
        {
            scanf("%c",&ch);
            switch ((ch))
            {
            case 'Y':
            case 'y':
                if (format()!=0) return 1;
                f=fopen(PATH,"r");
                i=0;
                break;
            case 'N':
            case 'n':
                exitdisplay();
                return 1;    
            default:
                printf("Meaningless command.\n");
                break;
            }
        }
    }
    fseek(f,0,SEEK_SET);
    fread(&group_desc,sizeof(ext2_group_desc),1,f);
    fseek(f,3*blocksiz,SEEK_SET);
    fread(&inode,sizeof(ext2_inode),1,f);
    fclose(f);
    initialize(cu);
    return 0;
}

//获得当前目录名
void getstring(char* cs,ext2_inode node)
{
    ext2_inode current=node;
    int i,j;
    ext2_dir_entry dir;
    f=fopen(PATH,"r+");
    Open(&current,"..");
    for (i=0;i<node.i_size/32;i++)
    {
        fseek(f,dir_entry_position(i*32,node.i_block),SEEK_SET);
        fread(&dir,sizeof(ext2_dir_entry),1,f);
        if (!strcmp(dir.name,"."))
        {
            j=dir.inode;
            break;
        }
    }
    for (i=0;i<current.i_size/32;i++)
    {
        fseek(f,dir_entry_position(i*32,current.i_block),SEEK_SET);
        fread(&dir,sizeof(ext2_dir_entry),1,f);
        if (dir.inode==j)
        {
            strcpy(cs,dir.name);
            return;
        }
    }
}

int Delet(int type,ext2_inode* current,char* name)
{
    FILE* fout=NULL;
    int i,j,k,t,flag;
    int Blocation2,Blocation3;
    int node_location,dir_entry_location,block_location;
    int block_location2,block_location3;
    ext2_inode cinode;
    ext2_dir_entry bentry,centry,dentry;
    dentry.inode=0;
    dentry.rec_len=sizeof(ext2_dir_entry);
    dentry.name_len=0;
    dentry.file_type=0;
    strcpy(dentry.name,"");
    dentry.dir_pad=0;
    fout=fopen(PATH,"r+");
    t=(int)(current->i_size/dirsiz);
    flag=0;
    fseek(fout,(data_begin_block+current->i_block[0])*blocksiz,SEEK_SET);
    fread(&bentry,dirsiz,1,fout);
    //printf("When delete,inode:%d\n",bentry.inode);
    for (i=0;i<t;i++)
    {
        dir_entry_location=dir_entry_position(i*dirsiz,current->i_block);
        fseek(fout,dir_entry_location,SEEK_SET);
        fread(&centry,sizeof(ext2_dir_entry),1,fout);
        if ((strcmp(centry.name,name))==0&&(centry.file_type==type))
        {
            flag=1;
            j=i;
            break;
        }

    }
    if (flag)
    {
        node_location=centry.inode;
        fseek(fout,3*blocksiz+node_location*sizeof(ext2_inode),SEEK_SET);
        fread(&cinode,sizeof(ext2_inode),1,fout);
        block_location=cinode.i_block[0];
        if (type==2) //删除目录
        {
            if (cinode.i_size>2*dirsiz) 
            {
                printf("The folder is not empty.\n");
                return 1;
            }
            else //目录已空
            {
                DelBlock(block_location);
                DelInode(node_location);
                dir_entry_location=dir_entry_position(current->i_size-dirsiz,current->i_block);
                fseek(fout,dir_entry_location,SEEK_SET);
                fread(&centry,dirsiz,1,fout);
                fseek(fout,dir_entry_location,SEEK_SET);
                fwrite(&dentry,dirsiz,1,fout);
                dir_entry_location-=data_begin_block*blocksiz;
                if (dir_entry_location%blocksiz==0)
                {
                    DelBlock((int)(dir_entry_location/blocksiz));
                    current->i_blocks--;
                    if (current->i_blocks==6) DelBlock(current->i_block[6]);
                    else if (current->i_blocks==(blocksiz/sizeof(int)+6))
                    {
                        int a;
                        fseek(fout,data_begin_block*blocksiz+current->i_block[7]*blocksiz,SEEK_SET);
                        fread(&a,sizeof(int),1,fout);
                        DelBlock(a);
                        DelBlock(current->i_block[7]);
                    }
                    else if (!((current->i_blocks-6-blocksiz/sizeof(int))%(blocksiz/sizeof(int))))
                    {
                        int a;
                        fseek(fout,data_begin_block*blocksiz+current->i_block[7]*blocksiz+
                            ((current->i_blocks-6-blocksiz/sizeof(int))/(blocksiz/sizeof(int))),SEEK_SET);
                        fread(&a,sizeof(int),1,fout);
                        DelBlock(a);
                    }
                }
                current->i_size-=dirsiz;
                //printf("%d\n",current->i_size);
                if (j*dirsiz<current->i_size-dirsiz)
                {
                    dir_entry_location=dir_entry_position(j*dirsiz,current->i_block);
                    fseek(fout,dir_entry_location,SEEK_SET);
                    fwrite(&centry,dirsiz,1,fout);
                }
                printf("%s has been deleted.\n",name);
            }
        }
        else //删除文件
        {
            for (i=0;i<6;i++)
            {
                if (cinode.i_blocks==0) break;
                block_location=cinode.i_block[i];
                DelBlock(block_location);
                cinode.i_blocks--;
            }
            if (cinode.i_blocks>0)
            {
                block_location=cinode.i_block[6];
                fseek(fout,(data_begin_block+block_location)*blocksiz,SEEK_SET);
                for (i=0;i<blocksiz/sizeof(int);i++)
                {
                    if (cinode.i_blocks==0) break;
                    fread(&Blocation2,sizeof(int),1,fout);
                    DelBlock(Blocation2);
                    cinode.i_blocks--;
                }
                DelBlock(block_location);
            }
            if (cinode.i_blocks>0)
            {
                block_location=cinode.i_block[7];
                for (i=0;i<blocksiz/sizeof(int);i++)
                {
                    fseek(fout,(data_begin_block+block_location)*blocksiz+i*sizeof(int),SEEK_SET);
                    fread(&Blocation2,sizeof(int),1,fout);
                    fseek(fout,(data_begin_block+Blocation2)*blocksiz,SEEK_SET);
                    for (k=0;k<blocksiz/sizeof(int);k++)
                    {
                        if (cinode.i_blocks==0) break;
                        fread(&Blocation3,sizeof(int),1,fout);
                        DelBlock(Blocation3);
                        cinode.i_blocks--;
                    }
                    DelBlock(Blocation2);
                }
                DelBlock(block_location);
            }
            DelInode(node_location);
            dir_entry_location=dir_entry_position(current->i_size-dirsiz,current->i_block);
            fseek(fout,dir_entry_location,SEEK_SET);
            fread(&centry,dirsiz,1,fout);
            fseek(fout,dir_entry_location,SEEK_SET);
            fwrite(&dentry,dirsiz,1,fout);
            dir_entry_location-=data_begin_block*blocksiz;
            if (dir_entry_location%blocksiz==0)
            {
                DelBlock((int)(dir_entry_location/blocksiz));
                current->i_blocks--;
                if (current->i_blocks==6) DelBlock(current->i_block[6]);
                else if (current->i_blocks==(blocksiz/sizeof(int)+6))
                {
                    int a;
                    fseek(fout,data_begin_block*blocksiz+current->i_block[7]*blocksiz,SEEK_SET);
                    fread(&a,sizeof(int),1,fout);
                    DelBlock(a);
                    DelBlock(current->i_block[7]);
                }
                else if (!((current->i_blocks-6-blocksiz/sizeof(int))%(blocksiz/sizeof(int))))
                {
                    int a;
                    fseek(fout,data_begin_block*blocksiz+current->i_block[7]*blocksiz+
                        ((current->i_blocks-6-blocksiz/sizeof(int))/(blocksiz/sizeof(int))),SEEK_SET);
                    fread(&a,sizeof(int),1,fout);
                    DelBlock(a);
                }
            }
            current->i_size-=dirsiz;
            if (j*dirsiz<current->i_size)
            {
                dir_entry_location=dir_entry_position(j*dirsiz,current->i_block);
                fseek(fout,dir_entry_location,SEEK_SET);
                fwrite(&centry,dirsiz,1,fout);
            }

        }
        fseek(fout,(data_begin_block+current->i_block[0])*blocksiz,SEEK_SET);
        fread(&bentry,dirsiz,1,fout);
        //printf("When delete,inode:%d\n",bentry.inode);
        fseek(fout,3*blocksiz+(bentry.inode)*sizeof(ext2_inode),SEEK_SET);
        //printf("%d\n",current->i_size);
        fwrite(current,sizeof(ext2_inode),1,fout);
    }
    else
    {
        fclose(fout);
        return 1;
    }
    fclose(fout);
    return 0;
}

void shellloop(ext2_inode currentdir)
{
    char command[10],var1[10],var2[100],var3[128],path[100];
    ext2_inode temp;
    int i,j;
    char currentsting[20];
    char ctable[12][10]={"create","delete","cd","close","read","write",
    "password","format","exit","login","logout","ls"};
    while (1)
    {
        getstring(currentsting,currentdir);
        printf("\n%s=>#",currentsting);
        scanf("%s",command);
        for (i=0;i<12;i++)
        {
            if (!strcmp(command,ctable[i])) break;
        }
            if (i==0||i==1)
            {
                scanf("%s",var1);
                scanf("%s",var2);
                if (var1[0]=='f') j=1;
                else if (var1[0]=='d') j=2;
                else
                {
                    printf("The first variant must be [f/d]");
                    continue;
                }
                if (i==0)
                {
                    if (Create(j,&currentdir,var2)==1) printf("%s faild to create.\n",var2);
                    else printf("%s created.\n",var2);
                }
                else 
                {
                    if (Delet(j,&currentdir,var2)==1)
                    {
                        printf("%s failed to delete.\n",var2);
                    }
                    else 
                    {
                        printf("%s deleted.\n",var2);
                    }
                } 
            }
            else if (i==2)
            {
                scanf("%s",var2);
                i=0;j=0;
                temp=currentdir;
                while ((1))
                {
                    path[i]=var2[j];
                    if (path[i]=='/')
                    {
                        if (j==0) initialize(&currentdir);
                        else if (i==0)
                        {
                            printf("Path input error.\n");
                            break;
                        }
                        else
                        {
                            path[i]='\0';
                            if (Open(&currentdir,path)==1)
                            {
                                printf("Path input error.\n");
                                currentdir=temp;
                            }
                        }
                        i=0;
                    }
                    else if (path[i]=='\0')
                    {
                        if (i==0) break;
                        if (Open(&currentdir,path)==1)
                        {
                            printf("Path input error.\n");
                            currentdir=temp;
                        }
                        break;
                    }
                    else i++;
                    j++;
                }
            }
            else if (i==3)
            {
                scanf("%d",&i);
                for (j=0;j<i;j++)
                {
                    if (Close(&currentdir)==1)
                    {
                        printf("Warning:%d is too large.\n",i);
                        break;
                    }
                }
            }
            else if (i==4)
            {
                scanf("%s",var2);
                if (Read(&currentdir,var2)==1)
                {
                    printf("Failed:can't read.\n");
                }
            }
            else if (i==5)
            {
                scanf("%s",var2);
                if (Write(&currentdir,var2)==1)
                {
                    printf("Failed:can't write.\n");
                }
            }
            else if (i==6)
            {
                Password();
            }
            else if (i==7)
            {
                while (1)
                {
                    printf("Do you want to format the filesystem?\nIt will be dangerous.\n");
                    printf("[Y/N]");
                    scanf("%s",var1);
                    if (var1[0]=='N'||var1[0]=='n') break;
                    else if (var1[0]=='Y'||var1[0]=='y')
                    {
                        format();
                        break;
                    }
                    else printf("Input [Y/N]");
                }
                
            }
            else if (i==8)
            {
                while (1)
                {
                    printf("Do you want to exit from filesystem?[Y/N]");
                    scanf("%s",var2);
                    if (var2[0]=='N'||var2[0]=='n') break;
                    else if (var2[0]=='Y'||var2[0]=='y') return;
                    else printf("Input [Y/N]");
                }
                
            }        
            else if (i==9)
            {
                printf("Failed:You havn't logged out.\n");
            }
            else if (i==10)
            {
                while (i)
                {
                    printf("Do you want to log out?[Y/N]");
                    scanf("%s",var1);
                    if (var1[0]=='N'||var1[0]=='n') break;
                    else if (var1[0]=='Y'||var1[0]=='y')
                    {
                        initialize(&currentdir);
                        while (1)
                        {
                            printf("$$$$=>#");
                            scanf("%s",var2);
                            if (strcmp(var2,"login")==0)
                            {
                                if (login()==0)
                                {
                                    i=0;
                                    break;
                                }
                            }
                            else if (strcmp(var2,"exit")==0) return;
                            else printf("Inpur [Y/N]");
                        }
                        
                    }
                }
                
            }
            else if (i==11)
            {
                Ls(&currentdir);
            }
            else printf("Failed:invalid command.\n");        
    }
}

int main()
{
    ext2_inode cu;
    printf("Welcome!\n");
    if (initfs(&cu)==1) return 0;
    if (login()!=0)
    {
        printf("Incorrect password.It will terminate right away.");
        exitdisplay();
        return 0;
    }
    shellloop(cu);
    exitdisplay();
    return 0;
}