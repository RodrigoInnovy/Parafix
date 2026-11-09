#INCLUDE "RWMAKE.CH"
#include "PROTHEUS.CH"

//Ponto de Entrada para bloquear a gravação do título caso as natureza possuir grupo de conta 32/33

//Ponto de entrada que informa se está sem centro de custo para grupo de contas (32 / 33) na hora de gravar o documento de entrada
/*
Contas contábeis que comecem com “33xxxx” devem ter o centro de custo que comece com “12xxxx” ou “13xxxx”;

Contas contábeis que comecem com “32xxxx” devem ter o centro de custo que comece com “11xxxx”.


Inicialmente as contas abaixo não devem ter o centro de custos como obrigatório .

Conta                   Descrição
32010104            custo dos insumos adquiridos a prazo no mercado interno
32010105            custo dos insumos adquiridos a prazo no mercado externo
32019801            custo dos bens produzidos - m.o.d.
32019802            custo dos bens produzidos
32019901            custo dos produtos vendidos
32020102            compra de mercadorias a vista no mercado interno
32020103            compra de mercadorias a vista no mercado externo
32020104            compra de mercadorias a prazo no mercado interno
32020105            compra de mercadorias a prazo no mercado externo
32020204            revenda de insumos adquiridos a prazo no mercado interno
32020205            revenda de insumos adquiridos a prazo no mercado externo

*/

USER FUNCTION FA050INC()

	Local lret := .T.
	Local ccont := SUBSTR(SED->ED_CONTA,1,2)

	if IsInCallStack('FINA677')
		lret := .T.
	else


	IF ccont $ "33,32" .AND. EMPTY(E2_CCD)  .AND. E2_RATEIO = "N" .AND. E2_MULTNAT = "2"

		MsgAlert('É necessario informar o centro de custo para gravar o título', 'Atenção')


		lret := .F.

	ELSEIF ccont $ "33" .AND. !SUBSTR(E2_CCD,1,2) $ "12,13" .AND. E2_RATEIO = "N" .AND. E2_MULTNAT = "2"

		MsgAlert('Contas contábeis que comecem com “33xxxx” devem ter o centro de custo que comece com 12xxxx ou 13xxxx', 'Atenção')

	ELSEIF ccont $ "32" .AND. !SUBSTR(E2_CCD,1,2) $ "11" .AND. E2_RATEIO = "N" .AND. E2_MULTNAT = "2"

		MsgAlert('Contas contábeis que comecem com “32xxxx” devem ter o centro de custo que comece com 11xxxx', 'Atenção')

	ENDIF
ENDIF

RETURN lret
