#Include 'Protheus.ch'
#Include 'TOPCONN.ch'


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TSPRODXRECºAutor  ³Microsiga           º Data ³  09/17/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³                                                            º±±
±±º 20140917 ³ Alteracao das regras de filtro para utilizacao de          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TSProdXRec()

If ValidPerg()
	MontaTela()
EndIf
	
Return

Static Function ValidPerg()
	
Local cPerg	:= "Recurso x Produção"
Local aPar	:= {}

//Private Opcoes	:= { || Opcoes() }

Aadd(aPar, {1, "Emissao de: ",    STOD(""),                       "",     "",  "",    "", 50, .F.})   				// MV_PAR01
Aadd(aPar, {1, "Emissao até: ",   STOD(""),                       "",     "",  "",    "", 50, .F.})   				// MV_PAR02
Aadd(aPar, {1, "Recurso de: ",    Space(TamSX3("D3_ZZRECUR")[1]), "",     "",  "SH1", "", 50, .F.})   				// MV_PAR03
Aadd(aPar, {1, "Recurso até: ",   Space(TamSX3("D3_ZZRECUR")[1]), "",     "",  "SH1", "", 50, .F.})   				// MV_PAR04
Aadd(aPar, {1, "Ordem de Prod. de: ",    Space(TamSX3("D3_OP")[1]), "",     "",  "SC2", "", 50, .F.})  				// MV_PAR05
Aadd(aPar, {1, "Ordem de Prod. até: ",   Space(TamSX3("D3_OP")[1]), "",     "",  "SC2", "", 50, .F.})  				// MV_PAR06

Return (ParamBox(aPar, "Recurso x Producao",,,,,,,, cPerg, .T., .T.))

Static Function MontaTela()

	Local cQuery := buscaSelect()
	Local aCoordA:= {6,1,22,100}
	
	Private cCadastro 	:= "Recusro x produção"
	Private aRotina 	:= {}
	Private bPesquisa	:= {|| oMBrowse:Pesquisa()}
	//Private bCadastro	:= {|| InsereNegociacao(), oMBrowse:Refresh()}
	Private bPrintRel	:= {|| PrintRel()}
	Private oMBrowse	:= Nil
	
	aAdd( aRotina , { "Pesquisar" 			, "Eval(bPesquisa)"	, 0 , 1 } )
	//aAdd( aRotina , { "Insere Negociação"	, "Eval(bCadastro)"	, 0 , 4 } )
	aAdd( aRotina , { "Imprimir"			, "Eval(bPrintRel)"	, 0 , 4 } )
	
	oMBrowse := ParafMBrowse():New(aCoordA,"ZSD3",,)
	oMBrowse:cQuery := cQuery

	oMBrowse:aIndex	:= {	{"Recurso"	,"D3_ZZRECUR+DtoS(D3_EMISSAO)+D3_COD"} }
	
	oMBrowse:cCampoMark := "D3_OK"
	
	AADD(oMBrowse:aSetFields,{"D3_EMISSAO","D",nil,nil})
	
	oMBrowse:ExecQuery()
	oMBrowse:Show(.t.)
	oMBrowse:Close()
	
Return

Static Function buscaSelect()
	
	Local cQuery := ""
	
	cQuery := "     select '  ' AS D3_OK, " + CRLF
	cQuery += "            SD3.D3_ZZRECUR, " + CRLF
	cQuery += "            SH1.H1_DESCRI, " + CRLF	
	cQuery += "            SD3.D3_OP, " + CRLF	
	cQuery += "            SD3.D3_EMISSAO, " + CRLF
	cQuery += "            SD3.D3_COD, " + CRLF
	cQuery += "            SB1.B1_DESC, " + CRLF
	cQuery += "            SD3.D3_QUANT, " + CRLF	
	cQuery += "            SD3.D3_UM, " + CRLF	
	cQuery += "            SD3.D3_QTSEGUM, " + CRLF	
	cQuery += "            SD3.D3_SEGUM, " + CRLF	
	cQuery += "            SD3.D3_ZZPALET, " + CRLF	
	cQuery += "            SD3.D3_TURNO, " + CRLF	
	cQuery += "            SD3.D3_REQUIS, " + CRLF	
	cQuery += "            SB1.B1_ZZLP " + CRLF	
	cQuery += "       from "+RetSqlName("SD3")+" SD3 " + CRLF
	cQuery += "  left join "+RetSqlName("SB1")+" SB1 " + CRLF 
	cQuery += "         on SB1.B1_FILIAL = '" + xFilial("SB1") + "'" + CRLF 
	cQuery += "        and SB1.B1_COD = SD3.D3_COD " + CRLF 
	cQuery += "        and SB1.D_E_L_E_T_ = ' ' " + CRLF 
	cQuery += "  left join "+RetSqlName("SH1")+" SH1 " + CRLF 
	cQuery += "         on SH1.H1_FILIAL = '" + xFilial("SH1") + "'" + CRLF 
	cQuery += "        and SH1.H1_CODIGO = SD3.D3_ZZRECUR " + CRLF 
	cQuery += "        and SH1.D_E_L_E_T_ = ' ' " + CRLF 	
	cQuery += "      where SD3.D3_EMISSAO between '" + dtos(MV_PAR01) + "' and '" + dtos(MV_PAR02) + "' " + CRLF
	cQuery += "        and SD3.D3_ZZRECUR between '" + MV_PAR03 + "' and '" + MV_PAR04 + "' " + CRLF
	cQuery += "        and SD3.D3_OP between '" + MV_PAR05 + "' and '" + MV_PAR06 + "' " + CRLF
	cQuery += "        and LEFT(SD3.D3_CF,2) = 'PR' " + CRLF
	cQuery += "        and SD3.D3_ESTORNO = ' ' " + CRLF
	cQuery += "        and SD3.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += "   order by SD3.D3_ZZRECUR, SD3.D3_EMISSAO, SD3.D3_COD, SD3.D3_OP, SD3.D3_NUMSEQ "
	
Return (cQuery)

Static Function PrintRel()
	Local oReport
	//:oFont   := TFont():New( cName ,nWidth,nHeight,,lBold,,,,lUnderline,lItalic )   
	Private oFont09B	:= TFont():New("Arial",9,09,,.T.,,,,,.F.) // Negrito
	Private oFont10		:= TFont():New("Arial",8,08,,.F.,,,,,.F.) // Normal
	oReport := ReportDef()
	oReport:PrintDialog()
Return

Static Function ReportDef()
   Local  oBreak  := NIL
   Local  oBreak2 := NIL
   Local  oBreak3 := NIL
   Local  oBreak4 := NIL
   Local  oBreak5 := NIL

	Local  oReport, oSection, oSection2
	Local  oCel1, oCel2, oCel3, oCel4, oCel5, oCel6, oCel7, oCel8, oCel9, oCel10, oCel10a, oCel10b, oCel10c, oCel1a, oCel2a, oCel3a, oCel1b, oCel12, oCel13, oCel14
	Local  oTotValor, oTotSaldo, oTotValor2, oTotSaldo2, oTotValor3, oTotSaldo3, oTotValor4, oTotSaldo4
	
	Local cOrdem := Alltrim(mv_par20)	

	oReport := TReport():New("TSPRODXREC","Recurso x Produção",,{|oReport| PrintReport(oReport) })
	oReport:SetLandScape()//Impressao em Paisagem
	oReport:SetTotalInLine(.F.)
		
	oSection := TRSection():New(oReport,"Recurso x Produção",(oMBrowse:cAlias))
	oSection:AutoSize()
	oSection:SetTotalInLine(.F.)
	oSection:SetTotalText("Total Geral")

	oCel1 := TRCell():New(oSection,"D3_ZZRECUR","", "Recurso"		,Nil,TamSX3("D3_ZZRECUR")[1])
	oCel1:oFontBody := oFont10
	oCel2 := TRCell():New(oSection,"H1_DESCRI","", "Nom. Recurso"	,Nil,30,,,,.t.)
	oCel2:oFontBody := oFont10
	oCel3 := TRCell():New(oSection,"D3_EMISSAO"	,"", "Emissão"		,Nil,TamSX3("D3_EMISSAO")[1]+2)
	oCel3:oFontBody := oFont10
	oCel4 := TRCell():New(oSection,"D3_OP","", "Ordem de Prod."	,Nil,15,,,,.t.)
	oCel4:oFontBody := oFont10
	oCel5 := TRCell():New(oSection,"D3_COD"		,"", "Produto"		,Nil,TamSX3("D3_COD")[1])
	oCel5:oFontBody := oFont10	
	oCel6 := TRCell():New(oSection,"B1_DESC"	,"", "Descricao"	,Nil,TamSX3("B1_DESC")[1]+5)
	oCel6:oFontBody := oFont10
	oCel7 := TRCell():New(oSection,"D3_QUANT"	,"", "Quantidade"	,PesqPict("SD3","D3_QUANT"),TamSX3("D3_QUANT")[1]+5)
	oCel7:oFontBody := oFont10
	oCel8 := TRCell():New(oSection,"D3_UM"	,"", "UM"		,Nil,TamSX3("D3_UM")[1]+2)
	oCel8:oFontBody := oFont10
	oCel9 := TRCell():New(oSection,"D3_QTSEGUM"	,"", "Qtde 2a UM"	,PesqPict("SD3","D3_QTSEGUM"),TamSX3("D3_QTSEGUM")[1]+5)
	oCel9:oFontBody := oFont10
	oCel10 := TRCell():New(oSection,"D3_SEGUM"	,"", "2a UM"		,Nil,TamSX3("D3_UM")[1]+2)
	oCel10:oFontBody := oFont10	
	oCel11 := TRCell():New(oSection,"D3_ZZPALET"	,"", "Nr Pallet"		,Nil,TamSX3("D3_ZZPALET")[1]+2)
	oCel11:oFontBody := oFont10	
	oCel12 := TRCell():New(oSection,"D3_TURNO"	,"", "Turno"		,Nil,TamSX3("D3_TURNO")[1]+2)
	oCel12:oFontBody := oFont10		
	oCel13 := TRCell():New(oSection,"D3_REQUIS"	,"", "Apontador"		,Nil,TamSX3("D3_REQUIS")[1]+2)
	oCel13:oFontBody := oFont10
	oCel14 := TRCell():New(oSection,"B1_ZZLP"	,"", "Linha Prod"		,Nil,TamSX3("B1_ZZLP")[1]+2)
	oCel14:oFontBody := oFont10		
	                               
	oBreak	:= TRBreak():New(oSection,oSection:Cell("D3_OP"),'Total OP')
	oBreak:oFontBody := oFont09B
	oTotValor:= TRFunction():New(oSection:Cell("D3_QUANT"),NIL,"SUM",oBreak," ",PesqPict("SD3","D3_QUANT"),NIL,.F.,.F.)
	oTotValor:oFontBody := oFont09B
	oTotValor:= TRFunction():New(oSection:Cell("D3_QTSEGUM"),NIL,"SUM",oBreak," ",PesqPict("SD3","D3_QTSEGUM"),NIL,.F.,.F.)
	oTotValor:oFontBody := oFont09B	
	
	oBreak2	:= TRBreak():New(oSection,oSection:Cell("D3_COD"),'Total Produto')
	oBreak2:oFontBody := oFont09B
	oTotValor:= TRFunction():New(oSection:Cell("D3_QUANT"),NIL,"SUM",oBreak2," ",PesqPict("SD3","D3_QUANT"),NIL,.F.,.F.)
	oTotValor:oFontBody := oFont09B
	oTotValor:= TRFunction():New(oSection:Cell("D3_QTSEGUM"),NIL,"SUM",oBreak2," ",PesqPict("SD3","D3_QTSEGUM"),NIL,.F.,.F.)
	oTotValor:oFontBody := oFont09B
	
	oBreak3	:= TRBreak():New(oSection,oSection:Cell("D3_ZZRECUR"),'Total Recurso')
	oBreak3:oFontBody := oFont09B
	oTotValor:= TRFunction():New(oSection:Cell("D3_QUANT"),NIL,"SUM",oBreak3," ",PesqPict("SD3","D3_QUANT"),NIL,.F.,.F.)
	oTotValor:oFontBody := oFont09B
	oTotValor:= TRFunction():New(oSection:Cell("D3_QTSEGUM"),NIL,"SUM",oBreak3," ",PesqPict("SD3","D3_QTSEGUM"),NIL,.F.,.F.)
	oTotValor:oFontBody := oFont09B
			
	oBreak4 := TRBreak():New( oSection, { || }, "Total Geral")
	oBreak4:oFontBody := oFont09B
	oTotValor:= TRFunction():New(oSection:Cell("D3_QUANT"),NIL,"SUM",oBreak4," ",PesqPict("SD3","D3_QUANT"),NIL,.F.,.F.)
	oTotValor:oFontBody := oFont09B
	oTotValor:= TRFunction():New(oSection:Cell("D3_QTSEGUM"),NIL,"SUM",oBreak4," ",PesqPict("SD3","D3_QTSEGUM"),NIL,.F.,.F.)
	oTotValor:oFontBody := oFont09B
   
	oCel7:SetAlign("RIGHT")
	oCel9:SetAlign("RIGHT")
	
Return (oReport)

Static Function PrintReport(oReport)
	
	Local oSec1		:= oReport:Section(1)
	Local aArea 	:= (oMBrowse:cAlias)->(GetArea())
	
	(oMBrowse:cAlias)->(oReport:SetMeter(RecCount()))
	oSec1:Init()
	
	(oMBrowse:cAlias)->(dbGoTop())
	Do While ( (oMBrowse:cAlias)->(!Eof()) )
		
		If oReport:Cancel()
			Exit
		EndIf
		If (oMBrowse:cAlias)->(IsMark(oMBrowse:cCampoMark,oMBrowse:cMarca ))
			oSec1:Cell("D3_ZZRECUR"):Setvalue((oMBrowse:cAlias)->D3_ZZRECUR)
			
			
			oSec1:Cell("D3_ZZRECUR"):Setvalue((oMBrowse:cAlias)->D3_ZZRECUR)
			oSec1:Cell("D3_EMISSAO"):Setvalue((oMBrowse:cAlias)->D3_EMISSAO)
			oSec1:Cell("H1_DESCRI"):Setvalue(Alltrim((oMBrowse:cAlias)->H1_DESCRI))
			oSec1:Cell("D3_OP"):Setvalue(Alltrim((oMBrowse:cAlias)->D3_OP))
			oSec1:Cell("D3_COD"):Setvalue((oMBrowse:cAlias)->D3_COD)
			oSec1:Cell("B1_DESC"):Setvalue((oMBrowse:cAlias)->B1_DESC)
			oSec1:Cell("D3_QUANT"):Setvalue((oMBrowse:cAlias)->D3_QUANT)
			oSec1:Cell("D3_UM"):Setvalue((oMBrowse:cAlias)->D3_UM)
			oSec1:Cell("D3_QTSEGUM"):Setvalue((oMBrowse:cAlias)->D3_QTSEGUM)
			oSec1:Cell("D3_SEGUM"):Setvalue((oMBrowse:cAlias)->D3_SEGUM)			
			oSec1:Cell("D3_ZZPALET"):Setvalue((oMBrowse:cAlias)->D3_ZZPALET)			
			oSec1:Cell("D3_TURNO"):Setvalue((oMBrowse:cAlias)->D3_TURNO)			
			oSec1:Cell("D3_REQUIS"):Setvalue((oMBrowse:cAlias)->D3_REQUIS)			
			oSec1:Cell("B1_ZZLP"):Setvalue((oMBrowse:cAlias)->B1_ZZLP)			
			
			oSec1:PrintLine()

		EndIf
	(oMBrowse:cAlias)->(dbSkip())
	EndDo

	oSec1:Finish()
	oReport:sKIPLINE()
	RestArea(aArea)
	
Return