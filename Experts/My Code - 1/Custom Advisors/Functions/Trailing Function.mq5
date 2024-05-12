#property copyright "Copyright 2023, Collins Gwaro"
#property link      "TBD"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
#include <Trade\trade.mqh>

input group "MONEY MANAGEMENT";
  input double lotSize      = 0.01;
  input int stopLoss        = 300;
  input int takeProfit      = 1200;
  input int openTrades      = 2;
  input int trailingStopLoss= 100;
 
CTrade trade;

MqlRates bar[];
datetime newBar;


int OnInit()
  {
    ArraySetAsSeries(bar, true);

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
    // Collect the ask and bid prices of the current bars
    double ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
    double bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
    
    // Checks that a new bar is created
    CopyRates(_Symbol, PERIOD_CURRENT, 0, 5, bar);
    if (bar[0].time > newBar){
      Print(__FUNCTION__, " > New Bar Created");
      newBar = bar[0].time;

      // Checks that positions are not greater than the indiccated number
      if (PositionsTotal() < openTrades){
        Print(__FUNCTION__, " total positions = ", PositionsTotal());
        trade.Buy(lotSize, _Symbol, ask, ask - (stopLoss * _Point), ask + (takeProfit * _Point));        
        }
    }
      for (int i = PositionsTotal() - 1; i >= 0; i--) {       // initialize the ticket indexes (ID)
        ulong positionTicket = PositionGetTicket(i);          // Get the ticket number from the ticket index
        
        if(PositionSelectByTicket(positionTicket)){           // Select the ticket
          Print(__FUNCTION__, " Position ticket number: ", positionTicket);
          double positionStopLoss = PositionGetDouble(POSITION_SL);
          double positionTakeProfit = PositionGetDouble(POSITION_TP);
          double positionCurrentPrice = PositionGetDouble(POSITION_PRICE_CURRENT);

          double positionOpenPrice = PositionGetDouble(POSITION_PRICE_OPEN);
          double trailingSL = positionCurrentPrice - (trailingStopLoss * _Point); 

          // Check that the trailing sl condition has been triggered 
          if (positionCurrentPrice > positionOpenPrice + (stopLoss * _Point)){
            trade.PositionModify(positionTicket, trailingSL, positionTakeProfit);
            Print("POSITION MODIFIED ..........");
          }
        }
      }      
  }
//+------------------------------------------------------------------+
