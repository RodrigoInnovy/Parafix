#Include "Protheus.ch"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Rotina que carrega o aCols com os dados dos Empenhos.³
//³                                                     ³
//³Autor: Rodrigo Bighetti                              ³
//³Data: 13/12/2011                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

User Function PRXESTA01()
	Local aAreaSD3 := SD3->(GetArea())
	Local aParam := {}
	Local aDados := {}
		
	aAdd(aParam,{1,"Ordem de Produção",Space(11),"@!","","SC2","",80,.T.})
	
	if ParamBox(aParam,"Parâmetros",@aParam,,,.T.,,,,,.F.,.F.)
		Processa({||fProcessa()}, "Aguarde Carregando Lista")
	endif             
	
	RestArea(aAreaSD3)
Return

//Carrega aCols com os empenhos da OP
Static Function fProcessa()
	Local nReg := 0	    
	Local aDados := {}
	
	Local cOrigem	:= Alltrim(GetMv("MV_ZZORIG"))
	Local cDestino := Alltrim(GetMv("MV_ZZLOCPR"))
	
	Local nProdOri := aScan(aHeader,{|x| AllTrim(x[2]) == "D3_COD"})  
	Local nDescOri := aScan(aHeader,{|x| AllTrim(x[2]) == "D3_DESCRI"})  
	Local nUmOri   := aScan(aHeader,{|x| AllTrim(x[2]) == "D3_UM"})  
	Local nLocOri  := aScan(aHeader,{|x| AllTrim(x[2]) == "D3_LOCAL"})       
	Local nPosOP	:= aScan(aHeader,{|x| Alltrim(x[2]) == "D3_ZZOP"})
	Local nPos2UM  := aScan(aHeader,{|x| Alltrim(x[2]) == "D3_SEGUM"})
	
	Local nProdDes := aScan(aHeader,{|x| AllTrim(x[2]) == "D3_COD"},nProdOri+4)  
	Local nDescDes := aScan(aHeader,{|x| AllTrim(x[2]) == "D3_DESCRI"},nDescOri+4)  
	Local nUmDes   := aScan(aHeader,{|x| AllTrim(x[2]) == "D3_UM"},nUmOri+4)  
	Local nLocDes  := aScan(aHeader,{|x| AllTrim(x[2]) == "D3_LOCAL"},nLocOri+4)  
	
	Local cLocDest  := Space(2) 
	Local nQuant   := aScan(aHeader,{|x| AllTrim(x[2]) == "D3_QUANT"})  
		
	if Select("TSD4") <> 0
		TSD4->(dbCloseArea())
	endif

   BEGINSQL ALIAS "TSD4"
   	SELECT * FROM %TABLE:SD4% SD4
   	INNER JOIN %TABLE:SB1% SB1 ON (SB1.B1_COD = SD4.D4_COD)
   	WHERE
   		SD4.%NOTDEL%
   		AND SB1.%NOTDEL%
   		AND SD4.D4_FILIAL = %XFILIAL:SD4%
   		AND SB1.B1_FILIAL = %XFILIAL:SB1%
   		AND SD4.D4_OP = %EXP:MV_PAR01%         
   		AND (SB1.B1_TIPO = 'MP' OR SB1.B1_TIPO = 'PI')
   	ORDER BY SD4.D4_COD
   ENDSQL
                
   dbSelectArea("TSD4")
	Count to nReg
	ProcRegua(nReg)
	
	dbSelectArea("TSD4")
	dbGoTop()
	
	While TSD4->(!Eof())
	
		aTemp := {}
		
		aAdd(aTemp, TSD4->D4_COD)		&&Produto
		aAdd(aTemp, TSD4->B1_DESC)		&&Descrição Produto
		aAdd(aTemp, TSD4->B1_UM)		&&Unidade Medida
		aAdd(aTemp, TSD4->D4_LOCAL)	&&Almoxarifado Origem
		aAdd(aTemp, TSD4->D4_OP)		&&Numero OP
		
		aAdd(aDados, aTemp)
		
		TSD4->(dbSkip())
	EndDo
	
	TSD4->(dbCloseArea())
	
	if Len(aDados) > 0 
		aCols := {}
		For nI:=1 to Len(aDados)
			aAdd(aCols,Array(Len(aHeader)+1))

			For nX:=1 to Len(aHeader)
				aCols[Len(aCols),nX] := CriaVar(aHeader[nX,2])
			Next

			nPos := Len(aCols)
			aCols[nPos,Len(aHeader)+1] := .F.

			//Dados de Origem
			aCols[nPos,nProdOri] := aDados[nI,1]
			aCols[nPos,nDescOri] := aDados[nI,2]
			aCols[nPos,nUmOri]	:= aDados[nI,3]
			aCols[nPos,nLocOri]	:= cOrigem
			aCols[nPos,nPosOP]	:= aDados[nI,5]

			//Dados de Destino
			aCols[nPos,nProdDes] := aDados[nI,1]
			aCols[nPos,nDescDes] := aDados[nI,2]
			aCols[nPos,nUmDes]	:= aDados[nI,3]
			aCols[nPos,nLocDes]	:= cDestino
		Next
	
		else
		MsgStop("Esta Ordem de Produção não Possui Empenhos !!",FunName())
		Return .F.
	endif
		
Return .T.