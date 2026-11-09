#Include "Protheus.ch"
#Include "TopConn.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} SD3250I
Ponto de entrada para endereçar o produto apontado no PC-Factory
com endereço gravado no SH6 - campo H6_ZZENDPR

@author João Gustavo Orsi
@since 05/12/2017
@version P12
/*/
//-------------------------------------------------------------------
User Function MT681INC()

	Local aAreaAtu	:= GetArea()
	Local _cLocaliz	:= SH6->H6_ZZENDPR
	Local nStart
	
    FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG MT681INC", 0, (nStart - Seconds()), {})
    FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG TOTVS1", 0, (nStart - Seconds()), {})
	
	If !Empty(_cLocaliz)
		FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG TOTVS2", 0, (nStart - Seconds()), {})
		EndProd(SD3->D3_DOC,SD3->D3_NUMSEQ,SD3->D3_COD,SD3->D3_LOCAL,SD3->D3_LOTECTL,_cLocaliz)	
	EndIf
	
	RestArea(aAreaAtu)
	
Return

//-------------------------------------------------------------------
/*/{Protheus.doc} EndProd
Função que faz o endereçamento automático após apontamento e ajuste 
empenho da OP pai com o endereço e número de série do produto FILHO
que está sendo apontado.

@author João Gustavo Orsi
@since 30/06/2016
@version P12
/*/
//-------------------------------------------------------------------
Static Function EndProd(_cDoc,_cNumseq,_cProduto,_cLocal,_cLoteCtl,_cLocaliz)
	
	Local aCab 		:= {}
	Local aItem		:= {} 
	Local aVetor 		:= {}
	Local aEmpen 		:= {}
	Local lMsErroAuto	:= .F.
	Local cAliasSDA	:= GetNextAlias()
	Private nStart
	
   		FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG TOTVS3", 0, (nStart - Seconds()), {})
	If !Empty(_cLocaliz) 
		FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG TOTVS4", 0, (nStart - Seconds()), {})
		BeginSql Alias cAliasSDA
			SELECT *
			FROM %table:SDA% SDA
			WHERE DA_FILIAL = %xFilial:SDA% AND 
				DA_DOC = %Exp:_cDoc% AND 
				DA_NUMSEQ = %Exp:_cNumseq% AND 
				DA_PRODUTO = %Exp:_cProduto% AND 
				DA_LOCAL = %Exp:_cLocal% AND 
				DA_LOTECTL = %Exp:_cLoteCtl% AND 
				SDA.%NotDel%
		EndSql 
		(cAliasSDA)->(DbGoTop())
		aCab :=	{;
			{"DA_PRODUTO"	,(cAliasSDA)->DA_PRODUTO	,Nil},; 
		   	{"DA_QTDORI"	,(cAliasSDA)->DA_QTDORI	,Nil},;
		    	{"DA_DATA"	,(cAliasSDA)->DA_DATA		,Nil},;
		    	{"DA_LOCAL"	,(cAliasSDA)->DA_LOCAL		,Nil},;
			{"DA_LOTECTL"	,(cAliasSDA)->DA_LOTECTL	,Nil},;
			{"DA_NUMLOTE"	,(cAliasSDA)->DA_NUMLOTE	,Nil},;
		    	{"DA_ORIGEM"	,(cAliasSDA)->DA_ORIGEM	,Nil},;
		    	{"DA_NUMSEQ"	,(cAliasSDA)->DA_NUMSEQ	,NIL};
			}		
		aAdd(aItem,	{;	
			{"DB_ITEM"	,"0001"					,Nil},; 
		    	{"DB_PRODUTO"	,(cAliasSDA)->DA_PRODUTO  	,Nil},; 
		    	{"DB_ESTORNO"	,""						,Nil},; 
		    	{"DB_LOCAL"	,(cAliasSDA)->DA_LOCAL		,Nil},; 
			{"DB_LOTECTL"	,(cAliasSDA)->DA_LOTECTL	,Nil},;
		    	{"DB_NUMLOTE"	,(cAliasSDA)->DA_NUMLOTE	,Nil},;
		    	{"DB_LOCALIZ"	,_cLocaliz				,Nil},; 
		    	{"DB_DATA"	,dDataBase				,Nil},; 
		    	{"DB_QUANT"	,(cAliasSDA)->DA_SALDO		,Nil},;
		    	{"DB_NUMSERI"	," "						,Nil},;
		    	{"DB_NUMSEQ"	,(cAliasSDA)->DA_NUMSEQ	,NIL},;
		    	{"DB_DOC"		,(cAliasSDA)->DA_DOC		,NIL},;
		    	{"DB_SERIE"	,(cAliasSDA)->DA_SERIE		,NIL},;
		    	{"DB_CLIFOR"	,(cAliasSDA)->DA_CLIFOR	,NIL},;
		    	{"DB_LOJA"	,(cAliasSDA)->DA_LOJA		,NIL};
			})
		(cAliasSDA)->(DbCloseArea())
        FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG TOTVS5", 0, (nStart - Seconds()), {})
		MSExecAuto({|x,y,z| MATA265(x,y,z)},aCab,aItem,3) // Execucao rotina automatica MATA265
		If lMSErroAuto
			FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG TOTVS ERRO", 0, (nStart - Seconds()), {})
			MostraErro()
			DisarmTransaction()
			
		ELSE
			FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG TOTVS SUCESSO", 0, (nStart - Seconds()), {})
		EndIf
	EndIf

Return
