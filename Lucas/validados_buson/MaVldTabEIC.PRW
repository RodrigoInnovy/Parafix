#Include "TOTVS.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTabEIC    บ Autor ณ *******            บ Data ณ  13/02/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Codigo gerado pelo AP6 IDE.                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบRevisใo   ณ 01         บ Autor ณ Gustavo Buson    บ Data ณ  12/11/2020 บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function TabEIC(cCodFor,cLojaFor,cCodTab,dDataVld)

	Local aArea   := GetArea()
	Local lValido := .T.
	Local cHelp := ""

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVerifica a vigencia da tabela de precos                                 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea("AIA")
	dbSetOrder(1)
	If DbSeek(xFilial("AIA")+cCodFor+cLojaFor+cCodTab)
		If dDataVld < AIA->AIA_DATDE .Or. dDataVld > IIF(!Empty(AIA->AIA_DATATE),AIA->AIA_DATATE,dDataVld )
			If Empty(cHelp)
				Aviso("A data de emissao do pedido nao encontra-se dentro da data de validade desta tabela de precos, altere a data de validade da tabela ou escolha outra")//"A data de emissao do pedido nao encontra-se dentro da data de validade desta tabela de precos, altere a data de validade da tabela ou escolha outra"
			Else
				cHelp := "COMTABPRC"
			EndIf
			lValido := .F.
		Else
			//If !Empty(cCondPag) .And. !Empty(AIA->AIA_CONDPG) .And. cCondPag <> AIA->AIA_CONDPG
			//	If Empty(cHelp)
			//		Help(" ",1,"COMTABPRC")
			//	Else
			//		cHelp := "COMTABPRC"
			//	EndIf
			//	lValido := .F.
			//EndIf
		EndIf
	Else
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Verifica se a tabela nao esta em branco e nao e' tabela 1              ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If !Empty(cCodTab) .And. !Empty(cCodFor) .And. !Empty(cLojaFor)
			If Empty(cHelp)
				Help(" ",1,"REGNOIS")
			Else
				cHelp := "REGNOIS"
			EndIf
			lValido := .F.
		EndIf
	EndIf

	RestArea(aArea)
	If lValido
			TRB->W1_PRECO 	:= AIB->AIB_PRCCOM
			TRB->W1_XVLUN2	:= AIB->AIB_ZZPRC2
	EndIf

Return(lValido)
