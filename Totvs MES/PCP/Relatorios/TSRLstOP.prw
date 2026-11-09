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
User Function TSRLstOP()
	Local cAliasOld := Alias()
	Local cPerg     := "TSRLSTOP"
	Local cPlanilha := ""
	Local cNome     := DToS(dDataBase) + "_" + StrTran(SubStr(Time(), 1, 5), ":", "_") + "_TSRLstOP"

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
	oExcel:NewWorkSheet("Listagem de Ordem de Producao")
	
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
	Local nVTotPerda 	 := 0   // Perda
	// Local nPTotPerda 	 := 0   // Perda %
	Local nVCusPrev 	 := 0   // Custo Previsto
	Local nQtdMOD	 	 := 0   // Qtd de M�o de Obra
	// Local nRecCount  	 := 0
	Local nVCustReal	 := 0   // Custo Real
	Local nQtdProd		 := 0   // Quantidade Produzida
	Local cOp            := ""
	Local cRecurso       := ""
	Local cPai			 := ""
	Local cDescPai		 := ""
	
	cSql := U_TSMntSql(Nil, MV_PAR01, MV_PAR02,Nil,MV_PAR03,MV_PAR04) //(cNumOp, dDatIni, dDatFin, lChangeQry)
				  
	TCQuery ChangeQuery(cSql) New Alias "TMPSC2"
	
	aStrTmpSc2 := TMPSC2->(DBStruct())
	/*
	SX3->(DBSetOrder(2))
	For nForCpos := 1 To Len(aStrTmpSc2)
		If SX3->(DBSeek(aStrTmpSc2[nForCpos][1])) .And. getSX3Cache(aStrTmpSc2[nForCposnX], "X3_TIPO") $ "D/N"
			TCSetField("TMPSC2", getSX3Cache(aStrTmpSc2[nForCposnX], "X3_CAMPO"), getSX3Cache(aStrTmpSc2[nForCposnX], "X3_TIPO"), getSX3Cache(aStrTmpSc2[nForCposnX], "X3_TAMANHO"), getSX3Cache(aStrTmpSc2[nForCposnX], "X3_DECIMAL"))
		EndIf
	Next nForCpos
   
   getSX3Cache(aStrTmpSc2[nForCposnX], "X3_CAMPO")
	*/

    
	DbSelectArea("TMPSC2")
	DBGoTop()
	
	ProcRegua(0)
	
	oExcel:NewRow(Nil)
	oExcel:NewCol("Data"               , 0, 01, nStyleBkCab, Nil)
	oExcel:NewCol("OP"                 , 0, 01, nStyleBkCab, Nil)
	oExcel:NewCol("Codigo"             , 0, 01, nStyleBkCab, Nil)
	oExcel:NewCol("Descricao"          , 0, 01, nStyleBkCab, Nil)
	oExcel:NewCol("Qtd. Produzida"     , 0, 01, nStyleBkCab, Nil)
	oExcel:NewCol("UM"                 , 0, 01, nStyleBkCab, Nil)
	oExcel:NewCol("Qtd. Produzida 2 UM", 0, 01, nStyleBkCab, Nil)
	oExcel:NewCol("2 UnidaDe"          , 0, 01, nStyleBkCab, Nil)
	oExcel:NewCol("Custo Previsto"     , 0, 01, nStyleBkCab, Nil)
	oExcel:NewCol("Custo Real"         , 0, 01, nStyleBkCab, Nil)
	oExcel:NewCol("Perda"              , 0, 01, nStyleBkCab, Nil)
	oExcel:NewCol("Perda %"            , 0, 01, nStyleBkCab, Nil)
	oExcel:NewCol("MOD."               , 0, 01, nStyleBkCab, Nil)
	oExcel:NewCol("Codigo Recurso"     , 0, 01, nStyleBkCab, Nil)
	oExcel:NewCol("Maquina"            , 0, 01, nStyleBkCab, Nil)	

 	While TMPSC2->(!Eof())
	
		IncProc("Aguarde gerando planilha...")
		
		DBSelectArea("SH1")
		DBSetOrder(1)
		DBSeek(xFilial("SH1") + TMPSC2->cC2ZZRecur)
		
		cOp      	:= TMPSC2->(C2_NUM + C2_ITEM +C2_SEQUEN)
		cRecurso 	:= TMPSC2->cC2ZZRecur
		cPai 	 	:= TMPSC2->C2_PRODUTO
		cDescPai 	:= TMPSC2->B1_DESC
		cDtaPrf	 	:= Dtoc(Stod(TMPSC2->C2_DATRF)) // DToC(TMPSC2->C2_DATRF)
		cUM		 	:= TMPSC2->C2_UM
		c2UM	 	:= TMPSC2->C2_SEGUM
		nQtdProd 	:= TMPSC2->nD3Quant
		nQtSegUM 	:= TMPSC2->nD3QtSegUm

		nVTotPerda 	:= 0
		nVCusPrev  	:= 0
		nVCustReal 	:= 0
		nQtdMOD	   	:= 0
		
		DBSelectArea("TMPSC2")
		While TMPSC2->(!Eof()) .And. cOp = TMPSC2->(C2_NUM + C2_ITEM +C2_SEQUEN) //.And. cRecurso == TMPSC2->cC2ZZRecur
			
			nVTotPerda += TMPSC2->nD3PCusto
			nVCusPrev  += TMPSC2->nD3FCusto
			nVCustReal += TMPSC2->nCustoReal
	
			If substr(TMPSC2->D4_COD,1,3) = "MOD"
				nQtdMOD += TMPSC2->nD3RQuant
			EndIf
 		 	    
			TMPSC2->(DBSkip())
		
		End
		
		oExcel:NewRow(Nil)
 		oExcel:NewCol(cDtaPrf				                , 0, 0, nStyleCItns, Nil)
 		oExcel:NewCol(cOP									, 0, 0, nStyleCItns, Nil)
 		oExcel:NewCol(cPai				                    , 0, 0, nStyleCItns, Nil)
 		oExcel:NewCol(cDescPai		                        , 0, 0, nStyleCItns, Nil)
 		oExcel:NewCol(nQtdProd                              , 0, 0, nStyleNItns, Nil)
 		oExcel:NewCol(cUM                                   , 0, 0, nStyleCItns, Nil)
 		oExcel:NewCol(nQtSegUM                              , 0, 0, nStyleNItns, Nil)
 		oExcel:NewCol(c2UM                                  , 0, 0, nStyleCItns, Nil)
 		oExcel:NewCol(nVCusPrev			                    , 0, 0, nStyleNItns, Nil)
 		oExcel:NewCol(nVCustReal+nVTotPerda                 , 0, 0, nStyleNItns, Nil)
 		oExcel:NewCol(nVTotPerda		                    , 0, 0, nStyleNItns, Nil)
 		oExcel:NewCol((nVTotPerda/nVCusPrev)*100			, 0, 0, nStyleNItns, Nil)
 		oExcel:NewCol(nQtdMOD			                    , 0, 0, nStyleNItns, Nil)
 	    oExcel:NewCol(cRecurso			                    , 0, 0, nStyleCItns, Nil)
 		oExcel:NewCol(SH1->H1_DESCRI                        , 0, 0, nStyleCItns, Nil)

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
	
		aHelpPor := {"Informe a data inicial"}
		PutSx1(cGrupo, "01", "Da Data?" , "", "", "mv_ch1", "D", 08, 0, 0, "G", "", "", "", "", "MV_PAR01", "",	"",	"",	"",	"",	"",	"",	"", "", "", "", "", "", "", "", "", aHelpPor,aHelpEng,aHelpSpa)
		
		aHelpPor := {"Informe a data final"}
	    PutSx1(cGrupo, "02", "At� Data?", "", "", "mv_ch2", "D", 08, 0, 0, "G", "", "", "", "", "MV_PAR02", "", "",	"",	"",	"",	"", "",	"", "", "", "", "", "", "", "", "", aHelpPor,aHelpEng,aHelpSpa)

		aHelpPor := {"Recurso de"}
		PutSx1(cGrupo, "03", "Recurso de", "", "", "mv_ch3", "C", Len(SD3->D3_ZZRECUR), 0, 0, "G", "", "SH1", "", "", "mv_par03", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", aHelpPor,aHelpEng,aHelpSpa)	

		aHelpPor := {"Recurso ate"}
		PutSx1(cGrupo, "04", "Recurso ate", "", "", "mv_ch4", "C", Len(SD3->D3_ZZRECUR), 0, 0, "G", "", "SH1", "", "", "mv_par04", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", aHelpPor,aHelpEng,aHelpSpa)
		
	EndIf
Return(Nil)
*/