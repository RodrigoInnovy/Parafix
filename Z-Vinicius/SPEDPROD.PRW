//CUSTOMIZA O EFD CONTRIBUICOES ONDE ELE APAGA O CODIGO DE BARRA DO PRODUTO NO BLOCO 0200

User Function SPEDPROD()

local cAlias := iif(len(paramixb) >= 1 , paramixb[1], '')
local cRegspd := iif(len(paramixb) >= 2 , paramixb[2], '')
local cUnid := iif(len(paramixb) >= 3 , paramixb[3], '')
local aProd := {}
local lFTProduto := .f.
local lB1Cod := .f.
local lCodItem := .f.
local lD2Cod := .f.
local lCF8Item := .f.
local cProduto := ""

//Alert("Ponto de entrada SPEDPROD")

do case
 //Verifica se o campo FT_PRODUTO existe no alias 
 case (cAlias)->(fieldPos('FT_PRODUTO')) > 0 
 cProduto := (cAlias)->FT_PRODUTO
 //Verifica se o campo B1_COD existe no alias
 case (cAlias)->(fieldPos('B1_COD')) > 0
 cProduto := (cAlias)->B1_COD
 //Verifica se o campo COD_ITEM existe no alias
 case (cAlias)->(fieldPos('COD_ITEM')) > 0
 cProduto := (cAlias)->COD_ITEM
 //Verifica se o campo D2_COD existe no alias
 case (cAlias)->(fieldPos('D2_COD')) > 0
 cProduto := (cAlias)->D2_COD
 //Verifica se o campo CF8_ITEM existe no alias
 case (cAlias)->(fieldPos('CF8_ITEM')) > 0 
 cProduto := (cAlias)->CF8_ITEM
endCase

dbSelectArea("SB1")
SB1->(dbSetOrder(1))

if SB1->(dbSeek(xFilial("SB1") + cProduto) ) 
 aAdd(aProd, SB1->B1_COD) // 1 - Código do Produto
 aAdd(aProd, SB1->B1_DESC) // 2 - Descrição do Produto
 aAdd(aProd, "" ) // 3 - Código de Barras
 aAdd(aProd, "" ) // 4 - Código Anterior
 aAdd(aProd) // 5 - Unidade de Medida
 aAdd(aProd) // 6 - Tipo do Item (Tipo SPED)
 aAdd(aProd) // 7 - Código de NCM
 aAdd(aProd) // 8 - Exceção da NCM
 aAdd(aProd) // 9 - Código do Gênero do Item
 aAdd(aProd) // 10 - Código de ISS
 aAdd(aProd) // 11 - Alíquota de ICMS
endIf
 
return aProd
