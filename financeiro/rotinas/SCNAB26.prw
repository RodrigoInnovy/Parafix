#include "rwmake.ch"

User Function SCNAB26()
   dbSelectArea("SEE")
   _nNumReg := SEE->EE_TOTREG
   _nInc    := 1
   RecLock("SEE",.f.)
   SEE->EE_TOTREG := _nNumReg+_nInc
   MsUnlock()
Return(space(1))