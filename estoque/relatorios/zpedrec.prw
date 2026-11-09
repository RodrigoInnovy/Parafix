// Relatório onde informa a quantidade do Pedido de Compras em aberto/ a receber. 
//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
	
//Constantes
#Define STR_PULA		Chr(13)+Chr(10)
	
/*/{Protheus.doc} zPedRec
Relatório - Pedidos a Reber               
@author zReport
@since 25/05/2023
@version 1.0
	@example
	u_zPedRec()
	@obs Função gerada pelo zReport()
/*/
	
User Function zPedRec()
	Local aArea   := GetArea()
	Local oReport
	Local lEmail  := .F.
	Local cPara   := ""
	Private cPerg := ""
	
	//Definições da pergunta
	cPerg := "ZPEDREC"
	
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
	oReport := TReport():New(	"zPedRec",;		//Nome do Relatório
								"Pedidos a Receber",;		//Título
								cPerg,;		//Pergunte ... Se eu defino a pergunta aqui, será impresso uma página com os parâmetros, conforme privilégio 101
								{|oReport| fRepPrint(oReport)},;		//Bloco de código que será executado na confirmação da impressão
								)		//Descrição
	oReport:SetTotalInLine(.F.)
	oReport:lParamPage := .F.
	oReport:oPage:SetPaperSize(9) //Folha A4
	oReport:SetPortrait()
	oReport:SetLineHeight(50)
	oReport:nFontBody := 08
	
	//Criando a seção de dados
	oSectDad := TRSection():New(	oReport,;		//Objeto TReport que a seção pertence
									"Dados",;		//Descrição da seção
									{"QRY_AUX"})		//Tabelas utilizadas, a primeira será considerada como principal da seção
	oSectDad:SetTotalInLine(.F.)  //Define se os totalizadores serão impressos em linha ou coluna. .F.=Coluna; .T.=Linha
	
	//Colunas do relatório
	TRCell():New(oSectDad, "DATA_RECEBIMENTO", "QRY_AUX", "Data_recebimento", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DATA_EMISSAO", "QRY_AUX", "Data_emissao", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PEDIDO", "QRY_AUX", "Pedido", /*Picture*/, 8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PRODUTO", "QRY_AUX", "Produto", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DESCR", "QRY_AUX", "Descr", /*Picture*/, 25, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "FORNECEDOR", "QRY_AUX", "Fornecedor", /*Picture*/, 25, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "QUANT", "QRY_AUX", "Quant", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "QUANT_RECEBIDA", "QRY_AUX", "Quant_recebida", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "SALDO_RECEBER", "QRY_AUX", "Saldo_receber", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "C7_UM", "QRY_AUX", "Unidade", /*Picture*/, 3, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ARMAZEM_01", "QRY_AUX", "Armazem_01", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ARMAZEM_11", "QRY_AUX", "Armazem_11", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
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
	cQryAux += "SELECT        FORMAT(CONVERT(DATE,C7_DATPRF,103),'dd/MM/yyyy') AS DATA_RECEBIMENTO, FORMAT(CONVERT(DATE,DBO.SC7010.C7_EMISSAO,103),'dd/MM/yyyy') AS DATA_EMISSAO, DBO.SC7010.C7_NUM AS PEDIDO, DBO.SC7010.C7_PRODUTO AS PRODUTO, "		+ STR_PULA
	cQryAux += "DBO.SC7010.C7_DESCRI AS DESCR, DBO.SA2010.A2_NOME AS FORNECEDOR, ROUND(DBO.SC7010.C7_QUANT,2) AS QUANT, ROUND(DBO.SC7010.C7_QUJE,2) AS QUANT_RECEBIDA, ROUND(SC7010.C7_QUANT-SC7010.C7_QUJE,2) AS SALDO_RECEBER, DBO.SC7010.C7_UM, "		+ STR_PULA
	cQryAux += "CASE WHEN SB2A.B2_QATU IS NULL THEN 0 ELSE ROUND(SB2A.B2_QATU,2) END AS ARMAZEM_01, CASE WHEN SB2B.B2_QATU IS NULL THEN 0 ELSE ROUND(SB2B.B2_QATU,2) END AS ARMAZEM_11"		+ STR_PULA
	cQryAux += "FROM            DBO.SC7010  INNER JOIN"		+ STR_PULA
	cQryAux += "                         DBO.SA2010 ON DBO.SC7010.C7_FORNECE = DBO.SA2010.A2_COD AND DBO.SC7010.C7_LOJA = DBO.SA2010.A2_LOJA AND (SA2010.D_E_L_E_T_='') LEFT OUTER JOIN"		+ STR_PULA
	cQryAux += "                         DBO.SB2010 AS SB2A ON DBO.SC7010.C7_FILIAL = SB2A.B2_FILIAL AND DBO.SC7010.C7_PRODUTO = SB2A.B2_COD AND (SB2A.B2_LOCAL = '01')  AND (SB2A.D_E_L_E_T_='') LEFT OUTER JOIN "		+ STR_PULA
	cQryAux += "                         DBO.SB2010 AS SB2B ON DBO.SC7010.C7_FILIAL = SB2B.B2_FILIAL AND DBO.SC7010.C7_PRODUTO = SB2B.B2_COD "		+ STR_PULA
	cQryAux += "						 AND (SB2B.B2_LOCAL = '11') AND (SB2B.D_E_L_E_T_='') "		+ STR_PULA
	cQryAux += "WHERE        (DBO.SC7010.D_E_L_E_T_ = '') AND (DBO.SC7010.C7_ENCER = '') AND (DBO.SC7010.C7_RESIDUO <> 'S') AND (SC7010.C7_QUANT-SC7010.C7_QUJE >='1') AND (SC7010.C7_PRODUTO NOT LIKE '9%')"		+ STR_PULA
	cQryAux += "AND (C7_DATPRF BETWEEN '"+ DTOS(MV_PAR01) +"' AND '"+ DTOS(MV_PAR02) +"')"		+ STR_PULA
	cQryAux += "ORDER BY C7_DATPRF,C7_NUM"		+ STR_PULA
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
