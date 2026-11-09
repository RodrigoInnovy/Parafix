#Include 'Totvs.ch'
#Include 'TopConn.ch'
#Include 'Font.ch'
#Include 'Colors.ch'
#Include 'Fileio.ch'
#Include "prtopdef.ch"

/*/{Protheus.doc} ZZACD002 Tela impressão etiqueta digitadas manualmente
 @type  Function
 @author  Lucas Silva
 @since   05/09/2022
 @Return  nil
/*/
user function ETQWOOD()
	local aPergs 		:= {}
	local lRet
	local lObrig		:= .T.    
	local aPergs, aRet 	:= {}
	local cNF			:= ""
	local cSerie 		:= ""
	local cCliente		:= ""
	local cLoja 		:= ""
	local cData			:= ""
	local cNF_Serie		:= ""
	local cTransp		:= ""
	local cPedido		:= ""
	local cCodBar		:= ""
	local cVolume		:= ""
	local nCont			:= 1
	local cProd			:= ""
	local cDescr		:= ""
	local cEcn			:= ""
	local nQuant		:= ""
	local cLote			:= ""
	local cUnd			:= ""
	local cExpedic		:= ""
	local cCodCli		:= ""

	private cAlias	:= ""
	private nRegs	:= 0
	
	aAdd( aPergs ,{1,"Número NF:"	,Space(9),"","","SF2","",70,lObrig})
	//aAdd( aPergs ,{1,"Série:"		,Space(3),"","","","",70,lObrig})

	if ParamBox(aPergs ,"Etiqueta de Produto",aRet)
		cNF			:= aRet[1]
	//	cSerie		:= aRet[2] 
		if vldNF(cNF)
			(cAlias) -> (dbGotop())
			cCliente 	:= (cAlias)->A1_MUN
			cLoja 		:= "01"
			//cNF_Serie	:= (cAlias)->F2_DOC
			cExpedic	:= DTOC((cAlias)->F2_EMISSAO)  //tcsetfild

			//cTransp		:= (cAlias)->A4_NOME
			//nNumVol		:= nRegs
			while !((cAlias)->(eof()))
				//cPedido	:= (cAlias)->CB6_PEDIDO
				cProd	:= alltrim((calias)->D2_COD)
				cCodCli := alltrim((calias)->B1_ZZCLI)
				cDescr	:= (calias)->A7_DESCCLI
				cEcn	:= alltrim((calias)->B1_ZZECN)
				nQuant	:= IIF((calias)->D2_UM $ "PC", alltrim(str((calias)->D2_QUANT)), alltrim(str((calias)->D2_QTSEGUM)))
				cData	:= (cAlias)->H6_DTAPONT
				cLote	:= (calias)->D2_LOTECTL
				cUnd	:= IIF((calias)->D2_UM $ "PC",(calias)->D2_UM,(calias)->D2_SEGUM)




				cCodBar := cCodCli + cEcn + 'CPV' + nQuant + cProd + cLoja + cLote + alltrim(cData) + cNF
				
				//cVolume := strZero(nCont,2,0) + " / " + strZero(nNumVol,2,0)
				u_itemetq(cCliente, cLoja, cNF, cExpedic, cProd, cCodCli, cDescr, cEcn,nQuant,cData,cLote,cUnd,cCodBar)  //Passa informações para o Layaut da Etiqueta
				(cAlias)->(dbSkip())
				nCont++
			enddo
		
		endIf
	endif
return

static function vldNF(cNF)
	local lRetorno := .T.
	
	nRegs := QryRgs(cNF)
	
	if nRegs <= 0
		MsgAlert("Atenção, NF e Série inválidas ou inexistentes!")
		lRetorno := .F.
	Endif
return lRetorno

Static Function QryRgs(cNF) 
	local cQuery := ""
	local cEol   := chr(10) + chr(13)
	local nRegs
	cAlias := GetNextAlias()



cQuery := " SELECT D2_COD, B1_ZZCLI, B1_DESC, B1_TIPO, D2_UM, B1_GRUPO, D2_SEGUM, B1_IDHIST, D2_LOTECTL, F2_VEND1, F2_EMISSAO, D2_QUANT, D2_QTSEGUM, SH6.H6_OP, FORMAT(CONVERT(DATE,SH6.H6_DTAPONT,103), 'ddMMyy') AS H6_DTAPONT, SA7.A7_CODCLI, SA7.A7_DESCCLI, SA1.A1_NREDUZ, SA1.A1_MUN, SF2.F2_DOC, SB1.B1_ZZECN, SD2.D2_LOJA "+ cEol
cQuery += " FROM " +RetSqlName("SF2") +" SF2 "+ cEol
cQuery += " INNER JOIN " +RetSqlName("SD2")+ " SD2 ON F2_FILIAL = D2_FILIAL " + cEol
cQuery += "											AND F2_DOC = D2_DOC " + cEol
cQuery += "											AND F2_SERIE = D2_SERIE " + cEol
cQuery += "											AND F2_CLIENTE = D2_CLIENTE " + cEol
cQuery += "											AND F2_LOJA = D2_LOJA " + cEol
cQuery += "											AND SD2.D_E_L_E_T_ = ' ' " + cEol
cQuery += " INNER JOIN " +RetSqlName("SB1")+ " SB1 ON D2_COD = B1_COD 
cQuery += "											AND SB1.D_E_L_E_T_ = ' ' "+ cEol
cQuery += " INNER JOIN " +RetSqlName("SH6")+ " SH6 ON H6_LOTECTL = D2_LOTECTL 
cQuery += "											AND SH6.D_E_L_E_T_ = '' "+ cEol
cQuery += " INNER JOIN " +RetSqlName("SA7")+ " SA7 ON A7_CLIENTE = D2_CLIENTE "+ cEol
cQuery += "											AND A7_LOJA = D2_LOJA "+ cEol
cQuery += "											AND A7_PRODUTO = D2_COD "+ cEol
cQuery += "											AND SA7.D_E_L_E_T_ = '' "+ cEol
cQuery += " INNER JOIN " +RetSqlName("SA1")+ " SA1 ON A1_COD+A1_LOJA = D2_CLIENTE+D2_LOJA 
cQuery += "											AND SA1.D_E_L_E_T_ = '' "+ cEol
cQuery += " WHERE SF2.F2_FILIAL = '" + xFilial("SF2") + "'"+ cEol
cQuery += " 	AND  F2_DOC = '"+ cNF +"' " + cEol
	
			
	TCQUERY cQuery NEW ALIAS &cAlias
	TCSETFIELD(cAlias,"F2_EMISSAO","D")
	
	count to nRegs	
Return nRegs

