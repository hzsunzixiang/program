
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
    struct student* s1 = (struct student* ) malloc(sizeof (struct student));
    memcpy (s1->name, "world", 6);
    s1->num = 18;
    // 把s等插入到链表student_list中
    flist_add( &(s->list), &student_list);//参数1是要插入的节点地址，参数2是链表头地址 
    flist_add( &(s1->list), &student_list);//参数1是要插入的节点地址，参数2是链表头地址 
    struct flist_head *pos;  
    struct student *tmp_student;  
    flist_for_each(pos,&student_list) //list_for_each用来遍历链表，这是个宏定义  
    {  
        tmp_student = flist_entry(pos,struct student,list);  
        print(tmp_student);
    }  
    /**
     * flist_for_each_safe  -   iterate over a list safe against removal of list entry
     * @pos:    the &struct flist_head to use as a loop counter.
     * @n:      another &struct flist_head to use as temporary storage
     * @head:   the head for your list.
     */
    //#define flist_for_each_safe(pos, n, head) \
    //for (pos = (head)->next, n = pos->next; pos != (head); \
    //        pos = n, n = pos->next)

    //      for (pos = (&student_list)->next, n = pos->next; pos != (&student_list); pos = n, n = pos->next)
    //           {
    //             tmp_student = ({ const typeof( ((struct student *)0)->list ) *__mptr = (pos); (struct student *)( (char *)__mptr-((size_t) &((struct student *)0)->list) );});
    //               print(tmp_student);
    //           }
    //

    struct flist_head  *n;
    printf("list safe\n");
    flist_for_each_safe(pos, n, &student_list)
    {
        tmp_student = flist_entry(pos,struct student,list);  
        print(tmp_student);
    }  

    return 0;
}

