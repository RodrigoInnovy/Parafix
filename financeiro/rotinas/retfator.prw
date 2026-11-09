#include "rwmake.ch"
// VALOR DO DOCUMENTO  DO CODIGO DE BARRA DA POSICAO 06 - 19, NO ARQUIVO E
// DA POSICAO 191 - 194, QUANDO NAO FOR CODIGO DE BARRA VAI O VALOR DO SE2
User Function RetFator()
   _cRet := ""
   if empty(left(SE2->E2_CODBAR,3))    // ??
      _cRet := "0000"	
   else        
   		if len(alltrim(SE2->E2_CODBAR)) == 44
	    	_cRet 	:= Substr(alltrim(SE2->E2_CODBAR),6,4)
	    ELSEIF len(alltrim(SE2->E2_CODBAR)) == 47
	    	_cRet  	:= Substr(alltrim(SE2->E2_CODBAR),34,4)
	    ELSE
			_cRet  	:= 	"0000"//Str( ( SE2->E2_VENCTO - Ctod("07/10/1997") ),4 )
	    ENDIF	
   endif                                                   
   IF Empty(_cRet)
	   _cRet := "0000"
   ENDIF
Return(_cRet)
