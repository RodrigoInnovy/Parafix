#Include "Protheus.ch" //Biblioteca
 
/*------------------------------------------------------------------------------------------------------*
 | P.E.:  MTA650E                                                                                       |
 | Empresa: PARAFIX                                                                                     |
 | Dev.: RenanFreitas                                                                                |
 | Desc:  Antes da Exclusão da OP                                                                       |
 | Links: http://tdn.totvs.com/pages/releaseview.action?pageId=6089302                                  |
 *------------------------------------------------------------------------------------------------------*/
 
User Function MTA650E() //Chamando Ponto de Entrada
    Local aArea:=GetArea() //Armazena dados de um alias em um array, que pode ser restaurado depois com a função RestArea
    Local lRet :=.F. //Campo Lógico Retorna .T. caso a variável especificada como primeiro parâmetro exista na lista de variáveis do programa em execução.
        
        //Alert de validação
        lRet := MsgYesNo("Atenção: Se for excluido a Ordem de Produção do (PROTHEUS), então será necessário validar a exclusão da Ordem de produção na programação do (PCFACTORY).", "Deseja continuar? Leia com atenção!" )
 
    RestArea(aArea) // Restauração da área de trabalho ( aArea )
Return lRet
