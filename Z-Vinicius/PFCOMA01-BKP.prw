#Include "Protheus.ch"

/*/{Protheus.doc} PFCOMA01
Rotina Atualiza PC em Aberto
@type function
@version 1.0
@author Parafix
@since 03/12/2021
@return lRet, logical
/*/

User Function PFCOMA01()
	Local lRet     := .T.
	Local aArea    := GetArea()
	Local aAreaAIA := AIA->(GetArea())
	Local aAreaSA2 := SA2->(GetArea())
	Local aAreaSC7 := SC7->(GetArea())
	Local lInativo := Dtos(AIA->AIA_DATATE) < Dtos(dDataBase).And. !Empty(Dtos(AIA->AIA_DATATE))
	Local cNomFor  := Posicione("SA2", 1, xFilial("SA2") + AIA->AIA_CODFOR + AIA->AIA_LOJFOR, "A2_NOME")

	If (lInativo)
		MsgInfo("Não é possível atualizar Pedido(s) de Compra em aberto." + CRLF + ;
			"Tabela de Preço inativa.", "Atualiza PC em Aberto")
	Else
		If (MsgYesNo("Deseja atualizar o(s) Pedido(s) de Compra em aberto?" + CRLF + CRLF + ;
				"Fornecedor: " + AllTrim(AIA->AIA_CODFOR) + "/" + AllTrim(AIA->AIA_LOJFOR) + " - " + AllTrim(cNomFor) + CRLF + ;
				"Tabela de Preço: " + AllTrim(AIA->AIA_CODTAB), ;
				"Atualiza PC em Aberto"))
			Processa({|| U_COMA01Prc(AIA->AIA_CODFOR, AIA->AIA_LOJFOR, AIA->AIA_CODTAB)}, "Aguarde...", "Processando Pedido(s) em aberto...")
		Endif
	Endif

	RestArea(aAreaSC7)
	RestArea(aAreaSA2)
	RestArea(aAreaAIA)
	RestArea(aArea)
Return(lRet)

/*/{Protheus.doc} COMA01Prc
Processa PC em Aberto
@type function
@version 1.0
@author Parafix
@since 03/12/2021
@return lRet, logical
/*/

User Function COMA01Prc(cFornece, cLoja, cCodTab)
	Local lRet   := .T.
	Local cQuery := ""
	Local cTab   := ""
	Local nRegs  := 0
	Local cNumPC := ""
	Local cUltPC := ""
	Local cLog   := ""
	Local oDlg   := Nil
	Local oLog   := Nil
	Local oBtn   := Nil
	Local aCab   := {}
	Local aItem  := {}
	Local aItens := {}
	Local nAtual := 0
	Local lContinua := .T.

	Private lMsErroAuto := .F.

	Default cFornece := ""
	Default cLoja    := ""
	Default cCodTab  := ""

	cQuery := "SELECT T0.C7_FILIAL" + CRLF
	cQuery += "	,T0.C7_NUM" + CRLF
	cQuery += "	,T0.C7_EMISSAO" + CRLF
	cQuery += "	,T0.C7_COND" + CRLF
	cQuery += "	,T0.C7_CONTATO" + CRLF
	cQuery += "	,T0.C7_FILENT" + CRLF
	cQuery += "	,T0.C7_MOEDA" + CRLF
	cQuery += "	,T0.C7_TXMOEDA" + CRLF
	cQuery += "	,T0.C7_ITEM" + CRLF
	cQuery += "	,T0.C7_PRODUTO" + CRLF
	cQuery += "	,T0.C7_QUANT" + CRLF
	cQuery += "	,T0.C7_PRECO" + CRLF
	cQuery += "FROM " + RetSQLName("SC7") + " T0" + CRLF
	cQuery += "WHERE T0.C7_QUJE = 0" + CRLF
	cQuery += "	AND T0.C7_QTDACLA = 0" + CRLF
	cQuery += "	AND T0.C7_RESIDUO = ''" + CRLF
	cQuery += "	AND T0.C7_FORNECE = '" + PadR(cFornece, TamSX3("C7_FORNECE")[1]) + "'" + CRLF
	cQuery += "	AND T0.C7_LOJA = '" + PadR(cLoja, TamSX3("C7_LOJA")[1]) + "'" + CRLF
	cQuery += "	AND T0.C7_CODTAB = '" + PadR(cCodTab, TamSX3("C7_CODTAB")[1]) + "'" + CRLF
	cQuery += "	AND T0.D_E_L_E_T_ = ''" + CRLF
	cQuery += "ORDER BY T0.C7_FILIAL" + CRLF
	cQuery += "	,T0.C7_NUM" + CRLF
	cQuery += "	,T0.C7_ITEM" + CRLF

	cTab := MPSysOpenQuery(cQuery)

	DbSelectArea((cTab))
	Count To nRegs
	(cTab)->(DbGoTop())

	ProcRegua(nRegs)

	Begin Transaction

		While ((cTab)->(!Eof()))
			cNumPC := (cTab)->C7_NUM

			IncProc("Processando PC: " + cNumPC)

			If (cUltPC <> cNumPC)
				If (!Empty(cUltPC))
					lMsErroAuto := .F.

					DbSelectArea("SC7")
					SC7->(DbSetOrder(1))
					If (SC7->(DbSeek(aCab[1][2] + aCab[2][2])))
						MSExecAuto({|v, x, y, z| MATA120(v, x, y, z)}, 1, aCab, aItens, 4)

						If (lMsErroAuto)
							cLog := cUltPC
							MostraErro()
							DisarmTransaction()
							lContinua := .F.
							Exit
						Endif
					Endif
				Endif

				If (Empty(cLog))
					cLog := cNumPC
				Else
					cLog += CRLF + cNumPC
				Endif

				cUltPC := cNumPC

				aCab := {}
				aAdd(aCab, {"C7_FILIAL" , (cTab)->C7_FILIAL                      , Nil})
				aAdd(aCab, {"C7_NUM"    , (cTab)->C7_NUM                         , Nil})
				aAdd(aCab, {"C7_EMISSAO", SToD((cTab)->C7_EMISSAO)               , Nil})
				aAdd(aCab, {"C7_FORNECE", PadR(cFornece, TamSX3("C7_FORNECE")[1]), Nil})
				aAdd(aCab, {"C7_LOJA"   , PadR(cLoja, TamSX3("C7_LOJA")[1])      , Nil})
				aAdd(aCab, {"C7_COND"   , (cTab)->C7_COND                        , Nil})
				aAdd(aCab, {"C7_CONTATO", (cTab)->C7_CONTATO                     , Nil})
				aAdd(aCab, {"C7_FILENT" , (cTab)->C7_FILENT                      , Nil})
				aAdd(aCab, {"C7_MOEDA"  , (cTab)->C7_MOEDA                       , Nil})
				aAdd(aCab, {"C7_TXMOEDA", (cTab)->C7_TXMOEDA                     , Nil})

				aItens := {}
			Endif

			aItem := {}
			aAdd(aItem, {"C7_ITEM", (cTab)->C7_ITEM, Nil})
			aAdd(aItem, {"C7_PRODUTO", (cTab)->C7_PRODUTO, Nil})
			aAdd(aItem, {"C7_QUANT", (cTab)->C7_QUANT, Nil})
			nAtual := MaTabPrCom(PadR(cCodTab, TamSX3("C7_CODTAB")[1]), (cTab)->C7_PRODUTO, (cTab)->C7_QUANT, ;
				PadR(cFornece, TamSX3("C7_FORNECE")[1]), PadR(cLoja, TamSX3("C7_LOJA")[1]))
			If (Empty(nAtual))
				aAdd(aItem, {"C7_PRECO", (cTab)->C7_PRECO, Nil})
			Else
				aAdd(aItem, {"C7_PRECO", nAtual, Nil})
			Endif
			aAdd(aItem, {"LINPOS", "C7_ITEM", (cTab)->C7_ITEM})
			aAdd(aItem, {"AUTDELETA", "N", Nil})
			aAdd(aItens, aItem)

			(cTab)->(DbSkip())
		Enddo

		(cTab)->(DbCloseArea())

		If (lContinua)
			If (!Empty(cUltPC))
				lMsErroAuto := .F.

				DbSelectArea("SC7")
				SC7->(DbSetOrder(1))
				If (SC7->(DbSeek(aCab[1][2] + aCab[2][2])))
					MSExecAuto({|v, x, y, z| MATA120(v, x, y, z)}, 1, aCab, aItens, 4)

					If (lMsErroAuto)
						cLog := cUltPC
						MostraErro()
						DisarmTransaction()
					Endif
				Endif
			Endif
		Endif

	End Transaction

	If (Empty(cLog))
		cLog := "Nenhum pedido processado."
	Elseif (lContinua)
		cLog := "Pedido(s) em aberto processado(s): " + CRLF + CRLF + cLog
	Else
		cLog := "Verificar Pedido em aberto: " + CRLF + CRLF + cLog
	Endif

	Define MsDialog oDlg Title "Log de Processamento" FROM 000, 000 TO 300, 400 Colors 0, 16777215 Pixel

	@ 002, 004 Get oLog Var cLog Of oDlg MultiLine Size 191, 121 Colors 0, 16777215 HScroll Pixel
	oLog:lReadOnly := .T.
	@ 127, 144 Button oBtn Prompt "Ok" Size 051, 019 Action (oDlg:End()) Of oDlg Pixel

	Activate MSDIALOG oDlg Centered
Return(lRet)
