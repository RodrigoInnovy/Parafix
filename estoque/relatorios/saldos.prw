//Bibliotecas
#Include "Protheus.ch"
#Include "TopConn.ch"
	
//Constantes
#Define STR_PULA		Chr(13)+Chr(10)
	
/*/{Protheus.doc} saldos
Relatório - Saldo Protheus x PCFactory    
@author zReport
@since 08/06/2021
@version 1.0
	@example
	u_saldos()
	@obs Função gerada pelo zReport()
/*/
	
User Function saldos()
	Local aArea   := GetArea()
	Local oReport
	Local lEmail  := .F.
	Local cPara   := ""
	Private cPerg := ""
	
	//Definições da pergunta
	cPerg := "SBFXPCF   "
	
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
	
	//Criação do componente de impressão
	oReport := TReport():New(	"saldos",;		//Nome do Relatório
								"Saldo Protheus x PCFactory",;		//Título
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
	TRCell():New(oSectDad, "PRODUTO", "QRY_AUX", "Produto", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "LOCAL", "QRY_AUX", "Local", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "TIPO", "QRY_AUX", "Tipo", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PROTHEUS", "QRY_AUX", "Protheus", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PCFACTORY", "QRY_AUX", "Pcfactory", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
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
	cQryAux += "SELECT DISTINCT B2_COD AS 'PRODUTO', B2_LOCAL AS 'LOCAL', B1_TIPO AS 'TIPO', convert(decimal(15,6),B2_QATU) AS 'PROTHEUS', CONVERT(DECIMAL(15,6),PCF.QUANT) AS 'PCFACTORY'"		+ STR_PULA
	cQryAux += "FROM"		+ STR_PULA
	cQryAux += "(SELECT DISTINCT PR.CODE AS PRODUTO, WN.CODE AS 'LOCAL', SUM((FN.INQTY - FN.OUTQTY)) AS 'QUANT'"		+ STR_PULA
	cQryAux += "FROM PCFV4.DBO.TBLFINALBALANCE FN, PCFV4.DBO.TBLPRODUCT PR, PCFV4.DBO.TBLADDRESS AD, PCFV4.DBO.TBLWAREHOUSE WN"		+ STR_PULA
	cQryAux += "WHERE FN.IDPRODUCT = PR.IDPRODUCT AND AD.IDADDRESS = FN.IDADDRESS AND WN.IDWAREHOUSE = AD.IDWAREHOUSE "		+ STR_PULA
	cQryAux += "GROUP BY PR.CODE,WN.CODE) AS PCF"		+ STR_PULA
	cQryAux += "FULL OUTER JOIN PROTHEUS12.DBO.SB2010 B2 ON B2.B2_COD = PCF.PRODUTO AND B2.B2_LOCAL = PCF.LOCAL"		+ STR_PULA
	cQryAux += "JOIN PROTHEUS12.DBO.SB1010 B1 ON B1.B1_COD = B2.B2_COD"		+ STR_PULA
	cQryAux += "WHERE B2.D_E_L_E_T_ = ''"		+ STR_PULA
	cQryAux += "AND B1.D_E_L_E_T_ = ''"		+ STR_PULA
	cQryAux += "AND B2_COD >= '"+MV_PAR01+"'"		+ STR_PULA
	cQryAux += "AND B2_COD <= '"+MV_PAR02+"'"		+ STR_PULA
	cQryAux += "AND B2_LOCAL >= '"+MV_PAR03+"'"		+ STR_PULA
	cQryAux += "AND B2_LOCAL <= '"+MV_PAR04+"'"		+ STR_PULA
	//cQryAux += "AND B2_LOCALIZ NOT IN ('P1.ALM.FRAC','P1.FRAC.01','P1.ALM.BENE','P1.01.RECEB.01','P1.01.FRAC.01','P1.CQ.LIBE.REC')"		+ STR_PULA
	cQryAux += "AND B2_FILIAL = '01'"		+ STR_PULA
	cQryAux += "GROUP BY B2_COD, B2_LOCAL, B1_TIPO, B2_QATU, PCF.QUANT"		+ STR_PULA
	cQryAux += "ORDER BY B2_COD, B2_LOCAL"		+ STR_PULA
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
