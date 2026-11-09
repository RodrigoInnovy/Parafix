#Include "Protheus.ch"

/*/{Protheus.doc} SD1140E
@author Evandro Simenes
@since 17/10/2017 
@version 1.0
/*/
User Function SD1140E() 
	Local lRet   := .T.

	If !IsInCallStack('U_QIMPNFE')
	U_QEXPEV('Documento Eliminado no Recebimento Fiscal', '1', '1', '6')
	Endif

	
	//Deleta controle de recebimento (status 1)
	U_DelCtrlRec("1")
	
Return(lRet)
