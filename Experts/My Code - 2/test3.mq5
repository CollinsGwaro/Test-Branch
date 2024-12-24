// INCLUDE SECTION
#include <Trade/Trade.mqh>

// GLOBAL VARIABLES
CTrade trade;
int numBars;
ulong ticketNumber;
ulong ticketCounter;
int counter;

// ON-INITIALIZATION
int OnInit(){
    numBars = iBars(_Symbol,PERIOD_D1);
    ticketCounter = 0;
    counter = 0;
    return (INIT_SUCCEEDED);
}

// ON-DEINITIALIZATION
void OnDeinit(const int reason){

}

// ON-TICK
void OnTick(){
    int bars = iBars(_Symbol, PERIOD_D1);
        
    
    if (numBars < bars)
    {
        Print("NUMBER OF CANDLES CHANGED TO ", bars);
        numBars = bars;

        // CANDLE COLOR CHECK
        double open = iOpen(_Symbol,PERIOD_D1, 1);
        double close = iClose(_Symbol, PERIOD_D1, 1);
        
        Print("COUNTER BEFORE IS ", counter);

        if (open < close)
        {
            Print("GREEN BAR");
            trade.Buy(0.1);
            ticketNumber = trade.ResultOrder();
            Print("TICKET NUMBER IS ", ticketNumber);
            counter ++;
            Print("COUNTER AFTER IS ", counter);
        }else if (close < open)
        {
            Print("RED BAR");
            trade.Sell(0.1);
            ticketNumber = trade.ResultOrder();
            Print("TICKET NUMBER IS ", ticketNumber);  
            counter ++;
            Print("COUNTER AFTER IS ", counter);

        }    
        // COUNTING THE NUMBER OF TICKETS
        ticketCounter = ticketNumber;
    }
}

// CUSTOM FUNCTIONS 
