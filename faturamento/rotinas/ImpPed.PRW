#Include "TOTVS.ch"
#Include "TBICONN.ch"

//----------------------------------------------------------------------------------------------
/*/{Protheus.doc} 																				|
|Rotina que realiza a leitura do arquivo TXT para passagem das informaÁıes						|
|atravÈs da funÁ„o, MsExecAuto({|x, y, z| MATA410(x, y, z)}, aHeader, aItems, nOpr),			|
|criando um pedido a partir das informaÁıes lidas.												|
|																								|
|O arquivo TXT importado s„o informaÁıes das programaÁıes de entrega de clientes				|
|Automotivos, o arquivo È tratado pelo usu·rio atravÈs de layout especÌcico.					|
|																								|
|CabeÁalho			seguimento;tipo do pedido;Cliente;Loja;Mensagem padr„o						|
|Itens				Seguimento;Item;Produto;Quantidade;Tipo de OperaÁ„p;data;data;data			|
|																								|
|CabeÁalho	001;N;000182;04;Nota fiscal emitida conforme Resolucao do Senado Federal 13/12		|
|Itens		002;01;3-401-0449;1000;01;26/05/2023;27/05/2023;28/05/2023							|
|																								|
|																								|
|@Parafix																						|
|@since 18/05/2023                                                                              |
|@version P12.1.33                                                                              |
|@Autor Lucas Silva                                                                             |
/*///                                                                                           |
//-----------------------------------------------------------------------------------------------

// FUN«√O PRINCIPAL
User Function ImpPed()

	Local nOpr
	Local oDlg, oButton, oCombo, cCombo, aItems:= {"Inclui","Altera"}

//cCombo:= aItems[2]

	DEFINE MSDIALOG oDlg FROM 0,0 TO 150,300 PIXEL TITLE "Selecione a OpÁao"

	oCombo:= tComboBox():New(10,10,{|u|if(PCount()>0,cCombo:=u,cCombo)},;
		aItems,100,20,oDlg,,; //aItems,100,20,oDlg,,{||MsgStop("Mudou item")};
		,,,,.T.,,,,,,,,,"cCombo")

// Bot„o para fechar a janela

	@ 40,10 BUTTON oButton PROMPT "Confirmar" OF oDlg PIXEL ACTION oDlg:End()

	ACTIVATE MSDIALOG oDlg CENTERED

//MsgStop( "O valor È "+cCombo )

	If cCombo = "Inclui"

		nOpr := 3
		Execimp(nOpr)

	elseif cCombo = "Altera"

		nOpr := 4
		Execimp(nOpr)

	EndIf

Return nil



Static Function Execimp(nOpc)

	//Local nOpr      // NUMERO DA OPERA«√O (3 - INCLUS√O |4 - ALTERA«√O )
	Local aHeader := {} // INFORMA«’ES DO CABE«ALHO
	Local aLine   := {} // INFORMA«’ES DA LINHA
	Local aItems  := {} // CONJUNTO DE LINHAS
	Local aArea   := {} // ARMAZENA ¿REA CORRENTE
	Local cDiret
	Local cLinha  := ""
	Local lPrimlin   := .T.
	Local aCampos := {}
	Local aDados  := {}
	Local nX
	Local nX2
	Local aAreaSC6  := SC6->(GetArea())

	Private aErro := {}
	Private lMsErroAuto := .F.
	Private lMsHelpAuto := .T.



	//RPCSetEnv("01", "01", NIL, NIL, "FAT", NIL, {"SC5", "SC6"}) // ABERTURA DE AMBIENTE (REMOVER SE EXECUTADO VIA SMARTCLIENT)
	aArea := GetArea() // CAPTURA DA ¿REA PARA FUTURA RESTAURA√á√ÉO

	cDiret :=  cGetFile( ' Arquito CSV|*.csv|Arquivo TXT|*.txt ',; //[ cMascara],
	'Selecao de Arquivos',;                  //[ cTitulo],
	0,;                                      //[ nMascpadrao],
	'C:\TOTVS\',;                            //[ cDirinicial],
	.F.,;                                    //[ lSalvar],
	GETF_LOCALHARD  + GETF_NETWORKDRIVE,;    //[ nOpcoes],
	.T.)

	If Empty( cDiret )

		MsgInfo( "Selecione um arquivo", "AtenÁ„o" )

		Return( Nil )
	endif

	FT_FUSE(cDiret)
	ProcRegua(FT_FLASTREC())
	FT_FGOTOP()
	While !FT_FEOF()

		IncProc("Lendo arquivo texto...")

		cLinha := FT_FREADLN()

		If lPrimlin
			aCampos := Separa(cLinha,";",.T.)
			lPrimlin := .F.
		Else
			AADD(aDados,Separa(cLinha,";",.T.))
		EndIf

		FT_FSKIP()
	EndDo


	//cNum := GetSXENum("SC5", "C5_NUM") // REMOVER PARA GERA√á√ÉO DE NUMERA√á√ÉO AUTOM√ùTICA PELA ROTINA

	// DADOS DO CABE√áALHO
	// AAdd(aHeader, {"C5_NUM", cNum, NIL}) // REMOVER PARA GERA√á√ÉO DE NUMERA√á√ÉO AUTOM√ùTICA PELA ROTINA
	if nOpc = 3 //Inclus„o

		aadd(aHeader, {"C5_TIPO",    aCampos[2],   Nil})
		aadd(aHeader, {"C5_CLIENTE", aCampos[3],   Nil})
		aadd(aHeader, {"C5_LOJACLI", aCampos[4],   Nil})
		aadd(aHeader, {"C5_MENNOTA", aCampos[5],   Nil})

	Elseif nOpc = 4 //AlteraÁ„o

		aadd(aHeader, {"C5_NUM",    aCampos[2],   Nil})

	Endif

	// DADOS DOS ITENS
	For nX := 1 To LEN(aDados)
		//--- Informando os dados do item do Pedido de Venda

		aLine := {}

		if (nOpc = 4) .and. (VAL(ADADOS[nX][4]) = 0) //valida se È exclus„o

			aadd(aLine,{"LINPOS","C6_ITEM",ADADOS[nX][2]})
			aadd(aLine,{"AUTDELETA","S",Nil})

			//Posiciona no item do pedido a ser alterado
		elseIf (nOpc = 4) .and. (VAL(ADADOS[nX][4]) <> 0)

			dbselectarea("SC6")
			dbsetorder(1)

			if 	dbSeek(xFilial("SC6")+aCampos[2]+ADADOS[nX][2]+ADADOS[nX][3])  //INDICE SC6 C6_FILIAL, C6_NUM, C6_ITEM, C6_PRODUTO, R_E_C_N_O_, D_E_L_E_T_

				aadd(aLine,{"LINPOS","C6_ITEM",ADADOS[nX][2]})
				aadd(aLine,{"C6_QTDVEN", 	IIF(UnMed(ADADOS[nX][3]) == 1, VAL(ADADOS[nX][4]), ConvUm(ADADOS[nX][3], 0,  val(ADADOS[nX][4]), 1)) , Nil}) //Tratamento para identificar a unidade de medida do Produto (1∫ ou 2∫)
				aadd(aLine,{"C6_OPER",    	ADADOS[nX][5],		Nil})
				aadd(aLine,{"C6_UNIDADE", 	IIF(UnMed(ADADOS[nX][3]) == 1, 1, 2) , Nil})
				aadd(aLine,{"C6_DTENTRG", 	ctod(ADADOS[nX][6]), Nil}) // Data da Entrega dd/mm/aaaa
				aadd(aLine,{"C6_ZZDTCLI", 	ctod(ADADOS[nX][7]), Nil})
				aadd(aLine,{"C6_ENTREG",  	ctod(ADADOS[nX][8]), Nil})


				//Valida se existe algum Array obrigatÛrio Vazio
				For nX2 := 2 To 8
					if empty(aDados[nx][nX2])
						MSGALERT( "Existe dados obrigatÛrios n„o preenchido no Layout de importaÁ„o", "AtenÁ„o" )
					endif
				Next nX2

				if LEN(aDados[nX]) > 8 .AND. !empty(ADADOS[nX][9])
					aadd(aLine,{"C6_PEDCLI",  	ADADOS[nX][9],		 Nil})
					aadd(aLine,{"C6_NUMPCOM",  	ADADOS[nX][9],		 Nil})
					if LEN(aDados[nX]) > 10 .AND. !empty(ADADOS[nX][11])
						aadd(aLine,{"C6_ITEMPC",  	ADADOS[nX][11],		 Nil})
					endif
				endif


			else
				aadd(aLine,{"C6_ITEM",    	ADADOS[nX][2], 		Nil})
				aadd(aLine,{"C6_PRODUTO", 	ADADOS[nX][3],	 	Nil})
				aadd(aLine,{"C6_QTDVEN", 	IIF(UnMed(ADADOS[nX][3]) == 1, VAL(ADADOS[nX][4]), ConvUm(ADADOS[nX][3], 0,  val(ADADOS[nX][4]), 1)) , Nil}) //Tratamento para identificar a unidade de medida do Produto (1∫ ou 2∫)
				aadd(aLine,{"C6_OPER",    	ADADOS[nX][5],		Nil})
				aadd(aLine,{"C6_UNIDADE", 	IIF(UnMed(ADADOS[nX][3]) == 1, 1, 2) , Nil})
				aadd(aLine,{"C6_DTENTRG", 	ctod(ADADOS[nX][6]), Nil}) // Data da Entrega dd/mm/aaaa
				aadd(aLine,{"C6_ZZDTCLI", 	ctod(ADADOS[nX][7]), Nil})
				aadd(aLine,{"C6_ENTREG",  	ctod(ADADOS[nX][8]), Nil})

				//Valida se existe algum Array obrigatÛrio Vazio
				For nX2 := 2 To 8
					if empty(aDados[nx][nX2])
						MSGALERT( "Existe dados obrigatÛrios n„o preenchido no Layout de importaÁ„o", "AtenÁ„o" )
					endif
				Next nX2

				if LEN(aDados[nX]) > 8 .AND. !empty(ADADOS[nX][9])
					aadd(aLine,{"C6_PEDCLI",  	ADADOS[nX][9],		 Nil})
					aadd(aLine,{"C6_NUMPCOM",  	ADADOS[nX][9],		 Nil})
					if LEN(aDados[nX]) > 10 .AND. !empty(ADADOS[nX][11])
						aadd(aLine,{"C6_ITEMPC",  	ADADOS[nX][11],		 Nil})
					endif
				endif

			endif

		elseif (nOpc = 3)

			aadd(aLine,{"C6_ITEM",    	ADADOS[nX][2], 		Nil})
			aadd(aLine,{"C6_PRODUTO", 	ADADOS[nX][3],	 	Nil})
			aadd(aLine,{"C6_QTDVEN", 	IIF(UnMed(ADADOS[nX][3]) == 1, VAL(ADADOS[nX][4]), ConvUm(ADADOS[nX][3], 0,  val(ADADOS[nX][4]), 1)) , Nil}) //Tratamento para identificar a unidade de medida do Produto (1∫ ou 2∫)
			aadd(aLine,{"C6_OPER",    	ADADOS[nX][5],		Nil})
			aadd(aLine,{"C6_UNIDADE", 	IIF(UnMed(ADADOS[nX][3]) == 1, 1, 2) , Nil})
			aadd(aLine,{"C6_DTENTRG", 	ctod(ADADOS[nX][6]), Nil}) // Data da Entrega dd/mm/aaaa
			aadd(aLine,{"C6_ZZDTCLI", 	ctod(ADADOS[nX][7]), Nil})
			aadd(aLine,{"C6_ENTREG",  	ctod(ADADOS[nX][8]), Nil})

			//Valida se existe algum Array obrigatÛrio Vazio
			For nX2 := 2 To 8
				if empty(aDados[nx][nX2])
					MSGALERT( "Existe dados obrigatÛrios n„o preenchido no Layout de importaÁ„o", "AtenÁ„o" )
				endif
			Next nX2

			if LEN(aDados[nX]) > 8 .AND. !empty(ADADOS[nX][9])
				aadd(aLine,{"C6_PEDCLI",  	ADADOS[nX][9],		 Nil})
				aadd(aLine,{"C6_NUMPCOM",  	ADADOS[nX][9],		 Nil})
				if LEN(aDados[nX]) > 10 .AND. !empty(ADADOS[nX][11])
					aadd(aLine,{"C6_ITEMPC",  	ADADOS[nX][11],		 Nil})
				endif
			endif
		endif
		aadd(aItems, aLine)
	Next nX

	MsExecAuto({|x, y, z| MATA410(x, y, z)}, aHeader, aItems, nOpc)

	// VALIDA√á√ÉO DE ERRO
	If (lMsErroAuto)
		MostraErro()
		// RollbackSX8() // REMOVER PARA GERA√á√ÉO DE NUMERA√á√ÉO AUTOM√ùTICA PELA ROTINA

		ConOut(Repl("-", 80))
		ConOut(PadC("MATA410 automatic routine ended with error", 80))
		ConOut(PadC("Ended at: " + Time(), 80))
		ConOut(Repl("-", 80))
	Else
		// ConfirmSX8() // REMOVER PARA GERA√á√ÉO DE NUMERA√á√ÉO AUTOM√ùTICA PELA ROTINA

		ConOut(Repl("-", 80))
		ConOut(PadC("MATA410 automatic routine successfully ended", 80))
		ConOut(PadC("Ended at: " + Time(), 80))
		ConOut(Repl("-", 80))

		if nOpc = 3

			MSGALERT( "Pedido: "+ SC5->C5_NUM + " incluido com sucesso", "ImportaÁ„o de TXT " )

		else

			MSGALERT( "Pedido: "+ SC5->C5_NUM + " alterado com sucesso", "ImportaÁ„o de TXT " )

		Endif


	EndIf


	RestArea(aArea) // RESTAURA√á√ÉO DA √ùREA ANTERIOR
	RestArea(aAreaSC6)
	//RPCClearEnv() // FECHAMENTO DE AMBIENTE (REMOVER SE EXECUTADO VIA SMARTCLIENT)


Return (NIL)


static Function UnMed(cProd)
	Local aAreaSB1  := SB1->(GetArea())
	Local nUnNF


	dbSelectArea("SB1")
	if dbSeek(xFilial("SB1")+cProd)
		if SB1->B1_SEGUM == "PC"
			nUnNF := 2

		elseif SB1->B1_UM == "PC"
			nUnNF := 1
		else
			nUnNF := 1

		endif
	endif

	RestArea(aAreaSB1)

Return nUnNF

