#include "rwmake.ch"
#include "Topconn.ch"
#include "protheus.ch"

// Ponto de entrada que faz preencher no EFD com a conta contabil quando tem rateio no Documento de entrada.

User Function SPDPIS07()
 
Local   cFilial     :=  PARAMIXB[1] //FT_FILIAL
Local   cTpMov      :=  PARAMIXB[2] //FT_TIPOMOV
Local   cSerie      :=  PARAMIXB[3] //FT_SERIE
Local   cDoc        :=  PARAMIXB[4] //FT_NFISCAL
Local   cClieFor    :=  PARAMIXB[5] //FT_CLIEFOR
Local   cLoja       :=  PARAMIXB[6] //FT_LOJA
Local   cItem       :=  PARAMIXB[7] //FT_ITEM
Local   cProd       :=  PARAMIXB[8] //FT_PRODUTO       
Local   cConta      :=  PARAMIXB[9] //FT_CONTA
 
cConta := Posicione("SB1",1,xFilial("SB1")+cProd,"B1_CONTA")   

Return cConta
