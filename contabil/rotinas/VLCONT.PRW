#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VlCONT    ºAutor  ³Ronaldo Fernandes   º Data ³  17/01/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gera Lancamento Padrao Contabilidade CTB                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CTB -  PARAFIX                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function VLCONT()
Local aAreaTMP:= GetArea()
SetPrvt("_CALIAS,_REC,_INDEX,_CCONTA,")

//u_RetNrCheq()

_cAlias := Alias()
_Rec    := Recno()
_INdex  := Indexord()

Do Case
	Case ALLTRIM(SE2->E2_NATUREZ) == "CSLL"
		_cconta := "2101110301"
		
	Case ALLTRIM(SE2->E2_NATUREZ) == "PIS"
		_cconta := "2101110301"
		
	Case ALLTRIM(SE2->E2_NATUREZ) == "ISS"
		_cconta := "2101110401"
		
	Case ALLTRIM(SE2->E2_NATUREZ) == "COFINS"
		_cconta := "2101110301"
		
	Case ALLTRIM(SE2->E2_NATUREZ) == "IRF"
		_cconta := "2101119001"
		
	Case ALLTRIM(SE2->E2_NATUREZ) == "INPS"
		_cconta := "2101110702"
		
	Case ALLTRIM(SE2->E2_NATUREZ) == "IPI"
		_cconta := "2101110101"
		
	Case ALLTRIM(SE2->E2_TIPO) == "PA"
		_cconta := ALLTRIM(SA6->A6_CONTA)
		
			
	Otherwise
		//Alteração para buscar a conta da Natureza - Lucas Silva em 04/08/2021
		  _cconta := ALLTRIM(SA2->A2_CONTA)
		//_cconta := ALLTRIM(SED->ED_CONTA)
		
EndCase



DbSelectArea(_cAlias)
DbSetOrder(_Index)
DbGoto(_rec)              
RestArea(aAreaTMP)

Return(_cconta)               

//=========================================================
    // Funcao utilizada para gravar o numero do Cheque em 
    // todos os registro dos cheques .


//User Function F190CAN()
           
//RECLOCK("SEF")
//SEF->EF_HISTD:=SEF->EF_NUM
//SEF->(MSUnLock())
//Return .T.  

//=========================================================
     //Funcao utilizada no momento do cancelamento do cheque 
     
     
//User Function F190ICAN()
           
//If Empty(SEF->EF_LA)
//	RECLOCK("SEF")
//	SEF->EF_LA:="S"
//	SEF->(MSUnLock())
//EndIf

//Return .T.  
