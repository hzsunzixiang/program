
#include "flist.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>


struct student  //代表一个实际节点的结构  
{  
    char name[100];  
    int num;  
    struct flist_head list;   //内核链表里的节点结构  
};  

// 打印一个student
void print(struct student *s){
    printf("name:\t%s,num:\t%d\n",s->name,s->num);
}
// 链表是这样定义的
//struct flist_head {
//    struct flist_head *next, *prev;
//};


/** 下面演示如何初始化一个链表
  定义的宏结构如下:
  两种效果完全一样，第一种是第二种的简化形式
#define FLIST_HEAD_INIT(name) { &(name), &(name) }
#define FLIST_HEAD(name) \
struct flist_head name = FLIST_HEAD_INIT(name)
 */

// 都是声明了一个链表,其实是声明了一个链表头,一个变量
// 都是在声明的时候就进行初始化
FLIST_HEAD(student_list);
struct flist_head student_list1= FLIST_HEAD_INIT(student_list1);
// 预编译之后

// struct flist_head student_list = { &(student_list), &(student_list) };
// struct flist_head student_list1= { &(student_list1), &(student_list1) };


/**
  除了用FLIST_HEAD()宏在声明的时候初始化一个链表以外，Linux还提供了一个INIT_LIST_HEAD宏用于运行时初始化链表：
  说白了，就是声明和初始化可以分开
#define INIT_FLIST_HEAD(ptr) do { \
(ptr)->next = (ptr); (ptr)->prev = (ptr); \
} while (0)
 */
// 先声明
struct flist_head student_list2;    
// 再初始化, ,挪到程序中，函数外只能声明，不能有执行语句的
//INIT_FLIST_HEAD(&student_list2);

//struct flist_head student_list2;
//do { 
//    (&student_list2)->next = (&student_list2); 
//    (&student_list2)->prev = (&student_list2); 
//} while (0);

//Linux用头指针的next是否指向自己来判断链表是否为空：
// 这是一个内联函数，参数为指针
//static inline int flist_empty(const struct flist_head *head)
//{
//    return head->next == head;
//}


int main(){

    // student_list2已经声明，这里初始化
    INIT_FLIST_HEAD(&student_list2);
    int empty = flist_empty(&student_list2);
    if(empty){
        printf("empty\n");
    }else{
        printf("not empty\n");
    }
    //对链表的插入操作有两种：在表头插入和在表尾插入。Linux为此提供了两个接口：
    //static inline void list_add(struct list_head *new, struct list_head *head);
    //static inline void list_add_tail(struct list_head *new, struct list_head *head);

    // 声明一个 student 

    struct student* s = (struct student* ) malloc(sizeof (struct student));
    memcpy (s->name, "hello", 6);
    s->num = 12;
    print(s);
    // 把s插入到链表student_list中
    flist_add( &(s->list), &student_list);//参数1是要插入的节点地址，参数2是链表头地址 
    struct flist_head *pos;  
    struct student *tmp_student;  
    flist_for_each(pos,&student_list) //list_for_each用来遍历链表，这是个宏定义  
    {  
        //flist_entry用来提取出内核链表节点对应的实际结构节点，即根据struct list_head来提取struct student  
        //第三个参数list就是student结构定义里的属性list  
        //list_entry的原理有点复杂，也是linux内核的一个经典实现，这个在上面那篇链接文章里也有讲解  
        tmp_student = flist_entry(pos,struct student,list);  
        /**
          预编译之后
        http://gcc.gnu.org/onlinedocs/gcc/Typeof.html
        tmp_student = 
        ({
            const typeof( ((struct student *)0)->list ) *__mptr = (pos);
            (struct student *)( (char *)__mptr -      ((size_t) &((struct student *)0)->list) );
        });

        */
        //打印一些信息，以备验证结果  
        print(tmp_student);
        //printf(typeof( ((struct student *)0)->list ) );
        //const typeof( ((struct student *)0)->list ) *__mptr = (pos);
        int x = (size_t) &((struct student *)0)->list;
        printf("offset list:%d\n",x);
        int y = (size_t) &tmp_student->list;
        printf("offset list:%d\n",y);
        printf("offset list:%d\n",tmp_student);
    }  
    return 0;
}

