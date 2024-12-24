//include
#include <Trade/Trade.mqh>

//global variables
CTrade trade;
int totalBars;
ulong ticketAddress;

//On-Init
int OnInit()
  {
   totalBars = iBars(_Symbol, PERIOD_D1);
   return(INIT_SUCCEEDED);
  }

//OnDeinit
void OnDeinit(const int reason)
  {
  }

//On-Tick
void OnTick()
  {
   int bars = iBars(_Symbol, PERIOD_D1);
   if(bars > totalBars)
     {
      Print("NUMBER OF BARS CHANGED TO ", bars);
      totalBars = bars;

      trade.PositionClose(ticketAddress);

      double equity   = AccountInfoDouble(ACCOUNT_EQUITY);
      double balance  = AccountInfoDouble(ACCOUNT_BALANCE);
      double ask      = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);

      if(equity >= balance)
        {
         trade.Buy(0.1);
         ticketAddress = trade.ResultOrder();
         Print("TICKET ADDRESS IS ", ticketAddress);
        }
     }
  }

//+------------------------------------------------------------------+
