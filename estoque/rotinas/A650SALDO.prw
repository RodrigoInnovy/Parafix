#include "Protheus.ch"

User Function A650SALDO()

Local nSaldo := PARAMIXB // Recebe o saldo disponivel do produto em estoque

if SB1->B1_GRUPO == "2201" 
  nSaldo := 0
 elseif SB1->B1_GRUPO $ "1240,1230" 
  nSaldo := 999999999
endif

Return nSaldo

