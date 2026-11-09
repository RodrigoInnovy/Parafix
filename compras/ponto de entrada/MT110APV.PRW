#Include "Protheus.ch"

User Function MT110APV() 

Local cParam1 := ParamIxb[1]
Local nParam2 := ParamIxb[2]
Local lRet := .F.


// Validações 
If !__cuserid $ "000000,000120,000111,000143"
		Alert("Somente o Administrador ou usuários autorizados podem executar esta rotina.")
	Return
EndIf

Return lRet
