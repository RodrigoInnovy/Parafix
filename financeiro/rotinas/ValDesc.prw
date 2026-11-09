#INCLUDE "Protheus.ch"

User Function ValDesc()
Local cRet := STRZERO(INT(SE2->(E2_DESCONT+E2_DECRESC)*100),15)
Local nDif := Val(U_PAGVAL()) - Val(U_VALPAG())
IF nDif <= 0            
	cRet := Replicate("0",15)            
ENDIF

Return cRet