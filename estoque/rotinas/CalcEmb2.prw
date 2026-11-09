#include "Protheus.ch"

User Function CalcEmb2()

Local nQtdEmb2 := M->B1_ZZQE2
Local cTipConv := M->B1_TIPCONV
Local nConv    := M->B1_CONV
Local nQtde    := 0

if cTipConv == "D" 
 nQtde := nQtdEmb2 * nConv
else
 nQtde := nQtdEmb2 / nConv
Endif

Return (nQtde)
   





