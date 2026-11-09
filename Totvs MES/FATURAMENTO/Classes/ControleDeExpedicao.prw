#include 'protheus.ch'
#Include "topconn.ch"

/*/{Protheus.doc} ControleDeExpedicao
Classe responsável pela criação de funções uteis para manipulação dos status da personalização de
controle de expedição
@author Evandro Simenes
@since 13/11/2017
@version 1.0
/*/
class ControleDeExpedicao 
	
	data cAlias 		as String
	data cChaveStatus	as String //nota+serie+fornecedor+loja+lote+produto
	data cOrdSep        as String
	data cNF            as String
	data cSerie         as String
	data cLoja          as String
	data cTransp        as String
	data cDescTr        as String
	data cCodCli        as String
	data cNomCli        as String
	data cUF            as String
	data cCodPro        as String
	data cDescPR        as String
	data nQtd1Um        as Float
	data cUM            as String
	data nQtd2Um        as Float
	data c2UM           as String
	data nQtdSep        as Float
	data dDtMov         as Date
	data cHrMov         as String
	data dDtFim         as Date
	data cHrFim         as String
	data cStatus        as String
	data cDescSt        as String
	data cItem          as String
	data cSequen        as String
	data lEstorno       as Boolean
	data cPedido        as String
	data cNVol          as string
	data cTVol          as string
	data cIdVol         as string
	
	method newControleDeExpedicao() constructor
	method incluiStatus()
	method excluiStatus()
	method AtualizaDataFim()
	method AdicStatus()
	method getAddQuery()   
	
	//setters
	method setcChaveStatus()	 
	method setcOrdSep()        
	method setcNF()            
	method setcSerie()         
	method setcLoja()          
	method setcTransp()        
	method setcDescTR()        
	method setcCodCli()        
	method setcNomCli()        
	method setcUF()            
	method setcCodPro()        
	method setcDescPr()        
	method setnQtd1Um()        
	method setcUM()            
	method setnQtd2Um()        
	method setc2UM()           
	method setnQtdSep()        
	method setdDtMov()         
	method setcHrMov()         
	method setdDtFim()         
	method setcHrFim()         
	method setcStatus()        
	method setcDescSt()
	method setcItem()   
	method setlEstorno()
	method setcSequen()  
	method setcPedido()
	method setcNVol()
	method setcTVol()
	method setcIdVol()
endclass

/*/{Protheus.doc} new
Metodo construtor
@author Evandro Simenes
@since 13/11/2017
@version 1.0
/*/
method newControleDeExpedicao() class ControleDeExpedicao
	::cAlias := "ZA2"
	::lEstorno := .F.
return

/*/{Protheus.doc} AdicStatus
@author Evandro Simenes
@since 13/11/2017 
@version 1.0
/*/
method AdicStatus() class ControleDeExpedicao
	Local nStatus := val(::cStatus)
	Local cStatus := ""
	local cNextAlias	:= GetNextAlias()
	Local cQuery := ""
	Private nStart
	
	cQuery := ::getAddQuery()
	
	FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG ControleDeExpedicao: Query adicstatus: "+cQuery, 0, (nStart - Seconds()), {})

	TCQUERY cQuery NEW ALIAS &cNextAlias
	
	(cNextAlias)->(DBGotop()) 
	
	While (cNextAlias)->(!Eof())
		
		oCtrlExp := ControleDeExpedicao():newControleDeExpedicao()
		oCtrlExp:setcOrdSep((cNextAlias)->ORDSEP)        
		oCtrlExp:setcNF((cNextAlias)->NF)            
		oCtrlExp:setcSerie((cNextAlias)->SERIE)         
		oCtrlExp:setcLoja((cNextAlias)->LOJA)          
		oCtrlExp:setcTransp((cNextAlias)->TRANSP)        
		oCtrlExp:setcDescTR((cNextAlias)->DESCTR)        
		oCtrlExp:setcCodCli((cNextAlias)->CODCLI)        
		oCtrlExp:setcNomCli((cNextAlias)->NOMCLI)        
		oCtrlExp:setcUF((cNextAlias)->UF)            
		oCtrlExp:setcCodPro((cNextAlias)->CODPRO)        
		oCtrlExp:setcDescPr((cNextAlias)->DESCPR)        
		oCtrlExp:setnQtd1Um((cNextAlias)->QTD1UM)        
		oCtrlExp:setcUM((cNextAlias)->UM)            
		oCtrlExp:setnQtd2Um(ConvUm((cNextAlias)->CODPRO, (cNextAlias)->QTD1UM, 0, 2))        
		oCtrlExp:setc2UM((cNextAlias)->UM2)           
		oCtrlExp:setnQtdSep((cNextAlias)->QTDSEP)        
		oCtrlExp:setdDtMov(Date())         
		oCtrlExp:setcHrMov(Substr(Time(),1,5))         
		oCtrlExp:setcStatus(::cStatus)        
		oCtrlExp:setcDescSt(::cDescST)
		oCtrlExp:setcItem((cNextAlias)->ITEM)
		oCtrlExp:setcPedido((cNextAlias)->PEDIDO)
		oCtrlExp:setcSequen((cNextAlias)->SEQUEN)
		oCtrlExp:setcNVol((cNextAlias)->NVOL)
		oCtrlExp:setcTVol((cNextAlias)->TVOL)
		oCtrlExp:setcIdVol((cNextAlias)->IDVOL)
		
		If ::cStatus == "5"
			oCtrlExp:setdDtFim(Date())
			oCtrlExp:setcHrFim(Substr(Time(),1,5))
		EndIf
		
		oCtrlExp:incluiStatus()
		
		(cNextAlias)->(dbSkip())
	End
	
	(cNextAlias)->(DBCloseArea())
	
	//Atualiza data fim do status anterior
	if nStatus > 1
		cStatus := alltrim(str(nStatus -1))
		oCtrlExp := ControleDeExpedicao():newControleDeExpedicao()
		oCtrlExp:setcOrdSep(::cOrdSep)
		oCtrlExp:setcLoja(::cLoja)
		oCtrlExp:setcStatus(cStatus)
		oCtrlExp:setcCodPro(::cCodPro)
		oCtrlExp:setcIdVol(::cIdVol)
		//oCtrlExp:setcItem(::cItem)
		//oCtrlExp:setcSequen(::cSequen)
		oCtrlExp:setdDtFim(Date())
		oCtrlExp:setcHrFim(Substr(Time(),1,5))
		oCtrlExp:AtualizaDataFim()
	endif
	
return

/*/{Protheus.doc} incluiStatus
Inclui status do controle de recebimento
@author Evandro Simenes
@since 13/11/2017 
@version 1.0
/*/
method incluiStatus() class ControleDeExpedicao
	Local aArea := GetArea()
	
	dbselectarea(::cAlias)
	RECLOCK(::cAlias, .T.)
	ZA2->ZA2_FILIAL  := xFilial(::cAlias)
	ZA2->ZA2_ORDSEP  := ::cOrdSep
	ZA2->ZA2_LOJA    := ::cLoja
	ZA2->ZA2_NF      := ::cNF
	ZA2->ZA2_SERIE   := ::cSerie
	ZA2->ZA2_TRANSP  := ::cTransp
	ZA2->ZA2_DESCTR  := ::cDescTr
	ZA2->ZA2_CODCLI  := ::cCodCli
	ZA2->ZA2_NOMCLI  := ::cNomCli
	ZA2->ZA2_UF      := ::cUF
	ZA2->ZA2_ITEM    := ::cItem
	ZA2->ZA2_SEQUEN  := ::cSequen
	ZA2->ZA2_CODPRO  := ::cCodPro
	ZA2->ZA2_DESCPR  := ::cDescPr
	ZA2->ZA2_QTD1UM  := ::nQtd1Um
	ZA2->ZA2_UM      := ::cUM
	ZA2->ZA2_QTD2UM  := ::nQtd2Um
	ZA2->ZA2_2UM     := ::c2UM
	ZA2->ZA2_QTDSEP  := ::nQtdSep
	ZA2->ZA2_DTMOV   := ::dDtMov
	ZA2->ZA2_HRMOV   := ::cHrMov
	ZA2->ZA2_DTFIM   := ::dDtFim
	ZA2->ZA2_HRFIM   := ::cHrFim
	ZA2->ZA2_STATUS  := ::cStatus
	ZA2->ZA2_DESCST  := ::cDescSt
	ZA2->ZA2_PEDIDO  := ::cPedido
	ZA2->ZA2_NVOL  	 := ::cNVol
	ZA2->ZA2_TVOL  	 := ::cTVol
	ZA2->ZA2_IDVOL   := ::cIdVol
	MSUNLOCK()
	
	RestArea(aArea)
return

/*/{Protheus.doc} excluiStatus
Exclui status do controle de recebimento
@author Evandro Simenes
@since 13/11/2017 
@version 1.0
/*/
method excluiStatus() class ControleDeExpedicao
	Local aArea := GetArea()
	Local oCtrlExp
	Local cQuery := ""
	Local nStatus := val(::cStatus)
	Local cStatus := ::cStatus
	local cAliasZA2	:= GetNextAlias()
	
	cQuery := "SELECT ZA2_STATUS, R_E_C_N_O_"
	cQuery += "  FROM "+RetSqlName("ZA2")
	cQuery += " WHERE ZA2_FILIAL = '"+xFilial("ZA2")+"'"
	cQuery += "   AND D_E_L_E_T_ <> '*'"
	cQuery += "   AND ZA2_ORDSEP = '"+::cOrdSep+"'"
	cQuery += "   AND ZA2_LOJA = '"+::cLoja+"'"
	cQuery += "   AND ZA2_STATUS >= '"+::cStatus+"'"
	
	IF ::cStatus == "2"
		cQuery += " AND ZA2_CODPRO = '"+::cCodPro+"'"
		//cQuery += " AND ZA2_ITEM = '"+::cItem+"'"
		//cQuery += " AND ZA2_SEQUEN = '"+::cSequen+"'"
	EndIf
	
	IF ::cStatus == "5"
		cQuery += " AND ZA2_IDVOL = '"+::cIdVol+"'"
	EndIf
	
    FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG ExcluiStatus: cQuery: "+cQuery, 0, (nStart - Seconds()), {})
	
	TCQUERY cQuery NEW ALIAS &cAliasZA2
	
	(cAliasZA2)->(DBGotop()) 
	
	While (cAliasZA2)->(!Eof())
	    
		DbSelectArea("ZA2")
        FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG SIM RECNO: "+str((cAliasZA2)->R_E_C_N_O_), 0, (nStart - Seconds()), {})
		DbGoTo((cAliasZA2)->R_E_C_N_O_)
		RECLOCK("ZA2", .F.)
		dbdelete()
		MsUnlock()
		WriteSx2("ZA2")
		
		If nStatus > 1
			cStatus := alltrim(str(nStatus-1))
			oCtrlExp := ControleDeExpedicao():newControleDeExpedicao()
			oCtrlExp:setcOrdSep(::cOrdSep)
			oCtrlExp:setcLoja(::cLoja)
			oCtrlExp:setcStatus(cStatus)
			oCtrlExp:setcCodPro(::cCodPro)
			oCtrlExp:setcIdVol(::cIdVol)
			//oCtrlExp:setcItem(::cItem)
			//oCtrlExp:setcSequenc(::cSequen)
			oCtrlExp:setdDtFim(ctod(""))
			oCtrlExp:setcHrFim("")
			oCtrlExp:AtualizaDataFim()
		endif
		(cAliasZA2)->(dbSkip())
	End
	
	(cAliasZA2)->(DBCloseArea()) 
	
	RestArea(aArea)
return

/*/{Protheus.doc} AtualizaDataFim
Insere data fim de status
@author Evandro Simenes
@since 13/11/2017 
@version 1.0
/*/
method AtualizaDataFim() class ControleDeExpedicao
	Local aArea := GetArea()
	local cAliasZA2	:= GetNextAlias()
	Local cQuery := ""
	
	cQuery := "SELECT ZA2_DTFIM, ZA2_HRFIM, R_E_C_N_O_"
	cQuery += "  FROM "+RetSqlName("ZA2")
	cQuery += " WHERE ZA2_FILIAL = '"+xFilial("ZA2")+"'"
	cQuery += "   AND D_E_L_E_T_ <> '*'"
	cQuery += "   AND ZA2_ORDSEP = '"+::cOrdSep+"'"
	cQuery += "   AND ZA2_LOJA = '"+::cLoja+"'"
	//cQuery += "   AND ZA2_CODPRO = '"+::cCodPro+"'"
	//cQuery += "   AND ZA2_ITEM = '"+::cItem+"'"
	cQuery += "   AND ZA2_STATUS = '"+::cStatus+"'"
	
	If ::cStatus == "4"
		cQuery += "   AND ZA2_IDVOL = '"+::cIdVol+"'"
	EndIf
	
	If ::cStatus == "1"
		cQuery += "   AND ZA2_CODPRO = '"+::cCodPro+"'"
		//cQuery += "   AND ZA2_ITEM = '"+::cItem+"'"
		//cQuery += "   AND ZA2_SEQUEN = '"+::cSequen+"'"
	EndIf
	
    FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG AtualizaDataFim: "+cQuery, 0, (nStart - Seconds()), {})
	
	TCQUERY cQuery NEW ALIAS &cAliasZA2
	
	(cAliasZA2)->(DBGotop()) 
	
	While (cAliasZA2)->(!Eof())
		
		DbSelectArea("ZA2")
        FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG AtualizaDataFim RECNO: "+str((cAliasZA2)->R_E_C_N_O_), 0, (nStart - Seconds()), {})
		DbGoTo((cAliasZA2)->R_E_C_N_O_)
		RECLOCK("ZA2", .F.)
		ZA2->ZA2_HRFIM 	:= ::cHrFim
		ZA2->ZA2_DTFIM 	:= ::dDtFim
		
		MSUNLOCK()
		(cAliasZA2)->(dbSkip())

	end
	(cAliasZA2)->(DBCloseArea())
	
	RestArea(aArea)
return

/*/{Protheus.doc} setcOrdSep
@author Evandro Simenes
@since 13/11/2017 
@version 1.0
/*/
method setcOrdSep(cOrdSep) class ControleDeExpedicao
	::cOrdSep := cOrdSep
return

/*/{Protheus.doc} setcNF
@author Evandro Simenes
@since 13/11/2017 
@version 1.0
/*/
method setcNF(cNF) class ControleDeExpedicao
	::cNF := cNF
return

/*/{Protheus.doc} setcSerie
@author Evandro Simenes
@since 13/11/2017 
@version 1.0
/*/
method setcSerie(cSerie) class ControleDeExpedicao
	::cSerie := cSerie
return

/*/{Protheus.doc} setcLoja
@author Evandro Simenes
@since 13/11/2017 
@version 1.0
/*/
method setcLoja(cLoja) class ControleDeExpedicao
	::cLoja := cLoja
return

/*/{Protheus.doc} setcTransp
@author Evandro Simenes
@since 13/11/2017 
@version 1.0
/*/
method setcTransp(cTransp) class ControleDeExpedicao
	::cTransp := cTransp
return

/*/{Protheus.doc} setcDescTr
@author Evandro Simenes
@since 13/11/2017 
@version 1.0
/*/
method setcDescTr(cDescTr) class ControleDeExpedicao
	::cDescTr := cDescTr
return

/*/{Protheus.doc} setcCodCli
@author Evandro Simenes
@since 13/11/2017 
@version 1.0
/*/
method setcCodCli(cCodCli) class ControleDeExpedicao
	::cCodCli := cCodCli
return

/*/{Protheus.doc} setcNomCli
@author Evandro Simenes
@since 13/11/2017 
@version 1.0
/*/
method setcNomCli(cNomCli) class ControleDeExpedicao
	::cNomCli := cNomCli
return

/*/{Protheus.doc} setcUF
@author Evandro Simenes
@since 13/11/2017 
@version 1.0
/*/
method setcUF(cUF) class ControleDeExpedicao
	::cUF := cUF
return

/*/{Protheus.doc} setcCodPro
@author Evandro Simenes
@since 13/11/2017 
@version 1.0
/*/
method setcCodPro(cCodPro) class ControleDeExpedicao
	::cCodPro := cCodPro
return

/*/{Protheus.doc} setcDescPr
@author Evandro Simenes
@since 13/11/2017 
@version 1.0
/*/
method setcDescPr(cDescPr) class ControleDeExpedicao
	::cDescPr := cDescPr
return

/*/{Protheus.doc} setnQtd1Um
@author Evandro Simenes
@since 13/11/2017 
@version 1.0
/*/
method setnQtd1Um(nQtd1Um) class ControleDeExpedicao
	::nQtd1Um := nQtd1Um
return

/*/{Protheus.doc} setcUM
@author Evandro Simenes
@since 13/11/2017 
@version 1.0
/*/
method setcUM(cUM) class ControleDeExpedicao
	::cUM := cUM
return

/*/{Protheus.doc} setnQtd2Um
@author Evandro Simenes
@since 13/11/2017 
@version 1.0
/*/
method setnQtd2Um(nQtd2Um) class ControleDeExpedicao
	::nQtd2Um := nQtd2Um
return

/*/{Protheus.doc} setc2UM
@author Evandro Simenes
@since 13/11/2017 
@version 1.0
/*/
method setc2UM(c2UM) class ControleDeExpedicao
	::c2UM := c2UM
return

/*/{Protheus.doc} setnQtdSep
@author Evandro Simenes
@since 13/11/2017 
@version 1.0
/*/
method setnQtdSep(nQtdSep) class ControleDeExpedicao
	::nQtdSep := nQtdSep
return


/*/{Protheus.doc} setdDtMov
@author Evandro Simenes
@since 13/11/2017 
@version 1.0
/*/
method setdDtMov(dDtMov) class ControleDeExpedicao
	::dDtMov := dDtMov
return

/*/{Protheus.doc} setcHrMov
@author Evandro Simenes
@since 13/11/2017 
@version 1.0
/*/
method setcHrMov(cHrMov) class ControleDeExpedicao
	::cHrMov := cHrMov
return

/*/{Protheus.doc} setdDtFim
@author Evandro Simenes
@since 13/11/2017 
@version 1.0
/*/
method setdDtFim(dDtFim) class ControleDeExpedicao
	::dDtFim := dDtFim
return

/*/{Protheus.doc} setcHrFim
@author Evandro Simenes
@since 13/11/2017 
@version 1.0
/*/
method setcHrFim(cHrFim) class ControleDeExpedicao
	::cHrFim := cHrFim
return

/*/{Protheus.doc} setcDescSt
@author Evandro Simenes
@since 13/11/2017 
@version 1.0
/*/
method setcDescSt(cDescSt) class ControleDeExpedicao
	::cDescSt := cDescSt
return

/*/{Protheus.doc} setcStatus
@author Evandro Simenes 
@since 13/11/2017 
@version 1.0
/*/
method setcStatus(cStatus) class ControleDeExpedicao
	::cStatus := cStatus
return

/*/{Protheus.doc} setcChaveStatus
@author Evandro Simenes 
@since 13/11/2017 
@version 1.0
/*/
method setcChaveStatus(cChave) class ControleDeExpedicao
	::cChaveStatus := cChave
return

/*/{Protheus.doc} setlEstorno
@author Evandro Simenes
@since 13/11/2017 
@version 1.0
/*/
method setlEstorno(lEstorno) class ControleDeExpedicao
	::lEstorno := lEstorno
return

/*/{Protheus.doc} setcItem
@author Evandro Simenes
@since 13/11/2017 
@version 1.0
/*/
method setcItem(cItem) class ControleDeExpedicao
	::cItem := cItem
return

/*/{Protheus.doc} setcSequen
@author Evandro Simenes
@since 13/11/2017 
@version 1.0
/*/
method setcSequen(cSequen) class ControleDeExpedicao
	::cSequen := cSequen
return
/*/{Protheus.doc} setcPedido
@author Evandro Simenes
@since 24/11/2017 
@version 1.0
/*/
method setcPedido(cPedido) class ControleDeExpedicao
	::cPedido := cPedido
return

/*/{Protheus.doc} setcNVol
@author Evandro Simenes
@since 24/11/2017 
@version 1.0
/*/
method setcNVol(cNVol) class ControleDeExpedicao
	::cNVol := cNVol
return

/*/{Protheus.doc} setcTVol
@author Evandro Simenes
@since 24/11/2017 
@version 1.0
/*/
method setcTVol(cTVol) class ControleDeExpedicao
	::cTVol := cTVol
return

/*/{Protheus.doc} setcIdVol
@author Evandro Simenes
@since 24/11/2017 
@version 1.0
/*/
method setcIdVol(cIdVol) class ControleDeExpedicao
	::cIdVol := cIdVol
return

method getAddQuery() class ControleDeExpedicao
	Local cQuery := ""
	
	Do Case 
	   Case ::cStatus == "1"
			cQuery := " SELECT CB7.CB7_ORDSEP ORDSEP, CB7.CB7_LOJA LOJA, CB7.CB7_CLIENT CODCLI, SA1.A1_NOME NOMCLI, SA1.A1_EST UF, '"+::cCodPro+"' CODPRO, SB1.B1_DESC DESCPR, "+str(::nQtd1Um)+" QTD1UM, SB1.B1_UM UM, SB1.B1_SEGUM UM2, '0' ITEM, '' NF, '' SERIE, '' TRANSP, '' DESCTR, 0 QTD2UM, '0' SEQUEN, '"+::cPedido+"' PEDIDO, 0 QTDSEP, '' NVOL, '' TVOL, '' IDVOL "
		  	cQuery += "   FROM "+RetSqlName("CB7")+" CB7 "
			cQuery += "  INNER JOIN "+RetSqlName("SA1")+" SA1 "
			cQuery += "          ON SA1.D_E_L_E_T_ <> '*' "
			cQuery += "         AND SA1.A1_FILIAL = '"+xFilial("SA1")+"'"
			cQuery += "         AND SA1.A1_COD = CB7.CB7_CLIENT "
			cQuery += "         AND SA1.A1_LOJA = CB7.CB7_LOJA "
			cQuery += "  INNER JOIN "+RetSqlName("SB1")+" SB1 "
			cQuery += "          ON SB1.D_E_L_E_T_ <> '*' "
			cQuery += "         AND SB1.B1_FILIAL = '"+xFilial("SB1")+"'"
			cQuery += "         AND SB1.B1_COD = '"+::cCodPro+"' "
			cQuery += "  WHERE CB7.D_E_L_E_T_ <> '*' "
			cQuery += "         AND CB7.CB7_FILIAL = '"+xFilial("CB7")+"'"
			cQuery += "         AND CB7.CB7_ORDSEP = '"+::cOrdSep+"' "
			cQuery += "         AND CB7.CB7_LOJA = '"+::cLoja+"' "
			
	   Case ::cStatus == "2"
			cQuery := " SELECT ZA2.ZA2_ORDSEP ORDSEP, ZA2.ZA2_LOJA LOJA, ZA2.ZA2_CODCLI CODCLI, ZA2.ZA2_NOMCLI NOMCLI, ZA2.ZA2_UF UF, ZA2.ZA2_CODPRO CODPRO, ZA2.ZA2_DESCPR DESCPR, ZA2.ZA2_QTD1UM QTD1UM, ZA2.ZA2_UM UM, ZA2.ZA2_2UM UM2, ZA2.ZA2_ITEM ITEM, ZA2.ZA2_NF NF, ZA2.ZA2_SERIE SERIE, ZA2.ZA2_TRANSP TRANSP, ZA2.ZA2_DESCTR DESCTR, ZA2.ZA2_QTD2UM QTD2UM, ZA2.ZA2_SEQUEN SEQUEN, ZA2.ZA2_PEDIDO PEDIDO, ZA2.ZA2_QTDSEP QTDSEP, '' NVOL, '' TVOL, '' IDVOL "
		  	cQuery += "   FROM "+RetSqlName("ZA2")+" ZA2 "
		  	cQuery += "  WHERE ZA2.D_E_L_E_T_ <> '*'"
			cQuery += "    AND ZA2.ZA2_FILIAL = '"+xFilial("ZA2")+"'"
			cQuery += "    AND ZA2.ZA2_ORDSEP = '"+::cOrdSep+"'"
			cQuery += "    AND ZA2.ZA2_CODPRO = '"+::cCodPro+"'"
			//cQuery += "    AND ZA2.ZA2_ITEM = '"+::cItem+"'"
			cQuery += "    AND ZA2.ZA2_LOJA = '"+::cLoja+"'"
			cQuery += "    AND ZA2.ZA2_STATUS = '1'"
			cQuery += "    AND ZA2.ZA2_ORDSEP NOT IN (SELECT ZA2_ORDSEP " 
			cQuery += "                                 FROM "+RetSqlName("ZA2")
			cQuery += "                                WHERE D_E_L_E_T_ <> '*' "
			cQuery += "                                  AND ZA2_FILIAL = '"+xFilial("ZA2")+"'"
			cQuery += "                                  AND ZA2_ORDSEP = '"+::cOrdSep+"'"
			cQuery += "                                  AND ZA2_STATUS = '"+::cStatus+"'"
			cQuery += "                                  AND ZA2_CODPRO = '"+::cCodPro+"'"
			//cQuery += "                                  AND ZA2_ITEM = '"+::cItem+"'"
			//cQuery += "                                  AND ZA2_SEQUEN = '"+::cSequen+"'"
			cQuery += "                                  AND (ZA2_DTFIM IS NULL OR ZA2_DTFIM = ''))"
			//cQuery += "    AND ZA2.ZA2_SEQUEN = '"+::cSequen+"'"
	  Case ::cStatus == "3"
			cQuery := " SELECT ZA2.ZA2_ORDSEP ORDSEP, ZA2.ZA2_LOJA LOJA, ZA2.ZA2_CODCLI CODCLI, ZA2.ZA2_NOMCLI NOMCLI, ZA2.ZA2_UF UF, ZA2.ZA2_CODPRO CODPRO, ZA2.ZA2_DESCPR DESCPR, ZA2.ZA2_QTD1UM QTD1UM, ZA2.ZA2_UM UM, ZA2.ZA2_2UM UM2, ZA2.ZA2_ITEM ITEM, '"+::cNF+"' NF, '"+::cSerie+"' SERIE, '"+::cTransp+"' TRANSP, '"+::cDescTr+"' DESCTR, ZA2.ZA2_QTD2UM QTD2UM, ZA2.ZA2_SEQUEN SEQUEN, ZA2.ZA2_PEDIDO PEDIDO , ZA2.ZA2_QTDSEP QTDSEP, '' NVOL, '' TVOL, '' IDVOL "
		  	cQuery += "   FROM "+RetSqlName("ZA2")+" ZA2 "
		  	cQuery += "  WHERE ZA2.D_E_L_E_T_ <> '*'"
			cQuery += "    AND ZA2.ZA2_FILIAL = '"+xFilial("ZA2")+"'"
			cQuery += "    AND ZA2.ZA2_ORDSEP = '"+::cOrdSep+"'"
			cQuery += "    AND ZA2.ZA2_LOJA = '"+::cLoja+"'"
			cQuery += "    AND ZA2.ZA2_STATUS = '2'"
			cQuery += "    AND ZA2.ZA2_ORDSEP NOT IN (SELECT ZA2_ORDSEP " 
			cQuery += "                                 FROM "+RetSqlName("ZA2")
			cQuery += "                                WHERE D_E_L_E_T_ <> '*' "
			cQuery += "                                  AND ZA2_FILIAL = '"+xFilial("ZA2")+"'"
			cQuery += "                                  AND ZA2_ORDSEP = '"+::cOrdSep+"'"
			cQuery += "                                  AND ZA2_STATUS = '"+::cStatus+"'"
			cQuery += "                                  AND (ZA2_DTFIM IS NULL OR ZA2_DTFIM = ''))"
			
	   Case ::cStatus == "4"
			/*cQuery := " SELECT ZA2.ZA2_ORDSEP ORDSEP, ZA2.ZA2_LOJA LOJA, ZA2.ZA2_CODCLI CODCLI, ZA2.ZA2_NOMCLI NOMCLI, ZA2.ZA2_UF UF, ZA2.ZA2_CODPRO CODPRO, ZA2.ZA2_DESCPR DESCPR, ZA2.ZA2_QTD1UM QTD1UM, ZA2.ZA2_UM UM, ZA2.ZA2_2UM UM2, ZA2.ZA2_ITEM ITEM, ZA2.ZA2_NF NF, ZA2.ZA2_SERIE SERIE, ZA2.ZA2_TRANSP TRANSP, ZA2.ZA2_DESCTR DESCTR, ZA2.ZA2_QTD2UM QTD2UM, ZA2.ZA2_SEQUEN SEQUEN, ZA2.ZA2_PEDIDO PEDIDO, ZA2.ZA2_QTDSEP QTDSEP "
		  	cQuery += "   FROM "+RetSqlName("ZA2")+" ZA2 "
		  	cQuery += "  WHERE ZA2.D_E_L_E_T_ <> '*'"
			cQuery += "    AND ZA2.ZA2_FILIAL = '"+xFilial("ZA2")+"'"
			cQuery += "    AND ZA2.ZA2_ORDSEP = '"+::cOrdSep+"'"
			cQuery += "    AND ZA2.ZA2_LOJA = '"+::cLoja+"'"
			cQuery += "    AND ZA2.ZA2_STATUS = '3'"
			cQuery += "    AND ZA2.ZA2_ORDSEP NOT IN (SELECT ZA2_ORDSEP " 
			cQuery += "                                 FROM "+RetSqlName("ZA2")
			cQuery += "                                WHERE D_E_L_E_T_ <> '*' "
			cQuery += "                                  AND ZA2_FILIAL = '"+xFilial("ZA2")+"'"
			cQuery += "                                  AND ZA2_ORDSEP = '"+::cOrdSep+"'"
			cQuery += "                                  AND ZA2_STATUS = '"+::cStatus+"'"
			cQuery += "                                  AND (ZA2_DTFIM IS NULL OR ZA2_DTFIM = ''))"*/
			
			cQuery := " SELECT DISTINCT ZA2.ZA2_ORDSEP ORDSEP, ZA2.ZA2_LOJA LOJA, ZA2.ZA2_CODCLI CODCLI, ZA2.ZA2_NOMCLI NOMCLI, ZA2.ZA2_UF UF, '' CODPRO, '' DESCPR, 0 QTD1UM, '' UM, '' UM2, '' ITEM, ZA2.ZA2_NF NF, ZA2.ZA2_SERIE SERIE, ZA2.ZA2_TRANSP TRANSP, ZA2.ZA2_DESCTR DESCTR, 0 QTD2UM, '' SEQUEN, ZA2.ZA2_PEDIDO PEDIDO, 0 QTDSEP, '"+::cNVol+"' NVOL, '"+::cTVol+"' TVOL, '"+::cIdVol+"' IDVOL "
			cQuery += "   FROM "+RetSqlName("ZA2")+" ZA2 "
			cQuery += "  WHERE ZA2.D_E_L_E_T_ <> '*'"
			cQuery += "    AND ZA2.ZA2_FILIAL = '"+xFilial("ZA2")+"'"
			cQuery += "    AND ZA2.ZA2_ORDSEP = '"+::cOrdSep+"'"
			cQuery += "    AND ZA2.ZA2_LOJA = '"+::cLoja+"'"
			cQuery += "    AND ZA2.ZA2_STATUS = '3'"
			cQuery += "    AND ZA2.ZA2_IDVOL NOT IN (SELECT ZA2_IDVOL"
			cQuery += "                                FROM "+RetSqlName("ZA2")
			cQuery += "                               WHERE D_E_L_E_T_ <> '*'"
			cQuery += "                                 AND ZA2_FILIAL = '"+xFilial("ZA2")+"'"
			cQuery += "                                 AND ZA2_ORDSEP = '"+::cOrdSep+"'"
			cQuery += "                                 AND ZA2_LOJA = '"+::cLoja+"'"
			cQuery += "                                 AND ZA2_STATUS = '4'"
			cQuery += "                                 AND ZA2_IDVOL = '"+::cIdVol+"')"
		
		Case ::cStatus == "5"
			/*cQuery := " SELECT ZA2.ZA2_ORDSEP ORDSEP, ZA2.ZA2_LOJA LOJA, ZA2.ZA2_CODCLI CODCLI, ZA2.ZA2_NOMCLI NOMCLI, ZA2.ZA2_UF UF, ZA2.ZA2_CODPRO CODPRO, ZA2.ZA2_DESCPR DESCPR, ZA2.ZA2_QTD1UM QTD1UM, ZA2.ZA2_UM UM, ZA2.ZA2_2UM UM2, ZA2.ZA2_ITEM ITEM, ZA2.ZA2_NF NF, ZA2.ZA2_SERIE SERIE, ZA2.ZA2_TRANSP TRANSP, ZA2.ZA2_DESCTR DESCTR, ZA2.ZA2_QTD2UM QTD2UM, ZA2.ZA2_SEQUEN SEQUEN, ZA2.ZA2_PEDIDO PEDIDO , ZA2.ZA2_QTDSEP QTDSEP, ZA2.ZA2_NVOL NVOL, ZA2.ZA2_TVOL TVOL, ZA2.ZA2_IDVOL IDVOL "
		  	cQuery += "   FROM "+RetSqlName("ZA2")+" ZA2 "
		  	cQuery += "  WHERE ZA2.D_E_L_E_T_ <> '*'"
			cQuery += "    AND ZA2.ZA2_FILIAL = '"+xFilial("ZA2")+"'"
			cQuery += "    AND ZA2.ZA2_ORDSEP = '"+::cOrdSep+"'"
			cQuery += "    AND ZA2.ZA2_LOJA = '"+::cLoja+"'"
			cQuery += "    AND ZA2.ZA2_STATUS = '4'"
			cQuery += "    AND ZA2.ZA2_ORDSEP NOT IN (SELECT ZA2_ORDSEP " 
			cQuery += "                                 FROM "+RetSqlName("ZA2")
			cQuery += "                                WHERE D_E_L_E_T_ <> '*' "
			cQuery += "                                  AND ZA2_FILIAL = '"+xFilial("ZA2")+"'"
			cQuery += "                                  AND ZA2_ORDSEP = '"+::cOrdSep+"'"
			cQuery += "                                  AND ZA2_STATUS = '"+::cStatus+"'"
			cQuery += "                                  )"*/
			
			cQuery := " SELECT DISTINCT ZA2.ZA2_ORDSEP ORDSEP, ZA2.ZA2_LOJA LOJA, ZA2.ZA2_CODCLI CODCLI, ZA2.ZA2_NOMCLI NOMCLI, ZA2.ZA2_UF UF, '' CODPRO, '' DESCPR, 0 QTD1UM, '' UM, '' UM2, '' ITEM, ZA2.ZA2_NF NF, ZA2.ZA2_SERIE SERIE, ZA2.ZA2_TRANSP TRANSP, ZA2.ZA2_DESCTR DESCTR, 0 QTD2UM, '' SEQUEN, ZA2.ZA2_PEDIDO PEDIDO, 0 QTDSEP, ZA2.ZA2_NVOL NVOL, ZA2.ZA2_TVOL TVOL, ZA2.ZA2_IDVOL IDVOL "
			cQuery += "   FROM "+RetSqlName("ZA2")+" ZA2 "
			cQuery += "  WHERE ZA2.D_E_L_E_T_ <> '*'"
			cQuery += "    AND ZA2.ZA2_FILIAL = '"+xFilial("ZA2")+"'"
			cQuery += "    AND ZA2.ZA2_ORDSEP = '"+::cOrdSep+"'"
			cQuery += "    AND ZA2.ZA2_LOJA = '"+::cLoja+"'"
			cQuery += "    AND ZA2.ZA2_STATUS = '4'"
			cQuery += "    AND ZA2.ZA2_IDVOL = '"+::cIdVol+"'"
			cQuery += "    AND ZA2.ZA2_IDVOL NOT IN (SELECT ZA2_IDVOL"
			cQuery += "                                FROM "+RetSqlName("ZA2")
			cQuery += "                               WHERE D_E_L_E_T_ <> '*'"
			cQuery += "                                 AND ZA2_FILIAL = '"+xFilial("ZA2")+"'"
			cQuery += "                                 AND ZA2_ORDSEP = '"+::cOrdSep+"'"
			cQuery += "                                 AND ZA2_LOJA = '"+::cLoja+"'"
			cQuery += "                                 AND ZA2_STATUS = '5'"
			cQuery += "                                 AND ZA2_IDVOL = '"+::cIdVol+"')"
	End
Return cQuery
