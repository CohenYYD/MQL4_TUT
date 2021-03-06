//+------------------------------------------------------------------+
//|                                                   架构与变量.mq4 |
//+------------------------------------------------------------------+
#property copyright "shiyingpan"
#property link      "https://aijy.github.io"
#property version   "1.00"
#property strict

//-- 以下按照1,2,3,4的顺序执行代码

//--- 1.全局变量和常量定义区域
input double 首单单量=1.0; //-- 输入变量输入变量
double 次单单量=0;
int cnt=0;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {

//--- 2.初始化参数区域，只执行一次，此处失败，程序自动卸载
   if(首单单量>1)
     {
      return(INIT_FAILED);
     }
   次单单量 = 首单单量*2;
   Print("初试化完成，首单单量是：",首单单量," 次单单量是：",次单单量);
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- 4.程序卸载时执行一次，一般为空
   Print("程序卸载");
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//--- 3.币种图表，每次报价时执行一次，无限循环
   cnt = cnt+1;
   PrintFormat("程序正在执行。当前时间：%s,当前为第%d次执行",TimeToStr(TimeCurrent(),TIME_DATE|TIME_MINUTES|TIME_SECONDS),cnt);
  }
//+------------------------------------------------------------------+
