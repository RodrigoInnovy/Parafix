#Include "Protheus.ch"

/*/{Protheus.doc} MT010ALT
Ponto de Entrada MT010ALT
@type function
@author Parafix
@since 14/04/2022
/*/

User Function MT010ALT()
	If (ExistBlock("PRCOME01"))
		ExecBlock("PRCOME01", .F., .F.)
	Endif
Return()
