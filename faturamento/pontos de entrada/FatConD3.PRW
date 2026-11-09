#INCLUDE "PROTHEUS.CH"

User Function FatConD3()

Local aArea    := GetArea()
Local cProduto := SB1->B1_COD
Local cTipConv := SB1->B1_TIPCONV
Local nFatConv := SB1->B1_CONV
Local nQuant   := SD3->D3_QUANT
Local nQtdSeg  := SD3->D3_QTSEGUM

dbSelectArea("SB1")
Dbsetorder(1)

While !EOF()

	cProduto := SB1->B1_COD
	cTipConv := SB1->B1_TIPCONV
	nFatConv := SB1->B1_CONV
	
	dbSelectArea("SD3")
	Dbsetorder(5)
	If DbSeek(xFilial("SD3")+cProduto)
	
		//MsgAlert("Processando Produto -> "+ cProduto)
		
		WHILE SD3->D3_COD == cProduto
//		   MsgAlert(SB1->B1_COD+ " <----> "+SD3->D3_COD )
		
			nQuant := SD3->D3_QUANT 
			
			If cTipConv == 'M' .AND. nFatConv # 0
				nQtdSeg	:= nQuant * nFatConv
			Else
				If cTipConv == 'D' .AND. nFatConv # 0
					nQtdSeg	:= nQuant / nFatConv
				Else
					If nFatConv  = 0
						nQtdSeg := 0
					EndIf
				EndIf
			EndIf
			
			dbSelectArea("SD3")
			RecLock("SD3",.F.)
	 			SD3->D3_QTSEGUM	:= nQtdSeg
		    MsUnlock()
		    
            DbSkip()
            
		End
	EndIf    

	DbSelectArea("SB1")
    DbSkip()

End
RestArea(aArea)
MsgAlert(" FF I M ")
Return