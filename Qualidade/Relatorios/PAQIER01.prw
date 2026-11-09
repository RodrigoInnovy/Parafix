#include 'totvs.ch'
#include 'topconn.ch'

/*/{Protheus.doc} PAQIER01

Relatório medições Inspeção de Entradas

@type function
@author Felipe Campos - TOTVSIP
@since 10/07/2022

/*/

User Function PAQIER01()
	Local oReport
	If !Pergunte('PAQIER01',.T.)
		Return
	EndIf
	/*
	mv_par01 -> data de
	mv_par02 -> data até
	*/	
	//Interface de impressão
	oReport := ReportDef()
	oReport:PrintDialog()
Return
//------------------------------------------------------------
//  Definições do relatório
//------------------------------------------------------------
Static Function ReportDef()
	Local oReport, oSection1

	oReport := TReport():New('PAQIER01', "Medições",'PAQIER01',{|oReport| ReportPrint(oReport)},"Este programa tem como objetivo imprimir relatorio de acordo com os parametros informados pelo usuario.")


	oSection1 := TRSection():New(oReport,"Itens",,,,,,,/*.T.*/,/*.T.*/,,,,,3,,,2)
	TRCell():New(oSection1,'QEK_DTENTR'   	,,"Data Entrada" 		, pesqPict("QEK","QEK_DTENTR")	, TamSx3("QEK_DTENTR")[1],/*lPixel*/,{|| QRY->QEK_DTENTR },/*Alinhamento*/)
	TRCell():New(oSection1,'QEK_NTFISC'   	,,"Nota Fiscal" 		, pesqPict("QEK","QEK_NTFISC")	, TamSx3("QEK_NTFISC")[1],/*lPixel*/,{|| QRY->QEK_NTFISC },/*Alinhamento*/)
	TRCell():New(oSection1,'QEK_SERINF'   	,,"Serie "              , pesqPict("QEK","QEK_SERINF")	, TamSx3("QEK_SERINF")[1],/*lPixel*/,{|| QRY->QEK_SERINF },/*Alinhamento*/)
	TRCell():New(oSection1,'A2_NOME'   	    ,,"Fornecedor "         , pesqPict("SA2","A2_NOME")     , TamSx3("A2_NOME")[1],/*lPixel*/,{|| QRY->A2_NOME },/*Alinhamento*/)
	TRCell():New(oSection1,'A2_LOJA'   	    ,,"Loja "               , pesqPict("SA2","A2_LOJA")	    , TamSx3("A2_LOJA")[1],/*lPixel*/,{|| QRY->A2_LOJA },/*Alinhamento*/)
	TRCell():New(oSection1,'QER_PRODUT'   	,,"Cód Produto "        , pesqPict("QER","QER_PRODUT")	, TamSx3("QER_PRODUT")[1],/*lPixel*/,{|| QRY->QER_PRODUT },/*Alinhamento*/)
	TRCell():New(oSection1,'B1_DESC'   	    ,,"Descrição "          , pesqPict("SB1","B1_DESC")	    , TamSx3("B1_DESC")[1],/*lPixel*/,{|| QRY->B1_DESC },/*Alinhamento*/)
	TRCell():New(oSection1,'D1_QUANT'   	,,"Qtd. NFE "           , pesqPict("SD1","D1_QUANT")	, TamSx3("D1_QUANT")[1],/*lPixel*/,{|| QRY->D1_QUANT },/*Alinhamento*/)
	TRCell():New(oSection1,'QER_ENSAIO'   	,,"Ensaio "              , pesqPict("QER","QER_ENSAIO")	, TamSx3("QER_ENSAIO")[1],/*lPixel*/,{|| QRY->QER_ENSAIO },/*Alinhamento*/)
	TRCell():New(oSection1,'QE1_DESCPO'   	,,"Descrição Ensaio "    , pesqPict("QE1","QE1_DESCPO")	, TamSx3("QE1_DESCPO")[1],/*lPixel*/,{|| QRY->QE1_DESCPO },/*Alinhamento*/)
	TRCell():New(oSection1,'QAA_NOME'   	,,"Ensaiador        "    , pesqPict("QAA","QAA_NOME")	, TamSx3("QAA_NOME")[1],/*lPixel*/,{|| QRY->QAA_NOME },/*Alinhamento*/)
	TRCell():New(oSection1,'QER_DTMEDI'   	,,"Data Medição "        , pesqPict("QER","QER_DTMEDI")	, TamSx3("QER_DTMEDI")[1],/*lPixel*/,{|| QRY->QER_DTMEDI },/*Alinhamento*/)
	TRCell():New(oSection1,'QER_HRMEDI'   	,,"Hora Medição "        , pesqPict("QER","QER_HRMEDI")	, TamSx3("QER_HRMEDI")[1],/*lPixel*/,{|| QRY->QER_HRMEDI },/*Alinhamento*/)
	TRCell():New(oSection1,'QER_RESULT'   	,,"A/R "                 , pesqPict("QER","QER_RESULT")	, TamSx3("QER_RESULT")[1],/*lPixel*/,{|| QRY->QER_RESULT },/*Alinhamento*/)
	TRCell():New(oSection1,'QE7_LIE'   	    ,,"LIE "                 , pesqPict("QE7","QE7_LIE")	, TamSx3("QE7_LIE")[1],/*lPixel*/,{|| QRY->QE7_LIE },/*Alinhamento*/)
	TRCell():New(oSection1,'QE7_LSE'      	,,"LSE "                 , pesqPict("QE7","QE7_LSE")	, TamSx3("QE7_LSE")[1],/*lPixel*/,{|| QRY->QE7_LSE },/*Alinhamento*/)
	TRCell():New(oSection1,'QES_MEDICA'   	,,"Medição "             , pesqPict("QES","QES_MEDICA")	, TamSx3("QES_MEDICA")[1],/*lPixel*/,{|| QRY->QES_MEDICA },/*Alinhamento*/)
	TRCell():New(oSection1,'QER_ZLOTE '   	,,"Lote Fornecedor "     , pesqPict("QER","QER_ZLOTE")  , TamSx3("QER_ZLOTE")[1],/*lPixel*/,{|| QRY->QER_ZLOTE },/*Alinhamento*/)
	TRCell():New(oSection1,'D1_DTVALID'   	,,"Dt Valid Lote"        , pesqPict("SD1","D1_DTVALID")	, TamSx3("D1_DTVALID")[1],/*lPixel*/,{|| QRY->D1_DTVALID },/*Alinhamento*/)
	TRCell():New(oSection1,"cDescNFC"       ,,"Não Conformidade"     ,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"nQtdNFC"        ,,"Qtd NFC"              ,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"cClasNFC"       ,,"Classe NFC"           ,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"cDemIQI"        ,,"Dem. IQI"             ,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,'QEL_LAUDO'   	,,"Laudo Final"          , pesqPict("QEL","QEL_LAUDO"), TamSx3("QEL_LAUDO")[1],/*lPixel*/,{|| QRY->QEL_LAUDO},/*Alinhamento*/)
	TRCell():New(oSection1,'QEL_JUSTLA'   	,,"Observação"           , pesqPict("QEL","QEL_JUSTLA"), TamSx3("QEL_JUSTLA")[1],/*lPixel*/,{|| QRY->QEL_JUSTLA},/*Alinhamento*/)
	TRCell():New(oSection1,"cLaudo"         ,,"Status Laudo"         ,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

	oReport:setLandScape()
	oReport:HideParamPage()

Return(oReport)

//-----------------------------------------------------------
// Impressão do relatório
//-----------------------------------------------------------
Static Function ReportPrint(oReport)
	Local oSection1 := oReport:Section(1)
	Local cQuery	:= ""
	Local nRegs		:= 0

	If Select("QRY") > 0
		QRY->(dbCloseArea())
	Endif
	
	cQuery := " SELECT QEK_SITENT, QEK_DTENTR, QEK_NTFISC, QEK_SERINF, A2_NOME , A2_LOJA , QER_PRODUT, B1_DESC, QER_ENSAIO, QE1_DESCPO, QAA_NOME, QER_DTMEDI, QER_HRMEDI, QER_RESULT,  " + CRLF
	cQuery += " QE7_LIE, QE7_LSE, QES_CODMED CODMED, QES_MEDICA, QER_ZLOTE , D1_QUANT, D1_DTVALID, QEL_LAUDO, QEL_JUSTLA"       + CRLF
	cQuery += " FROM "+RetSqlTab("QER")+" "                                             + CRLF
	cQuery += " INNER JOIN "+RetSqlTab("QE1")+" ON 1 = 1 "                              + CRLF
	cQuery += " AND "+RetSqlDel("QE1")+" "                                              + CRLF
	cQuery += " AND "+RetSqlFil("QE1")+" "                                              + CRLF
	cQuery += " AND QE1_ENSAIO = QER_ENSAIO "                                           + CRLF
	cQuery += " INNER JOIN "+RetSqlTab("QE7")+" ON 1 = 1 "                              + CRLF
	cQuery += " AND "+RetSqlDel("QE7")+" "                                              + CRLF
	cQuery += " AND "+RetSqlFil("QE7")+" "                                              + CRLF
	cQuery += " AND  QE7_PRODUT = QER_PRODUT "                                          + CRLF
	cQuery += " AND  QE7_ENSAIO = QER_ENSAIO "                                          + CRLF
	cQuery += " AND  QE7_REVI   = QER_REVI "                                            + CRLF
	cQuery += " INNER JOIN "+RetSqlTab("QES")+" ON 1 = 1 "                              + CRLF
	cQuery += " AND "+RetSqlDel("QES")+" "                                              + CRLF
	cQuery += " AND "+RetSqlFil("QES")+" "                                              + CRLF
	cQuery += " AND QES_CODMED = QER_CHAVE "                                            + CRLF
	cQuery += " INNER JOIN "+RetSqlTab("QEK")+" ON 1 = 1 "                              + CRLF
	cQuery += " AND "+RetSqlDel("QEK")+" "                                              + CRLF
	cQuery += " AND "+RetSqlFil("QEK")+" "                                              + CRLF
	cQuery += " AND QEK_NTFISC = QER_NTFISC "                                           + CRLF
	cQuery += " AND QEK_SERINF = QER_SERINF "                                           + CRLF
	cQuery += " AND QEK_ITEMNF = QER_ITEMNF "                                           + CRLF
	cQuery += " AND QEK_FORNEC = QER_FORNEC "                                           + CRLF
	cQuery += " AND QEK_LOJFOR = QER_LOJFOR "                                           + CRLF
	cQuery += " INNER JOIN "+RetSqlTab("SA2")+" ON 1 = 1 "                              + CRLF
	cQuery += " AND "+RetSqlDel("SA2")+" "                                              + CRLF
	cQuery += " AND "+RetSqlFil("SA2")+" "                                              + CRLF
	cQuery += " AND A2_COD  = QEK_FORNEC "                                              + CRLF
	cQuery += " AND A2_LOJA = QEK_LOJFOR "                                              + CRLF
	cQuery += " INNER JOIN "+RetSqlTab("QAA")+" ON 1 = 1 "                              + CRLF
	cQuery += " AND "+RetSqlDel("QAA")+" "                                              + CRLF
	cQuery += " AND "+RetSqlFil("QAA")+" "                                              + CRLF
	cQuery += " AND QER_ENSR = QAA_MAT "                                                + CRLF
	cQuery += " LEFT JOIN "+RetSqlTab("QEL")+" ON 1 = 1 "                               + CRLF
	cQuery += " AND "+RetSqlDel("QEL")+" "                                              + CRLF
	cQuery += " AND "+RetSqlFil("QEL")+" "                                              + CRLF
	cQuery += " AND QEL_FORNEC = QER_FORNEC "                                           + CRLF
	cQuery += " AND QEL_LOJFOR = QER_LOJFOR "                                           + CRLF
	cQuery += " AND QEL_NISERI = QER_NTFISC + QER_SERINF + QER_ITEMNF "                 + CRLF
	cQuery += " AND QEL_LABOR = ' ' "                                                   + CRLF
	cQuery += " LEFT JOIN "+RetSqlTab("SD1")+" ON 1 = 1 "                               + CRLF
	cQuery += " AND "+RetSqlDel("SD1")+" "                                              + CRLF
	cQuery += " AND "+RetSqlFil("SD1")+" "                                              + CRLF
	cQuery += " AND QER_FORNEC = D1_FORNECE "                                           + CRLF
	cQuery += " AND QER_LOJFOR = D1_LOJA "                                              + CRLF
	cQuery += " AND QER_NTFISC = D1_DOC "                                               + CRLF
	cQuery += " AND QER_SERINF = D1_SERIE "                                             + CRLF
	cQuery += " AND QER_ITEMNF = D1_ITEM "                                              + CRLF
	cQuery += " INNER JOIN "+RetSqlTab("SB1")+" ON 1 = 1 "                              + CRLF
	cQuery += " AND "+RetSqlDel("SB1")+" "                                              + CRLF
	cQuery += " AND "+RetSqlFil("SB1")+" "                                              + CRLF
	cQuery += " AND B1_COD = QER_PRODUT "                                               + CRLF
	cQuery += " WHERE 1 = 1  "                                                          + CRLF
	cQuery += " AND "+RetSqlDel("QER")+" "                                              + CRLF
	cQuery += " AND "+RetSqlFil("QER")+" "                                              + CRLF
	cQuery += " AND QER_DTMEDI >='" + dtos(MV_PAR01)+"' "                               + CRLF
	cQuery += " AND QER_DTMEDI <='" + dtos(MV_PAR02)+"' "                               + CRLF
	cQuery += " AND QER_PRODUT >='" + MV_PAR03 +"' "                                    + CRLF
	cQuery += " AND QER_PRODUT <='" + MV_PAR04 +"' "                                    + CRLF
	cQuery += " AND QER_FORNEC >='" + MV_PAR05 +"' "                                    + CRLF
	cQuery += " AND QER_LOJFOR >='" + MV_PAR06 +"' "                                    + CRLF
	cQuery += " AND QER_FORNEC <='" + MV_PAR07 +"' "                                    + CRLF
	cQuery += " AND QER_LOJFOR <='" + MV_PAR08 +"' "                                    + CRLF
	cQuery += " AND QER_NTFISC >='" + MV_PAR09 +"' "                                    + CRLF
	cQuery += " AND QER_NTFISC <='" + MV_PAR10 +"' "                                    + CRLF
 
	cQuery += " UNION ALL " + CRLF

	cQuery += " SELECT QEK_SITENT, QEK_DTENTR, QEK_NTFISC, QEK_SERINF, A2_NOME , A2_LOJA , QER_PRODUT, B1_DESC, QER_ENSAIO, QE1_DESCPO, QAA_NOME, QER_DTMEDI, QER_HRMEDI, QER_RESULT,  "
	cQuery += " ' - ', ' - ', QEQ_CODMED CODMED, QEQ_MEDICA, QER_ZLOTE, D1_QUANT, D1_DTVALID, QEL_LAUDO, QEL_JUSTLA "                                  + CRLF
	cQuery += " FROM "+RetSqlTab("QER")+" "                                             + CRLF
	cQuery += " INNER JOIN "+RetSqlTab("QE1")+" ON 1 = 1 "                              + CRLF
	cQuery += " AND "+RetSqlDel("QE1")+" "                                              + CRLF
	cQuery += " AND "+RetSqlFil("QE1")+" "                                              + CRLF
	cQuery += " AND QE1_ENSAIO = QER_ENSAIO "                                           + CRLF
	cQuery += " INNER JOIN "+RetSqlTab("QE8")+" ON 1 = 1 "                              + CRLF
	cQuery += " AND "+RetSqlDel("QE8")+" "                                              + CRLF
	cQuery += " AND "+RetSqlFil("QE8")+" "                                              + CRLF
	cQuery += " AND QE8_PRODUT = QER_PRODUT "                                           + CRLF
	cQuery += " AND QE8_ENSAIO = QER_ENSAIO "                                           + CRLF
	cQuery += " AND QE8_REVI   = QER_REVI "                                             + CRLF
	cQuery += " INNER JOIN "+RetSqlTab("QEQ")+" ON 1 = 1 "                              + CRLF
	cQuery += " AND "+RetSqlDel("QEQ")+" "                                              + CRLF
	cQuery += " AND "+RetSqlFil("QEQ")+" "                                              + CRLF
	cQuery += " AND  QEQ_CODMED = QER_CHAVE "                                           + CRLF
	cQuery += " INNER JOIN "+RetSqlTab("QEK")+" ON 1 = 1 "                              + CRLF
	cQuery += " AND "+RetSqlDel("QEK")+" "                                              + CRLF
	cQuery += " AND "+RetSqlFil("QEK")+" "                                              + CRLF
	cQuery += " AND QEK_NTFISC = QER_NTFISC "                                           + CRLF
	cQuery += " AND QEK_SERINF = QER_SERINF "                                           + CRLF
	cQuery += " AND QEK_ITEMNF = QER_ITEMNF "                                           + CRLF
	cQuery += " AND QEK_FORNEC = QER_FORNEC "                                           + CRLF
	cQuery += " AND QEK_LOJFOR = QER_LOJFOR "                                           + CRLF
	cQuery += " INNER JOIN "+RetSqlTab("SA2")+" ON 1 = 1"                               + CRLF
	cQuery += " AND "+RetSqlDel("SA2")+" "                                              + CRLF
	cQuery += " AND "+RetSqlFil("SA2")+" "                                              + CRLF
	cQuery += " AND A2_COD  = QEK_FORNEC "                                              + CRLF
	cQuery += " AND A2_LOJA = QEK_LOJFOR "                                              + CRLF
	cQuery += " INNER JOIN "+RetSqlTab("QAA")+" ON 1 = 1"
	cQuery += " AND "+RetSqlDel("QAA")+" "                                              + CRLF
	cQuery += " AND "+RetSqlFil("QAA")+" "                                              + CRLF
	cQuery += " AND QER_ENSR = QAA_MAT"                                                 + CRLF
	cQuery += " LEFT JOIN "+RetSqlTab("QEL")+" ON 1 = 1"
	cQuery += " AND "+RetSqlDel("QEL")+" "                                              + CRLF
	cQuery += " AND "+RetSqlFil("QEL")+" "                                              + CRLF
	cQuery += " AND QEL_FORNEC = QER_FORNEC "
	cQuery += " AND QEL_LOJFOR = QER_LOJFOR "
	cQuery += " AND QEL_NISERI = QER_NTFISC + QER_SERINF + QER_ITEMNF "
	cQuery += " AND QEL_LABOR = ' ' "
	cQuery += " LEFT JOIN "+RetSqlTab("SD1")+" ON 1 = 1 "                               + CRLF
	cQuery += " AND "+RetSqlDel("SD1")+" "                                              + CRLF
	cQuery += " AND "+RetSqlFil("SD1")+" "                                              + CRLF
	cQuery += " AND QER_FORNEC = D1_FORNECE "                                           + CRLF
	cQuery += " AND QER_LOJFOR = D1_LOJA "                                              + CRLF
	cQuery += " AND QER_NTFISC = D1_DOC "                                               + CRLF
	cQuery += " AND QER_SERINF = D1_SERIE "                                             + CRLF
	cQuery += " AND QER_ITEMNF = D1_ITEM "                                              + CRLF
	cQuery += " INNER JOIN  "+RetSqlTab("SB1")+" ON 1 = 1 "                             + CRLF
	cQuery += " AND "+RetSqlDel("SB1")+" "                                              + CRLF
	cQuery += " AND "+RetSqlFil("SB1")+" "                                              + CRLF
	cQuery += " AND B1_COD = QER_PRODUT "                                               + CRLF
	cQuery += " WHERE 1 = 1 "                                                           + CRLF
	cQuery += " AND "+RetSqlDel("QER")+" "                                              + CRLF
	cQuery += " AND "+RetSqlFil("QER")+" "                                              + CRLF
	cQuery += " AND QER_DTMEDI >='" + dtos(MV_PAR01)+"' "                               + CRLF
	cQuery += " AND QER_DTMEDI <='" + dtos(MV_PAR02)+"' "                               + CRLF
	cQuery += " AND QER_PRODUT >='" + MV_PAR03 +"' "                                    + CRLF
	cQuery += " AND QER_PRODUT <='" + MV_PAR04 +"' "                                    + CRLF
	cQuery += " AND QER_FORNEC >='" + MV_PAR05 +"' "                                    + CRLF
	cQuery += " AND QER_LOJFOR >='" + MV_PAR06 +"' "                                    + CRLF
	cQuery += " AND QER_FORNEC <='" + MV_PAR07 +"' "                                    + CRLF
	cQuery += " AND QER_LOJFOR <='" + MV_PAR08 +"' "                                    + CRLF
	cQuery += " AND QER_NTFISC >='" + MV_PAR09 +"' "                                    + CRLF
	cQuery += " AND QER_NTFISC <='" + MV_PAR10 +"' "                                    + CRLF
    
	cQuery += " UNION All "
	
	cQuery += " SELECT QEK_SITENT, QEK_DTENTR, QEK_NTFISC, QEK_SERINF, A2_NOME , A2_LOJA , QEK_PRODUT, B1_DESC, ' - ', ' - ' , ' - ', QEK_DTENTR , '- ', ' - ',  " + CRLF
	cQuery += " ' - ', ' - ', ' - ' CODMED, ' - ', ' - ' , QEK_TAMLOT, QEL_DTVAL, QEL_LAUDO, QEL_JUSTLA"       + CRLF

	cQuery += " FROM "+RetSqlTab("QEL") + " "                                           + CRLF
	cQuery += " INNER JOIN "+RetSqlTab("QEK") + "ON 1=1 "                               + CRLF
	cQuery += " AND QEK_PRODUT = QEL_PRODUT "                                           + CRLF
    cQuery += " AND QEK_FORNEC = QEL_FORNEC "                                           + CRLF
    cQuery += " AND QEK_LOJFOR = QEL_LOJFOR "                                           + CRLF
    cQuery += " AND QEK_NTFISC + QEK_SERINF + QEK_ITEMNF = QEL_NISERI "                 + CRLF
	cQuery += " AND "+RetSqlDel("QEL")+" "                                              + CRLF
	cQuery += " AND "+RetSqlFil("QEL")+" "                                              + CRLF
	cQuery += " INNER JOIN "+RetSqlTab("SA2")+" ON 1 = 1 "                              + CRLF
	cQuery += " AND "+RetSqlDel("SA2")+" "                                              + CRLF
	cQuery += " AND "+RetSqlFil("SA2")+" "                                              + CRLF
	cQuery += " AND A2_COD  = QEK_FORNEC "                                              + CRLF
	cQuery += " AND A2_LOJA = QEK_LOJFOR "                                              + CRLF
	cQuery += " INNER JOIN "+RetSqlTab("SB1")+" ON 1 = 1 "                              + CRLF
	cQuery += " AND "+RetSqlDel("SB1")+" "                                              + CRLF
	cQuery += " AND "+RetSqlFil("SB1")+" "                                              + CRLF
	cQuery += " AND B1_COD = QEK_PRODUT "                                               + CRLF
	cQuery += " WHERE 1 = 1  "                                                          + CRLF
	cQuery += " AND "+RetSqlDel("QEK")+" "                                              + CRLF
	cQuery += " AND "+RetSqlFil("QEK")+" "                                              + CRLF
	cQuery += " AND QEK_DTENTR >='" + dtos(MV_PAR01)+"' "                               + CRLF
	cQuery += " AND QEK_DTENTR <='" + dtos(MV_PAR02)+"' "                               + CRLF
	cQuery += " AND QEK_PRODUT >='" + MV_PAR03 +"' "                                    + CRLF
	cQuery += " AND QEK_PRODUT <='" + MV_PAR04 +"' "                                    + CRLF
	cQuery += " AND QEK_FORNEC >='" + MV_PAR05 +"' "                                    + CRLF
	cQuery += " AND QEK_LOJFOR >='" + MV_PAR06 +"' "                                    + CRLF
	cQuery += " AND QEK_FORNEC <='" + MV_PAR07 +"' "                                    + CRLF
	cQuery += " AND QEK_LOJFOR <='" + MV_PAR08 +"' "                                    + CRLF
	cQuery += " AND QEK_NTFISC >='" + MV_PAR09 +"' "                                    + CRLF
	cQuery += " AND QEK_NTFISC <='" + MV_PAR10 +"' "                                    + CRLF
    cQuery += " AND QEK_VERIFI = '2' "                                                  + CRLF
    cQuery += " AND QEL_LAUDO = 'A' "                                                   + CRLF
	cQuery += " ORDER BY QER_DTMEDI, QER_HRMEDI, QEK_NTFISC, A2_NOME, A2_LOJA, QER_PRODUT"  + CRLF

//	memoWrite("\SQL\KIRFAT02.SQL",cQuery)
	tcQuery cQuery New Alias "QRY"
	Count to nRegs
	QRY->(dbGotop())
	oSection1:Init()
	oReport:setMeter(nRegs)
	While QRY->(!eof())
		oReport:incMeter()
		oSection1:Cell("QEK_DTENTR"):SetValue(dToc(sTod(QRY->QEK_DTENTR)))
		oSection1:Cell("QER_DTMEDI"):SetValue(dToc(sTod(QRY->QER_DTMEDI)))
		oSection1:Cell("D1_DTVALID"):SetValue(dToc(sTod(QRY->D1_DTVALID)))

		If Posicione("QEU",1,xFilial("QEU")+QRY->CODMED,"!Eof()")
			oSection1:Cell("nQtdNFC"):SetValue(QEU->QEU_NUMNC)
			oSection1:Cell("cClasNFC"):SetValue(QEU->QEU_CLASSE)
			oSection1:Cell("cDemIQI"):SetValue(QEU->QEU_DEMIQI)
			oSection1:Cell("cDescNFC"):SetValue(alltrim(Posicione("SAG",1,xFilial("SAG")+QEU->QEU_NAOCON,"AG_DESCPO")))
		Endif

		If QRY->QEK_SITENT == "2"
			oSection1:Cell("cLaudo"):SetValue("Aprovado")
		Elseif QRY->QEK_SITENT == "1"
			oSection1:Cell("cLaudo"):SetValue("Pendente")
		Elseif QRY->QEK_SITENT == "3"
			oSection1:Cell("cLaudo"):SetValue("Reprovado")
		Elseif QRY->QEK_SITENT == "4"
			oSection1:Cell("cLaudo"):SetValue("Liberação Ugente")
		Elseif QRY->QEK_SITENT == "5"
			oSection1:Cell("cLaudo"):SetValue("Liberação Condicional")
		Elseif QRY->QEK_SITENT == "6"
			oSection1:Cell("cLaudo"):SetValue("Laudo sem movimentação de estoque")
		Endif

		oSection1:PrintLine()

		QRY->(dbSkip())
	EndDo

	oSection1:Finish()

	QRY->(dbCloseArea())

Return
