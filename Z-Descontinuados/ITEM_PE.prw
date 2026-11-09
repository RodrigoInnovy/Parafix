#Include "Protheus.ch"
#include "parmtype.ch"
#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"

/*/{Protheus.doc} ITEM
@author Gustavo Buson
@since 06/11/2020
@version 1.0 
@type function 
@obs Deixar o nome do prw como: ITEM_PE.prw 
/*/

User Function ITEM()

	Local aParam    := PARAMIXB
	Local xRet      := .T.
	Local oObj      := Nil
	Local cIdPonto  := ""
	Local cIdModel  := ""
	local oView     := nil

	If aParam <> NIL
		oObj        := aParam[1]
		cIdPonto    := aParam[2]
		cIdModel    := aParam[3]
		lIsGrid     := (Len(aParam) > 3) //se maior que 3, significa que é um grid.
		cOper       := oObj:GetOperation()    //Armazena o tipo de operação que está sendo efetuada.
	endif

	If cIdPonto == "FORMPRE" .and. cIdModel == "SB1MASTER"
		If FwIsInCallStack("A010COPIA")
			oObj:LoadValue("B1_VM_I"   , "")
			oObj:LoadValue("B1_VM_GI"   , "")
			oObj:LoadValue("B1_IMPORT"  , "")
			M->B1_IMPORT    := ""
			M->B1_VM_I      := ""
			M->B1_VM_GI     := ""
					
		endif

	elseif cIdPonto == "BUTTONBAR"
		oView := FwViewActive()
		if valtype(oView) == "O"
			oView:refresh()			
		endif
		
	EndIf

Return xRet
