#INCLUDE "PROTHEUS.CH" 
// Altera forma pagamento do tittulo a pagar = 341


User Function F050ALT() 

IF LEFT(SE2->E2_CODBAR,3) == "341"

SE2->E2_FORMPAG := '30'

ENDIF

Return Nil

