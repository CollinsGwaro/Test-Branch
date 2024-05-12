input double shortShadowRatio = 0.1;
input double longShadowToBodyRatio  = 3.0;

void OnTick()
{
  hammerPattern(longShadowToBodyRatio, shortShadowRatio);
}

// Custom functions
//........................................................................................................................................................
bool hammerPattern(double bodyTimesRatio, double shortShadowTimesCandleSize)
{
  double  high  = iHigh(_Symbol, PERIOD_CURRENT, 1);
  double  low   = iLow(_Symbol, PERIOD_CURRENT, 1);
  double  open  = iOpen(_Symbol, PERIOD_CURRENT, 1);
  double  close = iClose(_Symbol, PERIOD_CURRENT,1);

  double  candleSize  = high - low;

  datetime time       = iTime(_Symbol, PERIOD_CURRENT, 1);

// UpperTrend reversal
  // Green hammer
    if(close > open)    {
      if((high - close) >= bodyTimesRatio*(close - open))      {
        if((open - low) <= shortShadowTimesCandleSize*candleSize)        {
          Create_Object(time, high, 226, clrRed, true);
          return true;
        }
      }
    }

    // Red hammer
    else if(open  > close)    {
      if((high - open) >= bodyTimesRatio*(open - close))      {
        if((close - low) <= shortShadowTimesCandleSize * candleSize)        {
          Create_Object(time, high, 226, clrRed, true);
          return true;
        }
      }
    }
  // LowerTrend reversal
    // Green hammer
    if(close  > open)    {
      if((open - low) >= bodyTimesRatio*(close - open))      {
        if((high - close) <= shortShadowTimesCandleSize * candleSize)  {
          Create_Object(time, low, 225, clrGreen, true);
          return true;
        }
      }
    }

    // Red hammer
    else if(open  > close)    {
      if((close - low) >= bodyTimesRatio*(open - close))      {
        if((high - open) <= shortShadowTimesCandleSize * candleSize)        {
          Create_Object(time, low, 225, clrGreen, true);
          return true;
        }
      }
    }

  return false;
}

//........................................................................................................................................................
// Creating a function that creates buy and sell arrows in the chart
void Create_Object(datetime time, double price, int arrowCode, color clr, bool bck)
{
  
  string objName  =  "";
  StringConcatenate(objName, time, price, "THISS");
  if(ObjectCreate(0, objName, OBJ_ARROW, 0, time, price))
  {
    ObjectSetInteger(0, objName, OBJPROP_ARROWCODE, arrowCode);
    ObjectSetInteger(0, objName, OBJPROP_COLOR, clr);
    ObjectSetInteger(0, objName, OBJPROP_BACK, bck);
  }
  
}