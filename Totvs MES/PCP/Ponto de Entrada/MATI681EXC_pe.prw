#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} MATI681EXC
Ponto de entrada para estorno do endereçamento no estorno do apontamento
de produção.

@type	User Function
@author 	João Gustavo Orsi
@since 	28/02/2018
@version P12
/*/
user function MATI681EXC()
	Local nEstorno  := aScan(PARAMIXB,{|aX| AllTrim(aX[1]) == "IDESTORNO"})
	Local lAchou    := .F.
	Local aRet      := {.T.,""}
	Local aCab      := {}
	Local aItens    := {}
	Local aErroAuto := {}
	Local nCount    := 0
	Local aStruDB   := {}
	Local nX        := 0
	Local aAreaH6   := SH6->(GetArea())
	Local aAreaD3   := SD3->(GetArea())
	Local aAreaDA   := SDA->(GetArea())
	Local aAreaDB   := SDB->(GetArea())
	
	If nEstorno > 0
		SH6->(dbGoTo(PARAMIXB[nEstorno,2]))
		
		lAchou := .F.
		SD3->(dbSetOrder(1))
		SD3->(dbSeek(xFilial("SD3")+SH6->H6_OP+SH6->H6_PRODUTO))
		While !SD3->(EOF()) .And. xFilial("SD3")+SH6->H6_OP+SH6->H6_PRODUTO == SD3->D3_FILIAL+SD3->D3_OP+SD3->D3_COD
			If SD3->D3_ESTORNO == "S"
				SD3->(dbSkip())
				Loop
			EndIf
			If SD3->D3_IDENT == SH6->H6_IDENT .And. SD3->D3_CF == "PR0"
				lAchou := .T.
				Exit
			EndIf
			SD3->(dbSkip())
		EndDo
		If lAchou
			SDA->(dbSetOrder(1))
			If SDA->(dbSeek(xFilial("SDA")+SD3->(D3_COD+D3_LOCAL+D3_NUMSEQ)))
				aCab := {{"DA_PRODUTO",SD3->D3_COD   , nil},;
						{"DA_LOCAL"  ,SD3->D3_LOCAL  , nil},;
						{"DA_NUMSEQ" ,SD3->D3_NUMSEQ , nil},; 
						{"DA_DOC"    ,SD3->D3_DOC    , nil}}

				SDB->(dbSetOrder(1))
				If SDB->(dbSeek(xFilial("SDB")+SD3->(D3_COD+D3_LOCAL+D3_NUMSEQ+D3_DOC)))
					aStruDB := SDB->(dbStruct())
					
					While SDB->(!Eof()) .And. SDB->(DB_FILIAL+DB_PRODUTO+DB_LOCAL+DB_NUMSEQ+DB_DOC) == ;
					                          xFilial("SDB")+SD3->(D3_COD+D3_LOCAL+D3_NUMSEQ+D3_DOC)
						
						If SDB->DB_ESTORNO == "S"
							SDB->(dbSKip())
							Loop
						EndIf
						
						aAdd(aItens,{})
						For nX := 1 To Len(aStruDB)
							aAdd(aItens[Len(aItens)],{aStruDB[nX,1],&("SDB->"+aStruDB[nX,1]),Nil})
						Next nX
						nX := aScan(aItens[Len(aItens)],{|x| AllTrim(x[1]) == "DB_ESTORNO"})
						If nX > 0
							aItens[Len(aItens),nX,2] := "S"
						Else
							aAdd(aItens[Len(aItens)],{"DB_ESTORNO","S",Nil})
						EndIf
						/*aAdd(aItens,{{'DB_ITEM',SDB->DB_ITEM,NIL},;
								{'DB_LOCAL',SDB->DB_LOCAL,NIL},;
								{'DB_LOCALIZ',SDB->DB_LOCALIZ,NIL},;
								{'DB_QUANT',SDB->DB_QUANT,NIL},;
								{'DB_DATA',SDB->DB_DATA,NIL},;
								{'DB_PRODUTO',SDB->DB_PRODUTO,NIL},;
								{'DB_NUMSERI',SDB->DB_NUMSERI,NIL},;
								{'DB_ESTORNO','S',Nil}})*/
						
						SDB->(dbSkip())
					End
				EndIf
				If Len(aCab) > 0 .And. Len(aItens) > 0
					lMSErroAuto := .F.
					msExecAuto({|x,y,z| mata265(x,y,z)},aCab,aItens,4)
					If lMsErroAuto
						aErroAuto := GetAutoGRLog() 
			
						For nCount := 1 To Len(aErroAuto)
							aRet[2] += StrTran( StrTran( aErroAuto[nCount], "<", "" ), "-", "" ) + (" | ")
						Next nCount
						aRet[1] := .F.
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
	
	SH6->(RestArea(aAreaH6))
	SD3->(RestArea(aAreaD3))
	SDA->(RestArea(aAreaDA))
	SDB->(RestArea(aAreaDB))
return aRet