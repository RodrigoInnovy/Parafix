#INCLUDE "Eicpo150.ch"
#INCLUDE "AvPrint.ch"
#INCLUDE "Font.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

#DEFINE DLG_CHARPIX_H              15.1
#DEFINE DLG_CHARPIX_W               7.9

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AxCadCMX  º Autor ³ FERNANDO PEREIRA   º Data ³  12/03/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Corrige Fluxo de Caixa para titulos internacionais         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PARAFIX                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
**************************
User Function AxCadCMX()
**************************
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Public lALTERA     := .T.   
Public dVencReaAnt := CtoD('') 
Public nOldValor   := 0 // SE2->E2_VALOR       
Private nValDig    := 0

PRIVATE aDadosImp := Array(3)     

oDlgIFin := nTipoFin := oRadio1 := Nil
nTpFin     := 1

@ (9*DLG_CHARPIX_H),(10*DLG_CHARPIX_W) TO (17*DLG_CHARPIX_H),(45*DLG_CHARPIX_W) DIALOG oDlgIFin TITLE AnsiToOem(STR0033) //"Seleção"

@  8,10 TO 48,80 TITLE "Selecione Tipo Financeiro"

nTipoFin:=0

oRadio1 := oSend( TRadMenu(), "New", 17, 13, {"Ajusta Pagar","Ajusta Receber"},{|u| If(PCount() == 0, nTpFin, nTpFin := u)}, oDlgIFin,,,,,, .F.,, 55, 13,, .F., .T., .T. )

oSend( SButton(), "New", 18, 90,1, {|| nTipoFin:=1, oSend(oDlgIFin, "End")}, oDlgIFin, .T.,,)
oSend( SButton(), "New", 37, 90,2, {|| oSend(oDlgIFin,"End")}, oDlgIFin, .T.,,)

ACTIVATE DIALOG oDlgIFin CENTERED

IF nTpFin == 1
	AxCadastro("SE2")

ElseIF nTpFin == 2
	AxCadastro("SE1")
Endif

Return