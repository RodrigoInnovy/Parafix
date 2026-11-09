//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
	
//Constantes
#Define STR_PULA		Chr(13)+Chr(10)
	
/*/{Protheus.doc} ZPEDAUTO
Relatório - Vendas Detalhadas Auto/Ind.   
@author zReport
@since 02/03/2023
@version 1.0
	@example
	u_ZPEDAUTO()
	@obs Função gerada pelo zReport()
/*/
	
User Function ZPEDAUTO()
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
	oReport := TReport():New(	"ZPEDAUTO",;		//Nome do Relatório
								"Vendas Detalhadas Auto/Ind.",;		//Título
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
	TRCell():New(oSectDad, "DATA_FATURAM", "QRY_AUX", "Data_faturam", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CLIENTE", "QRY_AUX", "Cliente", /*Picture*/, 25, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "COD_CLIE", "QRY_AUX", "Cod_clie", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "LOJA", "QRY_AUX", "Loja", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DESTINO", "QRY_AUX", "Destino", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NUM_PEDIDO", "QRY_AUX", "Num_pedido", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ITEM", "QRY_AUX", "Item", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PRODUTO", "QRY_AUX", "Produto", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DESCR", "QRY_AUX", "Descr", /*Picture*/, 25, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "QUANT1", "QRY_AUX", "Quant1", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "UNIDADE1", "QRY_AUX", "Unidade1", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "QUANT2", "QRY_AUX", "Quant2", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "UNIDADE2", "QRY_AUX", "Unidade2", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PRECO_UNIT", "QRY_AUX", "Preco_unit", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "MOEDA", "QRY_AUX", "Moeda", /*Picture*/, 5, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "TAXA_MOEDA", "QRY_AUX", "Taxa_moeda", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "TOTAL_REAIS", "QRY_AUX", "Total_reais", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "C6_CF", "QRY_AUX", "Cod. Fiscal", /*Picture*/, 5, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NOTA_FISCAL", "QRY_AUX", "Nota_fiscal", /*Picture*/, 9, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "STATUS_PEDIDO", "QRY_AUX", "Status_pedido", /*Picture*/, 16, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "COND_PAGAMENTO", "QRY_AUX", "Cond_pagamento", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "FAMILIA_CLIENTE", "QRY_AUX", "Familia_cliente", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "FAMILIA_PRODUTO", "QRY_AUX", "Familia_produto", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VENDEDOR", "QRY_AUX", "Vendedor", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "STATUS_ENTREGA", "QRY_AUX", "Status_entrega", /*Picture*/, 8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DATA_EMISSAO", "QRY_AUX", "Data_emissao", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DATA_INPUT", "QRY_AUX", "Data_input", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DATA_FATU", "QRY_AUX", "Data_fatu", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ENTREG_CLIE", "QRY_AUX", "Entreg_clie", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ENTREG_PARAFIX", "QRY_AUX", "Entreg_parafix", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "QUANT_ORIGINAL1", "QRY_AUX", "Quant_original1", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
Return oReport
	
/*-------------------------------------------------------------------------------*
 | Func:  fRepPrint                                                              |
 | Desc:  Função que imprime o relatório                                         |
 *-------------------------------------------------------------------------------*/
	
Static Function fRepPrint(oReport)
	U_PRECONET02()
	Local aArea    := GetArea()
	Local cQryAux  := ""
	Local oSectDad := Nil
	Local nAtual   := 0
	Local nTotal   := 0
	
	//Pegando as seções do relatório
	oSectDad := oReport:Section(1)
	
	//Montando consulta de dados
	cQryAux := ""
	cQryAux += "SELECT FORMAT(CONVERT(DATE,DBO.SC6010.C6_DTENTRG,103),'dd/MM/yyyy') AS DATA_FATURAM, A1_NOME AS CLIENTE, C5_CLIENTE AS COD_CLIE, C5_LOJACLI AS LOJA, CASE WHEN A1_EST = 'EX' THEN 'EXPORTACAO' ELSE 'NACIONAL' END AS DESTINO,"		+ STR_PULA
	cQryAux += "C6_NUM AS NUM_PEDIDO, C6_ITEM AS ITEM, C6_PRODUTO AS PRODUTO,B1_DESC AS DESCR, C6_QTDVEN AS QUANT1, C6_UM AS UNIDADE1, C6_UNSVEN AS QUANT2, C6_SEGUM AS UNIDADE2,C6_ZPRCNET AS PRECO_UNIT,"		+ STR_PULA
	cQryAux += "CASE WHEN C5_MOEDA='1' THEN 'REAIS' WHEN C5_MOEDA='2' THEN 'DOLAR' ELSE 'EURO' END AS MOEDA, C5_TXMOEDA AS TAXA_MOEDA, ROUND(C6_ZPRCNET*C5_TXMOEDA*C6_QTDVEN,2) AS TOTAL_REAIS, C6_CF, C6_NOTA AS NOTA_FISCAL,"		+ STR_PULA
	cQryAux += "CASE WHEN (C6_QTDENT > 0 AND C6_QTDENT < C6_QTDVEN) THEN 'FATURADO PARCIAL' WHEN (C6_QTDENT > 0 AND C6_QTDENT >= C6_QTDVEN) THEN 'FATURADO' ELSE 'ABERTO' END AS STATUS_PEDIDO,"		+ STR_PULA
	cQryAux += "E4_DESCRI AS COND_PAGAMENTO, A1_ZZMKT AS FAMILIA_CLIENTE, B1_ZZLP AS FAMILIA_PRODUTO, A3_NREDUZ AS VENDEDOR, CASE WHEN C6_ENTREG > C6_ZZDTCLI THEN 'ATRASADO' ELSE 'EM DIA' END AS STATUS_ENTREGA,"		+ STR_PULA
	cQryAux += "FORMAT(CONVERT(DATE,DBO.SC5010.C5_EMISSAO,103),'dd/MM/yyyy') AS DATA_EMISSAO, FORMAT(CONVERT(DATE,DBO.SC6010.C6_ZDTIMP,103),'dd/MM/yyyy') AS DATA_INPUT, FORMAT(CONVERT(DATE,DBO.SC6010.C6_DTENTRG,103),'dd/MM/yyyy') AS DATA_FATU,"		+ STR_PULA
	cQryAux += "FORMAT(CONVERT(DATE,DBO.SC6010.C6_ZZDTCLI,103),'dd/MM/yyyy') AS ENTREG_CLIE, FORMAT(CONVERT(DATE,DBO.SC6010.C6_ENTREG,103),'dd/MM/yyyy') AS ENTREG_PARAFIX, DBO.SC6010.C6_ZQTDORI as QUANT_ORIGINAL1"		+ STR_PULA
	cQryAux += "FROM					DBO.SB1010 INNER JOIN"		+ STR_PULA
	cQryAux += "                         DBO.SC6010 ON DBO.SB1010.B1_COD = DBO.SC6010.C6_PRODUTO AND SB1010.D_E_L_E_T_='' LEFT OUTER JOIN"		+ STR_PULA
	cQryAux += "                         DBO.SC5010 INNER JOIN"		+ STR_PULA
	cQryAux += "                         DBO.SE4010 ON DBO.SC5010.C5_CONDPAG = DBO.SE4010.E4_CODIGO AND DBO.SC5010.C5_FILIAL = DBO.SE4010.E4_FILIAL AND SE4010.D_E_L_E_T_ ='' LEFT OUTER JOIN  "		+ STR_PULA
	cQryAux += "                         DBO.SA3010 LEFT OUTER JOIN"		+ STR_PULA
	cQryAux += "                         DBO.SA1010 ON DBO.SA3010.A3_COD = DBO.SA1010.A1_VEND ON DBO.SC5010.C5_CLIENTE = DBO.SA1010.A1_COD AND DBO.SC5010.C5_LOJACLI = DBO.SA1010.A1_LOJA ON DBO.SC6010.C6_NUM = DBO.SC5010.C5_NUM AND "		+ STR_PULA
	cQryAux += "                         DBO.SC6010.C6_FILIAL = DBO.SC5010.C5_FILIAL"		+ STR_PULA
	cQryAux += "WHERE        (DBO.SC6010.C6_DTENTRG BETWEEN '"+ DTOS(MV_PAR01) +"' AND '"+ DTOS(MV_PAR02) +"') AND (DBO.SC6010.D_E_L_E_T_ = '') AND (C5_TIPO = 'N' OR C5_TIPO = 'C') AND (C6_FILIAL = '01') AND (C6_CF IN ('5101', '5102', '5105', '5106', '5122', '5125', '6101', '6102', '6105', '6106', '6125', '6122', '7101', '7102', '7127', '5123', '6107', '6114', '6123'))"		+ STR_PULA
	cQryAux += "AND (C6_TES <> '5VX' OR C6_TES <> '5XX') AND (C6_BLQ <> 'R') AND A1_ZZMKT IN ('AUTOMOTIVE','OTHERS IND.')                   "		+ STR_PULA
	cQryAux += "ORDER BY C6_DTENTRG"		+ STR_PULA
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
