#Include "TOTVS.CH"

/*/{Protheus.doc} MI261GCP
Ponto de entrada para carregar o campo D3_ZZOP customizado da 
integração do TOTVS MES para o Protheus.

@type	User Function
@author 	João Gustavo Orsi
@since 	30/10/2017
@version P12
/*/
User Function MI261GCP()

	Local aRet 			:= {} 
	Local oXmlBusinItem 	:= nil
	Local cOpTrans 		:= ""
	Local cOpTMPPI			:= ""
	Public __cOpTrans
	Public __cOpTMPPI
	Private nStart

	FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG MI261GCP", 0, (nStart - Seconds()), {})
	oXmlBusinItem := oXmlBusin:_BUSINESSCONTENT:_LISTOFTRANSFERWAREHOUSEITEM
	cOpTrans := PadR(oXmlBusinItem:_TRANSFERWAREHOUSEITEM[1]:_xWoCode:Text,TamSX3("D3_ZZOP")[1])
	cOpTMPPI := PadR(oXmlBusinItem:_TRANSFERWAREHOUSEITEM[1]:_xMovTypeCode:Text,TamSX3("D3_TM")[1])
	
	__cOpTrans := cOpTrans
	__cOpTMPPI  := cOpTMPPI
	//Variáveis públicas utilizadas no ponto de entrada MA261TRD3
	
	FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG MI261GCP OP: "+cOpTrans, 0, (nStart - Seconds()), {})
	FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG MI261GCP TMPPI: "+cOpTMPPI, 0, (nStart - Seconds()), {})
	
	
	//aAdd(aRet,{"D3_ZZOP",cOpTrans,Nil})
	
Return aRet
