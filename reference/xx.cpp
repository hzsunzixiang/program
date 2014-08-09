
#include<iostream>
using namespace std;

class testb{
    public: int y;
};
class test{

    public: int x;
    public: testb b;
};
int ttt;
int ttt1=100;
int  main()
{
    test a =test(); 
    test *uuuuuuuu =new test(); 
    test vvvvvvvv =test(); 
    sizeof(a);

    a.x=10;
    a.b.y=100;

    test b=a;

    b.x=11;
    b.b.y=111;

    cout<<"a.x\t"<<a.x<<"\t\t"<<"b.x"<<b.x<<endl;
    cout<<"a.x\t"<<a.b.y<<"\t\t"<<"b.x"<<b.b.y<<endl;
    return 0;
}
