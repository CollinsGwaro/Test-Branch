//+------------------------------------------------------------------+// PROPERTY
//|                                     CJ-Candle Pattern (Doji).mq5 |
//|PROPERTY                              Copyright 2023, COLLINS.cop |
//|                                                              TBD |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, COLLINS.cop"
#property link      "TBD"
#property version   "1.00"

//+------------------------------------------------------------------+// GLOBAL VARIABLES
//|                        DEFINES                                   |
//+------------------------------------------------------------------+
// For the NewBar function

MqlRates        bar[];
bool            newBar;
datetime        lastBarTime;
// For ...

//+------------------------------------------------------------------+// INCLUDES
//|                        INCLUDES                                  |
//+------------------------------------------------------------------+

#include <Trade\Trade.mqh>

//+------------------------------------------------------------------+// EXPERT OBJECTS
//|                        GLOBAL EXPERT OBJECTS                     |
//+------------------------------------------------------------------+

CTrade trade;

//+------------------------------------------------------------------+// INPUTS
//|                        INPUTS                                    |
//+------------------------------------------------------------------+

static input int    magicNumber    =   24816;
input double        lotSize        =   0.01;
input double        stopLoss       =   100;
input double        takeProfit     =   300;

// The TwoPositions function
input int   balanceOfTheAccount     =   80;
input int   numberOfTradesToOpen    =   2;

//+------------------------------------------------------------------+// INITIALIZATION FUNCTION 
//|                        INITIALIZATION                            |
//+------------------------------------------------------------------+

int OnInit(){
    ArraySetAsSeries(bar, true);                    // This code is for the NewBar function under the custom functions

    if (!magicNumber || magicNumber<=0){
        Print("INVALID MAGIC NUMBER");
        return(INIT_PARAMETERS_INCORRECT);
    }
    Print("SUCCESSFUL MAGIC_NUMBER INPUT");
    
    if(!lotSize){
        Print("INVALID LOT-SIZE PARAMETER...");
        return(INIT_PARAMETERS_INCORRECT);
    }
    Print("LOT SIZE IKO FITI");

    if(!stopLoss){
        Print("NO STOP-LOSS VALUE PARAMETER");
        return (INIT_PARAMETERS_INCORRECT);
    }
    Print("STOP LOSS IKO FITI");

    if (!takeProfit){
        Print("NO TAKE-PROFIT VALUE PARAMETER...");
        return(INIT_PARAMETERS_INCORRECT);
    }
    Print("TAKE PROFIT IKO FITI");

    Print("INITIALIZATION SUCCESSFUL...");
    return(INIT_SUCCEEDED);

}

//+------------------------------------------------------------------+// DE-INITIALIZATION FUNCTION
//|                        DE-INITIALIZATION                         |
//+------------------------------------------------------------------+

void OnDeinit(const int reason){

}

//+------------------------------------------------------------------+// ON-TICK FUNCTION
//|                        ON-TICK FUNCTION                          |
//|         FUNCTION-EVENT HANDLERS (ON-TICK, TRADE, TIMER)          |
//+------------------------------------------------------------------+

void OnTick()
{
    NewBarFunction();
}

//+------------------------------------------------------------------+// CUSTOM FUNCTIONS
//|                        CUSTOM FUNCTIONS                          |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+// NEW BAR FUNCTIONS
//|                        New Bar Function                          |
//+------------------------------------------------------------------+

int NewBarFunction()
{
    CopyRates(_Symbol, PERIOD_CURRENT, 0, 5, bar);
    if (bar[0].time > lastBarTime)
    {
        newBar = true;
        lastBarTime = bar[0].time;
    } else
    {
        newBar = false;
    }
// See if a new bar is created and call the TwoPositions function.
    if(newBar == true)
    {
        TwoPositions(numberOfTradesToOpen, balanceOfTheAccount);   // These parameters within this function comes from the global input variables and can be modified by the user to determine te amount of balance expected to close a trade and the number of open positions to allow the EA to open at a given time.  
    }
    return 1;
}

//+------------------------------------------------------------------+// TWO POSITIONS FUNCTION
//|                        2 positions open Function                 |
//+------------------------------------------------------------------+
// A function that opens only 2 positions at a time using the PositionsTotal() function

int TwoPositions(int howManyPositions, int accountBalance)
{
    double ask      = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);
    double equity   = AccountInfoDouble(ACCOUNT_EQUITY);
    double balance  = AccountInfoDouble(ACCOUNT_BALANCE);
    int total       = PositionsTotal();
    
    if(equity >= balance )
    {
        if(balance > accountBalance) 
        {
            if(total <=howManyPositions - 1)   //position counting starts at 0, hence 1 represents two positions. 
            {
                trade.Buy(lotSize, Symbol(), ask, ask - (stopLoss*_Point), ask + (takeProfit*_Point), "BUY POSITION IMEINGIANA...");
            }            
        }        
    }
    Print("Two positions set");
    return 1;
}