#Include "Totvs.ch"

/*/{Protheus.doc} CEXMITNFE
@description 	Ponto de entrada apos carregar itens para lancar NF-e
				(Central XML)
@author 		
@version		1.0
@param			PARAMIXB
@return			ExpA[1]	- Itens da NF
@return			ExpA[2]	- Logico
@return			ExpA[3] - Mensagem caso retorno seja .F.
@type 			Function
/*/
User Function CEXMITNFE()
	Local aRetorno	:= PARAMIXB
	Local aAreaAt	:= GetArea()
	Local lRetorno	:= .T.
	Local cMensagem	:= ""
	Local nX		:= 0

	
		//Validacao do Usuario
	For nX := 1 To Len( aRetorno )
				
			if (SB1->B1_RASTRO == "L")
			
			aAdd(aRetorno[nX],{"D1_LOTECTL","P" + retPedidoItem(aRetorno,nX),Nil})
			aAdd(aRetorno[nX],{"D1_DTVALID",dDatabase + Posicione("SB1",1,xFilial("SB1") + aRetorno[nX][3][2],"B1_PRVALID"),Nil})
		
			endif
			Next nX
				
	RestArea( aAreaAt )
	
Return { aRetorno, lRetorno, cMensagem }


/*
 * Função responsável por retornar numero do pedido + item, caso exista.
 */
static function retPedidoItem(aRetorno, nX)
 	
 	local cRet 		:= ""
 	local cPedido	:= ""
 	local cItemPC	:= ""
 	
 	
 	if aScan(aRetorno[nX], {|linha| linha[1] == "D1_PEDIDO" } ) > 0
 		cPedido := aRetorno[nX][5][2]
 	endIf
 	
 	if aScan(aRetorno[nX], {|linha| linha[1] == "D1_ITEMPC" } ) > 0
 		cItemPC := aRetorno[nX][6][2]
 	endIf
 	
 	cRet := cPedido + cItemPC
 	 	
  	
 return cRet





