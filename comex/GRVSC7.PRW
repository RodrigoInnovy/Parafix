#Include "Protheus.ch" 
#Include "Topconn.ch"

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Função    ³ GRVSC7      ³ Autor ³ Gustavo Buson      ³ Data ³ 12/11/2020 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição ³ PONTO DE ENTRADA PARA GRAVAÇÃO DE CAMPOS ESPECÍFICOS NO      ³±±
±±³			 ³ PEDIDO DE COMPRAS (SC7) PELA PURCHASE ORDER (SW2/SW3)        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function GRVSC7()

	Local aAreaSC7	:= SC7->(GetArea())
	Local aAreaAtu	:= GetArea()
	Local lRet     := .F.
	Local cOk      := .T.
	Local nOpcA    := 0,oDlg
	Local bOk      := {|| nOpcA := 1, oDlg:End()}
	Local bCancel  := {|| oDlg:End()}
	
	If  SC7->(!EOF()) 

		RecLock("SC7",.F.)

		SC7->C7_SEGUM 	:= SW3->W3_XUN2
		SC7->C7_QTSEGUM	:= SW3->W3_XQTUN2
		SC7->C7_PRC2UN	:= SW3->W3_XVLUN2
		SC7->C7_XTPUN   := SW3->W3_XTPUN

		SC7->(MSUnLock())

	Endif

	RestArea(aAreaSC7)
	RestArea(aAreaAtu)

Return 
