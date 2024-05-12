//+------------------------------------------------------------------+
//|                                                       3MA EA.mq5 |
//|                                    Copyright 2023, Collins Gwaro |
//|                                                              TBD |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Collins Gwaro"
#property link      "TBD"
#property version   "1.00"

//+------------------------------------------------------------------+
//|   INCLUDES                                                       |
//+------------------------------------------------------------------+
#include <Trade\trade.mqh>

//+------------------------------------------------------------------+
//|    INPUTS                                                        | 
//+------------------------------------------------------------------+
input int inplongmaperiod = 50;        //Long MA Period
input int inpmidmaperiod  = 30;        //Middle MA Period
input int inpshortmaperiod = 14;       //Short MA Period

//+------------------------------------------------------------------+
//|    GLOBAL VARIABLES                                              |
//+------------------------------------------------------------------+
// Variables for the newBar function 
MqlRates bar[];
datetime lastBarTime;
bool  newBar;

// Variables for the moving averages 
int longmahandle;
int midmahandle;
int shortmahandle;
double longmabuffer[];
double midmabuffer[];
double shortmabuffer[];


//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   // New bar function initialization. reverse the order of counting
    ArraySetAsSeries(bar, true);
    
    
    
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
//---
   
  }
//+------------------------------------------------------------------+



//+------------------------------------------------------------------+
//|   CUSTOM FUNCTIONS                                               |
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


