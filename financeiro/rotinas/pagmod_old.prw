#include "rwmake.ch"
//  PROGRAMA PARA INDICAR A MODALIDADE DO PAGAMENTO
//  CNAB BRADESCO A PAGAR (PAGFOR) - POSICOES (264-265)
User Function Pagmod()
   _cRet := SEA->EA_MODELO
   if empty(_cRet)
      if empty(SE2->E2_CODBAR)
         do case
            case _cRet == "05"
                 _cRet := "01"
            case _cRet == "41"
                 _cRet := "07"
         endcase
      else
         _cRet := iif(left(SE2->E2_CODBAR,1,3)=="237","30","31")
      endif
   endif
Return(_cRet)
