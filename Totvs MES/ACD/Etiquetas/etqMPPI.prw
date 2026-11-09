#Include "protheus.ch"
#Include "rptdef.ch"
#Include "fwprintsetup.ch"
#Include "topconn.ch"
#Include "prtopdef.ch"


/*/{Protheus.doc}	etqMPPI
Geração de Etiquetas
@type				function
@author				Augusto Krejci Bem-Haja
@since				14/09/2017
/*/
user function etqMPPI(cTipo,cCod,cDesc,cLote,cDataHora,cDataVal,cQtd1a,cUnd1a,cQtd2a,cUnd2a,cCodBar,nQuant,cNF_Serie,cForLoja, cItem)
	local nColIni   	:= 5
	local nColFim   	:= 495 //393
	local nLinIni   	:= 10
	local nLinFim		:= 208
	local nSaltoEsp 	:= 35
	local nSalto 		:= 27
	local nSaltoCont	:= 10  
	local nSaltoContEsp	:= 25
	
	Local lAdjustToLegacy 	:= .f.
	Local lDisableSetup  	:= .T.
	local oFonteS			:= TFont():New("Arial",, -8, .t.)
	local oFonteN			:= TFont():New("Arial",, -18, .t.)
	local oFonteB			:= TFont():New("Arial",, -12, .t.)
	local oFonteC			:= TFont():New("Arial",, -16, .t.)
	local oFonte			:= TFont():New("Arial",, -18, .t.)
	local oFonteTit			:= TFont():New("Arial",, -30, .t.)
	local cPrinter			:= SuperGetMV("MV_ZZPNAM",.F.,"Argox CP-2140E PPLB")
	
	private oPrinter 	:= FWMSPrinter():New("produto.etq",IMP_SPOOL,lAdjustToLegacy,"/spool/",lDisableSetup,,,Alltrim(cPrinter) /*parametro que recebe a impressora*/,,,,,nQuant)
	
	default cNF_Serie 		:= ""
	default cForLoja		:= ""
	default cItem			:= ""
	//private oPrinter 	:= FWMSPrinter():New("produto.etq",IMP_SPOOL,lAdjustToLegacy,"/spool/",lDisableSetup,,,Alltrim("Argox CP-2140E PPLB") /*parametro que recebe a impressora*/)
	//private oPrinter 	:= FWMSPrinter():New("produto.etq",IMP_SPOOL,lAdjustToLegacy,"/spool/",lDisableSetup,,,Alltrim("PDFCreator") /*parametro que recebe a impressora*/)
	
	nLinha1 := nLinIni
	nLinha2 := nLinha1 + nSaltoEsp
	nLinha3 := nLinha2 + nSalto
	nLinha4 := nLinha3 + nSalto
	nLinha5 := nLinha4 + nSalto
	nLinha6 := nLinha5 + nSalto
	nLinha7 := nLinha6 + nSalto
	
	nColuna1 := nColIni
	nColuna2 := 130
	nColuna3 := 160
	nColuna4 := 260
	nColuna5 := 370
	nColuna6 := 390
	nColuna7 := nColFim
	
	oPrinter:SetMargin(10,10,10,10)
	//oPrinter:SetPaperSize(0,142,104)
	oPrinter:SetLandScape()
	
	oPrinter:StartPage()
	
	// Box geral
	oPrinter:Box(nLinIni,		nColIni,	nLinFim,	nColFim, "-8")
	
	oFonteN:Bold := .t.
	oPrinter:SetFont(oFonteN)
	
	// Linhas Horizontais
	oPrinter:Line(nLinha1,		nColIni,	nLinha1,		nColFim, 0, "-6") 
	oPrinter:Line(nLinha2,		nColIni,	nLinha2,		nColFim, 0, "-8") 
	oPrinter:Line(nLinha3,		nColIni,	nLinha3,		nColFim, 0, "-6") 
	oPrinter:Line(nLinha4,		nColIni,	nLinha4,		nColFim, 0, "-8")
	oPrinter:Line(nLinha5,		nColIni,	nLinha5,		nColFim, 0, "-6")
	oPrinter:Line(nLinha6,		nColIni,	nLinha6,		nColFim, 0, "-8")
	oPrinter:Line(nLinha7,		nColIni,	nLinha7,		nColFim, 0, "-6")
	
	// Linhas Verticais
	oPrinter:Line(nLinha2,		nColuna2,	nLinha4,		nColuna2, 0, "-6") 
	oPrinter:Line(nLinha4,		nColuna3,	nLinFim,		nColuna3, 0, "-6") 
	oPrinter:Line(nLinha6,		nColuna4,	nLinFim,		nColuna4, 0, "-6") 
	oPrinter:Line(nLinha4,		nColuna5,	nLinha6,		nColuna5, 0, "-6")
	oPrinter:Line(nLinha6,		nColuna6,	nLinFim,		nColuna6, 0, "-6")
	
	// Conteúdo
	oPrinter:Say(nLinha1 + nSaltoContEsp,nColuna1 + 5,"Parafix - " + cTipo,oFonteTit)
	if !(Empty(cNF_Serie))
		oPrinter:Say(nLinha1 + nSaltoContEsp,nColuna3 + 5,"N.F./Série: "+ cNF_Serie + " FOR./LOJA: " + cForLoja + " - ITEM "+ cItem,oFonteC)
	endif
	oPrinter:Say(nLinha2 + nSaltoCont,nColuna1 + 5,"Código",oFonte)
	oPrinter:Say(nLinha2 + nSaltoCont,nColuna2 + 5,"Descrição",oFonte)
	oPrinter:Say(nLinha3 + nSaltoCont,nColuna1 + 5,cCod,oFonteN)
	oPrinter:Say(nLinha3 + nSaltoCont,nColuna2 + 5,cDesc,oFonteN)

	oPrinter:Say(nLinha4 + nSaltoCont,nColuna1 + 5,"Lote / ID",oFonte)
	oPrinter:Say(nLinha4 + nSaltoCont,nColuna3 + 5,"Data/Hora",oFonte)
	oPrinter:Say(nLinha4 + nSaltoCont,nColuna5 + 5,"Validade",oFonte)
	oPrinter:Say(nLinha5 + nSaltoCont,nColuna1 + 5,cLote,oFonteN)
	oPrinter:Say(nLinha5 + nSaltoCont,nColuna3 + 5,cDataHora,oFonteN)
	oPrinter:Say(nLinha5 + nSaltoCont,nColuna5 + 5,cDataVal,oFonteN)
	
	oPrinter:Say(nLinha6 + nSaltoCont,nColuna1 + 5,"Qtd. 1a. UM",oFonte)
	oPrinter:Say(nLinha6 + nSaltoCont,nColuna3 + 5,"1a. UM",oFonte)
	oPrinter:Say(nLinha6 + nSaltoCont,nColuna4 + 5,"Qtd. 2a. UM",oFonte)
	oPrinter:Say(nLinha6 + nSaltoCont,nColuna6 + 5,"2a. UM",oFonte)
	oPrinter:Say(nLinha7 + nSaltoCont,nColuna1 + 5,cQtd1a,oFonteN)
	oPrinter:Say(nLinha7 + nSaltoCont,nColuna3 + 5,cUnd1a,oFonteN)
	oPrinter:Say(nLinha7 + nSaltoCont,nColuna4 + 5,cQtd2a,oFonteN)
	oPrinter:Say(nLinha7 + nSaltoCont,nColuna6 + 5,cUnd2a,oFonteN)
	
	nLinC		:= 19.75	//Linha que será impresso o Código de Barra
	nColC		:= 0.50		//Coluna que será impresso o Código de Barra
	nWidth	 	:= 0.02	//Numero do Tamanho da barra. Default 0.025 limite de largura da etiqueta é 0.0164
	nHeigth   	:= 0.8		//Numero da Altura da barra. Default 1.5 --- limite de altura é 0.3
	lBanner		:= .T.		//Se imprime a linha com o código embaixo da barra. Default .T.
	nPFWidth	:= 1.0		//Número do índice de ajuste da largura da fonte. Default 1
	nPFHeigth	:= 1.0		//Número do índice de ajuste da altura da fonte. Default 1
	lCmtr2Pix	:= .F.		//Utiliza o método Cmtr2Pix() do objeto Printer.Default .T.
 	
 	oPrinter:SetFont(oFonteB)
 	//oPrinter:Code128(230/*nRow*/ ,10/*nCol*/, cCodBar/*cCode*/,1/*nWidth*/,50/*nHeigth*/,.T./*lSay*/,oFonteB,480) 
	//oPrinter:Code128(230/*nRow*/ ,20/*nCol*/, cCodBar/*cCode*/,1/*nWidth*/,45/*nHeigth*/,.T./*lSay*/,oFonteB,360)
	//oPrinter:QRCode(285,405,cCodQR, 30)
	//oPrinter:QRCode(300,405,cCodBar, 10)
	oPrinter:DataMatrix(390,280,cCodBar, 40)
	oPrinter:Say(288,nColuna1 + 290,cCodBar,oFonteS) 
	oPrinter:EndPage()
	oPrinter:Print()
return

Static Function getValor(nValor)
	local cValor := ""
	
	cValor := Alltrim(Transform(nValor,"@ze 9,999,999,999,999.999"))			
	cValor := Strtran(cValor,".","")
	cValor := Strtran(cValor,",",".")
return cValor
