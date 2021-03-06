//+------------------------------------------------------------------+
//|                                                     马丁策略-多方向.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

input int rsi_period=14;
input double lot=0.1;
input int 止盈点数=300;
input int 加仓间距点数=500;
input double 加仓倍数=1.2;

int Magic_Num=23424;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   
//---
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
//--开仓部分
//-- 仓位判断
   int count=0;
   double last_order_price=0,rsi_value=0;
   double total_price=0,avg_price,total_lots=0;
   for(int i=0;i<OrdersTotal();i++) //--- for(int i=OrdersTotal()-1;i>=0;i--)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) && OrderSymbol()==Symbol() && OrderMagicNumber()==Magic_Num)
      {
         if(OrderType()==OP_BUY)
         {
            count=count+1;
            last_order_price=OrderOpenPrice();
            total_price=total_price+OrderLots()*OrderOpenPrice();
            total_lots = total_lots+OrderLots();
         }
      }
   }

   if(count==0)
   {
      rsi_value=iRSI(Symbol(),PERIOD_M5,14,PRICE_CLOSE,1);
      if(rsi_value>50)
      {
         OrderSend(Symbol(),OP_BUY,lot,Ask,3,0,0,IntegerToString(count+1),Magic_Num,0,clrNONE);
      }
   }
   else
   {
      if(last_order_price-Ask>加仓间距点数*Point)
      {
         OrderSend(Symbol(),OP_BUY,lot*NormalizeDouble(MathPow(1.2,count),2),Ask,3,0,0,IntegerToString(count+1),Magic_Num,0,clrNONE);
      }
//---平仓部分   
      avg_price=total_price/total_lots;
      if(Ask-avg_price>300*Point)
         CloseAll();
   }
  }
//+------------------------------------------------------------------+
void CloseAll()
{
   for(int i=0;i<OrdersTotal();i++) 
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) && OrderSymbol()==Symbol() && OrderMagicNumber()==Magic_Num)
      {
         if(OrderType()==OP_BUY)
         {
            OrderClose(OrderTicket(),OrderLots(),Bid,3,clrNONE);
         }
      }
   }
}