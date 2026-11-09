#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'
#Include "topconn.ch"

/*/{Protheus.doc} DelCtrlExp
Exclui status para Controle de Expedicao
@author Evandro Simenes
@since 21/10/2017 
@version 1.0
/*/ 
User Function DelCtrlExp(cStatus)
	Local oCtrlExp
	Local aArea := GetArea()
	local cNextAlias := GetNextAlias()
	Local cQuery := ""
	Private nStart
	
	oCtrlExp := ControleDeExpedicao():newControleDeExpedicao()
	
	FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG DelCtrlExp: cStatus: "+cStatus, 0, (nStart - Seconds()), {})
	
	DO CASE
		CASE cStatus == "1"
			oCtrlExp:setcOrdSep(CB7->CB7_ORDSEP)
			oCtrlExp:setcLoja(CB7->CB7_LOJA)

		CASE cStatus == "2"
			FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG SIM1: STATUS 2 ORDSEP "+CB7->CB7_ORDSEP, 0, (nStart - Seconds()), {})
			oCtrlExp:setcOrdSep(CB7->CB7_ORDSEP)
			oCtrlExp:setcLoja(CB7->CB7_LOJA)
			//oCtrlExp:setcItem(CB8->CB8_ITEM)
			oCtrlExp:setcCodPro(CB8->CB8_PROD)
			//oCtrlExp:setcSequenc(CB8->CB8_SEQUEN)

		CASE cStatus == "5"
			oCtrlExp:setcOrdSep(CB7->CB7_ORDSEP)
			oCtrlExp:setcLoja(CB7->CB7_LOJA)
			oCtrlExp:setcIdVol(cIdVol)
			

		CASE cStatus == "3"
			cQuery := " SELECT DISTINCT F2_DOC, F2_SERIE, F2_TRANSP, A4_NOME, C9_ORDSEP, F2_LOJA " 
			cQuery += "   FROM "+RetSqlName("SF2")+" SF2 "
			cQuery += "   INNER JOIN "+RetSqlName("SD2")+" SD2 "
			cQuery += "      ON SD2.D_E_L_E_T_ <> '*' "
			cQuery += "     AND SD2.D2_FILIAL = '"+xFilial("SD2")+"' "
			cQuery += "     AND SD2.D2_LOJA = SF2.F2_LOJA "
			cQuery += "     AND SD2.D2_DOC = SF2.F2_DOC "
			cQuery += "     AND SD2.D2_SERIE = SF2.F2_SERIE "
			cQuery += "   INNER JOIN "+RetSqlName("SC9")+" SC9 "
			cQuery += "      ON SC9.D_E_L_E_T_ <> '*' "
			cQuery += "     AND SC9.C9_FILIAL = '"+xFilial("SC9")+"' "
			cQuery += "     AND SC9.C9_PEDIDO = SD2.D2_PEDIDO "
			cQuery += "     AND SC9.C9_ITEM = SD2.D2_ITEMPV "
			cQuery += "     AND SC9.C9_NFISCAL = SD2.D2_DOC "
			cQuery += "     AND SC9.C9_SERIENF = SD2.D2_SERIE "
			cQuery += "     AND SC9.C9_NUMSEQ = SD2.D2_NUMSEQ "
			//cQuery += "   INNER JOIN "+RetSqlName("CB8")+" CB8 "
			//cQuery += "      ON CB8.D_E_L_E_T_ <> '*' "
			//cQuery += "     AND CB8.CB8_FILIAL = '"+xFilial("CB8")+"' "
			//cQuery += "     AND CB8.CB8_ORDSEP = SC9.C9_ORDSEP "
			//cQuery += "     AND CB8.CB8_ITEM = SC9.C9_ITEM "
			//cQuery += "     AND CB8.CB8_SEQUEN = SC9.C9_SEQUEN "
			cQuery += "    LEFT JOIN "+RetSqlName("SA4")+" SA4 "
			cQuery += "      ON SA4.D_E_L_E_T_ <> '*' "
			cQuery += "     AND SA4.A4_FILIAL = '"+xFilial("SA4")+"' "
			cQuery += "     AND SA4.A4_COD = SF2.F2_TRANSP "
			cQuery += " WHERE SF2.D_E_L_E_T_ <> '*' "
			cQuery += "   AND SF2.F2_FILIAL = '"+xFilial("SF2")+"' "
			cQuery += "   AND SF2.F2_DOC = '"+SF2->F2_DOC+"' "
			cQuery += "   AND SF2.F2_SERIE = '"+SF2->F2_SERIE+"' "
			cQuery += "   AND SF2.F2_LOJA = '"+SF2->F2_LOJA+"' "
			
			TcQuery cQuery New Alias &cNextAlias
			
			if (cNextAlias)->(!EOF())
				oCtrlExp:setcOrdSep((cNextAlias)->C9_ORDSEP)
				oCtrlExp:setcLoja((cNextAlias)->F2_LOJA)
			endIf
			
			(cNextAlias)->(DbCloseArea())
	END
	
	oCtrlExp:setcStatus(cStatus)
	oCtrlExp:excluiStatus()
	
	RestArea(aArea)
Return
