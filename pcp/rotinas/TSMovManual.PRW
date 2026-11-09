#Include 'Protheus.ch'
#Include 'TOPCONN.ch'


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TSMOVXMANUALºAutor  ³Microsiga         º Data ³  27/01/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatorio de movimentos manuaispor centro de custo         º±±
±±º          ³ (Controle de movimentação)                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º          ³                                                            º±±
±±º 20140917 ³ Alteracao das regras de filtro para utilizacao de          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TSMovManual()

If ValidPerg()
	MontaTela()
EndIf
	
Return

Static Function ValidPerg()
	
Local cPerg	:= "Movimentos Manuais"
Local aPar	:= {}

//Private Opcoes	:= { || Opcoes() }

Aadd(aPar, {1, "Emissao de: ",    STOD(""),                       "",     "",  "",    "", 50, .F.})   				// MV_PAR01
Aadd(aPar, {1, "Emissao até: ",   STOD(""),                       "",     "",  "",    "", 50, .F.})   				// MV_PAR02
Aadd(aPar, {1, "Produto De: ",    Space(TamSX3("D3_COD")[1]),     "",     "",  "SB1", "", 50, .F.})   				// MV_PAR03
Aadd(aPar, {1, "Produto Até: ",   Space(TamSX3("D3_COD")[1]), "",         "",  "SB1", "", 50, .F.})   				// MV_PAR04

Return (ParamBox(aPar, "Movimentos Manuais",,,,,,,, cPerg, .T., .T.))

Static Function MontaTela()

	Local cQuery := buscaSelect()
	Local aCoordA:= {6,1,22,100}
	
	Private cCadastro 	:= "Mavimentos Manuais"
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

	oMBrowse:aIndex	:= {	{"Movimento"	,"D3_TM+DtoS(D3_EMISSAO)+D3_COD"} }
	
	oMBrowse:cCampoMark := "D3_OK"
	
	AADD(oMBrowse:aSetFields,{"D3_EMISSAO","D",nil,nil})
	
	oMBrowse:ExecQuery()
	oMBrowse:Show(.t.)
	oMBrowse:Close()
	
Return

Static Function buscaSelect()
	
	Local cQuery := ""
	
	cQuery := "     select '  ' AS D3_OK, " + CRLF
	cQuery += "            SD3.D3_FILIAL, " + CRLF
	cQuery += "            SD3.D3_TM, " + CRLF
	cQuery += "            SD3.D3_EMISSAO, " + CRLF
	cQuery += "            SD3.D3_COD, " + CRLF
	cQuery += "            SB1.B1_DESC, " + CRLF
	cQuery += "            SD3.D3_QUANT, " + CRLF	
	cQuery += "            SD3.D3_UM, " + CRLF	
	cQuery += "            SD3.D3_QTSEGUM, " + CRLF	
	cQuery += "            SD3.D3_SEGUM, " + CRLF	
	cQuery += "            SD3.D3_CUSTO1, " + CRLF
	cQuery += "            SD3.D3_OP, " + CRLF
	cQuery += "            SD3.D3_CC, " + CRLF
	cQuery += "            SD3.D3_REQUIS, " + CRLF	         
    cQuery += "            SD3.D3_TURNO, " + CRLF	
    cQuery += "            SD3.D3_ZZRNCOB " + CRLF
    cQuery += "      FROM "+RetSqlName("SD3")+" SD3" + CRLF
    cQuery += "      inner join "+RetSqlName("SB1")+" SB1 on SB1.B1_FILIAL = '"+xFilial("SB1")+"' and SB1.B1_COD = SD3.D3_COD and SB1.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += "      where SD3.D3_EMISSAO between '" + dtos(MV_PAR01) + "' and '" + dtos(MV_PAR02) + "' " + CRLF
	cQuery += "        and SD3.D3_COD between '" + MV_PAR03 + "' and '" + MV_PAR04 + "' " + CRLF
	cQuery += "        and LEFT(SD3.D3_CF,2) IN ('RE','DE') " + CRLF
	cQuery += "        and SD3.D3_TM IN ('480','980','486','986')" + CRLF   
	cQuery += "        and SD3.D3_ESTORNO = ' ' " + CRLF
	cQuery += "        and SD3.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += "   order by SD3.D3_TM, SD3.D3_EMISSAO, SD3.D3_COD, SD3.D3_NUMSEQ "
	
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

	oReport := TReport():New("TSMOVMANUAL","Movimentos Manuais",,{|oReport| PrintReport(oReport) })
	oReport:SetLandScape()//Impressao em Paisagem
	oReport:SetTotalInLine(.F.)
		
	oSection := TRSection():New(oReport,"Movimentos Manuais",(oMBrowse:cAlias))
	oSection:AutoSize()
	oSection:SetTotalInLine(.F.)
	oSection:SetTotalText("Total Geral")

	oCel3 := TRCell():New(oSection,"D3_FILIAL"	,"", "Filial"		,Nil,TamSX3("D3_FILIAL")[1]+2)
    oCel3:oFontBody := oFont10
	oCel4 := TRCell():New(oSection,"D3_TM"	,"", "TM"		,Nil,TamSX3("D3_TM")[1]+2)
    oCel4:oFontBody := oFont10    
    oCel5 := TRCell():New(oSection,"D3_EMISSAO"	,"", "Emissão"		,Nil,TamSX3("D3_EMISSAO")[1]+2)
	oCel5:oFontBody := oFont10
	oCel6 := TRCell():New(oSection,"D3_COD"		,"", "Produto"		,Nil,TamSX3("D3_COD")[1])
	oCel6:oFontBody := oFont10	
	oCel7 := TRCell():New(oSection,"B1_DESC"	,"", "Descricao"	,Nil,TamSX3("B1_DESC")[1]+5)
	oCel7:oFontBody := oFont10
	oCel8 := TRCell():New(oSection,"D3_QUANT"	,"", "Quantidade"	,PesqPict("SD3","D3_QUANT"),TamSX3("D3_QUANT")[1]+5)
	oCel8:oFontBody := oFont10
	oCel9 := TRCell():New(oSection,"D3_UM"	,"", "UM"		,Nil,TamSX3("D3_UM")[1]+2)
	oCel9:oFontBody := oFont10
	oCe20 := TRCell():New(oSection,"D3_QTSEGUM"	,"", "Qtde 2a UM"	,PesqPict("SD3","D3_QTSEGUM"),TamSX3("D3_QTSEGUM")[1]+5)
	oCe20:oFontBody := oFont10
	oCel10 := TRCell():New(oSection,"D3_SEGUM"	,"", "2a UM"		,Nil,TamSX3("D3_UM")[1]+2)
	oCel10:oFontBody := oFont10	
	oCel11 := TRCell():New(oSection,"D3_CUSTO1"	,"", "Custo"		,Nil,TamSX3("D3_CUSTO1")[1]+2)
	oCel11:oFontBody := oFont10	
    oCel12 := TRCell():New(oSection,"D3_OP"	,"", "Ordem Produção"		,Nil,TamSX3("D3_OP")[1]+2)
	oCel12:oFontBody := oFont10
	oCel13 := TRCell():New(oSection,"D3_CC"	,"", "Centro Custo"		,Nil,TamSX3("D3_CC")[1]+2)
	oCel13:oFontBody := oFont10
	oCel14 := TRCell():New(oSection,"D3_TURNO"	,"", "Turno"		,Nil,TamSX3("D3_TURNO")[1]+2)
	oCel14:oFontBody := oFont10		
	oCel15 := TRCell():New(oSection,"D3_REQUIS"	,"", "Usuario"		,Nil,TamSX3("D3_REQUIS")[1]+2)
	oCel15:oFontBody := oFont10
	oCel16 := TRCell():New(oSection,"D3_ZZRNCOB"	,"", "Observação" ,Nil,TamSX3("D3_ZZRNCOB")[1]+2)
	oCel16:oFontBody := oFont10
	                              
	oBreak	:= TRBreak():New(oSection,oSection:Cell("D3_TM"),'Total TM')
	oBreak:oFontBody := oFont09B
	oTotValor:= TRFunction():New(oSection:Cell("D3_QUANT"),NIL,"SUM",oBreak," ",PesqPict("SD3","D3_QUANT"),NIL,.F.,.F.)
	oTotValor:oFontBody := oFont09B
	oTotValor:= TRFunction():New(oSection:Cell("D3_QTSEGUM"),NIL,"SUM",oBreak," ",PesqPict("SD3","D3_QTSEGUM"),NIL,.F.,.F.)
	oTotValor:oFontBody := oFont09B
	oTotValor:= TRFunction():New(oSection:Cell("D3_CUSTO1"),NIL,"SUM",oBreak," ",PesqPict("SD3","D3_CUSTO1"),NIL,.F.,.F.)
	oTotValor:oFontBody := oFont09B
		
   // oBreak2	:= TRBreak():New(oSection,oSection:Cell("D3_COD"),'Total Produto')
	//oBreak2:oFontBody := oFont09B
	//oTotValor:= TRFunction():New(oSection:Cell("D3_QUANT"),NIL,"SUM",oBreak2," ",PesqPict("SD3","D3_QUANT"),NIL,.F.,.F.)
	//oTotValor:oFontBody := oFont09B
	//oTotValor:= TRFunction():New(oSection:Cell("D3_QTSEGUM"),NIL,"SUM",oBreak2," ",PesqPict("SD3","D3_QTSEGUM"),NIL,.F.,.F.)
	//oTotValor:oFontBody := oFont09B 
	//oTotValor:= TRFunction():New(oSection:Cell("D3_CUSTO1"),NIL,"SUM",oBreak2," ",PesqPict("SD3","D3_CUSTO1"),NIL,.F.,.F.)
	//oTotValor:oFontBody := oFont09B
	
	oBreak3 := TRBreak():New( oSection, { || }, "Total Geral")
	oBreak3:oFontBody := oFont09B
	oTotValor:= TRFunction():New(oSection:Cell("D3_QUANT"),NIL,"SUM",oBreak3," ",PesqPict("SD3","D3_QUANT"),NIL,.F.,.F.)
	oTotValor:oFontBody := oFont09B
	oTotValor:= TRFunction():New(oSection:Cell("D3_QTSEGUM"),NIL,"SUM",oBreak3," ",PesqPict("SD3","D3_QTSEGUM"),NIL,.F.,.F.)
	oTotValor:oFontBody := oFont09B
    oTotValor:= TRFunction():New(oSection:Cell("D3_CUSTO1"),NIL,"SUM",oBreak3," ",PesqPict("SD3","D3_CUSTO1"),NIL,.F.,.F.)
	oTotValor:oFontBody := oFont09B
   
	oCel8:SetAlign("RIGHT")
	oCe20:SetAlign("RIGHT")  
	oCe20:SetAlign("RIGHT") 
	
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
			oSec1:Cell("D3_TM"):Setvalue((oMBrowse:cAlias)->D3_TM)
			
			
			oSec1:Cell("D3_FILIAL"):Setvalue((oMBrowse:cAlias)->D3_FILIAL)
			oSec1:Cell("D3_TM"):Setvalue((oMBrowse:cAlias)->D3_TM)
			oSec1:Cell("D3_EMISSAO"):Setvalue((oMBrowse:cAlias)->D3_EMISSAO)
			oSec1:Cell("D3_COD"):Setvalue((oMBrowse:cAlias)->D3_COD)
			oSec1:Cell("B1_DESC"):Setvalue((oMBrowse:cAlias)->B1_DESC)
			oSec1:Cell("D3_QUANT"):Setvalue((oMBrowse:cAlias)->D3_QUANT)
			oSec1:Cell("D3_UM"):Setvalue((oMBrowse:cAlias)->D3_UM)
			oSec1:Cell("D3_QTSEGUM"):Setvalue((oMBrowse:cAlias)->D3_QTSEGUM)
			oSec1:Cell("D3_SEGUM"):Setvalue((oMBrowse:cAlias)->D3_SEGUM)			
			oSec1:Cell("D3_CUSTO1"):Setvalue((oMBrowse:cAlias)->D3_CUSTO1)	
			oSec1:Cell("D3_OP"):Setvalue((oMBrowse:cAlias)->D3_OP)
			oSec1:Cell("D3_CC"):Setvalue((oMBrowse:cAlias)->D3_CC)		
			oSec1:Cell("D3_REQUIS"):Setvalue((oMBrowse:cAlias)->D3_REQUIS)
			oSec1:Cell("D3_TURNO"):Setvalue((oMBrowse:cAlias)->D3_TURNO)			
			oSec1:Cell("D3_ZZRNCOB"):Setvalue((oMBrowse:cAlias)->D3_ZZRNCOB)			
						
			
			oSec1:PrintLine()

		EndIf
	(oMBrowse:cAlias)->(dbSkip())
	EndDo

	oSec1:Finish()
	oReport:sKIPLINE()
	RestArea(aArea)
	
Return