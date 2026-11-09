#include "totvs.ch"
#include "protheus.ch"

/*
################################################
Caso a empresa possua esse fonte GFEA065 em suas customizações realizar MERGE, caso não tenha, é só compilar este fonte em seu projeto.
################################################
*/
User Function GFEA065()
Local aParam := PARAMIXB 	   

If aParam <> Nil  
	If ExistBlock("BCX065")
		ExecBlock("BCX065",.F.,.F.,aParam)
	EndIf
Endif

Return .T.  
