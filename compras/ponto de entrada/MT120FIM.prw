// Ponto de Entrada que envia email quando cria o Primeiro Pedido de Compra de um Produto Automotivo / Fornecedor

#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
#IFNDEF CRLF
#DEFINE CRLF ( chr(13)+chr(10) )
#ENDIF

User Function MT120FIM ()

Local cAlias    := Alias()
Local lRet		:= .T.
Local nOpc		:= ParamIxb[1]
Local cPedido   := SC7->C7_NUM
Local nOpca		:= ParamIxb[3]
Local lEmail	:= If ((nOpc = 3 .or. nOpc = 9) .and. nOpca = 1,.T.,.F.)
Local cSubject	:= ""
Local cBody		:= "" 
Local cDest		:= Alltrim(GetMV("ZZ_EMAILPC"))
Local nTanLin	:= 80
Local cFornece	:= SC7->C7_FORNECE
Local cLoja     := SC7->C7_LOJA
Local cNomeFornece := ""
Local cProduto		:=""
Local cPrimeiroPedido :=""
Local cMailContX  := Alltrim(GETMV("ZZ_MAILAPR"))
Local cMailSenha  := Alltrim(GETMV("ZZ_PSWMAPR"))
Local nJ

If lEmail	
	For nJ:= 1 To Len(aCols)
	cProduto := acols[nJ][02]

		cQuery     := "select C7_FORNECE+C7_LOJA Cod_Fornece, A2_NREDUZ,  C7_PRODUTO, TRIM(B1_ZZLP) Linha_Produto ,Count(C7_FORNECE) as QUANTDIDADE_DE_PEDIDOS " + CRLF
		cQuery     += "from SC7010 Left Outer Join " + CRLF
		cQuery     += "     SA2010 ON C7_FORNECE+C7_LOJA = A2_COD+A2_LOJA and SA2010.D_E_L_E_T_='' Left Outer Join " + CRLF
		cQuery     += "	 SB1010 ON C7_PRODUTO = B1_COD and SB1010.D_E_L_E_T_=''  " + CRLF
		cQuery     += "where C7_FILIAL = '01' and SC7010.D_E_L_E_T_ ='' and C7_FORNECE = '" + cFornece + "' and C7_LOJA='" + cLoja + "' and C7_PRODUTO ='" + cProduto + "' AND B1_ZZLP='AUTO' " + CRLF
		cQuery     += "Group By C7_FORNECE+C7_LOJA, A2_NREDUZ,  C7_PRODUTO, TRIM(B1_ZZLP) "	
	
		cQuery := ChangeQuery(cQuery)
	
		TcQuery cQuery New Alias "QRY"

    	cPrimeiroPedido := QRY->QUANTDIDADE_DE_PEDIDOS
		cNomeFornece := ALLTRIM(QRY->A2_NREDUZ)

	    IF cPrimeiroPedido =1
			cSubject := "Primeiro Pedido de Compras"
			cBody := "Atenção P&D: Foi criado o Primeiro Pedido de Compras para este Fornecedor / Produto " + CRLF
			cBody += REPLICATE("_",nTanLin) + CRLF
			cBody += "Pedido: " + cPedido + CRLF
			cBody += REPLICATE("_",nTanLin) + CRLF
			cBody += "Fornecedor: " + cNomeFornece + CRLF
			cBody += REPLICATE("_",nTanLin) + CRLF
			cBody += "Produto: " + CRLF 
			cBody += cProduto
			u_TngMail(cSubject,cBody,,cMailContX,cMailSenha,cDest)
        EndIf
	QRY->(DbCloseArea())	
	next
Endif

DBSelectArea(cAlias)

Return (lRet)
