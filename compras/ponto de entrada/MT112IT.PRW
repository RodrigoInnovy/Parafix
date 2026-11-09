#include "Protheus.ch"

//leva a segunda unidade de medida da solicitação de compras para a solicitação de importação

User Function MT112IT() 
 
 Local aArea          := GetArea()
 Local aAreaSW1       := SW1->(GetArea())
 Local aAreaSC1       := SC1->(GetArea())

 
  DbSelectArea("SW1")


  RecLock("SW1", .F.)
     SW1->W1_XUN1   := SC1->C1_UM
     SW1->W1_XUN2   := SC1->C1_SEGUM
     SW1->W1_XQTUN2 := SC1->C1_QTSEGUM
     SW1->W1_ZOBS   := SC1->C1_OBS
  SW1->(MsUnlock())
    
 RestArea(aArea)

Return
