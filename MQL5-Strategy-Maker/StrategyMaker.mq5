//+------------------------------------------------------------------+
//|                                             ScalpingPosition.mq5 |
//|                                                   Giovani Merlin |
//|                                         gbm1996gbm1996@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Giovani Merlin"
#property link      "gbm1996gbm1996@gmail.com"
#property version   "1.2"
#property icon "\\Images\\StrategyMaker.ico";

#include <Controls\Dialog.mqh>
#include <Controls\Label.mqh>
#include <Controls\Button.mqh>
#include <ChartObjects\ChartObjectsLines.mqh>
#include <Trade\AccountInfo.mqh>
#include <Trade\Trade.mqh>
#include <Controls\RadioGroup.mqh>
#include <Controls\ComboBox.mqh>



// cur_price nao importa, todas estrategias vem do script inicial que pega os valores
// e então faz a operação, eu capto do click do usuario, após entrar foda-se usuario!

//    DEFENSE É RIDICULO, foda-se ele. Acumlation Attack deixa pra futuro, já ta bom de estrategias. termina saporra.


// LINHA DE AÇÃO :

//   Tem erro dos lotes geometric e pa no label. se tem volatilidade da erro se from price = stop level, ver se manange erro
// ou simplesmente ces't la vie e fala isso na venda. Resto ta tudo mt topper

//   6º FAZ ARTE E POSTA POR 100 DOLAR A VERSÃO BETA.

//    CRIAR VERIFICAÇÃO PRA VER SE O PLAYER FDP PODE OPERAR (TEM MARGEM) e dando em relação a quantos levels pode ter -> FUTURO
//    VIEW -> FUTURO 
//    ON -> FUTURO (ou substitui por outro button q ja tem os bang)
//    Linha que ta cur_price e mexe nela muda o cur_price -> futuro
//    Linhas que vao mostrar onde vai tudo os lotes -> futuro
//    Lotes pro grid -> futuro (pra poder ter lotes inicias diferente)
     



     
//| Resources                                                        

  #resource "\\Include\\Controls\\res\\RadioButtonOn.bmp"
  #resource "\\Include\\Controls\\res\\RadioButtonOff.bmp"
  #resource "\\Include\\Controls\\res\\CheckBoxOn.bmp"
  #resource "\\Include\\Controls\\res\\CheckBoxOff.bmp"
  #resource "\\Include\\Controls\\res\\SpinInc.bmp"
  #resource "\\Include\\Controls\\res\\SpinDec.bmp"
//
//-- Panel Create 
    //MULTIPLER
    //GainBoleta,
    // USAVEIS

    //Editaveis
      // cur_price = PriceForOperate.Text());
      // cur_lot= Lots.Text()); -> E A PORRA DO LOTS NIVEIS, DUPLIQUEI COM CUR_LOTS
      // Niveis = LevelsP.Text());
      // Multipler = MultiplerEd.Text());
      // Gain = TicksGainP.Text());
      // Ticks = TicksLossP.Text());
      // FromPrice = FromPriceP.Text());
      // Loss = StopBoletaPE.Text());
      // Slippage = SlippageP.Text());
      // LossMoney = StopFinanceiroP.Text());
      // magic = MagicP.Text());
      // GainMoney = GainFinanceiroP.Text());

      
    //Buttons
        //StopBoleta -> StopBoletaP button
        //GainFinanceiro ->  GainFinanceiroButtonP button
        //Follow -> FollowBP button
        //StopFinanceiro -> StopFinanceiroButtonP 
        // ONCONTROL ->  BotOn button
        // ViewLines -> View button

    //Group
        // mode -> InvestGroup
        // acumulation = "ARITMETIC" "LINEAR" "GEOMETRIC" -> LotesGroup


  class CEdit_new : public CEdit
      {
    public:
                        CEdit_new(void){};
                        ~CEdit_new(void){};
      virtual bool      Save(const int file_handle)
        {
          if(file_handle==INVALID_HANDLE)
            {
            return false;
            }
          string text=Text();
          FileWriteInteger(file_handle,StringLen(text));
          return(FileWriteString(file_handle,text)>0); 
        }
      virtual bool      Load(const int file_handle)
        {
          if(file_handle==INVALID_HANDLE)
            {
            return false;
            }
          int size=FileReadInteger(file_handle);
          string text=FileReadString(file_handle,size);
          return(Text(text));
        }
      
      };

  class CBmpButton_new : public CBmpButton
      {
    public:
                        CBmpButton_new(void){};
                        ~CBmpButton_new(void){};
      virtual bool      Save(const int file_handle)
        {
        if(file_handle==INVALID_HANDLE)
            {
            return false;
            }
          return(FileWriteInteger(file_handle,Pressed()));
        }
      virtual bool      Load(const int file_handle)
        {
          if(file_handle==INVALID_HANDLE)
            {
            return false;
            }
          return(Pressed((bool)FileReadInteger(file_handle)));
        }
      };

      class CComboBox_new : public CComboBox
      {
    public:
                        CComboBox_new(void){};
                        ~CComboBox_new(void){};
      virtual bool      Save(const int file_handle)
        {
        if(file_handle==INVALID_HANDLE)
            {
            return false;
            }
          return(FileWriteInteger(file_handle,Value()));
        }
      virtual bool      Load(const int file_handle)
        {
          if(file_handle==INVALID_HANDLE)
            {
            return false;
            }
          return(SelectByValue(FileReadInteger(file_handle)));
        }
      };


  class CTradePanel : public CAppDialog
    {
   private:
    
    #define  Y_STEP   (int)(ClientAreaHeight()/18/3)      // height step betwine elements
    #define  Y_WIDTH  (int)(ClientAreaHeight()/14)        // height of element
    #define  BORDER   (int)(ClientAreaHeight()/22)        // distance betwine boder and elements
    #define  SL_Line_color  clrRed                        // Stop Loss lines color
    #define  TP_Line_color  clrGreen                      // Take Profit lines color
              
    enum label_align
      {
        left=-1,
        right=1,
        center=0
      };


    CLabel            Compra,Venda,MB,MS;
    CLabel            On;
    CLabel            BuyLevel,SellLevel;
    CLabel            ASK, BID;                        // Display Ask and Bid prices
    CLabel            Moeda;
    CLabel            Moeda2;
    CLabel            ShowLevels;                      // Display label "Show"
    // CLabel            FollowP;
    CLabel            MultiplerPL;
    // CBmpButton_new    FollowBP;
    CEdit_new         Lots;                            // Display volume of next order
    CEdit_new         PriceForOperate;                      // Display Risk in account currency
    CEdit_new         MagicP;
    CEdit_new         SlippageP;
    CBmpButton_new    StopBoletaP;
    CBmpButton_new    StopFinanceiroButtonP;
    CEdit_new         StopFinanceiroP;
    CEdit_new         GainFinanceiroP;
    CEdit_new         LevelsP;
    CEdit_new         MultiplerEd;
    CBmpButton_new    GainFinanceiroButtonP;
    CBmpButton_new    BotOn;                            //habilita a estrategia
    CBmpButton_new    View;                            //Ve as ordens antes de bota
    CLabel            MagicPL;
    CLabel            SlippagePL;
    CLabel            StopBoletaPL;
    CLabel            StopFinanceiroPL;
    CLabel            TicksGainPL;
    CLabel            TicksLossPL;
    CLabel            FromPricePL;
    CLabel            LevelsLP;
    CLabel            ViewL;
    CLabel            GainFinanceiroPL;
    CBmpButton_new    StopLoss_line;                   // Check to display StopLoss Line
    CBmpButton_new    TakeProfit_line;                 // Check to display TakeProfit Line
    CBmpButton_new    Increase,Decrease; 
    CBmpButton_new    IncreasePrice,DecreasePrice;              // Increase and Decrease buttons
    CButton           SELL,BUY,CloseOrders;                        // Sell and Buy Buttons
    CButton           SELLPENDENT,BUYPENDENT,CloseAll;     // Close buttons
    CChartObjectHLine BuySL, SellSL, BuyTP, SellTP;    // Stop Loss and Take Profit Lines
    //---
   // CAccountInfo      AccountInfo;                     // Class to get account info
    //CTrade            Trade;                           // Class of trade operations
    
    //--- variables of current values

    
    //--- Create Label object
    bool              CreateLabel(const long chart,const int subwindow,CLabel &object,const string text,const uint x,const uint y,label_align align);
    //--- Create Button
    bool              CreateButton(const long chart,const int subwindow,CButton &object,const string text,const uint x,const uint y,const uint x_size,const uint y_size);
    //--- Cleate Edit object
    bool              CreateEdit(const long chart,const int subwindow,CEdit &object,const string text,const uint x,const uint y,const uint x_size,const uint y_size);
    //--- Create BMP Button
    bool              CreateBmpButton(const long chart,const int subwindow,CBmpButton &object,const uint x,const uint y,string BmpON,string BmpOFF,bool lock);
    //--- Create Horizontal line
    // bool              CreateHLine(long chart, int subwindow,CChartObjectHLine &object,color clr, string comment);
    //---             
    bool              CreateRadioGroup(const long chart,const int subwindow,CRadioGroup &object,const uint x,const uint y,const uint x_size,const uint y_size,int tipo);
    //--
    bool              CreateComboBox(const long chart,const int subwindow,CComboBox &object,const uint x,const uint y,const uint x_size,const uint y_size,int tipo);
    //--- On Event functions
    
    void              LotsEndEdit(void);                              // Edit Lot size
     void              IncreaseLotClick();                             // Click Increase Lot
     void              DecreaseLotClick();                             // Click Decrease Lot
    // void              StopLossLineClick();                            // Click StopLoss Line 
    // void              TakeProfitLineClick();                          // Click TakeProfit Line
    void              BuyClick();                                     // Click BUY button
    void              SellClick();                                    // Click SELL button
    void              CloseBuyClick();                                // Click CLOSE BUY button
    void              CloseSellClick();                               // Click CLOSE SELL button
    void              CloseClick();                                   // Click CLOSE ALL button
    
    void              PriceEndEdit(void);
    void              IncreasePriceClick(void);
    void              DecreasePriceClick(void);
    void              MagicEndEdit();        
    void              StopMoneyEndEdit(void);
    void              GainMoneyEndEdit(void);
    void              SlippageEndEdit(void);
    void              GainEndEdit(void);
    void              FromPriceEndEdit(void);
    void              TicksLossEndEdit(void);
    void              LossEndEdit(void);
    void              LevelsEndEdit(void);

    void              StopBoletaClick(void);
    void              GainFinanceiroClick(void);
    void              StopFinanceiroClick(void);
    void              MultiplerEndEdit(void);

    void              BuyPendentClick(void);
    void              SellPendentClick(void);
    void              CloseOrdersClick(void);

    void              ViewClick(void);
    void              BotOnClick(void);
    
    void              InvestClick(void); 
    void              LotsClick(void);

    //--- Correction value functions
     double            NormalizeLots(double lots);
     double            NormalizePrice(double price);  
     double            NormalizeMoney(double money);                   // Normalize lot's size
    // void              UpdateSLLines(void);                            // Calculate SL prices and modify lines
    // void              UpdateTPLines(void);                            // Calculate TP prices and modify lines
    
   public:
                      CTradePanel(void);
                      ~CTradePanel(void){};
    //--- Create function
    virtual bool      Create(const long chart,const string name,const int subwin=0,const int x1=20,const int y1=20,const int x2=320,const int y2=520);
    virtual void      OnTick(void);
    virtual bool      OnEvent(const int id,const long &lparam, const double &dparam, const string &sparam);
    virtual bool      Run(void);
    // virtual bool      DragLine(string name);
    virtual void      Destroy(const int reason);

    CEdit_new         StopBoletaPE;
    CEdit_new         FromPriceP;
    CEdit_new         TicksGainP;
    CEdit_new         TicksLossP;
    CComboBox_new       TrendGroup,AcumulationGroup;
    CComboBox_new       InvestGroup;
    CComboBox_new       LotesGroup;          // pau no cu do private, ja q me fode sem disable faço essa negragem mesmo

    };

  CTradePanel TradePanel;


//
//-- Enum Variables
  enum ACUMULATION_MODE{ 

      LINEAR = 0,
      ARITMETIC = 1,
      GEOMETRIC = 2,

  };



//<
//-- Variaveis do Panel -> NÃO MUDAR NUNCA, CONTROLADO PELO USUARIO
bool     AutoAdjust = true;
int      Ticks = 2; // Ticks de volta
bool     StopBoleta = true; 
int      Loss = 2; // Ticks Stop
int      Niveis = 4;
int      Multipler = 1 ; //Multiplicador
int      Gain = 4; // Ticks gain cada
int      Slippage = 2; // Ticks spread
int      FromPrice = 2; //
bool     StopFinanceiro = true ;
bool     GainFinanceiro = true;
double   GainMoney = 300; // Gain Financeiro (em R$)
double   LossMoney = 300; // Loss Financeiro (em R$)
ACUMULATION_MODE    acumulation = LINEAR;
int mode = 0;
ulong magic = 0; // Magic do panel
bool    ViewLines = false;
double            cur_lot;                         // Lot of next order
double            cur_price;                        // Preco que ta
// -- Input variables
  input color OrderColor = PaleGoldenrod;
//
//-- Booleans Like Variables (checkers)
  int Marcador = 0;
  int Verificador = 0;
  int InGame = 0;
  ENUM_POSITION_TYPE Entrada = POSITION_TYPE_BUY;
//
//-- Users GlobalVariables do preço
  double LastPrice = 0;
  double PriceUser = 0;
  double LotsInicial = 0;
  double LotsNiveis = 1;
  double FromPreco = FromPrice; // Auxiliar
  int Andadas = 0;
  double grana = 0;
  
  ulong MagicUser = 35; // Magic de entrada usuario
//
//-- Symbol Variables
  double MyPoint = _Point;
  int Digits = 0;
  int DigitsLotes = 0;
  double StopLevel = 0;
  double steplot;
//
//--Trade Control Variables -
  int aritmetico = 1;
  int geometrico = 2;
  double PrecoValido = 0;
  double PrecoCompra[40];
  double PrecoVenda[40];
  ulong TicketCompra[40];
  ulong TicketCompraCounter[40];
  ulong TicketVenda[40];
  ulong TicketVendaCounter[40];
  ulong TicketStopCompra = 0; // STOP DE POSICAO COMPRADA
  ulong TicketStopVenda = 0;
  bool operando = 0;
  double ProfitSession = 0;
  double lotesaux;
  datetime TempoInicializado = 0; 
  double ProfitPosicao = 0;
  CTrade            Trade;   // Class of trade operations
  double LotsInicialBuy,LotsInicialSell;
// EM ANDAMENTO

  string TrenderString[] = {"None","Trender","Attacker"};//,"Defenser"};
  string AcumulationString[] = {"Accumulation","AcPock"};//,"AcAttacker"};
  string Lotees[] = {"Linear","Aritmetic","Geometric"};
  int LOTESSIZE = 3;
  int TRENDSIZE = 3;
  int ACUMULATIONSIZE = 2;
  int DigitsMoeda = 2;
  bool ONCONTROL = false;
  bool agrediu = 0;
  int checker = 1;
  int losschecker =1;
//-- Label Variaveis 
    CLabel            Attacker,Trender,None,Accumulation,AcPock;
    CLabel            Linear,Aritmetic,Geometric;
    datetime abertura;
int OnInit(){
      
       if(!TerminalInfoInteger(TERMINAL_TRADE_ALLOWED)) 
     { 
      Print("Autotrading in the terminal is disabled, Expert Advisor will be removed."); 
      ExpertRemove(); 
      return(-1); 
     }


  abertura = TimeCurrent();
  ArrayInitialize(TicketCompra,EMPTY_VALUE);
  ArrayInitialize(TicketCompraCounter,EMPTY_VALUE);
  ArrayInitialize(TicketVenda,EMPTY_VALUE);
  ArrayInitialize(TicketVendaCounter,EMPTY_VALUE);
  ArrayInitialize(PrecoVenda,EMPTY_VALUE);
  ArrayInitialize(PrecoCompra,EMPTY_VALUE);



  TempoInicializado = TimeCurrent();
  
  // Creat Trade Panel 
    if(!TradePanel.Create(ChartID(),"Strategy Maker",0,20,20,320,360))
      {
        
        return (INIT_FAILED);
      }
    // Run Trade Panel
   
    TradePanel.Run();


  ChartSetInteger(0,CHART_COLOR_VOLUME, OrderColor);  
  
  ChartSetInteger(ChartID(),CHART_EVENT_MOUSE_WHEEL,0,false);
  ChartRedraw();
  
  /////SymbolInfos
    Digits=(int)SymbolInfoInteger(Symbol(),SYMBOL_DIGITS);
    MyPoint = NormalizeDouble(SymbolInfoDouble(Symbol(),SYMBOL_TRADE_TICK_SIZE),Digits);
    
    
    DigitsLotes = (int) log10(1/SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_STEP));
    steplot=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP);
    if(DigitsLotes<1)
      DigitsLotes=0;

  //StopLevels
  StopLevel = NormalizeDouble(SymbolInfoInteger(Symbol(),SYMBOL_TRADE_STOPS_LEVEL)*MyPoint,Digits);
  
  //debug
  // Print("DIGITS = " + Digits);
  // Print("MyPoint = " + MyPoint);
  // Print("Stop Level = " + StopLevel);
  
    

       if(!TerminalInfoInteger(TERMINAL_TRADE_ALLOWED)) 
     { 
      Print("Autotrading in the terminal is disabled, Expert Advisor will be removed."); 
      ExpertRemove(); 
      return(-1); 
     } 
   //---

   
  return(INIT_SUCCEEDED);
   
}

void OnDeinit(const int reason)
  {


  TradePanel.Destroy(reason);
      Comment(" \n \n \n ");
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+

void OnTick(){
  int i=0;
   if(PositionSelect(Symbol())){} //SE TA ABERTO A POSIÇÃO SEGUE O GAIME
    else{ //SE TA FECHADO E NÃO TEM NENHUMA ORDEM DO BOT ABERTO, POD RESETA TUTO!
            int orders = OrdersTotal();
          for(i = orders-1 ; i >= 0 ;i--)
        {
          OrderGetTicket (i);
          ulong magicmomento = OrderGetInteger(ORDER_MAGIC);
                        
              if (OrderGetString(ORDER_SYMBOL) == _Symbol && magicmomento == magic) //ISSO VAI LENTIA MEU ALGORITMO, VE SE VALE A PENA TER (impede q se user mexer dar merda)
                  break;
            }
            
            if(i==0)
            ResetaVariaveis(); //só vai reseta tuto, pq tem nada pra fecha....
            
        }
     
   
   grana = PositionGetDouble(POSITION_PROFIT);
   
   //debug
   
  //  Comment(StringFormat("Priceuser: %G \n Acumulation : %G \n Marcador : %G \n Saldo sessão : %G R$ \n Volume Posicao = %G \n Saldo posicao = %G R$ \n cur_lot = %G\n  cur_price = %G\n Niveis = %G\n Multipler = %G\n Gain = %G\n Ticks = %G\n FromPrice = %G\n Loss = %G\n Slippage = %G\n LossMoney = %G\n magic = %G\n GainMoney = %G\n StopBoleta = %G\n GainFinanceiro = %G\n mode = %G\n"
  //   ,PriceUser,acumulation, Marcador,ProfitSession+grana+ProfitPosicao,PositionGetDouble(POSITION_VOLUME),ProfitPosicao+grana,cur_lot,cur_price,Niveis,Multipler,Gain,Ticks,FromPrice,Loss,Slippage,LossMoney,magic,GainMoney
  //   ,StopBoleta,GainFinanceiro,mode));


   
   
   StopMoney();
   

   TradePanel.OnTick();
    
  switch(mode) { //TIPOS DE ATUAÇÕES 

        case 0 : // None

          ScriptInicial();
          break;

        case 1 : // Trender = 1,

        
            ScriptInicial();

            Defense();
            
            Trend();

         break;
        
        case 2 : // Attacker  = 2,
        
          ScriptInicial();
          Attack();
          
          TrendAttack();
        
         break;
        
       
        case 3 : // Acumulationer = 3,
         
            AcumulationInicial();

            AcumulationScalp();

         break;

       
        case 4 : // AcumulationPock = 4,
         
          AcumulationInicial();

          AcumulationPock();

          break;

    }
  

}

void OnTradeTransaction(const MqlTradeTransaction &trans,
                        const MqlTradeRequest &request,
                        const MqlTradeResult &result){
  
  //--- get transaction type as enumeration value 
   ENUM_TRADE_TRANSACTION_TYPE type=trans.type;
  //--- if transaction is result of addition of the transaction in history
   if(type==TRADE_TRANSACTION_DEAL_ADD)
     {
      long     deal_entry        =0;
      string   deal_symbol       ="";
      long     deal_magic        =0;
      int      deal_type         =0;
      if(HistoryDealSelect(trans.deal))
        {
         deal_entry=HistoryDealGetInteger(trans.deal,DEAL_ENTRY);
         deal_symbol=HistoryDealGetString(trans.deal,DEAL_SYMBOL);
         deal_magic=HistoryDealGetInteger(trans.deal,DEAL_MAGIC);
         deal_type=HistoryDealGetInteger(trans.deal,DEAL_REASON);
        }
      else
         return;
      // if(deal_symbol==Symbol() && deal_magic==m_magic)
      if(deal_symbol == Symbol())
         if(deal_entry==DEAL_ENTRY_OUT)
           {
            //  if(deal_type == DEAL_REASON_SL){
            //   ProfitSession += HistoryDealGetDouble(trans.deal,DEAL_PROFIT);
            //   Alert("STOPPER : " + HistoryDealGetDouble(trans.deal,DEAL_PROFIT));
            //  }
              // else
             ProfitPosicao += HistoryDealGetDouble(trans.deal,DEAL_PROFIT);
           }
      if(!PositionSelect(Symbol())){ //isto é, estou zerado
        ProfitSession = ProfitSession + ProfitPosicao;
        ProfitPosicao = 0;
        
     }
          
     }
}

//-- OnTester
  double OnTester(){

    //---
    double ret=0.0;
    //---

    //---
    return(ret);
  }

//
//-- Stop (Financeiro por op) + Close Orders (Close Position + orders) 


  void StopMoney(){

        if(GainFinanceiro && GainMoney != 0 )
        if(grana+ProfitPosicao >= GainMoney){
          
          CloseOrders();
         
                ProfitPosicao = 0; 
                
        }
            if(StopFinanceiro  && LossMoney != 0)
            if(grana+ProfitPosicao <= -LossMoney){
          CloseOrders();
          
          ProfitPosicao = 0;      
                
        }
      



  }
  void ResetaVariaveis(){

      ArrayInitialize(TicketCompraCounter,EMPTY_VALUE);
      ArrayInitialize(TicketCompra,EMPTY_VALUE);
      ArrayInitialize(TicketVenda,EMPTY_VALUE);
      ArrayInitialize(TicketVendaCounter,EMPTY_VALUE);
      ArrayInitialize(PrecoVenda,EMPTY_VALUE);
      ArrayInitialize(PrecoCompra,EMPTY_VALUE);
      ProfitSession = ProfitSession + ProfitPosicao;
      ProfitPosicao = 0;
      Marcador = 0;
      LotsInicial = 0;
      InGame = 0;
      LabelHide();
      TradePanel.InvestGroup.Show();
      TradePanel.LotesGroup.Show();
      TicketStopCompra = EMPTY_VALUE;
      TicketStopVenda = EMPTY_VALUE;
      Andadas = 0;
      MagicUser=0;
  }
  void CloseOrders(){

    
    Trade.PositionClose(Symbol());
     int magicmomento=0;
     ulong tickete;
     int orders = OrdersTotal();

      

    for(int i = orders-1 ; i >= 0 ;i--)
      {
      tickete  = OrderGetTicket (i);
      magicmomento = OrderGetInteger(ORDER_MAGIC);
            
            if (OrderGetString(ORDER_SYMBOL) == _Symbol && magicmomento == magic)
          {
          ResetLastError();
          if(!Trade.OrderDelete(tickete))
            {
            Print("Fail to delete ticket ", tickete  ,": Error ",GetLastError());

            }

          }
      }
    ResetaVariaveis();  
  
  }


// 
//-- ScriptInicial + Defense
  void ScriptInicial(){
      int cnt;
   //   Print("Marcador " + Marcador);
        

      if(Marcador == 0){
          PositionSelect(Symbol());
          if (HistorySelect(abertura, TimeCurrent()) && (HistoryDealsTotal() > 0)){
          MagicUser = HistoryDealGetInteger(HistoryDealGetTicket(HistoryDealsTotal() - 1), DEAL_MAGIC);
          abertura = TimeCurrent();
          
          }

        
         
          
        
        
        if(PositionGetDouble(POSITION_VOLUME)!=0 && MagicUser == magic){ 

        if((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY)
        Entrada= POSITION_TYPE_BUY;
        else
        Entrada = POSITION_TYPE_SELL;

        LotsInicial = PositionGetDouble(POSITION_VOLUME);
        LotsNiveis=LotsInicial;
            TradePanel.LotesGroup.Hide();
            TradePanel.InvestGroup.Hide();
            LabelShow();
          PriceUser = PositionGetDouble(POSITION_PRICE_OPEN);       
          LastPrice = PriceUser; // Vai servir também pra re-colocar o price user no price user
          FromPreco=FromPrice;

        if(Entrada == POSITION_TYPE_BUY && magic == MagicUser){
          // caso seja de compra...
          
            Marcador = 1;

            // PrecoValido = PrecoMinimo(0);
            // if(NormalizeDouble(PriceUser-FromPreco*MyPoint,Digits) > PrecoValido ){ 
            //   //debug
            //   Print("Normalizo" + (PriceUser-FromPreco*MyPoint) + " Precovalido " + PrecoValido);
                  
            //     PriceUser = PrecoValido - MyPoint; // Margem
            //     FromPreco = 0; //FromPreco nao importa daí.... é o "from price minimo"
            //     LastPrice = PriceUser;
                
            // }
          //  Print("Niveis " + Niveis);
        //   StopContratos();
          for(cnt=0;cnt<Niveis;cnt++){
          //    Print("cnt" + cnt);

          checker=1;

          if(!Trade.BuyLimit(LotsNiveis*Multipler,NormalizeDouble(PriceUser-MyPoint*Ticks*cnt-FromPrice*MyPoint,Digits)))
          {
          //--- failure message
              if(AutoAdjust)
             if(Trade.ResultRetcode()==10015){
              FromPreco=FromPrice+FromPrice/10;
              if(FromPreco==FromPrice){
                FromPrice++;
              }
              else{
                FromPrice=FromPreco;
              }
              TradePanel.FromPriceP.Text(DoubleToString(FromPrice,0));
              cnt--;
              checker=0;
            }
            Print("Buy() method failed. Return code=",Trade.ResultRetcode(),
                ". Code description: ",Trade.ResultRetcodeDescription());

            }
            if(checker)
            TicketCompra[cnt] = Trade.ResultOrder();
            
          }
          
        if(StopBoleta){

          while(checker){
        if(Trade.SellStop(Niveis*LotsNiveis*Multipler+LotsInicial,NormalizeDouble(PriceUser-MyPoint*Ticks*(Niveis-1)-Loss*MyPoint-FromPrice*MyPoint,Digits))){
          checker=0;
        }
        else{
          Print("SellStop() method failed. Return code=",Trade.ResultRetcode(),
                ". Code description: ",Trade.ResultRetcodeDescription());
        
            if(!AutoAdjust){
            checker=0;
            }

            else{
             if(Trade.ResultRetcode()==10015){
                 losschecker=Loss+Loss/10;
              if(losschecker==Loss){
                Loss++;
              }
              else{
                Loss=losschecker;
              }
              TradePanel.StopBoletaPE.Text(DoubleToString(Loss,0));
             }

               else
        {
          checker=0;
        }

        }
      
             }
          
          
        }
        
          TicketStopCompra = Trade.ResultOrder();
        }

        }

     if(Entrada == POSITION_TYPE_SELL && magic == MagicUser){ // Venda...
        //   
              Marcador = 1;
            // PrecoValido = PrecoMinimo(1);

            //       if(NormalizeDouble(PriceUser-FromPreco*MyPoint,Digits) < PrecoValido ){ // Ta muito Em baixo
            //       PriceUser = PrecoValido + MyPoint; // margem
            //       FromPreco = 0; //FromPreco nao importa daí.... é o "from price minimo"
            //       LastPrice = PriceUser;
            //   }

          for(cnt=0;cnt<Niveis;cnt++){
            checker=1;
            if(!Trade.SellLimit(LotsNiveis*Multipler,NormalizeDouble(PriceUser+MyPoint*Ticks*cnt+FromPrice*MyPoint,Digits)))
            {
            //--- failure message
                if(AutoAdjust)
             if(Trade.ResultRetcode()==10015){
              FromPreco=FromPrice+FromPrice/10;
              if(FromPreco==FromPrice){
                FromPrice++;
              }
              else{
                FromPrice=FromPreco;
              }
              TradePanel.FromPriceP.Text(DoubleToString(FromPrice,0));
              cnt--;
              checker=0;
            }
              Print("Sell() method failed. Return code=",Trade.ResultRetcode(),
                  ". Code description: ",Trade.ResultRetcodeDescription());

              }
              if(checker)
              TicketVenda[cnt] = Trade.ResultOrder();
              
            }
            if(StopBoleta){
              while(checker){
          if(!Trade.BuyStop(Niveis*LotsNiveis*Multipler+LotsInicial,NormalizeDouble(PriceUser+MyPoint*Ticks*(Niveis-1)+Loss*MyPoint+FromPrice*MyPoint,Digits))){
          checker=0;
        }
        else{
          Print("SellStop() method failed. Return code=",Trade.ResultRetcode(),
                ". Code description: ",Trade.ResultRetcodeDescription());
        
            if(!AutoAdjust){
            checker=0;
            }

            else{
             if(Trade.ResultRetcode()==10015){
                 losschecker=Loss+Loss/10;
              if(losschecker==Loss){
                Loss++;
              }
              else{
                Loss=losschecker;
              }
              TradePanel.StopBoletaPE.Text(DoubleToString(Loss,0));
             }

               else
        {
          checker=0;
        }

        }
      
             }
              
          }
              TicketStopVenda = Trade.ResultOrder();
            }
            }
          

          }


          InGame = 0;

          

      }
      }
  
  //-- Bota ordens com gain scalp
  void Defense(){

    int cnt;

    // PositionSelect(Symbol());
  if(Marcador == 1){

      if(Entrada == POSITION_TYPE_BUY){
        
      
                
            for(cnt=0;cnt<Niveis;cnt++){ // 
              if(TicketCompra[cnt]!=EMPTY_VALUE) 
              if(HistoryOrderSelect(TicketCompra[cnt]))
                if((ENUM_ORDER_STATE)HistoryOrderGetInteger(TicketCompra[cnt],ORDER_STATE)==ORDER_STATE_FILLED){  //executada completamente
                  BotaCompraCounter(cnt,0);
                }
              
        
            }

          

            for(cnt=0;cnt<Niveis;cnt++){
            if(TicketCompraCounter[cnt]!=EMPTY_VALUE)
              if(HistoryOrderSelect(TicketCompraCounter[cnt])) //Ja virou historia
                if((ENUM_ORDER_STATE)HistoryOrderGetInteger(TicketCompraCounter[cnt],ORDER_STATE)==ORDER_STATE_FILLED){  //executada completamente
                   BotaCompra(cnt,0,0);
        
            }
            }
              
        
              if( StopBoleta){
                  HistoryOrderSelect(TicketStopCompra);
            if((ENUM_ORDER_STATE)HistoryOrderGetInteger(TicketStopCompra,ORDER_STATE)==ORDER_STATE_FILLED){//STOP -> Faz uns alert e descobre a treta q ta dando
                 
              CloseOrders();
              
            }
                }
          }



      
      
      if(Entrada == POSITION_TYPE_SELL){ // É VENDEDOR
    
        for(cnt=0;cnt<Niveis;cnt++){
              if(TicketVenda[cnt]!=EMPTY_VALUE) // Nao perde tempo.
              if(HistoryOrderSelect(TicketVenda[cnt])) //Ja virou historia
                if((ENUM_ORDER_STATE)HistoryOrderGetInteger(TicketVenda[cnt],ORDER_STATE)==ORDER_STATE_FILLED){  //executada completamente
                  BotaVendaCounter(cnt,0);
                }
        
          }

          



          for(cnt=0;cnt<Niveis;cnt++){
            if(TicketVendaCounter[cnt]!=EMPTY_VALUE)
              if(HistoryOrderSelect(TicketVendaCounter[cnt])) //Ja virou historia
                if((ENUM_ORDER_STATE)HistoryOrderGetInteger(TicketVendaCounter[cnt],ORDER_STATE)==ORDER_STATE_FILLED){  //executada completamente
                        BotaVenda(cnt,0,0);
                }
        
            }
          
          
          if( StopBoleta){
                  HistoryOrderSelect(TicketStopVenda);
            if((ENUM_ORDER_STATE)HistoryOrderGetInteger(TicketStopVenda,ORDER_STATE)==ORDER_STATE_FILLED){
                  
              CloseOrders();
              
            }
                }
          }





      
      }
  }
//-- Calcula Quantidade de Contratos que vai ter pego no fucking stop.
    // int StopContratos(int tipo){
    //  //==1 compra ==2 venda
    //     //SE sell STOP NORMAL
    //     double spread = NormalizeDouble(SymbolInfoInteger(Symbol(),SYMBOL_SPREAD)*MyPoint,Digits);
    //     Print("SPREADE " + spread);
    //     double onde;
    //     int cnt;

    //     if(tipo==1)
    //     onde = NormalizeDouble(PriceUser-MyPoint*Ticks*(Niveis-1)-Loss*MyPoint-FromPrice*MyPoint+spread,Digits); //Onde vai chegar o ask até stoppa
    //     for(cnt=0;cnt<Niveis;cnt++){
    //         if(PriceUser-MyPoint*Ticks*cnt-FromPrice*MyPoint<onde)
    //         break;
    //     }
    //     Print("cnt" + cnt);

    //   //  NormalizeDouble(PriceUser+MyPoint*Ticks*(Niveis-1)+Loss*MyPoint+FromPrice*MyPoint,Digits)

    // }
    //
//-- Trend + TrendAttack + Attack

  void TrendAttack(){

     if(Marcador == 1) { 
       checker=0;
        int cnt;
      if(Entrada == POSITION_TYPE_BUY && SymbolInfoDouble(Symbol(),SYMBOL_ASK) >= NormalizeDouble(LastPrice+Ticks*MyPoint,Digits)){ //COMPRADOR SAFADO
              
                          
            for(cnt=0;cnt<Niveis;cnt++){ // 
              if(TicketCompra[cnt]!=EMPTY_VALUE) 
              if(OrderSelect(TicketCompra[cnt]))
              if(Trade.OrderModify(TicketCompra[cnt],NormalizeDouble(LastPrice-cnt*MyPoint*Ticks-FromPrice*MyPoint+Ticks*MyPoint,Digits),0,0,ORDER_TIME_GTC,0)){
              checker=1;
              
              }
              else
              Print("Order upping method failed. Return code=",Trade.ResultRetcode(),
                ". Code description: ",Trade.ResultRetcodeDescription() );
              }
            
              //aí mata o tickets[niveis] e mexe o stop
          if(checker)
          if(StopBoleta){
              OrderSelect(TicketStopCompra);
              double preco = OrderGetDouble(ORDER_PRICE_OPEN);
              
              if(!Trade.OrderModify(TicketStopCompra,NormalizeDouble(preco+Ticks*MyPoint,Digits),0,0,ORDER_TIME_GTC,0))
            Print("Order Stop upping method failed. Return code=",Trade.ResultRetcode(),
                ". Code description: ",Trade.ResultRetcodeDescription() );


          }
            

                LastPrice = NormalizeDouble(LastPrice+Ticks*MyPoint,Digits);
              Andadas++;
        }


      if(Entrada == POSITION_TYPE_SELL && SymbolInfoDouble(Symbol(),SYMBOL_BID) <= NormalizeDouble(LastPrice-Ticks*MyPoint,Digits) ) { //VENDEDOR RAPA

           for(cnt=0;cnt<Niveis;cnt++){ // 
              if(TicketVenda[cnt]!=EMPTY_VALUE) 
              if(OrderSelect(TicketVenda[cnt]))
              if(Trade.OrderModify(TicketVenda[cnt],NormalizeDouble(LastPrice+cnt*MyPoint*Ticks+FromPrice*MyPoint-Ticks*MyPoint,Digits),0,0,ORDER_TIME_GTC,0)){
                  checker=1;
                                         }
              else
              Print("Order dowing method failed. Return code=",Trade.ResultRetcode(),
                ". Code description: ",Trade.ResultRetcodeDescription() );
              
              //aí mata o tickets[niveis] e mexe o stop
              }
           if(checker)
          if(StopBoleta){
            OrderSelect(TicketStopVenda);
              double preco = OrderGetDouble(ORDER_PRICE_OPEN);
              if(!Trade.OrderModify(TicketStopVenda,NormalizeDouble(preco-Ticks*MyPoint,Digits),0,0,ORDER_TIME_GTC,0))
            Print("Order Stop upping method failed. Return code=",Trade.ResultRetcode(),
                ". Code description: ",Trade.ResultRetcodeDescription() );


          }
          Andadas++;
          LastPrice = NormalizeDouble(LastPrice-Ticks*MyPoint,Digits);
        }

    }


  }
  // Segue Preço (Só sobe as ordens)
  void Trend(){ //TRETA EM ASK É MAIOR Q LAST PRICE + TICKS*MYPOINT PQ TEM STOP LEVEL, TEM Q SER MAIOR Q PREÇO VALIDO ETC
    if(InGame == 0)
    if(Niveis!=0)
    if(Marcador == 1) { 
        checker=0;
      if(Entrada == POSITION_TYPE_BUY && SymbolInfoDouble(Symbol(),SYMBOL_ASK) >= NormalizeDouble(LastPrice+Ticks*MyPoint,Digits)){ //COMPRADOR SAFADO
              
              if(OrderSelect(TicketCompra[Niveis-1]))
              if(Trade.OrderModify(TicketCompra[Niveis-1], NormalizeDouble(LastPrice-FromPrice*MyPoint+Ticks*MyPoint,Digits),0,0,ORDER_TIME_GTC,0)){
              ShifterCompra();
              TicketCompra[0] = TicketCompra[Niveis];
              TicketCompra[Niveis] = EMPTY_VALUE;
              LastPrice = NormalizeDouble(LastPrice+Ticks*MyPoint,Digits);
              Andadas++;
              checker=1;
              }
              else
              Print("Order upping method failed. Return code=",Trade.ResultRetcode(),
                ". Code description: ",Trade.ResultRetcodeDescription() );
              
              //aí mata o tickets[niveis] e mexe o stop
          if(checker)
          if(StopBoleta){
              OrderSelect(TicketStopCompra);
              double preco = OrderGetDouble(ORDER_PRICE_OPEN);
              
              if(!Trade.OrderModify(TicketStopCompra,NormalizeDouble(preco+Ticks*MyPoint,Digits),0,0,ORDER_TIME_GTC,0))
            Print("Order Stop upping method failed. Return code=",Trade.ResultRetcode(),
                ". Code description: ",Trade.ResultRetcodeDescription() );


          }
            

                

        }


      if(Entrada == POSITION_TYPE_SELL && SymbolInfoDouble(Symbol(),SYMBOL_BID) <= NormalizeDouble(LastPrice-Ticks*MyPoint,Digits) ) { //VENDEDOR RAPA
          if(OrderSelect(TicketVenda[Niveis-1]))
          if(Trade.OrderModify(TicketVenda[Niveis-1],NormalizeDouble(LastPrice+FromPrice*MyPoint-Ticks*MyPoint,Digits),0,0,ORDER_TIME_GTC,0)){
              ShifterVenda();
              TicketVenda[0] = TicketVenda[Niveis];
              TicketVenda[Niveis] = EMPTY_VALUE;
              Andadas++;
              LastPrice = NormalizeDouble(LastPrice-Ticks*MyPoint,Digits);
              checker=1;
              }
              else
              Print("Order dowing method failed. Return code=",Trade.ResultRetcode(),
                ". Code description: ",Trade.ResultRetcodeDescription() );
              
              //aí mata o tickets[niveis] e mexe o stop
          if(checker)
          if(StopBoleta){
            OrderSelect(TicketStopVenda);
              double preco = OrderGetDouble(ORDER_PRICE_OPEN);
              if(!Trade.OrderModify(TicketStopVenda,NormalizeDouble(preco-Ticks*MyPoint,Digits),0,0,ORDER_TIME_GTC,0))
            Print("Order Stop upping method failed. Return code=",Trade.ResultRetcode(),
                ". Code description: ",Trade.ResultRetcodeDescription() );


          }

        }

    }


  }

  //Quanto mais perto do stop a ordem, maior o gain ( Maior pull back = maior volta)
  



  void Attack(){

    int cnt;
    if(Marcador == 1 && Entrada == POSITION_TYPE_BUY){//É COMPRADOR
        
        
            
        for(cnt=0;cnt<Niveis;cnt++){ // 
         
          if(TicketCompra[cnt]!=EMPTY_VALUE) 
          if(HistoryOrderSelect(TicketCompra[cnt]))
            if((ENUM_ORDER_STATE)HistoryOrderGetInteger(TicketCompra[cnt],ORDER_STATE)==ORDER_STATE_FILLED){  //executada completamente
                        BotaCompraCounter(cnt,cnt);
    
        }
        }
        for(cnt=0;cnt<Niveis;cnt++){
          if(TicketCompraCounter[cnt]!=EMPTY_VALUE)
            if(HistoryOrderSelect(TicketCompraCounter[cnt])) //Ja virou historia
              if((ENUM_ORDER_STATE)HistoryOrderGetInteger(TicketCompraCounter[cnt],ORDER_STATE)==ORDER_STATE_FILLED){  //executada completamente
                            BotaCompra(cnt,cnt,Andadas);
      
          }
          
    }
        if( StopBoleta){
              HistoryOrderSelect(TicketStopCompra);
        if((ENUM_ORDER_STATE)HistoryOrderGetInteger(TicketStopCompra,ORDER_STATE)==ORDER_STATE_FILLED){//STOP -> Faz uns alert e descobre a treta q ta dando
              
          CloseOrders();
            
        }
            }
      }



    if(Marcador == 1 && Entrada == POSITION_TYPE_SELL){ // É VENDEDOR

        
      
        for(cnt=0;cnt<Niveis;cnt++){
          if(TicketVenda[cnt]!=EMPTY_VALUE) // Nao perde tempo.
          if(HistoryOrderSelect(TicketVenda[cnt])) //Ja virou historia
            if((ENUM_ORDER_STATE)HistoryOrderGetInteger(TicketVenda[cnt],ORDER_STATE)==ORDER_STATE_FILLED){  //executada completamente
                BotaVendaCounter(cnt,cnt);
    
        }
        }
   
        for(cnt=0;cnt<Niveis;cnt++){
          if(TicketVendaCounter[cnt]!=EMPTY_VALUE)
            if(HistoryOrderSelect(TicketVendaCounter[cnt])) //Ja virou historia
              if((ENUM_ORDER_STATE)HistoryOrderGetInteger(TicketVendaCounter[cnt],ORDER_STATE)==ORDER_STATE_FILLED){  //executada completamente
                          BotaVenda(cnt,cnt,Andadas);
      
          }
        }
      
            if( StopBoleta){
              HistoryOrderSelect(TicketStopVenda);
        if((ENUM_ORDER_STATE)HistoryOrderGetInteger(TicketStopVenda,ORDER_STATE)==ORDER_STATE_FILLED){//STOP -> Faz uns alert e descobre a treta q ta dando
             
          CloseOrders();
           
        }
            }
      }


  }
//
//-- AcumlationInicial + Scalp + Attack + Pock
  void AcumulationInicial(){

      int cnt;

      if(Marcador==0){
      PositionSelect(Symbol());
      if (HistorySelect(abertura, TimeCurrent()) && (HistoryDealsTotal() > 0)){
      MagicUser = HistoryDealGetInteger(HistoryDealGetTicket(HistoryDealsTotal() - 1), DEAL_MAGIC);
      abertura = TimeCurrent();
                    }
      
      if(PositionGetDouble(POSITION_VOLUME)!=0 && MagicUser == magic){ // ENTROU NUMA OP
            
        
        if((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE)==POSITION_TYPE_BUY){
          LotsInicialBuy=PositionGetDouble(POSITION_VOLUME);
          LotsInicialSell = -LotsInicialBuy;
        }
        
        else{
        LotsInicialSell=PositionGetDouble(POSITION_VOLUME);
        LotsInicialBuy=-LotsInicialSell;
        }


         TradePanel.LotesGroup.Hide();
         TradePanel.InvestGroup.Hide();
         LabelShow();
        LotsInicial = PositionGetDouble(POSITION_VOLUME);
        LotsNiveis = LotsInicial;
        PriceUser = PositionGetDouble(POSITION_PRICE_OPEN);
        FromPreco=FromPrice;

        Marcador = 1;
        LastPrice = PriceUser;
        double Lotes;
        double Sum=0;
      
        for(cnt=0;cnt<Niveis;cnt++){ //Bota os de compra
            checker=1;
            lotesaux=Lotes;
            switch (acumulation){
                case LINEAR:
                  Lotes = LotsNiveis*Multipler;
                  Sum = Lotes + Sum;
                  break;

                case ARITMETIC:
                  Lotes = LotsNiveis+cnt*aritmetico*steplot*Multipler;
                  Sum = Lotes + Sum;
                  break;

                case GEOMETRIC:
                  Lotes = LotsNiveis*pow(geometrico,cnt);
                  Sum = Lotes + Sum;
                  break;

            }

          if(!Trade.BuyLimit(Lotes,NormalizeDouble(PriceUser-MyPoint*Ticks*cnt-FromPrice*MyPoint,Digits))) 
            {
            //--- failure message
            if(AutoAdjust)
             if(Trade.ResultRetcode()==10015){
              FromPreco=FromPrice+FromPrice/10;
              if(FromPreco==FromPrice){
                FromPrice++;
              }
              else{
                FromPrice=FromPreco;
              }
              TradePanel.FromPriceP.Text(DoubleToString(FromPrice,0));
              cnt--;
              checker=0;
              Sum=Sum-Lotes;
              Lotes=lotesaux;
            }
           
            
           Print("Buy() method failed. Return code=",Trade.ResultRetcode(),
                ". Code description: ",Trade.ResultRetcodeDescription());

            }

            if(checker)
            TicketCompra[cnt] = Trade.ResultOrder();
      
         }

        if(StopBoleta){
          while(checker){
          if(!Trade.SellStop(Sum+LotsInicialBuy,NormalizeDouble(PriceUser-MyPoint*Ticks*(Niveis-1)-Loss*MyPoint-FromPrice*MyPoint,Digits))){
          checker=0;
        }
        else{
          Print("SellStop() method failed. Return code=",Trade.ResultRetcode(),
                ". Code description: ",Trade.ResultRetcodeDescription());
        
            if(!AutoAdjust){
            checker=0;
            }

            else{
             if(Trade.ResultRetcode()==10015){
                 losschecker=Loss+Loss/10;
              if(losschecker==Loss){
                Loss++;
              }
              else{
                Loss=losschecker;
              }
              TradePanel.StopBoletaPE.Text(DoubleToString(Loss,0));
             }

               else
        {
          checker=0;
        }

        }
      
             }
          }
          TicketStopCompra = Trade.ResultOrder();
         }
      
        Sum=0;

        for(cnt=0;cnt<Niveis;cnt++){ //Bota os de venda
          checker=1;
          lotesaux=Lotes;
            switch (acumulation){
                case LINEAR:
                  Lotes = LotsNiveis*Multipler;
                  Sum = Lotes + Sum;
                  break;

                case ARITMETIC:
                  Lotes = LotsNiveis+cnt*aritmetico*steplot*Multipler;
                  Sum = Lotes + Sum;
                  break;

                case GEOMETRIC:
                  Lotes = LotsNiveis*pow(geometrico,cnt);
                  Sum = Lotes + Sum;
                  break;

              }
          
          if(!Trade.SellLimit(Lotes,NormalizeDouble(PriceUser+MyPoint*Ticks*cnt+FromPrice*MyPoint,Digits))){
               //--- failure message

               if(AutoAdjust)
             if(Trade.ResultRetcode()==10015){
              FromPreco=FromPrice+FromPrice/10;
              if(FromPreco==FromPrice){
                FromPrice++;
              }
              else{
                FromPrice=FromPreco;
              }
              TradePanel.FromPriceP.Text(DoubleToString(FromPrice,0));
              cnt--;
              checker=0;
              Sum=Sum-Lotes;
              Lotes=lotesaux;
            }
            
            
               Print("Sell() method failed. Return code=",Trade.ResultRetcode(),
                ". Code description: ",Trade.ResultRetcodeDescription());
            
            

          }
          if(checker)
            TicketVenda[cnt] = Trade.ResultOrder();
         }
        if(StopBoleta){
          while(checker){
          if(!Trade.BuyStop(Sum+LotsInicialSell,NormalizeDouble(PriceUser+MyPoint*Ticks*(Niveis-1)+Loss*MyPoint+FromPrice*MyPoint,Digits))){
          checker=0;
        }
        else{
          Print("SellStop() method failed. Return code=",Trade.ResultRetcode(),
                ". Code description: ",Trade.ResultRetcodeDescription());
        
            if(!AutoAdjust){
            checker=0;
            }

            else{
             if(Trade.ResultRetcode()==10015){
                 losschecker=Loss+Loss/10;
              if(losschecker==Loss){
                Loss++;
              }
              else{
                Loss=losschecker;
              }
              TradePanel.StopBoletaPE.Text(DoubleToString(Loss,0));
             }

               else
        {
          checker=0;
        }

        }
      
             }
          }
          TicketStopVenda = Trade.ResultOrder();
          }
         }

      
      
      InGame = 0;
    
      }
  }
  
  //-- Scalp -> gain ticks cada
  void AcumulationScalp(){

    int cnt;
    if(Marcador == 1){
    //--Lotes de comprador
      for(cnt=0;cnt<Niveis;cnt++){ //-- Pegou compra bota venda (pra gain)
        if(TicketCompra[cnt]!=EMPTY_VALUE) 
        if(HistoryOrderSelect(TicketCompra[cnt]))
          if((ENUM_ORDER_STATE)HistoryOrderGetInteger(TicketCompra[cnt],ORDER_STATE)==ORDER_STATE_FILLED){  //executada completamente
              if(Trade.SellLimit(HistoryOrderGetDouble(TicketCompra[cnt],ORDER_VOLUME_INITIAL),NormalizeDouble(HistoryOrderGetDouble(TicketCompra[cnt],ORDER_PRICE_OPEN)+MyPoint*Gain,Digits))){
              
                TicketCompra[cnt] = EMPTY_VALUE;
                TicketCompraCounter[cnt] = Trade.ResultOrder();
                
              }
              else
              Print("SellLimit() method failed. Return code=",Trade.ResultRetcode(),
              ". Code description: ",Trade.ResultRetcodeDescription());
          }
        
  
       }

      for(cnt=0;cnt<Niveis;cnt++){ //-- Pegou gain venda bota compra (repor)
        if(TicketCompraCounter[cnt]!=EMPTY_VALUE)
          if(HistoryOrderSelect(TicketCompraCounter[cnt])) //Ja virou historia
            if((ENUM_ORDER_STATE)HistoryOrderGetInteger(TicketCompraCounter[cnt],ORDER_STATE)==ORDER_STATE_FILLED){  //executada completamente
                if(Trade.BuyLimit(HistoryOrderGetDouble(TicketCompraCounter[cnt],ORDER_VOLUME_INITIAL),NormalizeDouble(HistoryOrderGetDouble(TicketCompraCounter[cnt],ORDER_PRICE_OPEN)-MyPoint*Gain,Digits))){
                  
                  TicketCompra[cnt] = Trade.ResultOrder();
                  TicketCompraCounter[cnt] = EMPTY_VALUE;
                
                }
                else
                Print("BuyLimit() method failed. Return code=",Trade.ResultRetcode(),
                ". Code description: ",Trade.ResultRetcodeDescription());
            }
    
        }
          
    
      if( StopBoleta){ //-- Se usa Stop Boleta
       HistoryOrderSelect(TicketStopCompra);
        if((ENUM_ORDER_STATE)HistoryOrderGetInteger(TicketStopCompra,ORDER_STATE)==ORDER_STATE_FILLED){ //-- Pegou Stop de compra (abaixo)
              
          CloseOrders();
          
         }
        HistoryOrderSelect(TicketStopVenda);
        if((ENUM_ORDER_STATE)HistoryOrderGetInteger(TicketStopVenda,ORDER_STATE)==ORDER_STATE_FILLED){//-- Pegou Stop de venda (acima)
              
          CloseOrders();
         
         }
        }

    //--Lotes de Vendedor
      for(cnt=0;cnt<Niveis;cnt++){ //-- Pegou venda bota compra (pra gain)
          if(TicketVenda[cnt]!=EMPTY_VALUE) // Nao perde tempo.
          if(HistoryOrderSelect(TicketVenda[cnt])) //Ja virou historia
            if((ENUM_ORDER_STATE)HistoryOrderGetInteger(TicketVenda[cnt],ORDER_STATE)==ORDER_STATE_FILLED){  //executada completamente
                if(Trade.BuyLimit(HistoryOrderGetDouble(TicketVenda[cnt],ORDER_VOLUME_INITIAL),NormalizeDouble(HistoryOrderGetDouble(TicketVenda[cnt],ORDER_PRICE_OPEN)-MyPoint*Gain,Digits))){
                
                  TicketVenda[cnt] = EMPTY_VALUE;
                  TicketVendaCounter[cnt] = Trade.ResultOrder();
                  
                }
                else
                Print("BuyLimit() method failed. Return code=",Trade.ResultRetcode(),
                ". Code description: ",Trade.ResultRetcodeDescription());
            }
    
        }

      



     
      for(cnt=0;cnt<Niveis;cnt++){ //-- Pegou compra bota venda (pra repor)
        if(TicketVendaCounter[cnt]!=EMPTY_VALUE)
          if(HistoryOrderSelect(TicketVendaCounter[cnt])) //Ja virou historia
            if((ENUM_ORDER_STATE)HistoryOrderGetInteger(TicketVendaCounter[cnt],ORDER_STATE)==ORDER_STATE_FILLED){  //executada completamente
                if(Trade.SellLimit(HistoryOrderGetDouble(TicketVendaCounter[cnt],ORDER_VOLUME_INITIAL),NormalizeDouble(HistoryOrderGetDouble(TicketVendaCounter[cnt],ORDER_PRICE_OPEN)+MyPoint*Gain,Digits))){
                  
                  TicketVenda[cnt] = Trade.ResultOrder();
                  TicketVendaCounter[cnt] = EMPTY_VALUE;
                  
                }
                else
                Print("SellLimit() method failed. Return code=",Trade.ResultRetcode(),
                ". Code description: ",Trade.ResultRetcodeDescription());
            }
    
       }

    }
  }
  // Bota mais longe da onde ta (tem que trabalhar ele também, não pode passar do range, tem que ser que no meio da metade do range inverte e até o fim posiciona tudo)
  // Ideia -> Faz que as ordens de gain batem em cima das ordens posicionadas do lado contrario!
  void AcumulationAttack(){

    int cnt;

    for(cnt=0;cnt<Niveis;cnt++){ // 
          if(TicketCompra[cnt]!=EMPTY_VALUE) 
          if(HistoryOrderSelect(TicketCompra[cnt]))
            if((ENUM_ORDER_STATE)HistoryOrderGetInteger(TicketCompra[cnt],ORDER_STATE)==ORDER_STATE_FILLED){  //executada completamente
                if(Trade.SellLimit(HistoryOrderGetDouble(TicketCompra[cnt],ORDER_VOLUME_INITIAL),NormalizeDouble(HistoryOrderGetDouble(TicketCompra[cnt],ORDER_PRICE_OPEN)+MyPoint*Gain*(cnt+1),Digits))){
                
                  TicketCompra[cnt] = EMPTY_VALUE;
                  TicketCompraCounter[cnt] = Trade.ResultOrder();
                  
                }
                else
                Print("SellLimit() method failed. Return code=",Trade.ResultRetcode(),
                ". Code description: ",Trade.ResultRetcodeDescription());
            }
          
    
        }

      

      for(cnt=0;cnt<Niveis;cnt++){
        if(TicketCompraCounter[cnt]!=EMPTY_VALUE)
          if(HistoryOrderSelect(TicketCompraCounter[cnt])) //Ja virou historia
            if((ENUM_ORDER_STATE)HistoryOrderGetInteger(TicketCompraCounter[cnt],ORDER_STATE)==ORDER_STATE_FILLED){  //executada completamente
                if(Trade.BuyLimit(HistoryOrderGetDouble(TicketCompraCounter[cnt],ORDER_VOLUME_INITIAL),NormalizeDouble(HistoryOrderGetDouble(TicketCompraCounter[cnt],ORDER_PRICE_OPEN)-MyPoint*Gain,Digits))){
                  
                  TicketCompra[cnt] = Trade.ResultOrder();
                  TicketCompraCounter[cnt] = EMPTY_VALUE;
                  
                }
                else
                Print("BuyLimit() method failed. Return code=",Trade.ResultRetcode(),
                ". Code description: ",Trade.ResultRetcodeDescription());
            }
    
        }
          
    
          if( StopBoleta){
              HistoryOrderSelect(TicketStopCompra);
        if((ENUM_ORDER_STATE)HistoryOrderGetInteger(TicketStopCompra,ORDER_STATE)==ORDER_STATE_FILLED){//STOP -> Faz uns alert e descobre a treta q ta dando
              
          CloseOrders();
            
        }
        HistoryOrderSelect(TicketStopVenda);
          if((ENUM_ORDER_STATE)HistoryOrderGetInteger(TicketStopVenda,ORDER_STATE)==ORDER_STATE_FILLED){//STOP -> Faz uns alert e descobre a treta q ta dando
              
          CloseOrders();
           
        }
          }

        
        for(cnt=0;cnt<Niveis;cnt++){
          if(TicketVenda[cnt]!=EMPTY_VALUE) // Nao perde tempo.
          if(HistoryOrderSelect(TicketVenda[cnt])) //Ja virou historia
            if((ENUM_ORDER_STATE)HistoryOrderGetInteger(TicketVenda[cnt],ORDER_STATE)==ORDER_STATE_FILLED){  //executada completamente
                if(Trade.BuyLimit(HistoryOrderGetDouble(TicketVenda[cnt],ORDER_VOLUME_INITIAL),NormalizeDouble(HistoryOrderGetDouble(TicketVenda[cnt],ORDER_PRICE_OPEN)-MyPoint*Gain*(cnt+1),Digits))){
                
                  TicketVenda[cnt] = EMPTY_VALUE;
                  TicketVendaCounter[cnt] = Trade.ResultOrder();
                  
                }
                else
                Print("BuyLimit() method failed. Return code=",Trade.ResultRetcode(),
                ". Code description: ",Trade.ResultRetcodeDescription());
            }
    
        }

      



      for(cnt=0;cnt<Niveis;cnt++){
      if(TicketVendaCounter[cnt]!=EMPTY_VALUE)
        if(HistoryOrderSelect(TicketVendaCounter[cnt])) //Ja virou historia
          if((ENUM_ORDER_STATE)HistoryOrderGetInteger(TicketVendaCounter[cnt],ORDER_STATE)==ORDER_STATE_FILLED){  //executada completamente
              if(Trade.SellLimit(HistoryOrderGetDouble(TicketVendaCounter[cnt],ORDER_VOLUME_INITIAL),NormalizeDouble(HistoryOrderGetDouble(TicketVendaCounter[cnt],ORDER_PRICE_OPEN)+MyPoint*Gain,Digits))){
                
                TicketVenda[cnt] = Trade.ResultOrder();
                TicketVendaCounter[cnt] = EMPTY_VALUE;
                
              }
              else
              Print("SellLimit() method failed. Return code=",Trade.ResultRetcode(),
              ". Code description: ",Trade.ResultRetcodeDescription());
          }
  
      }






  }
  //-- Gain no pock...
  void AcumulationPock(){
    int cnt;
    if(Marcador == 1){
    for(cnt=0;cnt<Niveis;cnt++){ // 
        if(TicketCompra[cnt]!=EMPTY_VALUE) 
        if(HistoryOrderSelect(TicketCompra[cnt]))
          if((ENUM_ORDER_STATE)HistoryOrderGetInteger(TicketCompra[cnt],ORDER_STATE)==ORDER_STATE_FILLED){  //executada completamente
              if(Trade.SellLimit(HistoryOrderGetDouble(TicketCompra[cnt],ORDER_VOLUME_INITIAL),NormalizeDouble(PriceUser,Digits))){
                PrecoCompra[cnt] = HistoryOrderGetDouble(TicketCompra[cnt],ORDER_PRICE_OPEN);
                TicketCompra[cnt] = EMPTY_VALUE;
                TicketCompraCounter[cnt] = Trade.ResultOrder();
                
              }
              else
              Print("SellLimit() method failed. Return code=",Trade.ResultRetcode(),
              ". Code description: ",Trade.ResultRetcodeDescription());
          }
        
  
      }

    

    for(cnt=0;cnt<Niveis;cnt++){
      if(TicketCompraCounter[cnt]!=EMPTY_VALUE)
        if(HistoryOrderSelect(TicketCompraCounter[cnt])) //Ja virou historia
          if((ENUM_ORDER_STATE)HistoryOrderGetInteger(TicketCompraCounter[cnt],ORDER_STATE)==ORDER_STATE_FILLED){  //executada completamente
              if(Trade.BuyLimit(HistoryOrderGetDouble(TicketCompraCounter[cnt],ORDER_VOLUME_INITIAL),NormalizeDouble(PrecoCompra[cnt],Digits))){
                
                TicketCompra[cnt] = Trade.ResultOrder();
                TicketCompraCounter[cnt] = EMPTY_VALUE;
                
              }
              else
              Print("BuyLimit() method failed. Return code=",Trade.ResultRetcode(),
              ". Code description: ",Trade.ResultRetcodeDescription());
          }
  
      }
        
  
        if( StopBoleta){
            HistoryOrderSelect(TicketStopCompra);
      if((ENUM_ORDER_STATE)HistoryOrderGetInteger(TicketStopCompra,ORDER_STATE)==ORDER_STATE_FILLED){//STOP -> Faz uns alert e descobre a treta q ta dando
            
        CloseOrders();
          
      }
      HistoryOrderSelect(TicketStopVenda);
        if((ENUM_ORDER_STATE)HistoryOrderGetInteger(TicketStopVenda,ORDER_STATE)==ORDER_STATE_FILLED){//STOP -> Faz uns alert e descobre a treta q ta dando
            
        CloseOrders();
          
      }
        }

      
    for(cnt=0;cnt<Niveis;cnt++){
        if(TicketVenda[cnt]!=EMPTY_VALUE) // Nao perde tempo.
        if(HistoryOrderSelect(TicketVenda[cnt])) //Ja virou historia
          if((ENUM_ORDER_STATE)HistoryOrderGetInteger(TicketVenda[cnt],ORDER_STATE)==ORDER_STATE_FILLED){  //executada completamente
              if(Trade.BuyLimit(HistoryOrderGetDouble(TicketVenda[cnt],ORDER_VOLUME_INITIAL),NormalizeDouble(PriceUser,Digits))){
               PrecoVenda[cnt] = HistoryOrderGetDouble(TicketVenda[cnt],ORDER_PRICE_OPEN);
                TicketVenda[cnt] = EMPTY_VALUE;
                TicketVendaCounter[cnt] = Trade.ResultOrder();
                
              }
              else
              Print("BuyLimit() method failed. Return code=",Trade.ResultRetcode(),
              ". Code description: ",Trade.ResultRetcodeDescription());
          }
  
      }

    



    for(cnt=0;cnt<Niveis;cnt++){
      if(TicketVendaCounter[cnt]!=EMPTY_VALUE)
        if(HistoryOrderSelect(TicketVendaCounter[cnt])) //Ja virou historia
          if((ENUM_ORDER_STATE)HistoryOrderGetInteger(TicketVendaCounter[cnt],ORDER_STATE)==ORDER_STATE_FILLED){  //executada completamente
              if(Trade.SellLimit(HistoryOrderGetDouble(TicketVendaCounter[cnt],ORDER_VOLUME_INITIAL),NormalizeDouble(PrecoVenda[cnt],Digits))){
                
                TicketVenda[cnt] = Trade.ResultOrder();
                TicketVendaCounter[cnt] = EMPTY_VALUE;
                
              }
              else
              Print("SellLimit() method failed. Return code=",Trade.ResultRetcode(),
              ". Code description: ",Trade.ResultRetcodeDescription());
          }
  
      }




    }

  }

//
//-- Shifter + Verifica stop level + BotaVenda/BotaCompra + BotaVendaCounter/CompraCounter
  
  void BotaVenda(int cnt,int modificador,int andou){

     PrecoValido = PrecoMinimo(1);
     double   PrecoAcao = NormalizeDouble(HistoryOrderGetDouble(TicketVendaCounter[cnt],ORDER_PRICE_OPEN)+MyPoint*Gain*(1+modificador)-andou*MyPoint,Digits);
    //debug
    // Print("PrecoAcao : " + PrecoAcao + "Open VendaCounter " + HistoryOrderGetDouble(TicketVendaCounter[cnt],ORDER_PRICE_OPEN) + "Andadas  " + Andadas);
      if( PrecoAcao < PrecoValido ){ 
              PrecoAcao = PrecoValido + MyPoint; // margem
          }
      if(Trade.SellLimit(LotsNiveis*Multipler,PrecoAcao)){
                      
                      TicketVenda[cnt] = Trade.ResultOrder();
                      TicketVendaCounter[cnt] = EMPTY_VALUE;
                      InGame--;
                    }
                    else
                    Print("PutSell() method failed. Return code=",Trade.ResultRetcode(),
                    ". Code description: ",Trade.ResultRetcodeDescription());

  }

  void BotaVendaCounter(int cnt,int modificador){
    
    PrecoValido = PrecoMinimo(0);
    double  PrecoAcao = NormalizeDouble(HistoryOrderGetDouble(TicketVenda[cnt],ORDER_PRICE_OPEN)-MyPoint*Gain*(1+modificador),Digits);
      //debug
       //Print("PrecoAcao : " + PrecoAcao + "Open Venda " + HistoryOrderGetDouble(TicketVenda[cnt],ORDER_PRICE_OPEN) + "Andadas  " + Andadas);
         if( PrecoAcao > PrecoValido ){ // Ta muito Em baixo
              PrecoAcao = PrecoValido - MyPoint; // margem
          }

          if(Trade.BuyLimit(LotsNiveis*Multipler,PrecoAcao)){
                    
                      TicketVenda[cnt] = EMPTY_VALUE;
                      TicketVendaCounter[cnt] = Trade.ResultOrder();
                      InGame++;
                    }
                    else
                    Print("PutSellCounter() method failed. Return code=",Trade.ResultRetcode(),
                    ". Code description: ",Trade.ResultRetcodeDescription());
       
  }

  void BotaCompra(int cnt,int modificador,int andou){
    PrecoValido = PrecoMinimo(0);
    
    double  PrecoAcao = NormalizeDouble(HistoryOrderGetDouble(TicketCompraCounter[cnt],ORDER_PRICE_OPEN)-MyPoint*Gain*(1+modificador)+andou*MyPoint,Digits);
      //debug
       //Print("PrecoAcao : " + PrecoAcao + "Open compracounter " + HistoryOrderGetDouble(TicketCompraCounter[cnt],ORDER_PRICE_OPEN) + "Andadas  " + Andadas);
         if( PrecoAcao > PrecoValido ){ // Ta muito Em baixo
              PrecoAcao = PrecoValido - MyPoint; // margem
          }

      if(Trade.BuyLimit(LotsNiveis*Multipler,PrecoAcao)){
                      
                      TicketCompra[cnt] = Trade.ResultOrder();
                      TicketCompraCounter[cnt] = EMPTY_VALUE;
                      InGame--;
                    }
            else
            Print("PutBuy() method failed. Return code=",Trade.ResultRetcode(),
                    ". Code description: ",Trade.ResultRetcodeDescription());
     }
      
  

  void BotaCompraCounter(int cnt,int modificador){
     PrecoValido = PrecoMinimo(1);
    
     double   PrecoAcao = NormalizeDouble(HistoryOrderGetDouble(TicketCompra[cnt],ORDER_PRICE_OPEN)+MyPoint*Gain*(1+modificador),Digits);
    //debug
     //Print("PrecoAcao : " + PrecoAcao + "Open compra " + HistoryOrderGetDouble(TicketCompra[cnt],ORDER_PRICE_OPEN) + "Andadas  " + Andadas);
        if( PrecoAcao < PrecoValido ){ 
              PrecoAcao = PrecoValido + MyPoint; // margem
          }

        if(Trade.SellLimit(LotsNiveis*Multipler,PrecoAcao)){
                    
                      TicketCompra[cnt] = EMPTY_VALUE;
                      TicketCompraCounter[cnt] = Trade.ResultOrder();
                      InGame++;
                    }
                    else
                    Print("PutBuyCounter() method failed. Return code=",Trade.ResultRetcode(),
                    ". Code description: ",Trade.ResultRetcodeDescription());
                    
  }
 
 
  double PrecoMinimo(int ENTRADA){
    // Entrada = 0 Compra     Não é position type porque aí ia me torrar pra re-colocar ordens
    // Entrada = 1 Venda 

    if(ENTRADA == 0){
        return(PrecoValido = DoubleToString(SymbolInfoDouble(_Symbol,SYMBOL_ASK)-StopLevel,_Digits));
    }
    
    else{
      return(PrecoValido = DoubleToString(SymbolInfoDouble(_Symbol,SYMBOL_BID)+StopLevel,_Digits));
    }

  }

  void ShifterCompra(void){
    for(int i=Niveis-1;i>=0;i--){
    
    TicketCompra[i+1] = TicketCompra[i];
    
    }
  }

 void ShifterVenda(void){
    for(int i=Niveis-1;i>=0;i--){
    
    TicketVenda[i+1] = TicketVenda[i];
    
    }
  }
//  
// 
// DEBUG
    //    void debug(){

    //         double _ma1[];
      
    //      ArraySetAsSeries(_ma1, true); // Indexando que nem timeseries, _ma1[0] é a ultima barra que veio
    //  //handle, numero de buffers-1, barra inicial, numero de barras, array que pega a data
    
    //       if(CopyBuffer(MA,0,0,20,_ma1)<0){Print("CopyBufferMA1 error =",GetLastError());}

      
      
      
    //      if(MathRound((_ma1[0]-SymbolInfoDouble(Symbol(),SYMBOL_ASK))/MyPoint)>=RangeBuy && Marcador == 0){
    //       Trade.Buy(1,Symbol());
          
    //       }
          
    //        if(MathRound((SymbolInfoDouble(Symbol(),SYMBOL_BID)-_ma1[0])/MyPoint)>=RangeSell && Marcador == 0){
    //       Trade.Sell(1,Symbol());
    //       }
        
    //    }
    // //

void OnChartEvent(const int id,
                      const long &lparam,
                      const double &dparam,
                      const string &sparam){
      
                       //debug
                       // Print("id" +(ENUM_CHART_EVENT)id + "L" + lparam + "d" + dparam + "s" + sparam);
    // if(id==CHARTEVENT_OBJECT_DRAG)
    //     {
    //       if(TradePanel.DragLine(sparam))
    //         {
    //         ChartRedraw();
    //         }
    //     }
    if(TradePanel.OnEvent(id, lparam, dparam, sparam))
          ChartRedraw();



  }

//
//
//
/// ****************   PANEL FUNCTIONS   *********
  //
  //+------------------------------------------------------------------+
  //| Class initialization function                                    |
  //+------------------------------------------------------------------+
  CTradePanel::CTradePanel(void)
    {
    Trade.SetExpertMagicNumber(magic);
    Trade.SetDeviationInPoints(Slippage);
    int fill=(int)SymbolInfoInteger(_Symbol,SYMBOL_FILLING_MODE);
    Trade.SetTypeFilling((ENUM_ORDER_TYPE_FILLING)(fill==0 ? 2 : fill-1));
    return;
    }
  //+------------------------------------------------------------------+
  //| Creat Trade Panel function                                       |
  //+------------------------------------------------------------------+
  bool CTradePanel::Create(const long chart,const string name,const int subwin=0,const int x1=20,const int y1=20,const int x2=320,const int y2=520)
  {
          
        // At first call creat function of parents class
        if(!CAppDialog::Create(chart,name,subwin,x1,y1,x2,y2))
          {
            return false;
          }
        // Calculate coofrdinates and size of BID object
        // Coordinates calculate in dialog box, not in chart
        int l_x_left=BORDER;
        int l_y=BORDER;
        int y_width=Y_WIDTH;
        int y_sptep=Y_STEP;
        
      //PARTE DE CIMA DO ASK E BID E PREÇO ORDEM
        if(!CreateLabel(chart,subwin,BID,DoubleToString(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits),l_x_left*2,l_y+Y_WIDTH,left))
          {
            return false;
          }
        // Adjust font size for object
        if(!BID.FontSize(Y_WIDTH/2))
          {
            return false;
          }
        if(!CreateLabel(chart,subwin,Compra,"Bid",l_x_left*2+15,l_y,left))
          {
            return false;
          }
        // Repeat same functions for other objects
        int l_x_right=ClientAreaWidth()-20;
        if(!CreateLabel(chart,subwin,ASK,DoubleToString(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits),l_x_right-8,l_y+Y_WIDTH,right))
          {
            return false;
          }
        if(!ASK.FontSize(Y_WIDTH/2))
          {
            return false;
          }
        if(!CreateLabel(chart,subwin,Venda,"Ask",l_x_right-20,l_y,right))
          {
            return false;
          }
        int x_size=(int)((ClientAreaWidth()-40)/3-5);
        // l_x_left=(int)((ClientAreaWidth()-x_size)/2);
        l_x_left=(int)((ClientAreaWidth())/2);
        if(!CreateEdit(chart,subwin,PriceForOperate,DoubleToString(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits),(int)((ClientAreaWidth()-x_size-10)/2),l_y-Y_WIDTH/2,(int)(x_size+25-CONTROLS_BUTTON_SIZE),Y_WIDTH*2))
          {
            return false;
          }


         if(!CreateBmpButton(chart,subwin,IncreasePrice,l_x_left+x_size/2+17,(int)(l_y-Y_WIDTH/6-Y_WIDTH/2),"::Include\\Controls\\res\\SpinInc.bmp","::Include\\Controls\\res\\SpinInc.bmp",false))
          {
            return false;
          }
      
        if(!CreateBmpButton(chart,subwin,DecreasePrice,l_x_left+x_size/2+17,(int)(l_y+Y_WIDTH*2/3),"::Include\\Controls\\res\\SpinDec.bmp","::Include\\Controls\\res\\SpinDec.bmp",false))
          {
            return false;
          }
        DecreasePrice.PropFlags(WND_PROP_FLAG_CLICKS_BY_PRESS);
        IncreasePrice.PropFlags(WND_PROP_FLAG_CLICKS_BY_PRESS);
        PriceForOperate.FontSize(Y_WIDTH*4/5);

      //**************************PARA DE BRINCA COM AS CORDENADA QUE TAVA FICANDO FODA E UMA BOSTA

        l_y+=2*Y_WIDTH;
        l_x_left=l_x_left; 
      //****************************** Botoes compra venda lotes até close all trend/acumlation

        if(!CreateButton(chart,subwin,SELL,"SELL",BORDER,l_y,x_size,Y_WIDTH))
          {
            return false;
          }
        if(!CreateButton(chart,subwin,BUY,"BUY",(l_x_right-x_size),l_y,x_size,Y_WIDTH))
          {
            return false;
          }
        
        cur_lot=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
        if(!CreateEdit(chart,subwin,Lots,DoubleToString(cur_lot,2),l_x_left-x_size/2,l_y,(int)(x_size+-CONTROLS_BUTTON_SIZE/2),Y_WIDTH))
          {
            return false;
          }
        l_x_left+=x_size;
        if(!CreateBmpButton(chart,subwin,Increase,l_x_left-x_size/2+6,(int)(l_y-Y_WIDTH/4),"::Include\\Controls\\res\\SpinInc.bmp","::Include\\Controls\\res\\SpinInc.bmp",false))
          {
            return false;
          }
        if(!CreateBmpButton(chart,subwin,Decrease,l_x_left-x_size/2+6,(int)(l_y+Y_WIDTH/3),"::Include\\Controls\\res\\SpinDec.bmp","::Include\\Controls\\res\\SpinDec.bmp",false))
          {
            return false;
          }
        Increase.PropFlags(WND_PROP_FLAG_CLICKS_BY_PRESS);
        Decrease.PropFlags(WND_PROP_FLAG_CLICKS_BY_PRESS);
        l_y+=Y_WIDTH+Y_STEP;
        
        int x_middle = (int)((ClientAreaWidth()-x_size)/2);
            if(!CreateButton(chart,subwin,SELLPENDENT,"SELL ORDER",BORDER,l_y,x_size,Y_WIDTH))
          {
            return false;
          }

        if(!CreateButton(chart,subwin,BUYPENDENT,"BUY ORDER",(l_x_right-x_size),l_y,x_size,Y_WIDTH))
          {
            return false;
          }

          if(!CreateButton(chart,subwin,CloseOrders,"C ORDERS",x_middle,l_y,x_size,Y_WIDTH))
          {
            return false;
          }
        l_x_left=(int)(ClientAreaWidth()/2);
        l_y+=Y_WIDTH+Y_STEP;
        
      
        if(!CreateButton(chart,subwin,CloseAll,"CLOSE ALL",x_middle,l_y,x_size,Y_WIDTH))
          {
            return false;
          }
        CloseAll.ColorBackground(clrRed);

        if(!CreateLabel(chart,subwin,BuyLevel,DoubleToString(SymbolInfoDouble(_Symbol,SYMBOL_ASK)-StopLevel,_Digits),BORDER,l_y,left))
          {
            return false;
          }
        
        if(!CreateLabel(chart,subwin,MB,"MB",BORDER+55,l_y,left))
          {
            return false;
          }

        if(!CreateLabel(chart,subwin,SellLevel,DoubleToString(SymbolInfoDouble(_Symbol,SYMBOL_BID)+StopLevel,_Digits),l_x_right,l_y,right))
          {
            return false;
          }

        if(!CreateLabel(chart,subwin,MS,"MS",l_x_right-55,l_y,right))
          {
            return false;
          }
      
        l_y+=Y_WIDTH+Y_STEP;
      //**************RADIOS GROUP
        
        //TIPO = 1 É PRAS ESTRATEGIAS DE INVEST E 2 É PRA LOTES
        
      if(!CreateComboBox(chart,subwin,InvestGroup,BORDER,l_y,x_size*1.5,Y_WIDTH*2,1)) 
          {
            return false;
          }
      
            // CRIA A NEGRAGEM PAU NO CU DOS RADIO
        
        if(!CreateLabel(chart,subwin,Attacker,"Attacker",BORDER+Y_STEP/2,l_y+1,left))
          {
            return false;
          }
          Attacker.Hide();
        
        if(!CreateLabel(chart,subwin,Trender,"Trender",BORDER+Y_STEP/2,l_y+1,left))
          {
            return false;
          }
          Trender.Hide();
        
        if(!CreateLabel(chart,subwin,None,"None",BORDER+Y_STEP/2,l_y+1,left))
          {
            return false;
          }
          None.Hide();
        
        if(!CreateLabel(chart,subwin,Accumulation,"Accumulation",BORDER+Y_STEP/2,l_y+1,left))
          {
            return false;
          }
          Accumulation.Hide();
        
        if(!CreateLabel(chart,subwin,AcPock,"AcPock",BORDER+Y_STEP/2,l_y+1,left))
          {
            return false;
          }
          AcPock.Hide();


       if(!CreateComboBox(chart,subwin,LotesGroup,l_x_right-x_size*1.5,l_y,x_size*1.5,Y_WIDTH*2,2))
          {
            return false;
          }

         if(!CreateLabel(chart,subwin,Linear,"Linear",l_x_right-x_size*1.5+Y_STEP/2,l_y+1,left))
          {
            return false;
          }
          Linear.Hide();

          if(!CreateLabel(chart,subwin,Aritmetic,"Aritmetic",l_x_right-x_size*1.5+Y_STEP/2,l_y+1,left))
          {
            return false;
          }
          Aritmetic.Hide();

          if(!CreateLabel(chart,subwin,Geometric,"Geometric",l_x_right-x_size*1.5+Y_STEP/2,l_y+1,left))
          {
            return false;
          }
          Geometric.Hide();

      l_y+=Y_STEP+Y_WIDTH;

      //****************************PÓS GROUPS
      
        if(!CreateLabel(chart,subwin,LevelsLP,"Levels",l_x_right-x_size*1.5,l_y,left))
          {
            return false;
          }

        if(!CreateEdit(chart,subwin,LevelsP,"0",l_x_right-x_size*0.75,l_y,(int)(x_size*0.75),Y_WIDTH))
          {
            return false;
          }
        
        
        if(!CreateLabel(chart,subwin,MultiplerPL,"Multiplier",BORDER,l_y,left))
          {
            return false;
          }

        if(!CreateEdit(chart,subwin,MultiplerEd,"1",BORDER+x_size*0.75,l_y,(int)(x_size*0.75),Y_WIDTH))
          {
            return false;
          }
        l_y+=Y_WIDTH+Y_STEP;
        
        //Futuro
        // if(!CreateLabel(chart,subwin,On,"ON",l_x_right-x_size*1.5,l_y,left))
        //   {
        //     return false;
        //   }

        // if(!CreateBmpButton(chart,subwin,BotOn,l_x_right,l_y,"::Include\\Controls\\res\\CheckBoxOn.bmp","::Include\\Controls\\res\\CheckBoxOff.bmp",true))
        //   {
        //     return false;
        //   }
             
       
        if(!CreateLabel(chart,subwin,TicksGainPL,"Gain",BORDER,l_y,left))
          {
            return false;
          }

        if(!CreateEdit(chart,subwin,TicksGainP,"0",BORDER+x_size*0.75,l_y,(int)(x_size*0.75),Y_WIDTH))
          {
            return false;
          }

        
        if(!CreateLabel(chart,subwin,TicksLossPL,"Loss",l_x_right-x_size*1.5,l_y,left))
          {
            return false;
          }

        if(!CreateEdit(chart,subwin,TicksLossP,"0",l_x_right-x_size*0.75,l_y,(int)(x_size*0.75),Y_WIDTH))
          {
            return false;
          }
        l_y+=Y_WIDTH+Y_STEP;

        if(!CreateLabel(chart,subwin,FromPricePL,"FromPrice",BORDER,l_y,left))
          {
            return false;
          }

        if(!CreateEdit(chart,subwin,FromPriceP,"0",BORDER+x_size*0.75,l_y,(int)(x_size*0.75),Y_WIDTH))
          {
            return false;
          }

        
        if(!CreateLabel(chart,subwin,StopBoletaPL,"Stop",l_x_right-x_size*1.5,l_y,left))
          {
            return false;
          }

        if(!CreateEdit(chart,subwin,StopBoletaPE,"0",l_x_right-x_size*0.75,l_y,(int)(x_size*0.75),Y_WIDTH))
          {
            return false;
          }

        if(!CreateBmpButton(chart,subwin,StopBoletaP,l_x_right-x_size*0.75,l_y,"::Include\\Controls\\res\\CheckBoxOn.bmp","::Include\\Controls\\res\\CheckBoxOff.bmp",true))
          {
            return false;
          }
        
        l_y+=Y_WIDTH+Y_STEP;


                if(!CreateLabel(chart,subwin,SlippagePL,"Slippage",BORDER,l_y,left))
          {
            return false;
          }

        if(!CreateEdit(chart,subwin,SlippageP,"0",BORDER+x_size*0.75,l_y,(int)(x_size*0.75),Y_WIDTH))
          {
            return false;
          }
        
          
        if(!CreateLabel(chart,subwin,StopFinanceiroPL,"Stop $",l_x_right-x_size*1.5,l_y,left))
          {
            return false;
          }

        if(!CreateEdit(chart,subwin,StopFinanceiroP,"0",l_x_right-x_size*0.75,l_y,(int)(x_size*0.75),Y_WIDTH))
          {
            return false;
          }
        
        if(!CreateLabel(chart,subwin,Moeda2,SymbolInfoString(Symbol(),SYMBOL_CURRENCY_BASE),l_x_right-1,l_y+Y_WIDTH/3,right))
          {
            return false;
          }
          Moeda2.FontSize(Y_WIDTH*2/5);

        if(!CreateBmpButton(chart,subwin,StopFinanceiroButtonP,l_x_right-x_size*0.75,l_y,"::Include\\Controls\\res\\CheckBoxOn.bmp","::Include\\Controls\\res\\CheckBoxOff.bmp",true))
          {
            return false;
          }

        l_y+=Y_WIDTH+Y_STEP;

        if(!CreateLabel(chart,subwin,MagicPL,"Magic",BORDER,l_y,left))
          {
            return false;
          }

        if(!CreateEdit(chart,subwin,MagicP,"0",BORDER+x_size*0.75,l_y,(int)(x_size*0.75),Y_WIDTH))
          {
            return false;
          }
         
        
        if(!CreateLabel(chart,subwin,GainFinanceiroPL,"Gain $",l_x_right-x_size*1.5,l_y,left))
          {
            return false;
          }

        if(!CreateEdit(chart,subwin,GainFinanceiroP,"0",l_x_right-x_size*0.75,l_y,(int)(x_size*0.75),Y_WIDTH))
          {
            return false;
          }
        
        if(!CreateLabel(chart,subwin,Moeda,SymbolInfoString(Symbol(),SYMBOL_CURRENCY_BASE),l_x_right-1,l_y+Y_WIDTH/3,right))
          {
            return false;
          }
           Moeda.FontSize(Y_WIDTH*2/5);
         if(!CreateBmpButton(chart,subwin,GainFinanceiroButtonP,l_x_right-x_size*0.75,l_y,"::Include\\Controls\\res\\CheckBoxOn.bmp","::Include\\Controls\\res\\CheckBoxOff.bmp",true))
          {
            return false;
          }
  
        l_y+=Y_WIDTH+Y_STEP;
        
   

        //futuro
        // if(!CreateLabel(chart,subwin,FollowP,"Follow",l_x_right-x_size*1.5,l_y,left))
        //   {
        //     return false;
        //   }

        // if(!CreateBmpButton(chart,subwin,FollowBP,l_x_right-x_size*0.75,l_y,"::Include\\Controls\\res\\CheckBoxOn.bmp","::Include\\Controls\\res\\CheckBoxOff.bmp",true))
        //   {
        //     return false;
        //   }
        // //futuro
        // if(!CreateLabel(chart,subwin,ViewL,"View",BORDER,l_y,left))
        //   {
        //     return false;
        //   }

        // if(!CreateBmpButton(chart,subwin,View,BORDER+x_size,l_y,"::Include\\Controls\\res\\CheckBoxOn.bmp","::Include\\Controls\\res\\CheckBoxOff.bmp",true))
        //   {
        //     return false;
        //   }
        l_y+=Y_WIDTH+Y_STEP;

        
      //antigo
  

     

      //--- Create horizontal lines of SL & TP
        // if(!CreateHLine(chart,subwin,BuySL,SL_Line_color,"Buy Stop Loss"))
        //   {
        //     return false;
        //   }
        // if(!CreateHLine(chart,subwin,SellSL,SL_Line_color,"Sell Stop Loss"))
        //   {
        //     return false;
        //   }
        // if(!CreateHLine(chart,subwin,BuyTP,TP_Line_color,"Buy Take Profit"))
        //   {
        //     return false;
        //   }
        // if(!CreateHLine(chart,subwin,SellTP,TP_Line_color,"Sell Take Profit"))
          // {
          //   return false;
          // }
      return true;
    }
  //+------------------------------------------------------------------+
  //| Create Label Object                                              |
  //+------------------------------------------------------------------+
  bool CTradePanel::CreateLabel(const long chart,const int subwindow,CLabel &object,const string text,const uint x,const uint y,label_align align)
    {
    // All objects mast to have separate name
    string name=m_name+"Label"+(string)ObjectsTotal(chart,-1,OBJ_LABEL);
    //--- Call Create function
    if(!object.Create(chart,name,subwindow,x,y,0,0))
      {
        return false;
      }
    //--- Addjust text
    if(!object.Text(text))
      {
        return false;
      }
    //--- Aling text to Dialog box's grid
    ObjectSetInteger(chart,object.Name(),OBJPROP_ANCHOR,(align==left ? ANCHOR_LEFT_UPPER : (align==right ? ANCHOR_RIGHT_UPPER : ANCHOR_UPPER)));
    //--- Add object to controls
    if(!Add(object))
      {
        return false;
      }
    return true;
    }
  //+------------------------------------------------------------------+
  //| Create Button                                                    |
  //+------------------------------------------------------------------+
  bool CTradePanel::CreateButton(const long chart,const int subwindow,CButton &object,const string text,const uint x,const uint y,const uint x_size,const uint y_size)
    {
    // All objects must to have separate name
    string name=m_name+"Button"+(string)ObjectsTotal(chart,-1,OBJ_BUTTON);
    //--- Call Create function
    if(!object.Create(chart,name,subwindow,x,y,x+x_size,y+y_size))
      {
        return false;
      }
    //--- Addjust text
    if(!object.Text(text))
      {
        return false;
      }
    //--- set button flag to unlock
    object.Locking(false);
    //--- set button flag to unpressed
    if(!object.Pressed(false))
      {
        return false;
      }
    //--- Add object to controls
    if(!Add(object))
      {
        return false;
      }
    return true;
    }
  //+------------------------------------------------------------------+
  //| Create RadioGroup  Object                                              |
  //+------------------------------------------------------------------+
  bool CTradePanel::CreateRadioGroup(const long chart,const int subwindow,CRadioGroup &object,const uint x,const uint y,const uint x_size,const uint y_size,int tipo){
     
      string name=m_name+"RadioButton"+tipo;

          //--- Call Create function
          if(tipo==1)
    if(!object.Create(chart,name,subwindow,x,y,x+x_size,y+Y_WIDTH*(TRENDSIZE+ACUMULATIONSIZE)))
      {
        return false;
      }
      if(tipo==2)
       if(!object.Create(chart,name,subwindow,x,y,x+x_size,y+Y_WIDTH*(LOTESSIZE)))
      {
        return false;
      }
        //--- set button flag to unlock
   // object.Locking(false);
    //--- set button flag to unpressed
   //  if(!object.Pressed(false))
   //      {
   //     return false;
   //    }
   // TIPO = 1 É PRAS ESTRATEGIAS DE INVEST, =2 É PRAS ESTRATEGIAS DE QUANTIDADE DE LOTES
   if(tipo==1){
    for(int i=0;i<TRENDSIZE;i++){
     
       if(!object.AddItem(TrenderString[i],i))
       {
       
        return false;
      
        }
    }
    for(int i=0;i<ACUMULATIONSIZE;i++){
      // if(tipo == 2)
       if(!object.AddItem(AcumulationString[i],i+TRENDSIZE))
      {
    
        return false;
       
      } 
    }
   }
  
   if(tipo==2){
    for(int i = 0;i<LOTESSIZE;i++)
    {
           if(!object.AddItem(Lotees[i],i))
      {
    
        return false;
       
      } 

    }

   }
    



    //--- Add object to controls
    if(!Add(object))
      {
        return false;
      }



    return true;


  }
  //+------------------------------------------------------------------+
  //| Create Edit  Object                                              |
  //+------------------------------------------------------------------+
  bool CTradePanel::CreateEdit(const long chart,const int subwindow,CEdit &object,const string text,const uint x,const uint y,const uint x_size,const uint y_size)
    {
    // All objects must to have separate name
    string name=m_name+"Edit"+(string)ObjectsTotal(chart,-1,OBJ_EDIT);
    //--- Call Create function
    if(!object.Create(chart,name,subwindow,x,y,x+x_size,y+y_size))
      {
        return false;
      }
    //--- Addjust text
    if(!object.Text(text))
      {
        return false;
      }
    //--- Align text in Edit box
    if(!object.TextAlign(ALIGN_CENTER))
      {
        return false;
      }
    //--- set Read only flag to false
    if(!object.ReadOnly(false))
      {
        return false;
      }
    //--- Add object to controls
    if(!Add(object))
      {
        return false;
      }
    return true;
    }
  //+------------------------------------------------------------------+
  //| Create BMP Button         and combo box                                       |
  //+------------------------------------------------------------------+
  bool CTradePanel::CreateBmpButton(const long chart,const int subwindow,CBmpButton &object,const uint x,const uint y,string BmpON,string BmpOFF,bool lock)
    {
    // All objects must to have separate name
    string name=m_name+"BmpButton"+(string)ObjectsTotal(chart,-1,OBJ_BITMAP_LABEL);
    //--- Calculate coordinates
    uint y1=(uint)(y-(Y_STEP-CONTROLS_BUTTON_SIZE)/2);
    uint y2=y1+CONTROLS_BUTTON_SIZE;
    //--- Call Create function
    if(!object.Create(m_chart_id,name,m_subwin,x-CONTROLS_BUTTON_SIZE,y1,x,y2))
        return(false);
    //--- Assign BMP pictuers to button status
    if(!object.BmpNames(BmpOFF,BmpON))
        return(false);
    //--- Add object to controls
    if(!Add(object))
        return(false);
    //--- set Lock flag to true
    object.Locking(true);
   //--- succeeded
    return(true);
    }

  bool CTradePanel::CreateComboBox(const long chart,const int subwindow,CComboBox &object,const uint x,const uint y,const uint x_size,const uint y_size,int tipo){

         string name=m_name+"Box"+tipo;

          //--- Call Create function
          if(tipo==1)
    if(!object.Create(chart,name,subwindow,x,y,x+x_size,y+Y_WIDTH))
      {
        
        return false;
      }
      if(tipo==2)
       if(!object.Create(chart,name,subwindow,x,y,x+x_size,y+Y_WIDTH))
      {
        return false;
      }

   if(tipo==1){
      // object.ListViewItems(TRENDSIZE+ACUMULATIONSIZE);
    for(int i=0;i<TRENDSIZE;i++){
     
       if(!object.AddItem(TrenderString[i],i))
       {
       
        return false;
      
        }
    }
    
    for(int i=0;i<ACUMULATIONSIZE;i++){
     
       if(!object.AddItem(AcumulationString[i],i+TRENDSIZE))
      {
    
        return false;
       
      } 
    }
   }
  
   if(tipo==2){
     //  object.ListViewItems(LOTESSIZE);
    for(int i = 0;i<LOTESSIZE;i++)
    {
           if(!object.AddItem(Lotees[i],i))
      {
    
        return false;
       
      } 

    }

   }
    
    //--- Add object to controls
    if(!Add(object))
      {
        return false;
      }



    return true;
  
  }
  //+------------------------------------------------------------------+
  //| Event "New Tick                                                  |
  //+------------------------------------------------------------------+
  void CTradePanel::OnTick(void)
     { 
         
    //--- Change Ask and Bid prices on panel
    ASK.Text(DoubleToString(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits));
    BID.Text(DoubleToString(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits));
    BuyLevel.Text(DoubleToString(SymbolInfoDouble(_Symbol,SYMBOL_ASK)-StopLevel,_Digits));
    SellLevel.Text(DoubleToString(SymbolInfoDouble(_Symbol,SYMBOL_BID)+StopLevel,_Digits));
    
  
      ChartRedraw();
      
      return;
      }
  //+------------------------------------------------------------------+
  //| Event Handling                                                   |
  //+------------------------------------------------------------------+
     EVENT_MAP_BEGIN(CTradePanel) // Qual evento, quem sofre a ação, qual função chama.
      ON_EVENT(ON_END_EDIT,Lots,LotsEndEdit)
      ON_EVENT(ON_CLICK,Increase,IncreaseLotClick)
      ON_EVENT(ON_CLICK,Decrease,DecreaseLotClick)

      ON_EVENT(ON_END_EDIT,PriceForOperate,PriceEndEdit)
      ON_EVENT(ON_CLICK,IncreasePrice,IncreasePriceClick)
      ON_EVENT(ON_CLICK,DecreasePrice,DecreasePriceClick)

      ON_EVENT(ON_END_EDIT,MagicP,MagicEndEdit)

      ON_EVENT(ON_END_EDIT,StopFinanceiroP,StopMoneyEndEdit)
      ON_EVENT(ON_END_EDIT,GainFinanceiroP,GainMoneyEndEdit)

      ON_EVENT(ON_END_EDIT,SlippageP,SlippageEndEdit)
      ON_EVENT(ON_END_EDIT,TicksGainP,GainEndEdit)
      ON_EVENT(ON_END_EDIT,FromPriceP,FromPriceEndEdit)
      ON_EVENT(ON_END_EDIT,TicksLossP,TicksLossEndEdit)
      ON_EVENT(ON_END_EDIT,StopBoletaPE,LossEndEdit)
      ON_EVENT(ON_END_EDIT,LevelsP,LevelsEndEdit)
      ON_EVENT(ON_END_EDIT,MultiplerEd,MultiplerEndEdit)
   
      //ON_EVENT(ON_CLICK,View,ViewClick)
      // ON_EVENT(ON_CLICK,FollowBP,FollowClick)

      ON_EVENT(ON_CLICK,StopFinanceiroButtonP,StopFinanceiroClick)
      ON_EVENT(ON_CLICK,GainFinanceiroButtonP,GainFinanceiroClick)
      ON_EVENT(ON_CLICK,StopBoletaP,StopBoletaClick)

      ON_EVENT(ON_CLICK,SELLPENDENT,SellPendentClick)
      ON_EVENT(ON_CLICK,BUYPENDENT,BuyPendentClick)
      ON_EVENT(ON_CLICK,CloseAll,CloseClick)
      ON_EVENT(ON_CLICK,CloseOrders,CloseOrdersClick)
      ON_EVENT(ON_CLICK,BUY,BuyClick)
      ON_EVENT(ON_CLICK,SELL,SellClick)
      ON_EVENT(ON_CLICK,BotOn,BotOnClick)
      ON_EVENT(ON_CLICK,View,ViewClick)


      // ON_EVENT(ON_CLICK,StopLoss_line,StopLossLineClick)
      // ON_EVENT(ON_CLICK,TakeProfit_line,TakeProfitLineClick)
      

      ON_EVENT(ON_CHANGE,InvestGroup,InvestClick)
      ON_EVENT(ON_CHANGE,LotesGroup,LotsClick)
      
      EVENT_MAP_END(CAppDialog);
  //+------------------------------------------------------------------+
  //| LOTES ->                           |
  //+------------------------------------------------------------------+
    void CTradePanel::LotsEndEdit(void)
      {
     
      //--- Read and normalize lot value
      cur_lot=NormalizeLots(StringToDouble(Lots.Text()));
                 //debug
       // Print("ENTROU Lots End Edit " + cur_lot);
      //--- Output lot value to panel
      Lots.Text(DoubleToString(cur_lot,DigitsLotes));
     
      ChartRedraw();
        return;
      }
    //+------------------------------------------------------------------+
    //|  Increase Lot Click                                              |
    //+------------------------------------------------------------------+
    void CTradePanel::IncreaseLotClick(void)
      {
                        //debug
      //  Print("ENTROU Increase Lot Click " + cur_lot + "STEP " + SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP));
      //--- Read and normalize lot value
      cur_lot=NormalizeLots(StringToDouble(Lots.Text())+SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP));
      //--- Output lot value to panel
      Lots.Text(DoubleToString(cur_lot,DigitsLotes));
      //--- Call end edit lot function
      LotsEndEdit();
      return;
      }
    //+------------------------------------------------------------------+
    //|  Decrease Lot Click                                              |
    //+------------------------------------------------------------------+
    void CTradePanel::DecreaseLotClick(void)
      {
      //--- Read and normalize lot value
      cur_lot=NormalizeLots(StringToDouble(Lots.Text())-SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP));
      //--- Output lot value to panel
      Lots.Text(DoubleToString(cur_lot,DigitsLotes));
      LotsEndEdit();
      }
    //+------------------------------------------------------------------+
    //|  Normalization of order volume                                   |
    //+------------------------------------------------------------------+
    double CTradePanel::NormalizeLots(double lots)
      {

       
      double result=0;
      double minLot=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MIN);
      double maxLot=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_MAX);
      double stepLot=SymbolInfoDouble(_Symbol,SYMBOL_VOLUME_STEP);
      if (lots>0)
          {
          lots=MathMax(minLot,lots);
          lots=minLot+NormalizeDouble((lots-minLot)/stepLot,0)*stepLot;
          result=MathMin(maxLot,lots);
          }
      else
          result=minLot;   
          //debug
       //Print("ENTROU Normalize Lots Digits" + DigitsLotes + "result  " + result);
          return (NormalizeDouble(result,DigitsLotes));
      }
  //+------------------------------------------------------------------+
  //|  -> PREÇO                                                        |
  //+------------------------------------------------------------------+
    void CTradePanel::PriceEndEdit(void)
      {
      //--- Read and normalize lot value
      cur_price=NormalizePrice(StringToDouble(PriceForOperate.Text()));
      //--- Output lot value to panel
      PriceForOperate.Text(DoubleToString(cur_price,Digits));

      ChartRedraw();
        return;
      }
      //+------------------------------------------------------------------+
    //|  Increase Price Click                                              |
    //+------------------------------------------------------------------+
    void CTradePanel::IncreasePriceClick(void)
      {
      //--- Read and normalize lot value
      cur_price=NormalizePrice(StringToDouble(PriceForOperate.Text())+MyPoint);
      //--- Output lot value to panel
      PriceForOperate.Text(DoubleToString(cur_price,Digits));
      //--- Call end edit lot function
      PriceEndEdit();
      return;
      }
    //+------------------------------------------------------------------+
    //|  Decrease Price Click                                              |
    //+------------------------------------------------------------------+
    void CTradePanel::DecreasePriceClick(void)
      {
    
        cur_price=NormalizePrice(StringToDouble(PriceForOperate.Text())-MyPoint);
        //--- Output lot value to panel
        PriceForOperate.Text(DoubleToString(cur_price,Digits));
        //--- Call end edit lot function
        PriceEndEdit();
        return;
        }
    //+------------------------------------------------------------------+
    //|  Normalization of price                                 |
    //+------------------------------------------------------------------+
    double CTradePanel::NormalizePrice(double price){
      double result=0;
    
      if (price>0)
          {
            result = MathRound(price/MyPoint)*MyPoint;
          }
      else
          result=SymbolInfoDouble(_Symbol,SYMBOL_LAST);   
      
          return (NormalizeDouble(result,Digits));
      }
  //+------------------------------------------------------------------+
  //|  Magic                         |
  //+------------------------------------------------------------------+
      void CTradePanel::MagicEndEdit(void)
      {
      //--- Read and normalize lot value
      if(magic<0)
        magic = 384;
      
      magic=MathRound(StringToDouble(MagicP.Text()));
      //--- Output lot value to panel
      MagicP.Text(DoubleToString(magic,0));
      Trade.SetExpertMagicNumber(magic);
      ChartRedraw();
        return;
      }
  //+------------------------------------------------------------------+
  //|  Stop e Gain$                      |
  //+------------------------------------------------------------------+
   void CTradePanel::StopMoneyEndEdit(void)
      {
      //--- Read and normalize lot value
      LossMoney=NormalizeMoney(StringToDouble(StopFinanceiroP.Text()));
      //--- Output lot value to panel
      StopFinanceiroP.Text(DoubleToString(LossMoney,DigitsMoeda));

      ChartRedraw();
            
      return;
      }

    void CTradePanel::GainMoneyEndEdit(void)
      {
      //--- Read and normalize lot value
      GainMoney=NormalizeMoney(StringToDouble(GainFinanceiroP.Text()));
      //--- Output lot value to panel
      GainFinanceiroP.Text(DoubleToString(GainMoney,DigitsMoeda));

      ChartRedraw();
            
      return;
      }  
      

   double CTradePanel::NormalizeMoney(double money){

      double result=0;
           
      if (money>0)
          {
            result = NormalizeDouble(money,DigitsMoeda);
          }
      else
          result=NormalizeDouble(0,DigitsMoeda);   
      
          return (NormalizeDouble(result,DigitsMoeda));
      }

  //+------------------------------------------------------------------+
  //| Update Gain/FromPrice/Loss/Levels/Slippage/Stop                                      |
  //+------------------------------------------------------------------+
    
     void CTradePanel::SlippageEndEdit(void)
        {
        //--- Read and normalize lot value
       Slippage=MathRound(StringToDouble(SlippageP.Text()));
        //--- Output lot value to panel
        SlippageP.Text(DoubleToString(Slippage,0));
        
        Trade.SetDeviationInPoints(Slippage);
        ChartRedraw();
          return;
        }

     void CTradePanel::GainEndEdit(void)
        {
        //--- Read and normalize lot value
       Gain=MathRound(StringToDouble(TicksGainP.Text()));
        //--- Output lot value to panel
        TicksGainP.Text(DoubleToString(Gain,0));

        ChartRedraw();
          return;
        }

     void CTradePanel::FromPriceEndEdit(void)
        {
        //--- Read and normalize lot value
       FromPrice=MathRound(StringToDouble(FromPriceP.Text()));
        //--- Output lot value to panel
        
        if(FromPrice<StopLevel/MyPoint)
        FromPrice=StopLevel/MyPoint;
        
        FromPriceP.Text(DoubleToString(FromPrice,0));

        ChartRedraw();
          return;
        }

     void CTradePanel::TicksLossEndEdit(void)
        {
        //--- Read and normalize lot value
       Ticks=MathRound(StringToDouble(TicksLossP.Text()));
        //--- Output lot value to panel
        TicksLossP.Text(DoubleToString(Ticks,0));

        ChartRedraw();
          return;
        }

     void CTradePanel::LossEndEdit(void)
        {
        //--- Read and normalize lot value
       Loss=MathRound(StringToDouble(StopBoletaPE.Text()));
           if(Loss<SymbolInfoInteger(Symbol(),SYMBOL_SPREAD))
            Loss=SymbolInfoInteger(Symbol(),SYMBOL_SPREAD)*1.1;
        //--- Output lot value to panel
        StopBoletaPE.Text(DoubleToString(Loss,0));

        ChartRedraw();
          return;
        }

     void CTradePanel::LevelsEndEdit(void)
        {
        //--- Read and normalize lot value
       Niveis=MathRound(StringToDouble(LevelsP.Text()));
        //--- Output lot value to panel
        LevelsP.Text(DoubleToString(Niveis,0));

        ChartRedraw();
          return;
        }

      void CTradePanel::MultiplerEndEdit(void)
        {
        //--- Read and normalize lot value
       Multipler=MathRound(StringToDouble(MultiplerEd.Text()));
       if(Multipler<1)
       Multipler = 1;
       
        //--- Output lot value to panel
        MultiplerEd.Text(DoubleToString(Multipler,0));

        ChartRedraw();
          return;
        }



  //+------------------------------------------------------------------+
  //| Click StopBoleta/Stop$/Follow                    |
  //+------------------------------------------------------------------+ 
      void CTradePanel::StopBoletaClick(void)
        {
          if(StopBoletaP.Pressed()){
            StopBoleta = true;
            
          }
          else{
            StopBoleta = false;
            
          }
          ChartRedraw();
          return;
          }

      void CTradePanel::StopFinanceiroClick(void)
        {
          if(StopFinanceiroButtonP.Pressed()){
            StopFinanceiro = true;
             }
          else{
            StopFinanceiro = false;
         
          }
          ChartRedraw();
          return;
          }

      void CTradePanel::GainFinanceiroClick(void)
        {
          
          if(GainFinanceiroButtonP.Pressed()){
             GainFinanceiro = true;}
        
          else{
              GainFinanceiro = false;
              }
          ChartRedraw();
          return;
          }

      // void CTradePanel::FollowClick(void)
      //   {
      //     if(FollowBP.Pressed()){
      //       Follow = false;
      //       FollowBP.Pressed(false);
      //     }
      //     else{
      //       Follow = true;
      //       FollowBP.Pressed(true);
      //     }
      //     ChartRedraw();
      //     return;
      //     }



  
  //+------------------------------------------------------------------+
  //|  Painel Inicial (buy,sell,close all,buy pendent, C orders e sell pendent)                                                |
  //+------------------------------------------------------------------+
    void CTradePanel::BuyClick(void)
      {
      cur_lot=NormalizeLots(StringToDouble(Lots.Text()));
      Lots.Text(DoubleToString(cur_lot,2));
      double price=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
     
      if(!Trade.Buy(NormalizeLots(cur_lot),_Symbol))
          Print("Fail to buyclick , Error: " + GetLastError());

          agrediu = 1;
      return;
      }
    //+------------------------------------------------------------------+
    //|  Click SELL button                                               |
    //+------------------------------------------------------------------+
    void CTradePanel::SellClick(void)
      {
      cur_lot=NormalizeLots(StringToDouble(Lots.Text()));
      Lots.Text(DoubleToString(cur_lot,2));
      double price=SymbolInfoDouble(_Symbol,SYMBOL_BID);

      if(!Trade.Sell(NormalizeLots(cur_lot),_Symbol))
          Print("Fail to sellclick , Error: " + GetLastError());

          agrediu = 1;
      return;
      }

    //+------------------------------------------------------------------+
    //|  Click CLOSE BUY button                                          |
    //+------------------------------------------------------------------+
    void CTradePanel::CloseClick(void)
      {
                //debug
        
        CloseOrders();
        return;
      }

    //+------------------------------------------------------------------+
    //|  Click CLOSE orders button                                          |
    //+------------------------------------------------------------------+
    void CTradePanel::CloseOrdersClick(void)
      {
        //debug
        
        int orders = OrdersTotal();
        ulong tickete;

            for(int i = orders-1 ; i >= 0 ;i--)
          {
          tickete  = OrderGetTicket (i);
          
                if (OrderGetString(ORDER_SYMBOL) == _Symbol && OrderGetInteger(ORDER_MAGIC) == magic)
              {
              ResetLastError();
              if(!Trade.OrderDelete(tickete))
                {
                Print("Fail to delete ticket ", tickete  ,": Error ",GetLastError());

                }

              }
          }


        return;
      }
    //+------------------------------------------------------------------+
    //|  Click BUY PENDENT button                                          |
    //+------------------------------------------------------------------+
    void CTradePanel::BuyPendentClick(void)
      {
            
            if(!Trade.BuyLimit(cur_lot,NormalizeDouble(cur_price,Digits)))
            {
              //--- failure message
              Print("Buy() method failed. Return code=",Trade.ResultRetcode(),
                ". Code description: ",Trade.ResultRetcodeDescription());
                      return;
            }
                            
        
            return;
      }
    //+------------------------------------------------------------------+
    //|  Click SELL PENDENT                                          |
    //+------------------------------------------------------------------+
    void CTradePanel::SellPendentClick(void)
      {
        if(!Trade.SellLimit(cur_lot,NormalizeDouble(cur_price,Digits)))
            {
              //--- failure message
              Print("Buy() method failed. Return code=",Trade.ResultRetcode(),
                ". Code description: ",Trade.ResultRetcodeDescription());
                      return;
            }
                            
        
            return;
      }
  //+------------------------------------------------------------------+
  //|  Buttons de estrategias (invest e lotes)                                            |
  //+------------------------------------------------------------------+
      // None = 0;
      // Trender = 1;
      // Attacker = 2;
      // Acumulationer = 3;
      // // AcumulationPock = 4;
      void CTradePanel::InvestClick(void){

          int k = InvestGroup.Value();
          
         

         if (!Marcador) // I have no open orders on this chart
             switch(k){
               case 0:
               mode = 0;
               break;

               case 1:
               mode = 1;
               break;

               case 2:
               mode = 2;
               break;

               case 3:
               mode = 3;
               break;

               case 4:
               mode = 4;
               break;
               
               case 5:
               mode = 5;
               break;

               case 6:
               mode = 6;
               break;
               
               
             }
          return;
      }

     void CTradePanel::LotsClick(void){

          int k = LotesGroup.Value();

          if (!Marcador) // I have no open orders on this chart
             switch(k){
               case 0:
               acumulation = LINEAR;
               break;

               case 1:
               acumulation = ARITMETIC;
               break;

               case 2:
               acumulation = GEOMETRIC;
               break;
               
             }
          return;
      }

  //+------------------------------------------------------------------+
  //|  View, ON, LabelHide/Show   |
  //+------------------------------------------------------------------+
      
      void LabelHide(){

                   

             switch(mode){
               case 0:
               None.Hide();
               break;

               case 1:
               Trender.Hide();
               break;

               case 2:
               Attacker.Hide();
               break;

               case 3:
               Accumulation.Hide();
               break;

               case 4:
               AcPock.Hide();
               break;
               
               case 5:
              // mode = 5;
               break;

               case 6:
              // mode = 6;
               break;
                              
             }

             switch((int)acumulation){
               case 0:
               Linear.Hide();
               break;

               case 1:
               Aritmetic.Hide();
               break;

               case 2:
               Geometric.Hide();
               break;
               
             }

          


      }
      void LabelShow(){

          

             switch(mode){
               case 0:
               None.Show();
               break;

               case 1:
               Trender.Show();
               break;

               case 2:
               Attacker.Show();
               break;

               case 3:
               Accumulation.Show();
               break;

               case 4:
               AcPock.Show();
               break;
               
               case 5:
              // mode = 5;
               break;

               case 6:
              // mode = 6;
               break;
                              
             }
          if(mode == 3 || mode == 4)
         switch((int)acumulation){
               case 0:
               Linear.Show();
               break;

               case 1:
               Aritmetic.Show();
               break;

               case 2:
               Geometric.Show();
               break;
               
             }

        
          


        return;
      }



      void CTradePanel::BotOnClick(void)
        {
          if(BotOn.Pressed()){
            ONCONTROL = false;
            BotOn.Pressed(false);
          }
          else{
            ONCONTROL = true;
            BotOn.Pressed(true);
          }
          ChartRedraw();
          return;
          }


      void CTradePanel::ViewClick(void)
        {
          if(View.Pressed()){
            ViewLines = false;
            View.Pressed(false);
          }
          else{
            ViewLines = true;
            View.Pressed(true);
          }
          ChartRedraw();
          return;
          }


  //+------------------------------------------------------------------+
  //| Run of Trade Panel                                               |
  //+------------------------------------------------------------------+ Inicia valores (dele, recicla boy)
  bool CTradePanel::Run(void)
    {
    IniFileLoad();

    cur_price = StringToDouble(PriceForOperate.Text());
    
    cur_lot=StringToDouble(Lots.Text());
    
    Niveis = StringToDouble(LevelsP.Text());
    Multipler = StringToDouble(MultiplerEd.Text());
    if(Multipler == 0)
    Multipler = 1;

    Gain = StringToDouble(TicksGainP.Text());
    Ticks = StringToDouble(TicksLossP.Text());
    FromPrice = StringToDouble(FromPriceP.Text());
    if(FromPrice<StopLevel){
      FromPrice = StopLevel/MyPoint;
      FromPriceP.Text(DoubleToString(FromPrice,0));}

    Loss = StringToDouble(StopBoletaPE.Text());
    if(Loss<SymbolInfoInteger(Symbol(),SYMBOL_SPREAD))
    Loss=SymbolInfoInteger(Symbol(),SYMBOL_SPREAD)*1.1;

    Slippage = StringToDouble(SlippageP.Text());
    LossMoney = StringToDouble(StopFinanceiroP.Text());
    magic = StringToDouble(MagicP.Text());
    GainMoney = StringToDouble(GainFinanceiroP.Text());
    StopFinanceiro = StopFinanceiroButtonP.Pressed();
    GainFinanceiro = GainFinanceiroButtonP.Pressed();
    mode = InvestGroup.Value();
    if(mode<0){
    mode=0;
    InvestGroup.SelectByValue(0);
    }

    acumulation = LotesGroup.Value();
    LotesGroup.SelectByValue(acumulation);
    
    
    if((int)acumulation<0){
    acumulation = LINEAR;
    LotesGroup.SelectByValue(0);
    }

    StopBoleta = StopBoletaP.Pressed();
    Trade.SetExpertMagicNumber(magic);
    Trade.SetDeviationInPoints(Slippage);

    // StopLossLineClick();
    // TakeProfitLineClick();
    return(CAppDialog::Run());
    }

  void CTradePanel::Destroy(const int reason)
  {

   CAppDialog::Destroy(reason);
   return;
  }

  