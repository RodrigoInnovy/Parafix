#include "rwmake.ch"

User Function SCNAB21()
   dbSelectArea("SEE")
   RecLock("SEE",.f.)
   SEE->EE_NumBco := "00000"
   MsUnlock()
Return(space(9))
