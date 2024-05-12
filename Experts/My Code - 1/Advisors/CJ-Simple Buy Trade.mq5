/*
*This EA is simply for opening buy trades based on one condition
*The condition is that if the Equity is equal to or greater than the account balance,
    a buy trade is excecuted. 
*/
#property copyright "Copyright 2023, Collins.cop."
#property link      "TBD"
#property version   "1.00"
#property description "This EA is simply for opening buy trades based on one condition"
#property description "The condition is that if the Equity is equal to or greater than the account balance"
#property description "a buy trade is excecuted."

#include<Trade\Trade.mqh>
CTrade Trade;


void OnTick() //this is the trade function
{
    double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);//Get the Ask price of the pair     
    double Balance=AccountInfoDouble(ACCOUNT_BALANCE);//get the account balance     
    double Equity=AccountInfoDouble(ACCOUNT_EQUITY); //get the account equity

    if(Equity >= Balance) //Condition//if the account equity is greater than or equal to the account balance
    /*
   bool  Buy( 
   double        volume,          // position volume 
   const string  symbol=NULL,     // symbol 
   double        price=0.0,       // execution price 
   double        sl=0.0,          // stop loss price 
   double        tp=0.0,          // take profit price 
   const string  comment=""       // comment 
   )
   */
    Trade.Buy(0.01, NULL, Ask ,(Ask -100 * _Point), (Ask+100 * _Point), "I BOUGHT HERE"); //This function places a buy trade when the conditions have been met

}
/*
WHY YOU CANNOT USE THIS EXPERT ADVISOR
    .The condition for trade excecution is amurture
    .It has no Money management strategy (account management)
    .It only has Buy trade signal, no sell signal or any other trading signals
*/