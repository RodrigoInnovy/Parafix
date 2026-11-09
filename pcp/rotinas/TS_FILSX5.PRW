#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³HS_FilSX5 ºAutor  ³Mario Arizono       º Data ³  13/03/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Filtro para consulta padrão HSP004.                         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static	__cRetSX5	:= ""

User Function TS_FilSX5()
	Local lRet    := .F.
	Local nUsado  := 0,  nOpcA   := 0, nSX3Campo := 0
	Local aColIX := {}, aHeadIX := {}
	Local oDlgCons, oGetCons
	Local aDadosSX5

	aColsX5 := {}
	aHeadX5 := {}

	nUsado := 0
	Aadd(aHeadX5, {"Codigo"           , "cChave"    , "@!", TamSx3("X5_CHAVE")[1], 0,,, "C",, "V",,,,"V"}) //"Chave"
	Aadd(aHeadX5, {"Descricao"        , "cDescricao", "@!", TamSx3("X5_DESCRI")[1], 0,,, "C",, "V",,,,"V"}) //"Descricao"

	If ReadVar() == "M->Z7_SUBGRUP"
		cTabSX5 := "SZ"
		aDadosSX5 := FWGetSX5("SZ")
		cCodSX5 := SubStr(M->Z7_GRUPO,1,2)
		nTam	:= 2

	ElseIf ReadVar() == "M->Z7_MOTIVO"
		cTabSX5 := "44"
		aDadosSX5 := FWGetSX5("44")
		cCodSX5 := SubStr(M->Z7_SUBGRUP,1,4)
		nTam	:= 4

	EndIf

	If Type("cTabSX5") <> "U" .And. !Empty(cTabSX5)
		DbSelectArea("SX5")
		DbSeek(xFilial("SX5")+cTabSX5+cCodSX5)
		For nAtual := 1 To Len(aDadosSX5 )
			If aDadosSX5[nAtual][2] == cTabSX5 .and. Substr(aDadosSX5[nAtual][3],1,nTam) == cCodSX5
				aAdd(aColsX5, {aDados[nAtual][3],aDados[nAtual][4], .F. })
				SX5->(DbSkip())
			EndIf
		Next nAtual 
	EndIf

	Define MsDialog oDlgCons Title OemToAnsi("SubGrupo/Motivo") From 000, 000 To 500, 850 Of oMainWnd PIXEL //"Indices"

	oGetCons := MsNewGetDados():New(000, 000, 500, 850, 0,,,,,, 99999,,,, oDlgCons, aHeadX5, aColsX5)
	oGetCons:oBrowse:align := CONTROL_ALIGN_ALLCLIENT

	Activate MsDialog oDlgCons Centered ON INIT EnchoiceBar (oDlgCons, { || nOpcA := 1, oDlgCons:End()}, {|| nOpcA := 0, oDlgCons:End()} )

	If nOpcA == 1
		__cRetSX5 := oGetCons:aCols[oGetCons:nAt, 1]
		lRet := .T.
	EndIf

Return(lRet)

User Function TS_SXBSX5()
	&(Readvar()) := __cRetSX5
Return(.T.)