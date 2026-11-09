#Include 'Protheus.ch'
 
User Function PCPXFUNPPI()
Local lRet := .T.
If AllTrim(PARAMIXB) == "MATA175" .OR. AllTrim(PARAMIXB) == "PRACOM01" .OR. AllTrim(PARAMIXB) == "U_PRAACD01"
//Não executa a integração a partir do programa MATA175, PRACOM01, U_PRAACD01
lRet := .F.
EndIf
Return lRet
