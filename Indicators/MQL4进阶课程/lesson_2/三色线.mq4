/*--------------------------------
本例制作一款趋势类型的变色均线指标，
红色是跌势
黄色是震荡
绿线是上涨
均线周期可选
----------------------------------*/
#property copyright "shiyingpan"
#property link      "https://aijy.github.io"
#property version   "1.00"
#property strict
//---定义指标属性
#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 Red
#property indicator_color2 Green
#property indicator_color3 Yellow
//---设置输入参数
input int 短周期=10;
input int 中周期=20;
input int 长周期=30;

//---定义指标缓存空间
double LongBuffer[];
double ShortBuffer[];
double NoTrendBuffer[];

//--- 指标起始点
int draw_begin=0;
int OnInit()
  {
//-- 为指标取个名字  
   string short_name="趋势指标("+IntegerToString(短周期)+IntegerToString(中周期)+IntegerToString(长周期)+")";
   IndicatorShortName(short_name);
//-- 设置指标缓存空间数量，设置线型并做连接,在此都设置为线型
   IndicatorBuffers(3);
   SetIndexStyle(0,DRAW_LINE,STYLE_SOLID,2);  
   SetIndexBuffer(0,LongBuffer);
   SetIndexStyle(1,DRAW_LINE,STYLE_SOLID,2);
   SetIndexBuffer(1,ShortBuffer);
   SetIndexStyle(2,DRAW_LINE,STYLE_SOLID,2);
   SetIndexBuffer(2,NoTrendBuffer);
//-- 设置指标起始的地方,小于长周期的K线并没有值   
   draw_begin=长周期;
   SetIndexDrawBegin(0,draw_begin);
//-- 返回初始化成功，若返回 INIT_FAILED则指标不会成功加载
   return(INIT_SUCCEEDED);
  }

int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//-- 若K线数量小于长周期数目，则不够计算
   if(rates_total<=长周期)
      return(0);
//-- 缓存空间顺序是从左到右的，最左边是1      
   ArraySetAsSeries(LongBuffer,false);
   ArraySetAsSeries(ShortBuffer,false);
   ArraySetAsSeries(NoTrendBuffer,false);

         
   double ma_fast,ma_mid,ma_slow;
   double ma_fast_prv,ma_mid_prv,ma_slow_prv;

//-- 为显示趋势变化快慢，为较短的周期赋予较大的权重
   double sum=短周期+中周期+长周期;
   double w1=长周期/sum,w2=中周期/sum,w3=短周期/sum;
    
   for(int i=draw_begin+1; i<=rates_total && !IsStopped(); i++)
   {
      ma_fast = iMA(Symbol(),0,短周期,0,MODE_EMA,PRICE_CLOSE,rates_total-i);
      ma_mid = iMA(Symbol(),0,中周期,0,MODE_EMA,PRICE_CLOSE,rates_total-i);
      ma_slow = iMA(Symbol(),0,长周期,0,MODE_EMA,PRICE_CLOSE,rates_total-i); 
      
      ma_fast_prv = iMA(Symbol(),0,短周期,0,MODE_EMA,PRICE_CLOSE,rates_total-i+1);
      ma_mid_prv = iMA(Symbol(),0,中周期,0,MODE_EMA,PRICE_CLOSE,rates_total-i+1);
      ma_slow_prv = iMA(Symbol(),0,长周期,0,MODE_EMA,PRICE_CLOSE,rates_total-i+1); 
      
      if(ma_fast>ma_mid && ma_mid>ma_slow)  //--- 多头排列，上涨趋势
      {
         LongBuffer[i]=(ma_fast+ma_mid+ma_slow)/3;              //--  计算本根和上一根的值，做不同趋势的连接
         LongBuffer[i-1]=(ma_fast_prv+ma_mid_prv+ma_slow_prv)/3;
         
         //LongBuffer[i]  =ma_fast*w1+ma_mid*w2+ma_slow*w3;              
         //LongBuffer[i-1]=ma_fast_prv*w1+ma_mid_prv*w2+ma_slow_prv*w3;
      }
      else if(ma_fast<ma_mid && ma_mid<ma_slow)  //--- 空头排列，下跌趋势
      {
         ShortBuffer[i]=(ma_fast+ma_mid+ma_slow)/3;
         ShortBuffer[i-1]=(ma_fast_prv+ma_mid_prv+ma_slow_prv)/3;
         
         //ShortBuffer[i]  =ma_fast*w1+ma_mid*w2+ma_slow*w3;              
         //ShortBuffer[i-1]=ma_fast_prv*w1+ma_mid_prv*w2+ma_slow_prv*w3;
      }
      else  //-- 除了上涨、下跌趋势，就是归纳于震荡
      {
         NoTrendBuffer[i]=(ma_fast+ma_mid+ma_slow)/3;
         NoTrendBuffer[i-1]=(ma_fast_prv+ma_mid_prv+ma_slow_prv)/3;
         
         //NoTrendBuffer[i]  =ma_fast*w1+ma_mid*w2+ma_slow*w3;              
         //NoTrendBuffer[i-1]=ma_fast_prv*w1+ma_mid_prv*w2+ma_slow_prv*w3;
      }
   }
   return(rates_total);
  }