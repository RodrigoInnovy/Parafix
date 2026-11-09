#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'
#Include "topconn.ch"
#Include "RwMake.CH"
#include "tbiconn.ch"

/*/{Protheus.doc} AdiCtrlExp
Adiciona status para Controle de Expedição
@author Evandro Simenes
@since 13/11/2017 
@version 1.0
/*/
User Function AdiCtrlExp(cStatus,cDescSt,cNFSerie,cPedido,cOrdem,cVolume,cCodBar)
	Local aArea := GetArea()
	Local cQuery := ""
	//Local nQtde := 0.00
	//Local nQtSegum := 0.00
	local cNextAlias := GetNextAlias()
	local cNF := ""
	local cSerie := ""
	local aArr := {}
	local lEntrou := .F.
	local cNVol := ""
	local cTVol := ""
	default cNFSerie := "0"
	default cPedido := "0"
	default cOrdem := "0"
	default cVolume := "0"
	default cCodBar := "0"
	Private nStart
	
    FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG AdiCtrlExp: Status: "+cStatus, 0, (nStart - Seconds()), {})
	
	oCtrlExp := ControleDeExpedicao():newControleDeExpedicao()
	
	DO CASE
		CASE cStatus == "1"
			//RETIRADO PARA AGLUTINAR OS ITENS DA OS
			//cQuery := " SELECT CB7_ORDSEP, CB8_PROD, CB8_PEDIDO, CB7_LOJA, CB8_ITEM, CB8_SEQUEN, SUM(CB8_QTDORI) QTD"
			cQuery := " SELECT CB7_ORDSEP, CB8_PROD, CB8_PEDIDO, CB7_LOJA, SUM(CB8_QTDORI) QTD"
			cQuery += "   FROM "+RetSqlName("CB7")+" CB7 "
			cQuery += "  INNER JOIN "+RetSqlName("CB8")+" CB8 " 
			cQuery += "          ON CB8.D_E_L_E_T_ <> '*'  "
			cQuery += "         AND CB8.CB8_FILIAL = '"+xFilial("CB8")+"' "
			cQuery += "         AND CB8.CB8_ORDSEP = CB7.CB7_ORDSEP "
			cQuery += "  WHERE CB7.D_E_L_E_T_ <> '*'  "
			cQuery += "         AND CB7.CB7_FILIAL = '"+xFilial("CB7")+"' "
			cQuery += "         AND CB7.CB7_ORDSEP = '"+CB7->CB7_ORDSEP+"' "
			cQuery += "         AND CB7.CB7_LOJA = '"+CB7->CB7_LOJA+"' "
			//RETIRADO PARA AGLUTINAR OS ITENS DA OS
			//cQuery += "  GROUP BY CB7_ORDSEP, CB8_PROD, CB8_PEDIDO, CB7_LOJA, CB8_ITEM, CB8_SEQUEN "
			cQuery += "  GROUP BY CB7_ORDSEP, CB8_PROD, CB8_PEDIDO, CB7_LOJA  "
			
            FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG AdicCtrlExp: cQuery: "+cQuery, 0, (nStart - Seconds()), {})
			
			TcQuery cQuery New Alias &cNextAlias
			
			while (cNextAlias)->(!EOF())
				oCtrlExp := ControleDeExpedicao():newControleDeExpedicao()
				oCtrlExp:setcOrdSep((cNextAlias)->CB7_ORDSEP)
				//oCtrlExp:setcItem((cNextAlias)->CB8_ITEM) //RETIRADO PARA AGLUTINAR OS ITENS DA OS
				oCtrlExp:setcPedido((cNextAlias)->CB8_PEDIDO)
				oCtrlExp:setcCodPro((cNextAlias)->CB8_PROD)
				oCtrlExp:setcLoja((cNextAlias)->CB7_LOJA)
				//oCtrlExp:setcSequenc((cNextAlias)->CB8_SEQUEN) //RETIRADO PARA AGLUTINAR OS ITENS DA OS
				oCtrlExp:setnQtd1Um((cNextAlias)->QTD)
				oCtrlExp:setcStatus(cStatus)
				oCtrlExp:setcDescSt(cDescSt)
				oCtrlExp:AdicStatus()
				(cNextAlias)->(dbSkip())
			end
			
			(cNextAlias)->(DbCloseArea())
			
			Return
			
		CASE cStatus == "2"
			oCtrlExp:setcOrdSep(CB8->CB8_ORDSEP)
			oCtrlExp:setcItem(CB8->CB8_ITEM)
			oCtrlExp:setcCodPro(CB8->CB8_PROD)
			oCtrlExp:setcLoja(CB7->CB7_LOJA)
			oCtrlExp:setcSequenc(CB8->CB8_SEQUEN)
		
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
			cQuery += "     AND SC9.C9_NFISCAL = SD2.D2_DOC "
			cQuery += "     AND SC9.C9_SERIENF = SD2.D2_SERIE "
			cQuery += "     AND SC9.C9_ITEM = SD2.D2_ITEMPV "
			cQuery += "     AND SC9.C9_NUMSEQ = SD2.D2_NUMSEQ "
			cQuery += "     AND SC9.C9_ORDSEP <> '' "
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
			//cQuery += "   AND SF2.F2_CLIENTE = '"+SF2->F2_CLIENTE+"' "
			
            FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG AdicCtrlExp: cQuery: "+cQuery, 0, (nStart - Seconds()), {})
			
			TcQuery cQuery New Alias &cNextAlias
			
			while (cNextAlias)->(!EOF())
				lEntrou := .T.
				FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG AdicCtrlExp: entrou", 0, (nStart - Seconds()), {})
				oCtrlExp := ControleDeExpedicao():newControleDeExpedicao()
				oCtrlExp:setcOrdSep((cNextAlias)->C9_ORDSEP)
				oCtrlExp:setcLoja((cNextAlias)->F2_LOJA)
				oCtrlExp:setcTransp((cNextAlias)->F2_TRANSP)
				oCtrlExp:setcDescTr((cNextAlias)->A4_NOME)
				oCtrlExp:setcNF((cNextAlias)->F2_DOC)
				oCtrlExp:setcSerie((cNextAlias)->F2_SERIE)
				oCtrlExp:setcStatus(cStatus)
				oCtrlExp:setcDescSt(cDescSt)
				oCtrlExp:AdicStatus()
				(cNextAlias)->(dbSkip())
			end
			
			(cNextAlias)->(DbCloseArea())
			
			If !lEntrou
				FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG AdicCtrlExp: nao entrou", 0, (nStart - Seconds()), {})
				If SelectOS()
					FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG AdicCtrlExp: selecionou ok", 0, (nStart - Seconds()), {})
					U_AdiCtrlExp('3','Aguardando Etiq Volumes')
				Else
					FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG AdicCtrlExp: cancelou selecao os", 0, (nStart - Seconds()), {})
				EndIf
			EndIf
			FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG AdicCtrlExp: retorna", 0, (nStart - Seconds()), {})
			return
		CASE cStatus == "4"
			IF cNFSerie == "0"
			
			ELSE
				aArr := strtokarr(cNFSerie,"/")
				cNF := padr(Alltrim(aArr[1]),TamSX3("F2_DOC")[1]," ")
				cSerie := padr(Alltrim(aArr[2]),TamSX3("F2_SERIE")[1]," ")
				
				aArr := strtokarr(cVolume,"/")
				cNVol := Alltrim(aArr[1])
				cTVol := Alltrim(aArr[2])
				
				cQuery := " SELECT DISTINCT C9_ORDSEP, F2_LOJA " 
				cQuery += "   FROM "+RetSqlName("SF2")+" SF2 "
				cQuery += "   INNER JOIN "+RetSqlName("SD2")+" SD2 "
				cQuery += "      ON SD2.D_E_L_E_T_ <> '*' "
				cQuery += "     AND SD2.D2_FILIAL = '"+xFilial("SD2")+"' "
				cQuery += "     AND SD2.D2_LOJA = SF2.F2_LOJA "
				cQuery += "     AND SD2.D2_DOC = SF2.F2_DOC "
				cQuery += "     AND SD2.D2_SERIE = SF2.F2_SERIE "
				cQuery += "     AND SD2.D2_PEDIDO = '"+cPedido+"'"
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
				cQuery += "   AND SF2.F2_DOC = '"+cNF+"' "
				cQuery += "   AND SF2.F2_SERIE = '"+cSerie+"' "
				//cQuery += "   AND SF2.F2_LOJA = '"+SF2->F2_LOJA+"' "
				
				FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG AdicCtrlExp: cQuery: "+cQuery, 0, (nStart - Seconds()), {})

				
				TcQuery cQuery New Alias &cNextAlias
				
				if (cNextAlias)->(!EOF())
					oCtrlExp:setcOrdSep((cNextAlias)->C9_ORDSEP)
					oCtrlExp:setcLoja((cNextAlias)->F2_LOJA)
					oCtrlExp:setcNVol(cNVol)
					oCtrlExp:setcTVol(cTVol)
					oCtrlExp:setcIdVol(cCodBar)
				endIf
				
				(cNextAlias)->(DbCloseArea())
			ENDIF
		Case cStatus == "5"
			oCtrlExp:setcOrdSep(CB7->CB7_ORDSEP)
			oCtrlExp:setcLoja(CB7->CB7_LOJA)
			oCtrlExp:setcIdVol(cIdVol)
	end 
	 
	oCtrlExp:setcStatus(cStatus)
	oCtrlExp:setcDescSt(cDescSt)
	oCtrlExp:AdicStatus()
	
	RestArea(aArea)
Return

//Funcao que abre tela para usuario selecionar Ordem de Separação no Final do faturamento (M460FIM) para relacionar Ordem de separação na SC9 
Static Function SelectOS()
	Local oDlg
	Local oLst
	Local cOS
	Local aOS := {}
	Local cQuery
	Local cNxtAlias := GetNextAlias()
	Local aArea := GetArea()
	Private nStart
	
	cQuery := "  SELECT DISTINCT CB8_ORDSEP "
   	cQuery += "    FROM "+RetSqlName("CB8")
  	cQuery += "   WHERE D_E_L_E_T_ <> '*'"
    cQuery += "     AND CB8_FILIAL = '"+xFilial("CB8")+"'"
    cQuery += "     AND CB8_PEDIDO IN (SELECT D2_PEDIDO "
    cQuery += "                          FROM "+RetSqlName("SD2")
    cQuery += "                         WHERE D_E_L_E_T_ <> '*'"
    cQuery += "                           AND D2_FILIAL  = '"+xFilial("SD2")+"'"
    cQuery += "                           AND D2_DOC     = '"+SF2->F2_DOC+"'"
    cQuery += "                           AND D2_SERIE   = '"+SF2->F2_SERIE+"'"
    cQuery += "                           AND D2_CLIENTE = '"+SF2->F2_CLIENTE+"'"
    cQuery += "                           AND D2_LOJA    = '"+SF2->F2_LOJA+"')"
    
    FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG SELECTOS QUERY1: "+cQuery, 0, (nStart - Seconds()), {})

    
    /*cQuery := "  SELECT DISTINCT CB8_ORDSEP "
   	cQuery += "    FROM CB8010 "
  	cQuery += "   WHERE D_E_L_E_T_ <> '*'"
    cQuery += "     AND CB8_FILIAL = '01'"
    cQuery += "     AND CB8_PEDIDO IN (SELECT D2_PEDIDO "
    cQuery += "                          FROM SD2010 "
    cQuery += "                         WHERE D2_FILIAL  = '01'"
    cQuery += "                           AND D2_DOC     = '000021328'"
    cQuery += "                           AND D2_SERIE   = '1'"
    cQuery += "                           AND D2_CLIENTE = '000052'"
    cQuery += "                           AND D2_LOJA    = '01')"
    */
    TCQUERY cQuery NEW ALIAS &cNxtAlias
    
    (cNxtAlias)->(DbGoTop())
	
	WHILE (cNxtAlias)->(!EOF())
		aadd(aOS,(cNxtAlias)->CB8_ORDSEP)
		(cNxtAlias)->(DbSkip())
	END
	
	(cNxtAlias)->(DbCloseArea())
	
	Define MsDialog oDlg From 0,0 to 200,500 Pixel Style DS_MODALFRAME Title "Escolha uma Ordem de Separação"
	@ 05,05 Say "Ordens de Separação:" of oDlg Pixel
	@ 15,05 ListBox oLst Var cOS items aOS of oDlg Pixel Size 240,65
	Define sButton From 85,190 of oDlg Type 1 Pixel Enable Action oDlg:End()
	Define sButton From 85,220 of oDlg Type 2 Pixel Enable Action (cOS:="",oDlg:End())
	Activate MsDialog oDlg Centered
	
	If Empty(cOS)
		Return .F.
	Else
		cQuery := " SELECT R_E_C_N_O_ "
		cQuery += "   FROM "+RetSqlName("SC9")
		cQuery += "  WHERE D_E_L_E_T_ <> '*' "
		cQuery += "    AND C9_FILIAL = '"+xFilial("SC9")+"'"
		cQuery += "    AND C9_NFISCAL = '"+SF2->F2_DOC+"'"
		cQuery += "    AND C9_SERIENF = '"+SF2->F2_SERIE+"'"
		cQuery += "    AND C9_CLIENTE = '"+SF2->F2_CLIENTE+"'"
		cQuery += "    AND C9_LOJA = '"+SF2->F2_LOJA+"'"

       FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG SELECTOS QUERY2: "+cQuery, 0, (nStart - Seconds()), {})		
		/*
		cQuery := " SELECT R_E_C_N_O_ "
		cQuery += "   FROM SC9010 "
		cQuery += "  WHERE C9_FILIAL = '01'"
		cQuery += "    AND C9_NFISCAL = '000021328'"
		cQuery += "    AND C9_SERIENF = '1'"
		cQuery += "    AND C9_CLIENTE = '000052'"
		cQuery += "    AND C9_LOJA = '01'"
		*/
		TCQUERY cQuery NEW ALIAS &cNxtAlias
		
		(cNxtAlias)->(DbGoTop())
		
		WHILE (cNxtAlias)->(!EOF())
			DbSelectArea("SC9")
			SC9->(DbGoTo((cNxtAlias)->R_E_C_N_O_))
			RECLOCK("SC9", .F.)
			SC9->C9_ORDSEP := cOS
			MSUNLOCK()
			(cNxtAlias)->(DbSkip())
		END
		
		(cNxtAlias)->(DbCloseArea())
	Endif
	
	RestArea(aArea)
	
Return .T.
