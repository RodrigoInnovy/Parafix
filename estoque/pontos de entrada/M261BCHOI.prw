#Include "Protheus.ch"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄx
//³PE para inclusão do botão "OP" na tela de transferencias³
//³                                                        ³
//³Autor: Rodrigo Bighetti                                 ³
//³Data: 13/12/11                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄx

User Function M261BCHOI()
	Local aArea := GetArea()
	Local aBtn := {}
	
	aAdd(aBtn,{'NOTE',{|| U_PRXESTA01() },'ORD'})
	//aAdd(aBtn,{'NOTE',{|| U_PRXSBF() },'AutoSBF'})	
	        
   RestArea(aArea)
Return(aBtn)
