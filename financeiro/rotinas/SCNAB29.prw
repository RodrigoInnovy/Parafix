#include "rwmake.ch"

User Function SCNAB29()//Controla numeração de lote
   dbSelectArea("SEE")
   RecLock("SEE",.f.)
   SEE->EE_LOTECP := strzero(0,4)
   MsUnlock()
Return(Space(1))