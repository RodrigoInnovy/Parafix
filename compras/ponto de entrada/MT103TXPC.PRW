#Include "Protheus.ch"
#Include "Totvs.ch"

User Function MT103TXPC()

	Local nTaxa  //Valor a ser adotado na taxa da moeda - aba duplicatas
	Local aArea := GetArea()

	If cuforig = "EX" .and. SC7->C7_MOEDA = 1

		msgalert("Fornecedor internacional, corrija a moeda de lançamento no pedido de Compra", "Moeda de Lancamento")

	else

		nmoedacor := SC7->C7_MOEDA

		DbSelectArea("SYE")
		SYE->(DbSetOrder(1))

		if nmoedacor = 2

			nTaxa := Posicione("SYE",1,xFilial("SYE")+dtos(SC7->C7_EMISSAO)+"US$","YE_TX_COMP")

		else

			if nmoedacor = 3

				nTaxa := Posicione("SYE",1,xFilial("SYE")+dtos(SC7->C7_EMISSAO)+"EUR","YE_VLCON_C")

			else

				nTaxa := 0

			Endif
			RestArea(aArea)
		Endif
	Endif
Return nTaxa
