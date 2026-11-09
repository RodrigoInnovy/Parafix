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
	Local lRet      := .T.
	Local cQuery    := ""
	Local cTab      := ""
	Local nRegs     := 0
	Local cNumPC    := ""
	Local cUltPC    := ""
	Local cLog      := ""
	Local oDlg      := Nil
	Local oLog      := Nil
	Local oBtn      := Nil
	Local aCab      := {}
	Local aItem     := {}
	Local aItens    := {}
	Local nAtual    := 0
	Local lContinua := .T.
	Local cForEx    := Posicione("SA2",1,xFilial("SA2")+cFornece+cLoja,"A2_EST")

	Private lMsErroAuto := .F.
	Private cGerPCSCR   := ""

	Default cFornece := ""
	Default cLoja    := ""
	Default cCodTab  := ""

	cQuery := "SELECT T0.C7_FILIAL" 	+ CRLF
	cQuery += "	,T0.C7_NUM" 			+ CRLF
	cQuery += "	,T0.C7_EMISSAO" 		+ CRLF
	cQuery += "	,T0.C7_COND" 			+ CRLF
	cQuery += "	,T0.C7_CONTATO" 		+ CRLF
	cQuery += "	,T0.C7_FILENT" 			+ CRLF
	cQuery += "	,T0.C7_MOEDA" 			+ CRLF
	cQuery += "	,T0.C7_TXMOEDA" 		+ CRLF
	cQuery += "	,T0.C7_ITEM" 			+ CRLF
	cQuery += "	,T0.C7_PRODUTO" 		+ CRLF
	cQuery += "	,T0.C7_QUANT" 			+ CRLF
	cQuery += "	,T0.C7_PRECO" 			+ CRLF
	cQuery += "	,T0.C7_PO_EIC" 			+ CRLF
	cQuery += "	,T0.C7_SEQUEN" 		 	+ CRLF
	cQuery += "	,T0.C7_APROV"			+ CRLF
	cQuery += "	,T0.C7_MOEDA" 		 	+ CRLF
	cQuery += "	,T0.C7_TXMOEDA"			+ CRLF
	cQuery += "	,T0.C7_PO_EIC"			+ CRLF
	cQuery += "FROM " + RetSQLName("SC7") + " T0" + CRLF
	cQuery += "WHERE T0.C7_QUJE = 0" 	+ CRLF
	cQuery += "	AND T0.C7_QTDACLA = 0" 	+ CRLF
	cQuery += "	AND T0.C7_RESIDUO = ''" + CRLF
	cQuery += "	AND T0.C7_FORNECE = '"  + PadR(cFornece, TamSX3("C7_FORNECE")[1]) + "'" + CRLF
	cQuery += "	AND T0.C7_LOJA = '"     + PadR(cLoja   , TamSX3("C7_LOJA")[1])    + "'" + CRLF
	cQuery += "	AND T0.C7_CODTAB = '"   + PadR(cCodTab , TamSX3("C7_CODTAB")[1])  + "'" + CRLF
	cQuery += "	AND T0.D_E_L_E_T_ = ''" + CRLF
	cQuery += "ORDER BY T0.C7_FILIAL" 	+ CRLF
	cQuery += "	,T0.C7_NUM" 			+ CRLF
	cQuery += "	,T0.C7_ITEM" 			+ CRLF

	cTab := MPSysOpenQuery(cQuery)

	DbSelectArea((cTab))
	Count To nRegs
	(cTab)->(DbGoTop())

	ProcRegua(nRegs)

	IF cForEX <> "EX" // Fernando em 18/09/2022

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
				aAdd(aItem, {"C7_ITEM"   , (cTab)->C7_ITEM		, Nil})
				aAdd(aItem, {"C7_PRODUTO", (cTab)->C7_PRODUTO	, Nil})
				aAdd(aItem, {"C7_QUANT"  , (cTab)->C7_QUANT		, Nil})
				nAtual := MaTabPrCom(PadR(cCodTab, TamSX3("C7_CODTAB")[1]), (cTab)->C7_PRODUTO, (cTab)->C7_QUANT, ;
					PadR(cFornece, TamSX3("C7_FORNECE")[1]), PadR(cLoja, TamSX3("C7_LOJA")[1]))
				If (Empty(nAtual))
					aAdd(aItem, {"C7_PRECO", (cTab)->C7_PRECO, Nil})
				Else
					aAdd(aItem, {"C7_PRECO", nAtual, Nil})
				Endif
				aAdd(aItem, {"LINPOS"   , "C7_ITEM", (cTab)->C7_ITEM})
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

	else

		//-----------------------------------------
		// Fernando em 18/09/2022
		//-----------------------------------------
		cLog    := ""
		Private cOldPc  := ""
		Private nContW5 := 0
		Private nContW3 := 0
		Private _nValTotFob := 0
		Private nAtualUN2   := 0

		Begin Transaction

			While ((cTab)->(!Eof()))

				cNumPC := (cTab)->C7_NUM
				cItPC  := (cTab)->C7_ITEM
				cPOPC  := (cTab)->C7_PO_EIC
				cSePC  := (cTab)->C7_SEQUEN
				//cCodPro:= (cTab)->C7_PRODUTO

				If cOldPc <> cNumPC .and. !Empty(cPOPC)

					_nValTotFob := 0
					If (Empty(cLog))
						cLog := "PC Nr.: "+Alltrim(cNumPC) + " - PO Nr.: "+Alltrim(cPOPC)
					Else
						cLog += CRLF + "PC Nr.: "+Alltrim(cNumPC) + " - PO Nr.: "+Alltrim(cPOPC)
					Endif
					cOldPC := cNumPC
				Endif

				IncProc("Processando PC: " + Alltrim(cNumPC) + "-"  + Alltrim(cItPC))
				cAliasPrin  := GetArea()
				nAtual 		:= 0
				nSaldoW5    := 0
				cPGI_NUM    := ""
				dDtValidAIA := AIA->AIA_DATATE

				nAtual := MaTabPrCom(PadR(cCodTab, TamSX3("C7_CODTAB")[1]), (cTab)->C7_PRODUTO, (cTab)->C7_QUANT, ;
					PadR(cFornece, TamSX3("C7_FORNECE")[1]), PadR(cLoja, TamSX3("C7_LOJA")[1]),(cTab)->C7_MOEDA, dDtValidAIA)
				cOldAib := GetArea()
				//AIB_FILIAL+AIB_CODFOR+AIB_LOJFOR+AIB_CODTAB+AIB_CODPRO
				nPrc2 := Posicione("AIB",2,xFilial("AIB")+cFornece+cLoja+cCodTab+(cTab)->C7_PRODUTO,"AIB_ZZPRC2")
				nAtualUN2 := nPrc2 // Valor Seg Unidade
				RestArea(cOldAib)
				If nAtual <> 0 // Caso valor ajuste seja maior
					// Encontra Inf do PO
					//------------------------
					DbSelectArea("SW3")
					DbSetOrder(8)

					If DbSeek(xFilial("SW3")+cPOPC+cSePC)
						IncProc("Processando PO: " + Alltrim(cPOPC)+ "-" + Alltrim(cSePC))
						SW3->(DbSkip())
						cPGI_NUM := SW3->W3_PGI_NUM
						SW3->(DbSkip(-1))
						// Encontra Inf do Saldo PO
						//---------------------------
						cAliasSW3 := GetArea()
						DbSelectArea("SW5")
						DbSetOrder(8)

						If DbSeek(xFilial("SW5")+cPGI_NUM+cPOPC+cSePC)
							IncProc("Processando SW5: " + Alltrim(cPOPC)+ "-" + Alltrim(cSePC))
							nSaldoW5 := W5_SALDO_Q
							If nSaldoW5 <> 0
								RecLock("SW5",.F.)
								SW5->W5_PRECO := nAtual
								MsUnlock("SW5")
							Endif
						Endif
						RestArea(cAliasSW3)
						If nSaldoW5 <> 0
							RecLock("SW3",.F.)
							SW3->W3_PRECO  := nAtual
							SW3->W3_XVLUN2 := nAtualUN2
							nTotW3It := (cTab)->C7_QUANT * nAtual
							_nValTotFob += nTotW3It
							nContW3 := nContW3+1
							MsUnlock("SW3")
							SW3->(DbSkip())
							RecLock("SW3",.F.)
							SW3->W3_PRECO := nAtual
							SW3->W3_XVLUN2 := nAtualUN2
							MsUnlock("SW3")
							SW3->(DbSkip(-1))
						else
							nContW5 := nContW5+1
						Endif
					Endif

					// Saldo do PO nao pode ser = 0
					If nSaldoW5 <> 0
						// Bloqueia PO
						DbSelectArea("SW2")
						DbSetOrder(1)
						_cNrPO := (cTab)->C7_PO_EIC
						If DbSeek(xFilial("SW2")+_cNrPO)
							//_nValTotFob := SW2->W2_FOB_TOT
							RecLock("SW2",.F.)
							SW2->W2_CONAPRO := "B"
							SW2->W2_FOB_TOT := _nValTotFob
							MsUnlock("SW2")
						Endif

						// Tabela SCR atualizar conforme o numero de aprovadores
						// Tabela SAL - Conforme C7_APROV
						// Valor é igual total do PC
						// SW2->W2_CONAPRO := "B"
						// Precisou fazer na mao porque o execblock do mata120 Critica quando o pedido
						// de compras vem do EIC nao permitindo usar a funcao
						// MSExecAuto({|v, x, y, z| MATA120(v, x, y, z)}, 1, aCab, aItens, 4)

						// Gera Informações de Alçada conforme grupo de aprovação
						iF  cGerPCSCR  <> cNumPC
							cGerPCSCR := cNumPC
							cGrupAprov := (cTab)->C7_APROV

							DbSelectArea("SCR")
							DbSetOrder(1)
							If DbSeek(xFilial("SCR")+"PC"+cNumPC+SPACE(44))
								While !eof() .and. Alltrim(SCR->CR_NUM) == cNumPC
									RecLock("SCR", .F. )
									dbDelete()
									MsUnlock()
									Dbskip()
								Enddo
							Endif

							// Funcao abaixo nao funcionou - Necessário fazer manual
							// MaAlcDoc({cNumPC,"PC",nAtual,,,cGrupAprov,,(cTab)->C7_MOEDA,(cTab)->C7_TXMOEDA,(cTab)->C7_EMISSAO},(cTab)->C7_EMISSAO,3)

							DbSelectArea("SAL")
							DbSetOrder(1)

							If DbSeek(xFilial("SAL")+cGrupAprov)

								While !Eof() .and. cGrupAprov == SAL->AL_COD

									AlAprov := SAL->AL_APROV
									AlGrupo := cGrupAprov
									AlUser  := SAL->AL_USER
									AlItem  := SAL->AL_ITEM
									Alnivel := SAL->AL_NIVEL
									Almsbloq:= SAL->AL_MSBLQL

									iF Almsbloq <> "1"

										DbSelectArea("SCR")
										DbSetOrder(3)

										If !DbSeek(xFilial("SCR")+"PC"+cNumPC+SPACE(44)+AlAprov)

											Reclock("SCR",.T.)

											SCR->CR_FILIAL  := xFilial("SCR")
											SCR->CR_NUM     := cNumPC
											SCR->CR_TIPO    := "PC"
											SCR->CR_USER    := AlUser
											SCR->CR_APROV   := AlAprov
											SCR->CR_GRUPO   := cGrupAprov
											SCR->CR_NIVEL   := Alnivel
											SCR->CR_STATUS  := "02"
											SCR->CR_EMISSAO := dDataBase
											SCR->CR_TOTAL   := _nValTotFob
											SCR->CR_MOEDA   := (cTab)->C7_MOEDA
											SCR->CR_TXMOEDA := (cTab)->C7_TXMOEDA
											SCR->CR_ESCALON := .F.
											SCR->CR_ESCALSP := .F.

											MsUnlock()

										Endif

									Endif
									DbSelectArea("SAL")
									DbSkip()
								EndDo
							Endif
						Endif

						// Bloqueia item do SC7
						DbSelectArea("SC7")
						DbSetOrder(1)
						If DbSeek(xFilial("SC7")+cNumPC+cItPC)
							RecLock("SC7",.F.)
							SC7->C7_PRECO   := nAtual
							SC7->C7_CONAPRO := "B"
							SC7->C7_TOTAL   := SC7->C7_QUANT * nAtual
							SC7->C7_PRC2UN  := nAtualUN2
							MsUnlock("SC7")
						Endif

					Endif

				Endif

				RestArea(cAliasPrin )

				(cTab)->(DbSkip())

				if (cTab)->C7_NUM <> cNumPC
				    cOldTab := GetArea()
					DbSelectArea("SCR")
					DbSetOrder(1)
					If DbSeek(xFilial("SCR")+"PC"+cNumPC+SPACE(44))
						While !eof() .and. Alltrim(SCR->CR_NUM) == cNumPC
							RecLock("SCR", .F. )
							SCR->CR_TOTAL   := _nValTotFob
							MsUnlock()
							Dbskip()
						Enddo
					Endif
					RestArea(cOldTab)
				Endif

			Enddo

			(cTab)->(DbCloseArea())

		End Transaction

		If (Empty(cLog))
			cLog := "Nenhum pedido processado."
		Elseif (lContinua)
			cLog := "Pedido(s) em aberto processado(s): " + CRLF + CRLF + Alltrim(cLog)  + CRLF + "Qtd. Itens Atualizados: "+Strzero(nContW3,5)  + CRLF +"Item Embarcados ! NÃO Atualizados : "+Strzero(nContW5,5)
		Else
			cLog := "Verificar Pedido em aberto: " + CRLF + CRLF + Alltim(cLog) + CRLF  + "Qtd. Itens Atualizados: "+Strzero(nContW3,5) + CRLF +"Item Embarcados ! NÃO Atualizados : "+Strzero(nContW5,5)
		Endif

		Define MsDialog oDlg Title "Log de Processamento" FROM 000, 000 TO 300, 400 Colors 0, 16777215 Pixel

		@ 002, 004 Get oLog Var cLog Of oDlg MultiLine Size 191, 121 Colors 0, 16777215 HScroll Pixel
		oLog:lReadOnly := .T.
		@ 127, 144 Button oBtn Prompt "Ok" Size 051, 019 Action (oDlg:End()) Of oDlg Pixel

		Activate MSDIALOG oDlg Centered

	Endif
	// Fernando em 18/09/2022
	//-----------------------------------------

Return(lRet)
