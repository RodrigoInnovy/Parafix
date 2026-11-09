#INCLUDE "TOTVS.ch" 
#Include 'Topconn.ch'
#include "apvt100.ch"


/*/{Protheus.doc} 
Check Embarque
@type function
@author Gerson
@since 06/04/2022
@version 1.0
/*/
User Function CHECKEMB()

Local aTela			:= {}
Local nCol			:= 0
Local nCol1			:= 03
Local nCol2			:= 12
Local nLin 			:= 0

Private nQtdLida    := 0
Private nQtdAcumu   := 0
Private aEtiqueta   := {}
Private aEtiCaixa   := {}
Private aEtiAux     := {}
Private aPalete     := {}
Private cOrdem		:= space(Len(CB8->CB8_ORDSEP))
Private nQtdTotal   := 0 // Quantidade Total dos Lotes da Ordem de Separação
Private nQtdLote    := 0
Private lFinal      := .f.

While .T.
	
	aTela := VTSave() 
	cOrdem	 := space(Len(CB8->CB8_ORDSEP))
	nLin	 := 0
	nCol	 := 0
	nCol1	 := 3
	nCol2	 := 12
	aEtiqueta:= {}	
	aEtiCaixa:= {}
	aEtiAux     := {}
	aPalete     := {}
	nQtdLida    := 0
	nQtdAcumu   := 0
	nQtdTotal   := 0
	nQtdLote    := 0
	lFinal      := .f.


	VTCLEAR()
	@ nLin,nCol vtSay "Check Embarque" 
	nLin+=2
	@ nLin,nCol VTSAY "ORDEM DE SEPARACAO:"
	nLin++ 
	@ nLin,nCol VTGET cOrdem pict '@!'  Valid !Empty(cOrdem) .and. validaOrdem() //F3 "SC2APO"	                                                                
	VTREAD()

	If vtLastKey() == 27
		If VTYesNo("Deseja Sair do Processo ?","Atencao",.T.)
			exit
    	else
          	loop                                    
		endif
	EndIf

	//abre tela para digitação do Palete
	telaPalete()

	VtRestore(,,,,aTela)		
		
EndDo

Return


/*/{Protheus.doc} telaPaleteo
Abre Tela para leitura da etiqueta do Palete
@type function
@author Gerson
@since 06/04/2022
@version 1.0
/*/


Static Function telaPalete()

Local cEtqPalete	:= Space(44) //space(Len(SD4->D4_LOTECTL))
Local cProduto      := space(Len(CB8->CB8_ORDSEP))
Local cLote         := space(Len(CB8->CB8_LOTECT))
Local lOk           := .t.

While .t.

	nCol			:= 0
	nCol1			:= 3
	nLin 			:= 0
	cEtqPalete		:= Space(44)  

	
	//VTSetKey(12,{|| ConsultaAux()},"Consumo Coletados")
	
	if !lFinal
		VTCLEAR()
		@ nLin,nCol vtSay "Check Embarque" 
		nLin+=2
		@ nLin,nCol VTSAY "ORDEM DE SEPARACAO:"
		nLin++ 
		@ nLin,nCol VTGET cOrdem pict '@!'  When .F.	                                                                

		nLin+=2
		@ nLin,nCol VTSAY "Palete:"
		nLin++ 
		@ nLin,nCol VTGET cEtqPalete  pict '@!' Valid !Empty(cEtqPalete) .and. validaEtqPalete(@cEtqPalete,@cProduto,@cLote) when .t. 
		VTREAD()
		
		If vtLastKey() == 27
			If VTYesNo("Finalizar Leitura Etq. Palete ?","Atencao",.T.)
				lOk:= finaliza(cProduto, cLote, 1)
				if lOk
					exit
				else
					loop	   
				endif	   
			else
				exit
				//loop                                      
			endif
		EndIf

		telaCaixa(cProduto, cLote)
	else
		exit	
	endif
enddo

Return



/*{Protheus.doc} telaCaixa
Abre Tela para leitura da etiqueta de Caixa/Rolo
@type function
@author Gerson
@since 06/04/2022
@version 1.0
*/

Static Function telaCaixa(cProduto, cLote)

Local cEtqCaixa  	:= Space(80) //space(Len(SD4->D4_LOTECTL))
Local cDescProd  	:= space(Len(SB1->B1_DESC))

While .t.

	nCol			:= 0
	nCol1			:= 3
	nCol2			:= 9
	nLin 			:= 0
	cEtqCaixa		:= Space(80)  
	
	//VTSetKey(06,{|| finaliza()},"Check Embarque") // CTRL+F

	SB1->(dbSetOrder(1))
	if SB1->(dbSeek(xFilial("SB1")+cProduto))
		cDescProd:= Alltrim(SB1->B1_DESC)
	else
		VTBEEP(2)
		VTALERT("PRODUTO NAO ENCONTRADO")	
	endif	
	
	VTCLEAR()
	@ nLin,nCol vtSay "Check Embarque" 
	nLin+=2
	@ nLin,nCol  VTSAY "PRODUTO:"
	@ nLin,nCol2 VTGET cProduto pict '@!'  When .F.	
	nLin++ 
	@ nLin,nCol  VTGET cDescProd pict '@!' when .f.                                                                
	nLin++
	@ nLin,nCol  VTSAY "LOTE   :"
	@ nLin,nCol2 VTGET cLote pict '@!'  When .F.	
	nLin+=2
	@ nLin,nCol VTSAY "Leia Etiqueta Caixa:"
	nLin++ 
	@ nLin,nCol VTGET cEtqCaixa  pict '@!' Valid !Empty(cEtqCaixa) .and. validaEtqCaixa(@cEtqCaixa, cProduto, cLote) when .t. 
	VTREAD()
	
	If vtLastKey() == 27
		If VTYesNo("Finaliza Leitura Etiqueta ?","Atencao",.T.)
			lOk:= finaliza(cProduto, cLote, 2)
			if lOk
				nQtdLida:= 0
				CB7->(dbSetOrder(1))
				if CB7->(dbSeek(xFilial("CB7")+cOrdem))
					RecLock("CB7",.f.)
					CB7->CB7_ZZCHEC:= "1"
					msunlock()
				endif
       			exit
			else
				//cEtqCaixa	:= Space(40)
				//VTGetRefresh("cEtqCaixa")
				CB7->(dbSetOrder(1))
				if CB7->(dbSeek(xFilial("CB7")+cOrdem))
					RecLock("CB7",.f.)
					CB7->CB7_ZZCHEC:= "2"
					msunlock()
				endif
				loop	   
			endif	   
    	else
			If VTYesNo("Abandonar Leitura Etiqueta ?","Atencao",.T.)
				exit
			else	
         	 	loop                                    
			endif	  
		endif
	EndIf

enddo

Return


Static Function finaliza(cProduto, cLote, nTela )

Local nPos:= 0
Local lRet:= .t.
Local nX  := 0

nQtdLida:= 0

For nX:= 1 to Len(aEtiAux)
	nQtdLida+= aEtiAux[nX,3]
Next nX

if nTela = 2
	
	nQtdLote++

	nPos:=	aScan( aEtiqueta, { |k| Alltrim(k[1]) == Alltrim(cProduto) .and. Alltrim(k[2]) == Alltrim(cLote) })

	if aEtiqueta[nPos,3] > nQtdLida
		VTBEEP(2)
		VTalert("Qtd. Menor que OS",FunDesc())
		lRet:= .f.
	elseif aEtiqueta[nPos,3] < nQtdLida
		VTBEEP(2)
		VTalert("Qtd. Maior que OS",FunDesc())
		lRet:= .f.	
	else
		VTBEEP(2)
		if Len(aEtiqueta) = 1
			VTalert("Conferencia Finalizada",FunDesc())
			lFinal:= .t.
		else
			if Len(aEtiqueta) > nQtdLote
				VTalert("Leia proximo Palete",FunDesc())
				nQtdLida:= 0
				aEtiAux:= {}
			elseif Len(aEtiqueta) = nQtdLote	
				VTalert("Conferencia Finalizada",FunDesc())
				lFinal:= .t.
			endif	
		endif		
	endif
elseif nTela = 1

	if nQtdTotal <> nQtdLida
		VTBEEP(2)
		VTalert("Falta Etiqueta para ser lida",FunDesc())
		If VTYesNo("Abandonar Leitura Etiqueta ?","Atencao",.T.)
			lRet:= .t.
		else
			lRet:= .f.	
		endif	  
	endif
endif

Return(lRet)


// Validação da Ordem de Separação (Tela 01)
Static Function validaOrdem()

Local aArea   := GetArea()
Local aAreaCB8:= CB8->(GetArea())
Local lRet    := .t.
Local cAlias  := GetNextAlias()

CB7->(dbSetOrder(1))
if !CB7->(dbSeek(xFilial("CB7")+cOrdem))
	VTBEEP(2)
	VTalert("Ordem Nao Encontrada",FunDesc())

	cOrdem:= space(Len(CB8->CB8_ORDSEP))
	VTGetRefresh("cOrdem")
	lRet:= .f.
else
	if CB7->CB7_ZZCHEC = "1"
		VTBEEP(2)
		VTalert("Ja foi feito Check para essa OS",FunDesc())
		cOrdem:= space(Len(CB8->CB8_ORDSEP))
		VTGetRefresh("cOrdem")
		lRet:= .f.
	elseif CB7->CB7_ZZCHEC = "2"
		VTBEEP(2)
		VTalert("OS Finalizada com divergencia",FunDesc())
		cOrdem:= space(Len(CB8->CB8_ORDSEP))
		VTGetRefresh("cOrdem")
		lRet:= .f.
	elseif !Empty(CB7->CB7_NOTA)
		VTBEEP(2)
		VTalert("Nota Fiscal nao foi emitida",FunDesc())
		cOrdem:= space(Len(CB8->CB8_ORDSEP))
		VTGetRefresh("cOrdem")
		lRet:= .f.
	else

		If(Select(cAlias) > 0)
			(cAlias)->(DBCloseArea())
		EndIf
		
		cQuery := " SELECT CB8_PROD, CB8_LOTECT, CB8_QTDORI " + CRLF
		cQuery += " FROM " + CRLF
		cQuery += " 	" + RetSqlName("CB8") + "   " + CRLF
		cQuery += " WHERE " + CRLF
		cQuery += "     CB8_FILIAL  = '" + xFilial("CB8") +"'	AND	"+ CRLF
		cQuery += "     CB8_ORDSEP  = '" + cOrdem +"'			AND	"+ CRLF
		cQuery += " 	D_E_L_E_T_ = ' ' " + CRLF
		
		TcQuery cQuery New Alias &cAlias

		(cAlias)->(dbGotop())
		While !(cAlias)->(Eof())

				AADD( aEtiqueta, { (cAlias)->CB8_PROD, (cAlias)->CB8_LOTECT, (cAlias)->CB8_QTDORI })

			nQtdTotal+= (cAlias)->CB8_QTDORI

			(cAlias)->(dbSkip())
		enddo

		(cAlias)->(dbCloseArea())
	
	endif

endif

RestArea(aAreaCB8)
RestArea(aArea)

Return(lRet)


// Validação da Etiqueta de Palete (Tela 02)
Static Function validaEtqPalete(cEtqPalete,cProduto,cLote)

Local cAlias  := GetNextAlias()
Local cProd   := Substr(cEtqPalete,5,10) //produto da etiqueta lida (pegar posição)
Local cLoteCT := Substr(cEtqPalete,19,11) //lote da etiqueta lida (pegar posição)
Local lRet    := .t.

//vtalert("PRODUTO: "+cProd)
//vtalert("LOTE: "+cLoteCT)

If(Select(cAlias) > 0)
	(cAlias)->(DBCloseArea())
EndIf

cQuery := " SELECT COUNT(*) AS QTDREG " + CRLF
cQuery += " FROM " + CRLF
cQuery += " 	" + RetSqlName("CB8") + "   " + CRLF
cQuery += " WHERE " + CRLF
cQuery += "     CB8_FILIAL  = '" + xFilial("CB8") +"'	AND	"+ CRLF
cQuery += "     CB8_ORDSEP  = '" + cOrdem +"'			AND	"+ CRLF
cQuery += "     CB8_PROD    = '" + cProd +"'			AND	"+ CRLF
cQuery += "     CB8_LOTECT  = '" + cLoteCT +"'			AND	"+ CRLF
cQuery += " 	D_E_L_E_T_  = ' ' " + CRLF

TcQuery cQuery New Alias &cAlias

if (cAlias)->QTDREG = 0
	VTBEEP(2)
	VTalert("Etiqueta Invalida !",FunDesc())
	cEtqPalete	:= Space(44)
	VTGetRefresh("cEtqPalete")
	lRet:= .f.
else
	nPos:=	aScan( aPalete, { |k| k[1] == cProd .and. k[2] == cLoteCT })
	if nPos = 0
		AADD( aPalete, { cProd, cLoteCT })
	else
		VTBEEP(2)
		VTalert("Palete Já foi Lido",FunDesc())
		VTalert("Palete Já foi Lido",FunDesc())
		cEtqPalete:= Space(44)
		VTGetRefresh("cEtqPalete")
		lRet:= .f.
	endif
	cProduto:= cProd
	cLote   := cLoteCT
		
endif	

(cAlias)->(dbCloseArea())

Return(lRet)


//Validação da Etiqueta de Caixa/Rolo (Tela 03)
Static Function validaEtqCaixa(cEtqCaixa, cProduto, cLote)

//Local cAlias   := GetNextAlias()
Local lRet     := .t.
Local cProdLido:= Substr(cEtqCaixa,5,10) //produto da etiqueta lida (pegar posição)
Local cLoteLido:= Substr(cEtqCaixa,19,11) //lote da etiqueta lida (pegar posição)
Local nQtd     :=VAL(Alltrim(Substr(cEtqCaixa,34,20))) //lote da etiqueta lida (pegar posição)
Local nPos     := 0


nPos:= aScan( aPalete, { |k| k[1] == cProdLido .and. k[2] == cLoteLido })
if nPos <> 0
//if Alltrim(cProdLido ) = Alltrim(cProduto) .and. Alltrim(cLoteLido) = Alltrim(cLote)
	VTBEEP(2)
	VTalert("Etiqueta Ivalida (Palete) !",FunDesc())
	cEtqCaixa:= Space(80)
	VTGetRefresh("cEtqCaixa")
	lRet:= .f.
	Return(lRet)
endif

if Alltrim(cProdLido) <> Alltrim(cProduto)
	VTBEEP(2)
	VTalert("Produto Invalido !",FunDesc())
	lRet:= .f.
else

	nPos:=	aScan( aEtiCaixa, { |k| k[1] == cProdLido .and. k[2] == cLoteLido })

	if nPos = 0
		AADD( aEtiCaixa, { cProdLido, cLoteLido, nQtd })
		AADD( aEtiAux, { cProdLido, cLoteLido, nQtd })
		
		//nQtdLida+= nQtd
		//nQtdAcumu+= nQtd
	else
		VTBEEP(2)
		VTalert("Etiqueta Já foi Lida !",FunDesc())
		cEtqCaixa:= Space(80)
		VTGetRefresh("cEtqCaixa")
		lRet:= .f.
	endif		
	
Endif	 	

//(cAlias)->(dbCloseArea())

Return(lRet)

