#Include "Totvs.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} MTI650FCOP
Ponto de entrada na integração de OP para o TOTVS MES para levar o
fator de conversão da segunda unidade unidade de medida no XML. Parafix.

@type	User Function
@author 	João Gustavo Orsi
@since 	09/10/2017
@version P12
/*/
//-------------------------------------------------------------------
User Function MTI650FCOP()

	Local cTpConv := Posicione("SB1",1,xFilial("SB1") + &(cPont+"->C2_PRODUTO"),"B1_TIPCONV")
	Local nFatConv := Posicione("SB1",1,xFilial("SB1") + &(cPont+"->C2_PRODUTO"),"B1_CONV")
	
	If cTpConv == "D"
		nFatConv := 1/nFatConv
	EndIf
	
Return nFatConv