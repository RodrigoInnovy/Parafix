#Include 'Totvs.ch'
#Include 'TopConn.ch'
#Include 'Font.ch'
#Include 'Colors.ch'
#Include 'Fileio.ch'
#Include "prtopdef.ch"

/*/{Protheus.doc} ZZACD001
 Tela impressão etiqueta digitadas manualmente
 @type  Function
 @author  Augusto Krejci Bem-Haja
 @since   14/09/2017
 @Return  nil
/*/
user function ZZACD001()
	local aPergs 		:= {}
	local lRet
	local lObrig		:= .T.    
	local aPergs, aRet 	:= {}
	//local aCombo 		:= {"Matéria Prima","Produto Intermediário","Produto Acabado","PA - Automotivo","Pallet","Volume"}
	local aCombo 		:= {"Matéria Prima","Produto Intermediário","Produto Acabado","PA - Automotivo","Pallet"}
	local cCod,cDesc,cLote,cDataEnt, cDataHora,cDataVal,cQtd1a,cUnd1a,cQtd2a,cUnd2a,cNumPallet, cLoteOp := ""
	local cTipoVol,cCodBar, cPesoLiq, cPesoBru, cCodCli, cDimensao, cStatus, cECN, cCodQR, cQtd1aBar := ""
	local nQuant,nNumVol, nQtd1a := 0
	local cPrefixo1 := "%001" // Pré-requisito PC-Factory
	local cPrefixo2 := "%010" // Pré-requisito PC-Factory
	local cPrefixo3 := "%030" // Pré-requisito PC-Factory
	private bValidaCod	:= {||validaCod(MV_PAR02)}	   
	private bValidaLote	:= {||validaLote(MV_PAR03)}
	private bValidaNrPallet	:= {||validaNrPallet(MV_PAR10)}
	private bWhenPallet := {||validaTipo("Pallet",MV_PAR01)} 
	Private bCalc2A := { || calc2Qtd(MV_PAR02,MV_PAR06,2) }
	Private bCalc2B := { || calc2Qtd(MV_PAR02,MV_PAR08,1) }
	
	aAdd( aPergs ,{2,"Selecione o Tipo:"		,"Matéria Prima", aCombo, 70, ".F.", lObrig})
	aAdd( aPergs ,{1,"Código de Produto:"		,Space(15),"","Eval(bValidaCod)","SB1","",70,lObrig})
	aAdd( aPergs ,{1,"Lote:"					,Space(11),"","Eval(bValidaLote)","","",70,lObrig})
	aAdd( aPergs ,{1,"Data de Entrada:"			,Ctod(Space(8)),"","","","",70,lObrig})
	aAdd( aPergs ,{1,"Data de Vencimento:"		,Ctod(Space(8)),"","","","",70,lObrig})
	aAdd( aPergs ,{1,"Qtd 1a UM:"				,0,PesqPict('SB2','B2_QATU'),"Eval(bCalc2A)","","",70,lObrig})
	//aAdd( aPergs ,{1,"Qtd 1a UM:"				,0,PesqPict('SB2','B2_QATU'),"U_calc2Qtd(MV_PAR02,MV_PAR06,2)","","",70,lObrig})
	aAdd( aPergs ,{1,"1a UM:"					,Space(TamSX3("B1_UM")[1]),"","","",".F.",70,lObrig})
	aAdd( aPergs ,{1,"Qtd 2 UM:"				,0,PesqPict('SB2','B2_QATU'),"Eval(bCalc2B)","","",70,.F.})
	//aAdd( aPergs ,{1,"Qtd 2 UM:"				,0,PesqPict('SB2','B2_QATU'),"U_calc2Qtd(MV_PAR02,MV_PAR08,1)","","",70,.F.})
	aAdd( aPergs ,{1,"2a UM:"					,Space(TamSX3("B1_SEGUM")[1]),"","","",".F.",70,.F.})
	aAdd( aPergs ,{1,"Nr. Pallet:"				,Space(3),"","Eval(bValidaNrPallet)","","Eval(bWhenPallet)",70,Eval(bWhenPallet)})   
	aAdd( aPergs ,{1,"Vol. Pallet:"				,0,"@E 999","","","Eval(bWhenPallet)",70,Eval(bWhenPallet)})   
	aAdd( aPergs ,{1,"Tp. Vol. Pallet:"			,Space(3),"","","","Eval(bWhenPallet)",70,Eval(bWhenPallet)})
	aAdd( aPergs ,{1,"Cópias:"					,0,"@E 99999","","","",70,lObrig}) 
	aAdd( aPergs ,{1,"Lote OP:"			        ,Space(11),"","","","",70,lObrig})	

	
	
	if ParamBox(aPergs ,"Etiqueta de Produto",aRet) 
		cCod 		:= allTrim(aRet[2])
		cDesc		:= Posicione('SB1',1,xFilial('SB1')+cCod,"B1_DESC")
		cLote		:= allTrim(aRet[3])
		cDataEnt	:= dToC(aRet[4])
		cDataHora	:= dToC(aRet[4]) + "  00:00"
		cDataVal	:= dToC(aRet[5])
		nQtd1a		:= aRet[6]
		cQtd1a		:= Alltrim(Transform(aRet[6],"@E 9,999,999.99"))
		cQtd1aBar	:= Alltrim(strTran(Transform(nQtd1a,"@E 9999999.999999"),",",".")) //getValor(nQtd1a)
		cUnd1a		:= Alltrim(aRet[7])
		cQtd2a		:= Alltrim(Transform(aRet[8],"@E 9,999,999.99"))
		cUnd2a		:= Alltrim(aRet[9])
		cLoteOP     := Alltrim(aRet[14])
		
		cCodBar		:= cPrefixo1+cCod+cPrefixo2+cLote+cPrefixo3+cQtd1aBar
		nQuant := aRet[13]
		
		if aRet[1] = "Matéria Prima" 
			cTipo 		:= "MP"
    	   	U_etqMPPI(cTipo,cCod,cDesc,upper(cLote),cDataHora,cDataVal,cQtd1a,cUnd1a,cQtd2a,cUnd2a,upper(cCodBar),nQuant)
    	   	//U_etqMPPI(cTipo,cCod,cDesc,cLote,cDataHora,cDataVal,cQtd1a,cUnd1a,cQtd2a,cUnd2a,cCodBar,nQuant,"012345678/1","000123/01","0001")
		elseif aRet[1] = "Produto Intermediário"
			cTipo 		:= "PI  -  Produto Intermediário"
   	   		U_etqMPPI(cTipo,cCod,cDesc,upper(cLote),cDataHora,cDataVal,cQtd1a,cUnd1a,cQtd2a,cUnd2a,upper(cCodBar),nQuant)
		elseif aRet[1] = "Produto Acabado" .or. aRet[1] = "PA - Automotivo"
			cPesoLiq	:= AllTrim(Transform(Posicione('SB1',1,xFilial('SB1')+cCod,"B1_PESO") * nQtd1a, "@E 999,999.99"))
			cPesoBru	:= AllTrim(Transform(Posicione('SB1',1,xFilial('SB1')+cCod,"B1_PESBRU") * nQtd1a, "@E 999,999.99"))
			cCodCli		:= Posicione('SB1',1,xFilial('SB1')+cCod,"B1_ZZCLI")
			cDimensao	:= Posicione('SB1',1,xFilial('SB1')+cCod,"B1_ZZDIM")
			cStatus		:= Posicione('SB1',1,xFilial('SB1')+cCod,"B1_ZZSTA")
			cECN		:= Posicione('SB1',1,xFilial('SB1')+cCod,"B1_ZZECN")
			if aRet[1] = "Produto Acabado"
				cTipo 		:= "PA - Produto Acabado"
    	   		U_etqPA(1,cTipo,cCod,cDesc,upper(cLote),upper(cLoteOp),cDataHora,cDataVal,cQtd1a,cUnd1a,cQtd2a,cUnd2a,upper(cCodBar),cCodCli,cDimensao,cStatus,cECN,cPesoLiq,cPesoBru,nQuant)
   	   			//U_etqPA(cTipo,'1-101-0002','FILBOPP BR 27G','00000000123','15/09/2017  /  00:00','15/09/2017','900,00','M2','240.50','Kg','(001)1-101-0002(010)00000000123(030)900,00','XXXXXXXXXX','50MM X 750M','Q.A.','01','22,89','29,40')
			elseif aRet[1] = "PA - Automotivo"	
				cTipo 		:= "PA - Automotivo"
				cCodQR		:= cCod+cQtd1a+cLote+cDataEnt
   	   			U_etqPAAU(cTipo,cCod,cDesc,upper(cLote),cDataHora,cDataVal,cQtd1a,cUnd1a,cQtd2a,cUnd2a,upper(cCodBar),cCodCli,cDimensao,cStatus,cECN,cPesoLiq,cPesoBru,nQuant,upper(cCodQR))
   	   			//U_etqPAAU(cTipo,'1-101-0002','FILBOPP BR 27G','00000000123','15/09/2017  /  00:00','15/09/2017','900,00','M2','240.50','Kg','(001)1-101-0002(010)00000000123(030)900,00','XXXXXXXXXX','50MM X 750M','Q.A.','01','22,89','29,40',1,'1-101-0002900,000000000012315/09/2017')
	    	endif
		elseif aRet[1] = "Pallet"
			cTipo 		:= ""
			cNumPallet	:= aRet[10]
			nNumVol		:= aRet[11]
			cTipoVol	:= aRet[12]
			cPesoLiq	:= AllTrim(Transform(Posicione('SB1',1,xFilial('SB1')+cCod,"B1_PESO") * nQtd1a, "@E 999,999.99"))
			cPesoBru	:= AllTrim(Transform(Posicione('SB1',1,xFilial('SB1')+cCod,"B1_PESBRU") * nQtd1a, "@E 999,999.99"))
    	   	U_etqPallet(cTipo,cCod,cDesc,upper(cLote),cDataHora,cDataVal,cQtd1a,cUnd1a,cQtd2a,cUnd2a,upper(cCodBar),cPesoLiq,cPesoBru,nQuant,cDataEnt,cNumPallet,nNumVol,cTipoVol)
    	   	//U_etqPallet(cTipo,'1-101-0002','FILBOPP BR 27G','00000000123','15/09/2017  /  00:00','15/09/2017','900,00','M2','240.50','Kg','(001)1-101-0002(010)00000000123(030)900,00','22,89','29,40',1,'001',5,'CX')
    	/*elseif aRet[1] = "Volume"
			cCliente 	:= "ACTIVE"
			cData		:= "26/05/2017"
			cNF_Serie	:= "123456789 / 1"
			cPedido		:= "231765"
			cTransp		:= "MERIDIONAL"
			nNumVol		:= nQuant
			for i:=1 to nNumVol
				cVolume := strZero(i,2,0) + " / " + strZero(nNumVol,2,0)
				cCodBar		:= strZero(i,10)
				U_etqVol(cCliente, cData, cNF_Serie, cPedido, cTransp, cVolume, cCodBar) 
			next*/
		endif      
	endIf
return

static function validaTipo(cTipoCpo,cTipoSel)
	local lRetorno := .F.

If valtype(cTipoSel) = "N"
cTipoSel := str(cTipoSel,15)
endif		

if (cTipoCpo = cTipoSel)
lRetorno := .T.
endif

return lRetorno


//user function calc2Qtd(cCod,nQuant,nOpc)
static function calc2Qtd(cCod,nQuant,nOpc)
	local lRetorno := .T.

	if !Empty(cCod)
		if nOpc = 2
			MV_PAR08 := ConvUm(cCod, nQuant, 0, nOpc)
		else
			MV_PAR06 := ConvUm(cCod, 0, nQuant, nOpc)
		endif
	endif
return lRetorno

static function validaCod(cCod)
	local lRetorno := .F.
	local cUM,cSegUM := ""
	
	if ExistCpo('SB1', cCod)
		cUM 	:= posicione("SB1",1,xFilial("SB1")+cCod,"B1_UM") 
		cSegUM 	:= posicione("SB1",1,xFilial("SB1")+cCod,"B1_SEGUM")
		MV_PAR07 := cUM
		MV_PAR09 := cSegUM
		lRetorno := .T.
	endif
return lRetorno

static function validaLote(cLote)
	local lRetorno := .F.
	
	if !Empty (cLote)
		MV_PAR03 := PADL(allTrim(cLote), 11,'0')
		lRetorno := .T.
	endif
return lRetorno

static function validaNrPallet(cNum)
	local lRetorno := .F.
	
	if !Empty (cNum)
		MV_PAR10 := PADL(allTrim(cNum), 3,'0')
		lRetorno := .T.
	endif
return lRetorno

static function getValor(nValor)
	local cValor := ""
	
	cValor := Alltrim(Transform(nValor,"@ze 9,999,999,999,999.99"))			
	cValor := Strtran(cValor,".","")
	cValor := Strtran(cValor,",",".")
return cValor
