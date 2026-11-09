#Include "TOTVS.CH"
#Include "topconn.ch"

/*/{Protheus.doc} SD3240I
Ponto de entrada para endereçamento das movimentações na 
integração do TOTVS MES para o Protheus.

@type	User Function
@author 	Evandro Simenes
@since 	21/12/2017
@version P12
/*/
User Function SD3240I()

	Local cQuery 
	Local cAliasSD7 := GetNextAlias()
	Private lMSErroAuto := .F.
	Private nStart
	
	If !IsInCallStack("WSPCPRUN")
	
		cQuery := "SELECT D7_LOTECTL, D7_NUMSEQ, SUM(D7_QTDE) D7_QTDE, SUM(D7_QTSEGUM) D7_QTSEGUM "
		cQuery += "  FROM "+RetSqlName("SD7")
		cQuery += " WHERE D7_FILIAL = '"+xFilial("SD7")+"'"
		cQuery += "   AND D_E_L_E_T_ <> '*'"
		cQuery += "   AND D7_PRODUTO = '"+SD3->D3_COD+"'"
		cQuery += "   AND D7_TIPO = 1"
		cQuery += "   AND D7_NUMERO = '"+SD3->D3_DOC+"'"
		cQuery += "   AND D7_ESTORNO <> 'S'"
		cQuery += "   AND D7_LOTECTL = '"+SD3->D3_LOTECTL+"'"
		cQuery += " GROUP BY D7_LOTECTL, D7_NUMSEQ"
	
		TcQuery cQuery New Alias &cAliasSD7
	
		if (cAliasSD7)->(!EOF())
			if !EnderItem((cAliasSD7)->D7_NUMSEQ,(cAliasSD7)->D7_QTDE)
				FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG SD3240I: "+cQuery, 0, (nStart - Seconds()), {})
				Alert("Falha no endereçamento do item "+SD3->D3_COD+". D3_DOC: "+SD3->D3_DOC)
			endif
		endIf
		
		(cAliasSD7)->(DbCloseArea())
		
	EndIf

Return

Static Function EnderItem(nSeq, nQtde)
	
	Local aCabSDA    := {} 
	Local aItSDB     := {} 
	Local aItensSDB := {} 
	Local nCount := 0
	Private nStart
	
	Private lMSErroAuto := .F.
	Private lAutoErrNoFile := .T.
	
	Aadd( aCabSDA, { 'DA_PRODUTO'	, SD3->D3_COD		, Nil } )
	Aadd( aCabSDA, { 'DA_NUMSEQ'  	, nSeq		, Nil } )
	
	//Dados do item que será endereçado
	aItSDB := {{"DB_ITEM"	  ,"0001"	  ,Nil},;                   
	           {"DB_ESTORNO"  ," "	      ,Nil},;                   
	           {"DB_LOCALIZ"  ,SD3->D3_LOCALIZ ,Nil},;            // VERIFICAR NOS TESTES SE O LOCAL ESTA CORRETO, POIS NAO TENHO COMO LER O XML NESTE PONTO DE ENTRADA       
	           {"DB_DATA"	  ,dDataBase  ,Nil},;                   
	           {"DB_QUANT"  ,nQtde        ,Nil}}       
	
	aadd(aItensSDB,aItSDB)
	
	//Executa o endereçamento do item
	//MATA265( aCabSDA, aItensSDB, 3)
	MSExecAuto({|x,y,z| MATA265(x,y,z)},aCabSDA,aItensSDB,3)
	If lMsErroAuto
		aErroAuto := GetAutoGRLog()
       For nCount := 1 To Len(aErroAuto)
        FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01",aErroAuto[nCount], 0, (nStart - Seconds()), {})
       Next nCount
	EndIf
	
Return .T.
