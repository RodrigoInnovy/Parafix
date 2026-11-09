#Include "RWMAKE.CH"
#Include "PROTHEUS.CH"
#Include "TopConn.CH"

User Function M460FIM()

Local _aArea    := GetArea()
Local _aAreaSA2 := SA2->(GetArea())
Local _aAreaSD2 := SD2->(GetArea())
Local _aAreaSD1 := SD1->(GetArea())
Local _aAreaSF2 := SF2->(GetArea())

Local cSql 			:= ""
Local nPerDeso 		:= Val(GetMV("MV_ZZPDESO"))
Local lConfirma     := .t.
Local nOpca 		:=	0
Local cCadastro 	:=	OemToAnsi("Geracao Automática do Documento de Entrada")

Local _nCont    := 0
Local cTesEnt   := ""
Local cTesCfop  := ""
Local cNatureza	:= ""

Private _cRotina:= "M460FIM"  //fUNNAME()
Private aCab	:= {}
Private aItens	:= {}
Private cFornece:= ""
Private cLojaFor:= ""
Private cEmpOri	:= cEmpAnt
Private cFilOri	:= cFilAnt
Private _cTipo  := ""
Private nStart

**** Fernando 09/04/2019 
*******************************              
Private xEstCLI     := ""
Private xPedC5      := ""    
Private xPesLiq     := 0
Private xPesBru     := 0
*******************************              
   
   FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG M460FIM: ENTROU", 0, (nStart - Seconds()), {})
   
 cSql  := ""
 cSql  += " SELECT D2_COD, R_E_C_N_O_ REGISTRO FROM "
 cSql  += RetSqlName("SD2")
 cSql  += " WHERE D_E_L_E_T_  = ' ' AND "
 cSql  += "       D2_FILIAL   = '"+SF2->F2_FILIAL+"' AND "
 cSql  += "       D2_DOC      = '"+SF2->F2_DOC+"' AND  "
 cSql  += "       D2_SERIE    = '"+SF2->F2_SERIE+"' AND  "
 cSql  += "       D2_CLIENTE  = '"+SF2->F2_CLIENTE+"' AND  "
 cSql  += "       D2_LOJA     = '"+SF2->F2_LOJA+"' AND  "
 cSql  += "       SUBSTRING(D2_CF,1,1) < '7' "
 cSql  += " ORDER BY D2_ITEM "

if select("OPNW")> 0
	dbSelectArea("OPNW")
	dbCloseArea()
	dbselectarea("SD2")
endif

dbUseArea(.T.,"TOPCONN",TcGenQry(,, cSql),"OPNW",.T.,.T.)

sb5->(dbsetorder(1))
dbSelectArea("OPNW")

while !opnw->(eof())
	dbselectarea("SD2")
	sd2->(dbgoto(opnw->registro))
	if sb5->(dbseek(xfilial("SB5") + sd2->d2_cod )) 
		if sb5->b5_inspat == "1" .and. !empty(sb5->b5_codativ) .and. nPerDeso > 0
			sd2->(RecLock("SD2",.f.))
			//sd2->d2_zdeson := sd2->d2_BASIMP5 * 0.025  //(sd2->d2_valbrut - ( sd2->d2_valicm + sd2->d2_valipi + sd2->d2_valimp5 + sd2->d2_valimp6)) * 0.025
			sd2->d2_zdeson := sd2->d2_BASIMP5 * (nPerDeso/100)
			sd2->(MsUnlock())	
		endif
	endif
	dbSelectArea("OPNW")
	opnw->(dbskip())
end-while

OPNW->(dbCloseArea())

cDoc		:= SF2->F2_DOC  
cSerie      := SF2->F2_SERIE
cCliente	:= SF2->F2_CLIENTE
cLojaCli	:= SF2->F2_LOJA            
cEmissao    := DTOS(SF2->F2_EMISSAO)
cCNPJOri    := SM0->M0_CGC     

**** Fernando 09/04/2019 
*******************************              
xEstCLI     := SF2->F2_EST
//xPesLiq     := SF2->F2_PLIQUI - desabilitado em 02/07/2019 conforme solicitacao do Samuel     
xPesBru     := SF2->F2_PBRUTO
*******************************

If SF2->F2_TIPO == "N"
	cFilTrf     := Posicione("SA1",1,xFilial("SA1")+cCliente+cLojaCli,"A1_FILTRF")
Else 
	cFilTrf     := Posicione("SA2",1,xFilial("SA2")+cCliente+cLojaCli,"A2_FILTRF")
EndIf

If SF2->F2_TIPO == "N"
	DbselectArea("SA2")
	DbSetOrder(3)
	Dbseek(xFilial("SA2")+cCNPJOri)
	
	cFornece 	:= SA2->A2_COD
	cLojaFor   	:= SA2->A2_LOJA
	cEstCli		:= SA2->A2_EST

Else                          
	DbselectArea("SA1")
	DbSetOrder(3)
	Dbseek(xFilial("SA1")+cCNPJOri)
	
	cFornece 	:= SA1->A1_COD
	cLojaFor   	:= SA1->A1_LOJA
	cEstCli		:= SA1->A1_EST

EndIf

cEmpAtu := cEmpAnt
cFilAtu	:= cFilTrf 
aItens 	:= {}

*************************************************************************************
**** Incluso pelo Fernando em 09/04/2019 - Trantamento Pesos das notas de Export
*************************************************************************************
dbSelectArea("SD2")
dbSetOrder(3)
lGrvPeso := .F.
If dbSeek(xFilial("SD2")+cDoc+cSerie+cCliente+cLojaCli) .and. AllTrim(xEstCLI) == "EX"
    xPedC5  := SD2->D2_PEDIDO
	//xPesLiq := Posicione("SC5",1,xFilial("SC5")+xPedC5,"C5_PESOL" ) - desabilitado em 02/07/2019 conforme solicitacao do Samuel    
	xPesBru := Posicione("SC5",1,xFilial("SC5")+xPedC5,"C5_PBRUTO")
    lGrvPeso:= .T.
Endif              
RestArea(_aAreaSF2)
If lGrvPeso
	SF2->(Reclock("SF2",.F.))
      	//SF2->F2_PLIQUI := xPesLiq - desabilitado em 02/07/2019 conforme solicitacao do Samuel    
 		SF2->F2_PBRUTO := xPesBru     
	SF2->(MsUnlock("SF2"))
Endif
*************************************************************************************

dbSelectArea("SD2")
dbSetOrder(3)
If dbSeek(xFilial("SD2")+cDoc+cSerie+cCliente+cLojaCli) .and. SC5->C5_ZZTRANS == '1' //"1"=Sim -> PV é transferencia
	
	While !Eof() .and. SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA == xFilial("SD2")+cDoc+cSerie+cCliente+cLojaCli
		cTesSai  := SD2->D2_TES
		cTesEnt  := Posicione("SF4",1,xFilial("SF4")+SD2->D2_TES,"F4_ZZTES")
		cTesCfop := Posicione("SF4",1,xFilial("SF4")+cTesEnt,"F4_CF")
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Realiza a validacao dos TES selecionados ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lConfirma := !Empty(cTesEnt) //A460VldTes(cFilOri,cFilAtu,.T.,{cTesSai,cTesEnt})
		If lConfirma
		
            // Grava arquivo de controle - SZ8
			TSGrvRemDev(cFornece, cLojaFor, cFilTrf)			

			aIt 	:= Array(0)
			aAdd( aIt, 	{"D1_COD"		,SD2->D2_COD	      	,Nil} )
			aAdd( aIt, 	{"D1_UM"		,SD2->D2_UM				,Nil} )
			aAdd( aIt, 	{"D1_TIPO"		,SD2->D2_TIPO			,Nil} )
			aAdd( aIt,	{"D1_QTSEGUM"	,SD2->D2_QTSEGUM    	,Nil} )			
			aAdd( aIt,	{"D1_QUANT"		,SD2->D2_QUANT			,Nil} )
			aAdd( aIt, 	{"D1_VUNIT"		,SD2->D2_PRCVEN			,Nil} )
			aAdd( aIt, 	{"D1_TOTAL"		,SD2->D2_TOTAL			,Nil} )
			aAdd( aIt, 	{"D1_ITEM" 		,SD2->D2_ITEM			,Nil} )
			aAdd( aIt,  {"D1_EMISSAO"	,SD2->D2_EMISSAO		,Nil} )
			aAdd( aIt,  {"D1_DTDIGIT"	,SD2->D2_EMISSAO		,Nil} )
			aAdd( aIt, 	{"D1_TES"		,cTesEnt 				,Nil} )		// Verificar como Pegar essa TES
			aAdd( aIt, 	{"D1_CF"		,cTesCfop				,Nil} )		// Verificar CFOP de Entrada
			aAdd( aIt, 	{"D1_LOCAL"		,SD2->D2_LOCAL			,Nil} )
			aAdd( aIt,	{"D1_LOTECTL"	,SD2->D2_LOTECTL		,Nil} )
			aAdd( aIt,	{"D1_DTVALID"	,SD2->D2_DTVALID		,Nil} )
			//If SD2->D2_TIPO = "B"
			aAdd( aIt,	{"D1_NFORI"		,SD2->D2_NFORI			,Nil} )
			aAdd( aIt,	{"D1_SERIORI"	,SD2->D2_SERIORI		,Nil} )
			aAdd( aIt,	{"D1_ITEMORI"	,SD2->D2_ITEMORI		,Nil} )
			//EndIf
			
			AADD(aItens,aIT)
			dbSelectArea("SD2")
			dbSkip()
		Else 
			_nCont++
		EndIf
		
	Enddo
	
	aCab 	:=	{	{"F1_TIPO"		,SF2->F2_TIPO							,Nil},;
					{"F1_FORMUL"	,'N'									,Nil},;
					{"F1_DOC"		,SF2->F2_DOC							,Nil},;
					{"F1_SERIE"		,SF2->F2_SERIE	    			   		,Nil},;
					{"F1_EMISSAO"	,SF2->F2_EMISSAO				    	,Nil},;
					{"F1_DTDIGIT"	,SF2->F2_EMISSAO						,Nil},;
					{"F1_RECBMTO"	,SF2->F2_EMISSAO						,Nil},;
					{"F1_FORNECE"	,cFornece							    ,Nil},;
					{"F1_LOJA"	  	,cLojaFor								,Nil},;
					{"F1_COND" 	 	,SF2->F2_COND 			    			,Nil},;
					{"F1_NATUREZ"   ,cNatureza		   			        	,Nil},;		//Ver Qual a Natureza
					{"F1_EST"    	,cEstCli			                    ,Nil},;
					{"F1_ESPECIE"	,'NF'    					    		,Nil}}
					
	_cTipo := SF2->F2_TIPO
	IF !Empty(aItens) //.and. _nCont == 0 //nCont > 0 é que teve item na NF c\ TES indevido
		DbSelectArea("SF4")
		DbSetOrder(1)
		DbSeek(xFilial("SF4")+cTesEnt)
		Reclock("SF4",.F.)
		SF4->F4_TRANFIL := "2"
		MsUnlock()
		
		Processa( { || GeraNfe(cEmpAtu,cFilAtu,aCab,aItens,.F.,SF2->F2_EMISSAO,SF2->F2_DOC,SF2->F2_SERIE,cFornece,cLojaFor,"",cEmissao,_cTipo) } )
		
		DbSelectArea("SF4")
		DbSetOrder(1)
		DbSeek(xFilial("SF4")+cTesEnt)
		Reclock("SF4",.F.)
		SF4->F4_TRANFIL := "1"
		MsUnlock()
		
	Else
	    Alert("Nota Fiscal de Entrada não foi Incluida, verifique!")
	Endif
EndIf

U_AdiCtrlExp('3','Aguardando Etiq Volumes')
U_AtuCB6()

//Restaura as Areas
RestArea(_aAreaSA2)
RestArea(_aAreaSF2)
RestArea(_aAreaSD2)
RestArea(_aAreaSD1)
RestArea(_aArea)

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GERANfe   ºAutor  ³                    º Data ³  22/11/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao que gera a Nota Fiscal de Entrada                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP8                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GeraNfe(cEmpAtu,cFilAtu,aCab,aItens,lPreNF,dDtRef,cDoc,cSerie,cFornece,cLojaFor,cObservac,cEmissao,_cTipo)
Local  _cCHVNFE         := ""

Private lMsErroAuto 	:= 	.F. 	//necessario a criacao, pois sera atualizado quando houver alguma incosistencia nos parametros
Private lMsHelpAuto 	:= 	.F. 	// se .t. direciona as mensagens de help para o arq. de log
Private nStart


cFilAnt	:= cFilAtu

MSExecAuto( { |x,y,z| Mata103(x,y,z) } , aCab , aItens , 3 )

If	lMsErroAuto
	DisarmTransaction()
	MostraErro()
    FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","Erro na Geracao NFE ", 0, (nStart - Seconds()), {}) 
	Return(.f.)    
Else
	u_AtuNFsTrans(cEmpAtu,cFilAtu,cDoc,cSerie,cFornece,cLojaFor,cEmissao,_cRotina,_cCHVNFE,cCliente, cLojaCli,_cTipo)
	FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","Concluida Geracao NFE " , 0, (nStart - Seconds()), {})
Endif

cFilAnt	:= cFilOri

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ AtuNFsTransºAutor³ tuning sistemas    º Data ³  20/11/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao que atualiza campos SF1, Sf3 e SFT                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ m460fim (pe)                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function AtuNFsTrans(cEmpAtu,cFilAtu,cDoc,cSerie,cFornece,cLojaFor,cEmissao,_cRotina,_cCHVNFE,cCliente, cLojaCli,_cTipo)
Local _aArea    := GetArea()
Local _aAreaSF1 := SF1->(GetArea())
Local _aAreaSF3 := SF3->(GetArea())
Local _aAreaSF2 := SF2->(GetArea())
Local _aAreaSFT := SFT->(GetArea())

Local _cChaveNFE := cDoc+cSerie+cFornece+cLojaFor+_cTipo
Local _cChaveNF3 := cDoc+cSerie+cFornece+cLojaFor //+_cTipo
Local _cChaveNFS := cDoc+cSerie+cCliente+cLojaCli
Local _cChaveNF2 := "E"+cSerie+cDoc+cFornece+cLojaFor


dbSelectArea("SF1")
dbSetOrder(1)    //Numero + Serie + Fornecedor + Loja + Tipo da Nota                     
If dbSeek(xFilial("SF1")+_cChaveNFE)
	RecLock("SF1",.f.)     
	    If _cRotina == "M460FIM"
			SF1->F1_ZZORIGE := "M460FIM"
		EndIf
		SF1->F1_ESPECIE := If(_cRotina="PARA001","SPED","")
		SF1->F1_CHVNFE  := If(_cRotina="PARA001",_cCHVNFE,"")
	MsUnlock()
EndIf

dbSelectArea("SF3")
dbSetOrder(1)  //DT Entrada + Nota Fiscal + Serie N.F. + Clien/Fornec + Loja + Cod. Fis
If dbSeek(xFilial("SF3")+cEmissao+_cChaveNF3)
	//If SF3->F3_TIPO == _cTipo
		RecLock("SF3",.f.)
		SF3->F3_ESPECIE := If(_cRotina="PARA001","SPED","")
		SF3->F3_CHVNFE  := If(_cRotina="PARA001",_cCHVNFE,"")
		MsUnlock()
	//EndIf
EndIf


dbSelectArea("SFT")
dbSetOrder(1)       //Tipo Mov. + Série NF + Doc. Fiscal + Cli/Forn. + Codigo loja + Código
If dbSeek(xFilial("SFT")+_cChaveNF2)
	While !Eof() .and. xFilial("SFT")+_cChaveNF2 == SFT->FT_FILIAL+SFT->FT_TIPOMOV+SFT->FT_SERIE+SFT->FT_NFISCAL+SFT->FT_CLIEFOR+SFT->FT_LOJA
		If SFT->FT_TIPO == _cTipo
			RecLock("SFT",.f.)
				SFT->FT_ESPECIE := If(_cRotina="PARA001","SPED","")
				SFT->FT_CHVNFE  := If(_cRotina="PARA001",_cCHVNFE,"")
			MsUnlock()
		EndIf
		dbSkip()
	End
EndIf

dbSelectArea("SF2")
dbSetOrder(1)    //Numero + Serie Docto. + Cliente + Loja + Form. Prop. + Tipo da nota   
If dbSeek(cFilOri+_cChaveNFS) .and. _cRotina == "M460FIM"
	If SF2->F2_TIPO == _cTipo
		RecLock("SF2",.f.)
			SF2->F2_ZZORIGE := "M460FIM"
		MsUnlock()
	EndIf
EndIf                 



//Restaura as areas salvas
RestArea(_aAreaSF2)
RestArea(_aAreaSF1)
RestArea(_aAreaSF3)
RestArea(_aAreaSFT)
RestArea(_aArea)

Return
                      
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ A460VldTes ³ Autor ³                     ³ Data ³ 13/11/16 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Validacao da TES                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³ A410VldTes(cFilOri,cFilDest)                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cFilOri  = Codigo da Filial Origem                        ³±±
±±³          ³ cFilDest  = Codigo da Filial Destin                        ³±±
±±³          ³ lValida   = Verifica se valida Tes                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ M460FIM   (PE. MATA410)                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function A460VldTes(cFilOri,cFilDest,lValida,aParam)
Local _aAreaAnt  := GetArea()
Local _aAreaSF4  := SF4->(GetArea())
Local lRet      := .T.
Local cFilBkp   := cFilAnt // Armazena a filial corrente

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Valida TES de Transferencia entre Filiais                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SF4")
If lValida
	//Carrega Filial Origem e Destino
	cFilAnt  := cFilOri
	cFilOri := xFilial("SF4")
	cFilAnt  := cFilDest
	cFilDest := xFilial("SF4")
	
	// Restaura a filial corrente
	cFilAnt  := cFilBkp
	
	// Validacao para o campo F4_TRANSFIL
	If lRet .And. FieldPos("F4_TRANFIL") > 0
		If MsSeek(cFilOri+aParam[1]) .And. SF4->F4_TRANFIL == "2"
//			If Aviso("MA460FIM","A TES"+aParam[1]+" não esta configurada para ser utilizada no processo de transferencia entre filiais." , {"Ok"}) // Favor verificar se o campo 'Trans. Filial' esta ativado no cadastro de TES."
				lRet := .F.
//			EndIf
		EndIf
	EndIf
	If lRet .And. FieldPos("F4_TRANFIL") > 0
		If MsSeek(cFilDest+aParam[2]) .And. SF4->F4_TRANFIL == "2"
//			If Aviso("MA460FIM", "A TES"+aParam[2]+"não esta configurada para ser utilizada no processo de transferencia entre filiais. Favor verificar se o campo 'Trans. Filial' esta ativado no cadastro de TES."," - " + aParam[2], {"Ok"})
				lRet := .F.
//			EndIf
		EndIf
	EndIf
	// Verifica se a Tes esta cadastrada na Filial Origem
	If lRet .And. !MsSeek(cFilOri+aParam[1]) .And. FieldPos("F4_TRANFIL") == 1  //Tes de transferencia
//		Aviso("MA460FIM","A TES"+aParam[1]+" de saida não esta cadastrada na filial. Favor verificar se a TES esta cadastrada." + " - Filial Origem" + cFilOri , {"Ok"})
		lRet := .F.
	EndIf
	// Verifica se a Tes esta cadastrada na Filial Destino
	If lRet .And. !MsSeek(cFilDest+aParam[2]) .And. FieldPos("F4_TRANFIL") == 1 //Tes de Transferencia
//		Aviso("MA460FIM","A TES "+aParam[2]+" de entrada não esta cadastrada na filial. Favor verificar se a TES esta cadastrada." + " - Filial Destino" + cFilDest, {"Ok"})
		lRet := .F.
	EndIf                                                                        

EndIf

RestArea(_aAreaSF4)
RestArea(_aAreaAnt)

Return lRet

// Grava controle de Saldo
Static Function TSGrvRemDev(cFornece, cLojaFor, cFilTrf)

Local aArea     := GetArea()
Local _cItemOri := Alltrim(SD2->D2_ITEMORI)+Space( TamSx3("Z8_ITEM   ")[1]-LEN(Alltrim(SD2->D2_ITEMORI)) )
Local _cNrCTRL  := BuscaNrCTRL ()

	dbSelectArea("SZ8")
	dbSetOrder(1)
		
		RecLock("SZ8",.t.)
		SZ8->Z8_FILIAL	:= xFilial("SZ8")
		SZ8->Z8_DOC		:= SD2->D2_DOC
		SZ8->Z8_SERIE 	:= SD2->D2_SERIE
		SZ8->Z8_ITEM 	:= SD2->D2_ITEM
		SZ8->Z8_COD 	:= SD2->D2_COD
		SZ8->Z8_EMISSAO := SD2->D2_EMISSAO
		SZ8->Z8_QUANT 	:= SD2->D2_QUANT
		SZ8->Z8_UM 		:= SD2->D2_UM
		SZ8->Z8_TIPO 	:= If (Alltrim(SD2->D2_TIPO)=="N","R","D")
		SZ8->Z8_FILORI 	:= cFilAnt
		SZ8->Z8_FILDEST := cFilTrf
		SZ8->Z8_CLIFOR 	:= SD2->D2_CLIENTE
		SZ8->Z8_LOJA 	:= SD2->D2_LOJA
		SZ8->Z8_NFORIG 	:= SD2->D2_NFORI
		SZ8->Z8_SERIORI := SD2->D2_SERIORI
		SZ8->Z8_ITEMORI := SD2->D2_ITEMORI
		SZ8->Z8_NUMSEQ 	:= SD2->D2_NUMSEQ
		SZ8->Z8_NRCTRL 	:= _cNrCTRL
		SZ8->Z8_SALDO 	:= If (Alltrim(SD2->D2_TIPO)=="N",SD2->D2_QUANT,0)
		
		MsUnlock()
	    
	    If !Empty(SD2->D2_NFORI)	
	    	If DbSeek(xFilial("SZ8")+SD2->D2_NFORI+SD2->D2_SERIORI+_cItemOri+SD2->D2_COD+cFornece+cLojaFor)
			    RecLock("SZ8",.F.)

				SZ8->Z8_SALDO 	:= SZ8->Z8_SALDO - SD2->D2_QUANT
				
				MsUnlock()
		    EndIf
	    EndIf
	
	
	RestArea(aArea)

Return()

//Busca numero de controle
Static Function BuscaNrCTRL ()
Local _cNrCtrl := ""
Local _cItemOri := Alltrim(SD2->D2_ITEMORI)+Space( TamSx3("Z8_ITEM   ")[1]-LEN(Alltrim(SD2->D2_ITEMORI)) )
Local cSql  := ""                

If !Empty(SD2->D2_NFORI)
	 cSql  := ""
	 cSql  += " SELECT max(Z8_NRCTRL) as Z8_NRCTRL FROM "
	 cSql  += RetSqlName("SZ8")
	 cSql  += " WHERE D_E_L_E_T_  = ' ' AND "
	 cSql  += "       Z8_FILIAL   = '"+xFilial("SZ8")+"' AND "
	 cSql  += "       Z8_DOC      = '"+SD2->D2_NFORI+"' AND  "
	 cSql  += "       Z8_SERIE    = '"+SD2->D2_SERIORI+"' AND  "
	 cSql  += "       Z8_ITEM     = '"+SD2->D2_ITEMORI+"' AND  "
	 cSql  += "       Z8_COD      = '"+SD2->D2_COD+"' AND  "
	 cSql  += "       Z8_CLIFOR   = '"+cFornece+"' AND  "
	 cSql  += "       Z8_LOJA     = '"+cLojaFor+"' AND  "
	 cSql  += "       Z8_TIPO     = 'R'"

	cSql := ChangeQuery(cSql)
	
	TCQuery cSql New Alias "TMPSZ8"
			
	DBSelectArea("TMPSZ8")
	//DBGoTop()
	While !Eof()
		_cNrCtrl := TMPSZ8->Z8_NRCTRL
		TMPSZ8->(dbskip())
	End
	TMPSZ8->(DBCloseArea())	
	
Else
	_cNrCtrl := SD2->D2_NUMSEQ	
EndIf

Return(_cNrCtrl)
