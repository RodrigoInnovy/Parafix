#Include 'Totvs.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} M410PVNF
Ponto de entrada para inibir o faturamento direto via pedido de vendas.

@author João Gustavo Orsi
@since 27/06/2014
@version P11

Alterações realizadas dia 13/07/2017 por João Gustavo Orsi
1 - Alterada include Protheus.ch por Totvs.ch.
/*/
//-------------------------------------------------------------------

User Function M410PVNF()

Local lRet := .F.

MSGALERT("Por favor, utilizar a rotina de documento de saída no Faturamento!","Não faturar")
 
Return lRet