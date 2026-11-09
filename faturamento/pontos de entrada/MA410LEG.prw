#include "Protheus.ch"

/*
*	PE do pedido de venda para alteração da legenda: Previsto
*
*/    

User Function MA410LEG()

Local aLegenda := aClone(ParamIXB)

aAdd(aLegenda, {'BR_PINK' , "Pedido de Venda Previsto" })

Return (aLegenda) 