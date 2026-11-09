//Não permite cadastrar fornecedor que não pertence a ONU

#include "protheus.ch"
#include "parmtype.ch"

User Function CUSTOMERVENDOR()
Local aParam     := PARAMIXB
Local xRet       := .T.
Local oObj       := ''
Local cIdPonto   := ''
Local cIdModel   := ''
Local lIsGrid    := .F.
Local cPais      := M->A2_PAIS 

If aParam <> NIL
        oObj := aParam[1]
        cIdPonto := aParam[2]
        cIdModel := aParam[3]
        lIsGrid := (Len(aParam) > 3)

        If cIdPonto == "MODELPOS" .AND. cPais $ "199,372,187,759,744"         
            xRet := .F.
            Help(NIL, NIL, "HELP CUSTOMERVENDOR.PRW", NIL, "Não é permitido cadastradar fornecedor deste país", 1, 0, NIL, NIL, NIL, NIL, NIL, {"Falar com Dpto. Fiscal"})
       Endif      
Endif

Return xRet
