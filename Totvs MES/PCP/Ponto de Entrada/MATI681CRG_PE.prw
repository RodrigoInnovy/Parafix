#Include 'Protheus.ch'
User Function MATI681CRG()
	Local aRet := {}
	Private nStart
	
	
	FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG MATI681CRG", 0, (nStart - Seconds()), {})
	
	//Grava endereço no SH6 campo especifico
	aAdd(aRet, {"H6_ZZENDPR", oXml:_TotvsMessage:_BusinessMessage:_BusinessContent:_LocationCode:Text, Nil})
	
Return aRet
