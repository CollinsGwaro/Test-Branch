//+------------------------------------------------------------------+
//|                                               SendTGmessages.mq5 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart(){
    string text = "WELCOME TO MY BOT";
    string ChatID = "-1002414522902";
    string botToken = "7252623056:AAHBZ-IB_BdMkiPOnCQVC2GRCjjv_XSZ3sY";

    Alert(sendMesseges(text, ChatID, botToken));

}

// CUSTOM FUNCTIONS 
int sendMesseges(string text, string chatID, string botToken){

    string baseUrl          = "https://api.telegram.org";
    string header           = "";
    string requestURL       = "";
    string requestHeaders   = "";
    char resultData[];
    char positionData[];
    int timeOut             = 2000;

    requestURL = StringFormat("%s/bot%s/sendmessage?chat_id=%s&text=%s", baseUrl, botToken, chatID, text);

    int response = WebRequest("POST", requestURL, header, timeOut, positionData, resultData, requestHeaders);
    
    string resultMessage = CharArrayToString(resultData);

    Print(resultMessage);

    return response;


}