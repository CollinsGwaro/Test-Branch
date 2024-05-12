//+------------------------------------------------------------------+
//|                                            Indicators_signal.mq5 |
//|                                    Copyright 2023, Collins Gwaro |
//|                                                              TBD |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Collins Gwaro"
#property link      "TBD"
#property version   "1.00"
#property description "This EA is meant to trade the Moving Average indicator"
#property description "It has been tested with the following conditions..."
#property description "Currency:      EUR/USD"
#property description "Timeframe:     H1"
#property description "SMA Settings:  "

// Global Variables 

int handleBB; 



//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
    //assign an integer value to receive the return value of the handle 

    
    //get the indicator's name 
    string indiname = ChartIndicatorName(0,0,0);
    
    handleBB = ChartIndicatorGet(0, 0, indiname);
    if (handleBB == INVALID_HANDLE){
      Print(__FUNCTION__, " > wrong indicator name == ", indiname);
      OnDeinit(REASON_INITFAILED);
    }
    return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   
  }

