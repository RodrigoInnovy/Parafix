//ponto de entrada onde nao Permite liberar um Pedido de Venda quando cliente estiver com cadastro Bloqueado.

#include "Protheus.ch"

User Function MA440VLD()

Local lRet       := .T.

IF(SA1->A1_MSBLQL = '1' .AND. C5_TIPO = 'N')
MSGALERT("Este Cliente está com cadastro bloqueado pelo nosso financeiro","Não Faturar")
lRet := .F.
ENDIF

 
Return lRet


