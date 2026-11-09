#Include 'Totvs.ch'

/*/{Protheus.doc} ACD100M
Cria botão no ações relacionadas da rotina de geração da Ordem de Separação
@author TOTVS IP
@since 23/05/2022
@version 1.0
@return Nil
/*/

User Function ACD100M()

	aAdd(aRotina,{"Liberar Conf.","U_PARACD01()",  0,3})

Return
