#property copyright "Copyright 2023, Collins Gwaro"
#property link      "TBD"
#property version   "1.00"


// Importation of the Library file which contain the custom functions 
#import "MyLibrary.ex5"
  int newBar_FUNCTION();          // calling the specific function
#import



void OnTick()
  { 
    newBar_FUNCTION();
  }


/*
//+------------------------------------------------------------------+
//|     GLOBAL VARIABLES                                             |
//+------------------------------------------------------------------+
// newBar_Function
MqlRates bar[];
datetime lastBarTime;

// initialization function
int OnInit()  
  {
    ArraySetAsSeries(bar, true);
      //this array reverses the order of counting of the candle bars so that the curret bar starts at 0.
    return(INIT_SUCCEEDED);
  }

int newBar_FUNCTION()export
  {
    CopyRates(_Symbol, PERIOD_CURRENT, 0, 5, bar);
    if(bar[0].time > lastBarTime){
      lastBarTime = bar[0].time;
      Print(__FUNCTION__, "> NEW BAR CREATED/ Library file");
      return 1;
    }
    return 0;
  }
*/