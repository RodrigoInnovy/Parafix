#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'
#Include "topconn.ch"

/*/{Protheus.doc} DelCtrlRec
Exclui status para Controle de Recebimento
@author Evandro Simenes
@since 17/10/2017 
@version 1.0
/*/
User Function DelCtrlRec(cStatus, cFil)
	Local oCtrlRec
	Local aArea := GetArea()
	Local cQuery := ""
	Local nQtde := 0.00
	local cAliasSD7	:= GetNextAlias()
	Local cLocaliz := ""
	Default cFil := cFilAnt
	
	oCtrlRec := ControleDeRecebimento():newControleDeRecebimento()
			
	DO CASE
		CASE cStatus == "1"
			oCtrlRec:setcNF(SF1->F1_DOC)
			oCtrlRec:setcSerie(SF1->F1_SERIE)
			oCtrlRec:setcCodFor(SF1->F1_FORNECE)
			oCtrlRec:setcLoja(SF1->F1_LOJA)
		CASE cStatus == "5"
			oCtrlRec:setcFil(cFil)
			oCtrlRec:setcNF(ZA1->ZA1_NF)
			oCtrlRec:setcSerie(ZA1->ZA1_SERIE)
			oCtrlRec:setcCodFor(ZA1->ZA1_CODFOR)
			oCtrlRec:setcLoja(ZA1->ZA1_LOJA)
		
		CASE cStatus == "2"
			oCtrlRec:setcNF(SF1->F1_DOC)
			oCtrlRec:setcSerie(SF1->F1_SERIE)
			oCtrlRec:setcCodFor(SF1->F1_FORNECE)
			oCtrlRec:setcLoja(SF1->F1_LOJA)
		
		CASE cStatus == "2E"
			oCtrlRec:setcNF(SF1->F1_DOC)
			oCtrlRec:setcSerie(SF1->F1_SERIE)
			oCtrlRec:setcCodFor(SF1->F1_FORNECE)
			oCtrlRec:setcLoja(SF1->F1_LOJA)
			cStatus := "2"
			oCtrlRec:setlEstorno(.T.)
		
		CASE cStatus == "4"
			
			if SD3->D3_CF == "RE4"
				oCtrlRec:setlPorItem(.T.)
				oCtrlRec:setlPorLote(.T.)
				oCtrlRec:setcLote(SD3->D3_LOTECTL)
				oCtrlRec:setcCodPro(SD3->D3_COD)
				oCtrlRec:setnQtd1Um(SD3->D3_QUANT)
				oCtrlRec:setnQtd2Um(SD3->D3_QTSEGUM)
				
				cLocaliz := SuperGetMv("MV_ZZLOCAR",.F.,"AGUARDANDO")
				
				If Alltrim(SD3->D3_LOCALIZ) == cLocaliz
					cStatus := "5"
				Endif
				
				cQuery += "SELECT ZA1_NF, ZA1_SERIE, ZA1_CODFOR, ZA1_LOJA"
				cQuery += "  FROM "+RetSqlName("ZA1")
				cQuery += " WHERE D_E_L_E_T_ <> '*'"
				cQuery += "   AND ZA1_FILIAL = '"+xFilial("ZA1")+"'"
				cQuery += "   AND ZA1_LOTE = '"+SD3->D3_LOTECTL+"'"
				cQuery += "   AND ZA1_STATUS = '"+cStatus+"'"
				
				TcQuery cQuery New Alias &cAliasSD7
				
				if (cAliasSD7)->(!EOF())
					oCtrlRec:setcNF((cAliasSD7)->ZA1_NF)
					oCtrlRec:setcSerie((cAliasSD7)->ZA1_SERIE)
					oCtrlRec:setcCodFor((cAliasSD7)->ZA1_CODFOR)
					oCtrlRec:setcLoja((cAliasSD7)->ZA1_LOJA)
				Else
					//Help( ,, 'Help',, "Não foi possivel localizar o lote "+SD3->D3_LOTECTL+" na ZA1", 1, 0 )
					Return
				endif
				
				(cAliasSD7)->(DbCloseArea()) 
			EndIf
		CASE cStatus == "3E"
			cStatus := "3"
			oCtrlRec:setcNF(SF1->F1_DOC)
			oCtrlRec:setcSerie(SF1->F1_SERIE)
			oCtrlRec:setcCodFor(SF1->F1_FORNECE)
			oCtrlRec:setcLoja(SF1->F1_LOJA)
			oCtrlRec:setlEstorno(.T.)
			
		CASE cStatus == "3"
			cQuery += "SELECT SUM(D7_QTDE) D7_QTDE"
			cQuery += "  FROM "+RetSqlName("SD7")
			cQuery += " WHERE D7_FILIAL = '"+xFilial("SD7")+"'"
			cQuery += "   AND D_E_L_E_T_ <> '*'"
			cQuery += "   AND D7_PRODUTO = '"+SD7->D7_PRODUTO+"'"
			cQuery += "   AND D7_TIPO = 6"
			cQuery += "   AND D7_NUMERO = '"+SD7->D7_NUMERO+"'"
			cQuery += "   AND D7_DATA = '"+DTOS(SD7->D7_DATA)+"'"
			cQuery += "   AND D7_SEQ IN (SELECT MAX(D7_SEQ)"
			cQuery += "                        FROM "+RetSqlName("SD7")
			cQuery += "                       WHERE D7_FILIAL = '"+xFilial("SD7")+"'"
			cQuery += "                         AND D_E_L_E_T_ <> '*'"
			cQuery += "                         AND D7_PRODUTO = '"+SD7->D7_PRODUTO+"'"
			cQuery += "                         AND D7_NUMERO = '"+SD7->D7_NUMERO+"'"
			cQuery += "                         AND D7_DATA = '"+DTOS(SD7->D7_DATA)+"')"
			TcQuery cQuery New Alias &cAliasSD7
	
			if (cAliasSD7)->(!EOF())
				nQtde := (cAliasSD7)->D7_QTDE
			endif
			
			(cAliasSD7)->(DbCloseArea()) 
			
			if nQtde == 0
				return
			endif
			
			oCtrlRec:setlPorLote(.T.)
			oCtrlRec:setcLote(SD7->D7_LOTECTL)
			oCtrlRec:setcNF(SD7->D7_DOC)
			oCtrlRec:setcSerie(SD7->D7_SERIE)
			oCtrlRec:setcCodFor(SD7->D7_FORNECE)
			oCtrlRec:setcLoja(SD7->D7_LOJA)
			oCtrlRec:setlPorItem(.T.)
			oCtrlRec:setcCodPro(SD1->D1_COD)
			oCtrlRec:setcNumCQ(SD7->D7_NUMERO)
			oCtrlRec:setcItemNF(SD1->D1_ITEM)
	END
	
	oCtrlRec:setcStatus(cStatus)
	oCtrlRec:excluiStatus()
	
	RestArea(aArea)
Return