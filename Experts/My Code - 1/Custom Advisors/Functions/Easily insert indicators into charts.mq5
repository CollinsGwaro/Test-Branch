//+------------------------------------------------------------------+
//|   INCLUDE                                                        |
//+------------------------------------------------------------------+
#include <Trade\trade.mqh>



//+------------------------------------------------------------------+
//|   INPUTS                                                         |
//+------------------------------------------------------------------+
input int inpFastMA = 10;
input int inpSlowMA = 50;

input int inpATR    = 14;


//+------------------------------------------------------------------+
//|    GLOBAL VARIABLES                                              |
//+------------------------------------------------------------------+
CTrade trade;      // Trade expert advisor
int fastHandle;      // MA function variables 
int slowHandle;      

double fastBuffer[];
double slowBuffer[];

int atrHandle;       //For ATR indicator
double atrBuffer[];



//+------------------------------------------------------------------+
//|     INITIALIZATION                                               |
//+------------------------------------------------------------------+
int OnInit(){
  
   // Check the inputs 
   if (inpFastMA >= inpSlowMA || inpFastMA <=0 || inpSlowMA <=0) {
   Print(__FUNCTION__, "Invalid inputs");
   return (INIT_FAILED);
   }
  
   // Check the indicator handles 
   ArraySetAsSeries(fastBuffer, true);
   ArraySetAsSeries(slowBuffer, true);
   
   fastHandle = iMA(_Symbol,PERIOD_CURRENT,inpFastMA,0,MODE_SMA,PRICE_CLOSE);
   slowHandle = iMA(_Symbol,PERIOD_CURRENT,inpSlowMA,0,MODE_SMA,PRICE_CLOSE);
   
   atrHandle = iATR(_Symbol, PERIOD_CURRENT, inpATR);
   
      if (fastHandle == INVALID_HANDLE || slowHandle == INVALID_HANDLE || atrHandle == INVALID_HANDLE){
      
      Print(__FUNCTION__, "INITIALIZATION FAILED");
      return (INIT_FAILED);
   }
   return (INIT_SUCCEEDED);
}




//+------------------------------------------------------------------+
//|     ON-TICK FUNCTION                                             |
//+------------------------------------------------------------------+
void OnTick(){

}

