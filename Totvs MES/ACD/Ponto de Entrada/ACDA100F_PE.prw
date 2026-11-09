#INCLUDE "Protheus.ch"    
#INCLUDE "rwmake.ch"
#Include "prtopdef.ch"

User Function ACDA100F()
	Local aArea := GetArea()
	Local cOrdens := PARAMIXB[1] 
	
	U_AdiCtrlExp('1','Aguardando Separação',"0","0",cOrdens);
	
	RestArea(aArea)
return
