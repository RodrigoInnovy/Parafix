#Include "TOTVS.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} PCPADDTAGS
Ponto de entrada para levar informações de cadastro de produtos e 
ordem de produção para a integração do TOTVS MES.

@type	User Function
@author 	João Gustavo Orsi
@since 	03/10/2017
@version P12
/*/
//-------------------------------------------------------------------
User Function PCPADDTAGS()

	Local cAddXml 	:= ""
	Local cTransac 	:= PARAMIXB[1] // Transação que está sendo trafegada. Ex: Item.
	Local cEvent 		:= PARAMIXB[2] // Evento da transação. upsert/delete.
	Local cPont 		:= PARAMIXB[3] // Ponteiro para recuperar as informações da transação. Ex: &(cPont+"B1_COD") -> retorna o código do produto.
	Local cCliLoja 	:= ""
	Local cEndCli 	:= "-"
	Local cTpConv 	:= ""
	Local nFatConv 	:= ""
	
	If Upper(AllTrim(cTransac)) == "ITEM" //Trafegando a mensagem de Produtos.
		If Upper(AllTrim(cEvent)) == "UPSERT" //Atualizando ou Incluindo um produto.
			cTpConv 	:= Posicione("SB1",1,xFilial("SB1") + &(cPont+"B1_COD"),"B1_TIPCONV")
			nFatConv 	:= Posicione("SB1",1,xFilial("SB1") + &(cPont+"B1_COD"),"B1_CONV")
			If cTpConv == "D"
				nFatConv := 1/nFatConv
			EndIf
			nFatConv := Transform(nFatConv,"@E 999,999,999.99999999")
			cAddXml := "<xComplemento>" + Upper(AllTrim(&(cPont+"B1_ZZCLI"))) + "|" // Código do produto para o cliente
			cAddXml += cValToChar(&(cPont+"B1_PRVALID")) + "|" // Prazo de validade em dias
			cAddXml +=  Upper(AllTrim(&(cPont+"B1_ZZDIM"))) + "|" // Dimensão
			cAddXml +=  Upper(AllTrim(&(cPont+"B1_ZZSTA"))) + "|" // Status (automotivo)
			cAddXml +=  Upper(AllTrim(&(cPont+"B1_ZZECN"))) + "|" // ECN (automotivo)
			cAddXml += AllTrim(cEndCli) + "|" // Endereço do cliente (exportação)
			cAddXml += cValToChar(&(cPont+"B1_ZZQTETQ")) + "|" // Quantidade na primeira unidade de medida por etiqueta
			cAddXml += cValToChar(&(cPont+"B1_ZZQTPP")) + "|" // Quantidade de volumes por palete
			cAddXml += cValToChar(&(cPont+"B1_PESBRU")) + "|" // Peso bruto
			cAddXml += cValToChar(&(cPont+"B1_PESO")) + "|" // Peso líquido
			cAddXml += cValToChar(nFatConv)	+ "</xComplemento>" // Fator de conversão com 8 casas decimais
		EndIf
	ElseIf Upper(AllTrim(cTransac)) == "PRODUCTIONORDER" // Trafegando a mensagem de ordem de produção.
		cTpConv 	:= Posicione("SB1",1,xFilial("SB1") + &(cPont+"->C2_PRODUTO"),"B1_TIPCONV")
		nFatConv 	:= Posicione("SB1",1,xFilial("SB1") + &(cPont+"->C2_PRODUTO"),"B1_CONV")
		If cTpConv == "D"
			nFatConv := 1/nFatConv
		EndIf
		nFatConv := Transform(nFatConv,"@E 999,999,999.99999999")
		If !Empty(&(cPont+"->C2_PEDIDO"))
			cCliLoja := Posicione("SC5",1,xFilial("SC5") + &(cPont+"->C2_PEDIDO"),"C5_CLIENTE")
			cCliLoja += Posicione("SC5",1,xFilial("SC5") + &(cPont+"->C2_PEDIDO"),"C5_LOJACLI")
			cEndCli += Upper(AllTrim(Posicione("SA1",1,xFilial("SA1") + cCliLoja,"A1_NOME"))) 		+ ";" 
			cEndCli += Upper(AllTrim(Posicione("SA1",1,xFilial("SA1") + cCliLoja,"A1_END"))) 		+ ";"
			cEndCli += Upper(AllTrim(Posicione("SA1",1,xFilial("SA1") + cCliLoja,"A1_BAIRRO"))) 	+ ";"
			cEndCli += Upper(AllTrim(Posicione("SA1",1,xFilial("SA1") + cCliLoja,"A1_MUN"))) 		+ ";"
			cEndCli += Upper(AllTrim(Posicione("SA1",1,xFilial("SA1") + cCliLoja,"A1_CEP"))) 		+ ";"
			cEndCli += Upper(AllTrim(Posicione("SYA",1,xFilial("SYA") + Posicione("SA1",1,xFilial("SA1") + cCliLoja,"A1_PAIS"),"YA_DESCR")))
		EndIf
		If Upper(AllTrim(cEvent)) == "UPSERT" // Atualizando ou Incluindo uma OP.
			cAddXml := "<xObs>" + Upper(AllTrim(&(cPont+"->C2_OBS")))	+ "|" // Observacao da OP
			cAddXml += Upper(AllTrim(Posicione("SB1",1,xFilial("SB1") + &(cPont+"->C2_PRODUTO"),"B1_ZZOBS1")))	+ "|" // Observacao produto linha 1
			cAddXml += Upper(AllTrim(Posicione("SB1",1,xFilial("SB1") + &(cPont+"->C2_PRODUTO"),"B1_ZZOBS2")))	+ "|" // Observacao produto linha 2
			cAddXml += Upper(AllTrim(Posicione("SB1",1,xFilial("SB1") + &(cPont+"->C2_PRODUTO"),"B1_ZZCLI")))	+ "|" // Codigo produto no cliente
			cAddXml += Upper(AllTrim(cEndCli)) + "|" // Endereço cliente exportação
			cAddXml += cValToChar(nFatConv)	+ "</xObs>" // Fator de conversão com 8 casas decimais
			// Tag criada para observação do complemento de produtos com a instrução de processo na OP.
			cAddXml += "<xObsOper>" + Upper(AllTrim(Posicione("SB5",1,xFilial("SB5") + &(cPont+"->C2_PRODUTO"),"B5_ZZOBS")))	+ "|" // Observacao complemento de produto
			cAddXml += Upper(AllTrim(Posicione("SB5",1,xFilial("SB5") + &(cPont+"->C2_PRODUTO"),"B5_ZZOBS1")))	+ "|" // Observacao complemento de produto 2
			cAddXml += Upper(AllTrim(Posicione("SB5",1,xFilial("SB5") + &(cPont+"->C2_PRODUTO"),"B5_ZZOBS3")))	+ "</xObsOper>" // // Observacao complemento de produto 3
		EndIf
	EndIf

Return cAddXml