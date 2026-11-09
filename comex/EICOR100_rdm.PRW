#Include "protheus.ch"
#Include "topconn.ch"

/*
Programa: 	EICOR100_RDM
Função	:	Ponto de Entrada do Programa Corrgir Unidade de Medida enviado ao despachante conforme embarque
Data	: 	19/03/19
Autor	:	Fernando Pereira
*/

*****************************
User Function EICOR100()
*****************************

Local cParam := If(Type("PARAMIXB") == "A", ParamIxb[1],ParamIxb)   

IF EasyGParam("MV_LAYDESP",,.F.)
   nInc2:= 10
Else
   nInc2:= 0
Endif


Do Case
	Case alltrim(cParam) == "ANTES_ITEA"
		IF SW7->W7_XTPUN == '2'
			cUnW7 := SW7->W7_XUN1
			SAH->(DbSetOrder(1))
			SAH->(DBSEEK(xFilial("SAH")+cUnW7))
		EndIf
		
	Case alltrim(cParam) == "VAL_FOB"
	  If SW7->W7_XPLIQ <> 0
		nSomaPesoL -= nPeso_L
		
		nPeso_L := SW7->W7_XPLIQ
		
		If Len(Alltrim(Str(Int(nPeso_L)))) <= 5
			cTexto := STUFF(cTexto,057+nInc2,012,ORI100Numero(nPeso_L,05,06,.T.))
		Else
			cTexto := STUFF(cTexto,057+nInc2,012,ORI100Numero(nPeso_L,09,02,.T.))
		EndIf
		
		nSomaPesoL += nPeso_L
	 Endif	
EndCase

Return