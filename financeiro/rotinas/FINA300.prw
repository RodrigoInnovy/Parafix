#INCLUDE "FINA300.CH"
#INCLUDE "PROTHEUS.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ Fina300  ³ Autor ³ Pilar S Albaladejo    ³ Data ³ 26/07/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Retorno do arquivo SISPAG                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Fina300()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Fina300(nPosArotina)

Local lPanelFin := If (FindFunction("IsPanelFin"),IsPanelFin(),.F.)
Private aRotina := MenuDef()
PRIVATE dDataLanc := dDataBase,cPadrao := "530"
PRIVATE cBcoDe    := CriaVar("E2_PORTADO"),cBcoAte := CriaVar("E2_PORTADO")
PRIVATE dVencIni  := dDataBase,dVencFim := dDataBase,dBaixa := dDataBase,nJuros := 0
PRIVATE nCorrecao := 0
PRIVATE cCtBaixa  := GetMv("MV_CTBAIXA")
PRIVATE cMarca    := GetMark( )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o cabe‡alho da tela de baixas                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE cCadastro := STR0013  //"Sispag"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica o n£mero do Lote                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cLote
LoteCont( "FIN" )

DEFAULT nPosArotina := 0

If nPosArotina > 0 // Sera executada uma opcao diretamento de aRotina, sem passar pela mBrowse
   dbSelectArea("SE2")
   bBlock := &( "{ |a,b,c,d,e| " + aRotina[ nPosArotina,2 ] + "(a,b,c,d,e) }" )
   Eval( bBlock, Alias(), (Alias())->(Recno()),nPosArotina)
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Endere‡a a Fun‡„o de BROWSE                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	mBrowse( 6, 1,22,75,"SE2",,"!E2_SALDO")
Endif

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ fA300Ret ³ Autor ³ Pilar S Albaladejo    ³ Data ³ 26/07/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Comunica‡„o Banc ria - Retorno SisPag                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fA300Ret()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FinA200                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function fA300Ret(cAlias)

Local lPanelFin := If (FindFunction("IsPanelFin"),IsPanelFin(),.F.)
LOCAL nOpca := 0
LOCAL aSays:={}
LOCAL aButtons:={}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³      ** Carrega Fun‡„o Pergunte **        ³
//³ mv_par01 - Mostra lan‡amentos cont beis   ³
//³ mv_par02 - Aglutina lan‡amentos           ³
//³ mv_par03 - Atualiza moedas por            ³
//³ mv_par04 - Arquivo de entrada             ³
//³ mv_par05 - Arquivo de config              ³
//³ mv_par06 - C¢digo do banco                ³
//³ mv_par07 - C¢digo da agencia              ³
//³ mv_par08 - C¢digo da conta                ³
//³ mv_par09 - Sub-conta                      ³
//³ mv_par10 - Abate desconto da comiss„o     ³
//³ mv_par11 - Contabiliza On-Line            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetKey (VK_F12,{|a,b| AcessaPerg("AFI300",.T.)})
pergunte("AFI300",.F.)
nOpca := 0
AADD (aSays, STR0014 ) //"   Esta opção processa o Arquivo de retorno de Comunicação Bancária SisPag"
AADD (aSays, STR0015)  //"Deverão ser verificados os parâmetros para correto processamento"
If lPanelFin  //Chamado pelo Painel Financeiro			
	aButtonTxt := {}				
	AADD(aButtonTxt,{STR0001,STR0001, {||Pergunte("AFI300",.T. )}}) // Parametros						
	FaMyFormBatch(aSays,aButtonTxt,{||nOpca:=1},{||nOpca:=0})	
Else
	AADD(aButtons, { 1,.T.,{|o| nOpca:= 1,o:oWnd:End()}} )
	AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )
	AADD(aButtons, { 5,.T.,{|| Pergunte("AFI300",.T. ) } } )
	FormBatch( STR0005, aSays, aButtons )  //"Retorno Arquivo SisPag"
Endif

lDigita:=IIF(mv_par01 == 1,.T.,.F.)
lAglut :=IIF(mv_par02 == 1,.T.,.F.)
lContabiliza:= Iif(mv_par11 == 1,.T.,.F.)

IF nOpca == 1
	Processa({|lEnd| _Fa300Processa()})
EndIF
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³Fa300Proce³ Autor ³                       ³ Data ³ 26/07/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Comunica‡„o Banc ria - Retorno SisPag                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³Fa300Processa()                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FinA200                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function _fA300Processa()

Local cPadrao := "" , nC := 0 , lCabec := .f.
Local cNumTit    := ""
Local nRegistro := 0

Local aHeadA := {}
Local aHead1 := {}
Local aHead2 := {}
Local aDetA  := {}
Local aDetB  := {}
Local aDetJ  := {}
Local aDetN  := {}
Local aDetO  := {}
Local aTrai1 := {}
Local aTrai2 := {}
Local aTraiA := {}
Local nBytes := 0
Local nTamArq := 0 , nLidos := 0
Local cArqConf := "" , cArqEnt := ""
Local nHdlConf := 0
Local nTotal := 0
LOCAL lF300SE5 := ExistBlock("F300SE5" )
LOCAL nValorTotal := 0
Local lFa300Oco := ExistBlock("FA300OCO")
Local lFa300Ren := ExistBlock("FA300Ren")
Local aTipoSeq := {}
Local cSequencia := "00"
Local nTamPre	:= TamSX3("E2_PREFIXO")[1]
Local nTamNum	:= TamSX3("E2_NUM")[1] 
Local nTamParc := TamSx3("E2_PARCELA")[1]
Local nTamTit  := TamSX3("E2_PREFIXO")[1]+TamSX3("E2_NUM")[1]+TamSX3("E2_PARCELA")[1]+;
						TamSX3("E2_TIPO")[1]+TamSX3("E2_FORNECE")[1]
Local nMulta := 0
Local nAscan
Local nLaco := 0
Local cTipoImp := "01"
Local nPos := 15
Local nAcresc := 0
Local nDecresc := 0
Local cFilAnt :=""
Local lF300Fil := ExistBlock("F300FIL")
Local aCpos := {}
Local cLotefin := " "
Local	cDesc1 := "DATA" 
Local	cDesc2 := "PRINCIPAL"     
Local	cDesc3 := "MULTA"
Local	cDesc4 := "JUROS"			
Local	lDataGrv := .F.      
Local	lDifPag := GetNewPar("MV_DIFPAG",.F.)
Local nValPadrao := 0
Local nValPag := 0
Local aCampos := {}
Local nI := 0 
Local nCpoTp := 0
Local cTpDoc := ""
Local cHistMov := ""
Local lNewIndice := FaVerInd()  //Verifica a existencia dos indices de IDCNAB sem filial
Local cFilOrig   := cFilAnt	// Salva a filial para garantir que nao seja alterada em customizacao
Local lPaMov := .F.
Local cKeySE5 := ""
Local cFA30   := ExistBlock ("FA300PA")
Local cCusto  := GetMv("MV_MCUSTO")


Private cBanco
Private cAgencia
Private cConta
Private lAut := .f.
Private nTotAbat := 0
Private cArquivo

VALOR := 0
STRLCTPAD := " "

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona no Banco indicado                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cBanco  := mv_par06
cAgencia:= mv_par07
cConta  := mv_par08
cSubCta := mv_par09

SA6->( dbSeek(xFilial("SA6")+cBanco+cAgencia+cConta) )
SEE->( dbSeek(xFilial("SEE")+cBanco+cAgencia+cConta+cSubCta) )
If !SEE->( found() )
	Help(" ",1,"PAR150")
	Return .F.
Endif

cTabela := Iif( Empty(SEE->EE_TABELA), "17" , SEE->EE_TABELA )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se a tabela existe           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !SX5->( dbSeek( xFilial("SX5") + cTabela ) )
	Help(" ",1,"PAR150")
	Return .F.
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica o numero do Lote                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE cLote
SX5->( dbSeek(xFilial("SX5")+"09FIN") )
cLote := Substr(X5Descri(),1,4)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abre arquivo de configura‡„o ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cArqConf := mv_par05
IF !FILE(cArqConf)
	Help(" ",1,"NOARQPAR")
	Return .F.
Else
	nHdlConf := FOPEN(cArqConf,0)
EndIF

nTamArq := FSEEK(nHdlConf,0,2)
FSEEK(nHdlConf,0,0)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Preenche os arrays de acordo com a Identificador             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
While nBytes < nTamArq
	xBuffer := Space(85)
	FREAD(nHdlConf,@xBuffer,85)
	IF SubStr(xBuffer,1,1) == "A" .or. SubStr(xBuffer,1,1) == Chr(1)
		AADD(aHeadA,{  SubStr(xBuffer,02,15) ,SubStr(xBuffer,17,03),;
			SubStr(xBuffer,20,03) ,SubStr(xBuffer,23,01),;
			SubStr(xBuffer,24,60 ) } )
	ElseIf SubStr(xBuffer,1,1) == "B" .or. SubStr(xBuffer,1,1) == Chr(2)
		AADD(aHead1,{  SubStr(xBuffer,02,15) ,SubStr(xBuffer,17,03),;
			SubStr(xBuffer,20,03) ,SubStr(xBuffer,23,01),;
			SubStr(xBuffer,24,60 ) } )
	ElseIf SubStr(xBuffer,1,1) == "C" .or. SubStr(xBuffer,1,1) == Chr(3)
		AADD(aHead2,{  SubStr(xBuffer,02,15) ,SubStr(xBuffer,17,03),;
			SubStr(xBuffer,20,03) ,SubStr(xBuffer,23,01),;
			SubStr(xBuffer,24,60 ) } )
	Elseif SubStr(xBuffer,1,1) == "D" .or. SubStr(xBuffer,1,1) == Chr(4)
		AADD(aTrai1,{  SubStr(xBuffer,02,15) ,SubStr(xBuffer,17,03),;
			SubStr(xBuffer,20,03) ,SubStr(xBuffer,23,01),;
			SubStr(xBuffer,24,60) } )
	Elseif SubStr(xBuffer,1,1) == "E" .or. SubStr(xBuffer,1,1) == Chr(5)
		AADD(aTrai2,{  SubStr(xBuffer,02,15) ,SubStr(xBuffer,17,03),;
			SubStr(xBuffer,20,03) ,SubStr(xBuffer,23,01),;
			SubStr(xBuffer,24,60) } )
	Elseif SubStr(xBuffer,1,1) == "F" .or. SubStr(xBuffer,1,1) == Chr(6)
		AADD(aTraiA,{  SubStr(xBuffer,02,15) ,SubStr(xBuffer,17,03),;
			SubStr(xBuffer,20,03) ,SubStr(xBuffer,23,01),;
			SubStr(xBuffer,24,60) } )
	Elseif SubStr(xBuffer,1,1) == "G" .or. SubStr(xBuffer,1,1) == Chr(7)
		AADD(aDetA,{   SubStr(xBuffer,02,15) ,SubStr(xBuffer,17,03),;
			SubStr(xBuffer,20,03) ,SubStr(xBuffer,23,01),;
			SubStr(xBuffer,24,60) } )
	Elseif SubStr(xBuffer,1,1) == "H" .or. SubStr(xBuffer,1,1) == Chr(8)
		AADD(aDetB,{   SubStr(xBuffer,02,15) ,SubStr(xBuffer,17,03),;
			SubStr(xBuffer,20,03) ,SubStr(xBuffer,23,01),;
			SubStr(xBuffer,24,60) } )
	Elseif SubStr(xBuffer,1,1) == "J" .or. SubStr(xBuffer,1,1) == Chr(10)
		AADD(aDetJ,{   SubStr(xBuffer,02,15) ,SubStr(xBuffer,17,03),;
			SubStr(xBuffer,20,03) ,SubStr(xBuffer,23,01),;
			SubStr(xBuffer,24,60) } )
	Elseif SubStr(xBuffer,1,1) == "N" .or. SubStr(xBuffer,1,1) == Chr(16)
		AADD(aDetN,{   SubStr(xBuffer,02,15) ,SubStr(xBuffer,17,03),;
			SubStr(xBuffer,20,03) ,SubStr(xBuffer,23,01),;
			SubStr(xBuffer,24,60) } )
	Elseif SubStr(xBuffer,1,1) == "O" .or. SubStr(xBuffer,1,1) == Chr(17)
		AADD(aDetO,{   SubStr(xBuffer,02,15) ,SubStr(xBuffer,17,03),;
			SubStr(xBuffer,20,03) ,SubStr(xBuffer,23,01),;
			SubStr(xBuffer,24,60) } )
	EndIF
	nBytes += 85
EndDO
IF Len(aHeadA) == 0  .And. Len(aHead1) == 0 .And. Len(aHead2) == 0 ;
		.And. Len(aTrai1) == 0 .And. Len(aTrai2) == 0 ;
		.And. Len(aDetA)  == 0 .And. Len(aDetB)  == 0 ;
		.And. Len(aDetJ)  == 0 .And. Len(aDetN)  == 0 ;
		.And. Len(aDetO)  == 0
	HELP(" ",1,"AX044BCO")
	Return
ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ fecha arquivo de configura‡„o ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
fclose(nHdlConf)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abre arquivo enviado pelo banco ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cArqEnt := mv_par04
IF !FILE(cArqEnt)
	Help(" ",1,"NOARQENT")
	Return .F.
Else
	nHdlBco := FOPEN(cArqEnt,0)
EndIF

If GetMv("MV_BXCNAB") == "S" // Baixar arquivo recebidos pelo CNAB aglutinando os valores
	If Empty(SEE->EE_LOTECP)
		cLoteFin := "0001"
	Else
		cLoteFin := Soma1(SEE->EE_LOTECP)
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Lˆ arquivo enviado pelo banco ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nLidos := 0
FSEEK(nHdlBco,0,0)
nTamArq := FSEEK(nHdlBco,0,2)
FSEEK(nHdlBco,0,0)

cPadrao := "532"
lPadrao := VerPadrao(cPadrao)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicia processo de integracao com o SIGAPCO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PCOIniLan("000022")	

ProcRegua(nTamArq/242,24,06)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Gera arquivo de Trabalho                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aCampos,{"FILMOV","C",02,0})
AADD(aCampos,{"DATAD","D",08,0})
AADD(aCampos,{"TOTAL","N",17,2})

If Select("TRB") == 0
	
	oTempTable := FWTemporaryTable():New("TRB", aCampos)
	
Endif

While nLidos <= nTamArq

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Lˆ linha do arquivo retorno ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	xBuffer := Space(242)
	FREAD(nHdlBco,@xBuffer,242)
	nLidos += 242

	IncProc(24,6)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Registro:ÚÄ0 - Header de Arquivo     ³
	//³          ³ÚÄÄ1 - Header de Lote      ³
	//³          ³³    3 - Detalhes Variados ³
	//³          ³ÀÄÄ5 - Trailler de Lote    ³
	//³          ÀÄ9 - Trailler de Arquivo   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cRegistro := Subst( xBuffer , Val(aHeada[3,2]) , 1+Val(aHeada[3,3])-Val(aHeada[3,2]))
	IF cRegistro == "0"
		Loop
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Retornos: 00-Cr‚dito efetuado BD-Pagamento Agendado  TA-Lote n„o aceito ³
	//³ Retornos: BE-Pagto Agendado c/Forma Alterada p/ OP   RJ-Pagto Rejeitado ³
	//³ Header de Lote - verificar se houve rejei‡„o                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Codigos de Rejeicao - TABELA=60                                         ³
	//³                                                                         ³
	//³ AD - Forma de lancamento invalida (Forma X Segmento)                    ³
	//³ AH - Numero sequencial do registro no lote invalido                     ³
	//³ AJ - Tipo de movimento invalido                                         ³
	//³ AL - Codigo do Banco do favorecido ou depositario invalido              ³
	//³ AM - Agencia do cedente invalido                                        ³
	//³ AN - Conta corrente do cedente invalido                                 ³
	//³ AO - Nome do cedente invalido                                           ³
	//³ AP - Data de lancamento / pagamento invalida                            ³
	//³ BC - Nosso numero invalido                                              ³
	//³ IA - Remetente / Motivo invalido                                        ³
	//³ IB - Valor do titulo invalido                                           ³
	//³ IC - Valor do abatimento invalido                                       ³
	//³ ID - Valor do desconto invalido                                         ³
	//³ IE - Valor da mora invalido                                             ³
	//³ IF - Valor da multa invalido                                            ³
	//³ IG - Valor da deducao invalido                                          ³
	//³ IH - Valor do acrescimo invalido                                        ³
	//³ II - Data de vecnto invalida                                            ³
	//³ IJ - Sequencia invalida de segmento                                     ³
	//³ IK - Codigo de instrucao invalida                                       ³
	//³ IL - Uso banco invalido para unibanco                                   ³
	//³ IM - Tipo X Forma nao compativel                                        ³
	//³ IN - Banco / Agencia nao pertence as pracas de compensacao ITAU         ³
	//³ IO - Identificacao Tipo de Cheque invalido                              ³
	//³ IP - Rejeicao do DAC do codigo de barras                                ³
	//³                                                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cRegistro == "1"
		cRetorno := Subst( xBuffer , Val(aDeta[Len(aDeta),2]) , 1+Val(aDeta[Len(aDeta),3] )-Val(aDeta[Len(aDeta),2]))
		Loop
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Final do lote e arquivo - Sai da leitura ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF cRegistro $ "9"
		Exit
	Endif
	IF cRegistro # "3"
		Loop
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Segmentos opcionais : B                               ³
	//³ Obs: Segmentos A e J possuem informa‡”es sobre o      ³
	//³ retorno.                                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cSegmento:= Subst( xBuffer , Val(aDeta[5,2]) , 1+Val(aDeta[5,3])-Val(aDeta[5,2]) )
	nJuros 	:= 0
	nMulta	:= 0
	nDescont	:= 0
	If cSegmento == "A"
		cRetorno   := Subst( xBuffer, Val(aDeta[Len(aDeta),2]) , 1+Val(aDeta[Len(aDeta),3] )-Val(aDeta[Len(aDeta),2]))
		cNumTit    := Subst( xBuffer, Val(aDeta[11,2])         , 1+Val(aDeta[11,3] )-Val(aDeta[11,2]))
		cValPag    := Subst( xBuffer, Val(aDeta[15,2])         , 1+Val(aDeta[15,3] )-Val(aDeta[15,2]))
		cData      := Substr( xBuffer,Val(aDeta[18,2])         , 1+Val(aDeta[18,3] )-Val(aDeta[18,2]))
		cData      := ChangDate(cData,SEE->EE_TIPODAT)
		dBaixa	  := Ctod(Substr(cData,1,2)+"/"+Substr(cData,3,2)+"/"+Substr(cData,5),"ddmm"+Replicate("y",Len(Substr(cData,5))))
	ElseIf cSegmento == "J"
		cRetorno   := Subst( xBuffer, Val(aDetJ[Len(aDetJ),2]) , 1+Val(aDetJ[Len(aDetJ),3])-Val(aDetJ[Len(aDetJ),2]))
		cNumTit    := Subst( xBuffer, Val(aDetJ[20,2])         , 1+Val(aDetJ[20,3] )-Val(aDetJ[20,2]))
		cValPag    := Subst( xBuffer, Val(aDetJ[18,2])         , 1+Val(aDetJ[18,3] )-Val(aDetJ[18,2]))
		cValJur    := Subst( xBuffer, Val(aDetJ[16,2])         , 1+Val(aDetJ[16,3] )-Val(aDetJ[16,2]))
		cValDes	  := Subst( xBuffer, Val(aDetJ[15,2])         , 1+Val(aDetJ[15,3] )-Val(aDetJ[15,2]))
		nJuros	  := Val(cValJur)/100
		nDescont   := Val(cValDes)/100
		cData      := Substr( xBuffer,Val(aDetJ[17,2])         , 1+Val(aDetJ[17,3] )-Val(aDetJ[17,2]))
		cData      := ChangDate(cData,SEE->EE_TIPODAT)
		dBaixa     := Ctod(Substr(cData,1,2)+"/"+Substr(cData,3,2)+"/"+Substr(cData,5),"ddmm"+Replicate("y",Len(Substr(cData,5))))
	ElseIf cSegmento == "N"
	   
		If !lDifPag
			cRetorno := Subst( xBuffer, Val(aDetN[Len(aDetN),2]) , 1+Val(aDetN[Len(aDetN),3])-Val(aDetN[Len(aDetN),2]))
		Else
			nAscan := Ascan(aDetN, {|e| AllTrim(Upper(e[1]))=="OCORRENCIAS"})                                                 
			If nAscan > 0
				cRetorno    := Subst( xBuffer, Val(aDetN[nAscan,2])         , 1+Val(aDetN[nAscan,3] )-Val(aDetN[nAscan,2]))		
			Else	
				ApMsgAlert(STR0023+ "OCORRENCIAS" + STR0024) //"Por favor, indique no registro detalhe do arquivo de configuração segmento N, no nome do campo, o identificador OCORRENCIAS utilizado para localizar, no arquivo retorno, o valor da multa.")
			EndIf
		EndIf
		
		// Procura a posicao do numero do titulo
		nAscan := Ascan(aDetN, {|e| AllTrim(Upper(e[1]))=="SEU NUMERO"})                                                 
		If nAscan > 0
			cNumTit    := Subst( xBuffer, Val(aDetN[nAscan,2])         , 1+Val(aDetN[nAscan,3] )-Val(aDetN[nAscan,2]))		
		Else	
			ApMsgAlert(STR0018) //"Por favor, indique no registro detalhe do arquivo de configuração segmento N, no nome do campo, o identificador "SEU NUMERO" utilizado para localizar, no arquivo retorno,o título a ser baixado.") 
		EndIf
		
		If lDifPag //Retorno contem configuracao de campos de acordo com o tipo do tributo
			//Verifico o tipo do imposto para saber qual posicao do array
			//contem as posicoes dos campos com os dados do tributo
			cTipoImp := Substr( xBuffer,Val(aDetN[07,2])         , 1+Val(aDetN[07,3] )-Val(aDetN[07,2]))		   
		   Do Case
				Case cTipoImp == "01"		// 01 - GPS
					cDesc1 := "DATA GPS" 
					cDesc2 := "PRINCIPAL GPS"     
					cDesc3 := "MULTA GPS"
					cDesc4 := "JUROS GPS"			
				Case cTipoImp == "02"		//02 - DARF
					cDesc1 := "DATA DARF"
					cDesc2 := "PRINCIPAL DARF"     
					cDesc3 := "MULTA DARF"
					cDesc4 := "JUROS DARF"
				Case cTipoImp == "03"	//03 - DARF Simples
					cDesc1 := "DATA SIMPLES"
					cDesc2 := "PRINC. SIMPLES"	
					cDesc3 := "MULTA SIMPLES"
					cDesc4 := "JUROS SIMPLES"
				Case cTipoImp == "04"	//04 - DARJ 
					cDesc1 := "DATA DARJ"
					cDesc2 := "PRINCIPAL DARJ"			
					cDesc3 := "MULTA DARJ"
					cDesc4 := "JUROS DARJ"
				Case cTipoImp == "05"	//05 - ICMS SP
					cDesc1 := "DATA ICMS"
					cDesc2 := "PRINCIPAL ICMS"			
					cDesc3 := "MULTA ICMS"
					cDesc4 := "JUROS ICMS"
				Case cTipoImp $ "07#08"	//07 - IPVA (SP e MG), 08 - DPVAT
					cDesc1 := "DATA IPVA"
					cDesc2 := "PRINCIPAL IPVA"			
					cDesc3 := "MULTA IPVA"
					cDesc4 := "JUROS IPVA"
				Case cTipoImp $ "11"	//11 - FGTS
					cDesc1 := "DATA FGTS"
					cDesc2 := "PRINCIPAL FGTS"			
			EndCase
		Else
			nPos := Ascan(aDetN, {|e| AllTrim(Upper(e[1]))=="DATA"})
			If nPos <= 0
				cTipoImp := Substr( xBuffer,Val(aDetN[07,2])         , 1+Val(aDetN[07,3] )-Val(aDetN[07,2]))		
				If cTipoImp == "01"			//GPS
					nPos := 15
				ElseIf cTipoImp == "02"		//DARF
					nPos := 18			
				ElseIf cTipoImp $ "03#04#05"	//03 - DARF Simples, 04 - DARJ e 05 - ICMS SP
					nPos := 20			
				Endif
			Endif
			//Verifico o tipo do imposto para saber qual posicao do array
			//contem as posicoes das datas de baixa.
			cData      := Substr( xBuffer,Val(aDetN[nPos,2])         , 1+Val(aDetN[nPos,3] )-Val(aDetN[nPos,2]))
			cData      := ChangDate(cData,SEE->EE_TIPODAT)
			dBaixa     := Ctod(Substr(cData,1,2)+"/"+Substr(cData,3,2)+"/"+Substr(cData,5),"ddmm"+Replicate("y",Len(Substr(cData,5))))
			lDataGrv   := .T.	   
	   EndIF
		
		// Procura a posicao da data do tributo		
		If !lDataGrv .And. lDifPag 
			nAscan := Ascan(aDetN, {|e| AllTrim(Upper(e[1]))==cDesc1})
			If nAscan > 0
				cData := Substr( xBuffer, Val(aDetN[nAscan,2])         , 1+Val(aDetN[nAscan,3] )-Val(aDetN[nAscan,2]))
				cData      := ChangDate(cData,SEE->EE_TIPODAT)
				dBaixa     := Ctod(Substr(cData,1,2)+"/"+Substr(cData,3,2)+"/"+Substr(cData,5),"ddmm"+Replicate("y",Len(Substr(cData,5))))
			Else
				ApMsgAlert(STR0023+ cDesc1 + STR0024) //"Por favor, indique no registro detalhe do arquivo de configuração segmento N, no nome do campo, o identificador "+ cDesc1 +" utilizado para localizar, no arquivo retorno, o valor da multa.")
			Endif	
		EndIf
	
		// Procura a posicao do valor principal do tributo		
		nAscan := Ascan(aDetN, {|e| AllTrim(Upper(e[1]))==cDesc2})
		If nAscan > 0
			cValPag    := Subst( xBuffer, Val(aDetN[nAscan,2])         , 1+Val(aDetN[nAscan,3] )-Val(aDetN[nAscan,2]))
		Else
			ApMsgAlert(STR0023+ cDesc2 + STR0024) //"Por favor, indique no registro detalhe do arquivo de configuração segmento N, no nome do campo, o identificador "+ cDesc2 +" utilizado para localizar, no arquivo retorno, o valor da multa.")
		Endif	

		// Procura a posicao da multa do tributo
		nAscan := Ascan(aDetN, {|e| AllTrim(Upper(e[1]))==cDesc3})
		If cTipoImp $ "11" //FGTS
			nMulta := 0		
		ElseIf nAscan > 0
			nMulta := Round(Val(Subst( xBuffer, Val(aDetN[nAscan,2])         , 1+Val(aDetN[nAscan,3] )-Val(aDetN[nAscan,2])))/100,2)
		Else
			ApMsgAlert(STR0023+ cDesc3 + STR0024) //"Por favor, indique no registro detalhe do arquivo de configuração segmento N, no nome do campo, o identificador "+ cDesc3 +" utilizado para localizar, no arquivo retorno, o valor da multa.")
		Endif	

		// Procura a posicao do juros do tributo
		nAscan := Ascan(aDetN, {|e| AllTrim(Upper(e[1]))==cDesc4})
		If cTipoImp $ "11" //FGTS
			nJuros := 0		
		ElseIf nAscan > 0
			cValJur    := Subst( xBuffer, Val(aDetN[nAscan,2])         , 1+Val(aDetN[nAscan,3] )-Val(aDetN[nAscan,2]))
			nJuros	  := Val(cValJur)/100
		Else
			ApMsgAlert(STR0023+ cDesc4 + STR0024) //"Por favor, indique no registro detalhe do arquivo de configuração segmento N, no nome do campo, o identificador "+ cDesc4 +" utilizado para localizar, no arquivo retorno, o valor da multa.")
		Endif	  

	ElseIf cSegmento == "O"
		cRetorno   := Subst( xBuffer, Val(aDetO[Len(aDetO),2]) , 1+Val(aDetO[Len(aDetO),3])-Val(aDetO[Len(aDetO),2]))
		cNumTit    := Subst( xBuffer, Val(aDetO[16,2])         , 1+Val(aDetO[16,3] )-Val(aDetO[16,2]))
		cValPag    := Subst( xBuffer, Val(aDetO[14,2])         , 1+Val(aDetO[14,3] )-Val(aDetO[14,2]))
		cData      := Substr( xBuffer,Val(aDetO[13,2])         , 1+Val(aDetO[13,3] )-Val(aDetO[13,2]))
		cData      := ChangDate(cData,SEE->EE_TIPODAT)
		dBaixa     := Ctod(Substr(cData,1,2)+"/"+Substr(cData,3,2)+"/"+Substr(cData,5),"ddmm"+Replicate("y",Len(Substr(cData,5))))
	Else
		Loop
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se existe o titulo no SE2. Caso este titulo n„o seja ³
	//³ localizado, passa-se para a proxima linha do arquivo retorno. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	//Guardo a filial corrente
	cFilAtu := cFilAnt
	
	dbSelectArea("SE2")

	If lF300Fil   
		aCpos := {}
		Aadd(aCpos,cNumTit)
		Aadd(aCpos,nTamParc)
		Aadd(aCpos,nTamTit)
		ExecBlock("F300FIL",.F.,.F.,aCpos)
	Else
		If lNewIndice .and. !Empty(xFilial("SE2"))
			//Busca por IdCnab (sem filial)
			nRecTit := Recno()
			SE2->(dbSetOrder(13)) // IdCnab
			If SE2->(MsSeek(Substr(cNumTit,1,10)))
				cFilAnt	:= SE2->E2_FILIAL
			Endif
			mv_par09	:= 2  //Desligo contabilizacao on-line				
		Else
			//Busca por IdCnab
			nRecTit := Recno()
			SE2->(dbSetOrder(11)) // Filial+IdCnab
			SE2->(MsSeek(xFilial("SE2")+	Substr(cNumTit,1,10)))
		Endif

		//Se nao achou, utiliza metodo antigo (titulo)
		If SE2->(!Found())
			//Busca pela chave antiga	
			dbSetOrder(1)
			If !dbSeek(xFilial("SE2")+Pad(cNumTit,nTamTit))
			// Busca por chave antiga adaptada para o tamanho de 9 posicoes para numero de NF
			// Isto ocorre quando titulo foi enviado com 6 posicoes para numero de NF e retornou com o
			// campo ja atualizado para 9 posicoes
				cNumTit := SubStr(cNumTit,1,nTamPre)+Padr(Substr(cNumTit,4,6),nTamNum)+SubStr(cNumTit,10)
				If !dbSeek(xFilial("SE2")+Pad(cNumTit,nTamTit))
					Help(" ",1,"NOESPECIE",,cNumTit,5,1)
					dbGoTo(nRecTit)
					Loop
				Endif
			Endif
		Endif  
	Endif

	If SE2->E2_SALDO = 0 
		dbGoTo(nRecTit)
		Loop
	Endif 
	
	//Gera movimento dos PAs e TXAs enviados ao banco via borderos
	If SE2->E2_TIPO $ MVPAGANT+"#"+MVTXA

		//Verifico existencia de movimento anterior (arquivo reprocessado)
		lPaMov = .F.
      dbSelectArea("SE5")
		SE5->(DBSETORDER(2))  //E5_FILIAL+E5_TIPODOC+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO                   
		cKeySe5 := xFilial("SE5")+IIF(SE2->E2_TIPO $ MVPAGANT,"PA","TX")+SE2->(E2_PREFIXO+E2_NUM+E2_PARCELA)
		cKeySe5 += IIF(SE2->E2_TIPO $ MVPAGANT,"PA ","TXA")
		If SE5->(MsSeek(cKeySe5))
			While !SE5->(EOF()) .and. SE5->(E5_FILIAL+E5_TIPODOC+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO) == cKeySe5
				If SE2->(E2_FORNECE+E2_LOJA) == SE5->(E5_CLIFOR+E5_LOJA)
					lPaMov = .T. 
					EXIT
				Else
					SE5->(dbSkip())
				Endif
			Enddo
		Endif
		//Gravo Movimento do PA/TXA se necessario
		If !lPaMov	
			RecLock("SE5",.T.)
			SE5->E5_FILIAL	 := xFilial("SE5")
			SE5->E5_BANCO	 := cBanco
			SE5->E5_AGENCIA := cAgencia
			SE5->E5_CONTA	 := cConta
			SE5->E5_DATA	 := dBaixa
			SE5->E5_VALOR	 := SE2->E2_VLCRUZ
			SE5->E5_NATUREZ := SE2->E2_NATUREZ
			SE5->E5_RECPAG  := "P"
			SE5->E5_TIPO	 := IIF(SE2->E2_TIPO $ MVPAGANT,MVPAGANT,MVTXA)
			SE5->E5_LA		 := "S"
			SE5->E5_TIPODOC := IIF(SE2->E2_TIPO $ MVPAGANT,"PA","TXA")
			SE5->E5_HISTOR  := SE2->E2_HIST
			SE5->E5_BENEF   := Posicione("SA2",1,xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA,"SA2->A2_NOME")
			SE5->E5_PREFIXO := SE2->E2_PREFIXO
			SE5->E5_NUMERO  := SE2->E2_NUM
			SE5->E5_PARCELA := SE2->E2_PARCELA
			SE5->E5_CLIFOR  := SE2->E2_FORNECE
			SE5->E5_LOJA	 := SE2->E2_LOJA
			SE5->E5_DTDIGIT := dDataBase
			SE5->E5_MOTBX	 := "NOR"
			SE5->E5_DTDISPO := SE5->E5_DATA
			SE5->E5_VLMOED2 := SE2->E2_VALOR
			
			If SPBInUse()
				SE5->E5_MODSPB		:= SE2->E2_MODSPB
			Endif
			
			MsUnlock()
			
			If  cFA30
				ExecBlock("FA300PA", .F., .F.)
			Endif
			
			AtuSalBco( cBanco,cAgencia,cConta,SE5->E5_DTDISPO,SE5->E5_VALOR,"-" )
			
	   Endif

		dbSelectArea("SE2")		
		dbGoTo(nRecTit)
		Loop

	Endif

	nRegistro := SE2->(Recno())

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica c¢digo da ocorrˆncia ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SEB")
	dbSeek(xFilial("SEB")+cBanco+Padr(Substr(cRetorno,1,3),3)+"P")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Reposicionar o SEB para uma chave diferente, que considere³ 
	//³ tamb‚m, campos espec¡ficos criados no SEB.                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lFa300Oco
		ExecBlock("FA300OCO", .F., .F.)
	Endif
	dbSelectArea("SE2")

	IF _fa300rejei()
		Loop
	Endif

	IF !(LEFT(cRetorno,2) $ SEB->EB_REFBAN)  //Baixa do Titulo
		Help(" ",1,"NOCORR",,"Chave="+cNumTit+CHR(10)+STR0016,3,1) //" Falta ocorrencia SEB de controle do sistema"
		Loop
	ENDIF

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta Contabiliza‡„o.         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !lCabec .and. lPadrao .and. lContabiliza
		nHdlPrv  := HeadProva(cLote,"FINA300",Substr(cUsuario,7,6),@cArquivo)
		lCabec   := .t.
	EndIf
	nValEstrang := SE2->(E2_SALDO+E2_SDACRES-E2_SDDECRE)
	lDesconto   := Iif(mv_par10==1,.T.,.F.)
	cHist070    := STR0017 //"Valor Pago s/ Titulo"
	nSaldo      := SE2->E2_SALDO
	nSaldoCru   := Moeda(SE2->E2_SALDO,1,"P")
	cNumero     := SE2->E2_NUM
	cPrefixo    := SE2->E2_PREFIXO
	cParcela    := SE2->E2_PARCELA
	cFornece    := SE2->E2_FORNECE
	nTotAbat    := 0
	nMoeda      := 2
	*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	*³Soma Titulos Abatimentos                         ³
	*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea( "SE2" )
	dbSetOrder( 1 )
	dbSeek( xFilial("SE2")+cPrefixo+cNumero+cParcela )
	While !EOF() .And. SE2->E2_FILIAL   == xFilial("SE2")  .And. ;
			SE2->E2_PREFIXO  == cPrefixo .And. ;
			SE2->E2_NUM      == cNumero  .And. ;
			SE2->E2_PARCELA  == cParcela
		IF SE2->E2_TIPO$ MVABATIM .And. ;
				SE2->E2_SALDO > 0 .And. ;
				SE2->E2_FORNECE == cFornece

			nTotAbat += Moeda(SE2->E2_SALDO,1,"P")
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Atualiza a Baixa do Titulo     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			RecLock("SE2",.F.)
			Replace E2_BAIXA   With dBaixa
			Replace E2_SALDO   With 0
			Replace E2_MOVIMEN With dDataBase
			Replace E2_BCOPAG  With E2_PORTADO
			Msunlock( )
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Grava o lançamento de integração com o SIGAPCO ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			PcoDetLan("000022","02","FINA300")

		EndIF
		dbSkip()
	Enddo
	dbSelectArea( "SE2" )
	dbGoTo( nRegistro )

	//Caso seja do Segmento 'N'(Impostos), nao considera acrescimos e decrescimos, pois
	//o banco trata os valores atraves dos campos de Juros e Multa
	If cSegmento != "N" 
		nAcresc  := Round(Noround(xMoeda(SE2->E2_SDACRES,SE2->E2_MOEDA,1,dBaixa,3),3),2)
		nDecresc := Round(Noround(xMoeda(SE2->E2_SDDECRE,SE2->E2_MOEDA,1,dBaixa,3),3),2)
	EndIf

	nJuros := nJuros - nAcresc
	nValPag		:= Val(cValPag)/100                     

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carrega valores para efetuar a baixa								  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nValPadrao := nValPag-(nJuros+nMulta-nDescont+nAcresc-nDecresc-nTotAbat)

	nSaldo := Round(nSaldo-nValPadrao,2)
   
	If nSaldo < 0
		nSaldo := 0
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza a Baixa do Titulo                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RecLock("SE2")
	Replace E2_BAIXA   	With dBaixa ,;
			E2_VALLIQ  	With nValPag ,;
			E2_SALDO   	With nSaldo,;
			E2_MOVIMEN 	With dDataBase ,;
			E2_BCOPAG  	With E2_PORTADO ,;
			E2_JUROS   	With nJuros+nAcresc ,;
			E2_DESCONT	With nDescont ,;
			E2_CORREC  	With nCorrecao ,;
			E2_MULTA	With nMulta ,;
			E2_SDACRES  With 0 ,;
			E2_SDDECRE  With 0
	MsUnlock( )
				
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grava o lançamento de integração com o SIGAPCO ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	PcoDetLan("000022","02","FINA300")

	dbSelectArea("TRB")
	If !(dbSeek(xFilial("SE5")+Dtos(dBaixa)))
		Reclock("TRB",.T.)
		Replace FILMOV With xFilial("SE5")
		Replace DATAD With dBaixa
	Else
		Reclock("TRB",.F.)
	Endif
	Replace TOTAL WITH TOTAL + nValPag
	MsUnlock()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Para numerar as sequencias o sistema precisa procurar os	³
	//³ registros com  tipodoc igual a vl ou ba.							³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aTipoSeq := { "VL","BA","CP" }
	dbSelectArea("SE5")
	SE5->(dbSetOrder(2))
	For nLaco := 1 to len(aTipoSeq)
		SE5->(dbSeek(xFilial("SE5") + aTipoSeq[nLaco] + SE2->E2_PREFIXO + SE2->E2_NUM + ;
			SE2->E2_PARCELA + SE2->E2_TIPO) )

		While !SE5->(Eof()) .And. ;
				SE5->E5_FILIAL == xFilial("SE5") .And. ;
				SE5->E5_TIPODOC == aTipoSeq[nLaco] .And. ;
				SE5->E5_PREFIXO == SE2->E2_PREFIXO .And. ;
				SE5->E5_NUMERO == SE2->E2_NUM .And. ;
				SE5->E5_PARCELA == SE2->E2_PARCELA .And. ;
				SE5->E5_TIPO == SE2->E2_TIPO

			If SE5->(E5_CLIFOR+E5_LOJA) == SE2->(E2_FORNECE+SE2->E2_LOJA)
				If cSequencia < SE5->E5_SEQ
					cSequencia := SE5->E5_SEQ
				EndIf
			EndIf
			SE5->( dbSkip() )
		Enddo
	Next

	cSequencia := Soma1(cSequencia,2)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Somo os valores para gravacao do total nos registros bancarios ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nJuros := nJuros + nAcresc
	nDescont := nDescont

	For nI:=1 to 4
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza a Movimentacao Bancaria 									  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nI==1
			nCpoTp := nDescont
			cTpDoc := "DC"
			cHistMov := OemToAnsi( STR0011 ) //"Desconto s/Pgto de Titulo"
		Elseif nI==2
			nCpoTp := nJuros
			cTpDoc := "JR"
			cHistMov := OemToAnsi( STR0010 ) //"Juros s/Pgto de Titulo"
		Elseif nI==3
			nCpoTp := nMulta
			cTpDoc := "MT"
			cHistMov := OemToAnsi( STR0026 ) //"Multa s/Pgto de Titulo"
		Elseif nI==4
			nCpoTp := nValPag
			cTpDoc := If(Empty(cLoteFin), "VL", "BA")
			cHistMov := OemToAnsi( STR0009 ) //"Valor pago s /Titulo"
		Endif

		If nCpoTp != 0 .or. nI == 4
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Grava registro referente a movimenta‡„o banc ria ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			RecLock("SE5",.T.)                   
			SE5-> E5_FILIAL 	:= xFilial("SE5")
			SE5-> E5_PREFIXO	:= SE2->E2_PREFIXO
			SE5-> E5_NUMERO 	:= SE2->E2_NUM
			SE5-> E5_PARCELA	:= SE2->E2_PARCELA
			SE5-> E5_FORNECE	:= SE2->E2_FORNECE
			SE5-> E5_CLIFOR 	:= SE2->E2_FORNECE
			SE5-> E5_LOJA		:= SE2->E2_LOJA
			SE5-> E5_BENEF		:= SE2->E2_NOMFOR
			SE5-> E5_VALOR	 	:= nCpoTp
			SE5-> E5_DATA		:= SE2->E2_BAIXA
			SE5-> E5_HISTOR 	:= cHistMov
			SE5-> E5_NATUREZ	:= SE2->E2_NATUREZ
			SE5-> E5_RECPAG 	:= "P"
			SE5-> E5_TIPO		:= SE2->E2_TIPO
			SE5->E5_DOCUMEN	:=	SE2->E2_NUMBOR
			SE5-> E5_DTDIGIT	:= dDataBase                                  
			SE5-> E5_LA			:= If(lPadrao .and. lContabiliza .and. lCabec,"S","N")
			SE5-> E5_TIPODOC	:= cTpDoc
			SE5->E5_DTDISPO	:=	dBaixa
			SE5-> E5_MOTBX		:= "DEB"
			SE5-> E5_VLMOED2	:= xMoeda(SE2->E2_VALLIQ,1,SE2->E2_MOEDA,SE2->E2_BAIXA)
			SE5-> E5_BANCO		:= cBanco
			SE5-> E5_AGENCIA	:= cAgencia
			SE5-> E5_CONTA		:= cConta
			SE5->E5_SEQ 		:= cSequencia
			SE5-> E5_LOTE		:= cLoteFin
			SE5->E5_ARQCNAB	:=	mv_par04
			MsUnlock()
      EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava os valores agregados ao titulo                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nI == 4
			RecLock("SE5",.F.)	
			Replace E5_VLMULTA With nMulta
			Replace E5_VLDESCO With nDescont
			Replace E5_VLJUROS With nJuros

			If SE5->(FieldPos("E5_VLACRES")) > 0 .and. SE5->(FieldPos("E5_VLDECRE")) > 0
				Replace SE5->E5_VLACRES With nAcresc
				Replace SE5->E5_VLDECRE With nDecresc
			Endif	

			MsUnlock()
		
			If Empty(cLoteFin)
				AtuSalBco( cBanco,cAgencia,cConta,SE5->E5_DATA,SE5->E5_VALOR,"-")
			Endif	

			nValorTotal += SE5->E5_VALOR

		EndIf	

		If nCpoTp != 0
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Grava o lançamento de integração com o SIGAPCO ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			PcoDetLan("000022","01","FINA300")
		EndIf
	
	Next
	
	If lF300SE5
		ExecBlock("F300SE5",.F.,.F.)
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza o Cadastro de Fornecedores     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SA2")
	If dbSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA)
		RecLock("SA2")
		IF nSaldoCru >= SA2->A2_SALDUP
			nSalDup := 0
		ELSE
			nSalDup := SA2->A2_SALDUP - nSaldoCru
		Endif
		Replace A2_SALDUP   With nSalDup
		Replace A2_SALDUPM With A2_SALDUPM - xMoeda(nSaldoCru,SE2->E2_MOEDA,Val(cCusto),SE2->E2_VENCREA)
		MsUnlock( )
	Endif
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica qual o Lanc Padr„o que ser  utilizado      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SE2")
	nC++

	// Header do cProva
	IF nC == 1 .And. lPadrao .and. lContabiliza
		nHdlPrv:=HeadProva(cLote,"FINA300",Substr(cUsuario,7,6),@cArquivo)
		lCabec := .T.
	Endif

	IF lPadrao .and. lContabiliza .and. lCabec
		nTotal+=DetProva(nHdlPrv,cPadrao,"FINA300",cLote)
	Endif
	
	//Retorno Filial
	cFilAnt := cFilAtu

Enddo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Grava no SEE o n£mero do £ltimo lote recebido e gera ³
//³ movimentacao bancaria											³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(cLoteFin) .and. GetMv("MV_BXCNAB") == "S"
	If TRB->(Reccount()) > 0
		RecLock("SEE",.F.)
		SEE->EE_LOTECP := cLoteFin
		MsUnLock()
		dbSelectArea("TRB")
		dbGotop()
		While !Eof()
			cFilAnt := TRB->FILMOV
			Reclock( "SE5" , .T. )
			SE5->E5_FILIAL := xFilial("SE5")
			SE5->E5_DATA   := TRB->DATAD
			SE5->E5_VALOR  := TRB->TOTAL
			SE5->E5_RECPAG := "P"
			SE5->E5_DTDIGIT:= dDataBase
			SE5->E5_BANCO  := cBanco
			SE5->E5_AGENCIA:= cAgencia
			SE5->E5_CONTA  := cConta
			SE5->E5_DTDISPO:= TRB->DATAD
			SE5->E5_LOTE   := cLoteFin
			SE5->E5_HISTOR := STR0022 + cLoteFin // "Bx p/Retorno SISPAG/Lote: "
			If SpbInUse()
				SE5->E5_MODSPB := "1"
			Endif
			MsUnlock()
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Grava o lançamento de integração com o SIGAPCO ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			PcoDetLan("000022","01","FINA300")
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Atualiza saldo bancario.      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			AtuSalBco(cBanco,cAgencia,cConta,SE5->E5_DATA,SE5->E5_VALOR,"-")
			dbSelectArea("TRB")
			dbSkip()
		Enddo
	Endif
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza processo de integracao com SIGAPCO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PCOFinLan("000022")

dbSelectArea("SE2")
dbGoBottom()
dbSkip()
dbSelectArea("SE5")
dbGoBottom()
dbSkip()

VALOR := nValorTotal

IF lPadrao .and. lContabiliza .and. lCabec
	nTotal+=DetProva(nHdlPrv,cPadrao,"FINA300",cLote)
Endif

IF lPadrao .and. lContabiliza .and. lCabec
	RodaProva(nHdlPrv,nTotal)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Envia para Lancamento Contabil                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lDigita:=IIF(mv_par01==1,.T.,.F.)
	lAglut :=IIF(mv_par02==1,.T.,.F.)
	cA100Incl(cArquivo,nHdlPrv,2,cLote,lDigita,lAglut)
Endif

VALOR := 0

dbSelectArea("SE2")
dbSeek(xFilial())

dbSelectArea("SE5")
dbSeek(xFilial())

If Select("TRB") > 0
	dbSelectArea("TRB")
	TRB->(dbCloseArea())
	Ferase(cNomeArq+GetDBExtension())
	Ferase(cNomeArq+OrdBagExt())
EndIf

FCLOSE(nHdlBco)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Utilizado para renomear o arquivo processado        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lFa300Ren
   ExecBlock("FA300REN", .F., .F.)
End   

cFilAnt := cFilOrig					// sempre restaura a filial original 

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fA300Rejei³ Autor ³ Vicente Sementilli    ³ Data ³ 29/11/95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Trata titulo rejeitado.                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³fa300Rejei                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function _fa300Rejei()
Local lRet := .T.
Local lFA300Rej := ExistBlock("FA300REJ")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ 00-Cr‚dito efetuado                 				   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If "00" $ cRetorno
	lRet := .F.
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ BD-Pagamento Agendado 										³
	//³ BE-Pagto Agendado c/Forma Alterada p/ OP				³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ElseIf !("BD" $ cRetorno .or. "BE" $ cRetorno)
	dbSelectArea("SEA")
	dbSetOrder(1)
	If MSSeek(xFilial()+SE2->E2_NUMBOR+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE+SE2->E2_LOJA)
		Reclock( "SE2" )
		SE2->E2_NUMBOR  := Space(Len(SE2->E2_NUMBOR))
		SE2->E2_PORTADO := Space(Len(SE2->E2_PORTADO))
		MsUnlock()
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Utilizado para gravacao de campos adicionais na SE2 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lFA300Rej
			ExecBlock("FA300REJ", .F., .F., {cRetorno})
		EndIf
		dbSelectArea("SEA")
		RecLock("SEA",.F.,.T.)
		dbDelete()
		MsUnlock( )
	EndIf
EndIf      

Return lRet

Static Function MenuDef()
Local aRotina := {{ OemToAnsi( STR0025 ),"AxPesqui"  , 0 , 1,,.F.},; //"Pesquisar"
				  { STR0002,"AxVisual", 0 , 2} ,;  //"Visualiza"
  				  { STR0012, "FA240Sis"   , 0 , 0} ,; //"Gerar Arquivo"
                  { STR0003, "U_fA300Ret()", 0 , 2}  } //"Recebe Arquivo"
Return(aRotina)



/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³FinA300T   ³ Autor ³ Marcelo Celi Marques ³ Data ³ 31.03.08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada semi-automatica utilizado pelo gestor financeiro   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINA300                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function _FinA300T(aParam)
	cRotinaExec := "FINA300"
	ReCreateBrow("SE2",FinWindow)      		
	FinA300(aParam[1])
	ReCreateBrow("SE2",FinWindow)      	
	dbSelectArea("SE2")
	
	INCLUI := .F.
	ALTERA := .F.
	
Return .T.
