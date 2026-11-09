//Ponto de entrada que validade se a quantidade de embalagem é multipla, e também calcula o preço net do produto//

#INCLUDE "PROTHEUS.CH"
#INCLUDE "PRTOPDEF.CH"

User Function M410LIOK()
Local aArea          := GetArea()
Local aAreaSB1       := SB1->(GetArea())
Local lRet           := .T.
Local nPosQuant      := Ascan(Aheader,{|x| AllTrim(x[2]) == "C6_QTDVEN" })
Local nPosProd       := Ascan(Aheader,{|x| AllTrim(x[2]) == "C6_PRODUTO" })
Local nPosTes        := Ascan(Aheader,{|x| AllTrim(x[2]) == "C6_TES" })
Local nPosPreco      := Ascan(Aheader,{|x| AllTrim(x[2]) == "C6_PRCVEN" })
Local nPosPrecoNet   := Ascan(Aheader,{|x| AllTrim(x[2]) == "C6_ZPRCNET" })
Local nPosCfop       := Ascan(Aheader,{|x| AllTrim(x[2]) == "C6_CF" })
local cProduto       := acols[n][nPosProd]
local nQuant         := acols[n][nPosQuant]
local cTes           := acols[n][nPosTes]
local cCfop          := acols[n][nPosCfop]
local nPreco         := acols[n][nPosPreco]
local cC6num         := M->C5_NUM
local cC6filial      := "01"
local cC5num         := M->C5_NUM
local cCliente       := M->C5_CLIENTE
local cloja          := M->C5_LOJACLI
Local cCliEstado     := Posicione("SA1",1,xFilial("SA1")+cCliente+cloja,"A1_EST")
local cTipoCli       := M->C5_TIPOCLI
local cTipo          := M->C5_TIPO
Local nEmb           := Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_ZZQTETQ")
Local nLinhaProd     := Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_ZZLP")
Local cNCM           := Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_POSIPI")
Local cTipoProduto   := Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_TIPO")
Local nTesReducao    := Posicione("SF4",1,xFilial("SF4")+cTes,"F4_BASEICM")


If nQuant % nEmb <> 0 .AND. nLinhaProd <> "EFT"
   FWAlertWarning("A quantiade informada deste produto não é múltipla de embalagem")
   Lret := .T.
EndIf

If cTipoCli <> 'X

MaFisIni(cCliente,; // 1-Codigo Cliente/Fornecedor
cloja,; // 2-Loja do Cliente/Fornecedor
"C",; // 3-C:Cliente , F:Fornecedor
cTipo,; // 4-Tipo da NF
cTipoCli,; // 5-Tipo do Cliente/Fornecedor
MaFisRelImp("MTR700",{"SC5","SC6"}),; // 6-Relacao de Impostos que suportados no arquivo
,; // 7-Tipo de complemento
,; // 8-Permite Incluir Impostos no Rodape .T./.F.
"SB1",; // 9-Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
"MTR700") // 10-Nome da rotina que esta utilizando a funcao
nItem := 0
nValIcmSt := 0
nDesconto := 0
nNrItem:=0
nPrecoSemICMS :=0.00
nPrecoNet := 0.00
nTotDesc := 0.00
nICM := 0.00
nPIS := 0.00
nCOFINS := 0.00
nTotDesp := 0.00
nTotFrete := 0.00
nTotSeguro := 0.00
nRedICM := 0.00
nItem ++
MaFisAdd(cProduto,; // 1-Codigo do Produto ( Obrigatorio )
cTes,; // 2-Codigo do TES ( Opcional )
nQuant,; // 3-Quantidade ( Obrigatorio )
nPreco,; // 4-Preco Unitario ( Obrigatorio )
nDesconto,; // 5-Valor do Desconto ( Opcional )
nil,; // 6-Numero da NF Original ( Devolucao/Benef )
nil,; // 7-Serie da NF Original ( Devolucao/Benef )
nil,; // 8-RecNo da NF Original no arq SD1/SD2
0,; // 9-Valor do Frete do Item ( Opcional )
0,; // 10-Valor da Despesa do item ( Opcional )
0,; // 11-Valor do Seguro do item ( Opcional )
0,; // 12-Valor do Frete Autonomo ( Opcional )
0,; // 13-Valor da Mercadoria ( Obrigatorio )
0,; // 14-Valor da Embalagem ( Opcional )
0,; // 15-RecNo do SB1
0) // 16-RecNo do SF4
nICM := MaFisRet(nItem,"IT_ALIQICM")
nRedICM := MaFisRet(nItem,"IT_ICMS")[16]
nPIS := MaFisRet(nItem,"IT_ALIQPIS")
nCOFINS := MaFisRet(nItem,"IT_ALIQCOF")
nTotDesp := MaFisRet(,'NF_DESPESA')
nTotFrete := MaFisRet(,'NF_FRETE')
nTotSeguro := MaFisRet(,'NF_SEGURO')
nTotIcmSol := MaFisRet(nItem,'NF_VALSOL')
nAliqICM := nICM*(MaFisRet(nItem,"IT_ICMS")[16]/100)

nPrecoSemICMS := iif(nAliqICM = 0,nPreco-(nPreco*(nICM/100)), nPreco-(nPreco*(nAliqICM/100)))
nPrecoNet := round(nPrecoSemICMS-(nPrecoSemICMS*((nPis+nCOFINS)/100)),4)
acols[n][nPosPrecoNet] := nPrecoNet
MaFisEnd()//Termino

Else
acols[n][nPosPrecoNet] := round(nPreco,4)

Endif

// Validação CFOP:  X-401-XXXX” (TIPOS PA, PI), seja final 101 ou 122 ou 924 ou 911, diferente de “EX”, sendo dentro de SP com a NCM começa “50 a 58” com redução SIM na TES 
If !cTipoCli == 'X' .AND. cTipo <> "B" .AND. SUBSTR(cProduto,3,3) =='401' .AND. cTipoProduto $ 'PA,PI' .AND. !SUBSTR(cCfop,2,3) $ '101,122,924,911' .AND. SUBSTR(cNCM,1,2) $ '50,58' .AND. cCliEstado == 'SP' .AND. nTesReducao <>0
   lRet := MsgYesNo('CFOP incorreto para o Tipo de Operação/Produto (reg1). Deseja continuar?', 'Atenção')
EndIf

// Validação CFOP:  X-401-XXXX” (TIPOS PA, PI), seja final 101 ou 122 ou 924 ou 911, diferente de “EX”, sendo fora de SP com redução NÃO na TES 
If !cTipoCli == 'X' .AND. cTipo <> "B" .AND. SUBSTR(cProduto,3,3) =='401' .AND. cTipoProduto $ 'PA,PI' .AND. !SUBSTR(cCfop,2,3) $ '101,122,924,910,911' .AND. cCliEstado <> 'SP' .AND. nTesReducao ==0
   lRet := MsgYesNo('CFOP incorreto para o Tipo de Operação/Produto (reg2). Deseja continuar?', 'Atenção')
EndIf

// Validação CFOP: X-520-XXXX” + “X-480-XXXX” (TIPOS ME, MP), seja final 102, 123, 924, 911, diferente de “EX”.
If !cTipoCli == 'X' .AND. cTipo <> "B" .AND. SUBSTR(cProduto,3,3) $ '520,480' .AND. cTipoProduto $ 'ME,MP' .AND. !SUBSTR(cCfop,2,3) $ '102,123,924,911,927'
   lRet := MsgYesNo('CFOP incorreto para o Tipo de Operação/Produto (reg3). Deseja continuar?', 'Atenção')
EndIf


RestArea(aAreaSB1)
RestArea(aArea)
Return lRet
