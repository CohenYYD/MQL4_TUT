//+------------------------------------------------------------------+
//|                                                      ProjectName |
//|                                      Copyright 2018, CompanyName |
//|                                       http://www.companyname.net |
//+------------------------------------------------------------------+
#property copyright "shiyingpan"
#property link      "https://aijy.github.com"
#property version   "1.00"
#property strict


double init_capital=0; //-- 初始资金变量
double max_loss_percent=15; //-- 净值最大亏损比例
int magic_num=123;
double max_volume=1;
datetime candle_time=0;
double global_a=0;
int OnInit()
  {
//--1.确保账户正常登陆,未登陆等到一秒再判断
   while(AccountNumber()==0)
      Sleep(1000);
   init_capital = AccountEquity(); //-- 净值

//--全局恢复,适用于程序重启,设计程序时，必须要考虑程序的意外卸载或死机情况后的再加载问题。
   if(GlobalVariableCheck("global_a"))
      global_a = GlobalVariableGet("global_a");

   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//-- 2.止损
   StopLoss();
//-- 3.止盈
   TakeProfit();
//-- 4.移动止损
   MovingStopLoss();
//-- 5.净值控制
   if(LossControl())
      return;
//-- 6.单量控制
   if(VolumeControl())
      return;
//-- 7.时间控制
   if(TimeControl())
      return;
//-- 8.K线控制，一根k线只进行一次开仓判断
   if(CandleControl())
      return;
//-- 9.开仓方法
   OpenOrder();
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void StopLoss()
  {
//-- 止损方法
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TakeProfit()
  {
//-- 止盈方法
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void MovingStopLoss()
  {
//-- 移动止损方法
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool LossControl()
  {
//-- 净值控制
   if(AccountEquity()<init_capital*(1-max_loss_percent*0.01))
     {
      CloseAll();
      ExpertRemove();
      return true;
     }
   return false;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool VolumeControl()
  {
//-- 单量控制
   double net_volume=0;
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) && OrderMagicNumber()==magic_num && OrderSymbol()==Symbol())
        {
         if(OrderType()==OP_BUY)
            net_volume = net_volume+OrderLots();
         if(OrderType()==OP_SELL)
            net_volume = net_volume-OrderLots();
        }
     }
   if(MathAbs(net_volume)>max_volume)
     {
      Print("单量达到上限，不能再开仓，此段程序需放在开仓函数之前");
      return true;
     }
   return false;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TimeControl()
  {
//-- 止损方法
   MqlDateTime now;
   TimeToStruct(TimeLocal(),now);
   if(now.hour>1 && now.hour<8)  //-- 北京时间1-8点不开仓，需保证本地时间正确
     {
      return true;
     }
   return false;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CandleControl()
  {
//-- 一根k线只进行一次开仓判断
   if(candle_time == iTime(Symbol(),Period(),0))
      return true;
   candle_time = iTime(Symbol(),Period(),0);
   return false;

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OpenOrder()
  {
//-- 开仓方法
   global_a=1000;
   GlobalVariableSet("global_a",global_a);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CloseAll()
  {
   for(int i=OrdersTotal()-1; i>=0; i--) //-- i 必须从大到小
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) && OrderMagicNumber()==magic_num && OrderSymbol()==Symbol())
        {
         if(OrderType()==OP_BUY)
            if(!OrderClose(OrderTicket(),OrderLots(),Bid,3,clrNONE))
              {
               Alert("订单："+IntegerToString(OrderTicket())+"自动平仓失败，需手动平仓！");
              }
         if(OrderType()==OP_SELL)
            if(OrderClose(OrderTicket(),OrderLots(),Ask,3,clrNONE))
              {
               Alert("订单："+IntegerToString(OrderTicket())+"自动平仓失败，需手动平仓！");
              }
        }
     }
  }
//+------------------------------------------------------------------+
