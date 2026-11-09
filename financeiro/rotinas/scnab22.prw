#include "rwmake.ch"

User Function SCNAB22()
   dbSelectArea("SEE")
   _nNumBco := val(SEE->EE_NumBco)
   _nInc    := iif(_nNumBco=0,1,2)
   RecLock("SEE",.f.)
   SEE->EE_NumBco := strzero(_nNumBco+_nInc,5)
   MsUnlock()
Return(SEE->EE_NumBco)
