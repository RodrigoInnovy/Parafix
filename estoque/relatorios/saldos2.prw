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
	
User Function saldos2()
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
	Local oBreak   := Nil
	
	//Criação do componente de impressão
	oReport := TReport():New(	"saldos2",;		//Nome do Relatório
								"Saldo Protheus x PCFactory 2",;		//Título
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
	TRCell():New(oSectDad, "BF_PRODUTO", "QRY_AUX", "Bf_Produto", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "BF_LOCAL", "QRY_AUX", "Bf_Local", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "BF_LOCALIZ", "QRY_AUX", "Bf-Localiz", /*Picture*/, 20, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "BF_LOTECTL", "QRY_AUX", "Bf_Lotectl", /*Picture*/, 20, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "BF_QUANT", "QRY_AUX", "Bf_Quant", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PCF_PRODUTO", "QRY_AUX", "Pcf_Produto", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PCF_LOCAL", "QRY_AUX", "Pcf_Local", /*Picture*/, 2, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PCF_LOCALIZ", "QRY_AUX", "Pcf_Endereco", /*Picture*/, 20, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PCF_LOTE", "QRY_AUX", "Pcf_Lote", /*Picture*/, 20, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "PCF_QUANT", "QRY_AUX", "Pcf_Quant", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
	TRCell():New(oSectDad, "DIFERENCA", "QRY_AUX", "Diferença", /*Picture*/, 15, /*lPixel*/,/*{|| code-block de impressao }*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign */,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)

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
	cQryAux += "SELECT BF_PRODUTO, BF_LOCAL, BF_LOCALIZ, BF_LOTECTL, Case When convert(decimal(15,6),BF_QUANT) IS Null then '0' else convert(decimal(15,6),BF_QUANT) end AS 'BF_QUANT', PCF.PRODUTO AS PCF_PRODUTO,  PCF.PCF_LOCAL, PCF.LOCALIZ2 AS PCF_LOCALIZ, PCF.CODE AS PCF_LOTE,  Case When convert(decimal(15,6),PCF.PCF_QUANT) Is Null then '0' else convert(decimal(15,6),PCF.PCF_QUANT) end AS 'PCF_QUANT', SUM(Case When convert(decimal(15,6),BF_QUANT) IS Null then '0' else convert(decimal(15,6),BF_QUANT) end - Case When convert(decimal(15,6),PCF.PCF_QUANT) Is Null then '0' else convert(decimal(15,6),PCF.PCF_QUANT) end) as 'DIFERENCA'" + STR_PULA
	cQryAux += "FROM (SELECT PR.CODE AS PRODUTO,LT.CODE as LOTE, AD.Code AS ENDERECO, WN.CODE AS PCF_LOCAL, LT.IDLot, LT.CODE, SUM((FN.INQTY - FN.OUTQTY)) AS 'PCF_QUANT', AD.CODE AS LOCALIZ2 " + STR_PULA
	cQryAux += "FROM PCFV4.DBO.TBLFINALBALANCE FN, PCFV4.DBO.TBLPRODUCT PR, PCFV4.DBO.TBLADDRESS AD, PCFV4.DBO.TBLWAREHOUSE WN, PCFV4.DBO.TBLLOT LT " + STR_PULA
	cQryAux += "WHERE FN.IDPRODUCT = PR.IDPRODUCT AND LT.IDLOT = FN.IDLot AND AD.IDADDRESS = FN.IDADDRESS AND WN.IDWAREHOUSE = AD.IDWAREHOUSE" + STR_PULA
	cQryAux += "GROUP BY PR.CODE,WN.CODE, LT.CODE, AD.CODE, LT.IDLot, LT.CODE, PR.IDPRODUCT) AS PCF" + STR_PULA
	cQryAux += "FULL OUTER JOIN PROTHEUS12.DBO.SBF010 BF ON BF.BF_PRODUTO = PCF.PRODUTO and BF_LOTECTL = PCF.LOTE AND BF_LOCALIZ = PCF.LOCALIZ2 AND PCF.PCF_LOCAL = BF_LOCAL" + STR_PULA
	cQryAux += "WHERE ((BF_PRODUTO >= '"+MV_PAR01+"'AND BF_PRODUTO <= '"+MV_PAR02+"') OR (PCF.PRODUTO >= '"+MV_PAR01+"' AND PCF.PRODUTO <= '"+MV_PAR02+"'))" + STR_PULA
	cQryAux += "AND (BF_QUANT is not null or PCF.PCF_QUANT <> 0)" + STR_PULA
	cQryAux += "AND ((BF_LOCAL >= '"+MV_PAR03+"' AND BF_LOCAL <= '"+MV_PAR04+"') or (PCF.PCF_LOCAL >= '"+MV_PAR03+"' AND PCF.PCF_LOCAL  <= '"+MV_PAR04+"'))" + STR_PULA
	//cQryAux += "AND BF_LOCALIZ NOT IN ('P1.ALM.FRAC','P1.FRAC.01','P1.ALM.BENE','P1.01.RECEB.01','P1.01.FRAC.01','P1.CQ.LIBE.REC')" + STR_PULA
	cQryAux += "GROUP BY BF_PRODUTO, BF_LOCAL, BF_LOCALIZ, BF_LOTECTL, BF_QUANT, PCF.PRODUTO, PCF.PCF_QUANT, PCF.CODE, PCF.PCF_LOCAL ,PCF.LOCALIZ2" + STR_PULA
	cQryAux += "ORDER BY BF_PRODUTO, PCF.PRODUTO" + STR_PULA
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
