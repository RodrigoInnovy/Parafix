#include "rwmake.ch"

User Function CPOLIVRE()
	IF len(alltrim(SE2->E2_CODBAR)) == 47 .or. len(alltrim(SE2->E2_CODBAR)) < 43
	   cCampo := substr(SE2->E2_CODBAR,5,5)+substr(SE2->E2_CODBAR,11,10)+substr(SE2->E2_CODBAR,22,10)
   ELSE                                     
	   cCampo := substr(SE2->E2_CODBAR,20,25)
   ENDIF	
   
Return(cCampo)
