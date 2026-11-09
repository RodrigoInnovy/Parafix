#Include 'Protheus.ch'

//altera loja do fornecedor do DDA na hora de rodar a conciliação

User Function F260LJCON()

Local aArea := GetArea()
Local aAreaSE2 := SE2->(GetArea())
Local aAreaFIG := FIG->(GetArea())
Local cLojaFIG := PARAMIXB[2]
FIG->(DbGoto(PARAMIXB[1]))
cFornFIG := FIG->FIG_FORNEC
cLojaFIG := FIG->FIG_LOJA
cTitulFIG := FIG->FIG_TITULO
cVenctoFIG := DTOS(FIG->FIG_VENCTO)
cValorFIG := STR(FIG->FIG_VALOR,17,2)
cLojaE2 := Posicione("SE2", 22, xFilial("SE2") + cFornFIG + cVenctoFIG + cValorFIG, "E2_LOJA")


IF cLojaE2 <> "  " .and. cLojaE2 <> cLojaFIG
	cLojaFIG := cLojaE2
	//MsgInfo("A loja do Fornecedor "+cFornFIG+" título "+cTituloE2+" foi alterada", "Alteração de Loja")
ENDIF

RecLock("FIG")
FIG->FIG_LOJA := cLojaFIG
FIG->(MsUnlock())

    RestArea(aAreaSE2)
	RestArea(aAreaFIG)
	RestArea(aArea)

Return cLojaFIG

