#include "Protheus.ch"

User Function QtdEmp01() 

Local aAreaSB1  := SB1->(GetArea())
Local nQtdSeg   := 0    

dbSelectArea("SB1")
if dbSeek(xFilial("SB1")+aCols[n][1])	
  if SB1->B1_TIPCONV == "M"
    nQtdSeg := aCols[n][4] * SB1->B1_CONV    
   else                                   
    nQtdSeg := aCols[n][4] / SB1->B1_CONV
  endif
endif

RestArea(aAreaSB1)

Return nQtdSeg
   
/*   


aCols[n][1] := TSD4->D4_COD
	aCols[nI][2] := TSD4->B1_DESC
	aCols[nI][3] := TSD4->B1_UM
	aCols[nI][4] := 0.00
	aCols[nI][5] := TSD4->B1_SEGUM
	aCols[nI][6] := 0.00
	aCols[nI][7] := .F.

*/
	