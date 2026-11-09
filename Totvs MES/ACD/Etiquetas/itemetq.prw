#Include "protheus.ch"
#Include "rptdef.ch"
#Include "fwprintsetup.ch"
#Include "topconn.ch"
#Include "prtopdef.ch"

/*/{Protheus.doc}	itemetq
Geração de Etiquetas
@type				function
@author				Lucas Silva
@since				05/09/2022
/*/

User Function itemetq(cCliente, cLoja, cNF, cExpedic, cProd, cCodCli, cDescr, cEcn,nQuant,cData,cLote,cUnd,cCodBar)
	local nColIni   	:= 10
	local nColFim   	:= 500 //393
	local nLinIni   	:= 10
	local nLinFim		:= 280
	local nSaltoEsp 	:= 25
	local nSalto 		:= 25
	local nSaltoCont	:= 17  
	local nSaltoCE		:= 21
		
	Local lAdjustToLegacy 	:= .f.
	Local lDisableSetup  	:= .T.
	local oFonteS			:= TFont():New("Arial",, -8, .t.)
	local oFonteN			:= TFont():New("Arial",, -18, .t.)
	local oFonteD			:= TFont():New("Arial",, -11, .t.)
	local oFonteB			:= TFont():New("Arial",, -12, .t.)
	local oFonte			:= TFont():New("Arial",, -15, .t.)
	local oFonteTit			:= TFont():New("Arial",, -30, .t.)
	local cPrinter			:= SuperGetMV("MV_ZZPNAM",.F.,"Argox CP-2140E PPLB")
	
	private oPrinter 	:= FWMSPrinter():New("produto.etq",IMP_SPOOL,lAdjustToLegacy,"/spool/",lDisableSetup,,,Alltrim(cPrinter) /*parametro que recebe a impressora*/,,,,,1)
	//private oPrinter 	:= FWMSPrinter():New("produto.etq",IMP_SPOOL,lAdjustToLegacy,"/spool/",lDisableSetup,,,Alltrim("PDFCreator") /*parametro que recebe a impressora*/)
	
	Default aRet := {}
	
	nLinha1 := nLinIni				
	nLinha2 := nLinha1 + nSaltoEsp	
	nLinha3 := nLinha2 + nSalto		
	nLinha4 := nLinha3 + nSalto
	nLinha5 := nLinha4 + nSalto
	nLinha6 := nLinha5 + nSalto
	nLinha7 := nLinha6 + nSalto
	nLinha8 := nLinha7 + nSalto
	nLinha9 := nLinha8 + nSalto 
	nLinha10 := nLinha9 + nSalto 
	nLinha11 := nLinha10 + nSalto 
	nLinha12 := nLinha11 + nSalto 
	nLinha13 := nLinha12 + nSalto 
	nLinha14 := nLinha13 + nSalto 
	
	nColuna1 := nColIni
	nColuna2 := 100
	nColuna3 := 130
	nColuna4 := 160
	nColuna5 := 230
	nColuna6 := 320
	nColuna7 := 360
	nColuna8 := 410
	nColuna9 := nColFim
	
	oPrinter:SetMargin(10,10,10,10)
	//oPrinter:SetPaperSize(0,142,104)
	oPrinter:SetLandScape()
	
	oPrinter:StartPage()
	
	// Box geral
	oPrinter:Box(nLinIni,		nColIni,	nLinFim,	nColFim, "-8")
	
	oFonteN:Bold := .t.
	oPrinter:SetFont(oFonteN)
	
	// Linhas Horizontais
	//oPrinter:Line(nLinha1,		nColIni,	nLinha1,		nColFim, 0, "-6") 
	//oPrinter:Line(nLinha2,		nColIni,	nLinha2,		nColFim, 0, "-8") 
	oPrinter:Line(nLinha3,		nColIni,	nLinha3,		nColFim, 0, "-6") 
	//oPrinter:Line(nLinha4,		nColIni,	nLinha4,		nColFim, 0, "-8")
	oPrinter:Line(nLinha5,		nColIni,	nLinha5,		nColFim, 0, "-6")
	//oPrinter:Line(nLinha6,		nColIni,	nLinha6,		nColFim, 0, "-8")
	oPrinter:Line(nLinha7,		nColIni,	nLinha7,		nColFim, 0, "-6")
	//oPrinter:Line(nLinha8,		nColIni,	nLinha8,		nColFim, 0, "-8")
	oPrinter:Line(nLinha9,		nColIni,	nLinha9,		nColFim, 0, "-6")
		
	// Linhas Verticais
	oPrinter:Line(nLinha1,		nColuna8,	nLinha5,		nColuna8, 0, "-6")
	oPrinter:Line(nLinha1,		nColuna4,	nLinha3,		nColuna4, 0, "-6") 
	oPrinter:Line(nLinha3,		nColuna3,	nLinha5,		nColuna3, 0, "-6") 
	oPrinter:Line(nLinha3,		nColuna5,	nLinha5,		nColuna5, 0, "-6") 
	oPrinter:Line(nLinha5,		nColuna7,	nLinha7,		nColuna7, 0, "-6")
	oPrinter:Line(nLinha5,		nColuna3,	nLinha7,		nColuna3, 0, "-6")
	oPrinter:Line(nLinha5,		nColuna7,	nLinha7,		nColuna7, 0, "-6")	
	oPrinter:Line(nLinha7,		nColuna3,	nLinha9,		nColuna3, 0, "-6")	 
	oPrinter:Line(nLinha7,		nColuna7,	nLinha9,		nColuna7, 0, "-6")	
	oPrinter:Line(nLinha9,		nColuna8,	nLinFim,		nColuna8, 0, "-6")	 

	
	oPrinter:Say(nLinha1 + nSaltoCont,nColuna1 + 5,"Fornecedor:",oFonte)
	oPrinter:Say(nLinha1 + nSaltoCont,nColuna4 + 5,"Codigo Fornecedor Woodbridge:",oFonte)
	oPrinter:Say(nLinha1 + nSaltoCont,nColuna8 + 5,"Loja:",oFonte)

	oPrinter:Say(nLinha2 + nSaltoCont,nColuna1 + 5,"Parafix",oFonteN)
	oPrinter:Say(nLinha2 + nSaltoCont,nColuna4 + 5,cProd,oFonteN)
	oPrinter:Say(nLinha2 + nSaltoCont,nColuna8 + 5,cLoja,oFonteN)

	oPrinter:Say(nLinha3 + nSaltoCont,nColuna1 + 5,"Planta Destino:",oFonte)
	oPrinter:Say(nLinha3 + nSaltoCont,nColuna3 + 5,"Codigo Produto:",oFonte)
	oPrinter:Say(nLinha3 + nSaltoCont,nColuna5 + 5,"Descri��o Produto:",oFonte)
	oPrinter:Say(nLinha3 + nSaltoCont,nColuna8 + 5,"ECN:",oFonte)

	oPrinter:Say(nLinha4 + nSaltoCont,nColuna1 + 5,cCliente,oFonteN)
	oPrinter:Say(nLinha4 + nSaltoCont,nColuna3 + 5,cCodCli,oFonteN)
	oPrinter:Say(nLinha4 + nSaltoCont,nColuna5 + 5,cDescr,oFonteD)
	oPrinter:Say(nLinha4 + nSaltoCont,nColuna8 + 5,cEcn,oFonteN)

	
	oPrinter:Say(nLinha5 + nSaltoCont,nColuna1 + 5,"Quantidade:",oFonte)
	oPrinter:Say(nLinha5 + nSaltoCont,nColuna3 + 5,"Fabrica��o:",oFonte)
	oPrinter:Say(nLinha5 + nSaltoCont,nColuna7 + 5,"Lote:",oFonte)

	oPrinter:Say(nLinha6 + nSaltoCont,nColuna1 + 5,nQuant,oFonteN)
	oPrinter:Say(nLinha6 + nSaltoCont,nColuna3 + 5,cData,oFonteN)
	oPrinter:Say(nLinha6 + nSaltoCont,nColuna7 + 5,cLote,oFonteN)	

	oPrinter:Say(nLinha7 + nSaltoCont,nColuna1 + 5,"Unidade Medida:",oFonte)
	oPrinter:Say(nLinha7 + nSaltoCont,nColuna3 + 5,"Numero Nota Fiscal:",oFonte)
	oPrinter:Say(nLinha7 + nSaltoCont,nColuna7 + 5,"Data Expedi��o Material:",oFonte)

	oPrinter:Say(nLinha8 + nSaltoCont,nColuna1 + 5,cUnd,oFonteN)
	oPrinter:Say(nLinha8 + nSaltoCont,nColuna3 + 5,cNF,oFonteN)
	oPrinter:Say(nLinha8 + nSaltoCont,nColuna7 + 5,cExpedic,oFonteN)

	oPrinter:Say(nLinha9 + nSaltoCont,nColuna8 + 5,"FIFO:",oFonte)
	

	
	nLinC		:= 19.75	//Linha que será impresso o Código de Barra
	nColC		:= 1.50		//Coluna que será impresso o Código de Barra
	nWidth	 	:= 0.02	//Numero do Tamanho da barra. Default 0.025 limite de largura da etiqueta é 0.0164
	nHeigth   	:= 1.0		//Numero da Altura da barra. Default 1.5 --- limite de altura é 0.3
	lBanner		:= .T.		//Se imprime a linha com o código embaixo da barra. Default .T.
	nPFWidth	:= 1.0		//Número do índice de ajuste da largura da fonte. Default 1
	nPFHeigth	:= 1.0		//Número do índice de ajuste da altura da fonte. Default 1
	lCmtr2Pix	:= .F.		//Utiliza o método Cmtr2Pix() do objeto Printer.Default .T.
 	
 	//oPrinter:SetFont(oFonteB)
	//oPrinter:DataMatrix(405,275,cCodBar, 65)
	//oPrinter:Say(288,nColuna1 + 295,cCodBar,oFonteS)
	oPrinter:Code128(214/*nRow*/ ,50/*nCol*/, cCodBar/*cCode*/,1/*nWidth*/,45/*nHeigth*/,.T./*lSay*/,oFonteB,310)
 	//oPrinter:QRCode(285,10,cCodQR, 30)
 	
	
	oPrinter:EndPage()
	
	oPrinter:Print()
return



Static Function getValor(nValor)
	local cValor := ""
	
	cValor := Alltrim(Transform(nValor,"@ze 9,999,999,999,999.999"))			
	cValor := Strtran(cValor,".","")
	cValor := Strtran(cValor,",",".")
return cValor
