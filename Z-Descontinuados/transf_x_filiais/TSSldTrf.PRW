#Include 'Protheus.ch'
#Include 'TOPCONN.ch'


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTSSLDTRFบAutor  ณMicrosiga           บ Data ณ  09/17/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑบ 20140917 ณ Alteracao das regras de filtro para utilizacao de          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TSSLDTRF()

If ValidPerg()
	MontaTela()
EndIf
	
Return

Static Function ValidPerg()
	
Local cPerg	:= "Saldo Transf_x_Filial"
Local aPar	:= {}

//Private Opcoes	:= { || Opcoes() }

Aadd(aPar, {1, "Emissao de: ",    STOD(""),               "", "",  "",     "", 50, .F.})   				// MV_PAR01
Aadd(aPar, {1, "Emissao at้: ",   STOD(""),               "", "",  "",     "", 50, .F.})   				// MV_PAR02
Aadd(aPar, {1, "Produto de: ",    Space(TamSX3("Z8_COD")[1]), "",  "",  "SB1", "", 50, .F.})   				// MV_PAR03
Aadd(aPar, {1, "Produto at้: ",   Space(TamSX3("Z8_COD")[1]), "",  "",  "SB1", "", 50, .F.})   				// MV_PAR04

Return (ParamBox(aPar, "Saldo Transf_x_Filial",,,,,,,, cPerg, .T., .T.))

Static Function MontaTela()

	Local cQuery := buscaSelect()
	Local aCoordA:= {6,1,22,100}
	
	Private cCadastro 	:= "Saldo Transf_x_Filial"
	Private aRotina 	:= {}
	Private bPesquisa	:= {|| oMBrowse:Pesquisa()}
	//Private bCadastro	:= {|| InsereNegociacao(), oMBrowse:Refresh()}
	Private bPrintRel	:= {|| PrintRel()}
	Private oMBrowse	:= Nil
	
	aAdd( aRotina , { "Pesquisar" 			, "Eval(bPesquisa)"	, 0 , 1 } )
	aAdd( aRotina , { "Imprimir"			, "Eval(bPrintRel)"	, 0 , 4 } )
	
	oMBrowse := ParafMbrowse():New(aCoordA,"ZSD3",,)
	oMBrowse:cQuery := cQuery

	oMBrowse:aIndex	:= {	{"Remessa"	,"DTOS(Z8_EMISSAO)+Z8_DOC+Z8_SERIE+Z8_ITEM+Z8_COD+Z8_CLIFOR+Z8_LOJA"} }
	
	oMBrowse:cCampoMark := "Z8_OK"
	
	AADD(oMBrowse:aSetFields,{"Z8_EMISSAO","D",nil,nil})
	
	oMBrowse:ExecQuery()
	oMBrowse:Show(.t.)
	oMBrowse:Close()
	
Return

Static Function buscaSelect()
	
	Local cQuery := ""
	
	cQuery := "select '  ' AS Z8_OK, Z8_NRCTRL, Z8_NUMSEQ, Z8_DOC,Z8_SERIE,Z8_ITEM,Z8_COD, B1_DESC, Z8_EMISSAO,Z8_QUANT " + CRLF
	cQuery += ",Z8_UM,Z8_TIPO,Z8_FILORI,Z8_FILDEST,Z8_CLIFOR,Z8_LOJA " + CRLF
	cQuery += ",Z8_NFORIG,Z8_ITEMORI,Z8_SERIORI,Z8_NUMSEQ, Z8_NRCTRL, Z8_SALDO " + CRLF
	cQuery += "FROM "+RetSqlName("SZ8")+ " Z8 " + CRLF
	cQuery += "INNER JOIN "+RetSqlName("SB1")+" B1 ON B1_FILIAL = '"+xFilial("SB1")+"' AND B1_COD = Z8_COD AND B1.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += "WHERE Z8.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += "AND Z8_SERIE <> 'TRF' " + CRLF
	cQuery += "AND Z8_FILORI = '01' " + CRLF
	//cQuery += "AND Z8_NRCTRL <> ' ' " + CRLF
	cQuery += "AND Z8_EMISSAO >= '"+DtoS(mv_par01)+"' " + CRLF
	cQuery += "AND Z8_EMISSAO <= '"+DtoS(mv_par02)+"' " + CRLF
	cQuery += "AND Z8_COD >= '"+mv_par03+"' " + CRLF
	cQuery += "AND Z8_COD <= '"+mv_par04+"' " + CRLF
	cQuery += "ORDER BY 2,3" + CRLF
	
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


	oReport := TReport():New("TSSLDTRF","Saldo Transf_x_Filial",,{|oReport| PrintReport(oReport) })
	oReport:SetLandScape()//Impressao em Paisagem
	oReport:SetTotalInLine(.F.)
		
	oSection := TRSection():New(oReport,"Saldo Transf_x_Filial",(oMBrowse:cAlias))
	oSection:AutoSize()
	oSection:SetTotalInLine(.F.)
	oSection:SetTotalText("Total Geral")

	oCel1 := TRCell():New(oSection,"Z8_TIPO","", "Tipo"		,Nil,TamSX3("Z8_TIPO")[1]+10)
	oCel1:oFontBody := oFont10
	oCel2 := TRCell():New(oSection,"Z8_NRCTRL","", "Nr. Controle",Nil,TamSX3("Z8_NRCTRL")[1]+10)
	oCel2:oFontBody := oFont10	
	oCel3 := TRCell():New(oSection,"Z8_EMISSAO"	,"", "Emissใo",Nil,TamSX3("Z8_EMISSAO")[1]+2)
	oCel3:oFontBody := oFont10
	oCel4 := TRCell():New(oSection,"Z8_DOC","", "Documento"	,Nil,TamSX3("Z8_DOC")[1]+2)
	oCel4:oFontBody := oFont10
	oCel5 := TRCell():New(oSection,"Z8_SERIE","", "Serie"	,Nil,TamSX3("Z8_SERIE")[1]+2)
	oCel5:oFontBody := oFont10
	oCel6:= TRCell():New(oSection,"Z8_ITEM","", "Item"	,Nil,TamSX3("Z8_ITEM")[1]+2)
	oCel6:oFontBody := oFont10	
	oCel7 := TRCell():New(oSection,"Z8_COD"	,"", "Produto"	,Nil,TamSX3("Z8_COD")[1]+2)
	oCel7:oFontBody := oFont10	
	oCel8 := TRCell():New(oSection,"B1_DESC","", "Descricao"	,Nil,TamSX3("B1_DESC")[1]+5)
	oCel8:oFontBody := oFont10
	oCel9 := TRCell():New(oSection,"Z8_QUANT"	,"", "Quantidade",PesqPict("SZ8","Z8_QUANT"),TamSX3("Z8_QUANT")[1]+5)
	oCel9:oFontBody := oFont10
	oCel10 := TRCell():New(oSection,"Z8_UM"	,"", "UM"		,Nil,TamSX3("Z8_UM")[1]+2)
	oCel10:oFontBody := oFont10
	oCel11 := TRCell():New(oSection,"Z8_SALDO","", "Saldo"	,PesqPict("SZ8","Z8_SALDO"),TamSX3("Z8_SALDO")[1]+5)
	oCel11:oFontBody := oFont10
	/*                               
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
	*/
Return (oReport)

Static Function PrintReport(oReport)
	
	Local oSec1		:= oReport:Section(1)
	Local aArea 	:= (oMBrowse:cAlias)->(GetArea())
	Local cQry := " "
		
	(oMBrowse:cAlias)->(oReport:SetMeter(RecCount()))
	oSec1:Init()
	
	(oMBrowse:cAlias)->(dbGoTop())
	Do While ( (oMBrowse:cAlias)->(!Eof()) )
		
		If oReport:Cancel()
			Exit
		EndIf
		If (oMBrowse:cAlias)->(IsMark(oMBrowse:cCampoMark,oMBrowse:cMarca ))
			oSec1:Cell("Z8_DOC"):Setvalue((oMBrowse:cAlias)->Z8_DOC)

			oSec1:Cell("Z8_TIPO"):Setvalue(If((oMBrowse:cAlias)->Z8_TIPO = "R","Remessa","Devolucao"))
			oSec1:Cell("Z8_NRCTRL"):Setvalue((oMBrowse:cAlias)->Z8_NRCTRL)
			oSec1:Cell("Z8_EMISSAO"):Setvalue((oMBrowse:cAlias)->Z8_EMISSAO)
			oSec1:Cell("Z8_DOC"):Setvalue(Alltrim((oMBrowse:cAlias)->Z8_DOC))
			oSec1:Cell("Z8_SERIE"):Setvalue(Alltrim((oMBrowse:cAlias)->Z8_SERIE))
			oSec1:Cell("Z8_ITEM"):Setvalue((oMBrowse:cAlias)->Z8_ITEM)
			oSec1:Cell("Z8_COD"):Setvalue((oMBrowse:cAlias)->Z8_COD)
			oSec1:Cell("B1_DESC"):Setvalue((oMBrowse:cAlias)->B1_DESC)
			oSec1:Cell("Z8_QUANT"):Setvalue((oMBrowse:cAlias)->Z8_QUANT)
			oSec1:Cell("Z8_UM"):Setvalue((oMBrowse:cAlias)->Z8_UM)
			oSec1:Cell("Z8_SALDO"):Setvalue((oMBrowse:cAlias)->Z8_SALDO)			
			
			oSec1:PrintLine()
            
            If (oMBrowse:cAlias)->Z8_SALDO < (oMBrowse:cAlias)->Z8_QUANT
				
				cQry := "SELECT Z8_NRCTRL, Z8_NUMSEQ, Z8_DOC,Z8_SERIE,Z8_ITEM,Z8_COD, B1_DESC, Z8_EMISSAO,Z8_QUANT " + CRLF
				cQry += ",Z8_UM,Z8_TIPO,Z8_FILORI,Z8_FILDEST,Z8_CLIFOR,Z8_LOJA " + CRLF
				cQry += ",Z8_NFORIG,Z8_ITEMORI,Z8_SERIORI,Z8_NUMSEQ, Z8_NRCTRL, Z8_SALDO " + CRLF
				cQry += "FROM "+RetSqlName("SZ8")+ " Z8 " + CRLF
				cQry += "INNER JOIN "+RetSqlName("SB1")+" B1 ON B1_FILIAL = '"+xFilial("SB1")+"' AND B1_COD = Z8_COD AND B1.D_E_L_E_T_ = ' ' " + CRLF
				cQry += "WHERE Z8.D_E_L_E_T_ = ' ' " + CRLF
				cQry += "AND Z8_SERIE <> 'TRF' " + CRLF
				cQry += "AND Z8_FILORI = '02' " + CRLF
				cQry += "AND Z8_NRCTRL = '"+(oMBrowse:cAlias)->Z8_NRCTRL+"' " + CRLF
				cQry += "AND Z8_TIPO = 'D' " + CRLF
				cQry += "ORDER BY 2,3" + CRLF

				cQry := ChangeQuery(cQry)
				
				TCQuery cQry New Alias "TSZ8"
						
				DBSelectArea("TSZ8")
				//DBGoTop()
				While !Eof()
					oSec1:Cell("Z8_TIPO"):Setvalue(If(TSZ8->Z8_TIPO = "R","Remessa","Devolucao"))
					oSec1:Cell("Z8_NRCTRL"):Setvalue(TSZ8->Z8_NRCTRL)
					oSec1:Cell("Z8_EMISSAO"):Setvalue(StoD(TSZ8->Z8_EMISSAO))
					oSec1:Cell("Z8_DOC"):Setvalue(Alltrim(TSZ8->Z8_DOC))
					oSec1:Cell("Z8_SERIE"):Setvalue(Alltrim(TSZ8->Z8_SERIE))
					oSec1:Cell("Z8_ITEM"):Setvalue(TSZ8->Z8_ITEM)
					oSec1:Cell("Z8_COD"):Setvalue(TSZ8->Z8_COD)
					oSec1:Cell("B1_DESC"):Setvalue(TSZ8->B1_DESC)
					oSec1:Cell("Z8_QUANT"):Setvalue(TSZ8->Z8_QUANT)
					oSec1:Cell("Z8_UM"):Setvalue(TSZ8->Z8_UM)
					oSec1:Cell("Z8_SALDO"):Setvalue(TSZ8->Z8_SALDO)			
					
					oSec1:PrintLine()
					TSZ8->(dbskip())
				End
				TSZ8->(DBCloseArea())	

			EndIf
		EndIf
	(oMBrowse:cAlias)->(dbSkip())
	EndDo

	oSec1:Finish()
	oReport:sKIPLINE()
	RestArea(aArea)
	
Return