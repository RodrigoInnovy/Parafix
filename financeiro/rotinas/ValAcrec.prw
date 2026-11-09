#INCLUDE "Protheus.ch"

User Function ValAcrec()
Local cRet := STRZERO(INT(SE2->(E2_ACRESC+E2_VALJUR)*100),15)
Local nDif := Val(U_PAGVAL()) - Val(U_VALPAG())
IF nDif >= 0            
	cRet := Replicate("0",15)            
ENDIF

Return cRet