#include "rwmake.ch"

User Function SCNAB25()
   dbSelectArea("SEE")
   RecLock("SEE",.f.)
   SEE->EE_TOTREG := 0
   MsUnlock()
Return(space(9))