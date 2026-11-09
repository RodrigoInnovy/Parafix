#include "rwmake.ch"

User Function SCNAB23()
   local cAux := U_SCNAB21()
   local cAux := U_SCNAB25()
   dbSelectArea("SEE")
   RecLock("SEE",.f.)
   SEE->EE_LOTECP := "0000"
   MsUnlock()
Return(space(9))