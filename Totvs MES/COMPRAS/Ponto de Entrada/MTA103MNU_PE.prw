#Include "Protheus.ch"

/*/{Protheus.doc} MTA103MNU
//Ponto de entrada no MATA103 (Documento Entrada) para adicionar opção ao menu "Outras Acoes"
@author Evandro Simenes
@since 23/10/2017 
@version 1.0
/*/
User Function MTA103MNU() 
	aAdd(aRotina,{ "Transfere Filial", "U_TransFil()", 0 , 2, 0, .F.})	
Return