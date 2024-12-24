#include <Trade/Trade.mqh>

// Global Variables
int totalBars;
CTrade trade;
ulong ticketAddress;

// Function to manage trades (only one trade allowed at a time)
void ManageTrades() {
    // Close any open position for the symbol
    if (PositionSelect(_Symbol)) {
        trade.PositionClose(_Symbol);
        Print("CLOSED EXISTING POSITIONS.");
    }

    // Get the open and close prices of the previous daily candle
    double open  = iOpen(_Symbol, PERIOD_D1, 1);
    double close = iClose(_Symbol, PERIOD_D1, 1);

    // Open a new trade based on the last candle's color
    if (open > close) {
        Print("THE LAST D1 CANDLE IS RED");
        if (trade.Sell(0.1)) {
            ticketAddress = trade.ResultOrder();
            Print("OPENED SELL TRADE; TICKET NUMBER  = ", ticketAddress);
        }
    } else if (open < close) {
        Print("THE LAST D1 CANDLE IS GREEN");
        if (trade.Buy(0.1)) {
            ticketAddress = trade.ResultOrder();
            Print("OPENED BUY TRADE; TICKET NUMBER = ", ticketAddress);
        }
    }
}

// Initialization function
int OnInit() {
    totalBars = iBars(_Symbol, PERIOD_D1);
    return (INIT_SUCCEEDED);
}

// OnTick function (calls the custom ManageTrades function)
void OnTick() {
    int bars = iBars(_Symbol, PERIOD_D1);

    // Check if a new bar has been formed
    if (totalBars < bars) {
        Print("THE NUMBER OF BARS CHANGED TO ", bars);
        totalBars = bars;

        // Call the custom function to manage trades
        ManageTrades();
    }
}

void OnDeinit(const int reason) {
    // Optional cleanup code can go here
}
