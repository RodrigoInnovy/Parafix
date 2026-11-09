#INCLUDE "PROTHEUS.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FA070TIT ºAutor  ³Fernando Pereira    º Data ³  25/04/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Função para CANCELAR dados da baixa na tabela EEQ modulo  º±±
±±º          ³  de exportacao                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PARAFIX                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
********************************
User Function FA070CAN()
********************************
Local cAlias    := GetArea()
Local lEEQOK    := .F.

If SE1->E1_PREFIXO == "EEC" .AND. SE1->E1_MOEDA <> 1
	
	cPrefEEQ    := Space(03)
	cTipEEQ     := Space(03)
	cTitEEQ     := SE1->E1_NUM
	
	DbSelectArea("EEQ")
	DbSetOrder(12)
	lEEQOK := IIf(EEQ->(DbSeek(xfilial("EEQ")+cPrefEEQ+cTipEEQ+cTitEEQ)),.T.,.F.)
	If lEEQOK
	    Reclock("EEQ",.F.)
			EEQ->EEQ_BANC   := ""
			EEQ->EEQ_AGEN   := ""
			EEQ->EEQ_NCON   := ""
            EEQ->EEQ_MOTIVO := ""
			EEQ->EEQ_NOMEBC := ""
			EEQ->EEQ_OBS    := ""
			EEQ->EEQ_DTCE 	:= CtoD("  /  /  ")
			EEQ->EEQ_SOL	:= CtoD("  /  /  ")
			EEQ->EEQ_DTNEGO	:= CtoD("  /  /  ")
			EEQ->EEQ_PGT	:= CtoD("  /  /  ")
			EEQ->EEQ_TX     := 0
			EEQ->EEQ_EQVL   := 0
		MsUnlock("EEQ")
	Endif
	
Endif

RestArea(cAlias)

Return .T.