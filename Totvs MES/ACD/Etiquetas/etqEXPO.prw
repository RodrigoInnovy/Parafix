// Fonte que gera a quantidade de etiquetas a imprimir de exportação cliente Argentina e passa para etqEXPO1.prw

#Include "protheus.ch"
#Include "rptdef.ch"
#Include "fwprintsetup.ch"
#Include "topconn.ch"
#Include "prtopdef.ch"

//user function etqEXPO(cB1cod, cB1desc, cB1tipo, cB1um, cB1grupo, cB1ucom, cB1idhist, cD2lotectl, cD2emissao, nD2quant, cH6op, cH6dtapont, cA7codcli, cA7descli, cD2doc, cA1nome,cCliente, cData, cNF_Serie, cPedido, cTransp, cVolume, cCodBar)
user function etqEXPO(cCliente, cData, cNF_Serie, cPedido, cTransp, cVolume, cCodBar)
	local aArea     := GetArea()  
	local cCod      :=""
    local cDesc     :=""
	local cPeso     :=""
	local cCompr    :=""
	local cUm		:=""
	local cDesbse3  :=""
	local cPfisica  :=""
	Local cQuery1 	:=""		
	Local STR_PULA  := chr(10) + chr(13)
		  cQuery1   :="SELECT SB1010.B1_COD, SB1010.B1_DESC, SB1010.B1_UM, SB1010.B1_PESO, B5_COMPR, B1_DESBSE3, A1_PFISICA, A1_PAIS "+ STR_PULA
		  cQuery1	+="FROM SB5010 LEFT OUTER JOIN"+ STR_PULA
          cQuery1   +="SB1010 ON SB5010.B5_COD = SB1010.B1_COD  and SB1010.D_E_L_E_T_='' RIGHT OUTER JOIN "+ STR_PULA
          cQuery1    +="SD2010 ON SB1010.B1_COD = SD2010.D2_COD  and SD2010.D_E_L_E_T_='' RIGHT OUTER JOIN "+ STR_PULA
		  cQuery1	+="SA1010 ON SD2010.D2_CLIENTE = A1_COD and D2_LOJA = A1_LOJA and SA1010.D_E_L_E_T_='' "+ STR_PULA
		  cQuery1	+="WHERE D2_DOC ='"+SubSTR(cNF_Serie,1,9)+"' and SD2010.D_E_L_E_T_ ='' "+ STR_PULA
          cQuery1   := ChangeQuery(cQuery1)
		  TCQuery cQuery1 New Alias "QRY1"

dbSelectArea("QRY1")
while !(QRY1->(eof()))
		cCod     := Alltrim(QRY1->B1_COD)
		cDesc    := Alltrim(QRY1->B1_DESC)
		cPeso    := Alltochar(QRY1->B1_PESO,"@E 999.9999")
		cCompr   := Alltochar(QRY1->B5_COMPR,"@E 999999.99")
		cUm		 := QRY1->B1_UM
		cDesbse3 := Alltrim(QRY1->B1_DESBSE3)
		cPfisica := Alltrim(QRY1->A1_PFISICA)
		U_etqEXPO1(cCliente, cData, cNF_Serie, cPedido, cTransp, cVolume, cCodBar,cCod,cDesc,cPeso,cCompr,cUm,cDesbse3,cPfisica)
		QRY1->(dbSkip())
Enddo

	QRY1->(dbCloseArea()) //Fecha a área de trabalho
	RestArea(aArea)

Return
