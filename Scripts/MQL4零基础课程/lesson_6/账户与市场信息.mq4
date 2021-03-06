#property copyright "shiyingpan"
#property link      "https://aijy.github.io"
#property version   "1.00"
#property strict

void OnStart()
  {
   //-- 账户信息
   Print("当前账户是模拟账户吗？答案：",IsDemo());
   Print("当前账户编号：",AccountNumber());
   Print("当前账户名称：",AccountName());
   Print("当前账户余额：",AccountBalance());
   Print("当前账户净值：",AccountEquity());
   Print("当前账户杠杆：",AccountLeverage());
   Print("当前账户公司：",AccountCompany());
   Print("当前账户剩余保证金：",AccountFreeMargin());
   Print("当前账户止损线：",AccountStopoutLevel());
   
   //-- 市场信息
   Print("当前币种卖价：",MarketInfo(Symbol(),MODE_ASK));
   Print("当前币种买价：",MarketInfo(Symbol(),MODE_BID));
   Print("当前币种有几位小数：",MarketInfo(Symbol(),MODE_DIGITS));
   Print("当前币种最小变动：",MarketInfo(Symbol(),MODE_POINT));
   Print("当前币种点值：",MarketInfo(Symbol(),MODE_TICKVALUE));
   
   //-- 终端信息
   Print("终端名：",TerminalName());
   Print("终端路径：",TerminalPath());
   Print("终端公司：",TerminalCompany());
   Print("终端公共数据文件夹：",TerminalInfoString(TERMINAL_COMMONDATA_PATH));  
   Print("终端文件夹：",TerminalInfoString(TERMINAL_DATA_PATH));  //-- 右侧 Files文件夹路径
   Print("关闭终端指令 TerminalClose() ");
  }
//+------------------------------------------------------------------+
