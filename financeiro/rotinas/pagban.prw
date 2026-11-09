#include "rwmake.ch"
//  PROGRAMA PARA SEPARAR O BANCO DO CODIGO DE BARRAS
//  CNAB BRADESCO A PAGAR (PAGFOR) - POSICOES (96-98)
User Function Pagban()
   _cBco := iif(empty(SE2->E2_CODBAR),left(SA2->A2_BANCO,3),left(SE2->E2_CODBAR,3))
//   _Ag := ""
Return(_cBco)
