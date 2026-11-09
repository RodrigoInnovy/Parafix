#Include "Protheus.ch"


/*/{Protheus.doc} SF1140I
@author Evandro Simenes
@since 16/10/2017 
@version 1.0
/*/
User Function SF1140I() 
	Local lRet   := .T.
	Local oCtrlRec
	Local cParInc := PARAMIXB[1]
	Local aArea := GetArea()
	Local nNum := "10"
	
	if cParInc
		//Adiciona Status para Controle de Recebimento
		U_AdiCtrlRec("1","Aguardando Classificação Fiscal")
	endif


Return(lRet)
