#include "rwmake.ch"
//     PROGRAMA PARA SEPARAR A AGENCIA DO CODIGO DE BARRA
//     CNAB BRADESCO A PAGAR (PAGFOR) - POSICOES (99-104)
User Function PagAgen()
   _Agencia := "00000 "
   if SEA->EA_Modelo == "31"   // titulos nao Itau
      _CodBar  := trim(SE2->E2_CODBAR)
      _cBanco  := left(_CodBar,3)
      _Ag      := ""
      if _cBanco == "001"   // BRADESCO
         _nCol    := iif(len(_CodBar)>44,5,20)
         _Agencia := u_Mod11Base7( substr(_CodBar,_nCol,4), 6)
//         _DigCon  := right(_Agencia, 1)
      endif
   endif
Return(_Agencia)