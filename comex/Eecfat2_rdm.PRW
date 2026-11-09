#Include "Average.ch"

/*
	//	Programa......: EecFat2_rdm.prw
	//	Objetivo......: Pontos de entrada do programa EECFAT2.PRW
	//	Autor.........: Fernando Pereira
	//	Data/Hora.....: 15/01/2019 - 11:40
*/

*********************************
User Function Eecfat2()
*********************************
Local cParam := If(Type("PARAMIXB") == "A", ParamIxb[1],ParamIxb)
Local lRet   := .t.    
Local xcPedcli := M->EE7_REFIMP

*********************************
Begin Sequence
*********************************
If cParam == "PE_GRVCAPA"
	****************************************************************************************************
	// Os campos abaixo foram customizados pela Totvs e são obrigatíorios.
	// Na gravação do Pedido de Exportação,há a necessidade de gravar informações nestes campos.
	****************************************************************************************************
	nTaxaEE7 := 0
	If M->EE7_DESPIN+M->EE7_SEGPRE+M->EE7_FRPREV <> 0 //M->EE7_DESPES+M->EE7_SEGPRE+M->EE7_FRPREV <> 0
		cAliasEE7 := GetArea()
		If SM2->(DBSeek(dDataBase))
			cMoedEE7  := M->EE7_MOEDA
			Do Case
				Case cMoedEE7 == "US$"
					nTaxaEE7 := SM2->M2_MOEDA2
				Case cMoedEE7 == "EUR"
					nTaxaEE7 := SM2->M2_MOEDA3
			EndCase
		Else
			Alert("Não existe PTAX no financeiro para a moeda do Pedido de Exportação!"+chr(13)+chr(10)+"Favor Solicitar ajuste ao Dpto Financeiro!")
		EndIf
		RestArea(cAliasEE7)
	Endif
	Aadd(aCab, {"C5_MENNOTA" ,M->EE7_MENNOT					 	,nil})	   // Mensagem Nota
	aAdd(aCab, {"C5_TPFRETE" ,Iif(M->EE7_FRPPCC == "PP","F","C"),nil})
	Aadd(aCab, {"C5_PESOL"   ,M->EE7_PESLIQ 					,nil})     // Envia peso Liq  do P.export para P.Faturamento
	Aadd(aCab, {"C5_PBRUTO"  ,M->EE7_PESBRU 					,nil})     // Envia peso Bru  do P.export para P.Faturamento
	Aadd(aCab, {"C5_ESPECI1" ,M->EE7_ESPECI 					,nil})     // Envia Descricao  do Volume  para P.Faturamento
	Aadd(aCab, {"C5_VOLUME1" ,M->EE7_VOLUME  					,nil})     // Envia Quantidade de volumes P. Faturamento
	Aadd(aCab, {"C5_DESPESA" ,M->EE7_DESPIN * nTaxaEE7			,nil})     // Envia Quantidade de volumes P. Faturamento
	Aadd(aCab, {"C5_ESPECI2" ,""   								,nil})     // Envia Descricao  do Volume  para P.Faturamento
	Aadd(aCab, {"C5_VOLUME2" ,0  								,nil})     // Envia Quantidade de volumes P. Faturamento
	Aadd(aCab, {"C5_ESPECI3" ,"" 								,nil})     // Envia Descricao  do Volume  para P.Faturamento
	Aadd(aCab, {"C5_VOLUME3" ,0  								,nil})     // Envia Quantidade de volumes P. Faturamento
	Aadd(aCab, {"C5_ESPECI4" ,"" 								,nil})     // Envia Descricao  do Volume  para P.Faturamento
	Aadd(aCab, {"C5_VOLUME4" ,0  								,nil})     // Envia Quantidade de volumes P. Faturamento
	Aadd(aCab, {"C5_SEGURO"  ,M->EE7_SEGPRE * nTaxaEE7			,nil})     // Envia Quantidade de volumes P. Faturamento
	Aadd(aCab, {"C5_FRETE"   ,M->EE7_FRPREV * nTaxaEE7			,nil})     // Envia Quantidade de volumes P. Faturamento
	Aadd(aCab, {"C5_NOMECLI" ,M->EE7_IMPODE  					,nil})     // Envia Quantidade de volumes P. Faturamento
Endif
If cParam == "PE_GRVITEM"    
					aAdd(aReg ,{"C6_LOCAL",WORKIT->EE8_LOCAL,nil})
				    aAdd(aReg ,{"C6_PEDCLI",xcPedcli,nil})
					// PREENCHER CAMPO C6_ZZDTCLI
					 AAdd(aReg, {"C6_ZZDTCLI", EE8->EE8_ZZDTC, Nil})

	xnPosNPX     := aScan(aReg,{|x| Alltrim(x[1]) == "C6_DTENTRG"})
	xnPosCLI     := aScan(aReg,{|x| Alltrim(x[1]) == "C6_ZZDTCLI"})
	xnPValor	 := aScan(aReg,{|x| AllTrim(x[1]) == "C6_VALOR"  })
	If xnPValor == 0
		aAdd(aReg,{"C6_VALOR",(WORKIT->EE8_SLDINI * WORKIT->EE8_PRECO),nil})
		xnPValor	 := aScan(aReg,{|x| AllTrim(x[1]) == "C6_VALOR"  })
	Endif
	xnPQtdVen	 := aScan(aReg,{|x| AllTrim(x[1]) == "C6_QTDVEN" })
	xnPVunit	 := aScan(aReg,{|x| AllTrim(x[1]) == "C6_PRCVEN" })
	xcPdCli      := aScan(aReg,{|x| AllTrim(x[1]) == "C6_PEDCLI" })
	IF xnPosNPX > 0
		aReg[xnPosNPX, 2] := WORKIT->EE8_DTENPX
	Endif
	IF xcPdCli >  0
		aReg[xcPdCli, 2]  := xcPedcli  
	Endif
	IF xnPosCLI > 0
		aReg[xnPosCLI, 2] := WORKIT->EE8_ZZDTC
	Endif
	IF xnPQtdVen > 0
		aReg[xnPQtdVen, 2]:= WORKIT->EE8_SLDINI
	Endif
	IF xnPVunit > 0
		aReg[xnPVunit, 2] := Round(WORKIT->EE8_PRECO,4)
	Endif
	cValUnit := Round(WORKIT->EE8_PRECO,4)
	WORKIT->EE8_PRECO := cValUnit
	WORKIT->EE8_PRCINC:= Round((WORKIT->EE8_SLDINI * cValUnit),2)
	IF xnPValor > 0
		aReg[xnPValor, 2]  := Round((WORKIT->EE8_SLDINI * cValUnit),2)
	Endif
Endif
*********************************
End Sequence
*********************************
		
Return lRet
