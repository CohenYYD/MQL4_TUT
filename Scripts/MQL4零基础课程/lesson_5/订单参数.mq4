#property copyright "shiyingpan"
#property link      "https://aijy.github.io"
#property version   "1.00"
#property strict
/*--------------------------------
选择订单参数是自动交易中的重要步骤。
----------------------------------*/
void OnStart()
  {
//-------------通用格式-----------
   for(int i=0;i<=OrdersTotal()-1;i++) //---------选择持仓订单
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)) 
      {
         Print("订单号：",OrderTicket()); 
         Print("币种：",OrderSymbol());
         Print("方向：",OrderType()); 
         Print("单量：",OrderLots()); 
         Print("开仓价：",OrderOpenPrice()); 
         Print("开仓时间：",OrderOpenTime()); 
         Print("止损：",OrderStopLoss()); 
         Print("止盈：",OrderTakeProfit()); 
         Print("收盘价：",OrderClosePrice()); 
         Print("收盘时间：",OrderCloseTime()); 
         Print("魔数：",OrderMagicNumber()); 
         Print("注释：",OrderComment());
         Print("浮盈：",OrderProfit());
         Print("隔夜利息：",OrderSwap());
         Print("手续费：",OrderCommission());    
      }
   }
   
   for(int i=0;i<=OrdersHistoryTotal()-1;i++) //---------选择历史订单
   {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY))
      {
         Print("订单号：",OrderTicket()); 
         Print("币种：",OrderSymbol());
         Print("方向：",OrderType()); 
         Print("单量：",OrderLots()); 
         Print("开仓价：",OrderOpenPrice()); 
         Print("开仓时间：",OrderOpenTime()); 
         Print("止损：",OrderStopLoss()); 
         Print("止盈：",OrderTakeProfit()); 
         Print("收盘价：",OrderClosePrice()); 
         Print("收盘时间：",OrderCloseTime()); 
         Print("魔数：",OrderMagicNumber()); 
         Print("注释：",OrderComment());
         Print("浮盈：",OrderProfit());
         Print("隔夜利息：",OrderSwap());
         Print("手续费：",OrderCommission());    
      }
   }
   
//------------直接按订单号选择-------
   int ticket=123;
   
   if(OrderSelect(ticket,SELECT_BY_TICKET)) //----直接按订单号选择需输入正确订单号，很少用
   {
         Print("订单号：",OrderTicket()); 
         Print("币种：",OrderSymbol());
         Print("方向：",OrderType()); 
         Print("单量：",OrderLots()); 
         Print("开仓价：",OrderOpenPrice()); 
         Print("开仓时间：",OrderOpenTime()); 
         Print("止损：",OrderStopLoss()); 
         Print("止盈：",OrderTakeProfit()); 
         Print("收盘价：",OrderClosePrice()); 
         Print("收盘时间：",OrderCloseTime()); 
         Print("魔数：",OrderMagicNumber()); 
         Print("注释：",OrderComment());
         Print("浮盈：",OrderProfit());
         Print("隔夜利息：",OrderSwap());
         Print("手续费：",OrderCommission()); 
   }   
  }