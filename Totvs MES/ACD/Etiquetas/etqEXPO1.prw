// Fonte que imprime a etiqueta volume de Exportação para cliente da Argentina.
#Include "protheus.ch"
#Include "rptdef.ch"
#Include "fwprintsetup.ch"
#Include "topconn.ch"
#Include "prtopdef.ch"


	user function etqEXPO1(cCliente,cData,cNF_Serie,cPedido,cTransp,cVolume,cCodBar,cCod,cDesc,cPeso,cCompr,cUm,cDesbse3,cPfisica) 
	local nColIni   		:= 10
	local nColFim   		:= 485 //485
	local nLinIni   		:= 10
	local nLinFim			:= 250
	local nSalto 			:= 20
	local nSaltoG 			:= 30
	Local lAdjustToLegacy 	:= .f.
	Local lDisableSetup  	:= .T.
	Local cBitMap           := ("\system\lgrl01etqexpo1.bmp")
	local oFonteN			:= TFont():New("Arial",, -14, .t.)
	local oFonteB			:= TFont():New("Arial",, -14, .t.)
	local cPrinter			:= SuperGetMV("MV_ZZPNAM",.F.,"Argox CP-2140E PPLB")


	private oPrinter 	:= FWMSPrinter():New("produto.etq",IMP_SPOOL,lAdjustToLegacy,"/spool/",lDisableSetup,,,Alltrim(cPrinter) /*parametro que recebe a impressora*/,,,,,1)
	//private oPrinter 	:= FWMSPrinter():New("produto.etq",IMP_SPOOL,lAdjustToLegacy,"/spool/",lDisableSetup,,,Alltrim("PDFCreator") /*parametro que recebe a impressora*/)
	
	nLinha1 := nLinIni				//10
	nLinha2 := nLinha1 + nSalto 
	nLinha3 := nLinha2 + nSalto 
	nLinha4 := nLinha3 + nSalto 
	nLinha5 := nLinha4 + nSalto 
	nLinha6 := nLinha5 + nSalto 
	nLinha7 := nLinha6 + nSalto 
	nLinha8 := nLinha7 + nSaltoG 
	nLinha9 := nLinha8 + nSaltoG 
	nLinha10 := nLinha9 + nSalto 
	nLinha11 := nLinha10 + nSalto 

	
	nColuna1 := nColIni
	nColuna2 := 280
	nColuna3 := 360
	
	oPrinter:SetMargin(10,10,10,10)
	//oPrinter:SetPaperSize(0,142,104)
	oPrinter:SetLandScape()
	
	oPrinter:StartPage()
	
	//Box geral
	oPrinter:Box(nLinIni,		nColIni,	nLinFim,	nColFim, "-8")
	
	oFonteN:Bold := .t.
	oPrinter:SetFont(oFonteN)

	// Conteï¿½do
	oPrinter:Say(nLinha1 + nSalto,nColuna1 + 5,"Razon Social Fabricante:",oFonteN)
	oPrinter:Say(nLinha1 + nSalto,nColuna2 + 5,"CNPJ:",oFonteN)
	
	oPrinter:Say(nLinha2 + nSalto,nColuna1 + 5,"PARAFIX IND. & COM. DE FITAS ADESIVAS LTDA.",oFonteB)
	oPrinter:Say(nLinha2 + nSalto,nColuna2 + 5,"03.192.243/0001-67",oFonteB)

	oPrinter:Say(nLinha3 + nSalto,nColuna1 + 5,"Producto: "+cCod,oFonteN)
	oPrinter:Say(nLinha3 + nSalto,nColuna2 + 5,"Gramatura:",oFonteN)
	oPrinter:Say(nLinha3 + nSalto,nColuna3 + 5,"Metros:",oFonteN)
	
	oPrinter:Say(nLinha4 + nSalto,nColuna1 + 5,cDesc,oFonteB)
	oPrinter:Say(nLinha4 + nSalto,nColuna2 + 5,cPeso,oFonteB)
	oPrinter:Say(nLinha4 + nSalto,nColuna3 + 5,cCompr+" "+cUm,oFonteB)
	
	oPrinter:Say(nLinha5 + nSalto,nColuna1 + 5,cDesbse3,oFonteB)
	
	oPrinter:Say(nLinha6 + nSalto,nColuna1 + 5,"Pais de Origem: Fabricado no Brazil",oFonteN)
	
	oPrinter:Say(nLinha7 + nSalto,nColuna1 + 5,"Tratamientos y cuidados para la conservacion del Producto: ",oFonteN)

	oPrinter:SayBitmap(nLinha7 + nSaltoG,nColuna1 + 5,cBitMap,250,40)
	
	oPrinter:Say(nLinha9 + nSaltoG,nColuna1 + 5,"Razon Socila Importador:",oFonteN)
	oPrinter:Say(nLinha9 + nSaltoG,nColuna2 + 5,"CUIT:",oFonteN)

	oPrinter:Say(nLinha10 + nSalto,nColuna1 + 5,Alltrim(cCliente),oFonteB)
	oPrinter:Say(nLinha10 + nSalto,nColuna2 + 5,cPfisica,oFonteB)

 	//oPrinter:QRCode(250,150,"QR Code gerado com sucesso", 100)
	//oPrinter:DataMatrix(220,280,cCodBar, 65)
	//oPrinter:Say(288,nColuna1 + 220,cCodBar,oFonteS)
	//oPrinter:EndPage()	
	
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
