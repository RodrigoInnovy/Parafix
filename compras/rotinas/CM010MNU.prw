#Include "Protheus.ch"

/*/{Protheus.doc} CM010MNU
   Adiciona botões na tela de Tabela de Preço
   type function
   @version 1.0
   @author Parafix
   @since 03/12/2021
   @return aRet, array
/*/

*****************************
User Function CM010MNU()
*****************************
	Local aRet 	:= {}
	aRet 		:= ParamIXB[1]
    aAdd(aRet,  {"Atualiza PC Em Aberto", "U_PFCOMA01", 0, 2, , .T.})
Return(aRet)
