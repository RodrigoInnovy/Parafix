User Function MC010CUS()

Local nRet := 0
Local cProd:= PARAMIXB[1]
Local nCusPad := PARAMIXB[2]


IF TYPE ("sDtParafix") == "C"

	nRet :=  posicione("SB9",1,xFilial("SB9")+SB1->B1_COD+SB1->B1_LOCPAD+sDtParafix,"B9_CM1")
    IF NRET <= 0
    	NRET := NCUSPAD
    ENDIF
Else
   	NRET := NCUSPAD    
EndIf


Return(nRet)