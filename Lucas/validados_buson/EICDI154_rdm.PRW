#Include "protheus.ch"
#INCLUDE "Eicdi154.ch"
#include "Average.ch"
#Include "TOPCONN.ch"

/*
Programa: 	EICDI154_RDM
Função	:	Ponto de Entrada do Programa gerador de NFE de importação
Data	: 	10/01/19
Autor	:	Fernando Pereira

//REVISÃO - 16/11/2020
@type function
@author Gustavo Buson - TOTVS IP Campinas
@since 16/11/2020
@version Protheus 12 - Importação (EIC)
@return nil
*/
User Function EICDI154()

	Local nQt     := 0
	//Inclusão -  Gustavo Buson - 16/11/2020
	Local cParam	:= ""
	Local cLoteEIC	:= Alltrim(GetMV("MV_LOTEEIC"))
	Local cLocPed	:= ""
	Local nPosLoc	:= 0
	Local aAreaSC7 	:= {}
	//FIM

	//Inclusão -  Gustavo Buson - 16/11/2020
	If ValType(ParamIXB) == "A"
		cParam := Alltrim(ParamIXB[1])
	Else
		cParam := Alltrim(ParamIXB)
	EndIf
	//FIM

	If cParam == "GRAVACAO_SF1"
		***************************************************************
		//Informações de Transportadora, Pesos e Volumes
		***************************************************************
		EIH->(dbSetOrder(1))

		If !lTipoCompl
			aAdd(aCab,{"F1_TRANSP",SW6->W6_TRANS  ,Nil})
			aAdd(aCab,{"F1_PLIQUI",SW6->W6_PESOL  ,Nil})
			aAdd(aCab,{"F1_PBRUTO",SW6->W6_PESO_BR,Nil})

			If EIH->(dbSeek(xFilial("EIH")+SW6->W6_HAWB))
				While EIH->(!EOF()) .AND. (xFilial("EIH")+EIH->EIH_HAWB) == (SW6->W6_FILIAL+SW6->W6_HAWB)
					cDesc := ""
					nQt++
					If nQt > 4
						Exit
					Else
						cDesc := Alltrim(Posicione("SJF",1,xFilial("SJF")+EIH->EIH_CODIGO,"JF_DESC"))
						aAdd(aCab,{"F1_ESPECI"+Alltrim(Str(nQt)),cDesc          ,Nil})
						aAdd(aCab,{"F1_VOLUME"+Alltrim(Str(nQt)),EIH->EIH_QTDADE,Nil})
					EndIf
					EIH->(dbSkip())
				EndDo
			EndIf
		EndIf
	EndIf
	***********************************************************
	If cParam == "ADD_ESTRU_WORK1"
		***********************************************************
		AADD(aDBF_Stru,{"WkXQTDE" ,AVSX3("W7_QTDE"  ,AV_TIPO ) ,AVSX3("W7_QTDE"  ,AV_TAMANHO ) ,AVSX3("W7_QTDE" ,AV_DECIMAL)})
		AADD(aDBF_Stru,{"WkXQTUN2",AVSX3("W7_XQTUN2",AV_TIPO ) ,AVSX3("W7_XQTUN2",AV_TAMANHO ) ,AVSX3("W7_XQTUN2",AV_DECIMAL)})
		AADD(aDBF_Stru,{"WkXUN2"  ,AVSX3("W7_XUN2"  ,AV_TIPO ) ,AVSX3("W7_XUN2"  ,AV_TAMANHO ) ,AVSX3("W7_XUN2"  ,AV_DECIMAL)})
		AADD(aDBF_Stru,{"WkXUN1"  ,AVSX3("W7_XUN1"  ,AV_TIPO ) ,AVSX3("W7_XUN1"  ,AV_TAMANHO ) ,AVSX3("W7_XUN1"  ,AV_DECIMAL)})
		AADD(aDBF_Stru,{"WkXTPUN" ,AVSX3("W7_XTPUN" ,AV_TIPO ) ,AVSX3("W7_XTPUN" ,AV_TAMANHO ) ,AVSX3("W7_XTPUN" ,AV_DECIMAL)})

	EndIf

	If Cparam == "GRAVACAO_SD1"
		***********************************************************
		cB1Rastro := ""

		cAreaeic := GetArea()

		cB1Rastro := Posicione("SB1",1,xFilial("SB1")+SC7->C7_PRODUTO,"B1_RASTRO") // Analisa se o cadastro do produto tem rastro
		If cB1Rastro == "L"
			AADD(aItem,{"D1_LOTECTL" ,"P"+SC7->C7_NUM+SC7->C7_ITEM     	,".T."}) // Item do Pedido de compra
			cB1Rastro := ""
		Endif
		
		cOldWork := GetArea()
		SW7->(DBSETORDER(4))
		If SW7->(DbSeek(xFilial("SW8")+SW8->W8_HAWB+Work1->WKPO_NUM+Work1->WKPOSICAO+Work1->WKPGI_NUM))
			Work1->WkXTPUN  := SW7->W7_XTPUN
			Work1->WkXQTDE  := SW7->W7_QTDE
			Work1->WkXQTUN2 := SW7->W7_XQTUN2
			Work1->WkXUN2   := SW7->W7_XUN2
			Work1->WkXUN1   := SW7->W7_XUN1
			
		Endif

		RestArea(cOldWork)

		AADD(aItem,{"D1_UNIDADE" ,	Work1->WkXTPUN    	,".T."})
		AADD(aItem,{"D1_CC"      ,	SPACE(3) 			,".T."}) // Limpar Centro de Custo da Nota
		AADD(aItem,{"D1_QTSEGUM" ,	Work1->WkXQTUN2    ,".T."})
		AADD(aItem,{"D1_SEGUM"   ,	Work1->WkXUN2      ,".T."})

		RestArea(cAreaEic)

	EndIf
	
Return
