#Include "Totvs.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} MTI650UMOP
Ponto de entrada na integração de OP para o TOTVS MES para levar a
segunda unidade de medida no XML. Parafix.

@type	User Function
@author 	João Gustavo Orsi
@since 	09/10/2017
@version P12
/*/
//-------------------------------------------------------------------
User Function MTI650UMOP()

	Local cSegum := Posicione("SB1",1,xFilial("SB1") + &(cPont+"->C2_PRODUTO"),"B1_SEGUM")
	
Return cSegUM