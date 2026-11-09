#Include "protheus.ch"
#Include "rptdef.ch"
#Include "fwprintsetup.ch"
#Include "topconn.ch"
#Include "prtopdef.ch"


/*/{Protheus.doc}	etqVol
Gera��o de Etiquetas
@type				function
@author				Augusto Krejci Bem-Haja
@since				08/11/2017
/*/

user function etqVol(cCliente, cData, cNF_Serie, cPedido, cTransp, cVolume, cCodBar)
	local nColIni   	:= 10
	local nColFim   	:= 485 //393
	local nLinIni   	:= 10
	local nLinFim		:= 214
	local nSaltoEsp 	:= 28
	local nSalto 		:= 23
	local nSaltoCont	:= 20  
	local nSaltoCE		:= 24
	
	Local lAdjustToLegacy 	:= .f.
	Local lDisableSetup  	:= .T.
	local oFonteS			:= TFont():New("Arial",, -8, .t.)
	local oFonteA			:= TFont():New("Arial",, -14, .t.)
	local oFonteN			:= TFont():New("Arial",, -18, .t.)
	local oFonteB			:= TFont():New("Arial",, -12, .t.)
	local oFonte			:= TFont():New("Arial",, -18, .t.)
	local oFonteTit			:= TFont():New("Arial",, -28, .t.)
	local oFonteBigg		:= TFont():New("Arial",, -50, .t.)
	local cPrinter			:= SuperGetMV("MV_ZZPNAM",.F.,"Argox CP-2140E PPLB")
	
	private oPrinter 	:= FWMSPrinter():New("produto.etq",IMP_SPOOL,lAdjustToLegacy,"/spool/",lDisableSetup,,,Alltrim(cPrinter) /*parametro que recebe a impressora*/,,,,,1)
	//private oPrinter 	:= FWMSPrinter():New("produto.etq",IMP_SPOOL,lAdjustToLegacy,"/spool/",lDisableSetup,,,"Microsoft Print to PDF" /*parametro que recebe a impressora*/)
	
	nLinha1 := nLinIni				//10
	nLinha2 := nLinha1 + nSalto
	nLinha3 := nLinha2 + nSaltoEsp
	nLinha4 := nLinha3 + nSalto
	nLinha5 := nLinha4 + nSaltoEsp
	nLinha6 := nLinha5 + nSalto
	nLinha7 := nLinha6 + nSaltoEsp
	nLinha8 := nLinha7 + nSalto
	nLinha9 := nLinha8 + nSaltoEsp 
	
	nColuna1 := nColIni
	nColuna2 := 320
	nColuna3 := nColFim
	
	oPrinter:SetMargin(10,10,10,10)
	//oPrinter:SetPaperSize(0,142,104)
	oPrinter:SetLandScape()
	
	oPrinter:StartPage()
	
	// Box geral
	oPrinter:Box(nLinIni,		nColIni,	nLinFim,	nColFim, "-8")
	
	oFonteN:Bold := .t.
	oPrinter:SetFont(oFonteN)
	
	// Linhas Horizontais
	oPrinter:Line(nLinha1,		nColIni,	nLinha1,		nColFim, 0, "-8") 
	oPrinter:Line(nLinha2,		nColIni,	nLinha2,		nColFim, 0, "-8") 
	oPrinter:Line(nLinha3,		nColIni,	nLinha3,		nColFim, 0, "-8") 
	oPrinter:Line(nLinha4,		nColIni,	nLinha4,		nColFim, 0, "-8")
	oPrinter:Line(nLinha5,		nColIni,	nLinha5,		nColuna2, 0, "-8")
	oPrinter:Line(nLinha6,		nColIni,	nLinha6,		nColuna2, 0, "-8")
	//oPrinter:Line(nLinha7,		nColIni,	nLinha7,		nColuna2, 0, "-8")
	oPrinter:Line(nLinha7,		nColIni,	nLinha7,		nColFim, 0, "-8")
	//oPrinter:Line(nLinha8,		nColIni,	nLinha8,		nColuna2, 0, "-8")
	oPrinter:Line(nLinha8,		nColIni,	nLinha8,		nColFim, 0, "-8")
	oPrinter:Line(nLinha9,		nColIni,	nLinha9,		nColuna2, 0, "-8")
		
	// Linhas Verticais
	oPrinter:Line(nLinha1,		nColuna2,	nLinha9,		nColuna2, 0, "-8")
	
	
	// Conte�do
	oPrinter:Say(nLinha1 + nSaltoCont,nColuna1 + 5,"CLIENTE:",oFonte)
	oPrinter:Say(nLinha1 + nSaltoCont,nColuna2 + 5,"DATA:",oFonte)
	
	oPrinter:Say(nLinha2 + nSaltoCE,nColuna1 + 5,cCliente,oFonteTit)
	oPrinter:Say(nLinha2 + nSaltoCE,nColuna2 + 5,cData,oFonteTit)

	oPrinter:Say(nLinha3 + nSaltoCont,nColuna1 + 5,"NF / SERIE:",oFonte)
	oPrinter:Say(nLinha3 + nSaltoCont,nColuna2 + 5,"VOLUME:",oFonte)
	
	oPrinter:Say(nLinha4 + nSaltoCE,nColuna1 + 5,cNF_Serie,oFonteTit)
	oPrinter:Say(nLinha5 + nSaltoCE,nColuna2 + 20,cVolume,oFonteBigg)
	
	oPrinter:Say(nLinha5 + nSaltoCont,nColuna1 + 5,"PEDIDO:",oFonte)
	
	oPrinter:Say(nLinha6 + nSaltoCE,nColuna1 + 5,cPedido,oFonteTit)
	
	oPrinter:Say(nLinha7 + nSaltoCont,nColuna1 + 5,"TRANSPORTADORA: ",oFonte)
	oFonteA:Bold := .T.
	oPrinter:Say(nLinha8 + nSaltoCE,nColuna1 + 5,cTransp,oFonteA)

	oPrinter:Say(nLinha7 + nSaltoCont,nColuna2 + 5,"ID EMBALAGEM: ",oFonte)
	oPrinter:Say(nLinha8 + nSaltoCE,nColuna2 + 20,cCodBar,oFonteTit)

/*	
	nLinC		:= 19.75	//Linha que ser� impresso o C�digo de Barra
	nColC		:= 1.50		//Coluna que ser� impresso o C�digo de Barra
	nWidth	 	:= 0.02	//Numero do Tamanho da barra. Default 0.025 limite de largura da etiqueta � 0.0164
	nHeigth   	:= 0.8		//Numero da Altura da barra. Default 1.5 --- limite de altura � 0.3
	lBanner		:= .T.		//Se imprime a linha com o c�digo embaixo da barra. Default .T.
	nPFWidth	:= 1.0		//N�mero do �ndice de ajuste da largura da fonte. Default 1
	nPFHeigth	:= 1.0		//N�mero do �ndice de ajuste da altura da fonte. Default 1
	lCmtr2Pix	:= .F.		//Utiliza o m�todo Cmtr2Pix() do objeto Printer.Default .T.
 	
 	oPrinter:SetFont(oFonteB)*/
	//oPrinter:Code128(230/*nRow*/ ,10/*nCol*/, cCodBar/*cCode*/,1/*nWidth*/,50/*nHeigth*/,.T./*lSay*/,oFonteB,485)

 	//oPrinter:QRCode(250,150,"QR Code gerado com sucesso", 100)
	oPrinter:DataMatrix(220,280,cCodBar, 65)
	oPrinter:Say(288,nColuna1 + 220,cCodBar,oFonteS)
	oPrinter:EndPage()
	
	oPrinter:Print()
	
	if vldZA2(cNF_Serie)
		U_AdiCtrlExp('4','Aguardando Embarque',cNF_Serie,cPedido,"0",cVolume,cCodBar)
	endif
return

Static Function getValor(nValor)
	local cValor := ""
	
	cValor := Alltrim(Transform(nValor,"@ze 9,999,999,999,999.999"))			
	cValor := Strtran(cValor,".","")
	cValor := Strtran(cValor,",",".")
return cValor

static function vldZA2(cNF_Serie)
	local lRetorno := .F.
	local cNF := substr(cNF_Serie,1,9)
	local cSerie := substr(cNF_Serie,13,3)
	
	nRegs := QryRgs(cNF,cSerie)
	
	if nRegs <= 0
		lRetorno := .T.
	Endif
return lRetorno

Static Function QryRgs(cNF,cSerie) 
	local cQuery := ""
	local cEol   := chr(10) + chr(13)
	local nRegs
	local cStatus := '4' //Aguardando Embarque
	local cAlias := GetNextAlias()
	
	cQuery := " SELECT * FROM " +RetSqlName("ZA2") + cEol
	cQuery += " WHERE ZA2_FILIAL = '" + xFilial("ZA2") + "'"+ cEol
	cQuery += "   AND ZA2_NF = '" + cNF + "' " + cEol
	cQuery += "   AND ZA2_SERIE = '"+ cSerie +"' "+ cEol
	cQuery += "   AND ZA2_STATUS = '"+ cStatus +"' "+ cEol 
	cQuery += "   AND D_E_L_E_T_ = ' ' " + cEol
			
	TCQUERY cQuery NEW ALIAS &cAlias
	
	count to nRegs	
Return nRegs
