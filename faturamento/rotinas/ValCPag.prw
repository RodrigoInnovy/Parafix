#Include "Totvs.ch"

user function ValCPag(cCondPag)
	
	local lRet 		:= .T.
	local cCondCli 	:= Posicione("SA1",1,xFilial("SA1") + M->C5_CLIENTE + M->C5_LOJACLI,"A1_COND")
	
	
	If Alltrim(FUNNAME()) <> "EECAP100"
	
	
	If !Empty(cCondCli) .And. cCondPag <> cCondCli .And. M->C5_TIPO = "N" 
		lRet := .F.
		MsgAlert("Não é permitida a troca da condição de pagamento.","ALTERAÇÃO NÃO PERMITIDA")
	EndIF
	EndIF
return lRet