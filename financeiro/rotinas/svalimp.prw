#include "rwmake.ch"
User Function SVALIMP()
  	IF len(alltrim(SE2->E2_CODBAR)) == 47 
   	cCampo := substr(SE2->E2_CODBAR,34,14)
   ELSEIF len(alltrim(SE2->E2_CODBAR)) == 44               
   	cCampo := substr(SE2->E2_CODBAR,06,14)
   ELSE
   	cCampo := Str( ( SE2->E2_VENCTO - Ctod("07/10/1997") ),4 )+STRZERO((SE2->E2_SALDO*100),10)
   ENDIF	
    
Return(cCampo)
