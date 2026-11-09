//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
	
//Constantes
#Define STR_PULA		Chr(13)+Chr(10)
	
/*/{Protheus.doc} Fixfatd
Relatório - Relatorio de Faturamento      
@author zReport
@since 16/09/2020
@version 1.0
	@example
	u_Fixfatd()
	@obs Função gerada pelo zReport()
/*/
	
User Function Fixfatd()
	Local aArea   := GetArea()
	Local oReport
	Local lEmail  := .F.
	Local cPara   := ""
	Private cPerg := ""
	
	//Definições da pergunta
	cPerg := "SB2XSC6   "
	
	//Se a pergunta não existir, zera a variável
	DbSelectArea("SX1")
	SX1->(DbSetOrder(1)) //X1_GRUPO + X1_ORDEM
	If ! SX1->(DbSeek(cPerg))
		cPerg := Nil
	EndIf
	
	Pergunte(cPerg,.F.)

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
	
	//Criação do componente de impressão
	oReport := TReport():New(	"Fixfatd",;		//Nome do Relatório
								"Relatorio de Faturamento",;		//Título
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
	TRCell():New(oSectDad, "FILIAL", "QRY_AUX", "Filial", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ANO", "QRY_AUX", "Ano", /*Picture*/, 4, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CFIELD3", "QRY_AUX", "Mês", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DIA", "QRY_AUX", "Dia", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CFIELD5", "QRY_AUX", "consolid.", /*Picture*/, 9, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CFIELD6", "QRY_AUX", "Operação", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "MERCADO", "QRY_AUX", "Mercado", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PAIS", "QRY_AUX", "Pais", /*Picture*/, 14, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CFIELD9", "QRY_AUX", "Cod vend", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VEND", "QRY_AUX", "Vend", /*Picture*/, 14, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CFIELD11", "QRY_AUX", "Linha Prod", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CFIELD12", "QRY_AUX", "Grupo Prod", /*Picture*/, 16, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CFIELD13", "QRY_AUX", "Nova Base", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CFIELD14", "QRY_AUX", "Novo Cofins", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CFIELD15", "QRY_AUX", "Novo Pis", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CFIELD16", "QRY_AUX", "Nova Receita", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CFIELD17", "QRY_AUX", "Produto", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "TES", "QRY_AUX", "TES", /*Picture*/, 3, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "UNID", "QRY_AUX", "Unid", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "QTDE", "QRY_AUX", "Qtde", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CFIELD21", "QRY_AUX", "2° Und", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CFIELD22", "QRY_AUX", "2° Qtde", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CFIELD23", "QRY_AUX", "Vlr Total", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CFIELD24", "QRY_AUX", "Vlr IPI", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CFIELD25", "QRY_AUX", "Vlr ICMS", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CFOP", "QRY_AUX", "Cfop", /*Picture*/, 5, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CFIELD27", "QRY_AUX", "Armazem", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NFISCAL", "QRY_AUX", "Nota Fiscal", /*Picture*/, 9, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CFIELD29", "QRY_AUX", "Vlr Frete", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CFIELD30", "QRY_AUX", "Vlr Seguro", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CFIELD31", "QRY_AUX", "Vlr Despesa", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CFIELD32", "QRY_AUX", "Tipo NF", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CFIELD33", "QRY_AUX", "Tipo Prod", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CFIELD34", "QRY_AUX", "Vlr IcmsRet", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CFIELD36", "QRY_AUX", "Desc Prod", /*Picture*/, 120, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ESTOQ", "QRY_AUX", "Estoq", /*Picture*/, 1, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CLIENTE", "QRY_AUX", "Cliente", /*Picture*/, 20, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CFIELD39", "QRY_AUX", "Desc Tes", /*Picture*/, 20, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CFIELD40", "QRY_AUX", "Cod Cliente", /*Picture*/, 9, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CFIELD41", "QRY_AUX", "Classif. Cliente", /*Picture*/, 3, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NCM", "QRY_AUX", "NCM", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CFIELD43", "QRY_AUX", "Base Pis/Cofins", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CFIELD44", "QRY_AUX", "Vlr Bruto", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CFIELD45", "QRY_AUX", "Vlr Cofins", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CFIELD46", "QRY_AUX", "Vlr Pis", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CFIELD47", "QRY_AUX", "Vlr Liq", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CFIELD48", "QRY_AUX", "Unid Fat", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "CFIELD49", "QRY_AUX", "Qtd Fat", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
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
	cQryAux += "SELECT RTRIM (D1_FILIAL) AS FILIAL,"		+ STR_PULA
	cQryAux += "YEAR (D1_DTDIGIT) AS ANO,"		+ STR_PULA
	cQryAux += "CASE MONTH (D1_DTDIGIT)"		+ STR_PULA
	cQryAux += "WHEN '1' THEN 'JANEIRO'"		+ STR_PULA
	cQryAux += "WHEN '2' THEN 'FEVEREIRO'"		+ STR_PULA
	cQryAux += "WHEN '3' THEN 'MARÇO'"		+ STR_PULA
	cQryAux += "WHEN '4' THEN 'ABRIL'"		+ STR_PULA
	cQryAux += "WHEN '5' THEN 'MAIO'"		+ STR_PULA
	cQryAux += "WHEN '6' THEN 'JUNHO'"		+ STR_PULA
	cQryAux += "WHEN '7' THEN 'JULHO'"		+ STR_PULA
	cQryAux += "WHEN '8' THEN 'AGOSTO'"		+ STR_PULA
	cQryAux += "WHEN '9' THEN 'SETEMBRO'"		+ STR_PULA
	cQryAux += "WHEN '10' THEN 'OUTUBRO'"		+ STR_PULA
	cQryAux += "WHEN '11' THEN 'NOVEMBRO'"		+ STR_PULA
	cQryAux += "WHEN '12' THEN 'DEZEMBRO'"		+ STR_PULA
	cQryAux += "END AS 'MÊS',"		+ STR_PULA
	cQryAux += "CONVERT (DATETIME,D1_DTDIGIT) AS DIA,"		+ STR_PULA
	cQryAux += "'ACUMULADO' AS 'CONSOLID.',"		+ STR_PULA
	cQryAux += "CASE (A1_NREDUZ)"		+ STR_PULA
	cQryAux += "WHEN 'CONTATO' THEN 'SUCATA'"		+ STR_PULA
	cQryAux += "WHEN 'PARAFIX 'THEN 'OUTRAS ENTRADAS'"		+ STR_PULA
	cQryAux += "ELSE 'DEVOLUÇÃO'"		+ STR_PULA
	cQryAux += "END AS 'OPERAÇÃO',"		+ STR_PULA
	cQryAux += "CASE (A1_PAIS)"		+ STR_PULA
	cQryAux += "WHEN 105 THEN 'NACIONAL'"		+ STR_PULA
	cQryAux += "ELSE 'EXPORTAÇÃO'"		+ STR_PULA
	cQryAux += "END AS 'MERCADO',"		+ STR_PULA
	cQryAux += "CASE (A1_PAIS)"		+ STR_PULA
	cQryAux += "WHEN 063 THEN 'ARGENTINA'"		+ STR_PULA
	cQryAux += "WHEN 105 THEN 'BRASIL'"		+ STR_PULA
	cQryAux += "WHEN 158 THEN 'CHILE'"		+ STR_PULA
	cQryAux += "WHEN 169 THEN 'COLÔMBIA'"		+ STR_PULA
	cQryAux += "WHEN 239 THEN 'EQUADOR'"		+ STR_PULA
	cQryAux += "WHEN 249 THEN 'ESTADOS UNIDOS'"		+ STR_PULA
	cQryAux += "WHEN 275 THEN 'FRANÇA'"		+ STR_PULA
	cQryAux += "WHEN 589 THEN 'PERU'"		+ STR_PULA
	cQryAux += "WHEN 845 THEN 'URUGUAI'"		+ STR_PULA
	cQryAux += "END AS 'PAIS',"		+ STR_PULA
	cQryAux += "A1_VEND AS CÓD_VEND,"		+ STR_PULA
	cQryAux += "CASE (A1_VEND)"		+ STR_PULA
	cQryAux += "WHEN 000001 THEN 'PARAFIX'"		+ STR_PULA
	cQryAux += "WHEN 000002 THEN 'SARTORI'"		+ STR_PULA
	cQryAux += "WHEN 000003 THEN 'PATRÍCIA'"		+ STR_PULA
	cQryAux += "WHEN 000004 THEN 'GONZALO'"		+ STR_PULA
	cQryAux += "WHEN 000005 THEN 'INCOPACK 2,0%'"		+ STR_PULA
	cQryAux += "WHEN 000006 THEN 'INCOPACK 2,5%'"		+ STR_PULA
	cQryAux += "WHEN 000007 THEN 'SPHERE'"		+ STR_PULA
	cQryAux += "WHEN 000008 THEN 'HENRIQUE'"		+ STR_PULA
	cQryAux += "WHEN 000009 THEN 'PATRÍCIA'"		+ STR_PULA
	cQryAux += "WHEN 000010 THEN 'ANDRE OLIVEIRA'"		+ STR_PULA
	cQryAux += "WHEN 000011 THEN 'SECONDSTEP'"		+ STR_PULA
	cQryAux += "WHEN 000012 THEN 'CHRISTIAN'"		+ STR_PULA
	cQryAux += "WHEN 000013 THEN 'ANA CRISTINA'"		+ STR_PULA
	cQryAux += "WHEN 000014 THEN 'FABIO WRUCK'"		+ STR_PULA
	cQryAux += "ELSE 'VERIF'"		+ STR_PULA
	cQryAux += "END AS 'VEND',"		+ STR_PULA
	cQryAux += "RTRIM (B1_ZZLP) AS 'LINHA PROD',"		+ STR_PULA
	cQryAux += "CASE (B1_ZZLP)"		+ STR_PULA
	cQryAux += "WHEN 'AUTO' THEN 'AUTO'"		+ STR_PULA
	cQryAux += "WHEN 'BS' THEN 'FITAS'"		+ STR_PULA
	cQryAux += "WHEN 'BS STR' THEN 'FITAS'"		+ STR_PULA
	cQryAux += "WHEN 'ETQ' THEN 'FITAS'"		+ STR_PULA
	cQryAux += "WHEN 'HKN' THEN 'FITAS'"		+ STR_PULA
	cQryAux += "WHEN 'HKT' THEN 'FITAS'"		+ STR_PULA
	cQryAux += "WHEN 'HKW' THEN 'FITAS'"		+ STR_PULA
	cQryAux += "WHEN 'IND' THEN 'FITAS'"		+ STR_PULA
	cQryAux += "WHEN 'HOOK' THEN 'FITAS'"		+ STR_PULA
	cQryAux += "WHEN 'LINER' THEN 'INDUSTRIALIZAÇÃO'"		+ STR_PULA
	cQryAux += "WHEN 'MONO' THEN 'FITAS'"		+ STR_PULA
	cQryAux += "WHEN 'RT' THEN 'FITAS'"		+ STR_PULA
	cQryAux += "WHEN 'SOFTGRIP' THEN 'SOFTGRIP'"		+ STR_PULA
	cQryAux += "WHEN 'STR EAR' THEN 'FITAS'"		+ STR_PULA
	cQryAux += "WHEN 'TBW10' THEN 'TBW'"		+ STR_PULA
	cQryAux += "WHEN 'TEC 23G' THEN 'FITAS'"		+ STR_PULA
	cQryAux += "WHEN 'EFT' THEN 'EFT'"		+ STR_PULA
	cQryAux += "WHEN 'FITA' THEN 'FITAS'"		+ STR_PULA
	cQryAux += "WHEN 'LOOP AUTO' THEN 'AUTO'"		+ STR_PULA
	cQryAux += "WHEN 'TR' THEN 'FITAS'"		+ STR_PULA
	cQryAux += "ELSE 'VERIF'"		+ STR_PULA
	cQryAux += "END AS 'GRUPO PROD',"		+ STR_PULA
	cQryAux += "-(D1_BASIMP5 - D1_VALICM) AS 'NOVA BASE',"		+ STR_PULA
	cQryAux += "-((D1_BASIMP5 - D1_VALICM)*0.0760) AS 'NOVO COFINS',"		+ STR_PULA
	cQryAux += "-((D1_BASIMP5 - D1_VALICM)*0.0165) AS 'NOVO PIS',"		+ STR_PULA
	cQryAux += "CASE (A1_PAIS)"		+ STR_PULA
	cQryAux += "WHEN 105 THEN -((D1_BASIMP5 - D1_VALICM)*0.9075)"		+ STR_PULA
	cQryAux += "ELSE -(D1_TOTAL-D1_DESPESA+D1_SEGURO+D1_VALFRE)"		+ STR_PULA
	cQryAux += "END AS 'NOVA RECEITA',"		+ STR_PULA
	cQryAux += "RTRIM (D1_COD) AS 'CÓD PROD',"		+ STR_PULA
	cQryAux += "RTRIM (D1_TES) AS TES,"		+ STR_PULA
	cQryAux += "RTRIM (D1_UM) AS 'UNID',"		+ STR_PULA
	cQryAux += "-D1_QUANT AS 'QTDE',"		+ STR_PULA
	cQryAux += "RTRIM (D1_SEGUM) AS '2º UNID',"		+ STR_PULA
	cQryAux += "-D1_QTSEGUM AS '2º QTDE',"		+ STR_PULA
	cQryAux += "-D1_TOTAL AS 'VLR TOTAL',"		+ STR_PULA
	cQryAux += "-D1_VALIPI AS 'VLR IPI',"		+ STR_PULA
	cQryAux += "-D1_VALICM AS 'VLR ICMS',"		+ STR_PULA
	cQryAux += "RTRIM (D1_CF) AS CFOP,"		+ STR_PULA
	cQryAux += "RTRIM (D1_LOCAL) AS ARMAZÉM,"		+ STR_PULA
	cQryAux += "RTRIM (D1_DOC) AS NFISCAL,"		+ STR_PULA
	cQryAux += "-D1_VALFRE AS 'VLR FRETE',"		+ STR_PULA
	cQryAux += "-D1_SEGURO AS 'VLR SEGURO',"		+ STR_PULA
	cQryAux += "-D1_DESPESA AS 'VLR DESP',"		+ STR_PULA
	cQryAux += "RTRIM (D1_TIPO) AS 'TIPO NF',"		+ STR_PULA
	cQryAux += "RTRIM (D1_TP) AS 'TIPO PROD',"		+ STR_PULA
	cQryAux += "-D1_ICMSRET AS 'VLR ICMSRET',"		+ STR_PULA
	cQryAux += "-D1_CUSTO AS CUSTO,"		+ STR_PULA
	cQryAux += "RTRIM (LOWER(B1_DESC)) AS 'DESCR PROD',"		+ STR_PULA
	cQryAux += "F4_ESTOQUE AS ESTOQ,"		+ STR_PULA
	cQryAux += "RTRIM (A1_NREDUZ) AS 'CLIENTE',"		+ STR_PULA
	cQryAux += "RTRIM (F4_TEXTO) AS 'DESC TES',"		+ STR_PULA
	cQryAux += "CONCAT (D1_FORNECE ,'/',D1_LOJA) AS 'CÓD CLIENTE',"		+ STR_PULA
	cQryAux += "RTRIM (A1_ZZABC) AS 'CLASSIF CLIENTE',"		+ STR_PULA
	cQryAux += "B1_POSIPI AS NCM,"		+ STR_PULA
	cQryAux += "-D1_BASIMP5 AS 'BASE PIS/COFINS',"		+ STR_PULA
	cQryAux += "-(D1_TOTAL + D1_VALIPI+D1_VALFRE+D1_SEGURO+D1_DESPESA) AS 'VLR BRUTO',"		+ STR_PULA
	cQryAux += "-D1_VALIMP5 AS 'VLR COFINS',"		+ STR_PULA
	cQryAux += "-D1_VALIMP6 AS 'VLR PIS',"		+ STR_PULA
	cQryAux += "-(D1_TOTAL-D1_VALICM-D1_VALIMP5-D1_VALIMP6) AS 'VLR LIQ',"		+ STR_PULA
	cQryAux += "CASE CONCAT (B1_ZZLP,D1_TP)"		+ STR_PULA
	cQryAux += "WHEN 'AUTO PA' THEN D1_SEGUM"		+ STR_PULA
	cQryAux += "WHEN 'LOOP AUTO PA' THEN D1_SEGUM"		+ STR_PULA
	cQryAux += "ELSE D1_UM"		+ STR_PULA
	cQryAux += "END AS 'UNID FAT',"		+ STR_PULA
	cQryAux += "CASE CONCAT (B1_ZZLP,D1_TP)"		+ STR_PULA
	cQryAux += "WHEN 'AUTO PA' THEN -D1_QTSEGUM"		+ STR_PULA
	cQryAux += "WHEN 'LOOP AUTO PA' THEN -D1_QTSEGUM"		+ STR_PULA
	cQryAux += "ELSE -D1_QUANT"		+ STR_PULA
	cQryAux += "END AS 'QTD FAT'"		+ STR_PULA
	cQryAux += "FROM SD1010 , SB1010, SF4010 , SA1010"		+ STR_PULA
	cQryAux += "WHERE D1_DTDIGIT BETWEEN '"+ DTOS(MV_PAR01) +"' AND '"+ DTOS(MV_PAR02) +"'"		+ STR_PULA
	cQryAux += "AND D1_FILIAL = '"+XFILIAL("SD1")+ "'"		+ STR_PULA
	cQryAux += "AND SD1010.D_E_L_E_T_ <> '*'"		+ STR_PULA
	cQryAux += "AND D1_COD = B1_COD"		+ STR_PULA
	cQryAux += "AND D1_TES = F4_CODIGO"		+ STR_PULA
	cQryAux += "AND F4_ESTOQUE >= 'S'"		+ STR_PULA
	cQryAux += "AND D1_TIPO IN ( 'D' )"		+ STR_PULA
	cQryAux += "AND D1_FORNECE = A1_COD"		+ STR_PULA
	cQryAux += "AND D1_LOJA = A1_LOJA"		+ STR_PULA
	cQryAux += "AND D1_CF NOT IN ( '2949' , '1949' )"		+ STR_PULA
	cQryAux += "AND D1_LOCAL NOT IN ( 'DE' )"		+ STR_PULA
	cQryAux += "ORDER BY"		+ STR_PULA
	cQryAux += "D1_DOC"		+ STR_PULA
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
