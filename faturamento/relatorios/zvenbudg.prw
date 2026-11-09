//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
	
//Constantes
#Define STR_PULA		Chr(13)+Chr(10)
	
/*/{Protheus.doc} zVenBudg
Relatório - Vendas Budget                 
@author zReport
@since 24/01/2023
@version 1.0
	@example
	u_zVenBudg()
	@obs Função gerada pelo zReport()
/*/
	
User Function zVenBudg()
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
	oReport := TReport():New(	"zVenBudg",;		//Nome do Relatório
								"Vendas Budget",;		//Título
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
	TRCell():New(oSectDad, "MES_FAT", "QRY_AUX", "Mes_fat", /*Picture*/, 20, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "QUANT1", "QRY_AUX", "Quant1", /*Picture*/, 20, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "TOTAL_REAIS", "QRY_AUX", "Total_reais", /*Picture*/, 20, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "FAMILIA_CLIENTE", "QRY_AUX", "Familia_cliente", /*Picture*/, 20, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VENDEDOR", "QRY_AUX", "Vendedor", /*Picture*/, 20, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
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
	cQryAux += "SELECT CASE WHEN FORMAT(CONVERT(DATE,DBO.SC6010.C6_DTENTRG,103),'MM') = '01' THEN 'JANUARY' WHEN FORMAT(CONVERT(DATE,DBO.SC6010.C6_DTENTRG,103),'MM') = '02' THEN 'FEBRUARY' WHEN FORMAT(CONVERT(DATE,DBO.SC6010.C6_DTENTRG,103),'MM') = '03' THEN 'MARCH'"		+ STR_PULA
	cQryAux += "WHEN FORMAT(CONVERT(DATE,DBO.SC6010.C6_DTENTRG,103),'MM') = '04' THEN 'APRIL' WHEN FORMAT(CONVERT(DATE,DBO.SC6010.C6_DTENTRG,103),'MM') = '05' THEN 'MAY' WHEN FORMAT(CONVERT(DATE,DBO.SC6010.C6_DTENTRG,103),'MM') = '06' THEN 'JUNE'"		+ STR_PULA
	cQryAux += "WHEN FORMAT(CONVERT(DATE,DBO.SC6010.C6_DTENTRG,103),'MM') = '07' THEN 'JULY' WHEN FORMAT(CONVERT(DATE,DBO.SC6010.C6_DTENTRG,103),'MM') = '08' THEN 'AUGUST' WHEN FORMAT(CONVERT(DATE,DBO.SC6010.C6_DTENTRG,103),'MM') = '09' THEN 'SEPTEMBER'"		+ STR_PULA
	cQryAux += "WHEN FORMAT(CONVERT(DATE,DBO.SC6010.C6_DTENTRG,103),'MM') = '10' THEN 'OCTOBER' WHEN FORMAT(CONVERT(DATE,DBO.SC6010.C6_DTENTRG,103),'MM') = '11' THEN 'NOVEMBER' WHEN FORMAT(CONVERT(DATE,DBO.SC6010.C6_DTENTRG,103),'MM') = '12' THEN 'DECEMBER' END AS MES_FAT,"		+ STR_PULA
	cQryAux += "SUM(C6_QTDVEN) AS QUANT1,"		+ STR_PULA
	cQryAux += "SUM(ROUND(C6_ZPRCNET*C5_TXMOEDA*C6_QTDVEN,2)) AS TOTAL_REAIS, "		+ STR_PULA
	cQryAux += "A1_ZZMKT AS FAMILIA_CLIENTE, A3_NREDUZ AS VENDEDOR"		+ STR_PULA
	cQryAux += "FROM            DBO.SB1010 INNER JOIN"		+ STR_PULA
	cQryAux += "                         DBO.SC6010 ON DBO.SB1010.B1_COD = DBO.SC6010.C6_PRODUTO AND SB1010.D_E_L_E_T_='' LEFT OUTER JOIN"		+ STR_PULA
	cQryAux += "                         DBO.SC5010 INNER JOIN"		+ STR_PULA
	cQryAux += "                         DBO.SE4010 ON DBO.SC5010.C5_CONDPAG = DBO.SE4010.E4_CODIGO AND DBO.SC5010.C5_FILIAL = DBO.SE4010.E4_FILIAL AND SE4010.D_E_L_E_T_ ='' LEFT OUTER JOIN"		+ STR_PULA
	cQryAux += "                         DBO.SA3010 LEFT OUTER JOIN"		+ STR_PULA
	cQryAux += "                         DBO.SA1010 ON DBO.SA3010.A3_COD = DBO.SA1010.A1_VEND ON DBO.SC5010.C5_CLIENTE = DBO.SA1010.A1_COD AND DBO.SC5010.C5_LOJACLI = DBO.SA1010.A1_LOJA ON DBO.SC6010.C6_NUM = DBO.SC5010.C5_NUM AND "		+ STR_PULA
	cQryAux += "                         DBO.SC6010.C6_FILIAL = DBO.SC5010.C5_FILIAL"		+ STR_PULA
	cQryAux += "WHERE        (DBO.SC6010.C6_DTENTRG BETWEEN '"+ DTOS(MV_PAR01) +"' AND '"+ DTOS(MV_PAR02) +"') AND (DBO.SC6010.D_E_L_E_T_ = '') AND (C5_TIPO = 'N' OR C5_TIPO = 'C') AND (C6_FILIAL = '01') AND (C6_CF IN ('5101', '5102', '5105', '5106', '5122', '5125', '6101', '6102', '6105', '6106', '6125', '6122', '7101', '7102', '7127', '5123', '6107', '6114', '6123'))"		+ STR_PULA
	cQryAux += "AND (C6_TES <> '5VX' OR C6_TES <> '5XX') AND (C6_BLQ <> 'R')"		+ STR_PULA
	cQryAux += "GROUP BY  FORMAT(CONVERT(DATE,DBO.SC6010.C6_DTENTRG,103),'MM'),  A1_ZZMKT, A3_NREDUZ"		+ STR_PULA
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
