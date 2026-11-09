#INCLUDE "PROTHEUS.CH"
 
User Function SPDFIS27()
    Local cConta := ""
    Local cReg := PARAMIXB[1]
    Local cFilial := "" // Filial
 
    // Para registros de nota
    Local cTpMovto := "" //Entrada ou saída?
    Local cSerie := "" //Série da nota fiscal
    Local cNotaFisc := "" //Código da nota fiscal
    Local cClieFor := "" //Código do Cliente/Fornecedor
    Local cLoja := "" //Código da Loja
    Local cItem := "" //Item da nota
    Local cProduto := "" //Produto

    If  cReg = "C170"
// Neste momento a variável PARAMIXB possui 9 posições, sendo elas informações da tabela SFT
        cFilial := PARAMIXB[2]// Filial
        cTpMovto := PARAMIXB[3]
        cSerie := PARAMIXB[4]
        cNotaFisc := PARAMIXB[5]
        cClieFor := PARAMIXB[6]
        cLoja := PARAMIXB[7]
        cItem := PARAMIXB[8]
        cProduto := PARAMIXB[9]
        cConta := Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_CONTA") 

    EndIf

Return cConta
