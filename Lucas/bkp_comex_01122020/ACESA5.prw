#INCLUDE "rwmake.ch"

/*/{Protheus.doc} AceSA5
	Faz a inclusao de Fornecedor x Fabricantes x Produtos na para uso do modulo de Importacao
	Alterar a validação do campo W1_FABR para:IIF(SUBSTR(M->W1_FABR,1,1)<>"*",SI400Valid(),Execblock("AceSA5",.F.))
	@type function
	@author Fernando.Pereira
	@since 13/11/2018
	@version 1.0
	@return ${return}, ${return_description}
	@example
	(examples)
	@see (links_or_references)

/*/
*******************************
User Function AceSA5()
*******************************

	If Substr(M->W1_FABR,1,1) != "*" 

	Endif   

	If Empty(TRB->W1_COD_I)
		MsgInfo("Favor digitar o Cod. do Produto !","Atenção !")
		Return(.F.)
	Endif

	SetPrvt("cProd,cFabr,cLjFbr,cForn,cLjFor,nPN")

	cProd  := TRB->W1_COD_I
	cFabr  := Space(06)
	cLjFbr := Space(02)
	cForn  := TRB->W1_FORN
	cLjFor := Space(02)
	cPN    := Space(20) // Part Number

	@ 0,0 TO 200,300 DIALOG oDlg1 TITLE "Amarrar Prod x Fabr x Forn"

	@ 012,010 Say "Fabricante:"
	@ 012,042 Get cFabr  PICTURE "@!" size 40,20 F3 "SA2" Valid cValLojas("FB")
	@ 012,085 Say "Loja:
	@ 012,100 Get cLjFbr PICTURE "@!" size 20,20 Valid cValLojas("FB")

	@ 032,010 Say "Fornecedor:"
	@ 032,042 Get cForn  PICTURE "@!" size 40,20 F3 "SA2" Valid cValLojas("FN")
	@ 032,085 Say "Loja:
	@ 032,100 Get cLjFor PICTURE "@!" size 20,20 Valid cValLojas("FN")

	@ 052,010 Say "Part Number:"
	@ 052,042 Get cPN    PICTURE "@!" size 90,20

	@ 70,032 BUTTON "_Ok" SIZE 35,15 ACTION VerCadSA5()
	@ 70,090 BUTTON "_Cancela" SIZE 35,15 ACTION Close(oDlg1)

	ACTIVATE DIALOG oDlg1 CENTER

	Return(.T.)

*****************************
Static Function VerCadSA5()
*****************************

	If !Empty(cFabr) .and. !Empty(cForn)

		cSaveArea := GetArea()

		DbSelectArea("SA5")
		DbSetOrder(3)
		DbSeek(xFilial("SA5")+cProd+cFabr+cForn)

		If eof()

			RecLock("SA5",.T.)
				SA5->A5_FILIAL  := xFilial("SA5")
				SA5->A5_FORNECE := cForn
				SA5->A5_NOMEFOR := Posicione("SA2",1,xFilial("SA2")+cForn+cLjFor,"A2_NOME")
				SA5->A5_LOJA    := cLjFor
				SA5->A5_PRODUTO := cProd
				SA5->A5_NOMPROD := Posicione("SB1",1,xFilial("SB1")+cProd,"B1_DESC")
				SA5->A5_FABR    := cFabr
				SA5->A5_FALOJA  := cLjFbr
				SA5->A5_CODPRF  := cPN
			MsUnlock()

			DbSelectArea("SA2")
			DbSetOrder(1)
			DbSeek(xFilial("SA2")+cForn+cLjFor)

			If !eof()
				RecLock("SA2",.F.)
				SA2->A2_ID_FBFN := "3-Todos"
				MsUnlock()
			Endif

			DbSelectArea("SA2")
			DbSetOrder(1)
			DbSeek(xFilial("SA2")+cFabr+cLjFbr)

			If !eof()
				RecLock("SA2",.F.)
				SA2->A2_ID_FBFN := "3-Todos"
				MsUnlock()
			Endif

		Else

			Alert("Este produto já está cadastrado para o Fabr/Fornecedor")

		Endif

	Endif

	RestArea(cSaveArea)

	M->W1_FORN := cForn
	M->W1_FABR := cFabr

	Close(oDlg1)

	Return(cFabr)

************************************
Static Function cValLojas(cCad)
************************************
** Verifica filias dos Forn/Fabr
************************************
	Local aSaveArea:= GetArea()
	Local lRetVal := .T.
	Local nReg

	nReg := Recno()
	If cCad == "FB"
		If !SA2->(DbSeek(xFilial("SA2")+cFabr+SA2->A2_LOJA))
			MsgInfo("Fabricante não Cadastrado!","Atenção !")
			lRetVal := .F.
		Endif
		cLjFbr := SA2->A2_LOJA

		cForn  := cFabr 
		cLjFor := cLjFbr

	ElseIf cCad == "FN"
		If !SA2->(DbSeek(xFilial("SA2")+cForn+SA2->A2_LOJA))
			MsgInfo("Fornecedor não Cadastrado!","Atenção !")
			lRetVal := .F.
		Endif
		cLjFor := SA2->A2_LOJA
	Endif

	dbGoto(nReg)

	RestArea(aSaveArea)

Return lRetVal