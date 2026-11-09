#Include "protheus.ch"
#Include "topconn.ch"

/*
	Programa: 	EICFI400_RDM
	Função	:	Ponto de Entrada do Programa Corrgir Taxa Titulo DI
	Data	: 	06/02/19
	Autor	:	Fernando Pereira
*/
                                                                              
*****************************
  User Function EICFI400()
***************************** 

Do Case
	Case ParamIxb == "ANTES_INC_TIT_INV" 
	   *** Acerto vencimentos da invoice conforme MIT006
	   *** Ajustar data de vencimento da invoice EIC via gatilho . Em Venc ate 1 a 15 = 10 e 16 a 31 = 23
	   *********************************************************************************************************
		   If Day(cDtVecto) < 16
		      cMudaDia := "10"+Substr(DtoC(cDtVecto),3,10)
		      cDtVecto := CtoD(cMudaDia)
		   Endif
		   If Day(cDtVecto) > 15
		      cMudaDia := "23"+Substr(DtoC(cDtVecto),3,10)
		      cDtVecto := CtoD(cMudaDia)
		   Endif          

		If Alltrim(FUNNAME())=="EICDI502" .and. !Empty(W6_DI_NUM)  
		   nTxMoeda  := SW9->W9_TX_FOB
	    Endif
EndCase

Return