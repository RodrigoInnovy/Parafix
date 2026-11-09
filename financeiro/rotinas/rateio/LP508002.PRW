#include "rwmake.ch"


//------------------------------------------------------------------------------------------\\
//TITULO: CRIAÇÃO DA L.P. 508 PARA RATEIO CONTAS A PAGAR NO CENTRO DE CUSTO                 \\
//------------------------------------------------------------------------------------------\\
//                                OBJETIVO:                                                 \\                                                                                                                                                                                                                           
//ESSA FUNÇÃO É PARA EXECUTAR NA LP DE RATEIO 508 COM EXECBLOCK("LP508002")                 \\                                                                                                                                                                
//Antes de retornar os lançamentos, será validado atraves desse programa se contei as       \\
//informações necessárias para o rateio .                                                   \\
//------------------------------------------------------------------------------------------\\
//       Empresa: PARAFIX      |          ATT:Renan Cosmos         |     DATA: 26/10/2021   \\                 
//------------------------------------------------------------------------------------------\\


User Function LP508002()

SetPrvt("_CALIAS,_REC,_INDEX,_VVALOR,")

_cAlias := Alias()
_Rec    := Recno()
_INdex  := Indexord()


IF(SE2->E2_MULTNAT <>"2") .AND. (SEV->EV_RATEICC=="1") 
    _vvalor  :=SEZ->EZ_VALOR
	
		else
			_vvalor:= 0
			
endif



DbSelectArea(_cAlias)
DbSetOrder(_Index)
DbGoto(_rec)

Return(_vvalor)
