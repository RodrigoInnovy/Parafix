#INCLUDE "RWMAKE.CH"
#include "PROTHEUS.CH"

///Ponto de Entrada para bloquear a gravação do título caso as natureza possuir grupo de conta 32/33

//Ponto de entrada que informa se está sem centro de custo para grupo de contas (32 / 33) na hora de gravar o documento de entrada
/*
Contas contábeis que comecem com 33xxxx devem ter o centro de custo que comece com 12xxxx ou 13xxxx

Contas contábeis que comecem com 32xxxx devem ter o centro de custo que comece com 11xxxx.

*/

USER FUNCTION F100TOK()

	Local lret := .T.
	Local ccont := SUBSTR(SE5->E5_DEBITO,1,2)

	


	IF ccont $ "33,32" .AND. EMPTY(E5_CCD)

		MsgAlert('É necessario informar o centro de custo para gravar o movimento bancario', 'Atenção')
	ENDIF

	//MsgAlert('passou aqui', 'Atenção')

/*
		//lret := .F.

	ELSEIF ccont $ "33" .AND. !SUBSTR(E5_CCD,1,2) $ "12,13"

		MsgAlert('Contas contabeis que comecem com 33xxxx devem ter o centro de custo que comece com 12xxxx ou 13xxxx', 'Atenção')

	ELSEIF ccont $ "32" .AND. !SUBSTR(E2_CCD,1,2) $ "11"

		MsgAlert('Contas contabeis que comecem com 32xxxx devem ter o centro de custo que comece com 11xxxx', 'Atenção')

	ENDIF
*/
RETURN lret

