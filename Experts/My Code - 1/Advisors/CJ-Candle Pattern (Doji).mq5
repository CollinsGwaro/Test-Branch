//+------------------------------------------------------------------+
//|                                     CJ-Candle Pattern (Doji).mq5 |
//|                                      Copyright 2023, COLLINS.cop |
//|                                                              TBD |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, COLLINS.cop"
#property link      "TBD"
#property version   "1.00"

//+------------------------------------------------------------------+
//|   Defines                                                        |
//+------------------------------------------------------------------+
#define   No_Conditions 2     // The define preprocessor replaces all instances of No_Conditions with 2. Number of conditions in the EA  

//+------------------------------------------------------------------+
//|   Includes                                                       |
//+------------------------------------------------------------------+
#include  <Trade\Trade.mqh>   //This preprocessor replaces the line #include <file_name> with the content of the file WinUser32.mqh.
                              //The Trade preprocessor will help us open trade positions
                           
//+------------------------------------------------------------------+
//|   Global variables                                               |
//+------------------------------------------------------------------+
enum MODE{       // Enum is used to define a constant that stores related variables 
   OPEN   = 0,   // Open price
   HIGH   = 1,   // Highest price
   LOW    = 2,   // Lowest price
   CLOSE  = 3,   // Close price
   RANGE  = 4,   // Range; Distance between the high and the low in a candle (in points)
   BODY   = 5,   // Body; The absolute distance between the open and close price in a candle (in points)
   Ratio  = 6,   // (body/range); The ratio between the heights of the range and the body 
   VALUE  = 7    // specific value for a condition (i.e., the body of a pevious bar has to be greater than 100 points)
};

enum INDEX{       // Enum used to define a constant variable that stores related index values of bars
   INDEX_0  =0,   // CURRENT BAR: Represents the index no. for the current/active candle bar
   INDEX_1  =1,   // PREV 1: Represents the index for the previous bar behind the active candle
   INDEX_2  =2,   // PREV 2: Represents the index for the previous 2nd bar behind the active candle
   INDEX_3  =3    // PREV 3: Represents the index for the previous 3rd bar behind the active candle
};

enum COMPARE{     // Enum used to compare the conditions
   GREATER,       // Greater than 
   LESS           // Less than
};

struct CONDITION{   // Structure for storing values for ONE condition. A structure is a set of elements of any type (except type void). Thus, the structure combines logically related data of different types
   bool     active;      // is the condition active?
   MODE     modeA;       // Mode A; Uses the Enum Mode constant to add a function to this structure 
   INDEX    idxA;        // Index A
   COMPARE  comp;        // Compare
   MODE     modeB;       // Mode B; Uses the Enum Mode constant to add a function to this structure
   INDEX    idxB;        // Index B
   double   VALUE;
   
   CONDITION(): active(false){};
};

CONDITION Con[No_Conditions];    // Creating an array of conditions 
MqlTick  currentTick;            // Current tick of the symbol: contains informaton about the current tick such as the open and close price, time etc
CTrade   trade;                  // Object to open/close positions

//+------------------------------------------------------------------+
//|   Inputs                                                         |
//+------------------------------------------------------------------+

input group "========   GENERAL INPUTS =========";

static input long       InpMagicnumber =  24816;   // Number to identify trades to avoid confusion with other trade positions 
static input double     InpLots        =  0.01;    // No. of lots for the trade 
input int               InpStopLoss    =  100;     // Stop loss in points (0 means the SL function is off)
input int               InpTakeProfit  =  300;     // Take profit in points (0 means the TP function is off)

input group "========   CONDITION 1    =========";

input bool              InpCon1Active  = true;     // Active 
input MODE              InpCon1ModeA   = OPEN;      // Mode A
input INDEX             InpCon1IndexA  = INDEX_1;   // Index A
input COMPARE           InpCon1Compare = GREATER;   // Compare
input MODE              InpCon1ModeB   = OPEN;      // Mode B
input INDEX             InpCon1IndexB  = INDEX_1;   // Index B
input double            InpCon1Value   = 0;         // Value


input group "========   CONDITION 2    =========";

input bool              InpCon2Active  = false;     // Active 
input MODE              InpCon2ModeA   = OPEN;      // Mode A
input INDEX             InpCon2IndexA  = INDEX_1;   // Index A
input COMPARE           InpCon2Compare = GREATER;   // Compare
input MODE              InpCon2ModeB   = OPEN;      // Mode B
input INDEX             InpCon2IndexB  = INDEX_1;   // Index B
input double            InpCon2Value   = 0;         // Value
 
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
// Set inputs (before we check the inputs)
   SetInputs();
   
   // Check the inputs, if the inputs fail, the initialization will have failed and the EA will not start
   if(!CheckInputs()){return INIT_PARAMETERS_INCORRECT;}
   
   // Set Magic Number for our trade objects
   trade.SetExpertMagicNumber(InpMagicnumber);
   
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {

  };
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {

// Check if the current tick is a new bar tick
if(!IsNewBar()) {
   Print("NEW BAR NOT CREATED");
   return;
}

// Get current symbol tick
if(!SymbolInfoTick(_Symbol, currentTick)){
   Print("FAILED TO GET CURRENT TICK");
   return;
}

// Count open positions
int countBuy, countSell;
if(!CountOpenPositions(countBuy, countSell)){
   Print("FAILED TO COUNT OPEN POSITIONS");
   return;
}

// Check for new buy position
if(countBuy == 0) {
   // Calculate SL and TP
   double sl = InpStopLoss == 0 ? 0 : currentTick.bid - InpStopLoss * _Point;
   double tp = InpTakeProfit == 0 ?  0: currentTick.bid + InpTakeProfit * _Point;
   if(!NormalizePrice(sl)) {
      return;
   }
   if(!NormalizePrice(tp)) {
      return;
   }

   trade.PositionOpen(_Symbol, ORDER_TYPE_BUY, InpLots, currentTick.ask, sl, tp, "CJ CANDLEPATTERN EXPERT ADVISOR");
}

// Check for new sell position
if(countSell == 0) {
   // Calculate SL and TP
   double sl = InpStopLoss == 0 ? 0 : currentTick.ask + InpStopLoss * _Point;
   double tp = InpTakeProfit == 0 ? 0 : currentTick.ask - InpTakeProfit * _Point;
   if(!NormalizePrice(sl)) {
      return;
   }
   if(!NormalizePrice(tp)) {
      return;
   }

   trade.PositionOpen(_Symbol, ORDER_TYPE_SELL, InpLots, currentTick.bid, sl, tp, "CJ CANDLEPATTERN EXPERT ADVISOR");
}

  }

//+------------------------------------------------------------------+
//|    Custom Functions                                              |
//+------------------------------------------------------------------+
   void  SetInputs(){
      
      // Condition 1
      Con[0].active     =  InpCon1Active;
      Con[0].modeA      =  InpCon1ModeA;
      Con[0].idxA       =  InpCon1IndexA;
      Con[0].comp       =  InpCon1Compare;
      Con[0].modeB      =  InpCon1ModeB;
      Con[0].idxB       =  InpCon1IndexB;
      Con[0].VALUE      =  InpCon1Value;
      
       // Condition 2
      Con[1].active     =  InpCon2Active;
      Con[1].modeA      =  InpCon2ModeA;
      Con[1].idxA       =  InpCon2IndexA;
      Con[1].comp       =  InpCon2Compare;
      Con[1].modeB      =  InpCon2ModeB;
      Con[1].idxB       =  InpCon2IndexB;
      Con[1].VALUE      =  InpCon2Value;
      
   } 
   
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//   
  bool CheckInputs(){      // This function, as initially described, checks that the inputs have been entered before the EA initializes. if the inputs have not been entered, the EA fails and does not start.
   if (!(InpMagicnumber > 0)) {
      Alert("Wrong Input: Magic Number is not valid");
      return false;
   }

   if (!(InpLots > 0)) {
      Alert("Wrong Input: Lots is not valid");
      return false;
   }

   if (!(InpStopLoss >= 0)) {
      Alert("Wrong Input: Stop Loss is not valid");
      return false;
   }

   if (!(InpTakeProfit >= 0)) {
      Alert("Wrong Input: Take Profit is not valid");
      return false;
   }
   
   // Also add check for condition +++
      
   return true;
   
  }  

//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
// This function Checks if we have a new bar open tick
bool IsNewBar(){

   static datetime      PreviousTime   =  0;
   datetime             CurrentTime    =  0;
   if(PreviousTime != CurrentTime){
      PreviousTime =  CurrentTime;
      return true;
   }
   return false;
}

//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
// This function counts open positions
bool CountOpenPositions(int &countBuy, int &countSell){

   countBuy    =0;
   countSell   =0;
   int total   =PositionsTotal();
   for (int i=total-1; i>=0; i--){
      
      ulong ticket = PositionGetTicket(i);      //The function, PositionGetTicket, returns the ticket of a position with the specified index in the list of open positions 
      if(ticket <=0){
         Print("FAILED TO GET TICKET POSITION");
         return false;
         }

      if(!PositionSelectByTicket(ticket)) {
            Print("FAILED TO SELECT POSITION");
            return false;
      }

      long magic;
      if(!PositionGetInteger(POSITION_MAGIC, magic)){
         Print("FAILED TO GET POSITION MAGIC NUMBER");
         return false;
      }
      
      if(magic == InpMagicnumber){
         long type;
         if(!PositionGetInteger(POSITION_TYPE, type)) {
            Print("FAILED TO GET POSITION TYPE");
            return false;
         }
         
         if(type == POSITION_TYPE_BUY){
            countBuy++;
         }
         
         if(type == POSITION_TYPE_SELL){
            countSell++;
         }
      }
   }
   return true;
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------//
// Normalize prize/ Rounding off the price value to a whole number or sort of
bool NormalizePrice(double &price){                                       // The object, NormalizeDouble, is for Rounding floating point number to a specified accuracy
   
   double tickSize   =0;
   if(!SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE, tickSize)){       // The _Symbol variable contains the symbol name of the current chart. // This object, SymbolInfoDouble, Returns the corresponding property of a specified symbol
      Print("FAILED TO GET TICK SIZE");                           
      return false;
   }   
   price = NormalizeDouble(MathRound(price/tickSize)*tickSize, _Digits);   // The object, NormalizeDouble, is for Rounding floating point number to a specified accuracy
   
   return true;
}