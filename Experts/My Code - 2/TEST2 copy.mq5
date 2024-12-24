// include function 
#include <Trade/Trade.mqh>

// input functions


// Global Vars 
CTrade Trade;
int totalBars;
ulong ticketAddress;

// On Initialization
int OnInit(){
    totalBars = iBars(_Symbol, PERIOD_D1);
    return(INIT_SUCCEEDED);
}

// OnDeInitalization
void OnDeinit (const int reason){

}

// OnTick function 
void OnTick(){
    Print("WORKINGGGGGGGGGGGGGGGGGG");
}