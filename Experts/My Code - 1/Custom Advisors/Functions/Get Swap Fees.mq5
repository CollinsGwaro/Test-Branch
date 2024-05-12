void OnTick()
  {
    double longTradeSwap = SymbolInfoDouble(_Symbol, SYMBOL_SWAP_LONG);
    double shortTradeSwap = SymbolInfoDouble(_Symbol, SYMBOL_SWAP_SHORT);

    Comment
    (
      "long trades swap fee:", longTradeSwap, "\n", 
      "short trade swap fees:", shortTradeSwap
    );  
  }
  