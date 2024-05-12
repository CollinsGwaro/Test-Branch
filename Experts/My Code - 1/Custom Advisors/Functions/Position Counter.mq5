#property copyright "Copyright 2023, Collins Gwaro"
#property link      "TBD"
#property version   "1.00"

#include <Trade\Trade.mqh>
CTrade  trade;

static  input int         magicNumber = 24816;
        input double      lotSize     = 0.01;
        input double      stopLoss    = 100;
        input double      takeProfit  = 200;


int OnInit()
  {
    if(!(lotSize + stopLoss + takeProfit + magicNumber))
    {
      return(INIT_FAILED);
    }
    Print("INITIALIZATION SUCCESSFUL...");
    return(INIT_SUCCEEDED);
  }
  
void OnDeinit(const int reason)
  {
   
  }
  
void OnTick()
  {

    double  ask     = NormalizeDouble(SymbolInfoDouble(_Symbol, SYMBOL_ASK), _Digits);
    double  equity  = AccountInfoDouble(ACCOUNT_EQUITY);
    double  balance = AccountInfoDouble(ACCOUNT_BALANCE);

    int     total   = PositionsTotal();

    if(equity >=  balance &&  balance  > 50)
    {
      if(total <= 4)   //if the total positions of open trades are less than 5 
      {
        trade.Buy(lotSize, _Symbol, ask, ask - (stopLoss * _Point), ask + (takeProfit * _Point), "BUY TRADE...");
      }
    }
  }