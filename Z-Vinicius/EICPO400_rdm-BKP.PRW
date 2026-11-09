#include "Protheus.ch"
#include "Average.ch"

/*/{Protheus.doc} EICPO400
	Manutenção Segunda unidade do P.O. igual a S.I.
	@author Fernando.Pereira
	@since 14/03/2019
	@version 1.0
/*/

*****************************
USER FUNCTION EICPO400()                                                        
***********************************
 
	IF ParamIXB == "INICIA_TE_3" .or. ParamIXB == "ANTES_TELA_ITEM" .or. ParamIXB == "ANTES_MARCA_ITEM"

		IF ParamIXB == "ANTES_MARCA_ITEM"

			Work->W3_XTPUN   := SW1->W1_XTPUN  
			Work->W3_XQTUN2  := SW1->W1_XQTUN2 
			Work->W3_XUN2 	 := SW1->W1_XUN2   
			Work->W3_XUN1    := SW1->W1_XUN1   
			Work->W3_XVLUN2  := SW1->W1_XVLUN2 

		Endif                               

	EndIf
/*
	IF ParamIXB == "GRAVA_ALTERACAO_ITEM"

            M->W3_XTPUN   := Work->W3_XTPUN  
			M->W3_XQTUN2  := Work->W3_XQTUN2 
			M->W3_XUN2 	  := Work->W3_XUN2 
			M->W3_XUN1    := Work->W3_XUN1  
			M->W3_XVLUN2  := Work->W3_XVLUN2

	EndIf
*/
Return
