#Include "protheus.ch"
#Include "rptdef.ch"
#Include "fwprintsetup.ch"
#Include "topconn.ch"
#Include "prtopdef.ch"


/*/{Protheus.doc}	etqPA
Geração de Etiquetas
@type				function
@author				Augusto Krejci Bem-Haja
@since				22/09/2017
Editado por VINICIUS 04/10/2022 , quando usurio for fazer a reempressão da etiqueta no protheus, o sistema vai chamar este fonte etqPA.prw
no qual eu incluí o campo cLoteOP. A versão original deste fonte está com o nome etqPAdesmb.prw
/*/

user function etqPA(nOpt,cTipo,cCod,cDesc,cLote,cLoteOp,cDataHora,cDataVal,cQtd1a,cUnd1a,cQtd2a,cUnd2a,cCodBar,cCodCli,cDimensao,cStatus,cECN,cPesoLiq,cPesoBru,nQuant,aRet)
	local nColIni   	:= 10
	local nColFim   	:= 495 //393
	local nLinIni   	:= 10
	local nLinFim		:= 211
	local nSaltoEsp 	:= 30
	local nSalto 		:= 21
	local nSaltoCont	:= 18  
	local nSaltoCE		:= 25
	
	Local lAdjustToLegacy 	:= .f.
	Local lDisableSetup  	:= .T.
	local oFonteS			:= TFont():New("Arial",, -8, .t.)
	local oFonteN			:= TFont():New("Arial",, -14, .t.)
	local oFonteB			:= TFont():New("Arial",, -12, .t.)
	local oFonte			:= TFont():New("Arial",, -18, .t.)
	local oFonteTit			:= TFont():New("Arial",, -30, .t.)
	local cPrinter			:= SuperGetMV("MV_ZZPNAM",.F.,"Argox CP-2140E PPLB")
	
	private oPrinter 	:= FWMSPrinter():New("produto.etq",IMP_SPOOL,lAdjustToLegacy,"/spool/",lDisableSetup,,,Alltrim(cPrinter) /*parametro que recebe a impressora*/,,,,,nQuant)
	//private oPrinter 	:= FWMSPrinter():New("produto.etq",IMP_SPOOL,lAdjustToLegacy,"/spool/",lDisableSetup,,,"Microsoft Print to PDF" /*parametro que recebe a impressora*/)
	
	Default aRet := {}
	
	nLinha1 := nLinIni				//10
	nLinha2 := nLinha1 + nSaltoEsp	//40
	nLinha3 := nLinha2 + nSalto		//63
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
	nColuna5 := 260
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
	oPrinter:Line(nLinha6,		nColuna2,	nLinha8,		nColuna2, 0, "-6")
	oPrinter:Line(nLinha2,		nColuna3,	nLinha5,		nColuna3, 0, "-6")  
	oPrinter:Line(nLinha4,		nColuna5,	nLinFim,		nColuna5, 0, "-6") 
	oPrinter:Line(nLinha6,		nColuna6,	nLinha8,		nColuna6, 0, "-6")
	oPrinter:Line(nLinha4,		nColuna7,	nLinha6,		nColuna7, 0, "-6")
	oPrinter:Line(nLinha6,		nColuna8,	nLinha8,		nColuna8, 0, "-6")
	
	// Conteúdo
	If Len(aRet) > 0 
		If nOpt == 1
			oPrinter:Say(nLinha1 + nSaltoCE,nColuna1 + 5,"Parafix " + Alltrim(cTipo) +" - "+ Alltrim(aRet[01]) ,oFonteTit)
		Else
			oPrinter:Say(nLinha1 + nSaltoCE,nColuna1 + 5,"Parafix " + Alltrim(cTipo) +" - "+ Alltrim(aRet[09]) ,oFonteTit)
		Endif		
	Else
		oPrinter:Say(nLinha1 + nSaltoCE,nColuna1 + 5,"Parafix " + Alltrim(cTipo) ,oFonteTit)
	Endif
	
	oPrinter:Say(nLinha2 + nSaltoCont,nColuna1 + 5,"Código",oFonte)
	oPrinter:Say(nLinha2 + nSaltoCont,nColuna3 + 5,"Descrição",oFonte)
	oPrinter:Say(nLinha3 + nSaltoCont,nColuna1 + 5,cCod,oFonteN)
	oPrinter:Say(nLinha3 + nSaltoCont,nColuna3 + 5,cDesc,oFonteN)
	


	oPrinter:Say(nLinha4 + nSaltoCont,nColuna1 + 5,"Lote / ID",oFonte)
	oPrinter:Say(nLinha4 + nSaltoCont,nColuna3 + 5,"Lote / OP",oFonte)
	oPrinter:Say(nLinha4 + nSaltoCont,nColuna5 + 5,"Data/Hora",oFonte)
	oPrinter:Say(nLinha4 + nSaltoCont,nColuna7 + 5,"Validade",oFonte)
	oPrinter:Say(nLinha5 + nSaltoCont,nColuna1 + 5,cLote,oFonteN)
	oPrinter:Say(nLinha5 + nSaltoCont,nColuna3 + 5,cLoteOp,oFonteN)
	oPrinter:Say(nLinha5 + nSaltoCont,nColuna5 + 5,cDataHora,oFonteN)
	oPrinter:Say(nLinha5 + nSaltoCont,nColuna7 + 5,cDataVal,oFonteN)
	
	oPrinter:Say(nLinha6 + nSaltoCont,nColuna1 + 5,"Qtd. 1a. UM",oFonte)
	oPrinter:Say(nLinha6 + nSaltoCont,nColuna2 + 5,"1a. UM",oFonte)
	oPrinter:Say(nLinha6 + nSaltoCont,nColuna4 + 5,"Qtd. 2a. UM",oFonte)
	oPrinter:Say(nLinha6 + nSaltoCont,nColuna5 + 5,"2a. UM",oFonte)
	oPrinter:Say(nLinha6 + nSaltoCont,nColuna6 + 5,"P. Liq. (Kg)",oFonte)
	oPrinter:Say(nLinha6 + nSaltoCont,nColuna8 + 5,"P. Bru. (Kg)",oFonte)
	oPrinter:Say(nLinha7 + nSaltoCont,nColuna1 + 5,cQtd1a,oFonteN)
	oPrinter:Say(nLinha7 + nSaltoCont,nColuna2 + 5,cUnd1a,oFonteN)
	oPrinter:Say(nLinha7 + nSaltoCont,nColuna4 + 5,cQtd2a,oFonteN)
	oPrinter:Say(nLinha7 + nSaltoCont,nColuna5 + 5,cUnd2a,oFonteN)
	oPrinter:Say(nLinha7 + nSaltoCont,nColuna6 + 5,cPesoLiq,oFonteN)
	oPrinter:Say(nLinha7 + nSaltoCont,nColuna8 + 5,cPesoBru,oFonteN)
	
	oPrinter:Say(nLinha8 + nSaltoCont,nColuna1 + 5,"Código do Cliente",oFonte)
	oPrinter:Say(nLinha8 + nSaltoCont,nColuna5 + 5,"Dimensão",oFonte)
	oPrinter:Say(nLinha9 + nSaltoCont,nColuna1 + 5,cCodCli,oFonteN)
	oPrinter:Say(nLinha9 + nSaltoCont,nColuna5 + 5,cDimensao,oFonteN)
	
	nLinC		:= 19.75	//Linha que será impresso o Código de Barra
	nColC		:= 1.50		//Coluna que será impresso o Código de Barra
	nWidth	 	:= 0.02	//Numero do Tamanho da barra. Default 0.025 limite de largura da etiqueta é 0.0164
	nHeigth   	:= 0.8		//Numero da Altura da barra. Default 1.5 --- limite de altura é 0.3
	lBanner		:= .T.		//Se imprime a linha com o código embaixo da barra. Default .T.
	nPFWidth	:= 1.0		//Número do índice de ajuste da largura da fonte. Default 1
	nPFHeigth	:= 1.0		//Número do índice de ajuste da altura da fonte. Default 1
	lCmtr2Pix	:= .F.		//Utiliza o método Cmtr2Pix() do objeto Printer.Default .T.
 	
 	oPrinter:SetFont(oFonteB)
	oPrinter:DataMatrix(405,280,cCodBar, 40)
	oPrinter:Say(288,nColuna1 + 295,cCodBar,oFonteS)
	oPrinter:EndPage()
	
	oPrinter:Print()
return

Static Function getValor(nValor)
	local cValor := ""
	
	cValor := Alltrim(Transform(nValor,"@ze 9,999,999,999,999.999"))			
	cValor := Strtran(cValor,".","")
	cValor := Strtran(cValor,",",".")
return cValor
