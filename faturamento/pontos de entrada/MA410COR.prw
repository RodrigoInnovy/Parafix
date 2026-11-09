#include "Protheus.ch"

/*
*	PE do pedido de venda para alteração das Cores: Previsto
*
*/ 
       
User Function MA410COR()  

Local aCores := {}

aCores := ParamIXB 

aAdd(aCores, {"C5_ZZPRNM == 'P'", 'BR_PINK'  , "Previsto"})
aAdd(aCores, {"C5_ZZPRNM == 'N'", 'BR_MARROM', "Normal"  })

Return (aCores)