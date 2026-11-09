#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"

#DEFINE	__EndLine	Chr(13) + Chr(10)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณU_TSRFecOPบ Autor ณ Jos้ Orfeu         บ Data ณ  27/01/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio de Fechamento de Ordem de Produ็ใo               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ PCP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/                         
User Function TSRFecOP()
	Local cAliasOld := Alias()
	Local cPerg     := "TSRFECOP"
	Local cPlanilha := ""
	Local cNome     := DToS(dDataBase) + "_" + StrTran(SubStr(Time(), 1, 5), ":", "_") + "_TSRFecOP"

	//AjustaSX1(cPerg)

	If Pergunte(cPerg, .T.) .And. !Empty(cPlanilha := GetPlanilha(cNome))
 	
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
	nStyleNItns := oExcel:NewStyle(3, 2, 1, Nil, Nil, .F., Nil, Nil, Nil, Nil, Nil, "[$-2]\ #,##0.00_);[Red]\([$-2]\ #,##0.00\)")
	nStyleCItns := oExcel:NewStyle(1, 2, 1, Nil, Nil, .F., Nil, Nil, Nil, Nil, Nil, Nil)
	
	// Define o uso da Barra de Progresso
	oExcel:SetProgressBar(.F.)		

	// Cria uma nova pasta na Planilha	
	oExcel:NewWorkSheet("Perdas e Ganhos")
	
	FSGerXls()
	
	// Gera o XML
	oExcel:GeraXml()
	
	// Abre a Planilha
	oExcel:OpenXml()
Return(Nil)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ FSgerXls บ Autor ณ Jos้ Orfeu         บ Data ณ  09/09/2015 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Monta Array para gera็ใo da planilha Excel                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function FSGerXls()
	Local cSql       := ""
	Local aStrTmpSc2 := {}
	Local nForCpos   := 0
	Local nVTotPerda := 0 
	Local nPTotPerda := 0
	Local nRecCount  := 0
	
	cSql := "SELECT SC2PAI.C2_NUM, SC2PAI.C2_ITEM, SC2PAI.C2_SEQUEN, SC2PAI.C2_PRODUTO, SC2PAI.C2_QUANT, SC2PAI.C2_UM, SC2PAI.C2_SEGUM, SC2PAI.C2_QTSEGUM, SC2PAI.C2_DATRF, " + __EndLine + ;
	        	   "SB1PAI.B1_DESC, " + __EndLine + ;
	        	   "SD3PAI.D3_UM, SD3PAI.D3_SEGUM, SD3PAI.nCustoStandart, SD3PAI.nCustoReal, SD3PAI.nD3Quant, SD3PAI.nD3QtSegUm, " + __EndLine + ;
	        	   "SD4FIL.D4_COD, SD4FIL.D4_QTDEORI, SD3ZOP.nD3EQuant, SD3_OP.nD3RQuant, SD3ZOP.nD3DQuant, " + __EndLine + ;
	        	   "(SD3ZOP.nD3EQuant - SD3_OP.nD3RQuant - SD3ZOP.nD3DQuant) nD3PQuant, SD3_OP.nD3FCusto, " + __EndLine + ;
	        	   "((SD3ZOP.nD3EQuant - SD3_OP.nD3RQuant - SD3ZOP.nD3DQuant) / SD3ZOP.nD3EQuant)*100 nD3HQuant, " + __EndLine + ;
	        	   "(SD3_OP.nD3FCusto / SD3ZOP.nD3GCusto)*100 nD3GCusto, " + __EndLine + ;
	        	   "SB1FIL.B1_DESC cB1Desc, SB1FIL.B1_UM cB1Um" + __EndLine + ;
			"FROM " + RetSqlName("SC2") + " SC2PAI " + __EndLine + ;
			"JOIN " + RetSqlName("SB1") + " SB1PAI ON SB1PAI.D_E_L_E_T_ <> '*' AND SB1PAI.B1_FILIAL = '  ' AND SB1PAI.B1_COD = SC2PAI.C2_PRODUTO " + __EndLine + ;
			"JOIN (SELECT SD3PAI.D3_OP, SD3PAI.D3_UM, SD3PAI.D3_SEGUM, " + __EndLine + ;
				 		 "SUM(SD3PAI.D3_QUANT) nD3Quant, " + __EndLine + ;
				 		 "SUM(SD3PAI.D3_QTSEGUM) nD3QtSegUm, " + __EndLine + ;
		  		 		 "SUM(SD3PAI.D3_QUANT * SB2PAI.B2_CM1) nCustoStandart, " + __EndLine + ;
		  		 		 "SUM(SD3PAI.D3_CUSTO1) nCustoReal " + __EndLine + ;
		  		  "FROM " + RetSqlName("SD3") + " SD3PAI " + __EndLine + ;
		  		  "JOIN " + RetSqlName("SB2") + " SB2PAI ON SB2PAI.D_E_L_E_T_ <> '*' AND SB2PAI.B2_FILIAL = '" + xFilial("SB2") + "' AND SB2PAI.B2_COD = SD3PAI.D3_COD AND SB2PAI.B2_LOCAL = SD3PAI.D3_LOCAL " + __EndLine + ;
		  		  "WHERE SD3PAI.D_E_L_E_T_ <> '*' AND SD3PAI.D3_FILIAL = '" + xFilial("SD3") + "' AND SD3PAI.D3_CF = 'PR0' AND SD3PAI.D3_ESTORNO = '" + Space(Len(SD3->D3_ESTORNO)) + "' " + __EndLine + ;
		  		  "GROUP BY SD3PAI.D3_OP, SD3PAI.D3_UM, SD3PAI.D3_SEGUM) SD3PAI ON SD3PAI.D3_OP = SC2PAI.C2_NUM + SC2PAI.C2_ITEM + SC2PAI.C2_SEQUEN " + __EndLine + ;
			"JOIN " + RetSqlName("SD4") + " SD4FIL ON SD4FIL.D_E_L_E_T_ <> '*' AND SD4FIL.D4_FILIAL = '" + xFilial("SD4") + "' AND SD4FIL.D4_OP = SC2PAI.C2_NUM + SC2PAI.C2_ITEM + SC2PAI.C2_SEQUEN " + __EndLine + ;
			"JOIN " + RetSqlName("SB1") + " SB1FIL ON SB1FIL.D_E_L_E_T_ <> '*' AND SB1FIL.B1_FILIAL = '" + xFIlial("SB1") + "' AND SB1FIL.B1_COD = SD4FIL.D4_COD " + __EndLine + ;
			"LEFT JOIN (SELECT SD3FIL.D3_ZZOP, SD3FIL.D3_COD, " + __EndLine + ;
				 			  "SUM(CASE WHEN SD3FIL.D3_CF = 'DE4' THEN SD3FIL.D3_QUANT  ELSE 0 END) nD3EQuant, " + __EndLine + ;
				 			  "SUM(CASE WHEN SD3FIL.D3_CF = 'DE4' THEN SD3FIL.D3_CUSTO1 ELSE 0 END) nD3GCusto, " + __EndLine + ;
				 			  "SUM(CASE WHEN SD3FIL.D3_CF = 'RE0' THEN SD3FIL.D3_QUANT  ELSE 0 END) nD3DQuant " + __EndLine + ;
		  			   "FROM " + RetSqlName("SD3") + " SD3FIL " + __EndLine + ;
		  		  	   "JOIN " + RetSqlName("SB2") + " SB2FIL ON SB2FIL.D_E_L_E_T_ <> '*' AND SB2FIL.B2_FILIAL = '" +  xFilial("SB2") + "' AND SB2FIL.B2_COD = SD3FIL.D3_COD AND SB2FIL.B2_LOCAL = SD3FIL.D3_LOCAL " + __EndLine + ;
		  			   "WHERE SD3FIL.D_E_L_E_T_ <> '*' AND SD3FIL.D3_FILIAL = '01' AND SD3FIL.D3_CF IN ('DE4', 'RE0') AND SD3FIL.D3_ESTORNO = '" + Space(Len(SD3->D3_ESTORNO)) + "' " + __EndLine + ;
		  			   "GROUP BY SD3FIL.D3_ZZOP, SD3FIL.D3_COD) SD3ZOP ON SD3ZOP.D3_ZZOP = SD4FIL.D4_OP AND SD3ZOP.D3_COD = SD4FIL.D4_COD " + __EndLine + ;
			"JOIN (SELECT SD3FIL.D3_OP, SD3FIL.D3_COD, " + __EndLine + ;
				 		  "SUM(CASE WHEN SD3FIL.D3_DTVALID =  '        ' THEN SD3FIL.D3_QUANT  ELSE 0 END) nD3RQuant, " + __EndLine + ;
				 		  "SUM(CASE WHEN SD3FIL.D3_DTVALID <> '        ' THEN SD3FIL.D3_CUSTO1 ELSE 0 END) nD3FCusto " + __EndLine + ;
		  		  "FROM " + RetSqlName("SD3") + " SD3FIL " + __EndLine + ;
		  		  "JOIN " + RetSqlName("SB2") + " SB2FIL ON SB2FIL.D_E_L_E_T_ <> '*' AND SB2FIL.B2_FILIAL = '" + xFilial("SB2") + "' AND SB2FIL.B2_COD = SD3FIL.D3_COD AND SB2FIL.B2_LOCAL = SD3FIL.D3_LOCAL " + __EndLine + ;
		  		  "WHERE SD3FIL.D_E_L_E_T_ <> '*' AND SD3FIL.D3_FILIAL = '" + xFilial("SD3") + "' AND SD3FIL.D3_CF = 'RE1' AND SD3FIL.D3_ESTORNO = '" + Space(Len(SD3->D3_ESTORNO)) + "' " + __EndLine + ;
		  		  "GROUP BY SD3FIL.D3_OP, SD3FIL.D3_COD) SD3_OP ON SD3_OP.D3_OP = SD4FIL.D4_OP AND SD3_OP.D3_COD = SD4FIL.D4_COD " + __EndLine + ;
			"WHERE SC2PAI.D_E_L_E_T_ <> '*' AND SC2PAI.C2_FILIAL = '" + xFilial("SC2") + "' AND " + __EndLine + ;
				  "SC2PAI.C2_NUM    = '" + SubStr(MV_PAR01, 1			                            , Len(SC2->C2_NUM )) + "' AND " + __EndLine + ;
				  "SC2PAI.C2_ITEM   = '" + SubStr(MV_PAR01, Len(SC2->C2_NUM) + 1 				    , Len(SC2->C2_ITEM)) + "' AND " + __EndLine + ;
				  "SC2PAI.C2_SEQUEN = '" + SubStr(MV_PAR01, Len(SC2->C2_NUM) + 1 + Len(SC2->C2_ITEM), Len(SC2->C2_NUM)) + "'"
				  
	TCQuery ChangeQuery(cSql) New Alias "TMPSC2"
	
	DBSelectArea("TMPSC2")
	DBGoTop()
	
	While TMPSC2->(!Eof())
		nVTotPerda += TMPSC2->nD3FCusto
		nRecCount  ++
		
		TMPSC2->(DBSkip())
	End
	
	TMPSC2->(DBGoTop())
	
	oExcel:NewRow(Nil)
	oExcel:NewCol("OP: [" + IIf(Empty(TMPSC2->C2_DATRF), "ABERTA", "FECHADA") + "] " + TMPSC2->C2_NUM + TMPSC2->C2_ITEM + SC2->C2_SEQUEN + " Produto: " + TMPSC2->C2_PRODUTO + " Descricao: " + TMPSC2->B1_DESC, 0, 11, nStyleCabec, Nil)
	                  
	oExcel:NewRow(Nil)
	oExcel:NewCol("Planejado", 0, 04, nStyleBkCab, Nil)
	oExcel:NewCol("Produzido", 0, 04, nStyleBkCab, Nil)
	oExcel:NewCol("Perda"    , 0, 03, nStyleBkCab, Nil)
	                                                        
	oExcel:NewRow(Nil) // Primeira Linha Cabe็alho
	// Planejado
	oExcel:NewCol("Quantidade 1 Un", 0, 02, nStyleLfCab, Nil)
	oExcel:NewCol(TMPSC2->C2_QUANT , 0, 02, nStyleNItns, Nil)
	
	// Produzido
	oExcel:NewCol("Quantidade 1 Un", 0, 02, nStyleLfCab, Nil)
	oExcel:NewCol(TMPSC2->nD3Quant , 0, 02, nStyleNItns, Nil)
	
	// Perda	
	oExcel:NewCol("Custo Standart"      , 0, 02, nStyleLfCab, Nil)
	oExcel:NewCol(TMPSC2->nCustoStandart, 0, 01, nStyleNItns, Nil)
	
	oExcel:NewRow(Nil) // Segunda Linha Cabe็alho
	// Planejado
	oExcel:NewCol("Unidade de Medida", 0, 02, nStyleLfCab, Nil)
	oExcel:NewCol(TMPSC2->C2_UM      , 0, 02, nStyleCItns, Nil)
	
	// Produzido
	oExcel:NewCol("Unidade de Medida", 0, 02, nStyleLfCab, Nil)
	oExcel:NewCol(TMPSC2->D3_UM      , 0, 02, nStyleCItns, Nil)
	
	// Perda	
	oExcel:NewCol("Custo Real"      , 0, 02, nStyleLfCab, Nil)
	oExcel:NewCol(TMPSC2->nCustoReal, 0, 01, nStyleNItns, Nil)
	
	oExcel:NewRow(Nil) // Terceira Linha Cabe็alho
	// Planejado
	oExcel:NewCol("Quantidade 2 Un" , 0, 02, nStyleLfCab, Nil)
	oExcel:NewCol(TMPSC2->C2_QTSEGUM, 0, 02, nStyleNItns, Nil)
	
	// Produzido
	oExcel:NewCol("Quantidade 2 Un" , 0, 02, nStyleLfCab, Nil)
	oExcel:NewCol(TMPSC2->nD3QtSegUm, 0, 02, nStyleNItns, Nil)
	
	// Perda	
	oExcel:NewCol("Perda R$", 0, 02, nStyleLfCab, Nil)
	oExcel:NewCol(nVTotPerda, 0, 01, nStyleNItns, Nil)
	
	oExcel:NewRow(Nil) // Quarta Linha Cabe็alho
	// Planejado
	oExcel:NewCol("Unidade de Medida", 0, 02, nStyleLfCab, Nil)
	oExcel:NewCol(TMPSC2->C2_SEGUM   , 0, 02, nStyleCItns, Nil)
	
	// Produzido
	oExcel:NewCol("Unidade de Medida", 0, 02, nStyleLfCab, Nil)
	oExcel:NewCol(TMPSC2->D3_SEGUM   , 0, 02, nStyleCItns, Nil)
	
	// Perda	            
	nPTotPerda := ((TMPSC2->nCustoReal / TMPSC2->nCustoStandart) - 1) * 100
	oExcel:NewCol("Perda %" , 0, 02, nStyleLfCab, Nil)
	oExcel:NewCol(nPTotPerda, 0, 01, nStyleNItns, Nil)
	
	oExcel:NewRow(Nil) // Quinta linha - Cabe็alho dos itens
	oExcel:NewCol("Estrutura"   , 0, 01, nStyleBkCab, Nil)
	oExcel:NewCol("Descricao"   , 0, 01, nStyleBkCab, Nil)
	oExcel:NewCol("Empenho"     , 0, 01, nStyleBkCab, Nil)
	oExcel:NewCol("UM"          , 0, 01, nStyleBkCab, Nil)
	oExcel:NewCol("Entrada"     , 0, 01, nStyleBkCab, Nil)
	oExcel:NewCol("Requisicao"  , 0, 01, nStyleBkCab, Nil)
	oExcel:NewCol("Devolucao"   , 0, 01, nStyleBkCab, Nil)
	oExcel:NewCol("Perda"       , 0, 01, nStyleBkCab, Nil)
	oExcel:NewCol("Perda R$"    , 0, 01, nStyleBkCab, Nil)
	oExcel:NewCol("% Quantidade", 0, 01, nStyleBkCab, Nil)
	oExcel:NewCol("% Valor"     , 0, 01, nStyleBkCab, Nil)
	
	aStrTmpSc2 := TMPSC2->(DBStruct())
	SX3->(DBSetOrder(2))
	For nForCpos := 1 To Len(aStrTmpSc2)
		If SX3->(DBSeek(aStrTmpSc2[nForCpos][1])) .And. getSX3Cache(aStrTmpSc2[nForCpos], "X3_TIPO") $ "D/N"
			TCSetField("TMPSC2", getSX3Cache(aStrTmpSc2[nForCpos], "X3_CAMPO"), getSX3Cache(aStrTmpSc2[nForCpos], "X3_TIPO"), getSX3Cache(aStrTmpSc2[nForCpos], "X3_TAMANHO"), getSX3Cache(aStrTmpSc2[nForCpos], "X3_DECIMAL"))
		EndIf
	Next nForCpos

	DbSelectArea("TMPSC2")

	ProcRegua(nRecCount)

	TMPSC2->(DbGoTop())
 	
 	While TMPSC2->(!Eof())
	
		IncProc("Aguarde gerando planilha...")
		
   		oExcel:NewRow(Nil)
 		oExcel:NewCol(TMPSC2->D4_COD    , 0, 0, nStyleCItns, Nil)
 		oExcel:NewCol(TMPSC2->cB1Desc   , 0, 0, nStyleCItns, Nil)
 		oExcel:NewCol(TMPSC2->D4_QTDEORI, 0, 0, nStyleNItns, Nil)
 		oExcel:NewCol(TMPSC2->cB1Um     , 0, 0, nStyleCItns, Nil)
 		oExcel:NewCol(TMPSC2->nD3EQuant , 0, 0, nStyleNItns, Nil)
 		oExcel:NewCol(TMPSC2->nD3RQuant , 0, 0, nStyleNItns, Nil)
 		oExcel:NewCol(TMPSC2->nD3DQuant , 0, 0, nStyleNItns, Nil)
 		oExcel:NewCol(TMPSC2->nD3PQuant , 0, 0, nStyleNItns, Nil)
 		oExcel:NewCol(TMPSC2->nD3FCusto , 0, 0, nStyleNItns, Nil)
 		oExcel:NewCol(TMPSC2->nD3HQuant , 0, 0, nStyleNItns, Nil)
 		oExcel:NewCol(TMPSC2->nD3GCusto , 0, 0, nStyleNItns, Nil)
 		
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
	
		aHelpPor := {"Informe o numero da ordem de produ็ใo"}
		PutSx1(cGrupo, "01", "OP", "OP", "OP", "mv_ch1", "C", Len(SD4->D4_OP), 0, 0, "G", "", "SC2", "", "", "mv_par01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", aHelpPor,aHelpEng,aHelpSpa)
		
	EndIf
Return(Nil)
*/
// Define a Planilha a ser gerada
Static Function GetPlanilha(cNome)
	Local cPlanilha := FileNoExt(AllTrim(cNome)) + ".xls"
	Local cDir		:= AllTrim(GetTempPath(.T.))
		
	If (Right(cDir, 1) <> "\")
		cDir += "\"	
	EndIf 
	
	If !(lIsDir(cDir))

		HS_MsgInf(OemToAnsi("Diretorio [" + AllTrim(cDir) + "] nใo existe, informe um diretorio valido"), "Aten็ใo", "Destino")

		cDir       := ""
		cPlanlinha := ""  
		
	EndIf
	
Return(cDir + cPlanilha)

Static Function FSRetChr(cString, cStrRet)
	Local cStrNew := ""
	Local nForStr := 0
	Local aStrRet := {{"<", "&lt;"}, {">", "&gt;"}}
	Local cStrPor := ""
	Local nPosStr := 0
	
	cStrNew := cString
	
	For nForStr := 1 To Len(cStrRet)
		If (nPosStr := aScan(aStrRet, {| aVet | aVet[1] == SubStr(cStrRet, nForStr, 1)})) > 0
			cStrPor := aStrRet[nPosStr][2]
			
		Else 
			cStrPor := ""
			
		EndIf
		
		cStrNew := StrTran(cStrNew, SubStr(cStrRet, nForStr, 1), cStrPor)
	Next
	
Return(cStrNew)