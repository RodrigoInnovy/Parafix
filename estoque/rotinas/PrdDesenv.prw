// Baixa do CQ - Informa se o produto esta em desenvolvimento
// Clember - Tuning - 14/11/2014
User Function PrdDesenv()
nTipo := M->D7_TIPO
cProduto := SD7->D7_PRODUTO
cStatus := posicione("SB1",1,xFilial("SB1")+cProduto,"B1_ZZSTATU")

If Alltrim(cStatus) == "2"

Alert("Produto em Desenvolvimento.")

EndIf 

Return .T.