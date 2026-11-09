// Fonte que gera a quantidade de etiquetas a imprimir de exportação cliente Argentina e passa para etqEXPO1.prw

#Include "protheus.ch"
#Include "rptdef.ch"
#Include "fwprintsetup.ch"
#Include "topconn.ch"
#Include "prtopdef.ch"

user function ONTEX(cCliente, cData, cNF_Serie, cPedido, cTransp, cVolume, cCodBar)
	local aArea       := GetArea()  
    Local cB1cod      :=""
    Local cB1desc     :=""
    Local cB1tipo     :=""
    Local cB1um       :=""
    Local cB1grupo    :=""
    Local cB1ucom     :=""
    Local cB1idhist   :=""
    Local cD2lotectl  :=""
    Local cD2emissao  :=""
    Local cD2quant    :=""
    Local cH6op       :=""
    Local cH6dtapont  :=""
    Local cA7codcli   :=""
    Local cA7descli   :=""
    Local cD2doc      :=""
    Local cA1nome     :=""
	Local cQuery1 	  :=""		
	Local STR_PULA  := chr(10) + chr(13)
    		cQuery1 := " SELECT B1_COD, B1_DESC, B1_TIPO, B1_UM, B1_GRUPO, Right(B1_UCOM,2)+'/'+SUBSTRING(B1_UCOM,5,2)+'/'+LEFT(B1_UCOM,4) AS B1_UCOM,B1_IDHIST,D2_LOTECTL,F2_CLIENTE,Right(D2_EMISSAO,2)+'/'+SUBSTRING(D2_EMISSAO,5,2)+'/'+LEFT(D2_EMISSAO,4) AS D2_EMISSAO, D2_QUANT, H6_OP, Right(H6_DTAPONT,2)+'/'+SUBSTRING(H6_DTAPONT,5,2)+'/'+LEFT(H6_DTAPONT,4) AS H6_DTAPONT, A7_CODCLI, A7_DESCCLI, D2_DOC, A1_NOME "+STR_PULA
    		cQuery1 += " FROM "+RetSqlName("SF2")+" SF2 "+STR_PULA
    		cQuery1 += " INNER JOIN "+RetSqlName("SD2")+" SD2 ON F2_FILIAL = D2_FILIAL AND F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE AND F2_CLIENTE = D2_CLIENTE AND F2_LOJA = D2_LOJA AND SD2.D_E_L_E_T_ = ' ' "+STR_PULA
    		cQuery1 += " INNER JOIN "+RetSqlName("SB1")+" SB1 ON D2_COD = B1_COD AND SB1.D_E_L_E_T_ = ' '"+STR_PULA
    		cQuery1 += " INNER JOIN "+RetSqlName("SH6")+" SH6 ON H6_FILIAL = D2_FILIAL AND H6_PRODUTO = D2_COD AND H6_LOTECTL = D2_LOTECTL AND SH6.D_E_L_E_T_ = ''"+STR_PULA
    		cQuery1 += " INNER JOIN "+RetSqlName("SA1")+" SA1 ON F2_CLIENTE = A1_COD AND F2_LOJA = A1_LOJA AND SA1.D_E_L_E_T_ = ' ' "+STR_PULA
    		cQuery1 += " LEFT OUTER JOIN "+RetSqlName("SA7")+" SA7 ON A7_CLIENTE = D2_CLIENTE AND A7_LOJA = D2_LOJA AND A7_PRODUTO = D2_COD AND SA7.D_E_L_E_T_ = ''"+STR_PULA
    		cQuery1 += " WHERE F2_DOC ='"+SubSTR(cNF_Serie,1,9)+"' and SF2.D_E_L_E_T_ ='' "+ STR_PULA
            cQuery1 := ChangeQuery(cQuery1)
		  TCQuery cQuery1 New Alias "QRY1"

dbSelectArea("QRY1")
while !(QRY1->(eof()))
		cB1cod     	:= Alltrim(QRY1->B1_COD)
		cB1desc     := Alltrim(QRY1->B1_DESC)
		cB1tipo     := Alltrim(QRY1->B1_TIPO)
		cB1um       := Alltrim(QRY1->B1_UM)
		cB1grupo    := Alltrim(QRY1->B1_GRUPO)
		cB1ucom		:= Alltrim(QRY1->B1_UCOM)
		cB1idhist   := Alltrim(QRY1->B1_IDHIST)
		cD2lotectl  := Alltrim(QRY1->D2_LOTECTL)
		cD2emissao  := Alltrim(Qry1->D2_EMISSAO)
		cD2quant    := Alltochar(Qry1->D2_QUANT,,"@E 999.999,99")
		cH6op       := Alltrim(Qry1->H6_OP)
		cH6dtapont  := Alltrim(Qry1->H6_DTAPONT)
		cA7codcli   := Alltrim(Qry1->A7_CODCLI)
		cA7descli   := Alltrim(Qry1->A7_DESCCLI)
		cD2doc      := Alltrim(Qry1->D2_DOC)
		cA1nome     := Alltrim(Qry1->A1_NOME)
		
		u_ONTEX1(cB1cod, cB1desc, cB1tipo, cB1um, cB1grupo, cB1ucom, cB1idhist, cD2lotectl, cD2emissao, cD2quant, cH6op, cH6dtapont, cA7codcli, cA7descli, cD2doc, cA1nome,cCliente, cData, cNF_Serie, cPedido, cTransp, cVolume, cCodBar)
		QRY1->(dbSkip())
Enddo

	QRY1->(dbCloseArea()) //Fecha a área de trabalho
	RestArea(aArea)

Return
