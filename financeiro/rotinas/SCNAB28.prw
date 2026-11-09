#include "rwmake.ch"

User Function SCNAB28()//Controla numeração de lote
   dbSelectArea("SEE")
   _nNumLote := val(SEE->EE_LOTECP)
   _nInc    := 1
   RecLock("SEE",.f.)
   SEE->EE_LOTECP := strzero(_nNumLote+_nInc,4)
   MsUnlock()
Return(SEE->EE_LOTECP)