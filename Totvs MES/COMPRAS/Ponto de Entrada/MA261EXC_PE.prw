#Include "Protheus.ch"

/*/{Protheus.doc} MA261EXC
Atualizações adicionais apos o estorno de uma transferencia.

@author Evandro Simenes
@since 27/10/2017 
@version 1.0
/*/
User Function MA261EXC() 
	Local lRet   := .T.
	Local aArea := GetArea()
	
	//Adiciona Status para Controle de Recebimento
	U_DelCtrlRec("4")
	
Return(lRet)