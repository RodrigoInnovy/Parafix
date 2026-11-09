#include "rwmake.ch"
// VALOR DO ACRESCIMO
// DA POSICAO 235 - 249
User Function PagDesc()

Local _cRet := ""

if len(alltrim(substr(SE2->E2_CODBAR,38, 10))) < 10
	_cRet += repl("0", 10 - len(alltrim(substr(SE2->E2_CODBAR,38, 10)))) + alltrim(substr(SE2->E2_CODBAR,35))
else
	_cRet += substr(SE2->E2_CODBAR,38,10) //  valor do documento
endif
If Val(_cRet) > 0
	_cRet := strZero(Val(_cRet) - SE2->(E2_SALDO+E2_ACRESC-E2_DECRESC) * 100, 15, 0)
Else
    _cRet := strZero(SE2->E2_DECRESC * 100, 15, 0)
EndIf
If val(_cRet) < 0
   _cRet := repl("0", 15)
EndIf   
Return(_cRet)
