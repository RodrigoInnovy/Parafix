//LP 660-309 ESTORNO INVOICE A PAGAR ATUALIZADA  
#INCLUDE 'Protheus.ch'
  
User FUNCTION LP660309()
 
Local aArea              := GetArea()
Local cF1_HAWB           := ALLTRIM(SF1->F1_HAWB)
Local cW6_XTPMAT         := Posicione("SW6",1,xFilial("SW6")+cF1_HAWB,"W6_XTPMAT")
Local cContaCredito      := ''

IF cW6_XTPMAT = "1" //Estoque
cContaCredito := "11030803"
ENDIF

IF cW6_XTPMAT = "2" //Uso e consumo
cContaCredito := "11050104"
ENDIF

IF cW6_XTPMAT = "3" // Imobilizado
cContaCredito := "17040396"
ENDIF

RestArea(aArea)                                                                                                                                                                                                        
RETURN (cContaCredito)

