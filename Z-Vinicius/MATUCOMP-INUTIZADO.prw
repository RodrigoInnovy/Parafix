#Include "Protheus.ch"

// MATUCOMP - Waldir Baldin - 25/04/2011 - PE disparado na rotina MATA926, para atualizar dados nas tabelas de complementos do SPED.
User Function MATUCOMP()
	Local cTipoNF	:= PARAMIXB[1]
	Local aAreaATU	:= GetArea()
	Local aAreaEEC	:= EEC->(GetArea())
	Local aAreaEE9	:= EE9->(GetArea())
	Local aAreaSY9	:= SY9->(GetArea())

	If cTipoNF == "S" .And. SF2->F2_EST = "EX"
		EEC->(DbSetOrder(1))		// EEC_FILIAL + EEC_PREEMB
		EE9->(DbSetOrder(1))		// EE9_FILIAL + EE9_PEDIDO + EE9_SEQUEN + EE9_PREEMB + EE9_HOUSE
		SY9->(DbSetOrder(2))		// Y9_FILIAL + Y9_SIGLA 		

		EEC->(DbSeek(xFilial("EEC") + SC5->C5_PEDEXP))
		EE9->(DbSeek(xFilial("EE9") + SC5->C5_PEDEXP))
		SY9->(DbSeek(xFilial("SY9") + EEC->EEC_ORIGEM))

		// Complementa os dados da tabela CDL
		RecLock("CDL", .T.)
			CDL->CDL_FILIAL	:= xFilial("CDL")
			CDL->CDL_DOC	:= SF2->F2_DOC
			CDL->CDL_SERIE	:= SF2->F2_SERIE
			CDL->CDL_ESPEC	:= SF2->F2_ESPECIE
			CDL->CDL_FORNEC	:= SF2->F2_CLIENTE
			CDL->CDL_CLIENT	:= SF2->F2_CLIENTE
			CDL->CDL_LOJFOR	:= SF2->F2_LOJA
			CDL->CDL_LOJA	:= SF2->F2_LOJA
			CDL->CDL_INDDOC	:= '0'
			CDL->CDL_NUMDE	:= SubStr(EE9->EE9_RE, 03, 11)
			CDL->CDL_DTDE	:= EE9->EE9_DTRE
			CDL->CDL_NATEXP	:= '0'
			CDL->CDL_NRREG	:= SubStr(EE9->EE9_RE, 03, 11)
			CDL->CDL_DTREG	:= EE9->EE9_DTRE
			CDL->CDL_CHCEMB	:= EEC->EEC_NRCONH
			CDL->CDL_DTCHC	:= EEC->EEC_DTCONH
			CDL->CDL_DTAVB	:= EE9->EE9_DTAVRB
			CDL->CDL_TPCHC	:= IIf(Alltrim(EEC->EEC_VIA) $ '01/02', '10', '01')
			CDL->CDL_PAIS	:= sa1->a1_pais//EEC->EEC_PAISDT
			CDL->CDL_UFEMB	:= SC5->C5_ZZUFEMB       //SY9->Y9_ESTADO		// SY9->Y9_SIGLA = EEC->EEC_ORIGEM
			CDL->CDL_LOCEMB:= SC5->C5_ZZLOCEM      // SY9->Y9_DESCR
		CDL->(MsUnLock())
    EndIf

	RestArea(aAreaEEC)
	RestArea(aAreaEE9)
	RestArea(aAreaSY9)
	RestArea(aAreaATU)
Return
