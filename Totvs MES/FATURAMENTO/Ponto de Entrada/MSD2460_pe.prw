#Include "Totvs.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} MSD2460
Ponto de entrada na gravação dos itens da nota fiscal de saída
para atualizar o campo D2_ORDSEP.

@type	User Function
@author 	João Gustavo Orsi
@since 	23/11/2017
@version P12
/*/
//-------------------------------------------------------------------
User Function MSD2460()

	SD2->D2_ORDSEP := SC9->C9_ORDSEP // Ordem de separação

Return