#include "rwmake.ch"

User Function SCNAB27()
   dbSelectArea("SEE")
   _nNumBco := val(SEE->EE_NumBco)
   _nInc    := 1
   RecLock("SEE",.f.)
   SEE->EE_NumBco := strzero(_nNumBco+_nInc,5)
   MsUnlock()
Return(SEE->EE_NumBco)