//+------------------------------------------------------------------+
//|                               insert indicatorinto the chart.mq5 |
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
  int indiName = IndicatorCreate(_Symbol,PERIOD_CURRENT, IND_ATR);
  IndicatorSetInteger(INDICATOR_DATA, 15); 


  bool chartAdd = ChartIndicatorAdd(0,0,indiName);
  if(chartAdd == false) {
    Print(__FUNCTION__" > failed in adding chart indicator");
  }
  Print(__FUNCTION__" > succeeded in adding chart indicator");
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
