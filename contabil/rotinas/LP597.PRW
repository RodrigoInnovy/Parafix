// Customizaçã para contabilizar a LP 597 compensação de adiantamento Contas a Pagar.

#Include "rwmake.ch"

User Function LP597(_cPar1,_cPar2)

// Definição das variáveis.
	Public _aArea   	:= GetArea()
	Public _aAreaSE2	:= {}
	Public _aAreaSE5	:= {}
	Public _aAreaSA1	:= {}
	Public _aAreaSED	:= {}
	Public _cRet		:= Space(20)
	Public _cCod		:= Space(TamSX3("A2_COD")[1])
	Public _cLoja		:= Space(TamSX3("A2_LOJA")[1])
	Public _cConta		:= Space(TamSX3("CT1_CONTA")[1])
	Public _cNat		:= Space(TamSX3("ED_CODIGO")[1])
	Public _cChavePA	:= Space(23)
	Public _cChaveNF	:= Space(23)
	Public _cChave		:= Space(23)
	Public _cForPA		:= Space(15)
	Public _cForNF		:= Space(15)
	Public  cNatureza   := ALLTRIM(SE2->E2_NATUREZ)
	Public  cContaNaturez := Posicione("SED",1,xfilial("SED")+cNatureza,SED->ED_CONTA)
	_cPar1 := Upper(Alltrim(_cPar1)) // Tipo de Dado a ser retornado.
	_cPar2 := Upper(Alltrim(_cPar2)) // Tipo de Dado a ser retornado.

	dbSelectArea("SE5")
	_aAreaSE5 := GetArea()
	If Alltrim(SE5->E5_TIPO) $ "PA/NDF" // Usuário compensou posicionando na NF.
		_cChaveNF := SUBSTR(SE5->E5_DOCUMEN,1,15+TamSX3("E5_PARCELA")[1])+SE5->E5_FORNADT+SE5->E5_LOJAADT
		_cChavePA := SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)
		_cRet := '1105070201'

	Else // Usuário compensou posicionando no PA/NDF
		_cChaveNF := SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)
		_cChavePA := SUBSTR(SE5->E5_DOCUMEN,1,15+TamSX3("E5_PARCELA")[1])+SE5->E5_FORNADT+SE5->E5_LOJAADT
	EndIf

	dbSelectArea("SE2")
	_aAreaSE2 := GetArea()
	dbSetOrder(1) //E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA

// Obtem nome do fornecedor da NF.

	If dbSeek(xFilial("SE2")+_cChaveNF,.T.)
		_cForNF	  := Alltrim(SE2->E2_NOMFOR)
	EndIf

// Obtem nome do fornecedor do PA.

	If dbSeek(xFilial("SE2")+_cChavePA,.T.)

		_cForPA	  := Alltrim(SE2->E2_NOMFOR)

		_cRet := Posicione("SED",1,XFILIAL("SED")+ALLTRIM(SE2->E2_NATUREZ),"SED->ED_CONTA")

	EndIf



// Restaura áreas de trabalho.
	RestArea(_aAreaSE2)
	RestArea(_aAreaSE5)
	RestArea(_aArea)

// Retorna dado para o LP.
Return(_cRet)
