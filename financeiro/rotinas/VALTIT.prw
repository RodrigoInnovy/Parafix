#Include "Protheus.ch"


//*****************************************************************************************  
//* Função : VALTIT
//* Objetivo : Retorno o valor do titulo para o CNAB
//* Autor    : Patrick Araujo - 28/11/2018
//*****************************************************************************************

User Function VALTIT()

Local cReturn := ""

cReturn := STRZERO(SE1->(E1_SALDO+E1_ACRESC-E1_DECRESC-E1_PIS-E1_COFINS)*100,13)        

Return(cReturn)