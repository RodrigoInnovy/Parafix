#include "rwmake.ch"

User Function SDIGVER()           
	IF len(alltrim(SE2->E2_CODBAR)) == 47 .or. len(alltrim(SE2->E2_CODBAR)) < 43
   	cCampo := substr(SE2->E2_CODBAR,33,01)
   ELSE                                     
   	cCampo := substr(SE2->E2_CODBAR,05,01)
   ENDIF	
Return(cCampo)