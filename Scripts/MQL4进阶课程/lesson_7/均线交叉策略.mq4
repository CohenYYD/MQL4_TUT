//+------------------------------------------------------------------+
//|                                                       均线交叉策略.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict


double lot=0.1;
//--- macd指标参数
int macd_fast=12;
int macd_slow=26;
int macd_signal=9;
//--- 均线指标参数
int ma_period=60;

//--- EA参数：识别码
int Magic_Num=124243;
string comment ="test";

//--- 策略变量
bool gold_cross=False,dead_cross=False;
datetime time_flag=0;


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
//-- 平仓部分
   double macd_4_main_value,macd_4_main_value_prv,macd_4_signal_value,macd_4_signal_value_prv;  
   macd_4_main_value = iMACD(Symbol(),PERIOD_H4,macd_fast,macd_slow,macd_signal,PRICE_CLOSE,MODE_MAIN,1);
   macd_4_main_value_prv = iMACD(Symbol(),PERIOD_H4,macd_fast,macd_slow,macd_signal,PRICE_CLOSE,MODE_MAIN,2);   

   macd_4_signal_value = iMACD(Symbol(),PERIOD_H4,macd_fast,macd_slow,macd_signal,PRICE_CLOSE,MODE_SIGNAL,1);
   macd_4_signal_value_prv = iMACD(Symbol(),PERIOD_H4,macd_fast,macd_slow,macd_signal,PRICE_CLOSE,MODE_SIGNAL,2); 
   
   for(int i=0;i<OrdersTotal();i++)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) && OrderSymbol()==Symbol() && OrderMagicNumber()==Magic_Num)
      {
         if(OrderType()==OP_BUY)
         {
            if(macd_4_main_value<macd_4_signal_value && macd_4_main_value_prv>macd_4_signal_value_prv)
               OrderClose(OrderTicket(),OrderLots(),Bid,3,clrNONE);//--- 4小时死叉平仓
         }
         if(OrderType()==OP_SELL)
         {
            if(macd_4_main_value>macd_4_signal_value && macd_4_main_value_prv<macd_4_signal_value_prv)
               OrderClose(OrderTicket(),OrderLots(),Ask,3,clrNONE);//--- 4小时金叉平仓
         }
      }
   }
  
//-- 开仓部分
   if(time_flag==iTime(Symbol(),0,0)) //-- 每根K线做一次开仓判断
      return;
   time_flag= iTime(Symbol(),0,0);  
   
   for(int i=0;i<OrdersTotal();i++)
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES) && OrderSymbol()==Symbol() && OrderMagicNumber()==Magic_Num)
         return;//--订单已存在，不再继续下单
   }
   
   double ma_value,ma_value_prv,macd_main_value,macd_main_value_prv,macd_signal_value,macd_signal_value_prv;
   ma_value = iMA(Symbol(),PERIOD_D1,ma_period,0,MODE_EMA,PRICE_CLOSE,1);
   ma_value_prv = iMA(Symbol(),PERIOD_D1,ma_period,0,MODE_EMA,PRICE_CLOSE,2);
   
   macd_main_value = iMACD(Symbol(),PERIOD_D1,macd_fast,macd_slow,macd_signal,PRICE_CLOSE,MODE_MAIN,1);
   macd_main_value_prv = iMACD(Symbol(),PERIOD_D1,macd_fast,macd_slow,macd_signal,PRICE_CLOSE,MODE_MAIN,2);   

   macd_signal_value = iMACD(Symbol(),PERIOD_D1,macd_fast,macd_slow,macd_signal,PRICE_CLOSE,MODE_SIGNAL,1);
   macd_signal_value_prv = iMACD(Symbol(),PERIOD_D1,macd_fast,macd_slow,macd_signal,PRICE_CLOSE,MODE_SIGNAL,2); 
   
   
   if(ma_value>ma_value_prv)//-- 均线向上
   {
      if(macd_main_value>macd_signal_value && macd_main_value_prv<macd_signal_value_prv)//--- macd金叉
         OrderSend(Symbol(),OP_BUY,lot,Ask,3,0,0,comment,Magic_Num,0,clrNONE); //--下多单
   }
   if(ma_value<ma_value_prv)//-- 均线向下
   {
      if(macd_main_value<macd_signal_value && macd_main_value_prv>macd_signal_value_prv)//--- macd死叉
         OrderSend(Symbol(),OP_SELL,lot,Bid,3,0,0,comment,Magic_Num,0,clrNONE); //--下空单
   }   
  }
//+------------------------------------------------------------------+
