#Include "Protheus.ch"

User Function M650BUT()
	Local aArea := SC2->(GetArea())
	
	alert(SC2->C2_NUM)	
	
	RestArea(aArea)
Return