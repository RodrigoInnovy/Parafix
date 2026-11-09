#Include 'Totvs.ch'
#Include 'TopConn.ch'
#Include 'Font.ch'
#Include 'Colors.ch'
#Include 'Fileio.ch'
#Include "prtopdef.ch"

/*/{Protheus.doc} ZZACD002 Tela impressão etiqueta digitadas manualmente
 @type  Function
 @author  Augusto Krejci Bem-Haja
 @since   22/11/2017
 @Return  nil
/*/
user function ZZACD002()
	local aPergs 		:= {}
	local lRet
	local lObrig		:= .T.    
	local aPergs, aRet 	:= {}
	local cNF			:= ""
	local cSerie 		:= ""
	local cCliente		:= ""
	local cData			:= ""
	local cNF_Serie		:= ""
	local cTransp		:= ""
	local cPedido		:= ""
	local cCodBar		:= ""
	local cVolume		:= ""
	local nCont			:= 1
	
	private cAlias	:= ""
	private nRegs	:= 0
	
	aAdd( aPergs ,{1,"Número NF:"	,Space(9),"","","SF2","",70,lObrig})
	aAdd( aPergs ,{1,"Série:"		,Space(3),"","","","",70,lObrig})

	if ParamBox(aPergs ,"Etiqueta de Produto",aRet)
		cNF			:= aRet[1]
		cSerie		:= aRet[2] 
		if vldNF(cNF,cSerie)
			(cAlias) -> (dbGotop())
			cCliente 	:= (cAlias)->A1_NREDUZ
			cData		:= dtoc(stod((cAlias)->F2_EMISSAO))
			cNF_Serie	:= (cAlias)->DOCSERIE
			cTransp		:= (cAlias)->A4_NOME
			nNumVol		:= nRegs
			cPais       := (cAlias)->A1_PAIS
			cCodClie    := (cAlias)->A1_COD
			while !((cAlias)->(eof()))
				cPedido	:= (cAlias)->CB6_PEDIDO
				cCodBar := (cAlias)->CB6_VOLUME 
				cVolume := strZero(nCont,2,0) + " / " + strZero(nNumVol,2,0)
				U_etqVol(cCliente, cData, cNF_Serie, cPedido, cTransp, cVolume, cCodBar)
				(cAlias)->(dbSkip())
				nCont++
			enddo
			If cPais =='063'
			U_etqEXPO(cCliente, cData, cNF_Serie, cPedido, cTransp, cVolume, cCodBar)// Vinicius ETIQUETA CLIENTE ARGENTINA
			EndIf
			
			//If cCodClie $('000310','000531')
			//U_LOTESSF3(cCliente, cData, cNF_Serie, cPedido, cTransp, cVolume, cCodBar)// Vinicius ETIQUETA ONTEX em desevolvimento
			//EndIf

		/*else
			cCliente 	:= "ACTIVE"
			cData		:= "26/05/2017"
			cNF_Serie	:= "123456789 / 1"
			cPedido		:= "231765"
			cTransp		:= "MERIDIONAL"
			nNumVol		:= 1
			for i:=1 to nNumVol
				cVolume := strZero(i,2,0) + " / " + strZero(nNumVol,2,0)
				cCodBar		:= strZero(i,10)
				U_etqVol(cCliente, cData, cNF_Serie, cPedido, cTransp, cVolume, cCodBar) 
			next*/
		endIf
	endif
return

static function vldNF(cNF,cSerie)
	local lRetorno := .T.
	
	nRegs := QryRgs(cNF,cSerie)
	
	if nRegs <= 0
		MsgAlert("Atenção, NF e Série inválidas ou inexistentes!")
		lRetorno := .F.
	Endif
return lRetorno

Static Function QryRgs(cNF,cSerie) 
	local cQuery := ""
	local cEol   := chr(10) + chr(13)
	local nRegs
	cAlias := GetNextAlias()
	
	cQuery := " SELECT SA1.A1_NREDUZ, SF2.F2_EMISSAO, SF2.F2_DOC + ' / ' + SF2.F2_SERIE AS DOCSERIE, CB6.CB6_PEDIDO, SA4.A4_NOME, CB6.CB6_VOLUME, SA1.A1_PAIS,SA1.A1_COD FROM " +RetSqlName("SF2") +" SF2 "+ cEol
	cQuery += "		INNER JOIN " +RetSqlName("SA1")+" SA1 ON SF2.F2_CLIENTE = SA1.A1_COD "+ cEol
	cQuery += "											AND SF2.F2_LOJA = SA1.A1_LOJA " + cEol
	cQuery += "											AND SA1.A1_FILIAL = '"+xFilial("SA1")+"' " + cEol
	cQuery += "											AND SA1.D_E_L_E_T_ = ' ' " + cEol
	cQuery += "		INNER JOIN " +RetSqlName("SA4")+" SA4 ON SF2.F2_TRANSP = SA4.A4_COD "+ cEol
	cQuery += "											AND SA4.A4_FILIAL = '"+xFilial("SA4")+"' " + cEol
	cQuery += "											AND SA4.D_E_L_E_T_ = ' ' " + cEol
	cQuery += "		INNER JOIN " +RetSqlName("CB6")+" CB6 ON SF2.F2_DOC = CB6.CB6_NOTA "+ cEol
	cQuery += "											AND SF2.F2_SERIE = CB6.CB6_SERIE " + cEol
	cQuery += "											AND SF2.F2_FILIAL = CB6.CB6_FILIAL " + cEol
	cQuery += "											AND CB6.D_E_L_E_T_ = ' ' " + cEol	
	cQuery += " WHERE SF2.F2_FILIAL = '" + xFilial("SF2") + "'"+ cEol
	cQuery += "   AND SF2.F2_DOC = '" + cNF + "' " + cEol
	cQuery += "   AND SF2.F2_SERIE = '"+ cSerie +"' "+ cEol 
	cQuery += "   AND SF2.D_E_L_E_T_ = ' ' " + cEol
			
	TCQUERY cQuery NEW ALIAS &cAlias
	
	count to nRegs	
Return nRegs
