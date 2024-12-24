#property version "1.00"
#property strict

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
{
   //--- Get the previous daily candle
   double open = iOpen(Symbol(), PERIOD_D1, 1);
   double high = iHigh(Symbol(), PERIOD_D1, 1);
   double low = iLow(Symbol(), PERIOD_D1, 1);
   double close = iClose(Symbol(), PERIOD_D1, 1);

   //--- Check if the previous daily candle is bullish/green
   if(close > open)
   {
      //--- Open a buy trade
      int ticket = OrderSend(Symbol(), OP_BUY, 0.1, Ask, 3, Bid-10, Bid+10, "Buy Order", 0, 0, Green);
      if(ticket > 0)
      {
         Print("Buy order opened successfully. Ticket: ", ticket);
      }
      else
      {
         Print("Error opening buy order. Error code: ", GetLastError());
      }
   }
   //--- Check if the previous daily candle is red/bearish
   else if(close < open)
   {
      //--- Open a sell trade
      int ticket = OrderSend(Symbol(), OP_SELL, 0.1, Bid, 3, Ask+10, Ask-10, "Sell Order", 0, 0, Red);
      if(ticket > 0)
      {
         Print("Sell order opened successfully. Ticket: ", ticket);
      }
      else
      {
         Print("Error opening sell order. Error code: ", GetLastError());
      }
   }
}

// done  
