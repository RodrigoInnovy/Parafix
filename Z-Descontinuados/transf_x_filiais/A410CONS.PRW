#Include "RwMake.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "TbiConn.ch"
#Include "Totvs.ch"                                                 
#Include "FwMvcDef.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ A410CONS  ³ Autor ³                     ³ Data ³19/11/2016³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Ponto Entrada na NF Entrada para incluir botao em Açoes    ³±±
±±³          ³ Relacionadas e tem como objetivo fazer a Transferencia entre±±
±±³          ³ Filial - Tipo Beneficiamento                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ COMPRAS                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function A410CONS()

	Local aButtons := {}
	
	aadd(aButtons,{"NF Entrada"    ,{|| U_a002NFE()}  , "NF Entrada"})
	aadd(aButtons,{"Retorno Filial",{|| U_a002TrfMP()}, "Retorno Filial"})
		
Return(aButtons)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ A002NFE    ³Autor³                       ³ Data ³20.11.2016³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Monta uma tela de Integracao com as nf´S ENTRADA           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Perguntas ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Expo1 = Objeto da getdados                                 ³±±
±±³          ³                                                            ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA410 (A410CONS)                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function a002NFE()
	
	Local _aArea	 := GetArea()
	Local _aAreaSX3	 := SX3->(GetArea())
	Local _aAreaSF1	 := SF1->(GetArea())
	Local _aAreaSD1	 := SD1->(GetArea())
	Local _aAreaSB1	 := SB1->(GetArea())
	Local _aAreaSC5	 := SC5->(GetArea())
	Local _aAreaSC6	 := SC6->(GetArea())
	Local _aAreaDA1	 := DA1->(GetArea())
	
	Local _nPosItem  := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_ITEM"})
	Local _nPProduto := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRODUTO"})
	Local _nPTES     := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_TES"})
	Local _nPQtdVen  := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_QTDVEN"})
	Local _nPPrcVen  := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRCVEN"})
	//  Local _nPDescr   := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_DESCRI"})
	Local _nPTotal   := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_VALOR"})
	Local nY         := 0
	Local nZ         := 0
	Local _cRotina   := "A460NF"
	Local _nModo	 := 1
	
	Local _cFornec   := "" //M->C5_CLIENTE
	Local _cLoja     := "" //M->C5_LOJACLI
	Local _cTabela   := M->C5_TABELA
	Local _cTipo     := M->C5_TIPO
	Local _cTransf   := M->C5_ZZTRANS
	Local _aCpos	 := {}
	Local cAliasSD1	 := "SD1"
	Local _aItemSD1  := {}
	Local _cItem     := StrZero(0,Len(SC6->C6_ITEM))
	Local _cTesTRF   := " "
	Local _cNFE      := space(09)
	Local _cSerie    := space(03)
	Local _cTESSai   := space(03)
	Local _cOperEn   := space(02)
	Local _lRet      := .t.
	Local _nRet      := 0
	Local _lMVZZLibNF:= GetMV("ZZ_LIBNFTR")
	Private _nPrcVen := 0
	
	//  Private aCols    := {}
	
	If _cTransf == "1" //1=Sim -> PV de Transferencia? (M->C5_ZZTRAN)
		If _cTipo == "N" //.and. !Empty(_cFornec+_cLoja)  //Tipo "B" = Beneficamento
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Realiza ajuste no dicionario de dados                              ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			//AjustaSX1(_cRotina)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica as perguntas selecionadas                                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Variaveis utilizadas para parametros                               ³
			//³ mv_par01        // NF Entrada								       ³
			//³ mv_par02        // Serie NF 									   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			Pergunte("A460NF",.T.)
			_cNFE     := mv_par01
			_cSerie   := mv_par02
			_cFornec  := mv_par03
			_cLoja    := mv_par04
			_cTESSai  := mv_par05
			_cOperEn  := mv_par06
			_cTranFil := Posicione("SF4",1,xFilial("SF4")+mv_par05,"F4_TRANFIL")
			_cTesTRF  := Posicione("SF4",1,xFilial("SF4")+mv_par05,"F4_ZZTES")
			
			If _cTranFil == "1" //1=Sim ->Valida se a TES de Entrada esta configurada para Tranferencia
				
				If Empty(_cFornec) .or. Empty(_cLoja)
					Aviso("Fornecedor/Loja", "Fornecedor e/ou Loja nao Informados, corrija!", {"OK"})
				Else
					
					// Montagem da query
					_cAliasSD1 := GetNextAlias()
					_cQuery    := "SELECT SD1.* FROM "+RetSqlName("SD1")+" SD1 "               
					_cQuery    += " WHERE SD1.D1_FILIAL  = '"+xFilial("SD1")+"'"
					_cQuery    += "   AND SD1.D1_DOC     = '"+mv_par01+"'"
					_cQuery    += "   AND SD1.D1_SERIE   = '"+mv_par02+"'"
					_cQuery    += "   AND SD1.D1_FORNECE = '"+_cFornec+"'"
					_cQuery    += "   AND SD1.D1_LOJA    = '"+_cLoja+"'"
					_cQuery    += "   AND SD1.D1_TIPO   in ('B','N') "
					_cQuery    += "   AND SD1.D1_TES    <> ' ' "
					_cQuery    += "   AND SD1.D_E_L_E_T_ = ' ' "
					
					_cQuery    += " ORDER BY "+SqlOrder(SD1->(IndexKey()))
					_cQuery    := ChangeQuery(_cQuery)
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAliasSD1,.T.,.T.)
					aEval(SD1->(dbStruct()), {|x| If(x[2] <> "C", TcSetField(_cAliasSD1,x[1],x[2],x[3],x[4]),Nil)})
					
					DbSelectArea(_cAliasSD1)
					DbGotop()
					If !Eof()
						If len(aCols) == 0 .or. (Len(aCols) == 1 .And. Empty(aCols[len(aCols)][_nPProduto]))
							_cItem := StrZero(0,Len(SC6->C6_ITEM))
							aCols := {}
						Else
							_cItem := aCols[len(aCols)][_nPosItem]
						EndIf
						
						Do While !(_cAliasSD1)->(Eof())
							
							dbSelectArea("SB1")
							dbSetOrder(1)
							dbSeek(xFilial("SB1")+(_cAliasSD1)->D1_COD)
							
							dbSelectArea("DA1") //Busca pelo preço de tabela = "085"
							dbSetOrder(1)
							If dbSeek(xFilial("DA1")+_cTabela+(_cAliasSD1)->D1_COD) //Tabela de precos='085'
								_nPrcVen := DA1->DA1_PRCVEN
							Else
								_nPrcVen := 0
							EndIf
							
							//_lRet := AVldProd(_cAliasSD1) //Valida se Produto ja foi Transferido ou encontra-se no CQ
							_nRet := AVldProd(_cAliasSD1) //Valida se Produto ja foi Transferido ou encontra-se no CQ
							
							If _nRet == 0
								aadd(aCOLS,Array(Len(aHeader)+1))
								
								_cItem := Soma1(_cItem)
								
								For nY:=1 To Len(aHeader)
									If ( AllTrim(aHeader[nY][2]) == "C6_ITEM" )
										aCols[Len(aCols)][nY] := _cItem
									Else
										If (aHeader[nY,2] <> "C6_REC_WT") .And. (aHeader[nY,2] <> "C6_ALI_WT")
											aCols[Len(aCols)][nY] := CriaVar(aHeader[nY][2])
										EndIf
									EndIf
								Next nY
								
								N := Len(aCols)
								
								aCOLS[N][Len(aHeader)+1] := .F.
								
								aCols[N][_nPProduto] := (_cAliasSD1)->D1_COD //_aItemSD1[nX][1]
								A410MultT("M->C6_PRODUTO",(_cAliasSD1)->D1_COD)
								If ExistTrigger("C6_PRODUTO")
									RunTrigger(2,N,Nil,,"C6_PRODUTO")
								Endif
								
								TSAtuaCols(_cAliasSD1, _cTesTRF, _cOperEn, _cTESSai,_cRotina,0,"",_nModo)
							ElseIf _nRet == 1
								
								If !_lMVZZLibNF
									Aviso("AVldProd","NF já utilizada, verifique!",{"OK"})
									//_lRet := .f.
									Exit
								Else
									aadd(aCOLS,Array(Len(aHeader)+1))
									
									_cItem := Soma1(_cItem)
									
									For nY:=1 To Len(aHeader)
										If ( AllTrim(aHeader[nY][2]) == "C6_ITEM" )
											aCols[Len(aCols)][nY] := _cItem
										Else
											If (aHeader[nY,2] <> "C6_REC_WT") .And. (aHeader[nY,2] <> "C6_ALI_WT")
												aCols[Len(aCols)][nY] := CriaVar(aHeader[nY][2])
											EndIf
										EndIf
									Next nY
									
									N := Len(aCols)
									
									aCOLS[N][Len(aHeader)+1] := .F.
									
									aCols[N][_nPProduto] := (_cAliasSD1)->D1_COD //_aItemSD1[nX][1]
									A410MultT("M->C6_PRODUTO",(_cAliasSD1)->D1_COD)
									If ExistTrigger("C6_PRODUTO")
										RunTrigger(2,N,Nil,,"C6_PRODUTO")
									Endif
									
									TSAtuaCols(_cAliasSD1, _cTesTRF, _cOperEn, _cTESSai,_cRotina,0,"",_nModo)
									
								EndIf
								
							ElseIf _nRet == 2
								Aviso("AVldProd","Produto no arnazem de CQ, verifique!",{"OK"})
								//_lRet := .f.
								Exit
							EndIf
							(_cAliasSD1)->(dbSelectArea(_cAliasSD1))
							(_cAliasSD1)->(dbSkip())
						Enddo
						
						//If Len(_cItem) > 1 .and. _lRet
						If Len(_cItem) > 1 .and. _nRet == 0
							//Grava nf no cabeçalho do PV
							M->C5_MENNOTA := _cNFE+"\"+_cSerie
							
							M->C5_TABELA  := if(Empty(M->C5_TABELA),'085',M->C5_TABELA)
							
							(_cAliasSD1)->(dbCloseArea())
							GETDREFRESH()
						EndIf
					Else
						Aviso("NF Entrada", "NF Informada já foi Transferida! Informar um novo nro",{"OK"})
					EndIf
				EndIf
			Else
				Aviso("TES Saida", "A TES de Saida nao esta configurada para Transferencia, corrija!", {"OK"})
			EndIf
		Else
			Aviso("Tipo", "Tipo deve ser 'N'- Normal!", {"OK"})
		EndIf
	Else
		Aviso("C5_ZZTRANS", "Campo Transferencia deve ser igual a Sim para prosseguir", {"OK"})
	EndIf
	
	RestArea(_aAreaSB1)
	RestArea(_aAreaDA1)
	RestArea(_aAreaSD1)
	RestArea(_aAreaSF1)
	RestArea(_aAreaSX3)
	RestArea(_aArea)
	
Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AVldProd     ³ Autor ³                   ³ Data ³ 19.11.16  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Valida se produto Transferido ou se encontra no CQ         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ AVldProd()					                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 = Quantidade                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AVldProd(_cAliasSD1)
	
	Local _aArea	  := GetArea()
	Local _aAreaSD7	  := SD7->(GetArea())
	Local _cSeekSD7   := ""
	Local _aArmazensCQ:={}
	Local _nSaldo     := 0
	//  Local _lRet       := .t.
	Local _nRet       := 0
	
	//Valida se produto já transferido
	If !Empty((_cAliasSD1)->D1_ZZTRF) //.and. !Empty(F1->F1_ZZORIGE)
		_nRet := 1
		//_lRet := .f.
	EndIf
	
	SD7->(dbSetOrder(1))
	//If _lRet
	If _nRet == 0
		// Monta array com os armazens tratados na movimentacao do CQ
		_cSeekSD7   := xFilial('SD7')+(_cAliasSD1)->D1_NUMCQ+(_cAliasSD1)->D1_COD+(_cAliasSD1)->D1_LOCAL
		SD7->(dbSetOrder(1))
		SD7->(dbSeek(_cSeekSD7))
		Do While !SD7->(Eof()) .And. _cSeekSD7 == SD7->D7_FILIAL+SD7->D7_NUMERO+SD7->D7_PRODUTO+SD7->D7_LOCAL
			/*
			If SD7->D7_TIPO >= 1 .And. SD7->D7_TIPO <= 2 .And. SD7->D7_ESTORNO # 'S'
			If aScan(_aArmazensCQ,SD7->D7_LOCDEST) == 0
			AADD(_aArmazensCQ,SD7->D7_LOCDEST)
			EndIf
			EndIf
			*/
			_nSaldo := _nSaldo + (Iif(SD7->D7_TIPO==0,SD7->D7_SALDO,IiF(SD7->D7_TIPO==1 .Or. SD7->D7_TIPO==2,-SD7->D7_QTDE,SD7->D7_QTDE)))
			
			SD7->(dbSkip())
		EndDo
		If _nSaldo > 0
			_nRet := 2
			//_lRet := .f.
		EndIf
	EndIf
	
	
	RestArea(_aAreaSD7)
	RestArea(_aArea)
	
Return(_nRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³TSAtuaCols   ³ Autor ³                   ³ Data ³ 19.11.16  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Move os campos das solicitacoes de compra em aberto.       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A002MovCampos()					                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 = Quantidade                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function TSAtuaCols(_cAliasSD1,_cTesTRF,_cOperEn,_cTESSai,_cRotina,_nQtdSD1,_cOP,_nModo)

	Local _aArea	:= GetArea()
	Local nPosQtd   := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_QTDVEN"})
	Local nPosQtd2  := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_SEGUM"})
	Local _cMVEst	:= Alltrim(GetMV("MV_ESTADO"))
	Local nX        := 0
	Local nSoma     := 0
	Local nSaldo    := 0
	
	Default _nModo  := 1
	
	If _cRotina == "A460NF"          
		cQuery :=        "SELECT SUM(D2_QUANT) AS D2_QUANT,
		cQuery += CRLF + "      ( SELECT SUM(B2_QATU)
		cQuery += CRLF + "          FROM "+RetSqlName("SB2")+" SB2"
		cQuery += CRLF + "          WHERE SB2.B2_FILIAL = '"+ xFilial("SB2") +"'"
		cQuery += CRLF + "            AND SB2.B2_COD    = '"+ (_cAliasSD1)->D1_COD +"'"
		cQuery += CRLF + "            AND SB2.B2_LOCAL  = '"+(_cAliasSD1)->D1_LOCAL+"' ) B2_QATU"
		cQuery += CRLF + "  FROM "+RetSqlName("SD2")+" SD2"
		cQuery += CRLF + " WHERE SD2.D2_FILIAL  = '"+ xFilial("SD2") +"'"
		cQuery += CRLF + "   AND SD2.D2_NFORI   = '"+ (_cAliasSD1)->D1_DOC +"'"
		cQuery += CRLF + "   AND SD2.D2_SERIORI = '"+ (_cAliasSD1)->D1_SERIE +"'"
		cQuery += CRLF + "   AND SD2.D2_ITEMORI = '"+ (_cAliasSD1)->D1_ITEM +"'"
		cQuery += CRLF + "   AND SD2.D2_TIPO    IN ('N')
		cQuery += CRLF + "   AND SD2.D_E_L_E_T_ = ' '
		
		cAliasA := GetNextAlias()
		TcQuery := ChangeQuery(cQuery)
		
		DbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), cAliasA , .T., .T.)
		aEval( SD2->(DbStruct()),{|x| If(x[2] != "C", TcSetField(cAliasA, AllTrim(x[1]), x[2], x[3], x[4]),Nil)})
		aEval( SB2->(DbStruct()),{|x| If(x[2] != "C", TcSetField(cAliasA, AllTrim(x[1]), x[2], x[3], x[4]),Nil)})
		
		_nQtdSD1  := IIf( (cAliasA)->B2_QATU < ((_cAliasSD1)->D1_QUANT - (cAliasA)->D2_QUANT), 0, ((_cAliasSD1)->D1_QUANT - (cAliasA)->D2_QUANT) )

		(cAliasA)->(DbCloseArea())
	EndIf
	
	_nPrcVen := Iif( _nPrcVen <= 0, (_cAliasSD1)->D1_VUNIT, _nPrcVen)
	
	For nX := 1 To Len(aHeader)
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial("SB1")+(_cAliasSD1)->D1_COD)
		
		Do Case
			Case AllTrim(aHeader[nX][2]) == "C6_UM"
				aCols[n][nX] := SB1->B1_UM
			Case AllTrim(aHeader[nX][2]) == "C6_LOCAL"
				aCols[n][nX] := (_cAliasSD1)->D1_LOCAL
			Case AllTrim(aHeader[nX][2]) == "C6_DESCRI"
				aCols[n][nX] := SB1->B1_DESC
			Case AllTrim(aHeader[nX][2]) == "C6_SEGUM"
				aCols[n][nX] := SB1->B1_SEGUM
			Case AllTrim(aHeader[nX][2]) == "C6_QTDVEN"
				aCols[n][nX] := _nQtdSD1 // If(_cRotina =="A460NF",(_cAliasSD1)->D1_QUANT,_nQtdSD1)
			Case AllTrim(aHeader[nX][2]) == "C6_PRUNIT"
				aCols[n][nX] := If(_cRotina =="A460TR",(_cAliasSD1)->D1_VUNIT,_nPrcVen)  //_nPrcVen
			Case AllTrim(aHeader[nX][2]) == "C6_PRCVEN"
				aCols[n][nX] := If(_cRotina =="A460TR",(_cAliasSD1)->D1_VUNIT,_nPrcVen)  //_nPrcVen
			Case AllTrim(aHeader[nX][2]) == "C6_VALOR"
				aCols[n][nX] := (_cAliasSD1)->D1_VUNIT*_nQtdSD1  //Round(If(_cRotina =="A460NF",_nPrcVen * (_cAliasSD1)->D1_QUANT,(_cAliasSD1)->D1_VUNIT*_nQtdSD1),2) //_nPrcVen * If(_cRotina =="A460NF",(_cAliasSD1)->D1_QUANT,_nQtdSD1)
			Case AllTrim(aHeader[nX][2]) == "C6_UNSVEN"
				A410SegUm(.T.)
			Case AllTrim(aHeader[nX][2]) == "C6_OPER"
				aCols[n][nX] := _cOperEn  //mv_par04
			Case AllTrim(aHeader[nX][2]) == "C6_TES"
				aCols[n][nX] := _cTesSai    //mv_par03
			Case AllTrim(aHeader[nX][2]) == "C6_CF"
				If M->C5_TIPO $ "D/B"
					_UF := Alltrim(Posicione("SA2",1,xFilial("SA2")+M->C5_CLIENTE+M->C5_LOJACLI,"A2_EST"))
				Else
					_UF := Alltrim(Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_EST"))
				EndIf
				_cCFOP := SubStr(Posicione("SF4",1,xFilial("SF4")+_cTesTRF,"F4_CF"),2,3)
				aCols[n][nX] := If( _UF == _cMVEst,"5", "6")+_cCFOP
			Case "C6_COMIS" $ AllTrim(aHeader[nX][2])
				aCols[n][nX] := SB1->B1_COMIS
			Case AllTrim(aHeader[nX][2]) == "C6_QTDLIB"
				aCols[n][nX] := 0                                                                                                         
			Case AllTrim(aHeader[nX][2]) == "C6_VALDESC"
				aCols[n][nX] := 0
			Case AllTrim(aHeader[nX][2]) == "C6_DESCONT"
				aCols[n][nX] := 0
			Case AllTrim(aHeader[nX][2]) == "C6_NUMLOTE"
				aCols[n][nX] := (_cAliasSD1)->D1_NUMLOTE
			Case AllTrim(aHeader[nX][2]) == "C6_LOTECTL"
				aCols[n][nX] := (_cAliasSD1)->D1_LOTECTL
			Case AllTrim(aHeader[nX][2]) == "C6_CODISS"
				aCols[n][nX] := RetFldProd(SB1->B1_COD,"B1_CODISS")
			Case AllTrim(aHeader[nX][2]) == "C6_NUMOP"
				aCols[n][nX] := If(_cRotina =="A460NF",CriaVar("C6_OP"),SubStr(_cOP,1,6))
			Case AllTrim(aHeader[nX][2]) == "C6_ITEMOP"
				aCols[n][nX] := If(_cRotina =="A460NF",CriaVar("C6_OP"),SubStr(_cOP,7,2))
			Case AllTrim(aHeader[nX][2]) == "C6_NFORI"
				aCols[n][nX] := (_cAliasSD1)->D1_DOC                     //If(_cRotina =="A460NF",CriaVar("C6_NFORI"),(_cAliasSD1)->D1_DOC)
			Case AllTrim(aHeader[nX][2]) == "C6_SERIORI"
				aCols[n][nX] := (_cAliasSD1)->D1_SERIE                   //If(_cRotina =="A460NF",CriaVar("C6_SERIORI"),(_cAliasSD1)->D1_SERIE)
			Case AllTrim(aHeader[nX][2]) == "C6_ITEMORI"
				aCols[n][nX] := (_cAliasSD1)->D1_ITEM                    //If(_cRotina =="A460NF",CriaVar("C6_ITEMORI"),(_cAliasSD1)->D1_ITEM)
			Case AllTrim(aHeader[nX][2]) == "C6_FCICOD" .And. FindFunction( "XFciGetOrigem" ) //SIGAFIS
				aCols[n][nX] := Upper( XFciGetOrigem( SB1->B1_COD , M->C5_EMISSAO )[2] )
			Case AllTrim(aHeader[nX][2]) == "C6_ZZNFFRT" .and. _nModo == 1                  
				aCols[n][nX] := (_cAliasSD1)->D1_DOC+(_cAliasSD1)->D1_SERIE+(_cAliasSD1)->D1_FORNECE+(_cAliasSD1)->D1_LOJA+(_cAliasSD1)->D1_COD+(_cAliasSD1)->D1_ITEM
		EndCase
		                
		Posicione("SX3",2,"C6_PRCVEN","")                    
		              	
		__ReadVar := "M->C6_PRCVEN"                                             
		If ExistTrigger("C6_PRCVEN")
			RunTrigger( 2, n, Nil, oGetDad, "C6_PRCVEN")
		Endif                                           
	Next nX
	
	aCols[Len(aCols)][Len(aHeader)+1] := IIf(aCols[n][GdFieldPos("C6_QTDVEN",aHeader)]  <= 0, .T., .F.)
	GETDREFRESH()
	
	RestArea(_aArea)
	
Return NIL

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ A002TrfMP ³Autor³                        ³ Data ³30.11.2016³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Transferencia Simbolica das MP´s após apontamentos Prod.   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Perguntas ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Expo1 = Objeto da getdados                                 ³±±
±±³          ³                                                            ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA410 (A410CONS)                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function a002TrfMP()

	Local _aArea	:= GetArea()
	Local _aAreaSX3	:= SX3->(GetArea())
	Local _aAreaSD3	:= SD3->(GetArea())
	Local _aAreaSD1	:= SD1->(GetArea())
	Local _aAreaSB1	:= SB1->(GetArea())
	Local _aAreaSC5	:= SC5->(GetArea())
	Local _aAreaSC6	:= SC6->(GetArea())
	Local _aAreaDA1	:= DA1->(GetArea())
	
	Local _nPosItem := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_ITEM"})
	Local _nPProduto:= aScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRODUTO"})
	Local _nPTES    := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_TES"})
	Local _nPQtdVen := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_QTDVEN"})
	Local _nPPrcVen := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRCVEN"})
	// Local _nPItem   := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_ITEM"})
	Local _nPTotal  := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_VALOR"})
	Local nY        := 0
	Local nZ        := 0
	Local _aNFEs    := {}
	
	Local _cTESSai  := space(03)
	Local _cOperEn  := ""
	
	Local _cCliente := M->C5_CLIENTE
	Local _cLoja    := M->C5_LOJACLI
	Local _cTabela  := M->C5_TABELA
	Local _cTipo    := M->C5_TIPO
	Local _cTransf  := M->C5_ZZTRANS
	Local _aCpos	:= {}
	
	Local cAliasSD3	:= "SD3"
	Local _cTesTRF  := " "
	Local _cTranFil := ""
	Local _cOp      := ""
	Local _cPrdIni  := space(15)
	Local _cPrdFim  := space(15)
	Local _cGrpIni  := space(04)
	Local _cGrpFim  := space(04)
	Local _lRet     := .t.
	Local _cRotina  := "A460TR"
	Local _cCodPrd  := space(15)
	Local _nQtdSD3  :=0
	                                                                   
	Private oMSNewGet1,oDlgMark
	Private _nPrcVen:= 0
	Private _cItemPv:= StrZero(0,Len(SC6->C6_ITEM))
	
	Public _aItemSD3:= {}
	
	If _cTransf == "1" //1=Sim -> PV de Transferencia? (M->C5_ZZTRAN)
		If _cTipo == "B" //.and. !Empty(_cCliente+_cLoja)  //Tipo "N" = Normal
			
			aRet      := {}
			aParamBox := {}
			
			aAdd(aParamBox,{3,"Seleione tipo de Busca",1,{"Por Consumo","Por Item"},50,"",.F.})
			ParamBox(aParamBox,"Teste Parâmetros...",@aRet)
			
			If aRet[1] == 2
				_cRotina :=  "A460TRA"
			Else
				_cRotina :=  "A460TR"
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Realiza ajuste no dicionario de dados                              ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			//AjustaSX1(_cRotina)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica as perguntas selecionadas                                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Variaveis utilizadas para parametros                               ³
			//³ mv_par01        // Produto De								       ³
			//³ mv_par02        // Produto Ate      							   ³
			//³ mv_par03        // Grupo De      							       ³
			//³ mv_par04        // Grupo Ate									   ³
			//³ mv_par05        // Tes Saida    							       ³
			//³ mv_par06        // Tipo Operacao Saida							   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			Pergunte(_cRotina,.T.)
			
			If aRet[1] == 1
				_cPrdIni  := mv_par01
				_cPrdFim  := mv_par02
				_cGrpIni  := mv_par03
				_cGrpFim  := mv_par04
				_cTESSai  := mv_par05
				_cOperEn  := mv_par06
				_cTranFil := Posicione("SF4",1,xFilial("SF4")+mv_par05,"F4_TRANFIL")
				_cTesTRF  := Posicione("SF4",1,xFilial("SF4")+mv_par05,"F4_ZZTES")
			Else
				_cPrdIni  := ""
				_cPrdFim  := "ZZZZZZZ"
				_cGrpIni  := ""
				_cGrpFim  := "ZZZZZZZ"
				_cTESSai  := mv_par01
				_cOperEn  := mv_par02
				_cTranFil := Posicione("SF4",1,xFilial("SF4")+mv_par01,"F4_TRANFIL")
				_cTesTRF  := Posicione("SF4",1,xFilial("SF4")+mv_par01,"F4_ZZTES")
			EndIf
			
			If _cTranFil == "1"  //1=Sim ->Valida se a TES de Entrada esta configurada para Tranferencia
				
				If Empty(_cCliente) .or. Empty(_cLoja)
					Aviso("Cliente/Loja", "Cliente e/ou Loja nao Informados, corrija!", {"OK"})
				Else
					//******************** Cíntia Araujo - 27/06/17 - Inicio
					If aRet[1] == 2
						A02BROWS()
						//******************** Cíntia Araujo - 27/06/17 - Fim
					Else
						// Montagem da query
						_cAliasSD3 := GetNextAlias()
						
						_cQuery := "SELECT 'REQ' as Tipo, D3_COD as Cod, D3_NUMSEQ as NumSeq, sum(D3_QUANT) as Qtde "
						_cQuery	+= "FROM "+ RetSqlName("SD3") +" D3 "
						_cQuery	+= "INNER JOIN "+ RetSqlName("SB1") +" B1 ON B1.B1_FILIAL = '"+xFilial("SB1")+"' and B1.B1_COD = D3.D3_COD "
						_cQuery	+= "         and B1.B1_GRUPO >= '"+ _cGrpIni +"' and B1.B1_GRUPO <= '"+_cGrpFim+"' and B1.D_E_L_E_T_ = ' ' "
						_cQuery	+= "INNER JOIN "+ RetSqlName("SBM") +" BM ON BM.BM_FILIAL = '"+xFilial("SBM")+"' and BM.BM_GRUPO = B1.B1_GRUPO "
						_cQuery	+= "         and BM.BM_ZZTRF = '1' and BM.D_E_L_E_T_ = ' ' "
						_cQuery	+= "WHERE D3.D_E_L_E_T_ = ' ' and "
						_cQuery	+= "D3_FILIAL = '"+xFilial("SD3")+"' and "
						_cQuery	+= "D3_ESTORNO = ' ' and "
						_cQuery	+= "D3_ZZTRF = ' ' and "
						_cQuery	+= "D3_COD >= '"+ _cPrdIni +"' and "
						_cQuery	+= "D3_COD <= '"+ _cPrdFim +"' and "
						_cQuery	+= "LEFT(D3_CF,2) = 'RE' and "
						_cQuery	+= "SUBSTRING(D3_CF,3,1) <> '4' "
						_cQuery	+= "GROUP BY D3_COD, D3_NUMSEQ "
						_cQuery	+= "union all "
						_cQuery += "SELECT 'DEV' as Tipo, D3_COD as Cod, D3_NUMSEQ as NumSeq, sum(D3_QUANT)*-1 as Qtde "
						_cQuery	+= "FROM "+ RetSqlName("SD3") +" D3 "
						_cQuery	+= "INNER JOIN "+ RetSqlName("SB1") +" B1 ON B1.B1_FILIAL = '"+xFilial("SB1")+"' and B1.B1_COD = D3.D3_COD "
						_cQuery	+= "         and B1.B1_GRUPO >= '"+ _cGrpIni +"' and B1.B1_GRUPO <= '"+_cGrpFim+"' and B1.D_E_L_E_T_ = ' ' "
						_cQuery	+= "INNER JOIN "+ RetSqlName("SBM") +" BM ON BM.BM_FILIAL = '"+xFilial("SBM")+"' and BM.BM_GRUPO = B1.B1_GRUPO "
						_cQuery	+= "         and BM.BM_ZZTRF = '1' and BM.D_E_L_E_T_ = ' ' "
						_cQuery	+= "WHERE D3.D_E_L_E_T_ = ' ' and "
						_cQuery	+= "D3_FILIAL = '"+xFilial("SD3")+"' and "
						_cQuery	+= "D3_ESTORNO = ' ' and "
						_cQuery	+= "D3_ZZTRF = ' ' and "
						_cQuery	+= "D3_COD >= '"+ _cPrdIni +"' and "
						_cQuery	+= "D3_COD <= '"+ _cPrdFim +"' and "
						_cQuery	+= "LEFT(D3_CF,2) = 'DE' and "
						_cQuery	+= "SUBSTRING(D3_CF,3,1) <> '4' "
						_cQuery	+= "GROUP BY D3_COD, D3_NUMSEQ "
						_cQuery	+= "ORDER BY D3_COD, D3_NUMSEQ "
						
						_cQuery    := ChangeQuery(_cQuery)
						dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAliasSD3,.T.,.T.)
						aEval(SD3->(dbStruct()), {|x| If(x[2] <> "C", TcSetField(_cAliasSD3,x[1],x[2],x[3],x[4]),Nil)})
						
						dbSelectArea(_cAliasSD3)
						dbGotop()
						If !Eof()
							If len(aCols) == 0 .or. (Len(aCols) == 1 .And. Empty(aCols[len(aCols)][_nPProduto]))
								_cItemPV := StrZero(0,Len(SC6->C6_ITEM))
								aCols := {}
							Else
								
								_cItemPV := aCols[len(aCols)][_nPosItem]
							EndIf
							
							Do While !(_cAliasSD3)->(Eof())
								_cCodPrd :=(_cAliasSD3)->COD
								
								DbSelectArea("SB1")
								DbSetOrder(1)
								DbSeek(xFilial("SB1")+_cCodPrd)
								
								dbSelectArea("DA1") //Busca pelo preço de tabela = "085"
								dbSetOrder(1)
								If dbSeek(xFilial("DA1")+_cTabela+(_cAliasSD3)->COD) //Tabela de precos='085'
									_nPrcVen := DA1->DA1_PRCVEN
								Else
									_nPrcVen := 0
								EndIf
								dbSelectArea(_cAliasSD3)
								While !Eof() .and. (_cAliasSD3)->COD == _cCodPrd
									_nQtdSd3 += (_cAliasSD3)->Qtde
									AADD(_aItemSD3 ,(_cAliasSD3)->NumSeq)
									
									(_cAliasSD3)->(dbSkip())
									
								EndDo
								//Valida se NF Entrada pelo FIFO
								_lRet := AVldNFFifo(_cAliasSD3,_cCodPrd,_nQtdSD3,_cCliente,_cLoja,_cTesTRF,_cOperEn,_cTESSai,_cRotina,_cOP)
								If !_lRet
									Aviso("AVldNFFifo","Não existe NF Classifcada para esse Produto (MP), verifique!",{"OK"})
									_lRet := .f.
									Exit
								EndIf
								_nQtdSD3 := 0
								//(_cAliasSD3)->(dbSelectArea(_cAliasSD3))
								
							Enddo
							If Len(_cItemPV) > 1 .and. _lRet
								
								M->C5_TABELA  := if(Empty(M->C5_TABELA),'085',M->C5_TABELA)
								
								(_cAliasSD3)->(dbCloseArea())
								GETDREFRESH()
							EndIf
						Else
							Aviso("Movimentacoes(SD3)", "Grupo Produto não encontrado em Movimentos da Producao! Informar um novo grupo",{"OK"})
						EndIf
					EndIf
				EndIf
			Else
				Aviso("TES Saida", "A TES de Saida nao esta configurada para Transferencia, corrija!", {"OK"})
			EndIf
		Else
			Aviso("Tipo", "Tipo teve ser 'B'- Beneficiamento!", {"OK"})
		EndIf
	Else
		Aviso("C5_ZZTRANS", "Campo Transferencia deve ser igual a Sim para prosseguir", {"OK"})
	EndIf
	
	RestArea(_aAreaSB1)
	RestArea(_aAreaDA1)
	RestArea(_aAreaSD1)
	RestArea(_aAreaSD3)
	RestArea(_aAreaSX3)
	RestArea(_aArea)

Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AVldNFFIFO  ³ Autor ³                   ³ Data ³ 19.11.16  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Valida NF Entrada Porduto MP x Qtd pelo FIFO               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ AVldNFFifo()					                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 = Quantidade                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AVldNFFifo(_cAliasSD3,_cCodPrd,_nQtdSD3,_cCliente,_cLoja,_cTesTRF,_cOperEn,_cTESSai,_cRotina,_cOP)

	Local _aArea	 := GetArea()
	Local _aAreaSD1	 := SD1->(GetArea())                                                            
	Local _aAreaSD1	 := SD1->(GetArea())
	
	Local _nPProduto := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRODUTO"})
	Local _cAliasSD1 := ""
	Local _lRet      := .t.
	Local _nSaldo    := _nQtdSD3
	Local _nQtdSD1   := 0
	Local _cNFEnt    := PesqPict('SD1','D1_DOC')
	Local _cSeEnt    := PesqPict('SD1','D1_SERIE')
	Local _nModo	 := 2
	Local nY

	//Local _cItem     := PesqPict('SD1','D1_ITEM')
	                                                      
	dbSelectArea("SD1")                                                                                                 
	dbSetOrder(6) //Data Digitacao+Seq
	// Montagem da query
	_cAliasSD1 := GetNextAlias()
	
	_cQuery :=        "SELECT Z8_DOC as D1_DOC, Z8_SERIE as D1_SERIE, Z8_ITEM as D1_ITEM, Z8_EMISSAO as EMISSAO, D1_FORNECE"
	_cQuery += CRLF + ", D1_LOJA, Z8_COD as D1_COD,  D1_UM, D1_NUMLOTE, D1_LOTECTL, D1_LOCAL, D1_VUNIT, Z8_QUANT as D1_QUANT, Z8_SALDO as SALDO "
	_cQuery += CRLF + "  FROM "+ RetSqlName("SZ8") + " Z8 "
	_cQuery += CRLF + " INNER JOIN "+ RetSqlName("SD1") + " D1 
	_cQuery += CRLF + "         ON D1_FILIAL     = Z8_FILDEST 
	_cQuery += CRLF + "        AND D1_DOC        = Z8_DOC 
	_cQuery += CRLF + "        AND D1_SERIE      = Z8_SERIE 
	_cQuery += CRLF + "        AND D1_ITEM       = Z8_ITEM " //RIGHT('0000'+Z8_ITEM,4) "
	_cQuery += CRLF + "        AND D1_FORNECE    = '"+_cCliente+"' 
	_cQuery += CRLF + "        AND D1_LOJA       = '"+_cLoja+"' "
	_cQuery += CRLF + "        AND D1_TES       <> ' ' 
	_cQuery += CRLF + "        AND D1.D_E_L_E_T_ = ' '"
	_cQuery += CRLF + " WHERE Z8.D_E_L_E_T_ = ' ' "
	_cQuery += CRLF + "   AND Z8_FILDEST = '"+cFilAnt+"' "
	_cQuery += CRLF + "   AND Z8_COD     = '"+_cCodPrd+"' "
	_cQuery += CRLF + "   AND Z8_TIPO    = 'R' "
	_cQuery += CRLF + "   AND Z8_SALDO   > 0 "
	_cQuery += CRLF + " ORDER BY Z8_COD, Z8_EMISSAO, Z8_DOC,Z8_ITEM "
		             
	_cQuery := ChangeQuery(_cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAliasSD1,.T.,.T.)
	aEval(SD1->(dbStruct()), {|x| If(x[2] <> "C", TcSetField(_cAliasSD1,x[1],x[2],x[3],x[4]),Nil)})
 	
	dbSelectArea(_cAliasSD1)
	dbGotop()
	If !Eof()
		While !Eof() .and. _nSaldo > 0
			_cNFEnt   := (_cAliasSD1)->D1_DOC
			_cSeEnt   := (_cAliasSD1)->D1_SERIE
			//_cItem    := (_cAliasSD1)->D1_ITEM
			_cCliente := (_cAliasSD1)->D1_FORNECE
			_cLoja    := (_cAliasSD1)->D1_LOJA
			
			If _nSaldo <= (_cAliasSD1)->SALDO
				_nQtdSD1 := _nSaldo
				_nSaldo  := 0
			ELse
				_nQtdSD1 := (_cAliasSD1)->SALDO
				_nSaldo  := _nSaldo - (_cAliasSD1)->SALDO
			EndIf
			
			//Atualiza SD1 - campo Saldo para controle das quantidade já utilizadas
			//AAtualSD1(_cNFEnt,_cSeEnt,_cCodPrd,_cItem,_cCliente,_cLoja,_nQtdSD1)
			
			aadd(aCOLS,Array(Len(aHeader)+1))
			
			
			_cItemPV := Soma1(_cItemPV)
			
			For nY:=1 To Len(aHeader)
				If ( AllTrim(aHeader[nY][2]) == "C6_ITEM" )
					aCols[Len(aCols)][nY] := _cItemPV
				Else
					If (aHeader[nY,2] <> "C6_REC_WT") .And. (aHeader[nY,2] <> "C6_ALI_WT")
						aCols[Len(aCols)][nY] := CriaVar(aHeader[nY][2])
					EndIf
				EndIf
			Next nY
			
			N := Len(aCols)
			
			aCOLS[N][Len(aHeader)+1] := .F.
			
			aCols[N][_nPProduto] := _cCodPrd //_aItemSD1[nX][1]
			A410MultT("M->C6_PRODUTO",_cCodPrd)
			If ExistTrigger("C6_PRODUTO")
				RunTrigger(2,N,Nil,,"C6_PRODUTO")
			Endif
			///Carrega o array aCols com o item
			TSAtuaCols(_cAliasSD1,_cTesTRF,_cOperEn,_cTESSai,_cRotina,_nQtdSD1,_cOP, 1)
			_nQtdSd1 := 0
			
			(_cAliasSD1)->(dbSelectArea(_cAliasSD1))
			(_cAliasSD1)->(dbSkip())
			
		End
	Else
		_lRet := .f.
	EndIf
	//Fecha arquivo trabalho         
	(_cAliasSD1)->(dbCloseArea())
	//Restaura areas salvas
	RestArea(_aAreaSD1)
	RestArea(_aArea)
	
Return(_lRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AAtualSD1   ³ Autor ³                   ³ Data ³ 19.11.16  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Atauliza Saldo do SD1 - Itens da NF Entrada                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ AVldNFFifo()					                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 = Quantidade                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AAtualSD1(_cNFEnt,_cSeEnt,_cCodPrd,_cItem,_cCliente,_cLoja,_nQtdSD1)

	Local _aArea	 := GetArea()
	Local _aAreaSD1	 := SD1->(GetArea())
	
	dbSelectArea("SD1")
	SD1->(dbSetOrder(1))
	If SD1->(dbSeek(xFilial("SD1")+_cNFEnt+_cSeEnt+_cCliente+_cLoja+_cCodPrd+_cItem))
		RecLock("SD1",.f.)
		SD1->D1_ZZSALDO += _nQtdSD1
		If SD1->D1_ZZSALDO == SD1->D1_QUANT
			SD1->D1_ZZTRF   := "S"
		EndIf
		MsUnlock()
	EndIf
	
	RestArea(_aAreaSD1)
	RestArea(_aArea)
	
Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AjustaSX1  ³ Autor ³Microsiga S/A        ³ Data ³ 06/01/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Realiza ajustes no dicionario SX1                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³ AjustaSX1()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ A410CONS                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
/*Static Function AjustaSX1(_cRotina)

	Local _aAreaAnt := GetArea()
	Local _nTamSX1  := Len(SX1->X1_GRUPO)
	Local aAreaAtu	:= GetArea()
	Local aAreaSX1	:= SX1->( GetArea() )
	
	If _cRotina == "A460NF"
		// --- Nro NF Entrada
		PutSX1("A460NF","01","NF Entrada?","NF Entrada?","NF Entrada?","MV_CH1","C",9,0,0,"G",'!Vazio()',;
		"  ","","","mv_par01","","","","","","","","","","","","","","","","",{"nro Nota Fiscal de Entrada "," que devera ser Transferida para Filial"})
		
		// --- Serie NF Entrada
		PutSX1("A460NF","02","Serie     ?","Serie     ?","Serie     ?","MV_CH2","C",3,0,0,"G",'!Vazio()',;
		"  ","","mv_par02","","","","","","","","","","","","","","","","",{"Serie da Nota Fiscal Entrada"," que devera ser Transferida para Filial"})
		
		// --- Fornecedor
		PutSX1("A460NF","03","Fornecedor?","Fornecedor?","Fornecedor?","MV_CH3","C",6,0,0,"G",'!Vazio()',;
		"SA2","","","mv_par03","","","","","","","","","","","","","","","","",{"Codigo Fornecedor da Nota Fiscal de Entrada "," que devera ser Transferida para Filial"})
		
		// --- Loja
		PutSX1("A460NF","04","Loja     ?","Loja     ?","Loja     ?","MV_CH4","C",2,0,0,"G",'!Vazio()',;
		"  ","","mv_par04","","","","","","","","","","","","","","","","",{"Serie da Nota Fiscal Entrada"," que devera ser Transferida para Filial"})
		
	Else
	
		
		// --- Produto De
		PutSX1("A460TR","01","Produto De?","Produto De?","Produto De?","MV_CH1","C",15,0,0,"G",'Vazio() .or. ExistCpo("SB1",mv_par01)',;
		"SB1","","","mv_par01","","","","","","","","","","","","","","","","",{"Codigo Produto (MP) a ser "," transferido para a Filial Origem"})
		// --- Produto Ate
		PutSX1("A460TR","02","Produto Ate?","Produto Ate?","Produto Ate?","MV_CH2","C",15,0,0,"G",'!Vazio() .or. ExistCpo("SB1",mv_par02)',;
		"SB1","","","mv_par02","","","","","","","","","","","","","","","","",{"Codigo Produto (MP) a ser "," transferido para a Filial Origem"})
		// --- Grupo De
		PutSX1("A460TR","03","Grupo De?","Grupo De?","Grupo De?","MV_CH3","C",03,0,0,"G",'Vazio() .or. ExistCpo("SBM",mv_par03)',;
		"SBM","","","mv_par03","","","","","","","","","","","","","","","","",{"GRupo do Produto (MP) a ser "," transferido para a Filial Origem"})
		// --- Grupo Ate
		PutSX1("A460TR","04","Grupo Ate?","Grupo Ate?","Grupo Ate?","MV_CH4","C",03,0,0,"G",'!Vazio() .or. ExistCpo("SBM",mv_par04)',;
		"SBM","","","mv_par04","","","","","","","","","","","","","","","","",{"GRupo do Produto (MP) a ser "," transferido para a Filial Origem"})
		
		
		PutSx1(	_cRotina, "01", "Produto De?"    , "Produto De?"    ,"Produto De?"    , "Mv_ch1", TAMSX3("B1_COD")[3]   , TAMSX3("B1_COD")[1]   , TAMSX3("B1_COD")[2]   , 0,"G",' Vazio() .Or. ExistCpo("SB1",mv_par01)',"SB1","","N","mv_par01","","","","","","","","","","","","","","","","",{"Codigo Produto (MP) a ser "         ," transferido para a Filial Origem", ""},{""},{""},"")
		PutSx1(	_cRotina, "02", "Produto Ate?"   , "Produto Ate?"   ,"Produto Ate?"   , "Mv_ch2", TAMSX3("B1_COD")[3]   , TAMSX3("B1_COD")[1]   , TAMSX3("B1_COD")[2]   , 0,"G",'!Vazio() .Or. ExistCpo("SB1",mv_par02)',"SB1","","N","mv_par02","","","","","","","","","","","","","","","","",{"Codigo Produto (MP) a ser "         ," transferido para a Filial Origem", ""},{""},{""},"")
		PutSx1(	_cRotina, "03", "Grupo De?"      , "Grupo De?"      ,"Grupo De?"      , "Mv_ch3", TAMSX3("B1_GRUPO")[3] , TAMSX3("B1_GRUPO")[1] , TAMSX3("B1_GRUPO")[2] , 0,"G",' Vazio() .Or. ExistCpo("SBM",mv_par03)',"SBM","","N","mv_par03","","","","","","","","","","","","","","","","",{"Grupo do Produto (MP) a ser "       ," transferido para a Filial Origem", ""},{""},{""},"")
		PutSx1(	_cRotina, "04", "Grupo De?"      , "Grupo De?"      ,"Grupo De?"      , "Mv_ch4", TAMSX3("B1_GRUPO")[3] , TAMSX3("B1_GRUPO")[1] , TAMSX3("B1_GRUPO")[2] , 0,"G",'!Vazio() .Or. ExistCpo("SBM",mv_par04)',"SBM","","N","mv_par04","","","","","","","","","","","","","","","","",{"GRupo do Produto (MP) a ser "       ," transferido para a Filial Origem", ""},{""},{""},"")
	EndIf
	
	// --- Codigo TES utilziada na NF de Saida
	PutSX1(_cRotina,"05","TES NF Saida?","TES NF Saida?","TES NF Saida?","MV_CH5","C",3,0,0,"G",'Vazio().Or.ExistCpo("SF4",mv_par05)',;
	"SF4","","","mv_par05","","","","","","","","","","","","","","","","",{"Codigo TES Saida utilizado na Nota "," Fiscal de Saida (Filial)"})
	// --- Tipo Operacao
	PutSX1(_cRotina,"06","TP Oper. Saida?","TP Oper. Saida?","TP Oper. Saida?","MV_CH6","C",2,0,0,"G",'Vazio().Or.ExistCpo("SX5","DJ"+mv_par06)',;
	"DJ","","","mv_par06","","","","","","","","","","","","","","","","",{"Tipo de Operação utilizada"," na Saida da Transferencia."})
	
	PutSx1(	_cRotina, "05", "TES NF Saida?"  , "TES NF Saida?"  ,"TES NF Saida?"  , "Mv_ch5", TAMSX3("F4_CODIGO")[3], TAMSX3("F4_CODIGO")[1], TAMSX3("F4_CODIGO")[2], 0,"G",' Vazio() .Or. ExistCpo("SF4",mv_par05)'     ,"SF4","","N","mv_par05","","","","","","","","","","","","","","","","",{"Codigo TES Saida utilizado na Nota "," Fiscal de Saida (Filial)"        , ""},{""},{""},"")
	PutSx1(	_cRotina, "06", "TP Oper. Saida?", "TP Oper. Saida?","TP Oper. Saida?", "Mv_ch6", TAMSX3("C6_OPER")[3]  , TAMSX3("C6_OPER")[1]  , TAMSX3("C6_OPER")[2]  , 0,"G",' Vazio() .Or. ExistCpo("SX5","DJ"+mv_par06)', "DJ","","N","mv_par06","","","","","","","","","","","","","","","","",{"Tipo de Operação utilizada"         ," na Saida da Transferencia."      , ""},{""},{""},"")
	
	RestArea( aAreaSX1 )
	RestArea( aAreaAtu )
	
	RestArea(_aAreaAnt)

Return

/*
+-------------------------------------------------------------------------------------------------------------------------------------+
| Programa   A02BROWS                                                                                                                 |
|                                                                                                                                     |
| Descricao  Browse para seleção de itens para retorno da filial                                                                      |
+----------+--------------------------------------------+---------+-------------------------------------------------------------------+
| Data     | Autor                                      | Chamado | Descricao                                                         |
+----------+--------------------------------------------+---------+-------------------------------------------------------------------+
|  07/2017 | Cíntia Araujo                              |         | Desenvolvimento Inicial                                           |
+----------+--------------------------------------------+---------+-------------------------------------------------------------------+
*/
Static Function A02BROWS()

	Local   aCoors  := FWGetDialogSize( oMainWnd )
	Local   cMarca  := GetMark()
	Local   aAlter  := {"RETORNA"}
	Local   aCampos := {}
	Local   cQuery  := ""
	Local   nOpcXX  := 0
	
	Private bCampoOK := { || A02CPOK() }
	Private bLinhaOK := { || A02LIOK() }
	Private bTudoOK  := { || A02TDOK() }
	Private cProduto:= CriaVar("B1_COD", .F.)
	Private aColsBKP:= {}
	
	aCoors[3] -= 170
	aCoors[4] -= 343
	
	aadd(aCampos, { "XMARCA"    , , 0, .F., Nil })
	aadd(aCampos, { "Z8_SERIE"  , , 0, .F., Nil })
	aadd(aCampos, { "Z8_DOC"    , , 0, .F., Nil })                          
	aadd(aCampos, { "Z8_ITEM"   , , 0, .F., Nil })
	aadd(aCampos, { "Z8_EMISSAO", , 0, .F., Nil })
	aadd(aCampos, { "Z8_QUANT"  , , 0, .F., Nil })
	aadd(aCampos, { "Z8_SALDO"  , , 0, .F., Nil })
	aadd(aCampos, { "Z8_UM"     , , 0, .F., Nil })
	aadd(aCampos, { "RETORNA"   , , 0, .F., {"Retornar", TamSX3("Z8_SALDO")[3], TamSX3("Z8_SALDO")[1], TamSX3("Z8_SALDO")[2], PesqPict("SZ8","Z8_SALDO")} })
	aadd(aCampos, { "Z8_COD"    , , 0, .F., Nil })
	aadd(aCampos, { "B1_DESC"   , , 0, .F., Nil })                   
	aadd(aCampos, { "XREGS"     , , 0, .F., Nil })
	
	cQuery :=        "SELECT 'LBNO' AS XMARCA, SZ8.*, 0 AS RETORNA, B1_DESC, SZ8.R_E_C_N_O_ AS XREGS"
	cQuery += CRLF + "  FROM "+ RetSqlName("SZ8") + " SZ8 "

	cQuery += CRLF + " INNER JOIN "+ RetSqlName("SD1") + " SD1 "
	cQuery += CRLF + "    ON SD1.D1_FILIAL  = SZ8.Z8_FILDEST 
	cQuery += CRLF + "   AND SD1.D1_DOC     = SZ8.Z8_DOC 
	cQuery += CRLF + "   AND SD1.D1_SERIE   = SZ8.Z8_SERIE 
	cQuery += CRLF + "   AND SD1.D1_ITEM    = SZ8.Z8_ITEM"   //RIGHT('0000'+SZ8.Z8_ITEM,4) "
	cQuery += CRLF + "   AND SD1.D1_FORNECE = '"+ M->C5_CLIENTE +"'"
	cQuery += CRLF + "   AND SD1.D1_LOJA    = '"+ M->C5_LOJACLI +"'"
	cQuery += CRLF + "   AND SD1.D1_TES    <> ' '" 
	cQuery += CRLF + "   AND SD1.D_E_L_E_T_ = ' '"

	cQuery += CRLF + " INNER JOIN  "+ RetSqlName("SB1") + " SB1 "
	cQuery += CRLF + "    ON SB1.B1_FILIAL  = '"+ xFilial("SZ8") +"'"
	cQuery += CRLF + "   AND SB1.B1_COD     = SZ8.Z8_COD
	cQuery += CRLF + "   AND SB1.D_E_L_E_T_ = ' '

	cQuery += CRLF + " WHERE SZ8.Z8_FILIAL  = '"+ xFilial("SZ8") +"'"
	cQuery += CRLF + "   AND SZ8.Z8_FILDEST = '"+ cFilAnt +"' "
	cQuery += CRLF + "   AND SZ8.Z8_TIPO    = 'R'
	cQuery += CRLF + "   AND SZ8.D_E_L_E_T_ = ' ' "
	cQuery += CRLF + "   AND SZ8.Z8_SALDO   > 0 "
	cQuery += CRLF + " ORDER BY SZ8.Z8_EMISSAO DESC, SZ8.Z8_DOC, SZ8.Z8_ITEM"
	                                                           
	aHead   := U_TSHEADER(aCampos)
	aCol    := U_TSCOLS(aHead, cQuery, {"SZ8"} )
	aColsBKP:= aClone(aCol)
	nMax    := Len(aCol) + 999
	nQtdItem:= Len(aCols)
	
	Define MsDialog oDlgMark Title "Seleção de Itens" From aCoors[1], aCoors[2] To aCoors[3], aCoors[4] Pixel
	
	@ 005, 005 GROUP oGrp1 To 025,(aCoors[4]/2)-5 PROMPT ""                    Of oDlgMark Pixel
	@ 012, 010 SAY   oSay1 PROMPT "Produto"          Size 130, 008 Of oDlgMark Pixel
	@ 010, 033 MSGET oGet1 VAR   cProduto  F3 "SB1"  Size 060, 008 Of oDlgMark Pixel Valid( A02SB1(cProduto) .And. ExistCpo("SB1") ) On CHANGE( A02FILT(cProduto,1 ) )
	
	oMSNewGet1 := MsNewGetDados():New( 030, 005, (aCoors[3]/2)-25, (aCoors[4]/2)-5, GD_UPDATE, "Eval(bLinhaOK)", "AllwaysTrue", "", aAlter, , nMax, "Eval(bCampoOK)", "", "AllwaysTrue", oDlgMark, aHead, aCol)
	oMSNewGet1:oBrowse:blDblClick   := {|| If( (nPos := aScan(aAlter,{|y| AllTrim(oMSNewGet1:aHeader[oMSNewGet1:oBrowse:nColPos][2]) == AllTrim(y)}) > 0), oMSNewGet1:EditCell() , Processa( {|| A02EDIT(aAlter,1) }, "Aguarde", "Gerando...",.F.)) }
	oMSNewGet1:oBrowse:BHeaderClick := {|| If( (nPos := aScan(aAlter,{|y| AllTrim(oMSNewGet1:aHeader[oMSNewGet1:oBrowse:nColPos][2]) == AllTrim(y)}) > 0), oMSNewGet1:EditCell() , Processa( {|| A02EDIT(aAlter,2) }, "Aguarde", "Gerando...",.F.)) }
	
	A02FILT(cProduto, 2)
	
	Define sButton oSBut1 From (aCoors[3]/2)-17,(aCoors[4]/2)-060 Type 01 Of oDlgMark Enable Action( lValid := A02CPOK(2,3), IIf(lValid == .T., (A02GRAVA(),oDlgMark:End()), Nil ))
	Define sButton oSBut2 From (aCoors[3]/2)-17,(aCoors[4]/2)-030 Type 02 Of oDlgMark Enable Action( nOpcXX  := 0, oDlgMark:End() )
	
	Activate MsDialog oDlgMark Centered

Return(nQtdItem)                                                                 

/*                                                                                                             
+-------------------------------------------------------------------------------------------------------------------------------------+
| Programa   A02SB1                                                                                                                   |
|                                                                                                                                     |
| Descricao  Valida produto digitado                                                                                                  |
+----------+--------------------------------------------+---------+-------------------------------------------------------------------+
| Data     | Autor                                      | Chamado | Descricao                                                         |
+----------+--------------------------------------------+---------+-------------------------------------------------------------------+
|  07/2017 | Cíntia Araujo                              |         | Desenvolvimento Inicial                                           |
+----------+--------------------------------------------+---------+-------------------------------------------------------------------+
*/
Static Function A02SB1(cProduto)

	Local lRet     := .T.
	Local aArea    := GetArea()
	Local aAreaSB1 := SB1->(GetArea())
	
	If !Empty(cProduto)
		SB1->(DbSetOrder(1))
		If SB1->(!DbSeek( xFilial("SB1") + cProduto ))
			MsgInfo("Produto não econtrado, verifique!","Atenção")
			cProduto := CriaVar("B1_COD", .F.)
			lRet := .F.
		Else
			If SB1->B1_MSBLQL == "1"
				MsgInfo("Produto bloqueado, selecione produto válido!","Atenção")
				cProduto := CriaVar("B1_COD", .F.)
				lRet := .F.
			EndIf
		EndIf
	Else
		MsgInfo("Produto não digitado, verifique!","Atenção")
		lRet := .F.
	EndIf
	
	RestArea(aArea)
	RestArea(aAreaSB1)
	
	oGet1:Refresh()
	
Return(lRet)

/*
+-------------------------------------------------------------------------------------------------------------------------------------+
| Funcao   : A02FILT                                                                                                                  |
|                                                                                                                                     |
| Descricao: Filtra Browse conforme produto digitado                                                                                  |
|                                                                                                                                     |
+----------+--------------------------------------------+---------+-------------------------------------------------------------------+
| Data     | Autor                                      | Chamado | Descricao                                                         |
+----------+--------------------------------------------+---------+-------------------------------------------------------------------+
| 01/2017  | Cintia Araujo                              |         | Desenvolvimento inicial                                            |
+----------+--------------------------------------------+---------+-------------------------------------------------------------------+
*/
Static Function A02FILT(cProduto, nTpFiltro)

	Local   nLin    := oMSNewGet1:oBrowse:nAt
	Local   nCol    := oMSNewGet1:oBrowse:ColPos
	Local   nMarca  := GdFieldPos("XMARCA" ,oMSNewGet1:aHeader)               
	Local   nRec    := GdFieldPos("XREGS"  ,oMSNewGet1:aHeader)
	Local   cCodig  := GdFieldPos("Z8_COD" ,oMSNewGet1:aHeader)
	Local   nQdtRet := GdFieldPos("RETORNA",oMSNewGet1:aHeader)    
	Local 	_n1
	Local 	_n2
	
	Default nTpFiltro := 2
	
	If !Empty(cProduto)
			For _n1 := 1 To Len(oMSNewGet1:aCols)
			If (nPos := aScan(aColsBKP, {|y| y[nRec] ==  oMSNewGet1:aCols[_n1][nRec] })) > 0       
				aColsBKP[nPos][nMarca]  := oMSNewGet1:aCols[_n1][nMarca]
				aColsBKP[nPos][nQdtRet] := oMSNewGet1:aCols[_n1][nQdtRet]
			EndIf
		Next _n1
		
		aCol := {}
		For _n2 := 1 To Len(aColsBKP)
			If aColsBKP[_n2][cCodig] == cProduto
				aadd(aCol, aColsBKP[_n2])                                        
			EndIf                                	
		Next _n2
	Else
		aCol := {}
	EndIf
	
	If Len(aCol) <= 0
		aCol := U_TSCOLS(oMSNewGet1:aHeader, "", {} )

		If nTpFiltro := 1 .And. !Empty(cProduto)
			msgInfo("Não há dados para o produto selecionado","Atenção")
		EndIf
	EndIf
	
	oMSNewGet1:aCols := aClone(aCol)
	oMSNewGet1:Refresh()

Return()

/*
+-------------------------------------------------------------------------------------------------------------------------------------+
| Programa   A02EDIT                                                                                                                  |
|                                                                                                                                     |
| Descricao  Edita campos os marca brose                                                                                              |
+----------+--------------------------------------------+---------+-------------------------------------------------------------------+
| Data     | Autor                                      | Chamado | Descricao                                                         |
+----------+--------------------------------------------+---------+-------------------------------------------------------------------+
|  07/2017 | Cíntia Araujo                              |         | Desenvolvimento Inicial                                           |
+----------+--------------------------------------------+---------+-------------------------------------------------------------------+
*/
Static Function A02EDIT(aAlter, nTipo)

	Local   nLin    := oMSNewGet1:oBrowse:nAt
	Local   nCol    := oMSNewGet1:oBrowse:ColPos
	Local   nMarca  := GdFieldPos("XMARCA",oMSNewGet1:aHeader)
	Local   cCampo  := oMSNewGet1:aHeader[nCol][2]
	Local 	_n1
	
	If nTipo == 1
		If nPos := aScan(aAlter,{|y| AllTrim(cCampo) == AllTrim(y)}) <= 0
			oMSNewGet1:aCols[nLin][nMarca] := IIf( oMSNewGet1:aCols[nLin][nMarca] == "LBOK", "LBNO", "LBOK")
		Else
			oMSNewGet1:EditCell()
		EndIf
	Else
		For _n1 := 1 To Len(oMSNewGet1:aCols)
			oMSNewGet1:aCols[_n1][nMarca] := IIf( oMSNewGet1:aCols[_n1][nMarca] == "LBOK", "LBNO", "LBOK")
		Next _n1
	EndIf
	
	oMSNewGet1:Refresh()

Return()

/*
+-------------------------------------------------------------------------------------------------------------------------------------+
| Programa   A02LIOK                                                                                                                  |
|                                                                                                                                     |
| Descricao Validação LinhaOK do Grid                                                                                                 |
+----------+--------------------------------------------+---------+-------------------------------------------------------------------+
| Data     | Autor                                      | Chamado | Descricao                                                         |
+----------+--------------------------------------------+---------+-------------------------------------------------------------------+
|  07/2017 | Cíntia Araujo                              |         | Desenvolvimento Inicial                                           |
+----------+--------------------------------------------+---------+-------------------------------------------------------------------+
*/
Static Function A02LIOK()
	Local lValid  := A02CPOK(1, 2)
Return(lValid)

/*
+-------------------------------------------------------------------------------------------------------------------------------------+
| Programa   A02TDOK                                                                                                                  |
|                                                                                                                                     |
| Descricao  Validação TudoOK do Grid                                                                                                 |
+----------+--------------------------------------------+---------+-------------------------------------------------------------------+
| Data     | Autor                                      | Chamado | Descricao                                                         |
+----------+--------------------------------------------+---------+-------------------------------------------------------------------+
|  07/2017 | Cíntia Araujo                              |         | Desenvolvimento Inicial                                           |
+----------+--------------------------------------------+---------+-------------------------------------------------------------------+
*/
Static Function A02TDOK()
	Local lValid  := A02CPOK(2, 3)
Return(lValid)

/*
+-------------------------------------------------------------------------------------------------------------------------------------+
| Programa   A02CPOK                                                                                                                  |
|                                                                                                                                     |
| Descricao  Validação CampoOK do Grid                                                                                                |
+----------+--------------------------------------------+---------+-------------------------------------------------------------------+
| Data     | Autor                                      | Chamado | Descricao                                                         |
+----------+--------------------------------------------+---------+-------------------------------------------------------------------+
|  07/2017 | Cíntia Araujo                              |         | Desenvolvimento Inicial                                           |
+----------+--------------------------------------------+---------+-------------------------------------------------------------------+
*/
Static Function A02CPOK(nTipo, nAcao)

	Local   nQdtDis := GdFieldPos("Z8_SALDO",oMSNewGet1:aHeader)
	Local   nQdtRet := GdFieldPos("RETORNA" ,oMSNewGet1:aHeader)
	Local   nMarca  := GdFieldPos("XMARCA"  ,oMSNewGet1:aHeader)
	Local   lValid  := .T.
	Local   cMensag := ""
	Local   cMensag1:= ""
	Local 	_n3
	
	Default nTipo   := 1
	Default nAcao   := 1
	
	nLinha  := oMSNewGet1:nAt
	nColuna := oMSNewGet1:oBrowse:ColPos
	nNomCol := oMSNewGet1:aHeader[nColuna, 2]
	
	If nTipo == 1
		nDe  := nLinha
		nAte := nLinha
	Else
		nDe  := nLinha
		nAte := Len(oMSNewGet1:aCols)
	EndIf
	
	For _n3 := nDe To nAte
		If nTipo == 1
			If oMSNewGet1:aCols[_n3][nMarca] == "LBOK"
				If Iif(nAcao == 2 .Or. nAcao == 3, oMSNewGet1:aCols[_n3][nQdtRet], M->RETORNA) <= 0
					cMensag += "Produto sem quantidade de retorno" + CRLF
				ElseIf Iif(nAcao == 2 .Or. nAcao == 3, oMSNewGet1:aCols[_n3][nQdtRet], M->RETORNA) >  oMSNewGet1:aCols[_n3][nQdtDis]
					cMensag += "Quantidade de retorno superior ao saldo" + CRLF
				EndIf
			Else
				If Iif(nAcao == 2 .Or. nAcao == 3, oMSNewGet1:aCols[_n3][nQdtRet], M->RETORNA) > 0
					If Iif(nAcao == 2 .Or. nAcao == 3, oMSNewGet1:aCols[_n3][nQdtRet], M->RETORNA) <= 0
						cMensag += "Produto sem quantidade de retorno" + CRLF
					ElseIf Iif(nAcao == 2 .Or. nAcao == 3, oMSNewGet1:aCols[_n3][nQdtRet], M->RETORNA) >  oMSNewGet1:aCols[_n3][nQdtDis]
						cMensag += "Quantidade de retorno superior ao saldo" + CRLF
					Else
						oMSNewGet1:aCols[_n3][nMarca] := "LBOK"
					EndIf
				EndIf
			EndIf
		Else
			If oMSNewGet1:aCols[_n3][nMarca] == "LBOK"  .And. (Iif(nAcao == 2 .Or. nAcao == 3, oMSNewGet1:aCols[_n3][nQdtRet], M->RETORNA) <= 0 .Or.;
				Iif(nAcao == 2 .Or. nAcao == 3, oMSNewGet1:aCols[_n3][nQdtRet], M->RETORNA) >  oMSNewGet1:aCols[_n3][nQdtDis])
				cMensag1 += "Produto na linha "+StrZero(_n3,3)+ CRLF
			EndIf
		EndIf
	Next _n3
	
	If nTipo <> 1 .And. !Empty(cMensag1)
		cMensag += "Existe(m) produto(s) com quantidade de retorno inválida, verifique!"+ CRLF+ CRLF
	EndIF
	
	If !Empty(cMensag+cMensag1)
		cMen := Iif(!Empty(cMensag ), cMensag  + CRLF,;
		Iif(!Empty(cMensag1), cMensag1 + CRLF, "" ))
		
		lValid := .F.
		Aviso("Validação de dados",cMen,{"OK"})
	EndIf                                                         
                                                                                     
Return(lValid)                                      

/*
+-------------------------------------------------------------------------------------------------------------------------------------+
| Programa   A02GRAVA                                                                                                                 |
|                                                                                                                                     |
| Descricao  Carrega dados selecionado para aCols do Pedido de Vendas                                                                 |
+----------+--------------------------------------------+---------+-------------------------------------------------------------------+
| Data     | Autor                                      | Chamado | Descricao                                                         |
+----------+--------------------------------------------+---------+-------------------------------------------------------------------+
|  07/2017 | Cíntia Araujo                              |         | Desenvolvimento Inicial                                           |
+----------+--------------------------------------------+---------+-------------------------------------------------------------------+
*/
Static Function A02GRAVA()

	Local   nQdtDis    := GdFieldPos("Z8_SALDO"  ,oMSNewGet1:aHeader)
	Local   nQdtRet    := GdFieldPos("RETORNA"   ,oMSNewGet1:aHeader)                              
	Local   nMarca     := GdFieldPos("XMARCA"    ,oMSNewGet1:aHeader)
	Local   nProdu     := GdFieldPos("Z8_COD"    ,oMSNewGet1:aHeader)
	Local   _nPProduto := GdFieldPos("C6_PRODUTO", aHeader) 
	Local 	ny
	Local 	_n1

	_cTESSai := mv_par01
	_cOperEn := mv_par02
	_cTesTRF := Posicione("SF4",1,xFilial("SF4")+mv_par01,"F4_ZZTES")
	                                                       
	RegToMemory("SC6", .T.)
                                                                                      
	A02FILT( oMSNewGet1:aCols[oMSNewGet1:nAt][nProdu], 2 )
	     
	aSort(aColsBKP,,,{|x,y| x[1]+x[10] < y[1]+y[10] })
	
	For _n1 := 1 To Len(aColsBKP)
		If aColsBKP[_n1][nMarca] == "LBOK"
			If aColsBKP[_n1][nQdtRet] <= 0 .Or. aColsBKP[_n1][nQdtRet] >  aColsBKP[_n1][nQdtDis]
				MsgInfo("Existe produto selecionado, sem quantidade de retorno, verifique!","Atenção")
			Else
				If Len(aCols) > 0
					If !Empty(aCols[Len(aCols)][_nPProduto])
						aadd(aCols,Array(Len(aHeader)+1))
						aCols[Len(aCols)][Len(aHeader)+1] := .F.
					EndIf
				EndIf
				
				_cItem := StrZero(Len(aCols),2)
				
				For nY:= 1 To Len(aHeader)
					If ( AllTrim(aHeader[nY][2]) == "C6_ITEM" )
						aCols[Len(aCols)][nY] := _cItem
						
					ElseIf ( AllTrim(aHeader[nY][2]) == "C6_QTDVEN" )
						aCols[Len(aCols)][nY] := aColsBKP[_n1][nQdtRet]
						
					Else
						If (aHeader[nY,2] <> "C6_REC_WT") .And. (aHeader[nY,2] <> "C6_ALI_WT")
							aCols[Len(aCols)][nY] := CriaVar(aHeader[nY][2])
						EndIf
					EndIf
				Next nY
				
				n := Len(aCols)
				aCols[n][Len(aHeader)+1] := .F.
				aCols[n][GdFieldPos("C6_PRODUTO", aHeader)] := aColsBKP[_n1][GdFieldPos("Z8_COD", oMSNewGet1:aHeader)]
				aCols[n][GdFieldPos("C6_TES"    , aHeader)] := Mv_Par01
				aCols[n][GdFieldPos("C6_OPER"   , aHeader)] := Mv_Par02
				aCols[n][GdFieldPos("C6_DESCRI" , aHeader)] := Posicione("SB1", 1, xFilial("SB1") + aColsBKP[_n1][GdFieldPos("Z8_COD", oMSNewGet1:aHeader)], "B1_DESC")
				
				SZ8->(DbGoTo( aColsBKP[_n1][GdFieldPos("XREGS",oMSNewGet1:aHeader)] ))
				If SZ8->(Recno()) == aColsBKP[_n1][GdFieldPos("XREGS",oMSNewGet1:aHeader)]
					SD2->(DbSetOrder(3))
					If SD2->(DbSeek(  xFilial("SD2") + SZ8->Z8_DOC + SZ8->Z8_SERIE + SZ8->Z8_CLIFOR + SZ8->Z8_LOJA + SZ8->Z8_COD + SZ8->Z8_ITEM ))
						aCols[n][GdFieldPos("C6_PRCVEN", aHeader)] := SD2->D2_PRCVEN
						aCols[n][GdFieldPos("C6_UM"    , aHeader)] := SD2->D2_UM
					EndIf
				EndIf                                            
				
				M->C6_PRODUTO := aCols[n][GdFieldPos("C6_PRODUTO", aHeader)]
				M->C6_TES     := aCols[n][GdFieldPos("C6_TES"    , aHeader)]
				M->C6_PRCVEN  := aCols[n][GdFieldPos("C6_PRCVEN" , aHeader)]
				M->C6_PRCVEN  := aCols[n][GdFieldPos("C6_PRCVEN" , aHeader)]
				
				Posicione("SX3",2,"C6_PRCVEN","")                    
				              	
				__ReadVar := "M->C6_PRCVEN"                                             
				If ExistTrigger("C6_PRCVEN")
					RunTrigger( 2, n, Nil, oGetDad, "C6_PRCVEN")
				Endif
				
				Posicione("SX3",2,"C6_PRODUTO","")
				                                             
				__ReadVar := "M->C6_PRODUTO"
//				A410MultT("M->C6_PRODUTO", aColsBKP[_n1][GdFieldPos("Z8_COD", oMSNewGet1:aHeader)] )
				If ExistTrigger("C6_PRODUTO")
					RunTrigger( 2, n, Nil, oGetDad, "C6_PRODUTO")
				Endif
				
				Posicione("SX3",2,"C6_TES","")                                            
				
				__ReadVar := "M->C6_TES"                        
				If ExistTrigger("C6_TES")
					RunTrigger( 2, n, Nil, oGetDad, "C6_TES")
				Endif     
				
				cProd  := aColsBKP[_n1][GdFieldPos("Z8_COD"   , oMSNewGet1:aHeader)]
				nQtdV  := aColsBKP[_n1][GdFieldPos("RETORNA"  , oMSNewGet1:aHeader)]
				cDoc   := aColsBKP[_n1][GdFieldPos("Z8_DOC"   , oMSNewGet1:aHeader)]
				cSerie := aColsBKP[_n1][GdFieldPos("Z8_SERIE" , oMSNewGet1:aHeader)]
				nItem  := aColsBKP[_n1][GdFieldPos("Z8_ITEM"  , oMSNewGet1:aHeader)]
				cForne := M->C5_CLIENTE
				cLoja  := M->C5_LOJACLI            	        
					
				If SD1->(DbSeek( cFilAnt + cDoc + cSerie + cForne + cLoja + cProd + RIGHT("0000"+nItem,4) ))
					TSAtuaCols("SD1",_cTesTRF,_cOperEn,_cTESSai,"A460TR",nQtdV,"", 1)
				EndIf
			EndIf
		EndIf                                              
	Next _n1

	GETDREFRESH()

Return()
 
/*
+-------------------------------------------------------------------------------------------------------------------------------------+
| Funcao   : fHEADER                                                                                                                  |
|                                                                                                                                     |
| Descricao: Função generica para montar Header da NewGetDados                                                                        |
|                                                                                                                                     |
+----------+--------------------------------------------+---------+-------------------------------------------------------------------+
| Data     | Autor                                      | Chamado | Descricao                                                         |
+----------+--------------------------------------------+---------+-------------------------------------------------------------------+
| 11/2016  | Cintia Araujo - personaleti.com.br         | ??????? | desenvolvimento inicial                                           |
+----------+--------------------------------------------+---------+-------------------------------------------------------------------+
*/
User Function TSHEADER(aCpos)

	Local   aHead := {}
	Local 	nX
	Default aCpos := {}
	
	DbSelectArea("SX3")
	SX3->(DbSetOrder(2))
	For nX := 1 to Len(aCpos)
		If SX3->(DbSeek(aCpos[nX,1]))
			nTam   :=  Iif(aCpos[nX,3] <= 0  , getSX3Cache(aCpoS[nX], "X3_TAMANHO"), aCpos[nX,3])
			cValid :=  Iif(aCpos[nX,4] == .T., getSX3Cache(aCpoS[nX], "X3_VALID"), "")
			
			If ValType(aCpos[nX,5]) == "A"
				nTam   :=  Iif(aCpos[nX,3] <= 0, aCpos[nX,5][3], aCpos[nX,3])
				
				Aadd(aHead, {aCpos[nX,5][1],aCpos[nX][2],aCpos[nX,5][5],nTam,aCpos[nX,5][4],cValid,getSX3Cache(aCpoS[nX], "X3_USADO"),;
				getSX3Cache(aCpoS[nX], "X3_TIPO"),getSX3Cache(aCpoS[nX], "X3_F3"),getSX3Cache(aCpoS[nX], "X3_CONTEXT"),getSX3Cache(aCpoS[nX], "X3_CBOX"),getSX3Cache(aCpoS[nX], "X3_RELACAO")})
			Else
				Aadd(aHead, {AllTrim(X3Titulo()),getSX3Cache(aCpoS[nX], "X3_CAMPO"),getSX3Cache(aCpoS[nX], "X3_PICTURE"),nTam,getSX3Cache(aCpoS[nX], "X3_DECIMAL"),cValid,getSX3Cache(aCpoS[nX], "X3_USADO"),;
				getSX3Cache(aCpoS[nX], "X3_TIPO"),getSX3Cache(aCpoS[nX], "X3_F3"),getSX3Cache(aCpoS[nX], "X3_CONTEXT"),getSX3Cache(aCpoS[nX], "X3_CBOX"),getSX3Cache(aCpoS[nX], "X3_RELACAO")})
			Endif
		Else
			If LEFT(aCpos[nX,1],5) == "XREGS"
				Aadd(aHead, {"Registro",aCpos[nX,1],"",10,0,"","","N","","","",""})
				
			ElseIf AllTrim( aCpos[nX,1] ) $ 'TMP_OK.XMARCA'
				Aadd( aHead,{ '',AllTrim( aCpos[nX,1] ),'@BMP', 2, 0, '','','','','','','' } )
				
			ElseIf AllTrim( aCpos[nX,1] ) == 'LEGEND'
				Aadd( aHead,{ '',	'LEGEND',	'@BMP', 2, 0, '','','','','','','' } )
				
			ElseIf ValType(aCpos[nX,5]) == "A"
				nTam   :=  Iif(aCpos[nX,3] <= 0, aCpos[nX,5][3], aCpos[nX,3])
				
				Aadd(aHead, {aCpos[nX,5][1], aCpos[nX][1],aCpos[nX,5][5],nTam,aCpos[nX,5][4],"","",aCpos[nX,5][2],"","","",""})
			Endif
		Endif
	Next nX

Return(aHead)

/*
+-------------------------------------------------------------------------------------------------------------------------------------+
| Funcao   : fCOLS                                                                                                                  |
|                                                                                                                                     |
| Descricao: Função para montar o Array aCols da NewGetDados                                                                          |
|                                                                                                                                     |
+----------+--------------------------------------------+---------+-------------------------------------------------------------------+
| Data     | Autor                                      | Chamado | Descricao                                                         |
+----------+--------------------------------------------+---------+-------------------------------------------------------------------+
| 11/2016  | Cintia Araujo - personaleti.com.br         | ??????? | desenvolvimento inicial                                           |
+----------+--------------------------------------------+---------+-------------------------------------------------------------------+
*/
User Function TSCOLS(aHd, cQuery, aTables, cContad)

	Local   aCL    := {}
	Local 	_w1
	Local 	_n1
	Default aHd    := {}
	Default cQuery := ""
	Default aTables := {}
	
	If !Empty(cQuery)
		nCont   := 0
		nTotReg := 0
		cAliasA := GetNextAlias()
		TcQuery := ChangeQuery(cQuery)
		
		DbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), cAliasA , .T., .T.)
		For _w1 := 1 To Len(aTables)
			aEval( &(aTables[_w1])->(DbStruct()),{|x| If(x[2] != "C", TcSetField(cAliasA, AllTrim(x[1]), x[2], x[3], x[4]),Nil)})
		Next _w1
		
		DbSelectArea( cAliasA )
		(cAliasA)->( DbEval( { || nTotReg++ },,{ || !Eof() } ) )
		(cAliasA)->( DbGoTop() )
		
		ProcRegua( nTotReg )
		
		If (cAliasA)->(!Eof())
			While (cAliasA)->(!Eof())
				IncProc( "Registro "+StrZero(++nCont,6)+" de "+StrZero(nTotReg,6) )
				
				aadd(aCL,Array(Len(aHd)+1))
				For _n1 := 1 To Len(aHd)
					aCL[Len(aCL),_n1] := (cAliasA)->&(aHd[_n1][2])
				Next _n1
				aCL[Len(aCL),Len(aHd)+1] := .F.
				
				(cAliasA)->(DbSkip())
			End-While
		EndIf
		(cAliasA)->(DbCloseArea())
	EndIf
	
	If Len(aCL) <= 0
		aadd(aCL,Array(Len(aHd)+1))
		
		For _n1 := 1 To Len(aHd)
			If aHd[_n1,8] == "C"
				nCriaV	:= Space(aHd[_n1,4])
			ElseIf aHd[_n1,8] == "N"
				nCriaV	:= 0
			ElseIf aHd[_n1,8] == "L"
				nCriaV	:= .F.
			ElseIf aHd[_n1,8] == "D"
				nCriaV	:= Ctod("")
			Else
				nCriaV	:= ""
			EndIf
			
			aCL[Len(aCL),_n1] := Iif( LEFT(aHd[_n1][2],5) == "XREGS", 0, nCriaV )
			
			If !Empty(cContad) .And. AllTrim(aHd[_n1,2]) == cContad
				aCL[Len(aCL),_n1] := StrZero(Len(aCL),TamSx3(cContad)[1])
			EndIf
		Next _n1
		aCL[Len(aCL),Len(aHd)+1] := .F.
	EndIf
	
Return(aCl)        
