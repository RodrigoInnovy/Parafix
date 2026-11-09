#Include "Protheus.ch"

/*/{Protheus.doc} A175GRV
@author Evandro Simenes
@since 17/10/2017 
@version 1.0
/*/
User Function A175GRV() 
	Local oCtrlRec
	Local aArea := GetArea()
	if lEstorno
		//Deleta Status do Controle de Recebimento
		U_DelCtrlRec("3")
	else
		//Adiciona Status para Controle de Recebimento
		U_AdiCtrlRec("3","Aguardando Fracionamento")
	endif
Return