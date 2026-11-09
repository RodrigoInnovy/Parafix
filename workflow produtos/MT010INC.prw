#Include "Protheus.ch"

/*/{Protheus.doc} MT010INC
Ponto de Entrada MT010INC
@type function
@author Parafix
@since 14/04/2022
/*/

User Function MT010INC()
    If (ExistBlock("PRCOME01"))
        ExecBlock("PRCOME01", .F., .F.)
    Endif
Return()
