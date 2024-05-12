//+------------------------------------------------------------------+// PROPERTY
//|                                     CJ-Candle Pattern (Doji).mq5 |
//|PROPERTY                              Copyright 2023, COLLINS.cop |
//|                                                              TBD |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, COLLINS.cop"
#property link      "TBD"
#property version   "1.00"
#property description "This EA is simply for opening pending order of type Buy-Stop based on one condition"
#property description "The condition is that if the Equity is equal to or greater than the account balance"
#property description "a buy trade is excecuted."


// Includes 
#include <Trade\Trade.mqh>

// Experts  
CTrade trade;

// Global variables
// Used for the newBar function to facilitate opening a trade only on a new bar
MqlRates    bar[];
bool        newBar;
datetime    lastBarTime;
//................................................................................//













// User Inputs 
// 1. For Opening Trades or for the CTrade expert
input group         "GENERAL USER INPUTS";
static input int    magicNumber    =   24816;
input double        lotSize        =   0.01;
input double        stopLoss       =   300;       // Means 30 pips 
input double        takeProfit     =   600;       // Means 60 pips 

// 2. For the Functions
input double shortShadowRatio = 0.1;
input double longShadowToBodyRatio  = 3.0;
input double ratioOfDayCandleToCurrentCandle = 0.3;

// For number of open trades at a time
input group         "Number of open trades at a time"
input int           Total_Positions =   3;

//..............................................................//
// Initialization Function
int OnInit()  
  {
    ArraySetAsSeries(bar, true);
      // This array reverses the order of counting of the candle bars so that the curret bar starts at 0.
    return(INIT_SUCCEEDED);
  }


//..............................................................//
// Ontick function
void OnTick()
{
// These are parameters for opening a trade
  double ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);
  double bid = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);

// These are the parameters for the second candle from the right  
  double  high  = iHigh(_Symbol, PERIOD_CURRENT, 1);
  double  low   = iLow(_Symbol, PERIOD_CURRENT, 1);
  double  open  = iOpen(_Symbol, PERIOD_CURRENT, 1);
  double  close = iClose(_Symbol, PERIOD_CURRENT,1);
  double  candleSize  = high - low;
  
  datetime time       = iTime(_Symbol, PERIOD_CURRENT, 1);
//..............................................................//

// These are the parameters for the third candle from the right 
  double  high2  = iHigh(_Symbol, PERIOD_CURRENT, 2);
  double  low2   = iLow(_Symbol, PERIOD_CURRENT, 2);
  double  open2  = iOpen(_Symbol, PERIOD_CURRENT, 2);
  double  close2 = iClose(_Symbol, PERIOD_CURRENT,2);
  double  candleSize2  = high2 - low2;
//..............................................................//

// These parameters will be used to calculate the daily range of the previous day
  double highD1 = iHigh(_Symbol, PERIOD_D1, 1);
  double lowD1  = iLow(_Symbol, PERIOD_D1, 1);
  double candleSizeD1 = highD1 - lowD1;


// INSERTING THE FUNCTIONS WITHIN THE ON-TICK FUNCTION
/*  
  hammerPattern(longShadowToBodyRatio, shortShadowRatio, 
                open, close, high, low,
                open2, close2, high2, low2,
                candleSize, candleSizeD1, 
                ask, bid,
                time );
*/
  
/*
  engulfingFunction(longShadowToBodyRatio, shortShadowRatio, 
                    open, close, high, low,
                    open2, close2, high2, low2,
                    candleSize, candleSizeD1, 
                    ask, bid,
                    time);
*/

NumTradeFunction(Total_Positions,       // This function contains the following embedded function tree within <NumTradeFunction\newBar\engulfingFunction\Create_Object>
                  longShadowToBodyRatio, shortShadowRatio, 
                  open, close, high, low,
                  open2, close2, high2, low2,
                  candleSize, candleSizeD1, 
                  ask, bid,
                  time);
}












// Custom functions
//........................................................................................................................................................
bool newBar(double bodyTimesRatio, double shortShadowTimesCandleSize,
            double open, double close, double high, double low, 
            double open2, double close2, double high2, double low2,
            double candleSize, double candleSizeD1, 
            double ask, double bid,
            datetime time )
  {
    CopyRates(_Symbol, PERIOD_CURRENT, 0, 5, bar);
    if(bar[0].time > lastBarTime)
    {
      newBar = true;
      lastBarTime = bar[0].time;
    }
    else{
      newBar = false;
    }
    if(newBar == true)
    {
      engulfingPatternSignal(longShadowToBodyRatio, shortShadowRatio, 
                        open, close, high, low,
                        open2, close2, high2, low2,
                        candleSize, candleSizeD1, 
                        ask, bid,
                        time);
    }
    return true;
  }









bool hammerPatternSignal(double bodyTimesRatio, double shortShadowTimesCandleSize,
                    double open, double close, double high, double low, 
                    double open2, double close2, double high2, double low2,
                    double candleSize, double candleSizeD1, 
                    double ask, double bid,
                    datetime time ) //these parameters will be copied, and pasted in every other function. some parameters may not be used within some functions but it helps adding variables instead of making new parameters which might be cumbersome. 
{

// UpperTrend reversal
  // Green hammer
    if(close > open){
      if((high - close) >= bodyTimesRatio*(close - open)){
        if((open - low) <= shortShadowTimesCandleSize*candleSize){
          if(dailyRange(candleSize, candleSizeD1, ratioOfDayCandleToCurrentCandle)){   
            trade.Sell(lotSize, Symbol(), bid, bid + (stopLoss*_Point), bid - (takeProfit*_Point), "BUY POSITION IMEINGIANA...");           
            Create_Object(time, high, 226, ANCHOR_RIGHT_UPPER, clrRed, true, "Hammer");
            return true;            
          }          
        }
      }
    }

    // Red hammer
    else if(open  > close)    {
      if((high - open) >= bodyTimesRatio*(open - close))      {
        if((close - low) <= shortShadowTimesCandleSize * candleSize)        {
          if(dailyRange(candleSize, candleSizeD1, ratioOfDayCandleToCurrentCandle)){ 
              trade.Sell(lotSize, Symbol(), bid, bid + (stopLoss*_Point), bid - (takeProfit*_Point), "BUY POSITION IMEINGIANA...");
              Create_Object(time, high, 226, ANCHOR_RIGHT_UPPER, clrRed, true, "Hammer");
              return true;            
          }
        }
      }
    }
  // LowerTrend reversal
    // Green hammer
    if(close  > open)    {
      if((open - low) >= bodyTimesRatio*(close - open))      {
        if((high - close) <= shortShadowTimesCandleSize * candleSize)  {
          if(dailyRange(candleSize, candleSizeD1, ratioOfDayCandleToCurrentCandle)){ 
              trade.Buy(lotSize, Symbol(), ask, ask - (stopLoss*_Point), ask + (takeProfit*_Point), "BUY POSITION IMEINGIANA...");
              Create_Object(time, low, 225, ANCHOR_RIGHT_LOWER, clrGreen, true, "Hammer");
              return true;            
          }
        }
      }
    }

    // Red hammer
    else if(open  > close)    {
      if((close - low) >= bodyTimesRatio*(open - close))      {
        if((high - open) <= shortShadowTimesCandleSize * candleSize)        {
          if(dailyRange(candleSize, candleSizeD1, ratioOfDayCandleToCurrentCandle)){ 
              trade.Buy(lotSize, Symbol(), ask, ask - (stopLoss*_Point), ask + (takeProfit*_Point), "BUY POSITION IMEINGIANA...");
              Create_Object(time, low, 225, ANCHOR_RIGHT_LOWER, clrGreen, true, "Hammer");
              return true;            
          }
        }
      }
    }

  return false;
}












//........................................................................................................................................................
// Creating a function that creates buy and sell arrows in the chart
void Create_Object(datetime time, double price, int arrowCode, ENUM_ANCHOR_POINT anchorCode, color clr, bool bck, string txt)
{
  
  string objName  =  "";
  StringConcatenate(objName, time, price, "THISS");
  if(ObjectCreate(0, objName, OBJ_ARROW, 0, time, price))
  {
    ObjectSetInteger(0, objName, OBJPROP_ARROWCODE, arrowCode);
    ObjectSetInteger(0, objName, OBJPROP_COLOR, clr);
    ObjectSetInteger(0, objName, OBJPROP_BACK, bck);
  }

  string objNameDescription  = txt;
  if(ObjectCreate(0, objNameDescription, OBJ_TEXT, 0, time, price))
  {
    ObjectSetString(0, objNameDescription, OBJPROP_TEXT, txt);
    ObjectSetInteger(0, objNameDescription, OBJPROP_COLOR, clr);
    ObjectSetInteger(0, objNameDescription, OBJPROP_BACK, bck);
    ObjectSetInteger(0, objNameDescription, OBJPROP_ANCHOR, anchorCode);
  }
}












//........................................................................................................................................................
// A function that checks if the candle size of the previous 2nd candle is smaller than the candle size of the previous 1st candle

bool candleSizeComparison(double cs1, double cs2) //these parameters will be copied, and pasted in every other function. some parameters may not be used within some functions but it helps adding variables instead of making new parameters which might be cumbersome. 
{
  if (cs1 >= 2* cs2){
    return true;
  }
  return false;
}












//........................................................................................................................................................
// A function that checks if the candle size of the previous 2nd candle is smaller than the candle size of the previous 1st candle
bool dailyRange(double myCandle, double dayCandle, double dayCandleRatio) //these parameters will be copied, and pasted in every other function. some parameters may not be used within some functions but it helps adding variables instead of making new parameters which might be cumbersome. 
{
  if (myCandle >= dayCandleRatio * dayCandle){
    return true;
  }
  return false;
}











//........................................................................................................................................................
// An Engulfing pattern function 
int engulfingPatternSignal(double bodyTimesRatio, double shortShadowTimesCandleSize,
                      double open, double close, double high, double low, 
                      double open2, double close2, double high2, double low2,
                      double candleSize, double candleSizeD1, 
                      double ask, double bid,
                      datetime time ) // These parameters will be copied, and pasted in every other function. some parameters may not be used within some functions but it helps adding variables instead of making new parameters which might be cumbersome. 
  {
  // Bullish Engulfing pattern / Buy signal
  if(high > high2 && low < low2){
    if(open2 > close2 && open < close){
      if(close2 > open && open2 < close){
        trade.Buy(lotSize, Symbol(), ask, ask - (stopLoss*_Point), ask + (takeProfit*_Point), "BUY POSITION IMEINGIANA...");              
        Create_Object(time, high, 246, ANCHOR_RIGHT_LOWER, clrGreen, true, "Bullish Engulfing");
        return 1;
      }
    }
  }

  // Bearish Engulfing pattern / Sell signal
  if(high > high2 && low < low2){
    if(open2 < close2 && open > close){
      if(close2 < open && open2 > close){
        trade.Sell(lotSize, Symbol(), bid, bid + (stopLoss*_Point), bid - (takeProfit*_Point), "BUY POSITION IMEINGIANA...");           
        Create_Object(time, high, 248, ANCHOR_RIGHT_UPPER, clrRed, true, "Bearish Engulfing");
        return -1;
      }
    }
  }

  return 0;
}






//........................................................................................................................................................
// A function that opens a number of trade at a time
int NumTradeFunction(int totalPositions, 
                      double bodyTimesRatio, double shortShadowTimesCandleSize,
                      double open, double close, double high, double low, 
                      double open2, double close2, double high2, double low2,
                      double candleSize, double candleSizeD1, 
                      double ask, double bid,
                      datetime time)
{
  totalPositions = PositionsTotal();
  if (totalPositions <= Total_Positions-1) {
    newBar(longShadowToBodyRatio, shortShadowRatio, 
            open, close, high, low,
            open2, close2, high2, low2,
            candleSize, candleSizeD1, 
            ask, bid,
            time);
            return 1;
  }
  return 0;
}