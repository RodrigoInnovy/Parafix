#Include "protheus.ch"
#Include "topconn.ch"

/*
	Programa: 	EICFI400_RDM
	Função	:	Ponto de Entrada do Programa Corrgir Taxa Titulo DI
	Data	: 	06/02/19
	Autor	:	Fernando Pereira
*/

*****************************
User Function EICFI400()
	*****************************
	Private dDtreg := IIF(!EMPTY(M->W6_DTREG_D),M->W6_DTREG_D, IIF(!Empty(M->W6_DTMANU),M->W6_DTMANU,''))


	if len(Paramixb) <> 2
		Do Case
		Case ParamIxb == "ANTES_INC_TIT_INV"
			*** Acerto vencimentos da invoice conforme MIT006
			*** Ajustar data de vencimento da invoice EIC via gatilho . Em Venc ate 1 a 15 = 10 e 16 a 31 = 23
			*********************************************************************************************************
			If Day(cDtVecto) < 16
				cMudaDia := "10"+Substr(DtoC(cDtVecto),3,10)
				cDtVecto := CtoD(cMudaDia)
			Endif
			If Day(cDtVecto) > 15
				cMudaDia := "23"+Substr(DtoC(cDtVecto),3,10)
				cDtVecto := CtoD(cMudaDia)
			Endif

			If Alltrim(FUNNAME())=="EICDI502" .and. !Empty(W6_DI_NUM)
				nTxMoeda  := SW9->W9_TX_FOB
			Endif
		EndCase
	endif

// Parametros para abertura do contas a pagar na tela OU via rotina automática 
if len(Paramixb) <> 2
	If ParamIxb == "FI400INCTIT" .OR. ParamIxb == "DEP_GRAVACAO_TIT"

		If "SWB" $ cOrigem

//If SWB->WB_TIPOREG == "P"

//M->E2_ZZHAWB := SWB->WB_HAWB
//M->E2_ZZINV := SW2->W2_NR_PRO
//M->E2_ZZCDESP := "101 - FOB INVOICE ANTECIPADA"

		ElseIf M->E2_TIPO == "INV"

			M->E2_ZZDTDI  := dDtreg //Data de Registro da DI
		EndIf
	EndIf

	If ParamIxb == "DEP_GRAVACAO_TIT"

		If "SWB_AP100" $ cOrigem

//aAdd(aTit,{"E2_ZZHAWB" ,SWB->WB_HAWB ,NIL})

		Else
			aAdd(aTit,{"E2_ZZDTDI" ,dDtreg ,NIL}) //Data de Registro da DI
		EndIf

	EndIf

	If ParamIxb == "ALTERA_SE2" .AND. !Empty(dDtreg) .AND. !Empty(SE2->E2_NUM)  //Vinicius preenche data DI no SE2_ZZDTDI
		RECLOCK("SE2",.F.)
         E2_ZZDTDI  := dDtreg
		MSUNLOCK()
	EndIf
EndIf
Return
