#include "rwmake.ch"

//------------------------------------------------------------------------------------------\\
//TITULO: CRIAÇÃO DA L.P. 511 PARA RATEIO                                                   \\
//------------------------------------------------------------------------------------------\\
//                                OBJETIVO:                                                 \\                                                                                                                                                                                                                           
//ESSA FUNÇÃO É PARA EXECUTAR NA LP DE RATEIO 511 EXECBLOCK("RATEIOCRED")                   \\                                                                                                                                                                
//LP CRIADA PARA DIFERENCIAR O RATEIO MANUAL DO PRÉ-CONFIGURADO(INCLUSÃO NO CONTAS A PAGAR) \\
//------------------------------------------------------------------------------------------\\
//       Empresa: PARAFIX      |          ATT:Renan          |       DATA: 22/10/2021       \\                 
//------------------------------------------------------------------------------------------\\

User Function RATEIOCRED()
Local aAreaTMP:= GetArea()
SetPrvt("_CALIAS,_REC,_INDEX,_CCONTA,")


	_cAlias := Alias()
	_Rec    := Recno()
	_INdex  := Indexord()



Do Case
	Case ALLTRIM(CV4->CV4_HIST) $ "MANUAL"
		_cconta := SA2->A2_CONTA 
		
		
	Otherwise
		
		  _cconta := ALLTRIM(CV4->CV4_CREDIT)
	
EndCase

DbSelectArea(_cAlias)
DbSetOrder(_Index)
DbGoto(_Rec)              

RestArea(aAreaTMP)

Return(_cconta)               
