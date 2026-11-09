#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#INCLUDE 'FWMVCDEF.CH'
#Include "prtopdef.ch"

#DEFINE cEOL CHR(13) + CHR(10)

/*/{Protheus.doc} MATA311
@author Evandro Simenes
@since 23/11/2017 
@version 1.0
/*/
User Function MATA311() 
	Local aParam  := PARAMIXB
	Local lRet    := .T.
	Local cIdPonto := ''
	Local cIdModel  := ''
	Local oModelGrid
	Local cFilDest := ""
	Local cCodPro := ''
	Local cLote := ""
	Local cQuery := ""
	Local cNxtAlias := GetNextAlias()
	Local oCtrlRec
	Local cAliasSD7 := GetNextAlias()
	local nStart
	
    FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG MATA311PE", 0, (nStart - Seconds()), {})
	
	If (aParam <> Nil)
	   oObj       := aParam[1]
	   cIdPonto   := aParam[2]
	   cIdModel   := aParam[3]
	   
	   FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG MATA311PE: idponto "+cIdPonto, 0, (nStart - Seconds()), {})
	   
	   if cIdPonto == 'MODELCOMMITNTTS' .and. oObj:GetOperation() == MODEL_OPERATION_DELETE
	   	  FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG MATA311PE: ENTROU DELETE ", 0, (nStart - Seconds()), {})
	   	  oModelGrid := oObj:GetModel("NNTDETAIL")
	      cFilDest := oModelGrid:GetValue("NNT_FILDES")
	      cLote := oModelGrid:GetValue("NNT_LOTECT")
	      DbSelectArea("ZA1")
	      ZA1->(DbSetOrder(1))
	      if ZA1->(DbSeek(cFilDest+cLote))
	    	U_DelCtrlRec('5', cFilDest)
	      EndIf
	   EndIf
	   
	   if cIdPonto == 'MODELCOMMITNTTS' .and. oObj:GetOperation() == MODEL_OPERATION_UPDATE
          FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG MATA311PE: ENTROU UPDATE ", 0, (nStart - Seconds()), {})
	   	   oModelGrid := oObj:GetModel("NNTDETAIL")
	       cCod := oModelGrid:GetValue("NNT_COD")
	       cFilDest := oModelGrid:GetValue("NNT_FILDES")
	       cProd := oModelGrid:GetValue("NNT_PROD")
	       cDoc := oModelGrid:GetValue("NNT_DOC")
	       cSerie := oModelGrid:GetValue("NNT_SERIE")
	       //nNum := oModelGrid:GetValue("NNT_FILDES")
	       cLote := oModelGrid:GetValue("NNT_LOTECT")
	   	   oCtrlRec := ControleDeRecebimento():newControleDeRecebimento()
	   	   
	   	   FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG MATA311PE: cFilDest "+cFilDest, 0, (nStart - Seconds()), {})
	   	   
	   	   If cFilDest == "01" .and. IsInCallStack('A311Efetiv')
	   	   	    FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG MATA311PE: ENTROU IF ", 0, (nStart - Seconds()), {})
	   	   	    cFilBkp := cFilAnt
	   	   	    cFilAnt := cFilDest
	   	      	cQuery := " SELECT DA_PRODUTO, DA_LOTECTL, DA_NUMSEQ, NNT_LOCALI, SUM(DA_SALDO) DA_SALDO, SUM(DA_QTSEGUM) DA_QTSEGUM" 
				cQuery += "	  FROM "+RetSqlName("SDA")+" SDA, "+RetSqlName("NNT")+" NNT"
				cQuery += "	 WHERE DA_FILIAL = '"+cFilDest+"'"
				cQuery += "	   AND SDA.D_E_L_E_T_ <> '*'"
				cQuery += "	   AND NNT.D_E_L_E_T_ <> '*'"
				cQuery += "	   AND NNT_PRODD = DA_PRODUTO"
				cQuery += "	   AND NNT_LOTED = DA_LOTECTL"
				cQuery += "	   AND NNT_FILDES = DA_FILIAL"
				cQuery += "	   AND NNT_DOC = DA_DOC"
				cQuery += "	   AND NNT_SERIE = DA_SERIE"
				cQuery += "	   AND DA_DOC = '"+cDoc+"'"
				cQuery += "	   AND DA_SERIE = '"+cSerie+"'"
				cQuery += "	 GROUP BY DA_PRODUTO, DA_LOTECTL, DA_NUMSEQ, NNT_LOCALI"
				
				FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG MATA311: query "+cQuery, 0, (nStart - Seconds()), {})
				
				TcQuery cQuery New Alias &cAliasSD7
		
				while (cAliasSD7)->(!EOF())
                    FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG MATA311: ENTROU WHILE ", 0, (nStart - Seconds()), {})
					if !EnderItem((cAliasSD7)->DA_PRODUTO,(cAliasSD7)->DA_NUMSEQ,(cAliasSD7)->DA_SALDO,(cAliasSD7)->NNT_LOCALI)
						MsgAlert("Falha ao endereçar o produto transferido "+(cAliasSD7)->DA_PRODUTO+" do lote "+cLote)
						FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG MATA311: NAO ENDERECOU ", 0, (nStart - Seconds()), {})
					ELSE
						FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG MATA311: ENDEREÇOU COM SUCESSO ", 0, (nStart - Seconds()), {})
					endif
					(cAliasSD7)->(DbSkip())
				end
				
				(cAliasSD7)->(DbCloseArea())
                FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG MATA311: FIM ", 0, (nStart - Seconds()), {})
				cFilAnt := cFilBkp
				Return .T.
	   	   EndIf
	   	   
	   	   DbSelectArea("ZA1")
	       ZA1->(DbSetOrder(1))
	       if ZA1->(DbSeek(cFilDest+cLote)) .and. IsInCallStack('A311Efetiv') .and. cFilDest == "02"
	       	  FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG MATA311PE: ENTROU IF 2", 0, (nStart - Seconds()), {})
	       	  //RODA ENDERECAMENTO NA FILIAL DESTINO APOS TRANSFERENCIA
	       	  cQuery := " SELECT DISTINCT SD1.D1_LOTECTL, SF1.F1_FORNECE, SF1.F1_LOJA, SD1.D1_COD, SF1.F1_DOC, SF1.F1_SERIE "
	       	  cQuery += "   FROM "+RetSqlName("SF1")+" SF1, "+RetSqlName("SD1")+" SD1 "
	       	  cQuery += "  WHERE SF1.D_E_L_E_T_ <> '*'"
	       	  cQuery += "    AND SD1.D_E_L_E_T_ <> '*'"
	       	  cQuery += "    AND SF1.F1_FILIAL = '"+cFilDest+"'"
	       	  cQuery += "    AND SD1.D1_FILIAL = '"+cFilDest+"'"
	       	  cQuery += "    AND SF1.F1_DOC = '"+oModelGrid:GetValue("NNT_DOC")+"'"
	       	  cQuery += "    AND SF1.F1_SERIE = '"+oModelGrid:GetValue("NNT_SERIE")+"'"
	       	  cQuery += "    AND SD1.D1_DOC = SF1.F1_DOC"
	       	  cQuery += "    AND SD1.D1_SERIE = SF1.F1_SERIE"
	       	  cQuery += "    AND SD1.D1_FORNECE = SF1.F1_FORNECE"
	       	  cQuery += "    AND SD1.D1_LOJA = SF1.F1_LOJA"
	       	  
              FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG MATA311: query2 "+cQuery, 0, (nStart - Seconds()), {})
	       	  
	       	  
	       	  TCQUERY cQuery NEW ALIAS &cNxtAlias
	       	  
	       	  (cNxtAlias)->(DbGoTop())
	       	  
	       	  While (cNxtAlias)->(!EOF())
	       	  	 FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG MATA311: ENTROU WHILE2 ", 0, (nStart - Seconds()), {})
	       	  	 
	       	  	 oCtrlRec:setcFil(cFilDest)
		       	 oCtrlRec:setcLote((cNxtAlias)->D1_LOTECTL)
		       	 oCtrlRec:setcCodPro((cNxtAlias)->D1_COD)
		       	 oCtrlRec:setcNF((cNxtAlias)->F1_DOC)
		       	 oCtrlRec:setcSerie((cNxtAlias)->F1_SERIE)
	       	  	 oCtrlRec:setcCodFor((cNxtAlias)->F1_FORNECE)
	       	     oCtrlRec:setcLoja((cNxtAlias)->F1_LOJA)
	       	     
	       	     If !oCtrlRec:EnderItem(.T.)
	    	  	  	Alert("Falha ao endereçar lote "+(cNxtAlias)->D1_LOTECTL+" transferidos na filial "+cFilDest)
	    	  	  	FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG MATA311: NAO ENDERECOU ", 0, (nStart - Seconds()), {})
	    	  	  	
	    	  	 ELSE
	    	  	 	FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG MATA311: ENDERECOU COM SUCESSO ", 0, (nStart - Seconds()), {})
	    	  	 EndIf
	    	  	 
	    	  	 (cNxtAlias)->(dbSkip())
	    	  	 
	       	  End
	       	  
	       	  (cNxtAlias)->(DbCloseArea())
	       	  
	       EndIf
	   EndIf
	   
	EndIf
	FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG MATA311PE: FIM ", 0, (nStart - Seconds()), {})
return lRet

Static Function EnderItem(cProd,nSeq, nQtde, cEnd)
	Local aCabSDA    := {} 
	Local aItSDB     := {} 
	Local aItensSDB := {} 
	Private	lMsErroAuto := .F.
	
	Aadd( aCabSDA, { 'DA_PRODUTO'	, cProd		, Nil } )
	Aadd( aCabSDA, { 'DA_NUMSEQ'  	, nSeq		, Nil } )
	
	//Dados do item que será endereçado
	aItSDB := {{"DB_ITEM"	  ,"0001"	  ,Nil},;                   
	           {"DB_ESTORNO"  ," "	      ,Nil},;                   
	           {"DB_LOCALIZ"  ,cEnd ,Nil},;                   
	           {"DB_DATA"	  ,dDataBase  ,Nil},;                   
	           {"DB_QUANT"  ,nQtde        ,Nil}}       
	
	aadd(aItensSDB,aItSDB)
	
	//Executa o endereçamento do item
	MATA265( aCabSDA, aItensSDB, 3)
	If lMsErroAuto    
		MostraErro()
		Return .F.
	Endif
Return .T.
