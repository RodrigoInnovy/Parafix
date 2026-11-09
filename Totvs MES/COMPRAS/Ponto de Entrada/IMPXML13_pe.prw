#Include "Totvs.ch"

#DEFINE COLUNA_VALOR_CAMPO 2

#DEFINE CAMPO_CODPROD 2
#DEFINE CAMPO_PEDIDO  3
#DEFINE CAMPO_ITEMPED 4
#DEFINE CAMPO_LOCAL   9

//-------------------------------------------------------------------
/*/{Protheus.doc} IMPXML13
Ponto de entrada para gerar código do lote na importação do XML.

@author João Gustavo Orsi
@since 10/11/2017
@version P12
/*/
//-------------------------------------------------------------------
User Function IMPXML13()
	
	Local aArea := SB1->(GetArea())
	Local aRet 	:= xAutoItens
	Local nX		:= 0
	For nX := 1 to Len(aRet)
		aAdd(aRet[nX],{"D1_LOTECTL",retPedidoItem(aRet,nX),Nil})
		aAdd(aRet[nX],{"D1_DTVALID",retValid( aRet[nX][CAMPO_CODPROD][COLUNA_VALOR_CAMPO]),Nil})
		//If !(Posicione("SB1",1,xFilial("SB1") + aRet[nX][CAMPO_CODPROD][COLUNA_VALOR_CAMPO],"B1_TIPO") $ "PA/PI") 
			//aRet[nX][CAMPO_LOCAL][COLUNA_VALOR_CAMPO] := " "  
		//EndIf
	Next nI
	
	RestArea(aArea)
	
Return aRet

/*
 * Função responsável por retornar numero do pedido + item, caso exista.
 */
 static function retPedidoItem(aRet, nX)
 	
 	local cRet 		:= ""
 	local cPedido	:= ""
 	local cItemPC	:= ""
 	
 	if aScan(aRet[nX], {|linha| linha[1] == "D1_PEDIDO" } ) > 0
 		cPedido := aRet[nX][CAMPO_PEDIDO][COLUNA_VALOR_CAMPO] 
 	endIf
 	
 	if aScan(aRet[nX], {|linha| linha[1] == "D1_ITEMPC" } ) > 0
 		cItemPC := aRet[nX][CAMPO_ITEMPED][COLUNA_VALOR_CAMPO]
 	endIf
 	
 	cRet := retlote(cPedido,cItemPC)//cPedido + cItemPC
 	
 return cRet

 /*/{Protheus.doc} retlote
	 (long_description)
	 @type  Static Function
	 @author user
	 @since 13/08/2021
	 @version version
	 @param param_name, param_type, param_descr
	 @return return_var, return_type, return_description
	 @example
	 (examples)
	 @see (links_or_references)
 /*/
 Static Function retlote(_cPedido,_cItemPc)
 Local cRet
	 cRet := "P"+_cPedido + _cItemPc
 Return cRet

 /*/{Protheus.doc} retValid
	 (long_description)
	 @type  Static Function
	 @author user
	 @since 13/08/2021
	 @version version
	 @param param_name, param_type, param_descr
	 @return return_var, return_type, return_description
	 @example
	 (examples)
	 @see (links_or_references)
 /*/
 Static Function retValid(_cProd)
 Local _nPrzVal:= Posicione("SB1",1,xFilial("SB1") + _cProd,"B1_PRVALID")
 Local _dRet:= dDatabase + _nPrzVal
	 
 Return _dRet
