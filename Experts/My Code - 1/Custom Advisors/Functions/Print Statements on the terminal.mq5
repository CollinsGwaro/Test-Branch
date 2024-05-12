//+------------------------------------------------------------------+
//|                                                      dispose.mq5 |
//|                                    Copyright 2023, Collins Gwaro |
//|                                                              TBD |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Collins Gwaro"
#property link      "TBD"
#property version   "1.00"
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
   double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   long spread = SymbolInfoInteger(_Symbol, SYMBOL_SPREAD);

   Comment(StringFormat("Ask price = %G \n  bid = %G\n   spread = %G\n", ask, bid, spread));
   
  }
  /*
  %n moves te cursor to the next line so that the different variables are not pprinted on te same line
  %G relates the comment in quotes with the first variable ask etc.
  */
  
