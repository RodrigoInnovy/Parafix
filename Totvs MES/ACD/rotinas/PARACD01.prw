#include "Totvs.ch"

/*/{Protheus.doc} PARACD01
Função para reabrir a conferência final da ordem de separação. 
Chamado atraves do ponto de entrada ACD100M
@author TOTVS IP
@since 23/05/2022
@version 1.0
@return Nil
/*/

User Function PARACD01()

	If MsgYesNo("Deseja reabrir a conferência final ?","Atenção")
//		If CB7->CB7_ZZCHEC == "2"
			RecLock("CB7",.F.)
			CB7->CB7_ZZCHEC := ""
			CB7->(MsUnlock())
			MsgInfo("Conferência reaberta com sucesso!")
//		Else
//			MsgAlert("Somente podem ser reabertas conferências bloqueadas com divergências")
//		Endif
	Else
		MsgInfo("Processo cancelado!")
	Endif

Return


