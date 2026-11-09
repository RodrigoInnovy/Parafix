#Include "protheus.ch"

#define CRLF Chr(13)+Chr(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±

±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±± ROTINA QUE ALTERA DADOS DO TRANSPORTE, VOLUME E ESPECIE DA SF2 E ZA2 ÍÍ¹±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±

±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/         
User Function RFat003()

aadd(aRotina,{'Dados de Transporte','U_XFat014Proc',0,4,0,Nil})

Return()


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ XFat014Prº Autor ³ Totvs             º Data ³  15/10/10    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Monta tela para informa os campos do Dados de transporte.  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Parafix                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/         
User Function XFat014Proc()

Local aArea		:= GetArea()
Local cRot      := IIf(FunName()="MATA410","1","2")
Local aTitles	:= IIf(cRot="1",{"Pedido de Venda"},{"Nota Fiscal"})
Local nCntFor	:= 0
Local nOpc		:= 0
Local nX        := 0
Local cTransp	:= ""
//Local nPesoL	:= 0
//Local nPesoB	:= 0
Local nVolume	:= 0
Local cEspec	:= ""
Local oDlg
Local oFolder
Local oList
Local cAlias := IIf(cRot="1","SC5","SF2")
Local cCampos := IIf(cRot="1","C5_NUM|C5_TIPO|C5_EMISSAO|C5_CLIENTE|C5_LOJACLI|A1_NOME|A1_ENDENT","F2_DOC|F2_SERIE|F2_EMISSAO|F2_CLIENTE|F2_LOJA|A1_NOME|A1_ENDENT")
Local cNomeTransp := ""
Local cNomeEspec := ""
Local cCliente := ""
Local cLoja := ""
Local lAtu := .T.
Local lEncerra := .T.

Private aHeader	  := {}
Private aCols	  := {}
Private oTransp
Private oPesoL
Private oPesoB
Private oVolume
Private oEspec

If cRot = "1"
	If !Empty(SC5->C5_NOTA)
		APMsgAlert("Pedido já faturado. Faça a manutenção no Documento de Saída deste pedido.")
		Return()
	Endif	
	If SC5->C5_LIBEROK != "S"
		APMsgAlert("Pedido não está liberado para faturamento. Realize a manutenção alterando o pedido de venda.")
		Return()		
	Endif	
	RegToMemory("SC5",.F.)
	cTransp	 := SC5->C5_TRANSP
	//nPesoL   := SC5->C5_PESOL
	//nPesoB   := SC5->C5_PBRUTO
	nVolume	 := SC5->C5_VOLUME1
	cEspec   := SC5->C5_ESPECI1
	cCliente := SC5->C5_CLIENTE
	cLoja    := SC5->C5_LOJACLI
Else	
	// valida se pode informar os dados de transporte para esta nota
	/*If SF2->F2_XDADOST != "2" // dados de transporte pendente para a nota
	 	lAtu := .F.
	Endif	*/
 	
	
	RegToMemory("SF2",.F.)
	cTransp	 := SF2->F2_TRANSP 
    //nPesoL   := SF2->F2_PLIQUI 
    //nPesoB   := SF2->F2_PBRUTO 
    nVolume  := SF2->F2_VOLUME1
	cEspec   := SF2->F2_ESPECI1
	cCliente := SF2->F2_CLIENTE
	cLoja    := SF2->F2_LOJA
	nNota    := SF2->F2_DOC
Endif	

IF lAtu
  // nPesoL  := 0
   //nPesoB  := 0
   nVolume := 0

   DBSelectArea("SC9")
   DBSetOrder(6) //C9_FILIAL+C9_SERIE+C9_NFISCAL+C9_CLIENTE+C9_LOJA
   DBSeek(xFilial("SC9")+SF2->F2_SERIE+SF2->F2_DOC)
	
Endif

cNomeTransp := Posicione("SA4",1,xFilial("SA4")+cTransp,"A4_NOME")
cNomeEspec := cEspec//Alltrim(Posicione("SX5",1,xFilial("SX5")+"CC"+cEspec,"X5_DESCRI"))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem do aHeader                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX3")
dbSetOrder(1)
If dbSeek(cAlias)
	While ( !Eof() .And. (SX3->X3_ARQUIVO == cAlias) )
		If ( X3USO(SX3->X3_USADO) .And. ;
			AllTrim(SX3->X3_CAMPO) $ cCampos .And. ;
			cNivel >= SX3->X3_NIVEL ) .and. !Alltrim(SX3->X3_CAMPO) == "F2_CLIENT" .and. !Alltrim(SX3->X3_CAMPO) == "C5_CLIENT"
			
			Aadd(aHeader,{ TRIM(X3Titulo()),;
				SX3->X3_CAMPO,;
				SX3->X3_PICTURE,;
				SX3->X3_TAMANHO,;
				SX3->X3_DECIMAL,;
				SX3->X3_VALID,;
				SX3->X3_USADO,;
				SX3->X3_TIPO,;
				SX3->X3_ARQUIVO,;
				SX3->X3_CONTEXT } )
		EndIf
		dbSelectArea("SX3")
		dbSkip()
	EndDo
EndIf                     

aAdd(aHeader,{"Nome","A1_NOME","@!",40,0,"","€€€€€€€€€€€€€€ ","C","SA1","R"})
aAdd(aHeader,{"End.Entrega","A1_ENDENT","@!",40,0,"","ÿÿi€€‹ğ€€€€€€ƒ€","C","SA1","R"})
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem do aCols                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(cAlias)
AADD(aCols,Array(Len(aHeader)))
For nCntFor:=1 To Len(aHeader)
	If ( aHeader[nCntFor,10] <>  "V" )
		aCols[Len(aCols)][nCntFor] := FieldGet(FieldPos(aHeader[nCntFor,2]))
	Else			
		aCols[Len(aCols)][nCntFor] := CriaVar(aHeader[nCntFor,2])
	EndIf
Next nCntFor

// atualiza campos do SA1
dbSelectArea("SA1")
dbSetOrder(1)
If dbSeek(xFilial("SA1")+cCliente+cLoja)
	aCols[Len(aCols)][6] := Alltrim(SA1->A1_NOME)
	aCols[Len(aCols)][7] := IIf(!Empty(SA1->A1_ENDENT),SA1->A1_ENDENT,SA1->A1_END)
Endif	

dbSelectArea(cAlias)
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta a tela de exibicao dos dados           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DEFINE MSDIALOG oDlg TITLE OemToAnsi(IIf(cRot="1","Manutencao de Dados do Pedido de Venda","Manutencao de Dados do Documento de Saída")) FROM 09,00 TO 30,80 

oFolder	:= TFolder():New(001,001,aTitles,{"HEADER"},oDlg,,,, .T., .F.,315,151)
oList 	:= TWBrowse():New( 5, 1, 310, 42,,{aHeader[1,1],aHeader[2,1],aHeader[3,1],aHeader[4,1],aHeader[5,1],aHeader[6,1],aHeader[7,1]},{30,40,30,20,40,60,60},oFolder:aDialogs[1],,,,,,,,,,,,.F.,,.T.,,.F.,,, ) //"Numero"###"Serie"###"Cliente"###"Loja"###"DT Emissao"###"Nome Cliente"###"End. Entrega"
oList:SetArray(aCols)
oList:bLine	:= {|| {aCols[oList:nAt][1],aCols[oList:nAt][2],aCols[oList:nAt][3],aCols[oList:nAt][4],aCols[oList:nAt][5],aCols[oList:nAt][6],aCols[oList:nAt][7]}}
oList:lAutoEdit	:= .F.

@ 051,005 SAY RetTitle("F2_TRANSP")		SIZE 40,10 PIXEL OF oFolder:aDialogs[1]
//@ 066,005 SAY RetTitle("F2_PLIQUI")		SIZE 40,10 PIXEL OF oFolder:aDialogs[1]
//@ 081,005 SAY RetTitle("F2_PBRUTO")		SIZE 40,10 PIXEL OF oFolder:aDialogs[1]	
@ 066,005 SAY "Volume"					SIZE 40,10 PIXEL OF oFolder:aDialogs[1]		
@ 081,005 SAY "Espécie"					SIZE 40,10 PIXEL OF oFolder:aDialogs[1]		

@ 051,050 MSGET IIf(cRot="1",M->C5_TRANSP,M->F2_TRANSP)	VAR cTransp		PICTURE PesqPict("SF2","F2_TRANSP")		F3 CpoRetF3("F2_TRANSP")	WHEN lAtu	SIZE 50,07 PIXEL OF oFolder:aDialogs[1] VALID IIf(Vazio(cTransp),(cNomeTransp:="",.T.),.F.) .Or. (ExistCpo("SA4",cTransp) .and. XFat014Disp(@cNomeTransp,cRot,cTransp))
//@ 066,050 MSGET IIf(cRot="1",M->C5_PESOL,M->F2_PLIQUI) 	VAR nPesoL	 	PICTURE PesqPict("SF2","F2_PLIQUI")		F3 CpoRetF3("F2_PLIQUI")	WHEN lAtu	SIZE 50,07 PIXEL OF oFolder:aDialogs[1] VALID ((Vazio(nPesoL) .or. nPesoL>0) .and. IIf(!Empty(nPesoB),nPesoL<=nPesoB,.T.))
//@ 081,050 MSGET IIf(cRot="1",M->C5_PBRUTO,M->F2_PBRUTO)	VAR	nPesoB		PICTURE PesqPict("SF2","F2_PBRUTO")		F3 CpoRetF3("F2_PBRUTO")	WHEN lAtu	SIZE 50,07 PIXEL OF oFolder:aDialogs[1] VALID ((Vazio(nPesoB) .or. nPesoB>0) .and. IIf(!Empty(nPesoL),nPesoB>=nPesoL,.T.))
@ 066,050 MSGET IIf(cRot="1",M->C5_VOLUME1,M->F2_VOLUME1)	VAR nVolume		PICTURE PesqPict("SF2","F2_VOLUME1")	F3 CpoRetF3("F2_VOLUME1")	WHEN lAtu	SIZE 50,07 PIXEL OF oFolder:aDialogs[1] VALID (Vazio(nVolume) .or. nVolume>0)
@ 081,050 MSGET IIf(cRot="1",M->C5_ESPECI1,M->F2_ESPECI1)	VAR cEspec		PICTURE PesqPict("SF2","F2_ESPECI1")	F3 cEspec					WHEN lAtu	SIZE 50,07 PIXEL OF oFolder:aDialogs[1] VALID IIf(Vazio(cEspec),(cNomeEspec:="",.T.),.F.) .Or. XFat014Disp(@cNomeEspec,cRot,cEspec) //VALID IIf(Vazio(),(cEspec:="",.T.),.F.) 	//.Or. (ExistCpo("DA3").And.A512Disp(@cVeicul3))	

@ 051,105 MSGET oTransp	VAR cNomeTransp	PICTURE PesqPict("SA4","A4_NOME")		WHEN .F. SIZE 150,07 PIXEL OF oFolder:aDialogs[1]
@ 081,105 MSGET oEspec	VAR cNomeEspec	PICTURE "@!"							WHEN .F. SIZE 150,07 PIXEL OF oFolder:aDialogs[1]

@ 081,005 TO 1,1 PIXEL OF oFolder:aDialogs[1]
If lAtu
	@ 123,225 BUTTON OemToAnsi("Confirmar")	SIZE 040,13 FONT oFolder:aDialogs[1]:oFont ACTION (nOpc:=1,oDlg:End())	OF oFolder:aDialogs[1] PIXEL
Endif	
@ 123,270 BUTTON OemToAnsi("Cancelar")	SIZE 040,13 FONT oFolder:aDialogs[1]:oFont ACTION oDlg:End()			OF oFolder:aDialogs[1] PIXEL

ACTIVATE MSDIALOG oDlg CENTERED
	
If nOpc == 1
	If cRot="1"
		SC5->(RecLock("SC5",.F.))
		SC5->C5_TRANSP	:= cTransp
	//	SC5->C5_PESOL	:= nPesoL
	//	SC5->C5_PBRUTO	:= nPesoB
		SC5->C5_VOLUME1	:= nVolume
		SC5->C5_ESPECI1	:= cEspec
		SC5->(MsUnlock())
	Else
		If Empty(cTransp) .or. Empty(nVolume) .or. Empty(cEspec)  //Empty(cTransp) .or. Empty(nPesoL) .or. Empty(nPesoB) .or. Empty(nVolume) .or. Empty(cEspec)
			If !APMsgYesNo("Não foram informados todos os campos de Dados de Transporte."+CRLF+;
			"Não será possível informar estes dados se o processo for encerrado."+CRLF+;
			"Deseja encerrar este processo ?","Atenção")
				 lEncerra := .F.
			Endif
		Endif

//Atualiza na ZA2 os dados da transportadora conforme consta na NF.

		DBSelectArea("ZA2")
   		DBSetOrder(5) //ZA2_FILIAL+ZA2_NF
   		DBSeek(xFilial("ZA2")+SF2->F2_DOC)

		while ZA2_NF = F2_DOC
		ZA2->(RecLock("ZA2",.F.))
		ZA2->ZA2_TRANSP	:= cTransp
		ZA2->ZA2_DESCTR := cNomeTransp
		ZA2->(MsUnlock())
		skip()
		enddo

//Atualiza na F2 os dados da Transportadora, Volume e Specie Embalagem

		SF2->(RecLock("SF2",.F.))
		SF2->F2_TRANSP	:= cTransp
		//SF2->F2_PLIQUI	:= nPesoL
		//SF2->F2_PBRUTO	:= nPesoB
		SF2->F2_VOLUME1	:= nVolume
		SF2->F2_ESPECI1	:= cEspec
		SF2->(MsUnlock())


		
	Endif	
Endif
	
RestArea(aArea)

Return Nil


/*/                
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³XFat014Dis³ Autor ³ Sergio S. Fuzinaka    ³ Data ³ 14.12.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Display do Campo                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function XFat014Disp(cCampo,cRot,cBusca,cEspec)

Local aArea	:= GetArea()
Local cCpo	:= ReadVar()

Do Case
	Case Upper(cCpo) == Upper("cTransp")
		cCampo := Posicione("SA4",1,xFilial("SA4")+cBusca,"A4_NOME")
		oTransp:Refresh()
	Case Upper(cCpo) == Upper("cEspec")
		cCampo := cEspec
		oEspec:Refresh()
EndCase

RestArea(aArea)

Return(.T.)


/*/                
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³XFat014Vld³ Autor ³ Sergio S. Fuzinaka    ³ Data ³ 14.12.05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Verifica se a nota em questao eh referente a um pedido de   ³±±
±±³Descricao ³cobranca                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function XFat014VldPed()

Local aArea := GetArea()
Local aPed := {}
Local cQ := ""
Local cAliasTrb := GetNextAlias()
Local nReg := 0

cQ := "SELECT COUNT(*) AS NREG "
cQ += "FROM "+RetSqlName("SF2")+" SF2, "+RetSqlName("SD2")+" SD2, "+RetSqlName("SC5")+" SC5 "
cQ += "WHERE F2_FILIAL = '"+xFilial("SF2")+"' "
cQ += "AND D2_FILIAL = '"+xFilial("SD2")+"' "
cQ += "AND C5_FILIAL = '"+xFilial("SC5")+"' "
cQ += "AND D2_FILIAL = F2_FILIAL "
cQ += "AND D2_DOC = F2_DOC "
cQ += "AND D2_SERIE = F2_SERIE "
cQ += "AND D2_CLIENTE = F2_CLIENTE "
cQ += "AND D2_LOJA = F2_LOJA "
cQ += "AND D2_EMISSAO = F2_EMISSAO "
cQ += "AND F2_DOC = '"+SF2->F2_DOC+"' "
cQ += "AND F2_SERIE = '"+SF2->F2_SERIE+"' "
cQ += "AND F2_CLIENTE = '"+SF2->F2_CLIENTE+"' "
cQ += "AND F2_LOJA = '"+SF2->F2_LOJA+"' "
cQ += "AND F2_EMISSAO = '"+dTos(SF2->F2_EMISSAO)+"' "
cQ += "AND D2_PEDIDO = C5_NUM "
cQ += "AND C5_TIPO IN ('1','2') "
cQ += "AND SF2.D_E_L_E_T_ = ' ' "
cQ += "AND SD2.D_E_L_E_T_ = ' ' " 
cQ += "AND SC5.D_E_L_E_T_ = ' ' " 
	
cQ := ChangeQuery(cQ)
	
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQ),cAliasTrb,.F.,.T.)

nReg := (cAliasTrb)->NREG

(cAliasTrb)->(dbCloseArea())

RestArea(aArea)

Return(nReg>0)
