//+------------------------------------------------------------------+
//|                                     CJ-Candle Pattern (Doji).mq5 |
//|PROPERTY                              Copyright 2023, COLLINS.cop |
//|                                                              TBD |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, COLLINS.cop"
#property link      "TBD"
#property version   "1.00"

//+------------------------------------------------------------------+
//|                        DEFINES                                   |
//+------------------------------------------------------------------+
//#define 

//+------------------------------------------------------------------+
//|                        INCLUDES                                  |
//+------------------------------------------------------------------+
#include <Trade\Trade.mqh>

//+------------------------------------------------------------------+
//|                        GLOBAL EXPERT OBJECTS                     |
//+------------------------------------------------------------------+
CTrade trade;

//+------------------------------------------------------------------+
//|                        INPUTS                                    |
//+------------------------------------------------------------------+

static input int    magicNumber    =   24816;
input double        lotSize        =   0.01;
input double        stopLoss       =   100;
input double        takeProfit     =   300;

//+------------------------------------------------------------------+
//|                        INITIALIZATION                            |
//+------------------------------------------------------------------+

int OnInit(){

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



//+------------------------------------------------------------------+
//|                        DE-INITIALIZATION                         |
//+------------------------------------------------------------------+
void OnDeinit(const int reason){

}

//+------------------------------------------------------------------+
//|                        ON-TICK FUNCTION                          |
//|         FUNCTION-EVENT HANDLERS (ON-TICK, TRADE, TIMER)          |
//+------------------------------------------------------------------+
void OnTick(){
    
    double ask = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);
    double equity = AccountInfoDouble(ACCOUNT_EQUITY);
    double balance = AccountInfoDouble(ACCOUNT_BALANCE);
    
    if(equity >= balance ){
        if(balance > 80) {
            trade.Buy(lotSize, Symbol(), ask, ask - (stopLoss*_Point), ask + (takeProfit*_Point), "BUY POSITION IMEINGIANA...");
        }        
    }
    
}

//+------------------------------------------------------------------+
//|                        CUSTOM FUNCTIONS                          |
//+------------------------------------------------------------------+
