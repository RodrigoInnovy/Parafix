// Ponto de entrada que preecnhe a Mensagem no Pedido de compras conforme cadastro do Fornecedor.
// Ponto de entrada que preecnhe a o Tipo do Frete no Pedido de compras conforme cadastro do Fornecedor C7_TPFRETE.
#Include "Protheus.ch"

User Function RETA2MENSAGE()
	Local aArea := GetArea()
	Local aAreaSC7 := SC7->(GetArea())
	Local aAreaSA2 := SA2->(GetArea())
	Local lRet := .T.
	Local cFornece := cA120Forn
	Local cLoja := cA120Loj
	Local cFrete := Posicione("SA2", 1, xFilial("SA2") + cFornece + cLoja, "A2_ZINCOTE")

	cMsg 	 := Posicione("SA2", 1, xFilial("SA2") + cFornece + cLoja, "A2_ZMENSAG")
	cTpFrete :=  If(cFrete=="CIF","C-CIF",If(cFrete=="FOB","F-FOB",""))

	RestArea(aAreaSA2)
	RestArea(aAreaSC7)
	RestArea(aArea)
Return(lRet)
