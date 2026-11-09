#include "rwmake.ch"   

//  PROGRAMA PARA SEPARAR A C/C DO CODIGO DE BARRA
//  CNAB BRADESCO A PAGAR (PAGFOR) - POSICOES (105-119)
User Function PagaCta()
   if SEA->EA_Modelo == "31"   // PAGAMENTO DE TITULOS
      _CtaCed  := replicate("0",14) 
      _cDigCon := _cDigCon2 := "0"
      _cBanco  := left(SE2->E2_CODBAR,3)
      if _cBanco == "001"    // BRADESCO
         _nCol   := iif(len(trim(SE2->E2_CODBAR))>44,24,37)
         _CtaCed := u_Mod11Base7(substr(SE2->E2_CODBAR,_nCol,7),14)+" "
      endif
   endif
Return(_CtaCed)
