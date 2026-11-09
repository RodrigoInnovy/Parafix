#Include "TOTVS.CH"
#Include "topconn.ch"
//-------------------------------------------------------------------
/*/{Protheus.doc} MATI240CRG
Ponto de entrada para carregar o campo D3_TM e D3_CC na 
integração do TOTVS MES para o Protheus.

@type	User Function
@author 	Evandro Simenes
@since 	21/12/2017
@version P12
/*/
//-------------------------------------------------------------------
user function MATI240CRG()
	local aRet 
	local oXml
	local aArea := GetArea()
	Local nStart
	
	FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG MATI240CRG", 0, (nStart - Seconds()), {})
	
	If oXmlMvInt:_TotvsMessage:_MessageInformation:_Transaction:Text == "movementsinternal"
		oXml := oXmlMvInt:_TotvsMessage:_BusinessMessage:_BusinessContent
		
		aRet := getTMProt(oXml:_xMovTypeCode:Text, oXml:_ProductionOrderNumber:Text)
	endIf
	restArea(aArea)
return aRet

static function getTMProt(cTMPPI, cOp)

	local aRet		:= {}
	local cAlias 	:= ""
	Local nStart
	
	cAlias := qryZA3(cTMPPI, cOp)
	(cAlias)->(dbGoTop()) 

	if !(cAlias)->(eof()) 
		if (cAlias)->OP != "1" //Retorna o campo C2_ZBENEF da tabela SC2, se for 1, não adiciona o campo D3_TM vindo da tabela ZA3, pois o mesmo não é necessário para a integração do TOTVS MES.
			FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG MATI240: ENCONTROU E ADICIONOU AO D3_TM", 0, (nStart - Seconds()), {})
			aadd(aRet,{"D3_TM",(cAlias)->ZA3_TMPROT,Nil})
		else //Se o campo C2_ZBENEF da tabela SC2 for 1, adiciona o valor 501 no campo D3_TM, pois o mesmo é necessário para a integração do TOTVS MES.
			FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG MATI240: ENCONTROU E ADICIONOU AO D3_TM", 0, (nStart - Seconds()), {})
			aadd(aRet,{"D3_TM","501",Nil}) 
		endIf
	else
		FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG MATI240: NAO ENCONTROU NADA PARA A ZZTMPPI "+cTMPPI, 0, (nStart - Seconds()), {})
	endif
	
	(cAlias)->(DbCloseArea())
return aRet

static function qryZA3(cTMPPI, cOp)

	local cQuery := ""
	local cAlias := GetNextAlias()
	local cEol   := chr(10) + chr(13)
	
	cQuery := " SELECT ZA3.ZA3_TMPROT, " + cEol
	cQuery := " (SELECT C2_ZBENEF FROM "+RetSqlName("SC2") +" C2 " + "WHERE C2_NUM = '"+cOp+"' AND C2.D_E_L_E_T_ = '') AS OP " + cEol
	cQuery += " 	FROM " +RetSqlName("ZA3") +" ZA3 "+ cEol
	cQuery += " 	WHERE ZA3.ZA3_FILIAL = '"+ xFilial("ZA3") +"'"+ cEol
	cQuery += " 		AND ZA3.ZA3_TMPPI = '" + cTMPPI + "'"+ cEol
	cQuery += " 		AND ZA3.D_E_L_E_T_ = ' ' " + cEol
			
	TCQUERY cQuery NEW ALIAS &cAlias

return cAlias
