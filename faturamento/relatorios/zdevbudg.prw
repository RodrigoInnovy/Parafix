//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
	
//Constantes
#Define STR_PULA		Chr(13)+Chr(10)
	
/*/{Protheus.doc} zDevBudg
Relatório - Devolucoes Budget             
@author zReport
@since 24/01/2023
@version 1.0
	@example
	u_zDevBudg()
	@obs Função gerada pelo zReport()
/*/
	
User Function zDevBudg()
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
	oReport := TReport():New(	"zDevBudg",;		//Nome do Relatório
								"Devolucoes Budget",;		//Título
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
	TRCell():New(oSectDad, "MES_DEVOLUCAO", "QRY_AUX", "Mes_devolucao", /*Picture*/, 20, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "QUANTIDADE_1", "QRY_AUX", "Quantidade_1", /*Picture*/, 20, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VALOR_REAIS", "QRY_AUX", "Valor_reais", /*Picture*/, 20, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "FAMILIA_CLIENTE", "QRY_AUX", "Familia_cliente", /*Picture*/, 20, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VENDEDOR", "QRY_AUX", "Vendedor", /*Picture*/, 20, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
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
	cQryAux += "SELECT CASE WHEN FORMAT(CONVERT(DATE,DBO.SF1010.F1_EMISSAO,103),'MM') = '01' THEN 'JANUARY' WHEN FORMAT(CONVERT(DATE,DBO.SF1010.F1_EMISSAO,103),'MM') = '02' THEN 'FEBRUARY' WHEN FORMAT(CONVERT(DATE,DBO.SF1010.F1_EMISSAO,103),'MM') = '03' THEN 'MARCH'"		+ STR_PULA
	cQryAux += "WHEN FORMAT(CONVERT(DATE,DBO.SF1010.F1_EMISSAO,103),'MM') = '04' THEN 'APRIL' WHEN FORMAT(CONVERT(DATE,DBO.SF1010.F1_EMISSAO,103),'MM') = '05' THEN 'MAY' WHEN FORMAT(CONVERT(DATE,DBO.SF1010.F1_EMISSAO,103),'MM') = '06' THEN 'JUNE'"		+ STR_PULA
	cQryAux += "WHEN FORMAT(CONVERT(DATE,DBO.SF1010.F1_EMISSAO,103),'MM') = '07' THEN 'JULY' WHEN FORMAT(CONVERT(DATE,DBO.SF1010.F1_EMISSAO,103),'MM') = '08' THEN 'AUGUST' WHEN FORMAT(CONVERT(DATE,DBO.SF1010.F1_EMISSAO,103),'MM') = '09' THEN 'SEPTEMBER'"		+ STR_PULA
	cQryAux += "WHEN FORMAT(CONVERT(DATE,DBO.SF1010.F1_EMISSAO,103),'MM') = '10' THEN 'OCTOBER' WHEN FORMAT(CONVERT(DATE,DBO.SF1010.F1_EMISSAO,103),'MM') = '11' THEN 'NOVEMBER' WHEN FORMAT(CONVERT(DATE,DBO.SF1010.F1_EMISSAO,103),'MM') = '12' THEN 'DECEMBER' END AS MES_DEVOLUCAO, "		+ STR_PULA
	cQryAux += "SUM(DBO.SD1010.D1_QUANT) AS QUANTIDADE_1, SUM((D1_TOTAL-D1_VALICM-D1_VALIMP6-D1_VALIMP5)) AS VALOR_REAIS, DBO.SA1010.A1_ZZMKT AS FAMILIA_CLIENTE, DBO.SA3010.A3_NREDUZ AS VENDEDOR"		+ STR_PULA
	cQryAux += "FROM            DBO.SF1010 INNER JOIN"		+ STR_PULA
	cQryAux += "                         DBO.SD1010 ON DBO.SF1010.F1_FILIAL = DBO.SD1010.D1_FILIAL AND DBO.SF1010.F1_DOC = DBO.SD1010.D1_DOC AND DBO.SF1010.F1_FORNECE = DBO.SD1010.D1_FORNECE AND "		+ STR_PULA
	cQryAux += "                         DBO.SF1010.F1_LOJA = DBO.SD1010.D1_LOJA INNER JOIN"		+ STR_PULA
	cQryAux += "                         DBO.SA1010 ON DBO.SF1010.F1_FORNECE = DBO.SA1010.A1_COD AND DBO.SF1010.F1_LOJA = DBO.SA1010.A1_LOJA LEFT OUTER JOIN"		+ STR_PULA
	cQryAux += "                         DBO.SA3010 ON DBO.SA1010.A1_FILIAL = DBO.SA3010.A3_FILIAL AND DBO.SA1010.A1_VEND = DBO.SA3010.A3_COD RIGHT OUTER JOIN"		+ STR_PULA
	cQryAux += "                         DBO.SB1010 ON DBO.SD1010.D1_COD = DBO.SB1010.B1_COD"		+ STR_PULA
	cQryAux += "WHERE        (F1_EMISSAO BETWEEN '"+ DTOS(MV_PAR01) +"' AND '"+ DTOS(MV_PAR02) +"') AND (DBO.SF1010.F1_TIPO = 'D') AND (DBO.SF1010.D_E_L_E_T_ = '') AND (DBO.SD1010.D_E_L_E_T_ = '') AND (D1_CF NOT IN ('1949','2949','3949'))"		+ STR_PULA
	cQryAux += "GROUP BY FORMAT(CONVERT(DATE,DBO.SF1010.F1_EMISSAO,103),'MM'), A1_ZZMKT, A3_NREDUZ"		+ STR_PULA
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
