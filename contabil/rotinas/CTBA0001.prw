# include "protheus.ch"
# include "topconn.ch"

/**
* Função        : CTBA0001
* Autor         : Tuning Sistemas - Clember Gaino Pinheiro
* Data          : 02/07/2015
* Descrição     : Rotina executada a partir do botão personalizado criado no menu do Rateio Off-Line.
*
* Parametros    : NA
*
* Retorno       : NA
*
* Observações:
*
*/

User Function CTBA0001

Local aArea   := GetArea()
Local aAreaCTQ:= CTQ->(GetArea())
Local aAreaSD3:= SD3->(GetArea())

Local nHrsTrb  := 0
Local nHrReal  := 0
Local lZero    := .F.
Local aQtdeProd := {}
Local nTotPerc 	:= 0
Local nLin		:= 0
Local nTotGer	:= 0
Local bAscan    := {}

Private nRegs := 0
//Private cPerg := "PERGUI"
Private cCCORI:= allTrim(CTQ->CTQ_CCORI)
Private dDatFec   := GetMv("MV_ULMES") + 1
Private cMesFec   := UltimoDia(dDatFec)

//CriaPerg(cPerg)
//Pergunte(cPerg)

aQtdeProd := FS_BuscaQtde(dDatFec,cMesFec)

For i := 1 To Len(aQtdeProd)
	nTotGer += aQtdeProd[i][2]
Next

DBSelectArea("TMP")
DBGoTop()
While !Eof()
	
	RecLock("TMP", .F.)
	TMP->CTQ_PERCEN := 0
	TMP->CTQ_FORMUL := "0"
	MSUnLock()
	
	For i := 1 To Len(aQtdeProd)
		
		If aQtdeProd[i][1] == Alltrim(TMP->CTQ_CCCPAR)
			
			RecLock("TMP", .F.)
			If nTotPerc = 100 .and.	round((aQtdeProd[i][2] / nTotGer) * 100,2) <> 0
				TMP->CTQ_PERCEN := 0
				TMP->CTQ_FORMUL := "0"
			Else
				TMP->CTQ_PERCEN := round((aQtdeProd[i][2] / nTotGer) * 100,2)
				TMP->CTQ_FORMUL := IIf(TMP->CTQ_PERCEN <= 0, "0", " ")
				nTotPerc += TMP->CTQ_PERCEN
				If nTotPerc > 100
					If TMP->CTQ_FORMUL = "0"
						TMP->CTQ_PERCEN := 0
					Else
						TMP->CTQ_PERCEN := TMP->CTQ_PERCEN - (nTotPerc-int(nTotPerc))
						nTotPerc := 100
					EndIf
				ElseIf nTotPerc < 100 .and. i = Len(aQtdeProd) .and. TMP->CTQ_PERCEN <> 0
					TMP->CTQ_PERCEN := TMP->CTQ_PERCEN + (100-nTotPerc)
					nTotPerc := 100
				EndIf
			EndIf
			MSUnLock()
		EndIf
	Next
	DBSkip()
End

nTotRat := nTotPerc

DBSelectArea("TMP")
TMP->(DBGoTop())

RestArea(aArea)
RestArea(aAreaCTQ)
RestArea(aAreaSD3)

Return

//********************************************************************
&& Esta funcao faz a Criacao do Grupo de Perguntas caso nao exista
//********************************************************************

/*
Static Function CriaPerg (cPerg)

PutSx1(cPerg, "01","Data do Fechamento"    ,"","","MV_CH3" ,"D",08,0,0,"G","", ""      ,"","", "MV_PAR01","","","","","","","","","","","","","")

Return
*/

//Caldula Quantidade de Horas por MOD

Static Function FS_BuscaQtde(dDatFec,cMesFec)

Local cAlias    := Alias()
Local nTotalGer := 0
Local cEOL      := Chr(13)+Chr(10)
Local cQuery    := ""
Local aRetQtde	:= {}
Local nPosProd  := 0
Local cModo		:= Alltrim(GetMV("ZZ_MODORAT"))
Local cNotRec	:= Alltrim(GetMV("ZZ_NOTREC"))
Local nTamCod	:= Str(TamSx3("D3_COD")[1]-3)

cNotRec := "('" + StrTran(cNotRec, "/", "', '") + "')"

If cModo = "H"
	cQuery     := "SELECT SUBSTRING(SD3.D3_COD,4," +nTamCod+ ") AS CCUSTO, SD3.D3_CF, SUM(D3_QUANT) AS QUANT " +cEOL
Else
	cQuery     := "SELECT SH1.H1_CCUSTO AS CCUSTO, SUM(D3_QUANT) AS QUANT " +cEOL
EndIf
cQuery     += "FROM " + RetSqlName ("SD3") + " SD3 " +cEOL
If cModo <> "H"
	cQuery     += "INNER JOIN " + RetSqlName ("SH1") + " SH1 ON SD3.D3_ZZRECUR = SH1.H1_CODIGO " +cEOL
	cQuery     += "                                         AND SD3.D3_FILIAL = SH1.H1_FILIAL " +cEOL
	cQuery     += "                                         AND SH1.H1_CODIGO NOT IN " + cNotRec
	cQuery     += "                                         AND SH1.D_E_L_E_T_ = ' ' " +cEOL
EndIf
cQuery     += "WHERE  SD3.D_E_L_E_T_ = ' ' AND SD3.D3_FILIAL = '" + xFilial("SD3") + "' " +cEOL
cQuery 	   += "AND SD3.D3_EMISSAO BETWEEN '"+dtos(dDatFec)+"' AND '"+dtos(cMesFec)+"'"  + cEOL
cQuery     += "AND SD3.D3_ESTORNO = ' ' " +cEOL
If cModo = "H"
	cQuery     += "AND SD3.D3_TIPO = 'MO' AND SUBSTRING(SD3.D3_COD,1,3) = 'MOD' " +cEOL
	cQuery     += "GROUP BY SD3.D3_COD, SD3.D3_CF " +cEOL
	cQuery     += "ORDER BY SD3.D3_COD, SD3.D3_CF " +cEOL
Else
	cQuery     += "AND SUBSTRING(D3_CF,1,2) = 'PR' " +cEOL
	cQuery     += "GROUP BY SH1.H1_CCUSTO " +cEOL
	cQuery     += "ORDER BY SH1.H1_CCUSTO " +cEOL
EndIf

cQuery := ChangeQuery(cQuery)

TCQuery cQuery New Alias "TMPSD3"

DBSelectArea("TMPSD3")
DBGoTop()
While !Eof()
	
	If (nPosProd := aScan(aRetQtde, {| aVet | aVet[1] == Alltrim(TMPSD3->CCUSTO)})) == 0
		aAdd(aRetQtde, {Alltrim(TMPSD3->CCUSTO), 0})
		nPosProd := Len(aRetQtde)
	EndIf
	If cModo = "H"
		aRetQtde[nPosProd][2] += IIf(SubStr(TMPSD3->D3_CF,1,2) = "DE", TMPSD3->QUANT * -1, TMPSD3->QUANT)
	Else
		aRetQtde[nPosProd][2] += TMPSD3->QUANT
	EndIf
	
	DBSkip()
	
End

TMPSD3->(DBCloseArea())
DBSelectArea(cAlias)
Return(aRetQtde)
