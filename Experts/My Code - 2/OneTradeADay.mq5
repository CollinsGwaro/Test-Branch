#include <Trade/Trade.mqh>

//declaring the GLOBAL VARIABLES
int totalBars;
CTrade trade;
ulong ticketAddress;

int OnInit(){   
   totalBars = iBars(_Symbol, PERIOD_D1);
   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason){
}

void OnTick(){
   int bars = iBars(_Symbol, PERIOD_D1);
   if(totalBars < bars) {
      Print("THE NUMBER OF BARS CHANGED TO ", bars);
      totalBars = bars;

      //close the open position wrt the ticket number 
      trade.PositionClose(ticketAddress);

      //check the prices of the open and close price 
      double open    = iOpen(_Symbol, PERIOD_D1, 1);
      double close   = iClose(_Symbol, PERIOD_D1, 1);

      //Opening the trades
      if(open > close){
         Print("The last D1 candle is red");
         trade.Sell(0.1);
         ticketAddress = trade.ResultOrder();
         Print("Ticket Number = ", ticketAddress);
      }else if(open < close){
         Print("The last D1 candle is green");
         trade.Buy(0.1);
         ticketAddress = trade.ResultOrder();
         Print("Ticket Number = ", ticketAddress);
      }
   }
}

