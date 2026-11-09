//********************************************************************************************
// Customização Tabela de Preço SIGAEEC utilizando a tabela do SIGAFAT - vinicius 20/07/2023
//********************************************************************************************

#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

User Function TABELAEEC()

Local aArea         := GetArea()
Local aAreaEE7      := EE7->(GetArea())
Local aAreaEE8      := EE8->(GetArea())
Local cCliente	    := EE7_IMPORT
Local cLoja         := EE7_IMLOJA
Local cTabelaPreco  := posicione("SA1",1,xfilial("SA1")+cCliente+cLoja,"A1_TABELA")
Local cProduto      := EE8_COD_I
//Local cDataEmissao  := EE7_DTPROC
//Local cDataVigencia := posicione("SA1",1,xfilial("SA1")+cCliente+cLoja,"A1_TABELA")
Local nPreco        := ''
Local cQuery        := "select DA1_PRCVEN from DA1010 where D_E_L_E_T_ = '' and DA1_CODTAB = '"+cTabelaPreco+"' and DA1_CODPRO = '"+cProduto+"' and DA1_ATIVO = '1'" 
TcQuery cQuery New Alias "QRY"

dbSelectArea("QRY")

nPreco := QRY->DA1_PRCVEN
    If nPreco == 0
     MSGINFO( "Produto não possui tabela de preço ativa", "Tabela de Preço" )
    EndIF

QRY->(dbCloseArea()) //Fecha a Area de trabalho

RestArea(aAreaEE7)
RestArea(aAreaEE8)
RestArea(aArea)

Return nPreco
