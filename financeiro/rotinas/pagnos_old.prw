#include "rwmake.ch"
// RETORNA O NOSSO NUMERO QUANDO COM VALOR NO E2_CODBAR (LD), E ZEROS QUANDO NAO
// TEM VALOR POSICAO ( 139 - 150 )
User Function PagNos()
   _cRet := replicate("0",12)
   if left(SE2->E2_CodBar,3) == "237"
      _cRet := "0" + substr(SE2->E2_CodBar,12,09) + substr(SE2->E2_CodBar,22,02)
   endif
Return(_cRet)