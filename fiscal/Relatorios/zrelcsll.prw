// Relatório valor CSLL dos titulos a pagar baixados

//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
	
//Constantes
#Define STR_PULA		Chr(13)+Chr(10)
	
/*/{Protheus.doc} zrelcsll
Relatório - Relatorio CSLL                
@author zReport
@since 27/11/2023
@version 1.0
	@example
	u_ZRELCSLL()
	@obs Função gerada pelo zReport()
/*/
	
User Function ZRELCSLL()
	Local aArea   := GetArea()
	Local oReport
	Local lEmail  := .F.
	Local cPara   := ""
	Private cPerg := ""
	
	//Definições da pergunta
	cPerg := "ZRELCSLL"
	
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
	Local oFunTot1 := Nil
	
	//Criação do componente de impressão
	oReport := TReport():New(	"ZRELCSLL",;		//Nome do Relatório
								"Relatorio CSLL",;		//Título
								cPerg,;		//Pergunte ... Se eu defino a pergunta aqui, será impresso uma página com os parâmetros, conforme privilégio 101
								{|oReport| fRepPrint(oReport)},;		//Bloco de código que será executado na confirmação da impressão
								)		//Descrição
	oReport:SetTotalInLine(.F.)
	oReport:lParamPage := .F.
	oReport:oPage:SetPaperSize(9) //Folha A4
	oReport:SetPortrait()
	oReport:SetLineHeight(60)
	oReport:nFontBody := 12
	
	//Criando a seção de dados
	oSectDad := TRSection():New(	oReport,;		//Objeto TReport que a seção pertence
									"Dados",;		//Descrição da seção
									{"QRY_AUX"})		//Tabelas utilizadas, a primeira será considerada como principal da seção
	oSectDad:SetTotalInLine(.F.)  //Define se os totalizadores serão impressos em linha ou coluna. .F.=Coluna; .T.=Linha
	
	//Colunas do relatório
	TRCell():New(oSectDad, "DATA_BAIXA", "QRY_AUX", "Data_baixa", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DATA_LANCAMENTO", "QRY_AUX", "Data_lancamento", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DATA_EMISSAO", "QRY_AUX", "Data_emissao", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "NOTA_FISCAL", "QRY_AUX", "Nota_fiscal", /*Picture*/, 12, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "COD_FORNECE", "QRY_AUX", "Cod_fornece", /*Picture*/, 8, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "LOJA", "QRY_AUX", "Loja", /*Picture*/, 3, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "FORNECEDOR", "QRY_AUX", "Fornecedor", /*Picture*/, 35, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PIS_COFINS_CSLL", "QRY_AUX", "Pis_cofins_csll", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	
	//Totalizadores
	oFunTot1 := TRFunction():New(oSectDad:Cell("PIS_COFINS_CSLL"),,"SUM",,,/*cPicture*/)
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
	cQryAux += "SELECT        FORMAT(CONVERT(DATE,E2_BAIXA,103),'dd/MM/yyyy') AS DATA_BAIXA, FORMAT(CONVERT(DATE,DBO.SF1010.F1_DTLANC,103),'dd/MM/yyyy') AS DATA_LANCAMENTO, FORMAT(CONVERT(DATE,DBO.SF1010.F1_EMISSAO,103),'dd/MM/yyyy') AS DATA_EMISSAO, DBO.SF1010.F1_DOC AS NOTA_FISCAL, DBO.SF1010.F1_FORNECE AS COD_FORNECE, DBO.SF1010.F1_LOJA AS LOJA, "		+ STR_PULA
	cQryAux += "			E2_NOMFOR AS FORNECEDOR, SUM(E2_COFINS+E2_PIS+E2_CSLL) AS PIS_COFINS_CSLL"		+ STR_PULA
	cQryAux += "FROM          DBO.SF1010 LEFT OUTER JOIN"		+ STR_PULA
	cQryAux += "              DBO.SE2010 ON DBO.SF1010.F1_FILIAL = DBO.SE2010.E2_FILIAL AND DBO.SF1010.F1_DOC = DBO.SE2010.E2_NUM AND DBO.SF1010.F1_FORNECE = DBO.SE2010.E2_FORNECE AND DBO.SF1010.F1_LOJA = DBO.SE2010.E2_LOJA"		+ STR_PULA
	cQryAux += "WHERE (E2_BAIXA BETWEEN '"+ DTOS(MV_PAR01) +"' AND '"+ DTOS(MV_PAR02) +"') AND DBO.SF1010.D_E_L_E_T_ ='' AND SE2010.D_E_L_E_T_ ='' AND (E2_COFINS+E2_PIS+E2_CSLL)<>'0'"		+ STR_PULA
	cQryAux += "GROUP BY E2_BAIXA, DBO.SF1010.F1_EMISSAO, F1_DTLANC, DBO.SF1010.F1_DOC, DBO.SF1010.F1_FORNECE, DBO.SF1010.F1_LOJA, E2_NOMFOR,F1_IRRF, E2_VENCTO"		+ STR_PULA
	cQryAux += "ORDER BY E2_BAIXA"		+ STR_PULA
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
