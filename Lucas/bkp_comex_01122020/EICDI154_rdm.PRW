#Include "protheus.ch"
#INCLUDE "Eicdi154.ch"
#include "Average.ch"
#Include "TOPCONN.ch"

/*
Programa: 	EICDI154_RDM
Função	:	Ponto de Entrada do Programa gerador de NFE de importação
Data	: 	10/01/19
Autor	:	Fernando Pereira
*/

//-------------------------
User Function EICDI154()
//-------------------------

Local nQt     := 0

Do Case
	
	Case ParamIxb == "GRAVACAO_SF1"    
	***************************************************************
		**** Informações de Transportadora, Pesos e Volumes
		***********************************************************
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
		***********************************************************
		
	Case ParamIxb == "ADD_ESTRU_WORK1"   
	***********************************************************
		AADD(aDBF_Stru,{"WkXTPUN" ,AVSX3("W7_XTPUN" ,AV_TIPO ) ,AVSX3("W7_XTPUN" ,AV_TAMANHO ) ,AVSX3("W7_XTPUN" ,AV_DECIMAL)})
		AADD(aDBF_Stru,{"WkXQTUN2",AVSX3("W7_XQTUN2",AV_TIPO ) ,AVSX3("W7_XQTUN2",AV_TAMANHO ) ,AVSX3("W7_XQTUN2",AV_DECIMAL)})
		AADD(aDBF_Stru,{"WkXUN2"  ,AVSX3("W7_XUN2"  ,AV_TIPO ) ,AVSX3("W7_XUN2"  ,AV_TAMANHO ) ,AVSX3("W7_XUN2"  ,AV_DECIMAL)})
		AADD(aDBF_Stru,{"WkXUN1"  ,AVSX3("W7_XUN1"  ,AV_TIPO ) ,AVSX3("W7_XUN1"  ,AV_TAMANHO ) ,AVSX3("W7_XUN1"  ,AV_DECIMAL)})
		AADD(aDBF_Stru,{"WkXVLUN2",AVSX3("W7_XVLUN2",AV_TIPO ) ,AVSX3("W7_XVLUN2",AV_TAMANHO ) ,AVSX3("W7_XVLUN2",AV_DECIMAL)})
		AADD(aDBF_Stru,{"WkXTPUN" ,AVSX3("W7_XTPUN" ,AV_TIPO ) ,AVSX3("W7_XTPUN" ,AV_TAMANHO ) ,AVSX3("W7_XTPUN" ,AV_DECIMAL)})
	
	Case ParamIxb == "GRAVACAO_SD1"
	***********************************************************
		cB1Rastro := ""

		cAreaeic := GetArea()
		
		cB1Rastro := Posicione("SB1",1,xFilial("SB1")+SC7->C7_PRODUTO,"B1_RASTRO") // analisa se o cadastro do produto tem rastro
		If cB1Rastro == "L"
			AADD(aItem,{"D1_LOTECTL" ,"P"+SC7->C7_NUM+SC7->C7_ITEM     	,".T."}) // Item do Pedido de compra
			cB1Rastro := ""
		Endif
	
		cOldWork := GetArea()
		SW7->(DBSETORDER(4))
		IF SW7->(DbSeek(xFilial("SW8")+SW8->W8_HAWB+Work1->WKPO_NUM+Work1->WKPOSICAO+Work1->WKPGI_NUM))
			Work1->WkXTPUN  := SW7->W7_XTPUN
			Work1->WkXQTUN2 := SW7->W7_XQTUN2
			Work1->WkXUN2   := SW7->W7_XUN2
			Work1->WkXUN1   := SW7->W7_XUN1
			Work1->WkXVLUN2 := SW7->W7_XVLUN2
		Endif
		RestArea(cOldWork)
		
		If Work1->WkXTPUN == "2"
			AADD(aItem,{"D1_QTSEGUM" ,Work1->WkQTDE   ,".T."})
			AADD(aItem,{"D1_QUANT"   ,Work1->WkXQTUN2 ,".T."})
		   	AADD(aItem,{"D1_PRC2UN"  ,Work1->WKPRUNI  ,".T."})
		ElseIF Work1->WkXTPUN == "1"
			AADD(aItem,{"D1_QTSEGUM" ,Work1->WkXQTUN2 ,".T."})
			//AADD(aItem,{"D1_QUANT  ,Work1->WkXQTUN2 ,".T."})
			AADD(aItem,{"D1_VUNIT"   ,Work1->WKPRUNI  ,".T."})
		Endif
			
		AADD(aItem,{"D1_CC"      ,SPACE(3) 							,".T."}) // Limpa Centro de Custo da nota?
		
		RestArea(cAreaeic)
EndCase

Return