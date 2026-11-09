#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
#IFNDEF CRLF
#DEFINE CRLF ( chr(13)+chr(10) )
#ENDIF

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT120FIM  º Autor ³Tuning Sistemas     º Data ³  02/07/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de Entrada para envio de e-mail apos a gravação do PCº±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function MT120FIM ()

Local cAlias    := Alias()
Local lRet		:= .T.
Local nOpc		:= ParamIxb[1]
Local cPed		:= Alltrim(ParamIxb[2])
Local nOpca		:= ParamIxb[3]
Local lEmail	:= If ((nOpc = 3 .or. nOpc = 9) .and. nOpca = 1,.T.,.F.)
Local cSubject	:= ""
Local cBody		:= "" 
Local cDest		:= Alltrim(GetMV("ZZ_EMAILPC"))
Local nZZVSupPc	:= GetMV("ZZ_VSUPPC")
Local nTanLin	:= 80
Local nVlrTot	:= 0
Local cCompr	:= ""
Local cFornec	:= ""
Local cEmiss	:= ""
Local cProd		:= ""
Local cMailContX  := Alltrim(GETMV("ZZ_MAILAPR"))
Local cMailSenha  := Alltrim(GETMV("ZZ_PSWMAPR"))
Local nTxModedaSM2:= 1

If lEmail
	
	cQuery     := "SELECT * " + CRLF
	cQuery     += "FROM " + RetSqlName ("SC7") + " SC7 " + CRLF
	cQuery     += "INNER JOIN " + RetSqlName ("SA2") + " SA2 ON SA2.A2_FILIAL = '" + xFilial("SA2") + "' " + CRLF
	cQuery     += "                                         AND SA2.A2_COD = SC7.C7_FORNECE AND SA2.A2_LOJA = SC7.C7_LOJA " + CRLF
	cQuery     += "                                         AND SA2.D_E_L_E_T_ = ' ' " + CRLF
	cQuery     += "INNER JOIN " + RetSqlName ("SY1") + " SY1 ON SY1.Y1_FILIAL = '" + xFilial("SY1") + "' " + CRLF
	cQuery     += "                                         AND SY1.Y1_USER = SC7.C7_USER " + CRLF
	cQuery     += "                                         AND SY1.D_E_L_E_T_ = ' ' " + CRLF
	cQuery     += "WHERE  SC7.D_E_L_E_T_ = ' ' AND SC7.C7_FILIAL = '" + xFilial("SC7") + "' " + CRLF
	cQuery 	   += "AND SC7.C7_NUM = '" + cPed + "'" + CRLF
	cQuery     += "ORDER BY SC7.C7_NUM, SC7.C7_ITEM, SC7.C7_PRODUTO "
	
	cQuery := ChangeQuery(cQuery)
	
	TCQuery cQuery New Alias "TMPSC7"
	
	DBSelectArea("TMPSC7")
	DBGoTop()
	While !Eof()
        _cMoeda := "M2_MOEDA"+Alltrim(Str(TMPSC7->C7_MOEDA))
		If TMPSC7->C7_MOEDA <> 1 .and. TMPSC7->C7_TXMOEDA = 0
		    /*
			DbSelectArea("SM2")
			SM2->(dbSetOrder(1))                                                                         	
			If DbSeek(StoD(TMPSC7->C7_EMISSAO))  	
				nTxModedaSM2 := &(_cMoeda)
			EndIf
			*/
			cQry := "SELECT M2_DATA, " + _cMoeda + CRLF
			cQry += "FROM " + RetSqlName ("SM2") + " A " + CRLF
			cQry += "INNER JOIN (SELECT MAX(M2_DATA) AS DATA FROM " + RetSqlName ("SM2") + CRLF
			cQry += "            WHERE SM2010.D_E_L_E_T_ = ' ' AND " + _cMoeda + " <> 0) B ON A.M2_DATA = B.DATA " 
			
			cQry := ChangeQuery(cQry)
			TCQuery cQry New Alias "QRYSM2"			
			
			DbSelectArea("QRYSM2")
			nTxModedaSM2 := &("QRYSM2->"+_cMoeda)
			QRYSM2->(DBCloseArea())	
			
		Else
			nTxModedaSM2 := TMPSC7->C7_TXMOEDA
		EndIf

	    If Empty(cCompr)
			cCompr	:= Alltrim(TMPSC7->Y1_NOME)
			cFornec	:= Alltrim(TMPSC7->A2_NOME)
			cEmiss	:= Alltrim(DtoC(StoD(TMPSC7->C7_EMISSAO)))
		EndIf
		//cProd += "Item: " + Alltrim(TMPSC7->C7_PRODUTO) + " - " + Alltrim(TMPSC7->C7_DESCRI) + " - Qtde: " + Alltrim(Transform(TMPSC7->C7_QUANT,"@E 999,999,999.99")) + " Valor: R$ " + Alltrim(Transform(TMPSC7->C7_TOTAL,"@E 999,999,999.99")) + CRLF
		cProd += "Item: " + Alltrim(TMPSC7->C7_PRODUTO) + " - " + Alltrim(TMPSC7->C7_DESCRI) + " - Data Entrega : " + Alltrim(DtoC(StoD(TMPSC7->C7_DATPRF))) + " - Qtde: " + Alltrim(Transform(TMPSC7->C7_QUANT,"@E 999,999,999.99")) + ;
		" Valor Unitario: R$ " + Alltrim(Transform(If(TMPSC7->C7_MOEDA = 1, TMPSC7->C7_PRECO, xMoeda(TMPSC7->C7_PRECO,TMPSC7->C7_MOEDA,1,,,nTxModedaSM2)),"@E 99,999,999.999999999")) + CRLF
		//nVlrTot	+= TMPSC7->C7_TOTAL
		nVlrTot	+= If(TMPSC7->C7_MOEDA = 1, TMPSC7->C7_TOTAL, xMoeda(TMPSC7->C7_TOTAL,TMPSC7->C7_MOEDA,1,,,nTxModedaSM2))

		DBSelectArea("TMPSC7")		
		TMPSC7->(DbSkip())

	End
	
	If nZZVSupPc <= nVlrTot
		
		cSubject := "Inclusão de Pedido de Compra - " + cPed + " - " + cFornec
		
		cBody := "Inclusão do Pedido de Compra: " + cPed + CRLF 
		cBody += REPLICATE("_",nTanLin) + CRLF 
		cBody += "Comprador: " + cCompr + CRLF
		cBody += "Fornecedor: " + cFornec + CRLF
		cBody += "Data de Emissão: " + cEmiss + CRLF
		cBody += REPLICATE("_",nTanLin) + CRLF
		cBody += "Produtos: " + CRLF 
		cBody += cProd
		cBody += "Valor Total: R$ " + Transform(nVlrTot,"@E 999,999,999.99") + CRLF
		cBody += REPLICATE("_",nTanLin)
		
		u_TngMail(cSubject,cBody,,cMailContX,cMailSenha,cDest)
	
	EndIf
	TMPSC7->(DBCloseArea())	
EndIf

DBSelectArea(cAlias)

Return (lRet)
