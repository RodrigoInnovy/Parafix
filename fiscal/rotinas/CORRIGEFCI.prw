// Programa que des-deleta o último registro de cada produto da SA8 para corrigir o FCI
#Include "Protheus.ch"
#Include "TopConn.ch"

User Function CORRIGESA8()
Begin Transaction
	cQryUpd := " UPDATE SA8010 SET D_E_L_E_T_ = '' , R_E_C_D_E_L_ = '' Where R_E_C_N_O_ in (Select MAX(R_E_C_N_O_) as R_E_C_N_O_ FROM SA8010 Group by A8_COD) "
//Tenta executar o update
    nErro := TcSqlExec(cQryUpd)
     
    //Se houve erro, mostra a mensagem e cancela a transação
    If nErro != 0
        MsgStop("Erro na execução: "+TcSqlError(), "Atenção")
        DisarmTransaction()
	else
		MsgInfo("Correção Processada Com Sucesso!", "Fim do Processo")
    EndIf
End Transaction
Return




	
