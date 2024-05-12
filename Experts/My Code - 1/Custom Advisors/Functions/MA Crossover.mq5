//+------------------------------------------------------------------+
//|                                                      dispose.mq5 |
//|                                    Copyright 2023, Collins Gwaro |
//|                                                              TBD |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Collins Gwaro"
#property link      "TBD"
#property version   "1.00"
#property description "This EA is meant to trade the Moving Average and ATR indicators"
#property description "It detects MA Crossover and ensures the average true range is rising to indicate increased volatility in the market before placing a trade."
#property description "It has been tested with the following conditions..."
#property description "Currency:      EUR/USD"
#property description "Timeframe:     H1"
#property description "SMA Settings:  fast MA = 14"
#property description "SMA Settings:  slow MA = 21"
#property description "ATR Settings:  MA = 14"
#property description "Lot size;      0.01"
#property description "Stop loss:     300 points "
#property description "Take Profit:   600 points "

//+------------------------------------------------------------------+
//|  Includes                                                        |
//+------------------------------------------------------------------+
#include <Trade\Trade.mqh>

//+------------------------------------------------------------------+
//|   inputs                                                         |
//+------------------------------------------------------------------+
input group "MONEY MANAGEMENT SETTINGS";
input double lotSize  = 0.01;
input int stopLoss    = 300;
input int takeProfit  = 600;

input group "MOVING AVERAGES SETTINGS";
input int inpFastPeriod  =  14;
input int inpSlowPeriod  =  21;

input group "ATR SETTINGS"
input int inpATR         =  14;

//+------------------------------------------------------------------+
//|   Global Variables                                               |
//+------------------------------------------------------------------+
// Global variable to excecute trades
CTrade trade; 

// Handles for the fast and slow moving average. AND bufers to store the values of the Moving averages
int  fastHandle;
int  slowHandle;
double fBuffer[];
double sBuffer[]; 

// Handles and buffer for ATR indicator
int atrHandle;
double atrBuffer[];

// Variables for the newBar function
MqlRates bar[];
datetime lastBarTime;
bool  newBar;








//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   // New bar function initialization. reverse the order of counting
    ArraySetAsSeries(bar, true);

      // Check to see if the inputs of the fast and slow MA have been defined correctly
      if(inpFastPeriod <= 0 || inpFastPeriod >= inpSlowPeriod || inpSlowPeriod <= 0){
        Alert("INVALID INPUTS FOR THE FAST AND SLOW MOVING AVERAGES");
        return INIT_FAILED;
      }
      
      // Settings of the handles using the i_IndicatorName
      fastHandle = iMA(_Symbol,PERIOD_CURRENT,inpFastPeriod, 0,MODE_SMA,PRICE_CLOSE);
      slowHandle = iMA(_Symbol,PERIOD_CURRENT,inpSlowPeriod, 0,MODE_SMA,PRICE_CLOSE); 

      // checking to see if the handles have been set
      if (fastHandle == INVALID_HANDLE || slowHandle == INVALID_HANDLE){
        return INIT_FAILED;
      }

      //initializing the ATR handle
      atrHandle = iATR(_Symbol, PERIOD_CURRENT, inpATR);
      if (atrHandle == INVALID_HANDLE) {
        Print(__FUNCTION__, "ATR HANDLE INCORRECT...");
        return (INIT_FAILED);
      }

   // reverse the count in the array series of the handles
   ArraySetAsSeries(fBuffer, true);
   ArraySetAsSeries(sBuffer, true);
    
    Print("INITIALIZATION SUCCESSFUL...");
    return(INIT_SUCCEEDED); 
  }







//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
    if(fastHandle != INVALID_HANDLE) {
      IndicatorRelease(fastHandle);
    }
   if(slowHandle != INVALID_HANDLE) {
      IndicatorRelease(slowHandle);
    }
   if(atrHandle != INVALID_HANDLE) {
      IndicatorRelease(atrHandle);
    }
  }








//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
    // These variables will store the price values of the current bar
    double ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);
    double bid = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_BID), _Digits);
    
    int newBarFunction  = newBar_FUNCTION();
    int maFunction      = MA_FUNCTION();            // If the maFunction handle returns 1, it means the MA_FUNCTION is working properly

    if (newBarFunction == 1) {    Print("NEW BAR CREATED..");      
      PlaceTrade_FUNCTION(maFunction, ask, bid);
    }  
  }








//+------------------------------------------------------------------+
//|   CUSTOM INDICATORS                                              |
//+------------------------------------------------------------------+
int newBar_FUNCTION()
  {
    CopyRates(_Symbol, PERIOD_CURRENT, 0, 5, bar);
    if(bar[0].time > lastBarTime){
      lastBarTime = bar[0].time;
      return 1;
    }
    return 0;
  }







//+------------------------------------------------------------------+
int MA_FUNCTION(){
  CopyBuffer(fastHandle,0,0,2,fBuffer);
  CopyBuffer(slowHandle,0,0,2,sBuffer);
      
      // Checking to see that a bus/sell signal has been formed
      if (fBuffer[1] <= sBuffer[1] && fBuffer[0] > sBuffer[0]){
        Print("CROSS-OVER TO THE UPSIDE");
        return 1;
      }
      if (fBuffer[1] >= sBuffer[1] && fBuffer[0] < sBuffer[0]){
        Print("CROSS-OVER TO THE DOWNSIDE");
        return 2;
      }
  return 0;
}
/*
//+------------------------------------------------------------------+
int MA_FUNCTION(){
  int values = CopyBuffer(fastHandle,0,0,2,fBuffer);

    // Checking to see that the buffers have 2 variables in their arrays. 2 vars are used to determine if there is a crossover of the MAs
    if(values !=2){
        Print("NOT ENOUGH DATA FOR THE FAST MOVING AVERAGE");
        return 0;
      }
      values = CopyBuffer(slowHandle,0,0,2,sBuffer);
      if(values !=2){
        Print("NOT ENOUGH DATA FOR THE SLOW MOVING AVERAGE");
        return 0;

      // Checking to see that a bus/sell signal has been formed
      if (fBuffer[1] <= sBuffer[1] && fBuffer[0] > sBuffer[0]){
        return 1;
      }
    }
  return 0;
  Print("MA FUNCTION IS WORKING");
}
*/







int ATR_FUNCTION(){
  CopyBuffer(atrHandle,0,0,3,atrBuffer);
  
  return 0;
}


void PlaceTrade_FUNCTION(int maFunction, double ask, double bid){
  //MOVING AVERAGE CONDITION
  if (maFunction == 1){       
    Print("BUY POSITION");
      Buy_FUNCTION(ask, bid);
    }
  if (maFunction == 2){       
    Print("SELL POSITION");
      Sell_FUNCTION(ask, bid);
    }else{    
    Print("Waiting for signal");
  }
}

        // INSTANT BUY TRADE
        void Buy_FUNCTION(double ask, double bid){
          trade.Buy(lotSize, _Symbol, ask, ask - (stopLoss * _Point), ask + (takeProfit * _Point), "COLLINS EA");
        }

        // INSTANT SELL TRADE
        void Sell_FUNCTION(double ask, double bid){
          trade.Sell(lotSize, _Symbol, bid, bid + (stopLoss * _Point), bid - (takeProfit * _Point), "COLLINS EA");
        }



