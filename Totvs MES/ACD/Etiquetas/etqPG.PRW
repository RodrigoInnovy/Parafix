// Etiqueta volume para cliente P&G 

#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#Include "RPTDef.ch"
#Include "FWPrintSetup.ch"
#Include "prtopdef.ch"

//Cores 
#Define COR_CINZA   RGB(180, 180, 180)
#Define COR_PRETO   RGB(000, 000, 000)

//Alinhamentos
#Define PAD_LEFT    0
#Define PAD_RIGHT   1
#Define PAD_CENTER  2

/*======================================================================================+
| Programa............:   etqPG.PRW                                                  |
| Autor...............:   George Eivazian              |
| Data................:   03/09/2021                                                    |
| Descricao / Objetivo:   Rotina para Consulta de Lotes e Impressao por NF              |
| Doc. Origem.........:   Nenhum.                                                       |
| Obs.................:                                                                 |
+======================================================================================*/

User Function etqPG()

	Local oPanFiltro
	Local oButBuscar
	Local oButSair
	Local oButPDF

	
	Local oGrBrowse
	
	Private oGetLin, oGetLdes, oGetEmis, oGetProd, oGetCli, oGetVend, oGetDOC, oGetCond
    
    Private oComboBo1       
    Private nComboBo1       := 1

    Private cGetLin         := space(1)
    Private cGetEmiDe       := dDataBase
    Private cGetEmiAte      := dDataBase
    Private cGetPDe         := space(15) 
    Private cGetPAte        := Replicate("Z",15)
    Private cGetCDe         := space(6)
    Private cGetCAte        := 'ZZZZZZ'
    Private cGetVDe         := space(6)
    Private cGetVAte        := "ZZZZZZ"
    Private cGetNDe         := space(9)
    Private cGetNAte        := "ZZZZZZZZZZ"
    Private cGetCond        := Space(5)
//  Private cGetEst         := Space(2)
    Private cGetNotaDe      := Space(9)
    Private cGetNotaAte     := "999999999"
	Private oPanResult

	Private aColsEx 		:= {} // ARRAY DO CABEC DA TELA 

	Private oLaranja		:= LoadBitmap( GetResources(), "BR_LARANJA")
	Private oAzul			:= LoadBitmap( GetResources(), "BR_AZUL")
	Private oPink			:= LoadBitmap( GetResources(), "BR_PINK")
	Private oVerde			:= LoadBitmap( GetResources(), "BR_VERDE")
	Private oAmarelo		:= LoadBitmap( GetResources(), "BR_AMARELO")
	Private oVermelho		:= LoadBitmap( GetResources(), "BR_VERMELHO")
	Private oBranco			:= LoadBitmap( GetResources(), "BR_BRANCO")
	Private oPreto			:= LoadBitmap( GetResources(), "BR_PRETO")
	Private oCinza			:= LoadBitmap( GetResources(), "BR_CINZA")
	Private oMarron			:= LoadBitmap( GetResources(), "BR_MARRON")

	Static oDlg
	Static oMSNewGe1

    DEFINE MSDIALOG oDlg TITLE "Relatório de Lotes por Item de NF " FROM 000, 000  TO 550, 1000 COLORS 255, 16777215 PIXEL
	DEFINE FONT oBold15   NAME "Arial" SIZE 0, -15 BOLD
	DEFINE FONT oBold12   NAME "Arial" SIZE 0, -12 BOLD
	DEFINE FONT oBold11   NAME "Arial" SIZE 0, -11 BOLD

    DEFINE FONT oBold30   NAME "Arial" SIZE 0, -30 BOLD


// Painel dos Filtros
   @ 003, 005 MSPANEL oPanFiltro SIZE 495, 058 OF oDlg COLORS 0, 16777215 RAISED

   @ 003, 015 SAY "Data:" SIZE 028, 220 OF oPanFiltro COLORS 0, 16777215 PIXEL  FONT oBold12
   @ 003, 035 SAY "Faturamento:" SIZE 040, 220 OF oPanFiltro COLORS 0, 16777215 PIXEL  FONT oBold12
   @ 012, 012 MSGET oGetEmis  VAR cGetEmiDe   SIZE 040, 010 OF oPanFiltro COLORS 0, 16777215 PIXEL 
   @ 012, 060 MSGET oGetEmis  VAR cGetEmiAte  SIZE 040, 010 OF oPanFiltro COLORS 0, 16777215 PIXEL 

   @ 004, 200 SAY "Cliente:" SIZE 028, 220 OF oPanFiltro COLORS 0, 16777215 PIXEL  FONT oBold12
   @ 017, 175 MSGET oGetCli  VAR cGetCDe   SIZE 035, 010 OF oPanFiltro COLORS 0, 16777215 PIXEL F3 "SA1"
   @ 017, 220 MSGET oGetCli  VAR cGetCAte  SIZE 035, 010 OF oPanFiltro COLORS 0, 16777215 PIXEL F3 "SA1"

   @ 004, 300 SAY "Nota Fiscal:" SIZE 035, 220 OF oPanFiltro COLORS 0, 16777215 PIXEL  FONT oBold12
   @ 017, 275 MSGET oGetNotaDe  VAR cGetNotaDe   SIZE 035, 010 OF oPanFiltro COLORS 0, 16777215 PIXEL F3 "SF2"
   @ 017, 320 MSGET oGetNotaAte VAR cGetNotaAte  SIZE 035, 010 OF oPanFiltro COLORS 0, 16777215 PIXEL F3 "SF2"

   @ 003, 445 BUTTON oButBuscar PROMPT "Pesquisar" ACTION MsgRun ( "Processando...", "Aguarde...", {|| fCarregaMs() }) SIZE 040, 010 OF oPanFiltro PIXEL FONT oBold15
   @ 017, 440 BUTTON oButPDF    PROMPT "Imprimir"  ACTION MsgRun ( "Processando...", "Aguarde...", {|| fIMPDF() }) SIZE 047, 010 OF oPanFiltro PIXEL FONT oBold15
   @ 031, 445 BUTTON oButPDF    PROMPT "Exp Excell"  ACTION MsgRun ( "Processando...", "Aguarde...", {|| fExpClien() }) SIZE 047, 010 OF oPanFiltro PIXEL FONT oBold15
   @ 045, 445 BUTTON oButSair   PROMPT "Fechar"    ACTION oDlg:END() SIZE 040, 010 OF oPanFiltro PIXEL FONT oBold15

    @ 062, 002 MSPANEL oPanResult SIZE 603, 200 OF oDlg COLORS 0, 16777215 RAISED
    @ 002, 002 GROUP oGrBrowse TO 198, 600 PROMPT "Itens da Nota filtrados " OF oPanResult COLOR 255, 16777215 PIXEL

  ACTIVATE MSDIALOG oDlg CENTERED

Return

Return lRet

Static Function fMSNewGe1()

	Private aCabecalho 	:= {}

	CriaCabec()

	aColsEx   := {}
	
	oMSNewGe1 := MsNewGetDados():New( 010, 005, 196, 497, GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "+Field1+Field2", {},0, 999, "AllwaysTrue", "", "AllwaysTrue", oPanResult, aCabecalho, aColsEx)

	oMSNewGe1:oBrowse:blDblClick := { || oMSNewGe1:EditCell(), fSeleciona() }
  
Return	

Static Function fSeleciona()
 	
Return .T.

Static Function fCarregaMs()

	Local cQuery		:= ""
//	Local nS1           := 0 // TOTAL QUANTIDADE

	Private cAliasTMP   := GetNextAlias()
    
	fMSNewGe1()

	aColsEx := {} //array para montar o cabeçalho da grid - resultado do select 
    
	oMSNewGe1:SetArray(aColsEx,.T.)
	oMSNewGe1:Refresh()

//  cQuery := " SELECT A7_CODCLI, A7_DESCCLI, B1_TIPO, B1_UM, B1_GRUPO, Right(B1_UCOM,2)+'/'+SUBSTRING(B1_UCOM,5,2)+'/'+LEFT(B1_UCOM,4) AS B1_UCOM,B1_IDHIST,D2_LOTECTL,F2_CLIENTE,Right(D2_EMISSAO,2)+'/'+SUBSTRING(D2_EMISSAO,5,2)+'/'+LEFT(D2_EMISSAO,4) AS D2_EMISSAO, D2_QUANT, H6_OP, Right(H6_DTAPONT,2)+'/'+SUBSTRING(H6_DTAPONT,5,2)+'/'+LEFT(H6_DTAPONT,4) AS H6_DTAPONT, A7_CODCLI, A7_DESCCLI, D2_DOC, A1_NOME "

    cQuery := " SELECT B1_COD, B1_DESC, B1_TIPO, B1_UM, B1_GRUPO, Right(B1_UCOM,2)+'/'+SUBSTRING(B1_UCOM,5,2)+'/'+LEFT(B1_UCOM,4) AS B1_UCOM,B1_IDHIST,D2_LOTECTL,F2_CLIENTE,Right(D2_EMISSAO,2)+'/'+SUBSTRING(D2_EMISSAO,5,2)+'/'+LEFT(D2_EMISSAO,4) AS D2_EMISSAO, D2_QUANT, H6_OP, SUBSTRING(H6_DTAPONT,5,2)+'-'+SUBSTRING(H6_DTAPONT,7,2)+'-'+LEFT(H6_DTAPONT,4) AS H6_DTAPONT, A7_CODCLI, A7_DESCCLI, SUBSTRING(D2_DOC,4,6) as D2_DOC, A1_NOME,SUBSTRING(D2_DTVALID,3,2)+SUBSTRING(D2_DTVALID,5,2)+SUBSTRING(D2_DTVALID,7,2) AS D2_DTVALID, D2_ITEM"
    cQuery += " FROM "+RetSqlName("SF2")+" SF2 "
    cQuery += " INNER JOIN "+RetSqlName("SD2")+" SD2 ON F2_FILIAL = D2_FILIAL AND F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE AND F2_CLIENTE = D2_CLIENTE AND F2_LOJA = D2_LOJA AND SD2.D_E_L_E_T_ = ' ' "
    cQuery += " INNER JOIN "+RetSqlName("SB1")+" SB1 ON D2_COD = B1_COD AND SB1.D_E_L_E_T_ = ' '"
    cQuery += " INNER JOIN "+RetSqlName("SH6")+" SH6 ON H6_FILIAL = D2_FILIAL AND H6_PRODUTO = D2_COD AND H6_LOTECTL = D2_LOTECTL AND SH6.D_E_L_E_T_ = ''"
    cQuery += " INNER JOIN "+RetSqlName("SA1")+" SA1 ON F2_CLIENTE = A1_COD AND F2_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = ' ' "
    cQuery += " LEFT OUTER JOIN "+RetSqlName("SA7")+" SA7 ON A7_CLIENTE = D2_CLIENTE AND A7_LOJA = D2_LOJA AND A7_PRODUTO = D2_COD AND SA7.D_E_L_E_T_ = ''"
    cQuery += " WHERE F2_CLIENTE BETWEEN '"+cGetCDe+"' AND '"+cGetCAte+"' "
    cQuery += " AND RTRIM(F2_DOC) BETWEEN '"+cGetNotaDe+"' AND '"+cGetNotaAte+"' "
    
    If !Empty(cGetEmiDe)
        cQuery += " AND D2_EMISSAO BETWEEN '"+DTOS(cGetEmiDe)+"' AND '"+DTOS(cGetEmiAte)+"'"
    Endif
   
    cQuery += " ORDER BY F2_DOC, D2_COD, D2_ITEM"
    
   	cQuery := ChangeQuery(cQuery)
	
	TcQuery cQuery New Alias (cAliasTMP)
		
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGotop())
		
	If ! (cAliasTmp)->(EoF())

//	nS1 := 0

//  cChave := rtrim((cAliasTMP)->D2_DOC)

		While !(cAliasTmp)->( EoF() ) 

    			aAdd(aColsEx,{ (cAliasTmp)->B1_COD  	,;
                               (cAliasTmp)->B1_DESC	    ,;
                               (cAliasTmp)->B1_TIPO	    ,;
                               (cAliasTmp)->B1_UM	    ,;
                               (cAliasTmp)->B1_GRUPO    ,;
 	 			               (cAliasTmp)->B1_UCOM     ,;
					    SUBSTR((cAliasTmp)->B1_IDHIST,1,18) ,;
					   	       (cAliasTmp)->D2_LOTECTL	,;
                               (cAliasTmp)->F2_CLIENTE	,;
                               (cAliasTmp)->D2_EMISSAO  ,;
						       (cAliasTmp)->D2_QUANT    ,;
						       (cAliasTmp)->H6_OP		,;
 			                   (cAliasTmp)->H6_DTAPONT  ,;
                               (cAliasTmp)->A7_CODCLI	,;
                               (cAliasTmp)->A7_DESCCLI 	,;
                               (cAliasTmp)->D2_DOC   	,;
                               (cAliasTmp)->A1_NOME   	,;
                               (cAliasTmp)->D2_DTVALID  ,;
                               (cAliasTmp)->D2_ITEM     ,;
				.F.						})

//			nS1	+= (cAliasTmp)->D2_QUANT    

	        (cAliasTmp)->(DbSkip())

//            If (cAliasTMP)->D2_DOC <> cChave
//                  cChave      := (cAliasTMP)->D2_DOC
//                aAdd(aColsEx,{" "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," ", .F.})
//
//                  aAdd(aColsEx,{" "," "," "," "," "," "," "," "," ","Total NF",nS1," "," "," "," "," "," ", .F.})
//
//                aAdd(aColsEx,{" "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," ", .T.})
//
//                  nS1 := 0
//
//            Endif
	    EndDo

	Else

//         aAdd(aColsEx,{	" "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," ",.F.})
	
	Endif 
	
	(cAliasTMP)->( dbCloseArea() )
	
	oMSNewGe1:SetArray(aColsEx,.T.)
	oMSNewGe1:Refresh()
	
	oPanResult:Refresh()
	SysRefresh()

Return

Static Function CriaCabec() // cabecalho da grid

aCabecalho := {}

    Aadd(aCabecalho, {"Produto"        ,""    ,""       ,15,0,".F.","","C","","R","","","","V"})
    Aadd(aCabecalho, {"Descrição"      ,""    ,""       ,30,0,".F.","","C","","R","","","","V"})
    Aadd(aCabecalho, {"Tipo"           ,""    ,""       ,02,0,".F.","","C","","R","","","","V"})
    Aadd(aCabecalho, {"UM"             ,""    ,""       ,02,0,".F.","","C","","R","","","","V"})
    Aadd(aCabecalho, {"Grupo"          ,""    ,""       ,04,0,".F.","","C","","R","","","","V"})
    Aadd(aCabecalho, {"Ultima Compra"  ,""    ,""       ,08,0,".F.","","D","","R","","","","V"})
    Aadd(aCabecalho, {"SSCC"           ,""    ,""       ,18,0,".F.","","C","","R","","","","V"})
    Aadd(aCabecalho, {"Lote"           ,""    ,""       ,15,0,".F.","","C","","R","","","","V"})
    Aadd(aCabecalho, {"Cliente"        ,""    ,""       ,06,0,".F.","","C","","R","","","","V"})
    Aadd(aCabecalho, {"Emissão Nota"   ,""    ,""       ,08,0,".F.","","D","","R","","","","V"})
    Aadd(aCabecalho, {"Quantidade"     ,""    ,""       ,15,0,".F.","","C","","R","","","","V"})
    Aadd(aCabecalho, {"OP"             ,""    ,""       ,12,0,".F.","","C","","R","","","","V"})
    Aadd(aCabecalho, {"Data Apont"     ,""    ,""       ,08,0,".F.","","D","","R","","","","V"})
    Aadd(aCabecalho, {"Cod Cliente"    ,""    ,""       ,06,0,".F.","","C","","R","","","","V"})
    Aadd(aCabecalho, {"Descrição"      ,""    ,""       ,30,0,".F.","","C","","R","","","","V"})
    Aadd(aCabecalho, {"Nota"           ,""    ,""       ,09,0,".F.","","C","","R","","","","V"})
    Aadd(aCabecalho, {"Nome Cliente"   ,""    ,""       ,30,0,".F.","","C","","R","","","","V"})
    Aadd(aCabecalho, {"Data Validade"  ,""    ,""       ,06,0,".F.","","C","","R","","","","V"})
    Aadd(aCabecalho, {"Item Pallet"           ,""    ,""       ,02,0,".F.","","C","","R","","","","V"})

Return

Static Function fIMPDF()

	Local nX_			:= "" // vinicius descomentei

	Private nPagAtu		:= 1 
    Private nLinAtu		:= 000
    Private nTamLin		:= 010
    Private nLinFin		:= 570
    Private nColIni		:= 003
    Private nColFin		:= 770
    Private nColMeio	:= (nColFin-nColIni)/2
    
    Private cLinhaPro	:= ""
    Private cProduto	:= ""

	Private cNumPed		:= ""
	Private nTamLinha	:= 0
	Private oPrintPvt
	Private cNomeFont	:= "Arial"
	Private oFontDet	:= TFont():New(cNomeFont, 7,  -7, .T., .F., 5, .T., 5, .T., .F.)
	Private oFontDetN	:= TFont():New(cNomeFont, 7,  -7, .T., .T., 5, .T., 5, .T., .F.)
	Private oFoDetNE	:= TFont():New(cNomeFont, 12,  12, .T., .F., 5, .T., 5, .T., .F.)  // Fonte Pequena do cabecaçho direito
    Private oFoDetItem	:= TFont():New(cNomeFont, 16,  -16, .T., .T., 5, .T., 5, .T., .F.)  // Fonte Pequena Desc. Item
	Private oFontRod	:= TFont():New(cNomeFont, 15, -15, .T., .T., 5, .T., 5, .T., .F.) // Fonte geral dos titulos 
	Private oFontTit	:= TFont():New(cNomeFont, 5, -5, .T., .F., 5, .T., 5, .T., .F.)   //Fonte dos Traços horizontais
    Private oFontGrande	:= TFont():New(cNomeFont, 20, -20, .T., .T., 5, .T., 5, .T., .F.) // Fonte Grande dos Valores
    Private oFontCodBbar1 := TFont():New(cNomeFont, 15, -15, .T., .F., 5, .T., 5, .T., .F.) // Fonte Grande dos Valores cod barras
    Private oFontCodBbar2 := TFont():New(cNomeFont, 18, -18, .T., .F., 5, .T., 5, .T., .F.) // Fonte Grande dos Valores cod barras

    Private cProdutoBarra := space(15)
    Private cDescBarra    := space(45)
    Private cSSCCBarra    := space(18)
    Private cVendedorBar  := space(06)
    Private cNomeVendedorBar  := space(40)
    Private cLoteBarra    := space(15)
    Private cDataBarra    := space(10)
    private cUnidadeBarra := space(02)
    Private cQuantiBarra  := 0
    Private cQuantidade   := "0"

    For nX_:=1 to Len(aColsEx)

//  Variáveis utilizadas para gravar dados para Impressão das etiquetas
    cProdutoBarra     := AllTrim(( aColsEx[nX_,14] ))
    cDescBarra        := ( aColsEx[nX_,15] )
    cSSCCBarra        := ( aColsEx[nX_,7] )
    cLoteBarra        := ( aColsEx[nX_,8] )
    cVendedorBar      := "15381057"
    cDataBarra        := ( aColsEx[nX_,13] )
    cNota             := ( aColsEx[nX_,16] )
    cQuantiBarra      := ( aColsEx[nX_,11] )
    cNomeVendedorBar  := ( aColsEx[nX_,17] )
    cUnidadeBarra     := ( aColsEx[nX_,4] )
    cProduto          := Alltrim(( aColsEx[nX_,1] ))
    cDataFabricacao   := Alltrim(( aColsEx[nX_,13] ))
    cDataValidade     := ( aColsEx[nX_,18] )
    cProdutoCliente   := Alltrim(( aColsEx[nX_,15] ))
    cUnidadeMedida    := Alltrim(( aColsEx[nX_,4] ))
    cLote             := Alltrim(( aColsEx[nX_,8] ))
    cOp               := Alltrim(( aColsEx[nX_,12] ))
    cQuantidade       := Alltrim(STR(( aColsEx[nX_,11] )))
    cItemPallet       := ( aColsEx[nX_,19] )
    cCCSS             := ALLTRIM("1"+cVendedorBar+cNota+cItemPallet)
    nCCSSimpares      := (VAL(substring(cCCSS,1,1))+VAL(substring(cCCSS,3,1))+VAL(substring(cCCSS,5,1))+VAL(substring(cCCSS,7,1))+VAL(substring(cCCSS,9,1))+VAL(substring(cCCSS,11,1))+VAL(substring(cCCSS,13,1))+VAL(substring(cCCSS,15,1))+VAL(substring(cCCSS,17,1)))*3
    nCCSSpares        := (VAL(substring(cCCSS,2,1))+VAL(substring(cCCSS,4,1))+VAL(substring(cCCSS,6,1))+VAL(substring(cCCSS,8,1))+VAL(substring(cCCSS,10,1))+VAL(substring(cCCSS,12,1))+VAL(substring(cCCSS,14,1))+VAL(substring(cCCSS,16,1)))
    nSomaImparPar     := nCCSSimpares+nCCSSpares
    nDigit            := IF(10-VAL(RIGHT(STR(nSomaImparPar),1))=10,0,10-VAL(RIGHT(STR(nSomaImparPar),1)))
    
    MyCod130()      

    Next nX_ 	
     
//  oPrintPvt:Preview()

Return 

Static Function fImpCab(cNumPed,cItem,cSequen)
    
    Local cTexto   			:= ""
    Local nLinCab  			:= 030
    //Local cStartPath        := GetSrvProfString("Startpath","")

    Local cStartPath        := "NOME DA EMPRESA"
    
    // Logo da Empresa
//  Local cLogo      	    := cStartPath + "EMPRESA.jpg"
    Local cLogo      	    := cStartPath + "EMPRESA"
  
    oPrintPvt:StartPage()
     
    //Cabeçalho
	oPrintPvt:SayBitmap(030,050,cLogo,070,035)
    cTexto := "Relatório de Itens de Nota Fiscal - Lotes "
 
        
    oPrintPvt:SayAlign(nLinCab - 2, 700, "Emissão : " + dtoc(dDatabase)	,	oFontDetN, 0080, nTamLin, COR_PRETO, PAD_LEFT, 0)
    oPrintPvt:SayAlign(nLinCab + 5, 700, "Horário : " + Time()			,   oFontDetN, 0080, nTamLin, COR_PRETO, PAD_LEFT, 0)
    oPrintPvt:SayAlign(nLinCab + 5, 10,  "NOME DA EMPRESA: "            ,   oFontDetN, 0080, nTamLin, COR_PRETO, PAD_LEFT, 0)

    oPrintPvt:SayAlign(nLinCab, nColMeio - 150, cTexto					,	oFontTit, 400, 20, COR_PRETO, PAD_CENTER, 0)
    nLinCab += nTamLin

    oPrintPvt:SayAlign(nLinCab + 5, 670, "Usuário : " + Substr(UsrFullName ( __cUserID ),1,15)	,   oFontDetN, 0080, nTamLin, COR_PRETO, PAD_LEFT, 0)
     
    //Linha Separatória
    nLinCab += (nTamLin * 2)
    oPrintPvt:Line(nLinCab, nColIni, nLinCab, nColFin, COR_PRETO)
     
    //Cabeçalho das colunas
    nLinCab += nTamLin
    
    oPrintPvt:SayAlign(nLinCab,    005, "PRODUTO"      , oFontDetN, 0200, nTamLin, COR_PRETO, PAD_LEFT, 0)
	oPrintPvt:SayAlign(nLinCab,    047, "DESCRIÇÃO"    , oFontDetN, 0200, nTamLin, COR_PRETO, PAD_LEFT, 0)
	oPrintPvt:SayAlign(nLinCab,    195, "TIPO"         , oFontDetN, 0200, nTamLin, COR_PRETO, PAD_LEFT, 0)
	oPrintPvt:SayAlign(nLinCab,    245, "UM"           , oFontDetN, 0200, nTamLin, COR_PRETO, PAD_LEFT, 0)
	oPrintPvt:SayAlign(nLinCab,    295, "GRUPO"        , oFontDetN, 0200, nTamLin, COR_PRETO, PAD_LEFT, 0)
	oPrintPvt:SayAlign(nLinCab,    355, "U.COMPRA"     , oFontDetN, 0200, nTamLin, COR_PRETO, PAD_LEFT, 0)
	oPrintPvt:SayAlign(nLinCab,    405, "SSCC"         , oFontDetN, 0200, nTamLin, COR_PRETO, PAD_LEFT, 0)
    oPrintPvt:SayAlign(nLinCab,    485, "LOTE"         , oFontDetN, 0200, nTamLin, COR_PRETO, PAD_LEFT, 0)
    oPrintPvt:SayAlign(nLinCab,    535, "VENDEDOR"     , oFontDetN, 0200, nTamLin, COR_PRETO, PAD_LEFT, 0)
    oPrintPvt:SayAlign(nLinCab,    585, "EMISSÃO"      , oFontDetN, 0200, nTamLin, COR_PRETO, PAD_LEFT, 0)
    oPrintPvt:SayAlign(nLinCab,    635, "OP"           , oFontDetN, 0200, nTamLin, COR_PRETO, PAD_LEFT, 0)
    oPrintPvt:SayAlign(nLinCab,    685, "NOTA"         , oFontDetN, 0200, nTamLin, COR_PRETO, PAD_LEFT, 0)

  //  nLinCab+=5 PULA LINHA

    nLinCab += (nTamLin+5)

    nLinAtu := nLinCab

Return

Static Function fImpRod()
    Local nLinRod   := nLinFin + nTamLin 
    Local cTextoEsq := ''
    Local cTextoDir := ''
 
    //Linha Separatória
    oPrintPvt:Line(nLinRod, nColIni, nLinRod, nColFin, COR_PRETO)
    nLinRod 	+= 3
     
    //Dados da Esquerda e Direita
    cTextoEsq 	:= "AQUI COLOQUE O NOME DA EMPRESA"
    cTextoDir 	:= "Página " + cValToChar(nPagAtu)
     
    //Imprimindo os textos
    oPrintPvt:SayAlign(nLinRod, nColIni,	cTextoEsq, oFontRod,	200, 05, COR_PRETO, PAD_LEFT,  0)
    oPrintPvt:SayAlign(nLinRod, nColFin-40,	cTextoDir, oFontRod,	040, 05, COR_PRETO, PAD_RIGHT, 0)

    nLinRod 	+= 3
     
    //Finalizando a página e somando mais um
    oPrintPvt:EndPage()
    nPagAtu++
    
Return

Static Function fExpClien() // RETIRADO EM 09/09/2021

	Local cQuery		:= ""

	Private cAliasTMP   := GetNextAlias()
	Private aCabec 		:= {}
	Private aDados 		:= {} 

	
	If !MsgYesno("Confirma a Exportação? ","Confirma")
		Return .t.
	Endif
    
    cQuery := " SELECT B1_COD, B1_DESC, B1_TIPO, B1_UM, B1_GRUPO, Right(B1_UCOM,2)+'/'+SUBSTRING(B1_UCOM,5,2)+'/'+LEFT(B1_UCOM,4) AS B1_UCOM,B1_IDHIST,D2_LOTECTL,F2_CLIENTE,Right(D2_EMISSAO,2)+'/'+SUBSTRING(D2_EMISSAO,5,2)+'/'+LEFT(D2_EMISSAO,4) AS D2_EMISSAO, D2_QUANT, H6_OP, Right(H6_DTAPONT,2)+'/'+SUBSTRING(H6_DTAPONT,5,2)+'/'+LEFT(H6_DTAPONT,4) AS H6_DTAPONT, D2_DOC, A1_NOME "
    cQuery += " FROM "+RetSqlName("SF2")+" SF2 "
    cQuery += " INNER JOIN "+RetSqlName("SD2")+" SD2 ON F2_FILIAL = D2_FILIAL AND F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE AND F2_CLIENTE = D2_CLIENTE AND F2_LOJA = D2_LOJA AND SD2.D_E_L_E_T_ = ' ' "
    cQuery += " INNER JOIN "+RetSqlName("SB1")+" SB1 ON D2_COD = B1_COD AND SB1.D_E_L_E_T_ = ' '"
    cQuery += " INNER JOIN "+RetSqlName("SH6")+" SH6 ON H6_FILIAL = D2_FILIAL AND H6_PRODUTO = D2_COD AND H6_LOTECTL = D2_LOTECTL AND SH6.D_E_L_E_T_ = ''"
    cQuery += " INNER JOIN "+RetSqlName("SA1")+" SA1 ON F2_CLIENTE = A1_COD AND F2_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = ' ' "
    cQuery += " LEFT OUTER JOIN "+RetSqlName("SA7")+" SA7 ON A7_CLIENTE = D2_CLIENTE AND A7_LOJA = D2_LOJA AND A7_PRODUTO = D2_COD AND SA7.D_E_L_E_T_ = ''"
    cQuery += " WHERE F2_CLIENTE BETWEEN '"+cGetCDe+"' AND '"+cGetCAte+"' "
    cQuery += " AND RTRIM(F2_DOC) BETWEEN '"+cGetNotaDe+"' AND '"+cGetNotaAte+"' "
    
    If !Empty(cGetEmiDe)
        cQuery += " AND D2_EMISSAO BETWEEN '"+DTOS(cGetEmiDe)+"' AND '"+DTOS(cGetEmiAte)+"'"
    Endif
   
    cQuery += " ORDER BY F2_DOC, D2_COD, D2_ITEM"

	cQuery 		:= ChangeQuery(cQuery)
	
	TcQuery cQuery New Alias (cAliasTMP)
	
    // Dados do Cabeçalho da Planilha
	AaDd( aCabec, "Produto"  )
	AaDd( aCabec, "Descrição" )
	AaDd( aCabec, "Tipo" )
	AaDd( aCabec, "UM" )
	AaDd( aCabec, "Grupo" )
	AaDd( aCabec, "Ultima Compra" )
	AaDd( aCabec, "SSCC" )
	AaDd( aCabec, "Num Lote" )
    AaDd( aCabec, "Cliente" )
    AaDd( aCabec, "Data Emissão" )
    AaDd( aCabec, "Quantidade" )
    AaDd( aCabec, "Num OP" )
    AaDd( aCabec, "Data Apontamento" )
    AaDd( aCabec, "Nota Fiscal" )
    AaDd( aCabec, "Nome Cliente" )

	While (cAliasTMP)->( !EOF() )

    		aAdd(aDados, { (cAliasTmp)->B1_COD	 ,;
                           (cAliasTmp)->B1_DESC	 ,;
                           (cAliasTmp)->B1_TIPO	 ,;
                           (cAliasTmp)->B1_UM	 ,;
                           (cAliasTmp)->B1_GRUPO ,;
 	                       (cAliasTmp)->B1_UCOM  ,;
					       (cAliasTmp)->B1_IDHIST ,;
					   	   (cAliasTmp)->D2_LOTECTL,;
                           (cAliasTmp)->F2_CLIENTE,;
                           (cAliasTmp)->D2_EMISSAO  ,;
                     TRANSFORM((cAliasTmp)->D2_QUANT,"@E 9999,999.99") 	,;
                           (cAliasTmp)->H6_OP,;
                           (cAliasTmp)->H6_DTAPONT  ,;
                           (cAliasTmp)->D2_DOC    ,;
                           (cAliasTmp)->A1_NOME })
        
		(cAliasTMP)->( dbSkip() )
		
	End
	
	If len(aDados) >= 1
		DlgToExcel( { { "ARRAY", "RELATÓRIO DE ITENS DAS NOTAS FISCAIS POR - LOTE", aCabec, aDados} })
		
		MsgAlert("Exportação finalizada com Sucesso...")
	Endif
	
	aColsEx := {}
	oMSNewGe1:SetArray(aColsEx,.T.)
	oMSNewGe1:Refresh()

Return .t.

// Imprissão das etiqueta em PDF 
Static Function MyCod130()

Local lAdjustToLegacy := .F.
Local lDisableSetup   := .T.
Local  cImpressora		:= SuperGetMV("MV_ZZPG",.F.,"Argox CP-2140E PPLB") // Vinicius
Local oPrinter

Private nTamLin   := 060

//cProdutoBarra     := ( aColsEx[nX_,1] )  
//cDescBarra        := ( aColsEx[nX_,2] ) 
//cSSCCBarra        := ( aColsEx[nX_,7] )
//cLoteBarra        := ( aColsEx[nX_,8] )
//cVendedorBar      := ( aColsEx[nX_,9] )
//cDataBarra        := ( aColsEx[nX_,13] )
//cQuantiBarra      := ( aColsEx[nX_,11] )
//cNomeVendedorBar  := ( aColsEx[nX_,17])

//oPrinter := FWMSPrinter():New("exemplo.rel", IMP_PDF,lAdjustToLegacy,cLocal, lDisableSetup, ,@oPrinter ,'', , , , .T. ) Vinicius 
oPrinter := FWMSPrinter():New("ontex.etq",IMP_SPOOL,lAdjustToLegacy,"/spool/",lDisableSetup,,,Alltrim(cImpressora)/*parametro que recebe a impressora*/,,,,,1) //vinicius
 
oPrinter:SetResolution(72)
oPrinter:SetLandScape()
oPrinter:SetPaperSize(0,75,50)
//oPrinter:SetMargin(02, 02, 02, 02)

//Imprime a moldura/ retangulo
oPrinter:Box(02,07,470,286, "-6")

//Imprime a linha vertical 01
oPrinter:Line(02, 125,55,125,,"-6") //inicio altura, inicio horizontal, fim altura, fim horizonta 

//Imprime a linha vertical 02
oPrinter:Line(95, 100,135,100,,"-6")

//Imprime a linha vertical 03
oPrinter:Line(95, 205,135,205,,"-6")

//Imprime a linha vertical  4
oPrinter:Line(135, 145,175,145,,"-6")

//Cabeçalho Esquerdo 
oPrinter:Say( 15, 10,"PARAFIX IND. LTDA", oFontRod, 0200, 100, COR_PRETO, PAD_LEFT, 0)
oPrinter:Say( 30, 10,"VINHEDO, SP", oFontRod, 0200, 100, COR_PRETO, PAD_LEFT, 0)
oPrinter:Say( 45, 10,"BRAZIL", oFontRod, 0200, 100, COR_PRETO, PAD_LEFT, 0)

//Cabeçalho Direito
oPrinter:Say( 15, 130,"SUPPLIER PRODUCT#: "+cProduto, oFoDetNE, 0200, 100, COR_PRETO, PAD_LEFT, 0)
oPrinter:Say( 25, 130,"PROD. DATE: "+cDataFabricacao, oFoDetNE, 0200, 100, COR_PRETO, PAD_LEFT, 0)
oPrinter:Say( 35, 130,"PALLET: "+cItemPallet, oFoDetNE, 0200, 100, COR_PRETO, PAD_LEFT, 0)

oPrinter:Say( 55, 09,replicate("_",92), oFontTit, 0200, 100, COR_PRETO, PAD_LEFT, 0) // Traço

//Item
oPrinter:Say( 70, 10,"ITEM:", oFoDetNE, 0200, 100, COR_PRETO, PAD_LEFT, 0)
oPrinter:Say( 85,10,cProdutoCliente, oFoDetItem, 0200, 100, COR_PRETO, PAD_LEFT, 0)

oPrinter:Say( 95, 09,replicate("_",92), oFontTit, 0200, 100, COR_PRETO, PAD_LEFT, 0) // Traço


//IRMS/GCAS
oPrinter:Say( 110, 10,"IRMS/GCAS #:", oFoDetNE, 0200, 100, COR_PRETO, PAD_LEFT, 0)
oPrinter:Say( 127, 10,cProdutoBarra,oFontGrande, 0200, 100, COR_PRETO, PAD_LEFT, 0)

//QUANTITY
oPrinter:Say( 110, 115,"QUANTITY", oFoDetNE, 0200, 100, COR_PRETO, PAD_LEFT, 0)
oPrinter:Say( 127, 115,cQuantidade+" "+cUnidadeMedida, oFontGrande, 0200, 100, COR_PRETO, PAD_LEFT, 0)

//Exp Date
oPrinter:Say( 110, 215,"EXP. DATE:", oFoDetNE, 0200, 100, COR_PRETO, PAD_LEFT, 0)
oPrinter:Say( 127, 215,cDataValidade, oFontGrande, 0200, 100, COR_PRETO, PAD_LEFT, 0)

oPrinter:Say( 135, 09,replicate("_",92), oFontTit, 0200, 100, COR_PRETO, PAD_LEFT, 0) // Traço

//LOT
oPrinter:Say( 150, 10,"LOT #:", oFoDetNE, 0200, 100, COR_PRETO, PAD_LEFT, 0)
oPrinter:Say( 167, 10,"PIIL"+cLote, oFontGrande, 0200, 100, COR_PRETO, PAD_LEFT, 0)

//PALLET TYPE
oPrinter:Say( 150, 160,"PALLET TYPE", oFoDetNE, 0200, 100, COR_PRETO, PAD_LEFT, 0)
oPrinter:Say( 167, 160,"NONE", oFontGrande, 0200, 100, COR_PRETO, PAD_LEFT, 0)

oPrinter:Say( 175, 09,replicate("_",92), oFontTit, 0200, 100, COR_PRETO, PAD_LEFT, 0) // Traço

//1 CODBARRA
oPrinter:Code128B(225,15,"(91)"+cProdutoBarra+"(37)"+cQuantidade, 32,15)
oPrinter:Say(240, 15,"(91)"+cProdutoBarra+"(37)"+cQuantidade,oFontCodBbar1, 0200, 100, COR_PRETO, PAD_LEFT, 0)

//2 CODBARRA 
oPrinter:Code128B(300,15,"(10)"+"PIIL"+cLote+"(90)"+"NONE", 27,15)
oPrinter:Say(315, 15,"(10)"+"PIIL"+cLote+ "(90)"+"NONE", oFontCodBbar1, 0200, 100, COR_PRETO, PAD_LEFT, 0)
 

//3 CODBARRA 
oPrinter:Code128B(375,15,"(17)"+cDataValidade, 32,15)
oPrinter:Say(390, 15,"(17)"+cDataValidade, oFontCodBbar1, 0200, 100, COR_PRETO, PAD_LEFT, 0)


//4 CODBARRA
oPrinter:Code128B(450,15,"(00)"+ALLTRIM(cCCSS)+ALLTRIM(STR(nDigit)),32,15)
oPrinter:Say(465, 15,"(00) "+ALLTRIM(SUBSTRING(cCCSS,1,1))+" "+ALLTRIM(SUBSTRING(cCCSS,2,8))+" "+ALLTRIM(SUBSTRING(cCCSS,10,8))+" "+ALLTRIM(STR(nDigit)), oFontCodBbar1, 0200, 100, COR_PRETO, PAD_LEFT, 0)
 
oPrinter:EndPage()
oPrinter:Preview()

Return
