#INCLUDE "PROTHEUS.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FA070TIT ºAutor  ³Fernando Pereira    º Data ³  25/04/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Função para Gravar dados da baixa na tabela EEQ do modulo º±±
±±º          ³  de exportacao                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PARAFIX                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
********************************
User Function FA070TIT()
********************************
Local cAlias    := GetArea()
Local lEEQOK    := .F.

If SE1->E1_PREFIXO == "EEC" .AND. SE1->E1_MOEDA <> 1 .AND. EMPTY(SE1->E1_BAIXA)
	
	cPrefEEQ    := Space(03)
	cTipEEQ     := Space(03)
	cTitEEQ     := SE1->E1_NUM
	dEEQDtBx    := dBaixa
	cEEQ_BANC   := cBanco
	cEEQ_AGEN   := cAgencia
	cEEQ_NCON   := cConta  
	cEEQ_MOTIVO := cMotBX
	cEEQ_NOMEBC := "AJUSTE OFF-SHORE"
	nEEQ_TX     := nTxMoeda 
	nEEQ_EQVL   := nValRec            
	
	DbSelectArea("EEQ")
	DbSetOrder(12)
	lEEQOK := IIf(EEQ->(DbSeek(xfilial("EEQ")+cPrefEEQ+cTipEEQ+cTitEEQ)),.T.,.F.)
	If lEEQOK
	    Reclock("EEQ",.F.)
			EEQ->EEQ_BANC   := cEEQ_BANC
			EEQ->EEQ_AGEN   := cEEQ_AGEN
			EEQ->EEQ_NCON   := cEEQ_NCON
            EEQ->EEQ_MOTIVO := cEEQ_MOTIVO
			EEQ->EEQ_NOMEBC := cEEQ_NOMEBC
			EEQ->EEQ_OBS    := cEEQ_NOMEBC
			EEQ->EEQ_DTCE 	:= dEEQDtBx
			EEQ->EEQ_SOL	:= dEEQDtBx
			EEQ->EEQ_DTNEGO	:= dEEQDtBx
			EEQ->EEQ_PGT	:= dEEQDtBx
			EEQ->EEQ_TX     := nEEQ_TX
			EEQ->EEQ_EQVL   := nEEQ_EQVL
		MsUnlock("EEQ")
	Endif
	
Endif

RestArea(cAlias)

Return .T.