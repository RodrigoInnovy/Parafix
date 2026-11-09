#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#INCLUDE "apvt100.ch"
#DEFINE cEOL CHR(13) + CHR(10)

/*/{Protheus.doc} ACD175VO
@author Evandro Simenes
@since 29/12/2017 
@version 1.0
/*/
User Function ACD175VO() 
	Private cIdVol := PARAMIXB[1]
	
	DbSelectArea("CB6")
	DbSetOrder(1)
	
	If CB6->(DbSeek(xFilial("CB6")+cIdVol))
		If CB6->CB6_STATUS == "1"
			U_AdiCtrlExp('5','Finalizado - Ok Embarcado')
		Else
			U_DelCtrlExp('5')
		EndIf
	EndIf
	
Return
