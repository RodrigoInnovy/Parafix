#include "rwmake.ch"

User Function DVNNUM()
   _nCont := 0
   _nPeso := 2
   _cDC   := "0"
   do case
      case SE1->E1_Portado == "001"  // Bradesco
           _cCarteira := '09' // Alterado por Ubiratan em 17/03/2011  era -> right(alltrim(SEE->EE_SUBCTA),2)  //"02"
           _cNNumero  := _cCarteira + right(alltrim(SE1->E1_NumBco),11)
           for _nI := 13 To 1 Step -1
               _nNum  := val(substr(_cNNumero,_nI,1))
               _nCont += _nNum * _nPeso
               if _nPeso == 7
                  _nPeso := 1
               endif
               _nPeso++
           next
           _nResto := _nCont%11
           if _nResto == 0
              _cDC := "0"
           elseif _nResto == 1
                  _cDC := "P"
           else
                  _nI  := 11 - _nResto
                  _cDC := str(_nI,1)
           endif
   endcase
Return (_cDC)
