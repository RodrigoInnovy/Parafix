#Include "protheus.ch"

******************************************************************************************************************************************************
// PRPCPE01 - Waldir Baldin - 16/02/2012 - Rotina responsável imprimir as etiquetas do Produto Acabado (PA) - Nacional
******************************************************************************************************************************************************
User Function PRPCPE01()
	Local aSays	:= {}
	Local aBtn		:= {}
	Local lEnd		:= .F.

	Private cPerg := "PRPCPE01"

	ValidPerg()

	aAdd(aSays, "Rotina responsável imprimir as etiquetas do Produto Acabado (PA) ")
	aAdd(aSays, "conforme paramêtros informados pelo usuário. ")
	aAdd(aSays, "                                                     ")
	aAdd(aSays, "*******************************************************************************************************")
	aAdd(aSays, "Antes de clicar no botão OK, clique em parametros para que sejam criados os filtros")
	aAdd(aSays, "necessários !!")
	aAdd(aSays, "*******************************************************************************************************")

	aAdd(aBtn, {5, .T., {|| Pergunte(cPerg,.T.)}})
	aAdd(aBtn, {1, .T., {|| FechaBatch(), MsgRun("Aguarde, Selecionando Registros...", "", {|| Processa({|lEnd| fProcessa(@lEnd), "Processando... Aguarde !!"})})}})
	aAdd(aBtn, {2, .T., {|| FechaBatch()}})

	FormBatch(FunDesc(), aSays, aBtn)
	Return

	******************************************************************************************************************************************************
	// fProcessa - Rotina que Executa a query de seleção dos registros
	******************************************************************************************************************************************************
Static Function fProcessa(lEnd)
	Local cPorta		:= Upper(AllTrim(GetMv("MV_ZZPORTA")))
	Local cTexto		:= ""
	Local dValidade	:= CToD("")
	Local nReg			:= 0
	Local nDias		:= 0
	Local nQtdEtq		:= 0
	Local nQuant		:= 0
	Local nQuantImp	:= 0
	Local nQuantImp2	:= 0
	Local nI			:= 0
	LOcal cZZDias       := GetMv("MV_ZZDIAS")
	// tipo net use lpt2 \\192.168.x.x\s600

	If Empty(MV_PAR01)
		Pergunte(cPerg, .T.)
	EndIf

	If Select("TSC2") <> 0
		TSC2->(DbCloseArea())
	EndIf

	BeginSql Alias "TSC2"
		Column B1_PESO			as Numeric(11, 04)
		Column B1_PESBRU		as Numeric(11, 04)
		Column B1_PRVALID		as Numeric(03, 00)
		Column B1_QE			as Numeric(09, 00)
		Column B5_COMPR 		as Numeric(09, 02)
		Column B5_LARG	 		as Numeric(09, 02)
		Column C2_QUANT		as Numeric(14, 05)
		Column C2_EMISSAO		as Date

		SELECT 
		C2_NUM, C2_ITEM, C2_SEQUEN, C2_PEDIDO, C2_PRODUTO, C2_QUANT, C2_EMISSAO, 
		B1_DESC, B1_PRVALID, B1_SEGUM, B1_UM, B1_PESO, B1_PESBRU, B1_QE, B1_TIPCONV, B1_CONV, 
		B5_COMPR, B5_LARG, 
		A1_NOME, 
		A7_CODCLI 
		FROM 
		%TABLE:SC2% SC2  
		INNER JOIN %TABLE:SB1% SB1 ON  
		B1_FILIAL = %XFILIAL:SB1% AND C2_PRODUTO = B1_COD AND B1_TIPO = "PA" AND SB1.%NOTDEL%	  
		LEFT JOIN %TABLE:SB5% SB5 ON  
		B5_FILIAL = %XFILIAL:SB5% AND B5_COD = B1_COD AND SB5.%NOTDEL%  
		LEFT JOIN %TABLE:SC6% SC6 ON  
		C2_FILIAL = %XFILIAL:SC2% AND C6_NUMOP = C2_NUM AND C6_ITEMOP = C2_ITEM AND SC2.%NOTDEL%  
		LEFT JOIN %TABLE:SA1% SA1 ON  
		A1_FILIAL = %XFILIAL:SA1% AND A1_COD = C6_CLI AND A1_LOJA = C6_LOJA AND SA1.%NOTDEL%  
		LEFT JOIN %TABLE:SA7% SA7 ON  
		A7_FILIAL = %XFILIAL:SA7% AND A7_CLIENTE = A1_COD AND A7_LOJA = A1_LOJA AND A7_PRODUTO = C6_PRODUTO AND SA7.%NOTDEL%	  
		WHERE 
		SC2.C2_FILIAL = %XFILIAL:SC2% AND 
		SC2.C2_EMISSAO BETWEEN %EXP:DtoS(MV_PAR01)% AND %EXP:DtoS(MV_PAR02)% AND 
		SC2.C2_NUM+SC2.C2_ITEM+SC2.C2_SEQUEN BETWEEN %EXP:MV_PAR03% AND %EXP:MV_PAR04% AND 
		SC2.C2_PRODUTO BETWEEN %EXP:MV_PAR05% AND %EXP:MV_PAR06% AND 
		SC2.%NOTDEL% 
	EndSql

	MemoWrite("\PRPCPE01.sql", GetLastQuery()[2])

	Count To nReg
	ProcRegua(nReg)

	TSC2->(DbGoTop())

	MSCBPrinter("S600", cPorta,, 140, .F.)	// Abre conexao com a impressora
	MSCBChkStatus(.F.)

	Do While TSC2->(!Eof())
		IncProc()

		nDias := 0
		nDias := IIf(TSC2->B1_PRVALID != 0, TSC2->B1_PRVALID, cZZDias)

		nQtdEtq := Int(TSC2->C2_QUANT / TSC2->B1_QE)
		If TSC2->C2_QUANT % TSC2->B1_QE > 0
			nQtdEtq ++
		EndIf

		nQuant := TSC2->C2_QUANT

		For nI := 1 To nQtdEtq
			MSCBBegin(01, 06)						 	   // Inicia a Criação da imagem da etiqueta
			MSCBBox(005, 005, 103, 140, 003)

			cTexto := "N.Ordem: "
			MSCBSay(007, 007, cTexto, "N", "0", "040,030")
			cTexto := TSC2->(C2_NUM + C2_ITEM + C2_SEQUEN)
			MSCBSay(032, 007, cTexto, "N", "0", "060,070")

			MSCBSayBar(015, 015, TSC2->(C2_NUM + C2_ITEM + C2_SEQUEN), "N", "MB07", 12, .T.,,,, 4, 3,,,,)

			MSCBLineH(005, 030, 103, 3) 

			cTexto := "Produto: "
			MSCBSay(007, 032, cTexto, "N", "0", "040,030")
			cTexto := TSC2->C2_PRODUTO
			MSCBSay(020, 035, cTexto, "N", "0", "100,080")

			MSCBLineH(005, 045, 103, 3) 

			cTexto := "Descricao: "
			MSCBSay(007, 047, cTexto, "N", "0", "040,030")
			cTexto := TSC2->B1_DESC
			MSCBSay(007, 053, cTexto, "N", "0", "040,050")

			MSCBLineH(005, 058, 103, 3) 

			cTexto := "Qtde.:"
			MSCBSay(007, 060,	cTexto, "N", "0", "040,030")

			If nQuant > TSC2->B1_QE
				nQuantImp	:= TSC2->B1_QE
				nQuant		-= TSC2->B1_QE
			Else
				nQuantImp	:= nQuant
				nQuant		:= 0
			EndIf

			If !Empty(TSC2->B1_SEGUM)
				If AllTrim(TSC2->B1_TIPCONV) == "D"
					nQuantImp2 := nQuantImp / TSC2->B1_CONV
				else
					nQuantImp2 := nQuantImp * TSC2->B1_CONV
				EndIf
				cTexto := AllTrim(Transform(nQuantImp,		"@E 999,999,999.999")) + " " + AllTrim(TSC2->B1_UM) + " / "
				cTexto += AllTrim(Transform(nQuantImp2,	"@E 999,999,999.999")) + " " + AllTrim(TSC2->B1_SEGUM)
			Else
				cTexto := AllTrim(Transform(nQuantImp,		"@E 999,999,999.999")) + " " + AllTrim(TSC2->B1_UM)
			EndIf

			MSCBSay(015, 066,	cTexto, "N", "0", "040,050")

			MSCBLineH(005, 071, 103, 3) 
			MSCBLineV(052, 071, 084, 3) 

			cTexto := "Peso Liquido: "
			MSCBSay(007, 073,	cTexto, "N", "0", "040,030")
			cTexto := AllTrim(Transform(TSC2->B1_PESO * nQuantImp,		"@E 999,999,999.999")) + " KG"
			MSCBSay(015, 079,	cTexto, "N", "0", "040,050")

			cTexto := "Peso Bruto: "
			MSCBSay(054, 073,	cTexto, "N", "0", "040,030")
			If TSC2->B1_PESBRU != 0
				// Só imprime se existe Peso Bruto Cadastrado no Produto
				cTexto := AllTrim(Transform(TSC2->B1_PESBRU * nQuantImp,	"@E 999,999,999.999")) + " KG"
				MSCBSay(060, 079,	cTexto, "N", "0", "040,050")
			EndIf

			MSCBLineH(005, 084, 103, 3) 
			MSCBLineV(085, 084, 097, 3)

			cTexto := "Dimensao: "
			MSCBSay(007, 086,	cTexto, "N", "0", "040,030")
			cTexto := AllTrim(Transform(TSC2->B5_LARG, "@E 999,999,999.999")) + " mm x " + AllTrim(Transform(TSC2->B5_COMPR, "@E 999,999,999.999")) + " m"
			MSCBSay(015, 092,	cTexto, "N", "0", "040,050")
			cTexto := "Cx/Pallet: "
			MSCBSay(087, 086,	cTexto, "N", "0", "040,030")
			cTexto := cValToChar(nI)
			MSCBSay(089, 091,	cTexto, "N", "0", "060,070")

			MSCBLineH(005, 097, 103, 3) 

			cTexto := "Cliente: "
			MSCBSay(007, 099,	cTexto, "N", "0", "040,030")

			If MV_PAR07 == 1
				cTexto := TSC2->A1_NOME
				MSCBSay(007, 105, cTexto, "N", "0", "040,050")
			EndIf

			MSCBLineH(005, 110, 103, 3) 
			MSCBLineV(052, 110, 133, 3) 

			cTexto := "Codigo no Cliente: "
			MSCBSay(007, 112, cTexto, "N", "0", "040,030")
			If MV_PAR07 == 1
				cTexto := TSC2->A7_CODCLI
				MSCBSay(015, 118, cTexto, "N", "0", "040,050")
			EndIf

			cTexto := "Pedido: "
			MSCBSay(054, 112, cTexto, "N", "0", "040,030")
			If MV_PAR07 == 1
				cTexto := TSC2->C2_PEDIDO
				MSCBSay(060, 118, cTexto, "N", "0", "040,050")
			EndIf

			MSCBLineH(005, 133, 103, 3)                                     
			MSCBLineV(052, 133, 140, 3) 

			dValidade := DToC(TSC2->C2_EMISSAO + nDias)
			cTexto := "Fabricacao: " + DtoC(TSC2->C2_EMISSAO)
			MSCBSay(007, 135, cTexto, "N", "0", "032,032")
			cTexto := "Validade: " + dValidade
			MSCBSay(054, 135, cTexto, "N", "0", "032,032")

			MSCBEnd()				// Finaliza a imagem da etiqueta
		Next nI

		TSC2->(DbSkip())
	EndDo

	Sleep(7000)					// Aguarda 7 segundos

	// Impressão de uma etiqueta informativa do que foi impresso.
	MSCBBegin(01, 06)		 	   // Inicia a Criação da imagem da etiqueta
	MSCBBox(005, 005, 103, 140, 003)

	cTexto := "FAIXA DE IMPRESSAO: "
	MSCBSay(07, 40, cTexto, "N", "0", "040,050")

	cTexto := "Da OP: " + MV_PAR03
	MSCBSay(07, 70,	cTexto, "N", "0", "040,050")

	cTexto := "Ate OP: " + MV_PAR04
	MSCBSay(07, 80,	cTexto, "N", "0", "040,050")

	MSCBEnd()						// Finaliza a imagem da etiqueta

	TSC2->(DbCloseArea())
	MSCBClosePrinter()			// Finaliza Conexao com a impressora
	Return

	******************************************************************************************************************************************************
	// ValidPerg - Cria as perguntas no SX1
	******************************************************************************************************************************************************
Static Function ValidPerg()
	Local aAreaATU	:= GetArea()
	Local aAreaSX1	:= SX1->(GetArea())
	Local oObj := FWSX1Util():New()
	Local aRegs		:= {}
	Local nI		:= 0
	Local nJ		:= 0

	oObj:AddGroup(cPerg)
	aPergunte := oObj:GetGroup(cPerg)

	// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
	aAdd(aRegs, {cPerg, "01", "Emissão de",					"Emissão de",					"Emissão de",					"mv_ch1", "D", 08, 0, 0, "G", "", "MV_PAR01", "",		"",		"",		"", "", "",		"",		"",		"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
	aAdd(aRegs, {cPerg, "02", "Emissão ate",					"Emissão ate",				"Emissão ate",				"mv_ch2", "D", 08, 0, 0, "G", "", "MV_PAR02", "",		"",		"",		"", "", "",		"",		"",		"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
	aAdd(aRegs, {cPerg, "03", "OP de",							"OP de",						"OP de",						"mv_ch3", "C", 11, 0, 0, "G", "", "MV_PAR03", "",		"",		"",		"", "", "",		"",		"",		"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SC2"})
	aAdd(aRegs, {cPerg, "04", "OP ate",							"OP ate",						"OP ate",						"mv_ch4", "C", 11, 0, 0, "G", "", "MV_PAR04", "",		"",		"",		"", "", "",		"",		"",		"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SC2"})
	aAdd(aRegs, {cPerg, "05", "Produto de",					"Produto de",					"Produto de",					"mv_ch5", "C", 20, 0, 0, "G", "", "MV_PAR05", "",		"",		"",		"", "", "",		"",		"",		"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SB1"})
	aAdd(aRegs, {cPerg, "06", "Produto ate",					"Produto ate",				"Produto ate",				"mv_ch6", "C", 20, 0, 0, "G", "", "MV_PAR06", "",		"",		"",		"", "", "",		"",		"",		"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SB1"})
	aAdd(aRegs, {cPerg, "07", "Imprime dados do cliente",	"Imprime dados do cliente",	"Imprime dados do cliente",	"mv_ch7", "N", 01, 0, 1, "C", "", "MV_PAR07", "Sim",	"Sim",	"Sim",	"", "", "Nao",	"Nao",	"Nao",	"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})

	FOR i := 1 to LEN(aRegs)
		IF !dbSeek(cPerg+aRegs[i,2])
			MsgAlert(" O item " + aRegs[i,2] + "  '" + aRegs[i,3] + "' " +  " do grupo de perguntas" + " " + cPerg + " " +  "não está cadastrado" + ", a partir de agora o grupo perguntas deverá ser criado pelo configurador")
		EndIf
	NEXT
	
	RestArea(aAreaSX1)
	RestArea(aAreaATU)
Return
