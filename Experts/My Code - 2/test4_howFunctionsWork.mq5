

// GLOBAL VARIABLES
int newBar;
int totalBars;


int OnInit(){
    totalBars = 0;
    return (INIT_SUCCEEDED);
}

void OnDeinit(const int reason){

}

void OnTick(){
    
    int result = printTextFunction("THIS TEXT IS A DERIVATIVE OF THE CUSTOM FUNCTION");
    Print(result);

}

// CUSTOM FUNCTION

// A FUNCTION TO PRINT TEXT
int printTextFunction(string txt){
    Print("THIS FUNCTION PRINTS TEXTS.../col then "+ txt);

    return (1);
}