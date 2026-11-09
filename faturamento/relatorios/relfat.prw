//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
	
//Constantes
#Define STR_PULA		Chr(13)+Chr(10)
	
/*/{Protheus.doc} relfat
Relatório - Pedidos de venda              
@author zReport
@since 26/03/2021
@version 1.0
	@example
	u_relfat()
	@obs Função gerada pelo zReport()
/*/
	
User Function relfat()
	Local aArea   := GetArea()
	Local oReport
	Local lEmail  := .F.
	Local cPara   := ""
	Private cPerg := ""
	
	//Definições da pergunta
	cPerg := "PEDFAT"
	
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
		oReport:nDevice := 3 //1-Arquivo,2-Impressora,3-email,4-Planilha e 5-Html
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
	Local oFunTot1 := Nil
	
	//Criação do componente de impressão
	oReport := TReport():New(	"relfat",;		//Nome do Relatório
								"Pedidos de venda",;		//Título
								cPerg,;		//Pergunte ... Se eu defino a pergunta aqui, será impresso uma página com os parâmetros, conforme privilégio 101
								{|oReport| fRepPrint(oReport)},;		//Bloco de código que será executado na confirmação da impressão
								)		//Descrição
	oReport:SetTotalInLine(.F.)
	oReport:lParamPage := .F.
	oReport:oPage:SetPaperSize(9) //Folha A4
	oReport:SetLandscape()
	
	//Criando a seção de dados
	oSectDad := TRSection():New(	oReport,;		//Objeto TReport que a seção pertence
									"Dados",;		//Descrição da seção
									{"QRY_AUX"})		//Tabelas utilizadas, a primeira será considerada como principal da seção
	oSectDad:SetTotalInLine(.F.)  //Define se os totalizadores serão impressos em linha ou coluna. .F.=Coluna; .T.=Linha
	
	//Colunas do relatório
	TRCell():New(oSectDad, "C5_CLIENTE", "QRY_AUX", "Cliente", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "C5_LOJACLI", "QRY_AUX", "Loja", /*Picture*/, 4, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "A1_NOME", "QRY_AUX", "Nome", /*Picture*/, 70, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "C5_NUM", "QRY_AUX", "Numero", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "C6_ITEM", "QRY_AUX", "Item", /*Picture*/, 3, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "C6_PRODUTO", "QRY_AUX", "Produto", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "C6_DESCRI", "QRY_AUX", "Descricao", /*Picture*/, 30, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "B1_ZZLP", "QRY_AUX", "Linha Prod", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "C6_UM", "QRY_AUX", "Unidade", /*Picture*/, 7, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "C6_QTDVEN", "QRY_AUX", "Quantidade", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "C6_SEGUM", "QRY_AUX", "Segunda UM", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "C6_UNSVEN", "QRY_AUX", "Qtd Ven 2 UM", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "C6_VALOR", "QRY_AUX", "Vlr.Total", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "EMISSAO", "QRY_AUX", "Emissao", /*Picture*/, 20, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ENTREGA", "QRY_AUX", "Entrega", /*Picture*/, 20, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VENDA", "QRY_AUX", "Venda", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "FATURADO", "QRY_AUX", "Faturado", /*Picture*/, 3, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	
	//Definindo a quebra
	//oBreak := TRBreak():New(oSectDad,{|| QRY_AUX->(C5_CLIENTE) },{|| "SEPARACAO DO RELATORIO" })
	//oSectDad:SetHeaderBreak(.T.)
	
	//Totalizadores
	oFunTot1 := TRFunction():New(oSectDad:Cell("C6_VALOR"),,"SUM",oBreak,,/*cPicture*/)
	oFunTot1:SetEndReport(.F.)
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
	cQryAux += "SELECT DISTINCT C5_CLIENTE, C5_LOJACLI, A1_NOME, C5_NUM, C6_ITEM, C6_PRODUTO, C6_DESCRI, B1_ZZLP, C6_UM, C6_QTDVEN, C6_SEGUM, C6_UNSVEN ,C6_VALOR,  "		+ STR_PULA
	cQryAux += "CONVERT(VARCHAR(20), CAST(C5_EMISSAO AS DATETIME), 103) AS EMISSAO,"		+ STR_PULA
	cQryAux += "CONVERT(VARCHAR(20), CAST(C6_ENTREG AS DATETIME), 103) AS ENTREGA, "		+ STR_PULA
	cQryAux += "CASE WHEN C5_TIPOCLI = 'X' THEN 'EXPORTACAO' ELSE 'NACIONAL' END AS 'VENDA', "		+ STR_PULA
	cQryAux += "CASE WHEN C6_QTDENT = '0' THEN 'NÃO' ELSE 'SIM' END AS 'FATURADO'"		+ STR_PULA
	cQryAux += "FROM SC6010 C6 (NOLOCK),SC5010 C5 (NOLOCK), SA1010 A1 (NOLOCK), SB1010 B1 (NOLOCK)"		+ STR_PULA
	cQryAux += "WHERE C6_FILIAL = C5_FILIAL "		+ STR_PULA
	cQryAux += "AND C6_CLI = C5_CLIENTE "		+ STR_PULA
	cQryAux += "AND C6_LOJA = C5_LOJACLI"		+ STR_PULA
	cQryAux += "AND C6_NUM = C5_NUM"		+ STR_PULA
	cQryAux += "AND A1_COD = C5_CLIENTE"		+ STR_PULA
	cQryAux += "AND A1_LOJA = C5_LOJACLI"		+ STR_PULA
	cQryAux += "AND B1_COD = C6_PRODUTO"		+ STR_PULA
	cQryAux += "AND C5_NUM BETWEEN '" +MV_PAR01+ "' AND '" +MV_PAR02+ "'"	+ STR_PULA
	cQryAux += "AND C5_EMISSAO BETWEEN '"+ DTOS(MV_PAR03) +"' AND '"+ DTOS(MV_PAR04) +"'"		+ STR_PULA
	cQryAux += "AND C6_ENTREG BETWEEN '"+ DTOS(MV_PAR05) +"' AND '"+ DTOS(MV_PAR06) +"'"		+ STR_PULA
	cQryAux += "AND C5_CLIENTE BETWEEN '"+ MV_PAR07 +"' AND '"+ MV_PAR08 +"'"		+ STR_PULA
	cQryAux += "AND C5_CLIENTE <> '000067' "		+ STR_PULA
	cQryAux += "AND C5_TIPO = 'N' "		+ STR_PULA
	cQryAux += "AND C5_FILIAL = '01'"		+ STR_PULA
	cQryAux += "AND C5.D_E_L_E_T_ = ''"		+ STR_PULA
	cQryAux += "AND C6.D_E_L_E_T_ = ''"		+ STR_PULA
	cQryAux += "AND A1.D_E_L_E_T_ = ''"		+ STR_PULA
	cQryAux += "AND B1.D_E_L_E_T_ = ''"		+ STR_PULA
	cQryAux += "ORDER BY C5_NUM, C6_ITEM"		+ STR_PULA
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
