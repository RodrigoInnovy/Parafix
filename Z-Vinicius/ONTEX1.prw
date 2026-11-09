// Fonte que imprime a etiqueta volume de Exportação para cliente da Argentina.
#Include "protheus.ch"
#Include "rptdef.ch"
#Include "fwprintsetup.ch"
#Include "topconn.ch"
#Include "prtopdef.ch"


	user function ONTEX1(cB1cod, cB1desc, cB1tipo, cB1um, cB1grupo, cB1ucom, cB1idhist, cD2lotectl, cD2emissao, cD2quant, cH6op, cH6dtapont, cA7codcli, cA7descli, cD2doc, cA1nome,cCliente, cData, cNF_Serie, cPedido, cTransp, cVolume, cCodBar)
	local nColIni   		:= 10
	local nColFim   		:= 500 //485
	local nLinIni   		:= 10
	local nLinFim			:= 300 //250
	local nSalto 			:= 15
	local nSaltoG 			:= 25
	Local lAdjustToLegacy 	:= .f.
	Local lDisableSetup  	:= .T.
	local oFonteN			:= TFont():New("Arial",, -14, .t.)
	local oFonteB			:= TFont():New("Arial",, -14, .t.)
	local cPrinter			:= SuperGetMV("MV_ZZPNAM",.F.,"Argox CP-2140E PPLB")


	private oPrinter 	:= FWMSPrinter():New("produto.etq",IMP_SPOOL,lAdjustToLegacy,"/spool/",lDisableSetup,,,Alltrim(cPrinter) /*parametro que recebe a impressora*/,,,,,1)
	//private oPrinter 	:= FWMSPrinter():New("produto.etq",IMP_SPOOL,lAdjustToLegacy,"/spool/",lDisableSetup,,,Alltrim("PDFCreator") /*parametro que recebe a impressora*/)
	
	nLinha1 := nLinIni				//10
	nLinha2 := nLinha1 + nSalto 
	nLinha3 := nLinha2 + nSaltoG 
	nLinha4 := nLinha3 + nSalto 
	nLinha5 := nLinha4 + nSaltoG
	nLinha6 := nLinha5 + nSalto 
	nLinha7 := nLinha6 + nSaltoG 
	nLinha8 := nLinha7 + nSalto
	nLinha9 := nLinha8 + nSaltoG 
	nLinha10 := nLinha9 + nSaltoG 
	nLinha11 := nLinha10 + nSalto 
	nLinha12 := nLinha11 + nSaltoG 
	nLinha13 := nLinha12 + nSalto 
	nLinha14 := nLinha13 + nSaltoG 

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
	oPrinter:Say(nLinha1 + nSalto,nColuna1 + 5,cA7codcli,oFonteN)
	oPrinter:Say(nLinha2 + nSalto,nColuna1 + 5,cA7descli,oFonteB)


	oPrinter:Say(nLinha3 + nSalto,nColuna1 + 5,"SSCC ",oFonteN)
	oPrinter:Say(nLinha3 + nSalto,nColuna2 + 5,"QUANTITY",oFonteN)

	
	oPrinter:Say(nLinha4 + nSalto,nColuna1 + 5,"nao sei",oFonteB)
	oPrinter:Say(nLinha4 + nSalto,nColuna2 + 5,cD2quant+" "+cB1um,oFonteB)
	
	oPrinter:Say(nLinha5 + nSalto,nColuna1 + 5,"VENDOR / NAME:",oFonteN)
	oPrinter:Say(nLinha6 + nSalto,nColuna1 + 5,"94218/ ONTEX OPERATIONS ISA, LLC",oFonteN)
	
	oPrinter:Say(nLinha7 + nSalto,nColuna1 + 5,"BATCH / LOT",oFonteN)
	oPrinter:Say(nLinha7 + nSalto,nColuna2 + 5,"PACK DATE",oFonteN)
	
	oPrinter:Say(nLinha8 + nSalto,nColuna1 + 5,cD2lotectl,oFonteB)
	oPrinter:Say(nLinha8 + nSalto,nColuna2 + 5,cH6dtapont,oFonteB)
	
    oPrinter:Code128(nLinha9 + nSalto,nColuna1 +10,"(240)G2.7920(10)P2309027740",4,18,.F.,,350)
	oPrinter:Say(nLinha10 + nSalto,nColuna1 +10,"(240)G2.7920(10)P2309027740",oFonteB)

	oPrinter:Code128(nLinha11 + nSalto,nColuna1 +10,"(13)230730(30)00003528",4,18,.F.,,200)
	oPrinter:Say(nLinha12 + nSalto,nColuna1 +10,"(13)230730(30)00003528",oFonteB)

	oPrinter:Code128(nLinha13 + nSalto,nColuna1 +10,"(00)",4,15,.F.,,100)
	oPrinter:Say(nLinha14 + nSalto,nColuna1+10,"(00)",oFonteB)

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
