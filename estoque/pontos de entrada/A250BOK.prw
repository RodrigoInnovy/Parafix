#Include "Protheus.ch"

User Function A200BOK()
    Local lRet  := .T.
    Local cProd := ""

    If Type("M->G1_COD") <> "U"
        cProd := M->G1_COD
    Else
        cProd := SG1->G1_COD
    EndIf

    U_SG1MAIL(cProd)
Return lRet
