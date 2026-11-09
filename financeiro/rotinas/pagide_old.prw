#include "rwmake.ch"

User Function PagIde()
   if SA2->A2_Tipo # "J"
      _cCgc := left(SA2->A2_CGC,9) + "0000" + substr(SA2->A2_CGC,10,2)
   else
      _cCgc := "0" + left(SA2->A2_CGC,8) + substr(SA2->A2_CGC,9,4) + right(SA2->A2_CGC,2)
   endif
Return(_cCgc)
