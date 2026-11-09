#include "EECRDM.CH"
#INCLUDE "EECPEM49.CH"

#define ITENSPAG 15
#define ITENSPAG1 7

*------------------------------*
Static Function GravaItens()
*------------------------------*
Local nPalletTot := 0
Local nRorlosTot := 0
Local nQtdTot    := 0  
Local nBundle    := 0
Local cQuery	 := ""

While EE8->(!Eof() .And. EE8_FILIAL == xFilial("EE8")) .And. EE8->EE8_PEDIDO == EE7->EE7_PEDIDO
	
	UnlockDet()
	cItem := EE8->EE8_FATIT
	cSec :=StrZero(Val(EE8->EE8_SEQUEN),2)
	cProdcod:= EE8->EE8_COD_I    
	
	cLocProd := cProdcod+cItem+cSec
	nPalletSUM := 0
	nRorlosSUM := 0
	nQtdSUM    := 0
	
	cEE8Area := GetArea()
	
	//DbSelectArea("CB8")
	//CB8_FILIAL+CB8_PEDIDO+CB8_PRODUTO+CB8_ITEM+CB8_SEQUEN
	//If Dbseek(xFilial("CB8")+cPedFat+cLocProd)
		
		nPalletUn  := 1
		nBundle    := 0
		nContaPall := 0
		cOLdItem   := ""
		
		cQuery := "SELECT CB8_FILIAL, CB8_PEDIDO, CB8_ITEM, CB8_SEQUEN, CB8_PROD, CB8_LOTECT, CB8_QTDORI "
		cQuery += "FROM "+RetSqlName("CB8")+ " CB8 "
		cQuery += "WHERE CB8_PEDIDO = '"+cPedFat + "'"
		cQuery += "AND CB8_FILIAL  = '"+xFilial("CB8")+"'"
		cQuery += "AND CB8.D_E_L_E_T_ = ' ' "
		cQuery += "ORDER BY CB8_SEQUEN "
		
		cQuery := ChangeQuery( cQuery )
		dbUseArea( .T., "TOPCONN", TcGenQry( , , cQuery ), "Plist", .T., .T. )
		
		dbSelectArea("Plist")
		ProcRegua(Plist->(LastRec()))
		Plist->(DBGoTop())  
		
		
		While Plist->(!Eof())
			
			
			nBundle    += 1
			
			If nContaPall == 0 .or. nPalletUn == 1
				If nPalletUN == 1
					nPalletDiv := nPalletUn
				Else
					nPalletDiv := nPalletUn / 2 //nPalletUn
				Endif
				nPalletUn  += 1
				nContaPall += 1
			Else
				nPalletDiv := 0
				nPalletUn  += 1
				nContaPall := 0
			Endif
			
			AppendDet()
			
			DETAIL_P->AVG_C01_10 := Plist->CB8_ITEM
			
			DETAIL_P->AVG_C02_10 := cProdcod
			DETAIL_P->AVG_C01_20 := Transf(cProdcod,AVSX3("EE8_COD_I",6))


			If nPalletDiv <> 0
				DETAIL_P->AVG_C03_60 := Alltrim(Transf(nPalletDiv,"@E 9999"))
				nPalletSUM := nPalletDiv
			Else
				DETAIL_P->AVG_C03_60 := Replicate("-",60) //Replicate("-–—",60) //Replicate("—",60)
			Endif

		IF Substr(WorkId->EEA_ARQUIV,1,15) == 'PACKPARAF04.RPT' .or. Substr(WorkId->EEA_ARQUIV,1,15) == 'PACKPARAF03.RPT'
			DETAIL_P->AVG_C04_10 := Alltrim(Transf(nPalletSUM  ,"@E 9999"))
		Else 
			DETAIL_P->AVG_C04_10 := Alltrim(Transf(nBundle  ,"@E 9999"))
		Endif

			DETAIL_P->AVG_C05_20 := Plist->CB8_LOTECT
			cAliasC9 := GETAREA()
			   nxC9lib2 := Posicione("SC9",1,xFilial("SC9")+Plist->CB8_PEDIDO+Plist->CB8_ITEM+Plist->CB8_SEQUEN+Plist->CB8_PROD,"C9_QTDLIB2")   //Posicione("SC9",1,cPedFat+cItem+cSec+cProdcod,"C9_QTDLIB2")   
			   dxC9lib2 := Posicione("SC9",1,xFilial("SC9")+Plist->CB8_PEDIDO+Plist->CB8_ITEM+Plist->CB8_SEQUEN+Plist->CB8_PROD,"C9_DATALIB")  // Posicione("SC9",1,cPedFat+cItem+cSec+cProdcod,"C9_DATALIB")
			RestArea(cAliasC9)
			DETAIL_P->AVG_C05_10 := DtoC(dxC9lib2)     
			DETAIL_P->AVG_C02_20 := Alltrim(Transf(nxC9lib2,"@E 999"))
			nRorlosSUM+= nxC9lib2
			DETAIL_P->AVG_C04_20 := Alltrim(Transf(Plist->CB8_QTDORI,"@E 99,999.99"))
			nQtdSUM   += Plist->CB8_QTDORI
			
			cMemo := Posicione("EE2",1,xFilial("EE2")+AvKey("3","EE2_CODCAD")+AvKey("*","EE2_TIPMEN")+AvKey(EE7->EE7_IDIOMA,"EE2_IDIOMA")+AvKey(EE8->EE8_COD_I,"EE2_COD"),"EE2_TEXTO")
			If !Empty(cMemo)
				DETAIL_P->AVG_C01_60 := MemoLine( MSMM(cMemo,AVSX3("EE2_VM_TEX",3),,,LERMEMO) , AVSX3("EE2_VM_TEX",3) ,1 )
			Else
				cMemo := MSMM(EE8->EE8_DESC,AVSX3("EE8_VM_DES",3))
				For I:=1 to len(cMemo)
					If substr(cMemo,i,1)=="®"
						cMemo:=SUBSTR(cMemo,1,I-1)+CHR(169)+SUBSTR(cMemo,I+1,LEN(cMemo))
					Endif
				Next
				DETAIL_P->AVG_C01_60 := MemoLine( MSMM(cMemo,AVSX3("EE8_VM_DES",3),,,LERMEMO) , AVSX3("EE8_VM_DES",3) ,1 )
			EndIf
			          
      		 If Empty(DETAIL_P->AVG_C01_60)
          		DETAIL_P->AVG_C01_60 := Posicione("SB1",1,xFilial("SB1")+EE8->EE8_COD_I,"B1_DESC") 
       		 Endif
			
			UnLockDet()
			
			dbSelectArea("Plist")
			Plist->(dbSkip())
			//DETAIL_P->AVG_C01_10 := " "
		Enddo
		
		DETAIL_P->AVG_C06_20 := Alltrim(Transf(nPalletSUM,"@E 9999"))
		DETAIL_P->AVG_C07_20 := Alltrim(Transf(nRorlosSUM,"@E 99999"))
		DETAIL_P->AVG_C08_20 := Alltrim(Transf(nQtdSUM   ,"@E 9,999,999.99"))

   		nPalletTot += nPalletSUM  
		nRorlosTot += nRorlosSUM
		nQtdTot    += nQtdSUM
		
		nPalletSUM := 0
		nRorlosSUM := 0
		nQtdSUM    := 0    
		
	//Endif
	
	AppendDet()
	
	DETAIL_P->AVG_C01_10 := "**********"
	
	RestArea(cEE8Area)
	
	EE8->(dbSkip())
	

Enddo

	IF Substr(WorkId->EEA_ARQUIV,1,15) == 'PACKPARAF04.RPT' .or. Substr(WorkId->EEA_ARQUIV,1,15) == 'PACKPARAF03.RPT'             
      	HEADER_P->AVG_C01_30 := Alltrim(Transf((nPalletTot+1) 		 ,"@E 99999")) /// Alerado em 11/06/219        
	else
	    HEADER_P->AVG_C01_30 := Alltrim(Transf(nBundle   		 ,"@E 99999")) /// Alerado em 11/06/219
	endif
	HEADER_P->AVG_C03_30 := Alltrim(Transf(nRorlosTot 		 ,"@E 99999"))
	HEADER_P->AVG_C04_30 := Alltrim(Transf(nQtdTot		 	 ,"@E 9,99                                                                       9,999.99"))

AppendDet()
  DETAIL_P->AVG_C01_10 := "END"
UnLockDet()

Return NIL

