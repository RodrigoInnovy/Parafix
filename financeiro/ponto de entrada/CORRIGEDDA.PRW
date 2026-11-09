// Programa que Corrige o codigo do Fornecedor para fazer a Varredura DDA
#Include "Protheus.ch"
#Include "TopConn.ch"

User Function CORRIGEDDA()
Begin Transaction
    cQryUpd := " UPDATE FIG010 SET FIG_FORNEC = A2_COD , FIG_LOJA = A2_LOJA FROM  dbo.FIG010 LEFT OUTER JOIN dbo.SA2010 ON SUBSTRING(FIG_CNPJ,1,10) = SUBSTRING(A2_CGC,1,10) WHERE (dbo.FIG010.FIG_FORNEC = '') and FIG_VENCTO >'20231001' and A2_COD is not null "
//Tenta executar o update
    nErro := TcSqlExec(cQryUpd)
     
    //Se houve erro, mostra a mensagem e cancela a transação
    //If nErro != 0
        //MsgStop("Erro na execução: "+TcSqlError(), "Atenção")
        //DisarmTransaction()
	//else
		//MsgInfo("Correção Processada Com Sucesso!", "Fim do Processo")
    //EndIf
End Transaction
Return
