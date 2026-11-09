#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#INCLUDE "apvt100.ch"
#DEFINE cEOL CHR(13) + CHR(10)

/*	
	Programa	:	PRAACD02
	Autor		:	Evandro Simenes
	Data		:	17/11/2017
	Descricao	:	Rotina para desmembramento de etiquetas de pallet
*/

User Function PRAACD02()
	Local cAuxEti 	:= Space(60)	&& Etiqueta
	Local aAuxTela	:= {}			&& Array tela
	Local aItens    := {}           && Array Transferencia
	Local oCtrlRec  := ControleDeRecebimento():newControleDeRecebimento()
	Local dDataVal := Date()
	Local cAuxQtd := space(TamSX3("BF_QUANT")[1])
	Local cAuxQtd2 := space(TamSX3("BF_QUANT")[1])
	Local cAuxPlt := space(10)

	&& Exibir tela para ler etiqueta
	VtClear()
		@00,00 VtSay "   Desmembramento"
		@01,00 VtSay "      Etiqueta    "
		@02,00 VtGet cAuxEti Pict "@!" when Empty(cAuxEti) .or. VtLastkey()==5 VALID VldEtiq(cAuxEti)
		@04,00 VtSay "Qtd UM 1:"
		@04,12 VtGet cAuxQtd Pict "@!" when Empty(cAuxQtd) .or. VtLastkey()==5 VALID VldQtd(cAuxEti, cAuxQtd, @cAuxQtd2)
		@05,00 VtSay "Qtd UM 2:"
		@05,12 VtGet cAuxQtd2 Pict "@!" when Empty(cAuxQtd2) .or. VtLastkey()==5 VALID VldQtd2(cAuxEti, cAuxQtd2, @cAuxQtd)
		@06,00 VtSay "Pallet:"
		@06,08 VtGet cAuxPlt Pict "@!" VALID VldPlt(cAuxPlt, cAuxQtd, cAuxQtd2)
	VtRead
	
	&& Salvar tela
	VTSave Screen To aAuxTela
	
	If 	VtLastkey() == 27
		Return .F.
	EndIf
	
	Imprime(cAuxEti, cAuxQtd, cAuxPlt)
	VtAlert("Imprimindo","Aviso",.T.,2000)
	
	&& Restaurar tela
	VTRestore Screen From aAuxTela   
	
	&& Chamada recursiva
	U_PRAACD02()
Return


Static Function VldEtiq(cAuxEti)
	Private nStart 	:= 0            && Start Substring
	Private nQtdChar 	:= 0            && Qtd Char
	Private cQry      := ""           && Query
	Private cLote		:= ""			&& Lote
	Private nQtde		:= ""			&& Quantidade
	Private cCodPro 	:= ""           && Codigo Produto
	Private lRet      := .T.
	
	If Empty(cAuxEti)
		VtAlert("Informe a Etiqueta.","Aviso",.T.,2000)
		Return .F.
	EndIf
	
	nStart := At("%001",cAuxEti) + 4
	nQtdChar := At("%010",cAuxEti) - nStart
	cCodPro 	:= padr(SubStr(cAuxEti,nStart,nQtdChar),15," ") //Seta Codigo do Produto
	
	nStart := At("%010",cAuxEti) + 4
	nQtdChar := At("%030",cAuxEti) - nStart
	cLote		:= padl(SubStr(cAuxEti,nStart,nQtdChar),11,"0") //Seta Lote do Produto
	//cLote		:= SubStr(cAuxEti,nStart,nQtdChar) //Seta Lote do Produto
	
	nStart := At("%030",cAuxEti) + 4
	nQtdChar := (Len(cAuxEti)+1) - nStart
	nQtde    := Val(AllTrim(SubStr(cAuxEti,nStart,nQtdChar)))//Seta Quantidade do Produto
	
	cQry :=	" SELECT R_E_C_N_O_ "
	cQry += "   FROM "+RetSqlName("SBF")
	cQry += "  WHERE D_E_L_E_T_ <> '*'"
	cQry += "    AND BF_FILIAL = '"+xFilial("SBF")+"'"
	cQry += "    AND BF_PRODUTO = '"+cCodPro+"'"
	cQry += "    AND BF_LOTECTL = '"+cLote+"'"
	cQry += "    AND BF_QUANT = "+str(nQtde)
	
	TcQuery cQry Alias TZA1 New
	
	&& Caso tenha encontrado
	If !TZA1->(!EOF())
		VtAlert("Pallet não encontrado.","Aviso",.T.,2000)
		lRet := .F.
	EndIf
	
	TZA1->(DbCloseArea())
	
Return lRet

Static Function Imprime(cAuxEti, cAuxQtd, cAuxPlt)
	Private nStart 	:= 0            && Start Substring
	Private nQtdChar 	:= 0            && Qtd Char
	Private cQry      := ""           && Query
	Private cLote		:= ""			&& Lote
	Private nQtde		:= ""			&& Quantidade
	Private cCodPro 	:= ""           && Codigo Produto
	Private nQtdRest1 := 0
	Private nQtdRest2 := 0
	Private cDataHora := ""
	Private cDataVal := ""
	Private cPesoLiq := ""
	Private cPesoBru := ""
	Private cPrefixo1 := "%001" // Pré-requisito PC-Factory
	Private cPrefixo2 := "%010" // Pré-requisito PC-Factory
	Private cPrefixo3 := "%030" // Pré-requisito PC-Factory
	Private cCodBar := ""
	
	nStart := At("%001",cAuxEti) + 4
	nQtdChar := At("%010",cAuxEti) - nStart
	cCodPro 	:= padr(SubStr(cAuxEti,nStart,nQtdChar),15," ") //Seta Codigo do Produto
	
	nStart := At("%010",cAuxEti) + 4
	nQtdChar := At("%030",cAuxEti) - nStart
	cLote		:= padl(SubStr(cAuxEti,nStart,nQtdChar),11,"0") //Seta Lote do Produto
	//cLote		:= SubStr(cAuxEti,nStart,nQtdChar) //Seta Lote do Produto
	
	nStart := At("%030",cAuxEti) + 4
	nQtdChar := (Len(cAuxEti)+1) - nStart
	nQtde    := Val(AllTrim(SubStr(cAuxEti,nStart,nQtdChar)))//Seta Quantidade do Produto
	
	cQry :=	" SELECT B1_PESO, B1_PESBRU, B1_UM, B1_SEGUM, B1_DESC, B1_ZZQLUM, B1_ZZQVOL, B1_ZZTPUNV"
	cQry += "   FROM "+RetSqlName("SB1")
	cQry += "  WHERE D_E_L_E_T_ <> '*'"
	cQry += "    AND B1_FILIAL = '"+xFilial("SB1")+"'"
	cQry += "    AND B1_COD = '"+cCodPro+"'"
	
	TcQuery cQry Alias TSB1 New
	
	&& Caso tenha encontrado
	If !TSB1->(!EOF())
		VtAlert("Produto não cadastrado.","Aviso",.T.,2000)
		Return .F.
	Else
		FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG CTRLEXP", 0, (nStart - Seconds()), {})
		nQtdRest1 := nQtde - val(cAuxQtd)
		nQtdRest2 := (ConvUm(cCodPro, nQtde, 0, 2)) - (ConvUm(cCodPro, val(cAuxQtd), 0, 2))
		If TSB1->B1_ZZQLUM == "1"
			nQtdVols := nQtdRest1 / TSB1->B1_ZZQVOL
		Else
			nQtdVols := nQtdRest2 / TSB1->B1_ZZQVOL 
		EndIf
		FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG CTRLEXP1: "+str(nQtdRest1), 0, (nStart - Seconds()), {})
		FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG CTRLEXP2: "+str(nQtdRest2), 0, (nStart - Seconds()), {})
		FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG CTRLEXP3: "+(TSB1->B1_ZZQLUM), 0, (nStart - Seconds()), {})
		FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG CTRLEXP4: "+str(TSB1->B1_ZZQVOL), 0, (nStart - Seconds()), {})
		FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG CTRLEXP5: "+str(nQtdVols), 0, (nStart - Seconds()), {})

		
		cDataHora	:= dtoc(Date()) + "  00:00"
		cDataVal	:= dtoc(Date())
		cPesoLiq	:= AllTrim(Transform(TSB1->B1_PESO * nQtdRest1, "@E 999,999.99"))
		cPesoBru	:= AllTrim(Transform(TSB1->B1_PESBRU * nQtdRest2, "@E 999,999.99"))
		
		cCodBar		:= cPrefixo1+cCodPro+cPrefixo2+cLote+cPrefixo3+str(nQtdRest1)
		
		
		FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG CTRLEXP4: "+cPesoLiq, 0, (nStart - Seconds()), {})
		FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG CTRLEXP5: "+cPesoBru, 0, (nStart - Seconds()), {})
		
		U_etqPallet("",;
		            cCodPro,;
		            TSB1->B1_DESC,;
		            cLote,;
		            cDataHora,;
		            cDataVal,;
		            str(nQtdRest1),;
		            TSB1->B1_UM,;
		            str(nQtdRest2),;
		            TSB1->B1_SEGUM,;
		            cCodBar,;
		            cPesoLiq,;
		            cPesoBru,;
		            1,;
		            cDataVal,;
		            cAuxPlt,;
		            nQtdVols,;
		            TSB1->B1_ZZTPUNV)
	EndIf
	
	TSB1->(DbCloseArea())
	
Return


Static Function VldQtd(cAuxEti, cQtdEti, cAuxQtd2)
	Private nStart 	:= 0            && Start Substring
	Private nQtdChar 	:= 0            && Qtd Char
	Private nQtde		:= ""			&& Quantidade
	Private lRet      := .T.
	Private cCodPro := ""
	
	nStart := At("%001",cAuxEti) + 4
	nQtdChar := At("%010",cAuxEti) - nStart
	cCodPro 	:= padr(SubStr(cAuxEti,nStart,nQtdChar),15," ") //Seta Codigo do Produto
	
	nStart := At("%030",cAuxEti) + 4
	nQtdChar := (Len(cAuxEti)+1) - nStart
	nQtde    := Val(AllTrim(SubStr(cAuxEti,nStart,nQtdChar)))//Seta Quantidade do Produto
	
	//If val(cQtdEti) == 0
	//	VtAlert("Quantidade não pode ser zero.","Aviso",.T.,2000)
	//	lRet := .F.
	//Endif
	
	If val(cQtdEti) > nQtde
		VtAlert("Quantidade Maior que a Etiqueta.","Aviso",.T.,2000)
		lRet := .F.
	EndIf
	
	If val(cQtdEti) > 0
		cAuxQtd2 := padr(alltrim(str(round(ConvUm(cCodPro, val(cQtdEti), 0, 2),TamSX3("BF_QUANT")[2]))),TamSX3("BF_QUANT")[1]," ")
	EndIf
	
	VTGetRefresh("cAuxQtd2")
Return lRet


Static Function VldQtd2(cAuxEti, cQtdEti, cAuxQtd)
	Private nStart 	:= 0            && Start Substring
	Private nQtdChar 	:= 0            && Qtd Char
	Private nQtde		:= ""			&& Quantidade
	Private lRet      := .T.
	Private cCodPro := ""
	
	nStart := At("%001",cAuxEti) + 4
	nQtdChar := At("%010",cAuxEti) - nStart
	cCodPro 	:= padr(SubStr(cAuxEti,nStart,nQtdChar),15," ") //Seta Codigo do Produto
	
	nStart := At("%030",cAuxEti) + 4
	nQtdChar := (Len(cAuxEti)+1) - nStart
	nQtde    := Val(AllTrim(SubStr(cAuxEti,nStart,nQtdChar)))//Seta Quantidade do Produto
	
	//If val(cQtdEti) == 0
	//	VtAlert("Quantidade não pode ser zero.","Aviso",.T.,2000)
	//	lRet := .F.
	//Endif
	
	If val(cQtdEti) > nQtde
		VtAlert("Quantidade Maior que a Etiqueta.","Aviso",.T.,2000)
		lRet := .F.
	EndIf
	
	If val(cQtdEti) > 0
		cAuxQtd := padr(alltrim(str(round(ConvUm(cCodPro, 0, val(cQtdEti), 1),TamSX3("BF_QUANT")[2]))),TamSX3("BF_QUANT")[1]," ")
	EndIf
	
	VTGetRefresh("cAuxQtd")
	
Return lRet


Static Function VldPlt(cAuxPlt, cQtdEti, cQtdEti2)
	
	If val(cQtdEti) == 0 .and. val(cQtdEti2) == 0
		VtAlert("Informe ao menos 1 das quantidades.","Aviso",.T.,2000)
		VTGetSetFocus("cAuxQtd")
		Return .F.
	Endif
	
	If Empty(cAuxPlt)
		VtAlert("Informe o Pallet.","Aviso",.T.,2000)
		Return .F.
	EndIf
	
Return .T.
