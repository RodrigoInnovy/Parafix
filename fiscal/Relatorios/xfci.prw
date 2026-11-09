// Relatório para conferir o FCI gerado.
//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
	
//Constantes
#Define STR_PULA		Chr(13)+Chr(10)
	
/*/{Protheus.doc} xFCI
Relatório - CONFERENCIA DE FCI            
@author zReport
@since 27/04/2023
@version 1.0
	@example
	u_xFCI()
	@obs Função gerada pelo zReport()
/*/
	
User Function xFCI()
	Local aArea   := GetArea()
	Local oReport
	Local lEmail  := .F.
	Local cPara   := ""
	Private cPerg := ""
	
	//Definições da pergunta
	cPerg := "FCI"
	
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
	oReport := TReport():New(	"xFCI",;		//Nome do Relatório
								"CONFERENCIA DE FCI",;		//Título
								cPerg,;		//Pergunte ... Se eu defino a pergunta aqui, será impresso uma página com os parâmetros, conforme privilégio 101
								{|oReport| fRepPrint(oReport)},;		//Bloco de código que será executado na confirmação da impressão
								)		//Descrição
	oReport:SetTotalInLine(.F.)
	oReport:lParamPage := .F.
	oReport:oPage:SetPaperSize(9) //Folha A4
	oReport:SetPortrait()
	oReport:SetLineHeight(60)
	oReport:nFontBody := 10
	
	//Criando a seção de dados
	oSectDad := TRSection():New(	oReport,;		//Objeto TReport que a seção pertence
									"Dados",;		//Descrição da seção
									{"QRY_AUX"})		//Tabelas utilizadas, a primeira será considerada como principal da seção
	oSectDad:SetTotalInLine(.F.)  //Define se os totalizadores serão impressos em linha ou coluna. .F.=Coluna; .T.=Linha
	
	//Colunas do relatório
	TRCell():New(oSectDad, "PRODUTO", "QRY_AUX", "Produto", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "VALORIMPORT", "QRY_AUX", "ValorImport", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PERVEN", "QRY_AUX", "Perven", /*Picture*/, 10, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "FCI", "QRY_AUX", "Fci", /*Picture*/, 40, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "ORIGEM", "QRY_AUX", "Origem", /*Picture*/, 3, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
Return oReport
	
/*-------------------------------------------------------------------------------*
 | Func:  fRepPrint                                                              |
 | Desc:  Função que imprime o relatório                                         |
 *-------------------------------------------------------------------------------*/
	
Static Function fRepPrint(oReport)
	U_CORRIGESA8()
	Local aArea    := GetArea()
	Local cQryAux  := ""
	Local oSectDad := Nil
	Local nAtual   := 0
	Local nTotal   := 0
	
	//Pegando as seções do relatório
	oSectDad := oReport:Section(1)
	
	//Montando consulta de dados
	cQryAux := ""
	cQryAux += "SELECT        dbo.SD2010.D2_COD as Produto, dbo.SA8010.A8_VLRVI as ValorImport, CASE WHEN CFD010.CFD_PERVEN is null THEN 'ERRO' ELSE CFD_PERVEN END as PERVEN, dbo.CFD010.CFD_FCICOD as FCI, CASE WHEN CFD_ORIGEM is null then 'ERRO' else CFD_ORIGEM END  as ORIGEM"		+ STR_PULA
	cQryAux += "FROM            DBO.SD2010 LEFT OUTER JOIN"		+ STR_PULA
	cQryAux += "                         DBO.CFD010 ON DBO.SD2010.D2_FILIAL = DBO.CFD010.CFD_FILIAL AND DBO.SD2010.D2_COD = DBO.CFD010.CFD_COD AND CFD_PERVEN = '"+ MV_PAR01 +"' "		+ STR_PULA
	cQryAux += "						 AND CFD_FILIAL ='01' AND DBO.CFD010.D_E_L_E_T_='' LEFT OUTER JOIN"		+ STR_PULA
	cQryAux += "                         DBO.SA8010 ON DBO.SD2010.D2_FILIAL = DBO.SA8010.A8_FILIAL AND DBO.SD2010.D2_COD = DBO.SA8010.A8_COD AND DBO.SA8010.D_E_L_E_T_ = '' "		+ STR_PULA
	cQryAux += "						 AND A8_FILIAL = '01' AND SA8010.R_E_C_N_O_ IN (SELECT MAX(R_E_C_N_O_) AS R_E_C_N_O_ FROM SA8010 GROUP BY A8_COD) LEFT OUTER JOIN"		+ STR_PULA
	cQryAux += "						 DBO.SB1010 ON DBO.SD2010.D2_COD = SB1010.B1_COD AND SB1010.D_E_L_E_T_ = ''"		+ STR_PULA
	cQryAux += "						 WHERE        (DBO.SD2010.D2_EMISSAO BETWEEN '20220101' AND '"+ DTOS(MV_PAR02) +"') AND (DBO.SD2010.D_E_L_E_T_ = '') AND (D2_TP = 'PA') AND B1_MSBLQL = '2'"		+ STR_PULA
	cQryAux += "						 AND D2_CLASFIS IN (100,110,120,170,190,200,210,220,270,290,300,310,320,370,390,800,810,820,870,890,500,510,520,570,590,150,250,350,450,550,650,750,850,700)"		+ STR_PULA
	cQryAux += "						 AND D2_CF IN (6107,6101,6103,6105,6109,6111,6113,6116,6118,6122,6124,6125,6401,6402,6403,6404,6901,6902,5107,5101,5103,5105,5109,5111,5113,5116,5118,5122,5124,5125,5401,5402,5403,5404,5901,5902)"		+ STR_PULA
	cQryAux += "						 AND D2_CLIENTE <> '000002'"		+ STR_PULA
	cQryAux += "GROUP BY DBO.SD2010.D2_COD, DBO.SA8010.A8_VLRVI, DBO.CFD010.CFD_PERVEN, DBO.CFD010.CFD_FCICOD, CFD_ORIGEM"		+ STR_PULA
	cQryAux += "ORDER BY D2_COD"		+ STR_PULA
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
