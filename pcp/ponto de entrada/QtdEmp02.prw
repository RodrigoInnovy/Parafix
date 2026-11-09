#include "Protheus.ch"

User Function QtdEmp02()

Local aAreaSB1  := SB1->(GetArea())            
Local nQuant    := 0

dbSelectArea("SB1")
if dbSeek(xFilial("SB1")+aCols[n][1])
	if SB1->B1_TIPCONV == "M"
		nQuant := aCols[n][6] / SB1->B1_CONV
	else
		nQuant := aCols[n][6] * SB1->B1_CONV
	endif
endif

Return nQuant

