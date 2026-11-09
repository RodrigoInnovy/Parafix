#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"

#DEFINE	__EndLine	Chr(13) + Chr(10)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �U_TSRFecOP� Autor � Jos� Orfeu         � Data �  27/01/2016 ���
�������������������������������������������������������������������������͹��
���Descricao � Relatorio de Fechamento de Ordem de Produ��o               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � PCP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/                         
User Function TSRFecOP()
	Local cAliasOld := Alias()
	Local cPerg     := "TSRFECOP"
	Local cPlanilha := ""
	Local cNome     := DToS(dDataBase) + "_" + StrTran(SubStr(Time(), 1, 5), ":", "_") + "_TSRFecOP"

	//AjustaSX1(cPerg)

	If Pergunte(cPerg, .T.) .And. !Empty(cPlanilha := U_TSGPlanilha(cNome))
 	
		Processa({|| GerPlExcel(cPlanilha)}, "")
		
	EndIf
	
	If !Empty(cAliasOld)
		DBSelectArea(cAliasOld)
	EndIf
Return(Nil)

// Gera planilha Excel
Static Function GerPlExcel(cPlanilha)
	Local nColorCinza := RGB(168,168,168)
	
	Private nStyleCabec  := Nil
    Private nStyleNItns  := Nil
    Private nStyleBkCab  := Nil
    Private nStyleCItns  := Nil
    Private nStyleLfCab  := Nil
    
	// Cria a Planilha	                            
	oExcel := TExcelXml():New(cPlanilha) 
	                                                                                                         
	// Definicao dos Estilos               
	                    //NewStyle(nAligHoriz,nAligVert,nBorder,cFont,nSize,lBold,lItalic,lUnderline,nColor,nBkColor,cWrapText,cFormat)
	nStyleCabec := oExcel:NewStyle(2, 2, 1, Nil, Nil, .T., Nil, Nil, Nil, Nil, Nil, Nil)
	nStyleLfCab := oExcel:NewStyle(1, 2, 1, Nil, Nil, .T., Nil, Nil, Nil, Nil, Nil, Nil)
	nStyleBkCab := oExcel:NewStyle(2, 2, 1, Nil, Nil, .T., Nil, Nil, Nil, nColorCinza, Nil, Nil)
	nStyleNItns := oExcel:NewStyle(3, 2, 1, Nil, Nil, .F., Nil, Nil, Nil, Nil, Nil, "[$-6]\ #,##0.000000_);[Red]\([$-6]\ #,##0.000000\)")
	nStyleCItns := oExcel:NewStyle(1, 2, 1, Nil, Nil, .F., Nil, Nil, Nil, Nil, Nil, Nil)
	
	// Define o uso da Barra de Progresso
	// oExcel:SetProgressBar(.F.)		

	// Cria uma nova pasta na Planilha	
	oExcel:NewWorkSheet("Perdas e Ganhos")
	
	FSGerXls()
	
	// Gera o XML
	oExcel:GeraXml()
	
	// Abre a Planilha
	oExcel:OpenXml()
Return(Nil)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    � FSgerXls � Autor � Jos� Orfeu         � Data �  09/09/2015 ���
�������������������������������������������������������������������������͹��
���Descri��o � Monta Array para gera��o da planilha Excel                 ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function FSGerXls()
	Local cSql       	 := ""
	Local aStrTmpSc2 	 := {}
	Local nForCpos   	 := 0
	Local nVTotPerda 	 := 0 
	Local nPTotPerda 	 := 0
	Local nRecCount  	 := 0
	Local nCustoPrev	 := 0
	Local nCustReal		 := 0
	Local nCMReq		 := 0
	
	cSql := U_TSMntSql(MV_PAR01, Nil, Nil)
				  
	TCQuery ChangeQuery(cSql) New Alias "TMPSC2"
	
	DBSelectArea("TMPSC2")
	DBGoTop()
	
	While TMPSC2->(!Eof())
	
		nVTotPerda += TMPSC2->nD3PCusto
		nCustoPrev += (TMPSC2->nD3FCusto) //-TMPSC2->nD3PCusto)
		nCustReal  += (TMPSC2->nCustoReal + TMPSC2->nD3PCusto)
		nRecCount  ++
		
		TMPSC2->(DBSkip())
	End
	
	TMPSC2->(DBGoTop())
	
	oExcel:NewRow(Nil)
	oExcel:NewCol("OP: [" + IIf(Empty(TMPSC2->C2_DATRF), "ABERTA", "FECHADA") + "] " + TMPSC2->C2_NUM + TMPSC2->C2_ITEM + SC2->C2_SEQUEN + " Produto: " + TMPSC2->C2_PRODUTO + " Descricao: " + TMPSC2->B1_DESC, 0, 12, nStyleBkCab, Nil)
	                  
	oExcel:NewRow(Nil) // Primeira Linha Cabe�alho
	// Planejado
	oExcel:NewCol("Quantidade 1 Un", 0, 02, nStyleLfCab, Nil)
	oExcel:NewCol(TMPSC2->C2_QUANT , 0, 02, nStyleNItns, Nil)
	
	// Produzido
	oExcel:NewCol("Quantidade 1 Un", 0, 02, nStyleLfCab, Nil)
	oExcel:NewCol(TMPSC2->nD3Quant , 0, 02, nStyleNItns, Nil)
	
	// Perda	
	oExcel:NewCol("Custo Standart"      , 0, 02, nStyleLfCab, Nil)
	oExcel:NewCol(TMPSC2->nCustoStandard, 0, 02, nStyleNItns, Nil)
	
	oExcel:NewRow(Nil) // Segunda Linha Cabe�alho
	// Planejado
	oExcel:NewCol("Unidade de Medida", 0, 02, nStyleLfCab, Nil)
	oExcel:NewCol(TMPSC2->C2_UM      , 0, 02, nStyleCItns, Nil)
	                                                        
	// Produzido
	oExcel:NewCol("Unidade de Medida", 0, 02, nStyleLfCab, Nil)
	oExcel:NewCol(TMPSC2->D3_UM      , 0, 02, nStyleCItns, Nil)
	
	// Perda	
	oExcel:NewCol("Custo Previsto"      , 0, 02, nStyleLfCab, Nil)
	oExcel:NewCol(nCustoPrev, 0, 02, nStyleNItns, Nil)
	
	oExcel:NewRow(Nil) // Terceira Linha Cabe�alho
	// Planejado
	oExcel:NewCol("Quantidade 2 Un" , 0, 02, nStyleLfCab, Nil)
	oExcel:NewCol(TMPSC2->C2_QTSEGUM, 0, 02, nStyleNItns, Nil)
	
	// Produzido
	oExcel:NewCol("Quantidade 2 Un" , 0, 02, nStyleLfCab, Nil)
	oExcel:NewCol(TMPSC2->nD3QtSegUm, 0, 02, nStyleNItns, Nil)
	
	// Perda	
	oExcel:NewCol("Custo Real"      , 0, 02, nStyleLfCab, Nil)
	oExcel:NewCol(nCustReal, 0, 02, nStyleNItns, Nil)
	
	oExcel:NewRow(Nil) // Quarta Linha Cabe�alho
	// Planejado                                              i
	oExcel:NewCol("Unidade de Medida", 0, 02, nStyleLfCab, Nil)
	oExcel:NewCol(TMPSC2->C2_SEGUM   , 0, 02, nStyleCItns, Nil)
	
	// Produzido
	oExcel:NewCol("Unidade de Medida", 0, 02, nStyleLfCab, Nil)
	//oExcel:NewCol(TMPSC2->D3_SEGUM   , 0, 02, nStyleCItns, Nil)
	oExcel:NewCol(TMPSC2->C2_SEGUM   , 0, 02, nStyleCItns, Nil)
	
	// Perda	            
	oExcel:NewCol("Perda R$", 0, 02, nStyleLfCab, Nil)
	oExcel:NewCol(nVTotPerda, 0, 02, nStyleNItns, Nil)

	oExcel:NewRow(Nil) // Quinta Linha Cabe�alho
	oExcel:NewCol(" ", 0, 08, nStyleLfCab, Nil)
	//oExcel:NewCol(TMPSC2->C2_SEGUM   , 0, 02, nStyleCItns, Nil)
	
	// Varia��o
	nPTotPerda := ((nCustReal / nCustoPrev) - 1) * 100
	oExcel:NewCol("Variacao Real x Std %" , 0, 02, nStyleLfCab, Nil)
	oExcel:NewCol(nPTotPerda, 0, 02, nStyleNItns, Nil)

	
	oExcel:NewRow(Nil)
	oExcel:NewCol("Planejado", 0, 04, nStyleBkCab, Nil)
	oExcel:NewCol("Produzido", 0, 04, nStyleBkCab, Nil)
	oExcel:NewCol("Perda"    , 0, 04, nStyleBkCab, Nil)

	oExcel:NewRow(Nil) // Quinta linha - Cabe�alho dos itens
	oExcel:NewCol("Estrutura"   , 0, 01, nStyleBkCab, Nil)
	oExcel:NewCol("Descricao"   , 0, 01, nStyleBkCab, Nil)
	oExcel:NewCol("Empenho"     , 0, 01, nStyleBkCab, Nil)
	oExcel:NewCol("UM"          , 0, 01, nStyleBkCab, Nil)
	oExcel:NewCol("Custo Unit" 	, 0, 01, nStyleBkCab, Nil)
	oExcel:NewCol("Entrada"     , 0, 01, nStyleBkCab, Nil)
	oExcel:NewCol("Requisicao"  , 0, 01, nStyleBkCab, Nil)
	oExcel:NewCol("Devolucao"   , 0, 01, nStyleBkCab, Nil)
	oExcel:NewCol("Perda"       , 0, 01, nStyleBkCab, Nil)
	oExcel:NewCol("Perda R$"    , 0, 01, nStyleBkCab, Nil)
	oExcel:NewCol("% Quantidade", 0, 01, nStyleBkCab, Nil)
	oExcel:NewCol("% Valor"     , 0, 01, nStyleBkCab, Nil)
	
	aStrTmpSc2 := TMPSC2->(DBStruct())
	SX3->(DBSetOrder(2))
	/*
	For nForCpos := 1 To Len(aStrTmpSc2)
		If SX3->(DBSeek(aStrTmpSc2[nForCpos][1])) .And. getSX3Cache(aStrTmpSc2[nForCpos], "X3_TIPO") $ "D/N"
			TCSetField("TMPSC2", getSX3Cache(aStrTmpSc2[nForCpos], "X3_CAMPO"), getSX3Cache(aStrTmpSc2[nForCpos], "X3_TIPO"), getSX3Cache(aStrTmpSc2[nForCpos], "X3_TAMANHO"), getSX3Cache(aStrTmpSc2[nForCpos], "X3_DECIMAL"))
		EndIf
	Next nForCpos
	
	
	getSX3Cache(aStrTmpSc2[nForCpos], "X3_CAMPO")
*/
	DbSelectArea("TMPSC2")

	ProcRegua(nRecCount)

	TMPSC2->(DbGoTop())
 	
 	While TMPSC2->(!Eof())
	
		IncProc("Aguarde gerando planilha...")
		
		nCusReq     := (TMPSC2->nD3FCusto) //-TMPSC2->nD3PCusto)
		nCMReq      := (nCusReq/TMPSC2->nD3RQuant)
   		nPerPerdVal := (TMPSC2->nD3PCusto/nCustoPrev)*100
   		
   		oExcel:NewRow(Nil)
 		oExcel:NewCol(TMPSC2->D4_COD    , 0, 0, nStyleCItns, Nil)
 		oExcel:NewCol(TMPSC2->cB1Desc   , 0, 0, nStyleCItns, Nil)
 		oExcel:NewCol(TMPSC2->D4_ZZQORIG, 0, 0, nStyleNItns, Nil)
 		oExcel:NewCol(TMPSC2->cB1Um     , 0, 0, nStyleCItns, Nil)
 		oExcel:NewCol(nCMReq			, 0, 0, nStyleNItns, Nil) 		
 		oExcel:NewCol(TMPSC2->nD3EQuant , 0, 0, nStyleNItns, Nil)
 		oExcel:NewCol(TMPSC2->nD3RQuant , 0, 0, nStyleNItns, Nil)
 		oExcel:NewCol(TMPSC2->nD3DQuant , 0, 0, nStyleNItns, Nil)
 		oExcel:NewCol(TMPSC2->nD3PQuant , 0, 0, nStyleNItns, Nil)
 		oExcel:NewCol(TMPSC2->nD3PCusto , 0, 0, nStyleNItns, Nil)
 		oExcel:NewCol(TMPSC2->nD3HQuant , 0, 0, nStyleNItns, Nil)
 		oExcel:NewCol(nPerPerdVal		, 0, 0, nStyleNItns, Nil)
 	
		TMPSC2->(DBSkip())
	End
	
	TMPSC2->(DBCloseArea())	
Return(Nil)

/*Static Function AjustaSX1(cGrupo)
	Local aHelpPor   := {}
	Local aHelpEng   := {}                                     
	Local aHelpSpa   := {}

	DbSelectArea("SX1")
	DbSetOrder(1)
	
	If !DBSeek(cGrupo)
	
		aHelpPor := {"Informe o numero da ordem de produ��o"}
		PutSx1(cGrupo, "01", "OP", "OP", "OP", "mv_ch1", "C", Len(SD4->D4_OP), 0, 0, "G", "", "SC2", "", "", "mv_par01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", aHelpPor,aHelpEng,aHelpSpa)
		
	EndIf
Return(Nil)
*/

// Define a Planilha a ser gerada
User Function TSGPlanilha(cNome)
	Local cPlanilha := FileNoExt(AllTrim(cNome)) + ".xls"
	Local cDir		:= AllTrim(GetTempPath(.T.))
		
	If (Right(cDir, 1) <> "\")
		cDir += "\"	
	EndIf 
	
	If !(lIsDir(cDir))

		HS_MsgInf(OemToAnsi("Diretorio [" + AllTrim(cDir) + "] n�o existe, informe um diretorio valido"), "Aten��o", "Destino")

		cDir       := ""
		cPlanlinha := ""  
		
	EndIf
	
Return(cDir + cPlanilha)

User Function TSMntSql(cNumOp, dDatIni, dDatFin, lChangeQry, cRecDe, cRecAte)
	Local cSql := ""
	
	Default lChangeQry := .T.
	
	cSql := "SELECT SC2PAI.C2_NUM, SC2PAI.C2_ITEM, SC2PAI.C2_SEQUEN, SC2PAI.C2_PRODUTO, SC2PAI.C2_QUANT, SC2PAI.C2_UM, SC2PAI.C2_SEGUM, SC2PAI.C2_QTSEGUM, SC2PAI.C2_DATRF, SC2PAI.C2_ZZRECUR AS cC2ZZRecur, " + __EndLine + ;
			"       SB1PAI.B1_DESC, SD3PAI.D3_UM, SD3PAI.D3_SEGUM, (SD3_OP.nD3FCusto-SD3_OP.nD3CusDev) AS nCustoReal, SD3PAI.nD3Quant, (SD3PAI.nD3Quant * SB1PAI.B1_CUSTD) AS nCustoStandard, " + __EndLine + ; 
			"       SD3PAI.nD3QtSegUm, " + __EndLine + ;
			"       SD4FIL.D4_COD, CASE WHEN SD4FIL.D4_ZZQORIG <> 0 THEN SD4FIL.D4_ZZQORIG  ELSE SD4FIL.D4_QTDEORI END D4_ZZQORIG, SD3ZOP.nD3EQuant, " + __EndLine + ;
			"       SD3_OP.nD3RQuant, " + __EndLine + ;
			"       SD3_OP.nD3FCusto, " + __EndLine + ;
			"       SD3ZOP.nD3DQuant, SD3PER.nD3PQuant, SD3PER.nD3PCusto, " + __EndLine + ;
			"       ROUND((SD3PER.nD3PQuant/ SD3_OP.nD3RQuant)*100,2) nD3HQuant, " + __EndLine + ;
			"       SB1FIL.B1_DESC cB1Desc, SB1FIL.B1_UM cB1Um, " + __EndLine + ;
			"       SD3PER.nD3Ganho, SD3PER.nD3Perda " + __EndLine + ;
			"FROM " + RetSqlName("SC2") + " SC2PAI " + __EndLine + ;
			"JOIN " + RetSqlName("SB1") + " SB1PAI ON SB1PAI.D_E_L_E_T_ <> '*' AND SB1PAI.B1_FILIAL = '" + xFilial("SB1") + "' AND SB1PAI.B1_COD = SC2PAI.C2_PRODUTO " + __EndLine + ;
			"JOIN (SELECT SD3PAI.D3_OP, SD3PAI.D3_UM, SD3PAI.D3_SEGUM, " + __EndLine + ;
				 		 "SUM(SD3PAI.D3_QUANT) nD3Quant, " + __EndLine + ;
				 		 "SUM(SD3PAI.D3_QTSEGUM) nD3QtSegUm, " + __EndLine + ;
		  		 		 "SUM(SD3PAI.D3_CUSTO1) nCustoReal " + __EndLine + ;
		  		  "FROM " + RetSqlName("SD3") + " SD3PAI " + __EndLine + ;
		  		  "WHERE SD3PAI.D_E_L_E_T_ <> '*' AND SD3PAI.D3_FILIAL = '" + xFilial("SD3") + "' AND LEFT(SD3PAI.D3_CF,2) = 'PR' AND SD3PAI.D3_ESTORNO = '" + Space(Len(SD3->D3_ESTORNO)) + "' " + __EndLine + ;
		  		  "GROUP BY SD3PAI.D3_OP, SD3PAI.D3_UM, SD3PAI.D3_SEGUM) SD3PAI ON SD3PAI.D3_OP = SC2PAI.C2_NUM + SC2PAI.C2_ITEM + SC2PAI.C2_SEQUEN " + __EndLine + ;
			"JOIN " + RetSqlName("SD4") + " SD4FIL ON SD4FIL.D_E_L_E_T_ <> '*' AND SD4FIL.D4_FILIAL = '" + xFilial("SD4") + "' AND SD4FIL.D4_OP = SC2PAI.C2_NUM + SC2PAI.C2_ITEM + SC2PAI.C2_SEQUEN " + __EndLine + ;
			"JOIN " + RetSqlName("SB1") + " SB1FIL ON SB1FIL.D_E_L_E_T_ <> '*' AND SB1FIL.B1_FILIAL = '" + xFIlial("SB1") + "' AND SB1FIL.B1_COD = SD4FIL.D4_COD " + __EndLine + ;
			"LEFT JOIN (SELECT SD3FIL.D3_ZZOP, SD3FIL.D3_COD, " + __EndLine + ;
				 			  "SUM(CASE WHEN SD3FIL.D3_CF = 'DE4' THEN SD3FIL.D3_QUANT  ELSE 0 END) nD3EQuant, " + __EndLine + ;
				 			  "SUM(CASE WHEN SD3FIL.D3_CF = 'RE4' THEN SD3FIL.D3_QUANT  ELSE 0 END) nD3DQuant " + __EndLine + ;
		  			   "FROM " + RetSqlName("SD3") + " SD3FIL " + __EndLine + ;
		  			   "WHERE SD3FIL.D_E_L_E_T_ <> '*' AND SD3FIL.D3_FILIAL = '" + xFilial("SD3") + "' AND SD3FIL.D3_CF IN ('DE4', 'RE4') AND SD3FIL.D3_ESTORNO = '" + Space(Len(SD3->D3_ESTORNO)) + "' " + __EndLine + ;
		  			   "GROUP BY SD3FIL.D3_ZZOP, SD3FIL.D3_COD) SD3ZOP ON SD3ZOP.D3_ZZOP = SD4FIL.D4_OP AND SD3ZOP.D3_COD = SD4FIL.D4_COD " + __EndLine + ;
			"LEFT JOIN (SELECT SD3FIL.D3_OP, SD3FIL.D3_COD, " + __EndLine + ;
				 		  "(SELECT SUM (D3_QUANT) FROM " + RetSqlName("SD3") + " D3900 WHERE D3900.D_E_L_E_T_ <> '*' AND D3900.D3_FILIAL = '"+xFIlial("SD3")+"' AND D3900.D3_OP = SD3FIL.D3_OP AND D3900.D3_COD = SD3FIL.D3_COD AND D3_TM = '912' AND D3_ESTORNO = '') nD3RQuant, " + __EndLine + ;
				 		  "(SELECT SUM (D3_CUSTO1) FROM " + RetSqlName("SD3") + " D3900 WHERE D3900.D_E_L_E_T_ <> '*' AND D3900.D3_FILIAL = '"+xFIlial("SD3")+"' AND D3900.D3_OP = SD3FIL.D3_OP AND D3900.D3_COD = SD3FIL.D3_COD AND D3_TM = '912' AND D3_ESTORNO = '') nD3FCusto, " + __EndLine + ;
				 		  "SUM(CASE WHEN LEFT(SD3FIL.D3_CF,2) = 'DE' THEN SD3FIL.D3_CUSTO1 ELSE 0 END) nD3CusDev " + __EndLine + ;				 		  
		  		  "FROM " + RetSqlName("SD3") + " SD3FIL " + __EndLine + ;
		  		  "WHERE SD3FIL.D_E_L_E_T_ <> '*' AND SD3FIL.D3_FILIAL = '" + xFilial("SD3") + "' AND LEFT(SD3FIL.D3_CF,2) IN ('RE','DE') AND SD3FIL.D3_ESTORNO = '" + Space(Len(SD3->D3_ESTORNO)) + "' " + __EndLine + ;
		  		  "GROUP BY SD3FIL.D3_OP, SD3FIL.D3_COD) SD3_OP ON SD3_OP.D3_OP = SD4FIL.D4_OP AND SD3_OP.D3_COD = SD4FIL.D4_COD " + __EndLine + ;
		 	"LEFT JOIN (SELECT SD3PER.D3_OP, SD3PER.D3_COD,  " + __EndLine + ;
				         "(SELECT SUM (D3_QUANT) FROM " + RetSqlName("SD3") + " D3901 WHERE D3901.D_E_L_E_T_ <> '*' AND D3901.D3_FILIAL = '"+xFIlial("SD3")+"' AND D3901.D3_OP = SD3PER.D3_OP AND D3901.D3_COD = SD3PER.D3_COD AND D3901.D3_TM = '901') nD3PQuant, " + __EndLine + ;
						 "(SELECT SUM (D3_CUSTO1) FROM " + RetSqlName("SD3") + " D3901 WHERE D3901.D_E_L_E_T_ <> '*' AND D3901.D3_FILIAL = '"+xFIlial("SD3")+"' AND D3901.D3_OP = SD3PER.D3_OP AND D3901.D3_COD = SD3PER.D3_COD AND D3901.D3_TM = '901') nD3PCusto, " + __EndLine + ;
						 "SUM(CASE WHEN SD3PER.D3_CF = 'DE0' AND SD3PER.D3_TM = '480' THEN ISNULL(SD3PER.D3_QUANT,0) ELSE 0 END) nD3Ganho, " + __EndLine + ;
           			     "SUM(CASE WHEN SD3PER.D3_CF = 'RE0' AND SD3PER.D3_TM = '980' THEN ISNULL(SD3PER.D3_QUANT,0) ELSE 0 END) nD3Perda " + __EndLine + ;
				   "FROM " + RetSqlName("SD3") + " SD3PER  " + __EndLine + ;
				   "LEFT JOIN " + RetSqlName("SBC") + " SBC ON SBC.BC_FILIAL = SD3PER.D3_FILIAL AND SBC.BC_SEQSD3 = SD3PER.D3_NUMSEQ AND SBC.D_E_L_E_T_ = ' ' " + __EndLine + ;
				   "WHERE SD3PER.D_E_L_E_T_ <> '*' AND SD3PER.D3_FILIAL = '" + xFilial("SD3") + "' AND (LEFT(SD3PER.D3_CF,2) = 'RE' OR SD3PER.D3_CF = 'DE0') AND SD3PER.D3_ESTORNO = '" + Space(Len(SD3->D3_ESTORNO)) + "' " + __EndLine + ;
				   "GROUP BY SD3PER.D3_OP, SD3PER.D3_COD) SD3PER ON SD3PER.D3_OP = SD4FIL.D4_OP AND SD3PER.D3_COD = SD4FIL.D4_COD  " + __EndLine + ;
			"WHERE SC2PAI.D_E_L_E_T_ <> '*' AND SC2PAI.C2_FILIAL = '" + xFilial("SC2") + "' AND " + __EndLine
			
	If !Empty(cNumOp)
		cSql += "SC2PAI.C2_NUM    = '" + SubStr(cNumOp, 1			                            , Len(SC2->C2_NUM )) + "' AND " + __EndLine + ;
				"SC2PAI.C2_ITEM   = '" + SubStr(cNumOp, Len(SC2->C2_NUM) + 1 				    , Len(SC2->C2_ITEM)) + "' AND " + __EndLine + ;
				"SC2PAI.C2_SEQUEN = '" + SubStr(cNumOp, Len(SC2->C2_NUM) + 1 + Len(SC2->C2_ITEM), Len(SC2->C2_NUM )) + "'"
				
	ElseIf !Empty(dDatIni) .And. !Empty(dDatFin)
		cSql += "SC2PAI.C2_DATRF  >= '" + DToS(dDatIni) + "' AND SC2PAI.C2_DATRF <= '" + DToS(dDatFin) + "' AND " + __EndLine + ;
				"SC2PAI.C2_ZZRECUR  >= '" + cRecDe + "' AND SC2PAI.C2_ZZRECUR <= '" + cRecAte + "' " + __EndLine

	EndIf
	
	cSql += "ORDER BY SC2PAI.C2_NUM, SC2PAI.C2_ITEM, SC2PAI.C2_SEQUEN, SC2PAI.C2_ZZRECUR"
	
Return(cSql)