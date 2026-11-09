#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#INCLUDE "apvt100.ch"
#DEFINE cEOL CHR(13) + CHR(10)

/*	
	Programa	:	AtuQtdSep
	Autor		:	Evandro Simenes
	Data		:	23/11/2017
	Descricao	:	Rotina para atualizar quantidade separada na separação do ACDV166
*/

User Function AtuQtdSep(lEstorno)
	Local cQuery := ""
	Local cNxtAlias := GetNextAlias()
	Local cNxtAlias2 := GetNextAlias()
	Local aArea := GetArea()
	Local nQtde := 0
	Local nQtdeZ := 0
	Local nStart
	
	
	cQuery := " SELECT CB7_ORDSEP, CB9_PROD, CB7_LOJA, SUM(CB9_QTESEP) QTD "
	cQuery += "   FROM "+RetSqlName("CB7")+" CB7  "
	cQuery += "		  INNER JOIN "+RetSqlName("CB9")+" CB9 "  
	cQuery += "		          ON CB9.D_E_L_E_T_ <> '*' "  
	cQuery += "		         AND CB9.CB9_FILIAL = '"+xFilial("CB9")+"'  "
	cQuery += "		         AND CB9.CB9_ORDSEP = CB7.CB7_ORDSEP "
	cQuery += "		         AND CB9.CB9_PROD = '"+CB9->CB9_PROD+"' "  
	cQuery += "		  WHERE CB7.D_E_L_E_T_ <> '*'   "
	cQuery += "		         AND CB7.CB7_FILIAL = '"+xFilial("CB7")+"' " 
	cQuery += "		         AND CB7.CB7_ORDSEP = '"+CB9->CB9_ORDSEP+"' " 
	cQuery += "		  GROUP BY CB7_ORDSEP, CB9_PROD, CB7_LOJA "
	
	TcQuery cQuery NEW ALIAS &cNxtAlias
	
    FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG SQL1: "+cQuery, 0, (nStart - Seconds()), {})
	
	(cNxtAlias)->(DBGotop()) 
	
	While (cNxtAlias)->(!Eof())
		cQuery := " SELECT (R_E_C_N_O_) recno"
		cQuery += "   FROM "+RetSqlName("ZA2")
		cQuery += "	 WHERE D_E_L_E_T_ <> '*'   "
		cQuery += "	   AND ZA2_FILIAL = '"+xFilial("ZA2")+"' " 
		cQuery += "	   AND ZA2_ORDSEP = '"+(cNxtAlias)->CB7_ORDSEP+"' " 
		cQuery += "	   AND ZA2_LOJA = '"+(cNxtAlias)->CB7_LOJA+"'  "
		cQuery += "	   AND ZA2_CODPRO = '"+(cNxtAlias)->CB9_PROD+"'  "
		
       FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG SQL2: "+cQuery, 0, (nStart - Seconds()), {})
	
		IF !lEstorno
			nQtde := (cNxtAlias)->QTD
		ELSE
			nQtde := (cNxtAlias)->QTD - CB9->CB9_QTESEP
		END IF
		
		TcQuery cQuery NEW ALIAS &cNxtAlias2
		
		(cNxtAlias2)->(DBGotop()) 
		
		While (cNxtAlias2)->(!Eof())
			FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG SIMX: ENTROU IF1 QTD "+str(nQtde), 0, (nStart - Seconds()), {})
			FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG SIMX: ENTROU IF12 QTD "+str((cNxtAlias)->QTD), 0, (nStart - Seconds()), {})
			DbSelectArea("ZA2")
			ZA2->(DBGoTo((cNxtAlias2)->recno))
			nQtdeZ := ZA2->ZA2_QTD1UM
			RECLOCK("ZA2", .F.)
			FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG SIMX: ENTROU IF11 QTD "+str((cNxtAlias2)->recno), 0, (nStart - Seconds()), {})
			ZA2->ZA2_QTDSEP := nQtde
			MsUnlock()
			(cNxtAlias2)->(dbSkip())
		End
		
		(cNxtAlias2)->(DBCloseArea())
		(cNxtAlias)->(dbSkip())
	End
	
	FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG SIMX: QTD "+str(nQtde), 0, (nStart - Seconds()), {})
	
	IF lEstorno
  		FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG SIMX: Estorna ", 0, (nStart - Seconds()), {})
		U_DelCtrlExp('2')
	ELSE
		FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG SIMX: Normal ", 0, (nStart - Seconds()), {})
		IF nQtde >= nQtdeZ
			FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG SIMX: Qtde = QtdeZ ", 0, (nStart - Seconds()), {})
			U_AdiCtrlExp('2','Aguardando Nota Fiscal')
		ENDIF
  	ENDIF
	
	(cNxtAlias)->(DBCloseArea())
	
	RestArea(aArea)
Return
