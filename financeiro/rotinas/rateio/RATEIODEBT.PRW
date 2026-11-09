#include "rwmake.ch"

//------------------------------------------------------------------------------------------\\
//TITULO: CRIAÇÃO DA L.P. 511 PARA RATEIO                                                   \\
//------------------------------------------------------------------------------------------\\
//                                OBJETIVO:                                                 \\                                                                                                                                                                                                                           
//ESSA FUNÇÃO É PARA EXECUTAR NA LP DE RATEIO 511 EXECBLOCK("RATEIODEBT")                   \\                                                                                                                                                                
//LP CRIADA PARA DIFERENCIAR O RATEIO MANUAL DO PRÉ-CONFIGURADO(INCLUSÃO NO CONTAS A PAGAR) \\
//------------------------------------------------------------------------------------------\\
//       Empresa: PARAFIX      |          ATT:Renan Cosmos         |     DATA: 22/10/2021   \\                 
//------------------------------------------------------------------------------------------\\
                                                                                                                              

User Function RATEIODEBT()
Local aAreaTMP:= GetArea()
SetPrvt("_CALIAS,_REC,_INDEX,_CCONTA,")


	_cAlias := Alias()
	_rec    := Recno()
	_index  := Indexord()



Do Case
	Case ALLTRIM(CV4->CV4_HIST) $ "MANUAL"
		_cconta :=  SED->ED_CONTA
				
	Otherwise
		
		  _cconta := ALLTRIM(CV4->CV4_DEBITO)
	
EndCase

DbSelectArea(_cAlias)
DbSetOrder(_index)
DbGoto(_rec)              

RestArea(aAreaTMP)

Return(_cconta)          
     
