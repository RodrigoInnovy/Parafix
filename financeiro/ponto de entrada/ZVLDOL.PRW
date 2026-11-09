// Calcula valor em Dolar baixa titulos a pagar em Euro e Banco em Dolar.

#include "PROTHEUS.CH"

User Function ZVLDOL()


Local aArea             := GetArea()  
Local dDataBaixa 	    := DTOS(M->WB_CA_DT)
Local nValorDolar       := M->WB_ZVLDOL
LocaL nDolarCompra      := Posicione("SYE",1,xFilial("SYE")+dDataBaixa+"US$","YE_TX_COMP")
Local nValorReais       := nValorDolar*nDolarCompra
Local nValorEuro        := M->WB_VLIQ
Local nTaxa             := Round(nValorReais/nValorEuro,4)


RestArea(aArea)
Return nTaxa
