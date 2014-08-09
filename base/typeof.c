//#include<stdio.h>
#include<iostream>
#include <typeinfo>
using namespace std;
#define max(a,b) \
    ({ typeof (a) _a = (a); \
     typeof (b) _b = (b); \
     _a > _b ? _a : _b; })

int foo()
{
    return 0;
}
typedef int(*fun)();
int main()
{
    int a = 10, b = 11;

    int m=max(a,b);
    //printf("max\t%d\n",xxxxxx);
    cout<<"max\t"<<m<<endl;

    
    
    double x[1];
    fun f = foo;

    cout<<"typeid\t"<<typeid(a).name()<<endl;
   cout<<"typeof(x[0](1)\t"<<typeid(typeof(f)).name()<<endl;
    //cout<<"typeof(foo()\t"<<typeid(typeof(foo()).name()<<endl;
    return 0;
}


