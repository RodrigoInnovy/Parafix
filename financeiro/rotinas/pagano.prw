#include "rwmake.ch"
//  PROGRAMA PARA SELECIONAR O ANO DO NOSSO NUMERO DO NUMERO CNAB QUANDO NAO
//  NAO TIVER TEM QUE SER COLOCADO "000"
User Function PagAno()
   _cRet := "000"
   if substr(SE2->E2_CODBAR,01,3) == "237"
      _nPos := iif(len(trim(SE2->E2_CODBAR))>46,26,9)
      _cRet := "0" + substr(SE2->E2_CODBAR,_nPos,2)
   endif
Return(_cRet)