#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE 'TOPCONN.CH'

/*/{Protheus.doc} ZA1REIMPR
Função para reimpressão de etiquetas dos lotes fracionados
@author Evandro Simenes
@since 23/10/2017 
@version 1.0
/*/
User Function ZA1REIMPR()
	Local aArea := GetArea()
	Local cDataHora := ""
	Local oModel := FWModelActive()
	Local cDataVal := DTOC(getValid2(ZA1->ZA1_NF, ZA1->ZA1_SERIE, ZA1->ZA1_CODFOR, ZA1->ZA1_CODPRO))
	Local cCodBar := ""
	local cPrefixo1 := "%001" // Pré-requisito PC-Factory
	local cPrefixo2 := "%010" // Pré-requisito PC-Factory
	local cPrefixo3 := "%030" // Pré-requisito PC-Factory
	Local cNFSerie := Alltrim(ZA1->ZA1_NF)+"/"+Alltrim(ZA1->ZA1_SERIE)
	Local cForLoja := Alltrim(ZA1->ZA1_CODFOR)+"/"+Alltrim(ZA1->ZA1_LOJA)
	Local cItem    := Alltrim(ZA1->ZA1_ITEM)
	Private nStart
	
	IF ZA1->ZA1_STATUS == '4' .OR. ZA1->ZA1_STATUS == '5'
		
		cDataHora := dToC(ZA1->ZA1_DTMOV)+" "+ZA1->ZA1_HRMOV
		cCodBar		:= cPrefixo1+allTrim(ZA1->ZA1_CODPRO)+cPrefixo2+allTrim(ZA1->ZA1_LOTE)+cPrefixo3+Alltrim(str(Round(ZA1->ZA1_QTD1UM,6)))
        FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG ZA1REIMPR: "+cCodBar, 0, (nStart - Seconds()), {})
		U_etqMPPI("MP",; 				//Tipo produto
		          ZA1->ZA1_CODPRO,; 	//Codigo Produto
		          ZA1->ZA1_DESCPR,; 	// Descricao Produto
		          ZA1->ZA1_LOTE,; 		//Lote
		          cDataHora,; 			//Data Hora Mov
		          cDataVal,; 			// Data Validade
		          Transform(ZA1->ZA1_QTD1UM,"@E 9,999,999.99"),;//Qtd 1 
		          ZA1->ZA1_UM,; 		//U.M. 1
		          Transform(ZA1->ZA1_QTD2UM,"@E 9,999,999.99"),;// Qtd 2
		          ZA1->ZA1_2UM,; 		//U.M. 2
		          cCodBar,; 			// Codigo de Barras
		          1,; 					// Qtd etiquetas
		          cNFSerie,;                 //NF/SERIE
		          cForLoja,;                 //CODFOR/LOJA
		          cItem) 					// ZA1_ITEM
	ELSE
		Help( ,, 'Help',, "Só é permitido reimprimir etiquetas para itens com status 'Aguardando Conferencia' e 'Finalizados'", 1, 0 )
	ENDIF
	
	RestArea(aArea)
Return

Static Function getValid2(cNF, cSerie, cCodFor, cCodPro)
	Local dDataVal := Date()
	Local dDataEmi := Date()
	Local aArea := GetArea()
	Local cQry := ""
	Local nPrValid
	
	cQry := "SELECT B1_PRVALID "
	cQry += "  FROM "+RetSqlName("SB1")
	cQry += " WHERE D_E_L_E_T_ <> '*'"
	cQry += "   AND B1_FILIAL 	= '"+xFilial("SB1")+"'"
	cQry += "   AND B1_COD = '"+cCodPro+"'"
	
	TcQuery cQry Alias TSB1 New
	
	If TSB1->(!EOF())
		nPrValid := TSB1->B1_PRVALID
	Else
		nPrValid := 0
	Endif
	
	TSB1->(DbCloseArea())
	
	cQry := "SELECT F1_RECBMTO "
	cQry += "  FROM "+RetSqlName("SF1")
	cQry += " WHERE D_E_L_E_T_ <> '*'"
	cQry += "   AND F1_FILIAL 	= '"+xFilial("SF1")+"'"
	cQry += "   AND F1_DOC 		= '"+cNF+"'"
	cQry += "   AND F1_SERIE 	= '"+cSerie+"'"
	cQry += "   AND F1_FORNECE 	= '"+cCodFor+"'"
	
	TcQuery cQry Alias TSF1 New
	
	If TSF1->(!EOF())
		dDataEmi := STOD(TSF1->F1_RECBMTO)
	Else
		Help( ,, 'Help',, "Data de Recebimento da NF nao foi encontrada.", 1, 0 )
	Endif
	
	TSF1->(DbCloseArea())
	
	dDataVal := dDataEmi + nPrValid
	
	RestArea(aArea)
Return dDataVal