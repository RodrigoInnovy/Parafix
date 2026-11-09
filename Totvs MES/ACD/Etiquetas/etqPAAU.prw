#Include "protheus.ch"
#Include "rptdef.ch"
#Include "fwprintsetup.ch"
#Include "topconn.ch"
#Include "prtopdef.ch"


/*/{Protheus.doc}	etqPAAU
Geração de Etiquetas
@type				function
@author				Augusto Krejci Bem-Haja
@since				22/09/2017
/*/

user function etqPAAU(cTipo,cCod,cDesc,cLote,cDataHora,cDataVal,cQtd1a,cUnd1a,cQtd2a,cUnd2a,cCodBar,cCodCli,cDimensao,cStatus,cECN,cPesoLiq,cPesoBru,nQuant,cCodQR,aRet)
	local nColIni   	:= 10
	local nColFim   	:= 500 //393
	local nLinIni   	:= 10
	local nLinFim		:= 190
	local nSaltoEsp 	:= 25
	local nSalto 		:= 19
	local nSaltoCont	:= 17  
	local nSaltoCE		:= 21
	
	Local lAdjustToLegacy 	:= .f.
	Local lDisableSetup  	:= .T.
	local oFonteS			:= TFont():New("Arial",, -8, .t.)
	local oFonteN			:= TFont():New("Arial",, -18, .t.)
	local oFonteB			:= TFont():New("Arial",, -12, .t.)
	local oFonte			:= TFont():New("Arial",, -18, .t.)
	local oFonteTit			:= TFont():New("Arial",, -30, .t.)
	local cPrinter			:= SuperGetMV("MV_ZZPNAM",.F.,"Argox CP-2140E PPLB")
	
	private oPrinter 	:= FWMSPrinter():New("produto.etq",IMP_SPOOL,lAdjustToLegacy,"/spool/",lDisableSetup,,,Alltrim(cPrinter) /*parametro que recebe a impressora*/,,,,,nQuant)
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
	oPrinter:Line(nLinha1,		nColIni,	nLinha1,		nColFim, 0, "-6") 
	oPrinter:Line(nLinha2,		nColIni,	nLinha2,		nColFim, 0, "-8") 
	oPrinter:Line(nLinha3,		nColIni,	nLinha3,		nColFim, 0, "-6") 
	oPrinter:Line(nLinha4,		nColIni,	nLinha4,		nColFim, 0, "-8")
	oPrinter:Line(nLinha5,		nColIni,	nLinha5,		nColFim, 0, "-6")
	oPrinter:Line(nLinha6,		nColIni,	nLinha6,		nColFim, 0, "-8")
	oPrinter:Line(nLinha7,		nColIni,	nLinha7,		nColFim, 0, "-6")
	oPrinter:Line(nLinha8,		nColIni,	nLinha8,		nColFim, 0, "-8")
	oPrinter:Line(nLinha9,		nColIni,	nLinha9,		nColFim, 0, "-6")
		
	// Linhas Verticais
	oPrinter:Line(nLinha6,		nColuna3,	nLinha8,		nColuna3, 0, "-6")
	oPrinter:Line(nLinha2,		nColuna3,	nLinha4,		nColuna3, 0, "-6") 
	oPrinter:Line(nLinha4,		nColuna4,	nLinha6,		nColuna4, 0, "-6") 
	oPrinter:Line(nLinha8,		nColuna4,	nLinFim,		nColuna4, 0, "-6")
	oPrinter:Line(nLinha6,		nColuna5,	nLinha8,		nColuna5, 0, "-6") 
	oPrinter:Line(nLinha8,		nColuna6,	nLinFim,		nColuna6, 0, "-6")
	oPrinter:Line(nLinha4,		nColuna7,	nLinha8,		nColuna7, 0, "-6")
	oPrinter:Line(nLinha8,		nColuna8,	nLinFim,		nColuna8, 0, "-6")
	oPrinter:Line(nLinha1,		nColuna7,	nLinha2,		nColuna7, 0, "-6")
	//oPrinter:Line(nLinha4,		nColuna7,	nLinha6,		nColuna7, 0, "-6")
	//oPrinter:Line(nLinha6,		nColuna8,	nLinha8,		nColuna8, 0, "-6")
	
	// Conteúdo
	If Len(aRet) > 0
		oPrinter:Say(nLinha1 + nSaltoCE,nColuna1 + 5,"Parafix " + Alltrim(cTipo) + Alltrim(aRet[01]),oFonteTit)
	Else
		oPrinter:Say(nLinha1 + nSaltoCE,nColuna1 + 5,"Parafix " + Alltrim(cTipo),oFonteTit)
	Endif
	
	oPrinter:Say(nLinha2 + nSaltoCont,nColuna1 + 5,"Código",oFonte)
	oPrinter:Say(nLinha2 + nSaltoCont,nColuna3 + 5,"Descrição",oFonte)
	oPrinter:Say(nLinha3 + nSaltoCont,nColuna1 + 5,cCod,oFonteN)
	oPrinter:Say(nLinha3 + nSaltoCont,nColuna3 + 5,cDesc,oFonteN)

	oPrinter:Say(nLinha4 + nSaltoCont,nColuna1 + 5,"Lote / ID",oFonte)
	oPrinter:Say(nLinha4 + nSaltoCont,nColuna4 + 5,"Data/Hora",oFonte)
	oPrinter:Say(nLinha4 + nSaltoCont,nColuna7 + 5,"Validade",oFonte)
	oPrinter:Say(nLinha5 + nSaltoCont,nColuna1 + 5,cLote,oFonteN)
	oPrinter:Say(nLinha5 + nSaltoCont,nColuna4 + 5,cDataHora,oFonteN)
	oPrinter:Say(nLinha5 + nSaltoCont,nColuna7 + 5,cDataVal,oFonteN)
	
	//oPrinter:Say(nLinha6 + nSaltoCont,nColuna1 + 5,"Qtd. 1a. UM",oFonte)
	//oPrinter:Say(nLinha6 + nSaltoCont,nColuna2 + 5,"1a. UM",oFonte)
	oPrinter:Say(nLinha6 + nSaltoCont,nColuna1 + 5,"Qtd.",oFonte)
	oPrinter:Say(nLinha6 + nSaltoCont,nColuna3 + 5,"Und",oFonte)
	oPrinter:Say(nLinha6 + nSaltoCont,nColuna5 + 5,"P. Liq. (Kg)",oFonte)
	oPrinter:Say(nLinha6 + nSaltoCont,nColuna7 + 5,"P. Bru. (Kg)",oFonte)
	//oPrinter:Say(nLinha7 + nSaltoCont,nColuna1 + 5,cQtd1a,oFonteN)
	//oPrinter:Say(nLinha7 + nSaltoCont,nColuna2 + 5,cUnd1a,oFonteN)
	oPrinter:Say(nLinha7 + nSaltoCont,nColuna1 + 5,cQtd2a,oFonteN)
	oPrinter:Say(nLinha7 + nSaltoCont,nColuna3 + 5,cUnd2a,oFonteN)
	oPrinter:Say(nLinha7 + nSaltoCont,nColuna5 + 5,cPesoLiq,oFonteN)
	oPrinter:Say(nLinha7 + nSaltoCont,nColuna7 + 5,cPesoBru,oFonteN)
	
	oPrinter:Say(nLinha8 + nSaltoCont,nColuna1 + 5,"Código do Cliente",oFonte)
	oPrinter:Say(nLinha8 + nSaltoCont,nColuna4 + 5,"Dimensão",oFonte)
	oPrinter:Say(nLinha8 + nSaltoCont,nColuna6 + 5,"Status",oFonte)
	oPrinter:Say(nLinha8 + nSaltoCont,nColuna8 + 5,"ECN",oFonte)
	
	oPrinter:Say(nLinha9 + nSaltoCont,nColuna1 + 5,cCodCli,oFonteN)
	oPrinter:Say(nLinha9 + nSaltoCont,nColuna4 + 5,cDimensao,oFonteN)
	oPrinter:Say(nLinha9 + nSaltoCont,nColuna6 + 5,cStatus,oFonteN)
	oPrinter:Say(nLinha9 + nSaltoCont,nColuna8 + 5,cECN,oFonteN)
	
	nLinC		:= 19.75	//Linha que será impresso o Código de Barra
	nColC		:= 1.50		//Coluna que será impresso o Código de Barra
	nWidth	 	:= 0.02	//Numero do Tamanho da barra. Default 0.025 limite de largura da etiqueta é 0.0164
	nHeigth   	:= 1.0		//Numero da Altura da barra. Default 1.5 --- limite de altura é 0.3
	lBanner		:= .T.		//Se imprime a linha com o código embaixo da barra. Default .T.
	nPFWidth	:= 1.0		//Número do índice de ajuste da largura da fonte. Default 1
	nPFHeigth	:= 1.0		//Número do índice de ajuste da altura da fonte. Default 1
	lCmtr2Pix	:= .F.		//Utiliza o método Cmtr2Pix() do objeto Printer.Default .T.
 	
 	oPrinter:SetFont(oFonteB)
	oPrinter:DataMatrix(405,275,cCodBar, 65)
	oPrinter:Say(288,nColuna1 + 295,cCodBar,oFonteS)
	//oPrinter:Code128(235/*nRow*/ ,85/*nCol*/, cCodBar/*cCode*/,1/*nWidth*/,45/*nHeigth*/,.T./*lSay*/,oFonteB,310)
 	oPrinter:QRCode(285,10,cCodQR, 30)
 	
	
	oPrinter:EndPage()
	
	oPrinter:Print()
return

Static Function getValor(nValor)
	local cValor := ""
	
	cValor := Alltrim(Transform(nValor,"@ze 9,999,999,999,999.999"))			
	cValor := Strtran(cValor,".","")
	cValor := Strtran(cValor,",",".")
return cValor
