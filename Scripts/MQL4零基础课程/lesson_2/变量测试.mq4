#property copyright "shiyingpan"
#property link      "https://aijy.github.io"
#property version   "1.00"
#property strict

#define N 10
int a=10,b=20,c;
//double a=10,b=20,c;
bool mybool;//--true,false
datetime time;

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   string name="N的值是：";
   Print(name,N);
   
   c=a+b;
   Print("a+b的值是：",c);
   c=a*b;
   Print("a*b的值是：",c);
   c=a/b;
   Print("a/b的值是：",c);
   a=12;
   b=7;
   c=a%b;
   Print("a%b的值是：",c);
   
   
   if(a>b)
   {
      Print("a是大于b的",a>b);
   }
   else
   {
      Print("a是不大于b的",a<=b); //a<=b的结果是true
   }
   
   time=TimeCurrent();
   Print("当前时间是：",time);
   
   if(a==10)
   {
      Print("对了，a=10");
   }
   else
   {
      Print("错了，a=",a);
   }
   
   if(b!=10)
   {
      Print("对了，b不等于10");
   }
   else
   {
      Print("错了，b=",b);
   }  
   
   mybool=false;
   
   if(!mybool)
   {
      Print("我是真的");
   }
   
   if(a>10 && b<7)//--逻辑与
   {
      Print("满足条件");
   }
   else
   {
      Print("不满足条件");
   }
   
   if(a>10 || b<7)//--逻辑或
   {
      Print("X满足条件");
   }
   else
   {
      Print("X不满足条件");
   }  
  }
//+------------------------------------------------------------------+
