#include "Protheus.ch"

User Function CalcEmb()

Local nQtdEmb  := M->B1_QE
Local cTipConv := M->B1_TIPCONV
Local nConv    := M->B1_CONV
Local nQtde    := 0

if cTipConv = "D" 
 nQtde := nQtdEmb / nConv
else
 nQtde := nQtdEmb * nConv
Endif

Return (nQtde)
   

