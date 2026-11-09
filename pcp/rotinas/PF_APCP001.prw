#INCLUDE 'TOTVS.CH'

/*
_____________________________________________________________________________________________
Programa : APCP001                        Autor: Thiago Copacheski          Data : 28/11/2022
_____________________________________________________________________________________________
Descricao: Rotina de reprocessamento de OPs para integração com o Preactor

Chamado..: 
___________________________________________________________________________________________
Uso      : PCP
_____________________________________________________________________________________________
Alteração:    									 					Data : 
Descrição: 
Chamado  : 
_____________________________________________________________________________________________
*/

user function APCP001

	local cSemaforo
	local cAlias

	cSemaforo := 'APCP001'
	if MayIUseCode(cSemaforo)

		if MsgYesNo('Confirma o reprocessamento das OPs?', 'Confirmação')

			DbSelectArea('SZA')
			DbSelectArea('SZB')
			DbSelectArea('SZC')
			DbSelectArea('SC2')
			DbSelectArea('SB5')

			if TCSQLExec('DELETE FROM ' + RetSQLName('SZA')) < 0
				MsgAlert('Erro na limpeza da tabela SZA!', 'Erro')
				return
			endif

			if TCSQLExec('DELETE FROM ' + RetSQLName('SZB')) < 0
				MsgAlert('Erro na limpeza da tabela SZB!', 'Erro')
				return
			endif

			if TCSQLExec('DELETE FROM ' + RetSQLName('SZC')) < 0
				MsgAlert('Erro na limpeza da tabela SZC!', 'Erro')
				return
			endif

			cAlias	:= GetNextAlias()

			FWMsgRun(,{|| processaOP(cAlias) },"Reprocessando OPs..."			,"Reprocessando OPs..."			)
			FWMsgRun(,{|| processaEM(cAlias) },"Reprocessando Empenhos..."		,"Reprocessando Empenhos..."	)
			FWMsgRun(,{|| processaAP(cAlias) },"Reprocessando Apontamentos..."	,"Reprocessando Apontamentos...")

		endif

	else

		Alert('Reprocessamento de OPs já em execução')

	endif

return

//********************************************************************************//

static function processaAP(cAAlias)

	local nQtdProd	:= 0
	local nSaldo	:= 0
	local cOpAnt	:= ''

	BeginSql Alias cAAlias

		SELECT ZA_OPORIGI, ZA_OP, ZA_QUANT, ZA_QTDORIG, C2_QUJE 

		FROM %Table:SZA% SZA 

		INNER JOIN %Table:SC2% SC2
		ON	C2_FILIAL					= ZA_FILIAL
		AND (C2_NUM+C2_ITEM+C2_SEQUEN)	= ZA_OPORIGI
		AND SC2.%NotDel%

		WHERE 	ZA_FILIAL = %xFilial:SZA%
		AND 	SZA.%NotDel%

		ORDER BY ZA_OPORIGI, ZA_OP

	EndSql

	SZC->(DbSetOrder(1))

	while !(cAAlias)->(Eof())

		if cOpAnt <> (cAAlias)->ZA_OPORIGI
			cOpAnt 		:= (cAAlias)->ZA_OPORIGI
			nQtdProd	:= (cAAlias)->C2_QUJE
		endif

		nSaldo		:= (cAAlias)->ZA_QUANT

		if nQtdProd > 0
			nSaldo 		:= iif(nQtdProd > (cAAlias)->ZA_QUANT, 0, (cAAlias)->ZA_QUANT - nQtdProd)
			nQtdProd	-= (cAAlias)->ZA_QUANT - nSaldo
		endif

		if nSaldo <= 0 .OR. (nSaldo > 0 .AND. nSaldo < (cAAlias)->ZA_QUANT)

			RecLock('SZC', .T.)
			SZC->ZC_FILIAL		:= xFilial('SZC')
			SZC->ZC_OPORIGI		:= (cAAlias)->ZA_OPORIGI
			SZC->ZC_OPFILHA		:= (cAAlias)->ZA_OP
			SZC->ZC_OPERNUM		:= '10'
			SZC->ZC_QTDORIG		:= (cAAlias)->ZA_QTDORIG
			SZC->ZC_QTDFILH		:= (cAAlias)->ZA_QUANT
			SZC->ZC_SALFILH		:= nSaldo

			if nSaldo <= 0
				SZC->ZC_STATUS	:= 'T'
				SZC->ZC_PROGRES	:= 'Operação Finalizada'
				SZC->ZC_TEMPORE	:= 'Sim'
			else
				SZC->ZC_STATUS	:= 'A'
				SZC->ZC_PROGRES	:= 'Executando'
				SZC->ZC_TEMPORE	:= 'Sim'
			endif

			SZC->(MsUnlock())
		
		endif

		(cAAlias)->(DBSkip())
	enddo

	(cAAlias)->(DBCloseArea())

return

//********************************************************************************//

static function processaEM(cAAlias)

	local cOpAnt := ''

	BeginSql Alias cAAlias

		SELECT ZA_OP, 		
		C2_PRODUTO, 
		H1_ZDESCOP,
		G2_OPERAC,
		D4_COD,
		ROUND(SD4.D4_QTDEORI/SC2.C2_QUANT, 6) D4_QTDEORI

		FROM %Table:SZA% SZA

		INNER JOIN %Table:SD4% SD4
		ON	D4_FILIAL = ZA_FILIAL
		AND D4_OP	  = ZA_OPORIGI
		AND D4_COD		NOT LIKE 'MOD%'
		AND SD4.%NotDel%

		INNER JOIN %Table:SC2% SC2
		ON	C2_FILIAL	= D4_FILIAL
		AND (C2_NUM+C2_ITEM+C2_SEQUEN) = D4_OP
		AND SC2.%NotDel%

		INNER JOIN %Table:SB1% SB1
		ON	B1_FILIAL = %xFilial:SB1%
		AND B1_COD = C2_PRODUTO
		AND SB1.%NotDel%

		INNER JOIN %Table:SG2% SG2
		ON	G2_FILIAL  = C2_FILIAL
		AND	G2_PRODUTO = C2_PRODUTO
		AND G2_CODIGO  = '01'
		//13/01/2023 - Por solicitação do João Marcos ajustado para considerar o recurso 000413 na integração
		//AND G2_RECURSO NOT IN ('000413', '000400', '000472', '000480')
		AND G2_RECURSO NOT IN ('000400', '000472', '000480')
		AND SG2.%NotDel%

		INNER JOIN %Table:SH1% SH1 
		ON H1_FILIAL = G2_FILIAL
		AND H1_CODIGO = G2_RECURSO 
		AND SH1.%NotDel%

		WHERE ZA_FILIAL = %xFilial:SZA%
		AND SZA.%NotDel%

		ORDER BY ZA_OP, D4_COD

	EndSql

	SZB->(DbSetOrder(1))

	while !(cAAlias)->(Eof())

		if cOpAnt == (cAAlias)->(ZA_OP+D4_COD)
			(cAAlias)->(DBSkip())
			loop
		endif
		cOpAnt := (cAAlias)->(ZA_OP+D4_COD)

		RecLock('SZB', .T.)
		SZB->ZB_FILIAL 	:= xFilial('SZB')
		SZB->ZB_OP     	:= (cAAlias)->ZA_OP
		SZB->ZB_PRODUTO	:= (cAAlias)->C2_PRODUTO
		SZB->ZB_OPERNOM	:= (cAAlias)->H1_ZDESCOP
		SZB->ZB_OPERNUM	:= (cAAlias)->G2_OPERAC
		SZB->ZB_COMPONE	:= (cAAlias)->D4_COD
		SZB->ZB_QTDCOMP	:= (cAAlias)->D4_QTDEORI
		SZB->(MsUnlock())

		(cAAlias)->(DBSkip())
	enddo

	(cAAlias)->(DBCloseArea())

return

//********************************************************************************//

static function processaOP(cAAlias)

	local nInd
	local nQtdSomaOP
	local aPlanCorte	:= {}
	local nPlanCorte	:= 0
	local nConPlaCor	:= 0
	local nPos
	local dDataIni		:= Date() - 30
	local nM2_FitJum	:= 0
	local nNum_Rolos	:= 0
	local nNum_Ordem	:= 0
	local nLargura		:= 0
	local nComprim		:= 0

	BeginSql Alias cAAlias
        COLUMN C2_DATPRF AS DATE

		//** Consulta retorna fitas e automotivo
		SELECT 
		C2_TPOP, 
		C2_NUM+C2_ITEM+C2_SEQUEN AS C2_NUM,
		C2_PRODUTO, 
		'' PRIORIDADE, 
		C2_DATPRF, 
		C2_QUANT, 
		C2_ZCASADA CASADA, 
		IIF(C2_ZCASADA='1',C2_ZOPAGR,(C2_NUM+C2_ITEM+C2_SEQUEN)) GRUPO_OP,
		C2_ZNFAIXA NR_FAIXA, 
		'' CLIENTE, 
		'' PEDIDO,
		B5_LARG,
		B5_COMPR,
		C2_RECURSO,
		H1_DESCRI
		
		FROM %Table:SC2% SC2

		INNER JOIN %Table:SB5% SB5
		ON	B5_FILIAL	= %xFilial:SB5%
		AND	B5_COD		=	C2_PRODUTO
		AND SB5.%NotDel%

		LEFT JOIN %Table:SH1% SH1 
		ON 	H1_FILIAL = %xFilial:SH1%
		AND H1_CODIGO = C2_RECURSO 
		AND SH1.%NotDel%

		WHERE	C2_FILIAL	= 	%xFilial:SC2%
		AND 	C2_DATRF 	=	' '
		//13/01/2023 - Por solicitação do João Marcos ajustado para considerar o recurso 000413 na integração
		//AND 	C2_RECURSO  <> 	'000413' //Recurso Formulação		
		AND 	C2_DATPRF 	>=	%Exp:dDataIni%		
		AND 	C2_QUJE 	<	C2_QUANT
		AND 	SC2.%NotDel%
	EndSql

	SZA->(DbSetOrder(1))
		
	SC2->(DbSetOrder(1))
	SB5->(DbSetOrder(1))

	while !(cAAlias)->(Eof())

		//Verifica se a OP já foi processada
		if SZA->(dbSeek(xFilial('SZA')+(cAAlias)->C2_NUM))
			(cAAlias)->(DBSkip())
			loop
		endif

		nM2_FitJum	:= 0
		nNum_Rolos	:= 0
		nNum_Ordem	:= 0

		nLargura	:= (cAAlias)->B5_LARG
		nComprim	:= (cAAlias)->B5_COMPR
		
		//MAQUINA NW290
		if (cAAlias)->C2_RECURSO == '000401' .AND. (cAAlias)->CASADA == '1' .AND. !Empty((cAAlias)->GRUPO_OP) .AND. AllTrim((cAAlias)->GRUPO_OP) <> AllTrim((cAAlias)->C2_NUM) 
			if SC2->(DBSeek(xFilial('SC2')+(cAAlias)->GRUPO_OP)) .AND. SB5->(DBSeek(xFilial('SB5')+SC2->C2_PRODUTO))
				nComprim	:= SB5->B5_COMPR
			endif
		endif


		nM2_FitJum	:= Round((nLargura*nComprim)/1000,2)
		if nM2_FitJum > 0
			nNum_Rolos	:= Round((cAAlias)->C2_QUANT / nM2_FitJum, 0)
			
			if !Empty((cAAlias)->NR_FAIXA)
				nNum_Ordem	:= Round(nNum_Rolos / (cAAlias)->NR_FAIXA, 0)
			endif
		endif


		nPlanCorte := 0
		if (cAAlias)->CASADA == '1' .AND. !Empty((cAAlias)->GRUPO_OP)

			nPos := aScan(aPlanCorte,{|X| X[1] == (cAAlias)->GRUPO_OP})
			if nPos <= 0
				nConPlaCor	+= 1
				nPlanCorte	:= nConPlaCor
				aAdd(aPlanCorte,{(cAAlias)->GRUPO_OP,nConPlaCor})
			else
				nPlanCorte := aPlanCorte[nPos,2]
			endif

		endif

		if reprocessa(cAAlias,nM2_FitJum,nNum_Ordem)

			nQtdSomaOP := 0

			for nInd := 1 to nNum_Ordem

				RecLock('SZA', .T.)
				SZA->ZA_FILIAL  := xFilial('SZA')
				SZA->ZA_TPOP    := (cAAlias)->C2_TPOP
				SZA->ZA_OP      := somaStr((cAAlias)->C2_NUM, CValToChar(nQtdSomaOP))
				SZA->ZA_PRODUTO := (cAAlias)->C2_PRODUTO
				SZA->ZA_PRIORID := (cAAlias)->PRIORIDADE
				SZA->ZA_DATPRF  := (cAAlias)->C2_DATPRF
				SZA->ZA_QUANT   := Ceiling((nM2_FitJum * (cAAlias)->NR_FAIXA) * 100) / 100
				SZA->ZA_QTDORIG := (cAAlias)->C2_QUANT
				SZA->ZA_ZCASADA := (cAAlias)->CASADA
				SZA->ZA_ZOPAGR  := somaStr((cAAlias)->GRUPO_OP, CValToChar(nQtdSomaOP))
				SZA->ZA_ZNFAIXA := (cAAlias)->NR_FAIXA
				SZA->ZA_CLIENTE := (cAAlias)->CLIENTE
				SZA->ZA_PEDIDO  := (cAAlias)->PEDIDO
				SZA->ZA_M2PROD  := nM2_FitJum
				SZA->ZA_NUMROLO := nNum_Rolos
				SZA->ZA_NUMORDE := nNum_Ordem
				SZA->ZA_PLACORT := ''
				if nPlanCorte > 0
					SZA->ZA_PLACORT := PadL(nPlanCorte,3,'0')
				endif
				SZA->ZA_OPORIGI := (cAAlias)->C2_NUM
				SZA->ZA_RECURSO := (cAAlias)->C2_RECURSO
				SZA->ZA_RECNOME := (cAAlias)->H1_DESCRI
				SZA->(MsUnlock())

				nQtdSomaOP += 1

			next


		else

			RecLock('SZA', .T.)
			SZA->ZA_FILIAL  := xFilial('SZA')
			SZA->ZA_TPOP    := (cAAlias)->C2_TPOP
			SZA->ZA_OP      := (cAAlias)->C2_NUM
			SZA->ZA_PRODUTO := (cAAlias)->C2_PRODUTO
			SZA->ZA_PRIORID := (cAAlias)->PRIORIDADE
			SZA->ZA_DATPRF  := (cAAlias)->C2_DATPRF
			SZA->ZA_QUANT   := (cAAlias)->C2_QUANT
			SZA->ZA_QTDORIG := (cAAlias)->C2_QUANT
			SZA->ZA_ZCASADA := (cAAlias)->CASADA
			SZA->ZA_ZOPAGR  := (cAAlias)->GRUPO_OP
			SZA->ZA_ZNFAIXA := iif((cAAlias)->NR_FAIXA > 0,(cAAlias)->NR_FAIXA, 1)
			SZA->ZA_CLIENTE := (cAAlias)->CLIENTE
			SZA->ZA_PEDIDO  := (cAAlias)->PEDIDO
			SZA->ZA_M2PROD  := nM2_FitJum
			SZA->ZA_NUMROLO := nNum_Rolos
			SZA->ZA_NUMORDE := nNum_Ordem
			SZA->ZA_PLACORT := ''
			if nPlanCorte > 0
				SZA->ZA_PLACORT := PadL(nPlanCorte,3,'0')
			endif
			SZA->ZA_OPORIGI := (cAAlias)->C2_NUM
			SZA->ZA_RECURSO := (cAAlias)->C2_RECURSO
			SZA->ZA_RECNOME := (cAAlias)->H1_DESCRI
			SZA->(MsUnlock())

		endif

		(cAAlias)->(DBSkip())
	enddo

	(cAAlias)->(DBCloseArea())

return

//********************************************************************************//

static function reprocessa(cAAlias,nAM2_FitJum,nANum_Ordem)

	local lRet := .F.

	static aRec := {}

	if Empty(aRec)
		aAdd(aRec, {'000401', 'MAQUINA NW290'   })
		aAdd(aRec, {'000412', 'COATER II'       })
		aAdd(aRec, {'000422', 'CORTADEIRA II'   })
		aAdd(aRec, {'000423', 'CORTADEIRA III'  })
		aAdd(aRec, {'000424', 'CORTADEIRA IV'   })
		aAdd(aRec, {'000425', 'CORTADEIRA V'    })
		aAdd(aRec, {'000426', 'CORTADEIRA VI'   })
	endif

	if      aScan(aRec,{|X| X[1] == (cAAlias)->C2_RECURSO}) > 0	.AND. ;
			nANum_Ordem > 1                    					.AND. ;
			nAM2_FitJum > 0                 					.AND. ;
			(cAAlias)->NR_FAIXA > 0

		lRet := .T.

	endif

return lRet

//********************************************************************************//

// Função para testes
user function APCP001X

	RPCSetEnv('01', '01', Nil, Nil, Nil, GetEnvServer())

	U_APCP001()

	RPCClearEnv()

return
