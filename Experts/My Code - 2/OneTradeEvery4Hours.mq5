#include <Trade/Trade.mqh>

// Global variables and objects
CTrade trade;
datetime lastTradeTime = 0; // Track the time of the last trade
ulong ticketNumber; // Store the ticket number for the opened trade

// Function to manage trades
void ManageTrades() {
    // Get the current account balance
    double accountBalance = AccountInfoDouble(ACCOUNT_BALANCE);

    // Calculate stop loss and take profit
    double sl = 0.02 * accountBalance;  // 2% of balance as SL
    double tp = 0.06 * accountBalance;  // 6% of balance as TP

    // Check if 4 hours have passed since the last trade
    if (TimeCurrent() >= lastTradeTime + 4 * 3600) {
        // Close any open position
        if (PositionSelect(_Symbol)) {
            trade.PositionClose(_Symbol);
            Print("Closed existing position.");
        }

        // Get the open and close prices of the last 1-hour candle
        double openPrice = iOpen(_Symbol, PERIOD_H1, 1);
        double closePrice = iClose(_Symbol, PERIOD_H1, 1);

        // Open a new trade based on the last candle
        if (closePrice > openPrice) {
            Print("The last 1-hour candle is green. Opening Buy Trade...");
            if (trade.Buy(0.1, _Symbol, 0, sl, tp)) {
                ticketNumber = trade.ResultOrder();
                Print("Buy trade opened. Ticket Number: ", ticketNumber);
            }
        } else if (closePrice < openPrice) {
            Print("The last 1-hour candle is red. Opening Sell Trade...");
            if (trade.Sell(0.1, _Symbol, 0, sl, tp)) {
                ticketNumber = trade.ResultOrder();
                Print("Sell trade opened. Ticket Number: ", ticketNumber);
            }
        }

        // Update the last trade time
        lastTradeTime = TimeCurrent();
    } else {
        Print("4 hours have not passed since the last trade. No new trade opened.");
    }
}

// OnInit function: Initialize global settings
int OnInit() {
    Print("EA initialized..............");
    lastTradeTime = TimeCurrent() - 4 * 3600;  // Ensure it can trade immediately
    return (INIT_SUCCEEDED);
}

// OnTick function: Calls the custom trade management function
void OnTick() {
    ManageTrades();
}

void OnDeinit(const int reason) {
    Print("EA de-initialized..................");
}
