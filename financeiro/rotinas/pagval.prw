#include "rwmake.ch"
// VALOR DO DOCUMENTO  DO CODIGO DE BARRA DA POSICAO 06 - 19, NO ARQUIVO E
// DA POSICAO 195 - 204, QUANDO NAO FOR CODIGO DE BARRA VAI O VALOR DO SE2
User Function PagVal()
Local _cRet := ""
if empty(left(SE2->E2_CODBAR,3))    // ??
	_cRet := STRZERO(0,10)
else
	if len(alltrim(SE2->E2_CODBAR)) == 44
		_cRet 	:= Substr(alltrim(SE2->E2_CODBAR),10,10) //Valor do Documento
	ELSEIF len(alltrim(SE2->E2_CODBAR)) == 47
		_cRet  	:= Substr(alltrim(SE2->E2_CODBAR),38,10) //Valor do Documento
	ELSE
		_cRet  	:= STRZERO(0,10) //Valor do Documento
	endif
ENDIF
IF Empty(_cRet)
	_cRet := STRZERO(0,10)
ENDIF

Return(_cRet)
