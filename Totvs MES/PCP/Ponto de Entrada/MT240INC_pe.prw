#Include "TOTVS.CH"
#Include "topconn.ch"

/*/{Protheus.doc} MT240INC
Migrado do SD3240I pois estava impactando na integração TOTVS MES
Migrado do MT240INC rotina descontinuada em 04/04/2022

@type	User Function
@author 	João Gustavo Orsi
@since 	01/03/2018
@version P12
/*/

User Function MT240INC()

	
	If IsInCallStack("WSPCPRUN")
		Do Case
			Case SD3->D3_TM == "901" .And. !Empty(SD3->D3_OP)
				ApontPer(SD3->D3_OP,SD3->D3_COD,SD3->D3_LOCAL,SD3->D3_QUANT,SD3->D3_NUMSEQ,SD3->D3_EMISSAO,SD3->D3_LOCALIZ,SD3->D3_LOTECTL,SD3->D3_DTVALID)
			Case SD3->D3_TM == "480" .And. Empty(SD3->D3_OP)
				EndProd(SD3->D3_FILIAL,SD3->D3_DOC,SD3->D3_NUMSEQ,SD3->D3_COD,SD3->D3_LOCAL,SD3->D3_LOTECTL,SD3->D3_EMISSAO,SD3->D3_ZZENDP)
		EndCase
		If SD3->D3_TM $ "480/980"
			RecLock("SD3",.F.)
				SD3->D3_CC := "19100101"
			MsUnlock("SD3")
		EndIf
	EndIf
	
Return 

/*/{Protheus.doc} ApontPer
Apontamento automático de perda quando usar a TM 901.
Específico TOTVS MES na Parafix.

@author João Gustavo Orsi
@since 13/02/2018
@version P12
/*/
Static Function ApontPer(cOp,cProduto,cLocal,nQuant,cNumSeq,dDataEmis,cEndereco,cLote,dDtValid)

	Local aCab	 		:= {}
	Local aLinha 			:= {}
	Local aItens 			:= {}
	Local aAreaSBC 		:= SBC->(GetArea())
	Local nCount := 0
	
	Private lMSErroAuto := .F.
	Private lAutoErrNoFile := .T.
	Private nStart
	
                    	
	aCab:= 	  {	{"BC_OP", 		cOp			,	Nil}, ;
				{"BC_OPERAC", 	""			,	Nil}, ;
				{"BC_RECURSO", 	""			, 	Nil}}	
				
	aItens := {	{"BC_QUANT",		nQuant		, 	Nil}, ;		
				{"BC_QTSEGUM",	0			,	Nil}, ;
				{"BC_PRODUTO",	cProduto		, 	Nil}, ;			
				{"BC_LOCORIG",	cLocal		, 	Nil}, ;			
				{"BC_LOCALIZ",	cEndereco		,	Nil}, ;
				{"BC_TIPO",		"S"			, 	Nil}, ;			
				{"BC_MOTIVO",		"001"		, 	Nil}, ;
				{"BC_LOTECTL",	cLote		, 	Nil}, ;
				{"BC_DTVALID",	dDtValid		,	Nil}, ;
				{"BC_DATA",		dDataEmis		, 	Nil}, ;				           			
				{"BC_OPERADO",	""			, 	Nil}}           			
			
	AAdd(aLinha, aItens)
	MsExecAuto ( {|x,y,z| MATA685(x,y,z) }, aCab, aLinha, 3)
	If lMsErroAuto
		aErroAuto := GetAutoGRLog()
       For nCount := 1 To Len(aErroAuto)
        FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01",aErroAuto[nCount], 0, (nStart - Seconds()), {})

       Next nCount
	EndIf
	RestArea(aAreaSBC)
	
Return

/*/{Protheus.doc} EndProd
Endereçamento automático de devoluções com TM 480 que vem da 
integração.
Específico TOTVS MES na Parafix.

@author João Gustavo Orsi
@since 15/02/2018
@version P12
/*/
Static Function EndProd(_cFilial,_cDoc,_cNumseq,_cProduto,_cLocal,_cLoteCtl,dDataEmis,_cEndMov)

	Local aCab 		:= {} && Array cabecalhos
	Local aItem		:= {} && Array itens
	Local cAlias 		:= GetNextAlias()
	Local aAreaSDA 	:= SDA->(GetArea())
	Local nCount := 0
	
	Private lMSErroAuto := .F.
	Private lAutoErrNoFile := .T.
	Private nStart
	
	BeginSql Alias cAlias
		SELECT *
		FROM %table:SDA% SDA
		WHERE DA_FILIAL = %Exp:_cFilial%
			AND DA_DOC = %Exp:_cDoc%
			AND DA_NUMSEQ = %Exp:_cNumseq%
			AND DA_PRODUTO = %Exp:_cProduto%
			AND DA_LOCAL = %Exp:_cLocal%
			AND DA_LOTECTL = %Exp:_cLoteCtl%
			AND SDA.%NotDel%
	EndSql 
	
	(cAlias)->(DbGoTop())
	While !(cAlias)->(EOF())
		aCab :=	{	{"DA_PRODUTO"	,(cAlias)->DA_PRODUTO	,	Nil}, ;
				{"DA_QTDORI"	,(cAlias)->DA_QTDORI		,	Nil}, ;
				{"DA_DATA"	,(cAlias)->DA_DATA			,	Nil}, ;
				{"DA_LOCAL"	,(cAlias)->DA_LOCAL		,	Nil}, ;
				{"DA_LOTECTL"	,(cAlias)->DA_LOTECTL		,	Nil}, ;
				{"DA_NUMLOTE"	,(cAlias)->DA_NUMLOTE		,	Nil}, ;
				{"DA_ORIGEM"	,(cAlias)->DA_ORIGEM		,	Nil}, ;
				{"DA_NUMSEQ"	,(cAlias)->DA_NUMSEQ		,	Nil}}		

		aAdd(aItem,{	{"DB_ITEM"	,"001"				,	Nil}, ; 
					{"DB_PRODUTO"	,(cAlias)->DA_PRODUTO  ,	Nil}, ;  
					{"DB_ESTORNO"	,""					,	Nil}, ; 
					{"DB_LOCAL"	,(cAlias)->DA_LOCAL	,	Nil}, ; 
					{"DB_LOTECTL"	,(cAlias)->DA_LOTECTL	,	Nil}, ; 
					{"DB_NUMLOTE"	,(cAlias)->DA_NUMLOTE	,	Nil}, ; 
					{"DB_LOCALIZ"	,_cEndMov				,	Nil}, ;  
					{"DB_DATA"	,dDataEmis			,	Nil}, ;  
					{"DB_QUANT"	,(cAlias)->DA_SALDO	,	Nil}, ; 
					{"DB_NUMSERI"	,""					,	Nil}, ; 
					{"DB_NUMSEQ"	,(cAlias)->DA_NUMSEQ	,	Nil}, ; 
					{"DB_DOC"		,(cAlias)->DA_DOC		,	Nil}, ; 
					{"DB_SERIE"	,(cAlias)->DA_SERIE	,	Nil}, ; 
					{"DB_CLIFOR"	,(cAlias)->DA_CLIFOR	,	Nil}, ; 
					{"DB_LOJA"	,(cAlias)->DA_LOJA		,	Nil}})
		lMsErroAuto := .F.		
		MSExecAuto({|x,y,z| MATA265(x,y,z)},aCab,aItem,3)
		If lMsErroAuto
			aErroAuto := GetAutoGRLog()
           For nCount := 1 To Len(aErroAuto)
               FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01",aErroAuto[nCount], 0, (nStart - Seconds()), {})
           Next nCount
		EndIf
		(cAlias)->(DbSkip())
	EndDo
	
	(cAlias)->(DbCloseArea())
	RestArea(aAreaSDA)

Return
