#INCLUDE "TBICONN.CH"
#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ MTA410     ³ Autor ³                     ³ Data ³27/11/2016³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Ponto Entrada na NF Entrada na validacao final do PV para  ³±±
±±³          ³ validar se PV de Transferencia em casos afirmativo gravar  e±±
±±³          ³ dados na NF Origem (SD1), para nao reutilização da mmesma. ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ COMPRAS                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MTA410()

Local _aArea    := GetArea()
Local _aAreaSD1 := SD1->(GetArea())    
Local _aAreaSD3 := SD3->(GetArea())

Local _cNFSerie := ""            
Local _cTipo    := M->C5_TIPO
Local _cCodPrd   := space(15)
Local _cCli     := M->C5_CLIENTE 
Local _cLoja    := M->C5_LOJACLI
Local _nPProduto := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRODUTO"})
Local _nPLocal   := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_LOCAL"})
Local _cLocal    := ""
Local _cOP       := ""
Local _cItmOP    := ""

If M->C5_TIPO == "N" .and. M->C5_ZZTRANS == "1" //1=Sim -> PV de Transferencia? (M->C5_ZZTRAN)
	For n:=1 To Len(aCols)
		For nX:=1 To Len(aHeader)
			Do Case
				Case AllTrim(aHeader[nX][2]) == "C6_ZZNFFRT"
					_cNFSerie := aCols[n][nX]
				Case AllTrim(aHeader[nX][2]) == "C6_ITEM"
					_cItem := aCols[n][nX]
				Case AllTrim(aHeader[nX][2]) == "C6_PRODUTO"
					_cCodPrd := aCols[n][nX]
				Case AllTrim(aHeader[nX][2]) == "C6_LOCAL"
					_cLocal  := aCols[n][nX]
				Case AllTrim(aHeader[nX][2]) == "C6_CLI"
					_cCli  := aCols[n][nX]
				Case AllTrim(aHeader[nX][2]) == "C6_LOJA"
					_cLoja := aCols[n][nX]
				Case AllTrim(aHeader[nX][2]) == "C6_NUMOP"
					_cOP   := aCols[n][nX]
				Case AllTrim(aHeader[nX][2]) == "C6_ITEMOP"
					_cItmOP := aCols[n][nX]
			End		
		Next nX 
	
    	SD1->(dbSetOrder(1))
	    If SD1->(dbSeek(xFilial("SD1")+_cNFSerie))
			RecLock("SD1",.f.)
				SD1->D1_ZZTRF := "S"
			MsUnlock()
	    EndIf         
 	Next n   
ElseIf M->C5_TIPO = "B" .and. M->C5_ZZTRANS == "1" .and. Inclui

		If TYPE ("_aItemSD3") == "A"

	    	//Atualiza Flag das MP´s no SD3
		    GravaSD3(_aItemSD3)
	    
	    Endif

EndIf

RestArea(_aAreaSD3)
RestArea(_aAreaSD1)
RestArea(_aArea)

Return(.t.)

// Preenche cammpo D3_ZZTRF com numero do PV   
Static Function GravaSD3(_aItemSD3)
Local _aArea     := GetArea()
Local _aAreaSD3  := SD3->(GetArea())
Local aArea      := SD3->(GetArea())
Local _cQuery    := ""
Local _cAliasSD3 := ""

For i := 1 to Len(_aItemSD3)

 cQry := "UPDATE " + RetSqlName("SD3") + " SET D3_ZZTRF = '"+M->C5_NUM+"' "
 cQry += "FROM " + RetSqlName("SD3") + " "
 cQry += "WHERE D_E_L_E_T_ = ' ' and "
 cQry += "D3_NUMSEQ = '"+_aItemSD3[i]+"' "
 TCSqlExec( cQry )

Next i

_aItemSD3 := {}

//Restaura areas salvas
RestArea(_aAreaSD3)
RestArea(_aArea)

Return