#Include "Protheus.ch"
//retorna nome do fornecedor para a rotina de liberação de pedidos de compras

User Function RETA2NOME()
	Local aArea := GetArea()
	Local aAreaSCR := SCR->(GetArea())
	Local aAreaSC7 := SC7->(GetArea())
	Local aAreaSA2 := SA2->(GetArea())
	Local cRet := ""
	Local cPedido := PadR(SCR->CR_NUM, TamSX3("C7_NUM")[1])
	Local cFornece := Posicione("SC7", 1, xFilial("SC7") + cPedido, "C7_FORNECE")
	Local cLoja := Posicione("SC7", 1, xFilial("SC7") + cPedido, "C7_LOJA")

	IF SCR->CR_TIPO ='PC'
	cRet := Posicione("SA2", 1, xFilial("SA2") + cFornece + cLoja, "A2_NOME")
	Endif


	RestArea(aAreaSA2)
	RestArea(aAreaSC7)
	RestArea(aAreaSCR)
	RestArea(aArea)
Return(cRet)
