#include "Totvs.ch"
#include "Apvt100.ch"
#Include "prtopdef.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} CBRETEAN
Ponto de entrada na leitura da etiqueta de produto (natural) para 
tratar quebra das informações do código de barras. PARAFIX.
Código de barras do %001PRODUTO%010LOTE%030QTD

@type	User Function
@author 	João Gustavo Orsi
@since 	02/10/2017
@version P12
/*/
//-------------------------------------------------------------------
User Function CBRETEAN()

	Local aArea 		:= GetArea()	
	Local cAuxEti		:= AllTrim(PARAMIXB[1]) // Conteúdo lido
	Local cProduto	:= Posicione("SB1",5,xFilial("SB1") + Alltrim(SubStr(cAuxEti,5,10)),"B1_COD") // Produto
	Local cLote		:= AllTrim(SubStr(cAuxEti,19,11)) // Lote
	Local dVenc		:= Posicione("SB8",2,xFilial("SB8") + Space(TamSx3("B8_NUMLOTE")[1]) + cLote + cProduto,"B8_DTVALID") // Validade
	Local nQuant		:= Val(SubStr(cAuxEti,34,Len(cAuxEti))) // Quantidade
	Local aRet		:= {cProduto,nQuant,cLote,dVenc," "} // Array de retorno

	RestArea(aArea)

Return(aRet)
