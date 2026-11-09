#include "RwMake.ch"
#include "Protheus.ch"
#INCLUDE "EICDI500.CH"

#define ESTORNO   5

/*/{Protheus.doc} EICDI500Ponto de Entrada do Programa Ajusta informações Seg Unidade Embarque/Desemb
	@type function
	@author Fernando.Pereira
	@since 14/03/2019
	@version 1.0
/*/
*****************************
USER FUNCTION EICDI500()
*****************************
Private nOldPesoW7
Static  nOldPesoW7      

If ParamIXB <> "ANT_VALID_SW6" .AND. ParamIXB <> "DEPOIS_VALID_SW6" 
//alert(ParamIXB) 
endif

	//If        ParamIXB=="MARCA_DESMARCA_ITEM_INVOICE"
	//   ElseIf ParamIXB=="GRAVA_SW8_A"
	//   ElseIf ParamIXB=="BROWSE_WORK_SW8"
	//   ElseIf ParamIXB=="AADD_ACAMPOS_SW8" .OR. ParamIXB=="BROWSE_WORK_DSI"	
	//   ElseIf ParamIXB=="MARCA_ITEM_SW7" 
	//   ElseIf ParamIXB=="GRAVA_INCLUI_SW5"
	//   ElseIf ParamIXB=="INICIA_GET_ITEM_INVOICE"
	//   ElseIf ParamIXB=="COLUNAS_BOTOES_NVES"
	//   ElseIf ParamIXB=="GRAVA_WORK_SW8"
	//   ElseIf ParamIXB=="ITEM_GET_INVOICE"
	//   ElseIf ParamIXB=="GRAVA_GET_ITEM_INVOICE"
	//   ElseIf ParamIXB=="INICIO_SOMA_TOTAIS" 
	//   ElseIf ParamIXB=="POS_GRAVA_TUDO" .OR. ParamIXB=="POS_GRAVA_CAPA" // ajustar os valores 8 invoice para DESCONTO
	//   ElseIf ParamIXB=="INV_CARREGA_SW8"     
                         

If ParamIXB == "SEL_ITEM"

	@nL1,nC1 		SAY   AVSX3("W7_XUN2",5)   SIZE 40,8 PIXEL
	@nL1,nC2 		MSGET Work->WkXUN2    PICT AVSX3("W7_XUN2",6) SIZE 10,08 PIXEL //WHEN .F. //VALID ReCalSW7() SIZE 95,08 PIXEL //WHEN .F.
	
	@nL1,nC1+095 		SAY   AVSX3("W7_XUN1",5)   SIZE 40,8 PIXEL
	@nL1,nC2+100 		MSGET Work->WkXUN1    PICT AVSX3("W7_XUN1",6) SIZE 10,08 PIXEL //WHEN .F. //VALID ReCalSW7() SIZE 95,08 PIXEL //WHEN .F.

	@nL1+12,nC1 	SAY   AVSX3("W7_XQTUN2",5)  SIZE 40,8 PIXEL
	@nL1+12,nC2 	MSGET Work->WkXQTUN2   PICT AVSX3("W7_XQTUN2",6)  SIZE 45,08 PIXEL //WHEN .F. //VALID ReCalSW7() SIZE 50,08 PIXEL //WHEN .F.

	@nL1+12,nC1+95 SAY   AVSX3("W7_XVLUN2",5)  SIZE 40,8 PIXEL
	@nL1+12,nC2+100 MSGET Work->WkXVLUN2   PICT AVSX3("W7_XVLUN2",6) SIZE 50,08 PIXEL //WHEN .F.
          
ElseIf ParamIXB == "VISUAL_CAMPOS"
	AADD(aSemSX3,{"W7_XTPUN"    ,AVSX3("W7_XTPUN" ,2),AVSX3("W7_XTPUN" ,3),AVSX3("W7_XTPUN" ,4)})
	AADD(aSemSX3,{"W7_XQTUN2"   ,AVSX3("W7_XQTUN2",2),AVSX3("W7_XQTUN2",3),AVSX3("W7_XQTUN2",4)})
	AADD(aSemSX3,{"W7_XUN2"     ,AVSX3("W7_XUN2"  ,2),AVSX3("W7_XUN2"  ,3),AVSX3("W7_XUN2"	,4)})
	AADD(aSemSX3,{"W7_XUN1"     ,AVSX3("W7_XUN1"  ,2),AVSX3("W7_XUN1"  ,3),AVSX3("W7_XUN1"	,4)})
	AADD(aSemSX3,{"W7_XVLUN2"   ,AVSX3("W7_XVLUN2",2),AVSX3("W7_XVLUN2",3),AVSX3("W7_XVLUN2",4)})       
	AADD(aSemSX3,{"W7_XPLIQ"    ,AVSX3("W7_XPLIQ" ,2),AVSX3("W7_XPLIQ" ,3),AVSX3("W7_XPLIQ" ,4)})       
	                                                                                                     
ElseIf ParamIXB == "VISUAL_INDICE_COLUNAS"
	If nOPC_mBrw # ESTORNO
		AADD(aTB_Campos,{"W7_XTPUN"    ,,AVSX3("W7_XTPUN" ,5),AVSX3("W7_XTPUN" ,6)})
		AADD(aTB_Campos,{"W7_XQTUN2"   ,,AVSX3("W7_XQTUN2",5),AVSX3("W7_XQTUN2",6)})
		AADD(aTB_Campos,{"W7_XUN2"     ,,AVSX3("W7_XUN2"  ,5),AVSX3("W7_XUN2"  ,6)})
		AADD(aTB_Campos,{"W7_XUN1"     ,,AVSX3("W7_XUN1"  ,5),AVSX3("W7_XUN1"  ,6)})
		AADD(aTB_Campos,{"W7_XVLUN2"   ,,AVSX3("W7_XVLUN2",5),AVSX3("W7_XVLUN2",6)})
		AADD(aTB_Campos,{"W7_XPLIQ"    ,,AVSX3("W7_XPLIQ" ,5),AVSX3("W7_XPLIQ" ,6)})
	EndIf

ElseIf ParamIXB="GRAVA_WORK_SW8"  

	Work_SW8->WKPESO_L   := Work->WKPESO_L
	Work_SW8->WKPESOTOT  := nOldPesoW7 //Work_SW8->(WKPESO_L*WKQTDE)
	Work_SW8->WKW8PESOBR := Work->WKW7PESOBR

ElseIf ParamIXB="MARCA_DESMARCA_ITEM_INVOICE"
	Work_SW8->WKPESOTOT  := nOldPesoW7 //Work_SW8->(WKPESO_L*WKQTDE)
	
ElseIf ParamIXB == "GRAVA_TRB"
	If nOPC_mBrw # ESTORNO
		TRB->W7_XTPUN  := SW7->W7_XTPUN
		TRB->W7_XQTUN2 := SW7->W7_XQTUN2
		TRB->W7_XUN2   := SW7->W7_XUN2
		TRB->W7_XUN1   := SW7->W7_XUN1
		TRB->W7_XVLUN2 := SW7->W7_XVLUN2
		TRB->W7_XPLIQ  := SW7->W7_XPLIQ
	EndIf


ElseIf ParamIXB == "GRV_WORK_ITEM"
	If cAlias=="W5_"
		Work->WkXTPUN  := SW3->W3_XTPUN
		Work->WkXQTUN2 := SW3->W3_XQTUN2
		Work->WkXUN2   := SW3->W3_XUN2
		Work->WkXUN1   := SW3->W3_XUN1
		Work->WkXVLUN2 := SW3->W3_XVLUN2

	ElseIf cAlias=="W7_"
		Work->WkXTPUN  := SW7->W7_XTPUN
		Work->WkXQTUN2 := SW7->W7_XQTUN2
		Work->WkXUN2   := SW7->W7_XUN2
		Work->WkXUN1   := SW7->W7_XUN1
		Work->WkXVLUN2 := SW7->W7_XVLUN2
		Work->WkXPLIQ  := SW7->W7_PESO*SW7->W7_QTDE
	else
		Work->WkXTPUN  := SW3->W3_XTPUN
		Work->WkXQTUN2 := SW3->W3_XQTUN2
		Work->WkXUN2   := SW3->W3_XUN2
		Work->WkXUN1   := SW3->W3_XUN1
		Work->WkXVLUN2 := SW3->W3_XVLUN2
	endif
	
ElseIf ParamIXB == "GRAVA_ALTERA_SW7"
		SW7->W7_XTPUN  := Work->WkXTPUN  
		SW7->W7_XQTUN2 := Work->WkXQTUN2 
		SW7->W7_XUN2   := Work->WkXUN2   
		SW7->W7_XUN1   := Work->WkXUN1   
		SW7->W7_XVLUN2 := Work->WkXVLUN2 
		SW7->W7_XPLIQ  := nOldPesoW7
		 	
ElseIf ParamIXB == "BROWSE_CONFERENCIA"
		AADD(aCamposConf,{"WkXTPUN"   ,,AVSX3("W3_XTPUN" ,5),AVSX3("W3_XTPUN"   ,6)})
		AADD(aCamposConf,{"WkXQTUN2"  ,,AVSX3("W3_XQTUN2",5),AVSX3("W3_XQTUN2"  ,6)})
		AADD(aCamposConf,{"WkXUN2   " ,,AVSX3("W3_XUN2"  ,5),AVSX3("W3_XUN2"    ,6)})
		AADD(aCamposConf,{"WkXUN1   " ,,AVSX3("W3_XUN1"  ,5),AVSX3("W3_XUN1"    ,6)})
		AADD(aCamposConf,{"WkXVLUN2 " ,,AVSX3("W3_XVLUN2",5),AVSX3("W3_XVLUN2"  ,6)})     

ElseIf ParamIXB == "ADD_TB_CAMPOS"
	If nOPC_mBrw # ESTORNO
		AADD(aTB_Campos,{"W7_XTPUN"  ,,AVSX3("W7_XTPUN"  ,5),AVSX3("W7_XTPUN" ,6)})
		AADD(aTB_Campos,{"W7_XQTUN2" ,,AVSX3("W7_XQTUN2" ,5),AVSX3("W7_XQTUN2",6)})
		AADD(aTB_Campos,{"W7_XUN2"   ,,AVSX3("W7_XUN2"   ,5),AVSX3("W7_XUN2"  ,6)})
		AADD(aTB_Campos,{"W7_XUN1"   ,,AVSX3("W7_XUN1"   ,5),AVSX3("W7_XUN1"  ,6)})
		AADD(aTB_Campos,{"W7_XVLUN2" ,,AVSX3("W7_XVLUN2" ,5),AVSX3("W7_XVLUN2",6)})
		AADD(aTB_Campos,{"W7_XPLIQ"  ,,AVSX3("W7_XPLIQ"  ,5),AVSX3("W7_XPLIQ" ,6)})

	EndIf
	
ElseIf ParamIXB == "GRAVA_INCLUI_SW7"
		SW7->W7_XTPUN  := Work->WkXTPUN   
		SW7->W7_XQTUN2 := Work->WkXQTUN2  
		SW7->W7_XUN2   := Work->WkXUN2    
		SW7->W7_XUN1   := Work->WkXUN1                                        
		SW7->W7_XVLUN2 := Work->WkXVLUN2     
		SW7->W7_XPLIQ  := Work->WkXPLIQ     
		
ElseIf ParamIXB == "DEPOIS_VALID_SW6" .and. Alltrim(cNomeCampo) == "W7_PESO"
	ReCalSW7("W7_PESO")
    //nPesoLiq
ElseIf ParamIXB == "STRU_WORKS"
		AADD(aSemSX3SW7,{"WKXTPUN"  ,"C",01,0})
		AADD(aSemSX3SW7,{"WKXQTUN2" ,"N",13,3})
		AADD(aSemSX3SW7,{"WKXUN2"   ,"C",02,0})
		AADD(aSemSX3SW7,{"WKXUN1"   ,"C",02,0})
		AADD(aSemSX3SW7,{"WKXVLUN2" ,"N",15,8})
		AADD(aSemSX3SW7,{"WKXPLIQ"  ,"N",15,5})
	
ElseIf ParamIXB == "BROWSE_SELECIONA" 
		AADD(aCamposItem,{"WkXTPUN"   ,,AVSX3("W3_XTPUN" ,5),AVSX3("W3_XTPUN"   ,6)})
		AADD(aCamposItem,{"WkXQTUN2"  ,,AVSX3("W3_XQTUN2",5),AVSX3("W3_XQTUN2"  ,6)})
		AADD(aCamposItem,{"WkXUN2   " ,,AVSX3("W3_XUN2"  ,5),AVSX3("W3_XUN2"    ,6)})
		AADD(aCamposItem,{"WkXUN1   " ,,AVSX3("W3_XUN1"  ,5),AVSX3("W3_XUN1"    ,6)})
		AADD(aCamposItem,{"WkXVLUN2 " ,,AVSX3("W3_XVLUN2",5),AVSX3("W3_XVLUN2"  ,6)})

EndIf 

Return


*************************************
Static Function ReCalSW7(cTipoPESO)
*************************************
                 
_cAreaW7 := GetArea()

If cTipoPeso == "W7_PESO"
	Work->WKPESO_L := W7_PESO  
If nOldPesoW7== Nil
	nOldPesoW7 := M->W7_PESO * TSALDO_Q //W7_PESO   
Endif


Endif
                                                                              
RestArea(_cAreaW7)

Return