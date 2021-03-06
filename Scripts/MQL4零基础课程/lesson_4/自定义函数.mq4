/*----函数的基本结构-----//
返回值类型 函数名(参数类型 参数定义,参数类型 参数定义)
{
   函数主体，执行特定功能
}
*/
#property copyright "shiyingpan"
#property link      "https://aijy.github.io"
#property version   "1.00"
#property strict
#define N 10 
int sum = 0 ; //-- 全局变量，任何地方都可调用。全局变量和局部变量名不要相同，以免混淆
int sum_array[N]; //-- 数组放多个数据，主要与循环配合使用,数组长度必须固定
//+------------------------------------------------------------------+
//| OnStart()也是一个函数，并且没有返回值                                   |
//+------------------------------------------------------------------+
void OnStart()
  {
   Acc_check(); //---没有参数
   int a=1,b=2,c=3,res;
   res = add(a,b,c,4);//---有4个参数，与函数定义需一一对应
   Print("res:",res);
   sum = res;
   display();
  }
  
void Acc_check()
{
   if(!IsDemo())
   {
      Alert("非模拟账户，请谨慎操作！");
   }   
   return;
}

int add(int aa,int bb,int cc,int dd) //-- aa,bb,cc,dd 是形式参数，传进来的值是真实参数
{
   int r=0;           //-- 局部变量，只在函数内起作用
   r=aa+bb+cc+dd;
   return r;
}

void display()
{
   Print("sum值是：",sum);
   //Print("r值是：",r);
   for(int i =0;i<N;i++)
   {
      sum_array[i]=sum+1;
      PrintFormat("sum_array[%d]值是：%d",i,sum_array[i]);
   }
}