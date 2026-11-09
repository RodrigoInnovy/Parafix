#Include "rwmake.ch"
#Include "protheus.ch"
#Include "topconn.ch"

/*-------------------------------------------------------------------------------.\
/|                            TOTVS INTERIOR PAULISTA                            |\
/|-------------------------------------------------------------------------------|\
/| Programa : MT120OK.PRW                | Autor : FELIPE CAMPOS                 |\
/|-------------------------------------------------------------------------------|\
/| Data     : 13/12/2011                 | Alteracao:                            |\
/|-------------------------------------------------------------------------------|\
/| Descricao: Ponto de Entrada chamado antes da gravacao do pedido de compra     |\
/|-------------------------------------------------------------------------------|\
/| Uso especifico - Parafix                                                      |\
/.-------------------------------------------------------------------------------.*/

user function MT120OK()    

Local lRet := .T.
Local cCondPag      := CCONDICAO
Local cAdiantamento := posicione("SE4",1,xFilial("SE4")+cCondPag,"E4_CTRADT")
Local cNumPed       := CA120NUM
Local cTitulo       := posicione("FIE",1,xFilial("FIE")+"P"+cNumPed,"FIE_NUM")
//Variavel com a posicao dos campos do aCols
private nPosCod    := Ascan(aHeader,{|x| "C7_PRODUTO" $ x[2]})
private nPosItem   := Ascan(aHeader,{|x| "C7_ITEM"    $ x[2]})

//-----------------------------------------------------------------------------------------------//
// Tratamento realizado para informar ao usuario quando o item do pedido esta em Desenvolvimento //
//-----------------------------------------------------------------------------------------------//
for i:=1 to len(acols)
	if !acols[i,len(aheader)+1]
		if Posicione("SB1",1,xFilial("SB1")+aCols[i,nPosCod],"B1_ZZSTATU") == "2"
			APMSGALERT("ATENCAO: Item: "+alltrim(aCols[i,nPosItem])+" - Produto : "+alltrim(aCols[i,nPosCod])+" em Desenvolvimento, favor consultar com o departamento responsavel")
		endif
	endif
Next


//Valida se exites adaintamento baixado e não vinculado no pedido de compras 
If cAdiantamento == "1" .AND. cTitulo =="         " .AND. CMODULO =="COM"
APMSGALERT("É Obrigatório Relacionar o Adiantamento ao Pedido de Compras")
lRet := .F.
Endif

Return lRet
