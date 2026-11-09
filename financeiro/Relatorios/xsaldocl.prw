//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
	
//Constantes
#Define STR_PULA		Chr(13)+Chr(10)
	
/*/{Protheus.doc} xSALDOCL
Relatório - Saldo de Clientes             
@author zReport
@since 21/11/2022
@version 1.0
	@example
	u_xSALDOCL()
	@obs Função gerada pelo zReport()
/*/
	
User Function xSALDOCL()
	Local aArea   := GetArea()
	Local oReport
	Local lEmail  := .F.
	Local cPara   := ""
	Private cPerg := ""
	
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
	oReport := TReport():New(	"xSALDOCL",;		//Nome do Relatório
								"Saldo de Clientes",;		//Título
								cPerg,;		//Pergunte ... Se eu defino a pergunta aqui, será impresso uma página com os parâmetros, conforme privilégio 101
								{|oReport| fRepPrint(oReport)},;		//Bloco de código que será executado na confirmação da impressão
								)		//Descrição
	oReport:SetTotalInLine(.F.)
	oReport:lParamPage := .F.
	oReport:oPage:SetPaperSize(9) //Folha A4
	oReport:SetPortrait()
	
	//Criando a seção de dados
	oSectDad := TRSection():New(	oReport,;		//Objeto TReport que a seção pertence
									"Dados",;		//Descrição da seção
									{"QRY_AUX"})		//Tabelas utilizadas, a primeira será considerada como principal da seção
	oSectDad:SetTotalInLine(.F.)  //Define se os totalizadores serão impressos em linha ou coluna. .F.=Coluna; .T.=Linha
	
	//Colunas do relatório
	TRCell():New(oSectDad, "COD", "QRY_AUX", "Desc.Modalid", /*Picture*/, 6, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "LOJA", "QRY_AUX", "Loja", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NOME", "QRY_AUX", "Nome", /*Picture*/, 45, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "A1_EST", "QRY_AUX", "Estado", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "MERCADO", "QRY_AUX", "Mercado", /*Picture*/, 20, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "COND_PAG", "QRY_AUX", "Cond_pag", /*Picture*/, 25, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "MOEDA", "QRY_AUX", "Moeda", /*Picture*/, 8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "LIMITE_CREDITO", "QRY_AUX", "Limite_credito", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "SALDO_A_RECEBER", "QRY_AUX", "Saldo_a_receber", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
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
	cQryAux += "SELECT  DBO.SA1010.A1_COD AS COD, DBO.SA1010.A1_LOJA AS LOJA, DBO.SA1010.A1_NOME AS NOME, "		+ STR_PULA
	cQryAux += "DBO.SA1010.A1_EST, DBO.SA1010.A1_ZZMKT AS MERCADO, DBO.SE4010.E4_DESCRI AS COND_PAG,"		+ STR_PULA
	cQryAux += "CASE WHEN DBO.SA1010.A1_MOEDALC ='1' THEN 'REAL' WHEN DBO.SA1010.A1_MOEDALC ='2' THEN 'DOLAR' ELSE 'EURO' END AS 'MOEDA' ,FORMAT(DBO.SA1010.A1_LC,'N','DE-DE') AS LIMITE_CREDITO, "		+ STR_PULA
	cQryAux += "FORMAT(E1.SALDO_A_RECEBER,'N','DE-DE') AS SALDO_A_RECEBER"		+ STR_PULA
	cQryAux += "FROM      (SELECT E1_CLIENTE, E1_LOJA, SUM(E1_SALDO) AS SALDO_A_RECEBER FROM SE1010 WHERE D_E_L_E_T_= '' GROUP BY E1_CLIENTE, E1_LOJA) AS E1"		+ STR_PULA
	cQryAux += "FULL OUTER JOIN"		+ STR_PULA
	cQryAux += "DBO.SA1010 ON E1.E1_CLIENTE = DBO.SA1010.A1_COD AND E1.E1_LOJA = DBO.SA1010.A1_LOJA FULL OUTER JOIN"		+ STR_PULA
	cQryAux += "DBO.SE4010 ON DBO.SA1010.A1_COND = DBO.SE4010.E4_CODIGO"		+ STR_PULA
	cQryAux += "WHERE (DBO.SA1010.D_E_L_E_T_ = '') AND DBO.SA1010.A1_MSBLQL = '2'"		+ STR_PULA
	cQryAux += "GROUP BY DBO.SA1010.A1_COD, DBO.SA1010.A1_LOJA, DBO.SA1010.A1_NOME, DBO.SA1010.A1_EST, DBO.SA1010.A1_ZZMKT, DBO.SA1010.A1_MOEDALC, DBO.SA1010.A1_LC, DBO.SE4010.E4_DESCRI,"		+ STR_PULA
	cQryAux += "DBO.SA1010.A1_MSBLQL, E1.SALDO_A_RECEBER"		+ STR_PULA
	cQryAux += "ORDER BY A1_COD"		+ STR_PULA
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
