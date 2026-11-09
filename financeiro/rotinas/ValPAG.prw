#INCLUDE "Protheus.ch"

User Function ValPAG
local cRet := STRZERO(0,15)
	cRet := STRZERO(SE2->(E2_SALDO+E2_ACRESC-E2_DECRESC-E2_DESCONT)*100,15)
Return cRet