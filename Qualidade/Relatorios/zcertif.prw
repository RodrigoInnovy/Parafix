//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
	
//Constantes
#Define STR_PULA		Chr(13)+Chr(10)
	
/*/{Protheus.doc} zCertif
Relatório - Nf´s Emitir Certificados      
@author zReport
@since 12/04/2023
@version 1.0
	@example
	u_zCertif()
	@obs Função gerada pelo zReport()
/*/
	
User Function zCertif()
	Local aArea   := GetArea()
	Local oReport
	Local lEmail  := .F.
	Local cPara   := ""
	Private cPerg := ""
	
	//Definições da pergunta
	cPerg := "ZPEDIDOS"
	
	//Se a pergunta não existir, zera a variável
	DbSelectArea("SX1")
	SX1->(DbSetOrder(1)) //X1_GRUPO + X1_ORDEM
	If ! SX1->(DbSeek(cPerg))
		cPerg := Nil
	EndIf
	
	//Cria as definições do relatório
	oReport := fReportDef()
	
	//Será enviado por e-Mail?
	If lEmail
		oReport:nRemoteType := NO_REMOTE
		oReport:cEmail := cPara
		oReport:nDevice := 4 //1-Arquivo,2-Impressora,3-email,4-Planilha e 5-Html
		oReport:SetPreview(.F.)
		oReport:Print(.F., "", .T.)
	//Senão, mostra a tela
	Else
		oReport:PrintDialog()
	EndIf
	
	RestArea(aArea)
Return
	
/*-------------------------------------------------------------------------------*
 | Func:  fReportDef                                                             |
 | Desc:  Função que monta a definição do relatório                              |
 *-------------------------------------------------------------------------------*/
	
Static Function fReportDef()
	Local oReport
	Local oSectDad := Nil
	Local oBreak := Nil
	
	//Criação do componente de impressão
	oReport := TReport():New(	"zCertif",;		//Nome do Relatório
								"Nf´s Emitir Certificados",;		//Título
								cPerg,;		//Pergunte ... Se eu defino a pergunta aqui, será impresso uma página com os parâmetros, conforme privilégio 101
								{|oReport| fRepPrint(oReport)},;		//Bloco de código que será executado na confirmação da impressão
								)		//Descrição
	oReport:SetTotalInLine(.F.)
	oReport:lParamPage := .F.
	oReport:oPage:SetPaperSize(9) //Folha A4
	oReport:SetPortrait()
	oReport:SetLineHeight(55)
	oReport:nFontBody := 9
	
	//Criando a seção de dados
	oSectDad := TRSection():New(	oReport,;		//Objeto TReport que a seção pertence
									"Dados",;		//Descrição da seção
									{"QRY_AUX"})		//Tabelas utilizadas, a primeira será considerada como principal da seção
	oSectDad:SetTotalInLine(.F.)  //Define se os totalizadores serão impressos em linha ou coluna. .F.=Coluna; .T.=Linha
	
	//Colunas do relatório
	TRCell():New(oSectDad, "DATA", "QRY_AUX", "Data", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NF", "QRY_AUX", "Nf", /*Picture*/, 11, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CLIENTE", "QRY_AUX", "Cliente", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PRODUTO", "QRY_AUX", "Produto", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DESCRI", "QRY_AUX", "Descri", /*Picture*/, 26, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "QAUNT1", "QRY_AUX", "Qaunt1", /*Picture*/, 8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "UM1", "QRY_AUX", "Um1", /*Picture*/, 3, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "QUANT2", "QRY_AUX", "Quant2", /*Picture*/, 8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "UM2", "QRY_AUX", "Um2", /*Picture*/, 3, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "OP_LOTE", "QRY_AUX", "Op_lote", /*Picture*/, 11, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
Return oReport
	
/*-------------------------------------------------------------------------------*
 | Func:  fRepPrint                                                              |
 | Desc:  Função que imprime o relatório                                         |
 *-------------------------------------------------------------------------------*/
	
Static Function fRepPrint(oReport)
	Local aArea    := GetArea()
	Local cQryAux  := ""
	Local oSectDad := Nil
	Local nAtual   := 0
	Local nTotal   := 0
	
	//Pegando as seções do relatório
	oSectDad := oReport:Section(1)
	
	//Montando consulta de dados
	cQryAux := ""
	cQryAux += "SELECT FORMAT(CONVERT(DATE, dbo.SF2010.F2_EMISSAO, 103), 'dd/MM/yyyy') AS Data, dbo.SF2010.F2_DOC AS NF, dbo.SA1010.A1_NOME AS Cliente, dbo.SD2010.D2_COD AS Produto,"+ STR_PULA
	cQryAux += "dbo.SB1010.B1_DESC as Descri, SUM(dbo.SD2010.D2_QUANT) AS Qaunt1, dbo.SD2010.D2_UM AS UM1, SUM(dbo.SD2010.D2_QTSEGUM) AS Quant2, dbo.SD2010.D2_SEGUM AS UM2, dbo.SD3010.D3_OP AS OP_LOTE"+ STR_PULA
	cQryAux += "FROM            dbo.SB1010 LEFT OUTER JOIN"+ STR_PULA
	cQryAux += "                         dbo.SD2010 ON dbo.SB1010.B1_COD = dbo.SD2010.D2_COD LEFT OUTER JOIN"+ STR_PULA
	cQryAux += "                         dbo.SF2010 RIGHT OUTER JOIN"+ STR_PULA
	cQryAux += "                         dbo.SA1010 ON dbo.SF2010.F2_LOJA = dbo.SA1010.A1_LOJA AND dbo.SF2010.F2_CLIENTE = dbo.SA1010.A1_COD ON dbo.SD2010.D2_DOC = dbo.SF2010.F2_DOC FULL OUTER JOIN"+ STR_PULA
	cQryAux += "                         dbo.SD3010 ON dbo.SD2010.D2_COD = dbo.SD3010.D3_COD AND dbo.SD2010.D2_LOTECTL = dbo.SD3010.D3_LOTECTL AND dbo.SD3010.D3_CF = 'PR0' AND dbo.SF2010.D_E_L_E_T_ = '' AND"+ STR_PULA 
	cQryAux += "                         dbo.SD2010.D_E_L_E_T_ = '' AND dbo.SD3010.D_E_L_E_T_ = '' AND dbo.SA1010.D_E_L_E_T_ = '' AND dbo.SB1010.D_E_L_E_T_ = ''"+ STR_PULA
	cQryAux += "WHERE        (dbo.SF2010.F2_EMISSAO BETWEEN '"+ DTOS(MV_PAR01) +"' AND '"+ DTOS(MV_PAR02) +"') AND (dbo.SD2010.D2_TES <> '5VT') AND (F2_TIPO not in ('D','B'))"+ STR_PULA
	cQryAux += "GROUP BY dbo.SF2010.F2_EMISSAO, dbo.SF2010.F2_DOC, dbo.SA1010.A1_NOME, dbo.SD2010.D2_COD, dbo.SB1010.B1_DESC, dbo.SD2010.D2_UM, dbo.SD2010.D2_SEGUM, dbo.SD3010.D3_OP"+ STR_PULA
	cQryAux += "ORDER BY F2_EMISSAO, F2_DOC"+ STR_PULA

	cQryAux := ChangeQuery(cQryAux)
	
	//Executando consulta e setando o total da régua
	TCQuery cQryAux New Alias "QRY_AUX"
	Count to nTotal
	oReport:SetMeter(nTotal)
	
	//Enquanto houver dados
	oSectDad:Init()
	QRY_AUX->(DbGoTop())
	While ! QRY_AUX->(Eof())
		//Incrementando a régua
		nAtual++
		oReport:SetMsgPrint("Imprimindo registro "+cValToChar(nAtual)+" de "+cValToChar(nTotal)+"...")
		oReport:IncMeter()
		
		//Imprimindo a linha atual
		oSectDad:PrintLine()
		
		QRY_AUX->(DbSkip())
	EndDo
	oSectDad:Finish()
	QRY_AUX->(DbCloseArea())
	
	RestArea(aArea)
Return
