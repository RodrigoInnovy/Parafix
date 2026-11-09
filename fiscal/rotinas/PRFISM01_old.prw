#Include "Protheus.ch"

/*/{Protheus.doc} PRFISM01
Exportação de XML para Prefeitura de Vinhedo
@type function
@version 12.1.33
@author Parafix
@since 20/06/2022
/*/

User Function PRFISM01()
	Local lRet := .T.
	Local cPath := ""
	Local nHandle := 0
	Local dEmiDe := SToD("")
	Local dEmiAte := SToD("")
	Local cFornDe := ""
	Local cLojaDe := ""
	Local cFornAte := ""
	Local cLojaAte := ""
	Local cDocto := ""
	Local oDlg := Nil
	Local oLog := Nil
	Local oBtnOk := Nil

	Private cLog := ""

	If (FISM01Par())
		dEmiDe   := mv_par01
		dEmiAte  := mv_par02
		cFornDe  := mv_par03
		cLojaDe  := mv_par04
		cFornAte := mv_par05
		cLojaAte := mv_par06
		cDocto   := mv_par07

		cPath := cGetFile("Arquivo .XML|*.XML", "Documentos", 1, "C:\", .F., GETF_LOCALHARD, .T., .T.)

		nHandle := FCreate(cPath)

		If (nHandle == -1)
			lRet := .F.
			Aviso("Aviso", "Não foi possível criar o arquivo.", {"Ok"}, 1)
		Else
			Processa({|| FISM01Prc(@nHandle, dEmiDe, dEmiAte, cFornDe, cLojaDe, cFornAte, cLojaAte, cDocto)}, "Exportação XML Vinhedo", "Processando..")

			FClose(nHandle)

			DEFINE MSDIALOG oDlg TITLE "Log de Processamento" FROM 000, 000  TO 300, 400 COLORS 0, 16777215 PIXEL

			@ 002, 004 GET oLog VAR cLog OF oDlg MULTILINE SIZE 191, 121 COLORS 0, 16777215 HSCROLL PIXEL
			oLog:lReadOnly := .T.

			@ 127, 144 BUTTON oBtnOk  PROMPT "Ok" SIZE 051, 019 ACTION (oDlg:End()) OF oDlg PIXEL
			ACTIVATE MSDIALOG oDlg CENTERED
		Endif
	Endif
Return(lRet)

/*/{Protheus.doc} FISM01Par
Exportação de XML para Prefeitura de Vinhedo
@type function
@version 12.1.33
@author Parafix
@since 20/06/2022
/*/

Static Function FISM01Par()
	Local lRet := .T.
	Local aParam := {}
	Local aRet := {}

	aAdd(aParam, {1, "Emissão De"      , CriaVar("F1_EMISSAO", .T.), PesqPict("SF1", "F1_EMISSAO"), "", ""   , "", 45                               , .F.})
	aAdd(aParam, {1, "Emissão Até"     , CriaVar("F1_EMISSAO", .T.), PesqPict("SF1", "F1_EMISSAO"), "", ""   , "", 45                               , .T.})
	aAdd(aParam, {1, "Fornecedor De"   , CriaVar("A2_COD", .T.)    , PesqPict("SA2", "A2_COD")    , "", "SA2", "", Ceiling(TamSX3("A2_COD")[1]  * 6), .F.})
	aAdd(aParam, {1, "Loja De"         , CriaVar("A2_LOJA", .T.)   , PesqPict("SA2", "A2_LOJA")   , "", ""   , "", Ceiling(TamSX3("A2_LOJA")[1] * 6), .F.})
	aAdd(aParam, {1, "Fornecedor Até"  , CriaVar("A2_COD", .T.)    , PesqPict("SA2", "A2_COD")    , "", "SA2", "", Ceiling(TamSX3("A2_COD")[1]  * 6), .T.})
	aAdd(aParam, {1, "Loja Até"        , CriaVar("A2_LOJA", .T.)   , PesqPict("SA2", "A2_LOJA")   , "", ""   , "", Ceiling(TamSX3("A2_LOJA")[1] * 6), .T.})
	aAdd(aParam, {1, "Número Documento", CriaVar("F1_DOC", .T.)    , PesqPict("SF1", "F1_DOC")    , "", "SF1", "", Ceiling(TamSX3("F1_DOC")[1]  * 6), .F.})

	lRet := ParamBox(aParam, "Parâmetros", @aRet, , , , , , , , , .T.)
Return(lRet)

/*/{Protheus.doc} FISM01Prc
Exportação de XML para Prefeitura de Vinhedo
@type function
@version 12.1.33
@author Parafix
@since 20/06/2022
/*/

Static Function FISM01Prc(nHandle, dEmiDe, dEmiAte, cFornDe, cLojaDe, cFornAte, cLojaAte, cDocto)
	Local lRet     := .T.
	Local cQuery   := ""
	Local cTab     := ""
	Local nRegs    := 0
	Local nI       := 0
	Local cXML     := ""
	Local nValIss  := 0
	Local cDescri  := ""
	Local nAliqIss := 0
	Local dEmissao := Nil

	Default nHandle  := 0
	Default dEmiDe   := SToD("")
	Default dEmiAte  := SToD("")
	Default cFornDe  := ""
	Default cLojaDe  := ""
	Default cFornAte := ""
	Default cLojaAte := ""
	Default cDocto   := ""

	cQuery := "SELECT T0.F1_FORNECE" + CRLF
	cQuery += "	,T0.F1_LOJA" + CRLF
	cQuery += "	,T0.F1_DOC" + CRLF
	cQuery += "	,T0.F1_SERIE" + CRLF
	cQuery += "	,T0.F1_EMISSAO" + CRLF
	cQuery += "	,T0.F1_VALBRUT" + CRLF
	cQuery += "	,T1.A2_TIPO" + CRLF
	cQuery += "	,T1.A2_CGC" + CRLF
	cQuery += "	,T1.A2_NOME" + CRLF
	cQuery += "	,CASE " + CRLF
	cQuery += "		WHEN (CHARINDEX(',', T1.A2_END) > 0)" + CRLF
	cQuery += "			THEN RTRIM(SUBSTRING(T1.A2_END, 1, CHARINDEX(',', T1.A2_END) - 1))" + CRLF
	cQuery += "		ELSE T1.A2_END" + CRLF
	cQuery += "		END A2_END" + CRLF
	cQuery += "	,CASE " + CRLF
	cQuery += "		WHEN (CHARINDEX(',', T1.A2_END) > 0)" + CRLF
	cQuery += "			THEN LTRIM(SUBSTRING(T1.A2_END, CHARINDEX(',', T1.A2_END) + 1, LEN(T1.A2_END)))" + CRLF
	cQuery += "		ELSE '01'" + CRLF
	cQuery += "		END A2_NR_END" + CRLF
	cQuery += "	,T1.A2_COMPLEM" + CRLF
	cQuery += "	,T1.A2_BAIRRO" + CRLF
	cQuery += "	,T1.A2_MUN" + CRLF
	cQuery += "	,T1.A2_EST" + CRLF
	cQuery += "	,T1.A2_CEP" + CRLF
	cQuery += "	,RTRIM(LTRIM(T1.A2_DDD)) + RTRIM(LTRIM(T1.A2_TEL)) A2_TEL" + CRLF
	cQuery += "	,T1.A2_EMAIL" + CRLF
	cQuery += "FROM " + RetSQLName("SF1") + " T0" + CRLF
	cQuery += "INNER JOIN " + RetSQLName("SA2") + " T1 ON (" + CRLF
	cQuery += "		(T1.A2_FILIAL = '" + xFilial("SA2") + "')" + CRLF
	cQuery += "		AND (T1.A2_COD = T0.F1_FORNECE)" + CRLF
	cQuery += "		AND (T1.A2_LOJA = T0.F1_LOJA)" + CRLF
	cQuery += "		AND (T1.D_E_L_E_T_ = '')" + CRLF
	cQuery += "		)" + CRLF
	cQuery += "WHERE T0.F1_FILIAL = '" + xFilial("SF1") + "'" + CRLF
	If (!Empty(cDocto))
		cQuery += "	AND T0.F1_DOC = '" + cDocto + "'" + CRLF
	Endif
	cQuery += "	AND T0.F1_FORNECE + T0.F1_LOJA BETWEEN '" + AllTrim(cFornDe) + AllTrim(cLojaDe) + "'" + CRLF
	cQuery += "		AND '" + AllTrim(cFornAte) + AllTrim(cLojaAte) + "'" + CRLF
	cQuery += "	AND T0.F1_EMISSAO BETWEEN '" + DToS(dEmiDe) + "'" + CRLF
	cQuery += "		AND '" + DToS(dEmiAte) + "'" + CRLF
	cQuery += "	AND T0.F1_ESPECIE = 'NFS'" + CRLF
	cQuery += "	AND T0.D_E_L_E_T_ = ''" + CRLF
	cQuery += "	AND RTRIM(LTRIM(T1.A2_MUN)) <> 'VINHEDO'" + CRLF
	cQuery += "	AND F1_ISS = '0'" + CRLF //criado 07/03/2023
	cQuery += "ORDER BY T0.F1_FILIAL" + CRLF
	cQuery += "	,T0.F1_FORNECE" + CRLF
	cQuery += "	,T0.F1_LOJA" + CRLF
	cQuery += "	,T0.F1_DOC" + CRLF
	cQuery += "	,T0.F1_SERIE" + CRLF

	cTab := MPSysOpenQuery(cQuery)

	DbSelectArea((cTab))
	Count To nRegs
	(cTab)->(DbGoTop())

	ProcRegua(nRegs)
	cLog := "Foram exportados " + AllTrim(Str(nRegs)) + " registros." + CRLF + CRLF

	FWrite(nHandle, "<retencao>" + CRLF)

	While ((cTab)->(!Eof()))
		nI++
		IncProc("Exportando registro " + AllTrim(Str(nI)) + " de " + AllTrim(Str(nRegs)))

		DbSelectArea("SD1")
		SD1->(DbSetOrder(1))
		If (SD1->(DbSeek( xFilial("SD1") + (cTab)->F1_DOC+ (cTab)->F1_SERIE + (cTab)->F1_FORNECE + (cTab)->F1_LOJA)))
			nValIss  := SD1->D1_VALISS
			nAliqIss := Iif(!Empty(SD1->D1_ALIQISS), SD1->D1_ALIQISS, 2.00)

			DbSelectArea("SB1")
			SB1->(DbSetOrder(1))
			If (SB1->(DbSeek(xFilial("SB1") + SD1->D1_COD)))
				cDescri  := AllTrim(SB1->B1_DESC)
			Endif
		Endif

		cXML := "   <lancamento>" + CRLF
		cXML += "       <servico>T</servico>" + CRLF
		cXML += "       <devido>" + Iif(!Empty(nValIss), "DT", "DP") + "</devido>" + CRLF
		cXML += "       <codigoNotaFiscal/>" + CRLF
		cXML += "       <numeroNotaFiscal>" + AllTrim((cTab)->F1_DOC) + "</numeroNotaFiscal>" + CRLF

		dEmissao := SToD((cTab)->F1_EMISSAO)

		cXML += "       <dataNotaFiscal>" + StrZero(Day(dEmissao), 2) + "/" + StrZero(Month(dEmissao), 2) + "/" +  StrZero(Year(dEmissao), 4) + "</dataNotaFiscal>" + CRLF
		If (nValIss == 0)
			cXML += "       <logradouroServico>" + AllTrim((cTab)->A2_END) + "</logradouroServico>" + CRLF
			cXML += "       <numeroServico>" + AllTrim((cTab)->A2_NR_END) + "</numeroServico>" + CRLF
			cXML += "       <complementoServico>" + AllTrim(Iif(!Empty((cTab)->A2_COMPLEM), (cTab)->A2_COMPLEM, "0")) + "</complementoServico>" + CRLF
			cXML += "       <bairroServico>" + AllTrim((cTab)->A2_BAIRRO) + "</bairroServico>" + CRLF
			cXML += "       <cidadeServico>" + AllTrim((cTab)->A2_MUN) + "</cidadeServico>" + CRLF
			cXML += "       <estadoServico>" + AllTrim((cTab)->A2_EST) + "</estadoServico>" + CRLF
			cXML += "       <cepServico>" + AllTrim(Transform((cTab)->A2_CEP, PesqPict("SA2", "A2_CEP"))) + "</cepServico>" + CRLF
		Else
			cXML += "       <logradouroServico>" + AllTrim(SubStr(SM0->M0_ENDCOB, 1, At(',', SM0->M0_ENDCOB) - 1)) + "</logradouroServico>" + CRLF
			cXML += "       <numeroServico>" + AllTrim(SubStr(SM0->M0_ENDCOB, At(',', SM0->M0_ENDCOB) + 1)) + "</numeroServico>" + CRLF
			cXML += "       <complementoServico>" + AllTrim(Iif(!Empty(SM0->M0_COMPCOB), SM0->M0_COMPCOB, "0")) + "</complementoServico>" + CRLF
			cXML += "       <bairroServico>" + AllTrim(SM0->M0_BAIRCOB) + "</bairroServico>" + CRLF
			cXML += "       <cidadeServico>" + AllTrim(SM0->M0_CIDCOB) + "</cidadeServico>" + CRLF
			cXML += "       <estadoServico>" + AllTrim(SM0->M0_ESTCOB) + "</estadoServico>" + CRLF
			cXML += "       <cepServico>" + AllTrim(Transform(SM0->M0_CEPCOB, PesqPict("SA2", "A2_CEP"))) + "</cepServico>" + CRLF
		Endif
		cXML += "       <descricaoServico>" + cDescri + "</descricaoServico>" + CRLF
		cXML += "       <dataArquivo>" + StrZero(Day(dDataBase), 2) + "/" + StrZero(Month(dDataBase), 2) + "/" +  StrZero(Year(dDataBase), 4) + "</dataArquivo>" + CRLF
		cXML += "       <valorServico>" + AllTrim(StrTran(StrTran(Transform((cTab)->F1_VALBRUT, PesqPict("SF1", "F1_VALBRUT")), ".", ""), ",", ".")) + "</valorServico>" + CRLF
		cXML += "       <valorAbatimentoLegal>0.00</valorAbatimentoLegal>" + CRLF
		cXML += "       <aliquotaIss>" + AllTrim(StrTran(StrTran(Transform(nAliqIss, PesqPict("SD1", "D1_ALIQISS")), ".", ""), ",", ".")) + "</aliquotaIss>" + CRLF
		cXML += "       <tipoDocumentoPrestador>" + AllTrim((cTab)->A2_TIPO) + "</tipoDocumentoPrestador>" + CRLF
		cXML += "       <documentoPrestador>" + AllTrim(Transform((cTab)->A2_CGC, PesqPict("SA2", "A2_CGC"))) + "</documentoPrestador>" + CRLF
		cXML += "       <nomePrestador>" + AllTrim(StrTran((cTab)->A2_NOME, "&", "E")) + "</nomePrestador>" + CRLF
		cXML += "       <logradouroPrestador>" + AllTrim((cTab)->A2_END) + "</logradouroPrestador>" + CRLF
		cXML += "       <numeroPrestador>" + AllTrim((cTab)->A2_NR_END) + "</numeroPrestador>" + CRLF
		cXML += "       <complementoPrestador>" + AllTrim(Iif(!Empty((cTab)->A2_COMPLEM), (cTab)->A2_COMPLEM, "0")) + "</complementoPrestador>" + CRLF
		cXML += "       <bairroPrestador>" + AllTrim((cTab)->A2_BAIRRO) + "</bairroPrestador>" + CRLF
		cXML += "       <cidadePrestador>" + AllTrim((cTab)->A2_MUN) + "</cidadePrestador>" + CRLF
		cXML += "       <estadoPrestador>" + AllTrim((cTab)->A2_EST) + "</estadoPrestador>" + CRLF
		cXML += "       <cepPrestador>" + AllTrim(Transform((cTab)->A2_CEP, PesqPict("SA2", "A2_CEP"))) + "</cepPrestador>" + CRLF
		cXML += "       <telefonePrestador>" + AllTrim(StrTran(StrTran(StrTran(Iif(!Empty((cTab)->A2_TEL), (cTab)->A2_TEL, SM0->M0_TEL), "-", ""), "(", ""), ")", "")) + "</telefonePrestador>" + CRLF
		cXML += "       <emailPrestador>" + AllTrim(Iif(!Empty((cTab)->A2_EMAIL), (cTab)->A2_EMAIL, "nfe@parafix.com.br")) + "</emailPrestador>" + CRLF
		cXML += "       <tipoDocumentoTomador>J</tipoDocumentoTomador>" + CRLF
		cXML += "       <documentoTomador>" + AllTrim(Transform(SM0->M0_CGC, PesqPict("SA2", "A2_CGC"))) + "</documentoTomador>" + CRLF
		cXML += "       <nomeTomador>" + AllTrim(SM0->M0_NOMECOM) + "</nomeTomador>" + CRLF
		cXML += "       <logradouroTomador>" + AllTrim(SubStr(SM0->M0_ENDCOB, 1, At(',', SM0->M0_ENDCOB) - 1)) + "</logradouroTomador>" + CRLF
		cXML += "       <numeroTomador>" + AllTrim(SubStr(SM0->M0_ENDCOB, At(',', SM0->M0_ENDCOB) + 1)) + "</numeroTomador>" + CRLF
		cXML += "       <complementoTomador>" + AllTrim(Iif(!Empty(SM0->M0_COMPCOB), SM0->M0_COMPCOB, "0")) + "</complementoTomador>" + CRLF
		cXML += "       <bairroTomador>" + AllTrim(SM0->M0_BAIRCOB) + "</bairroTomador>" + CRLF
		cXML += "       <cidadeTomador>" + AllTrim(SM0->M0_CIDCOB) + "</cidadeTomador>" + CRLF
		cXML += "       <estadoTomador>" + AllTrim(SM0->M0_ESTCOB) + "</estadoTomador>" + CRLF
		cXML += "       <cepTomador>" + AllTrim(Transform(SM0->M0_CEPCOB, PesqPict("SA2", "A2_CEP"))) + "</cepTomador>" + CRLF
		cXML += "       <telefoneTomador>" + AllTrim(StrTran(StrTran(StrTran(SM0->M0_TEL, "-", ""), "(", ""), ")", "")) + "</telefoneTomador>" + CRLF
		cXML += "       <emailTomador>nfe@parafix.com.br</emailTomador>" + CRLF
		cXML += "       <devidoForaMunic>" + Iif(!Empty(nValIss), "0", "1") + "</devidoForaMunic>" + CRLF
		cXML += "   </lancamento>" + CRLF
		FWrite(nHandle, cXML)

		cLog += "CNPJ: " + AllTrim(Transform((cTab)->A2_CGC, PesqPict("SA2", "A2_CGC"))) + CRLF
		cLog += "Razão Social: " + AllTrim(StrTran((cTab)->A2_NOME, "&", "E")) + CRLF
		cLog += "Documento: " + AllTrim((cTab)->F1_DOC) + CRLF
		cLog += "Data Emissão: " + DToC(SToD((cTab)->F1_EMISSAO)) + CRLF
		cLog += "Valor Bruto: " + AllTrim(StrTran(StrTran(Transform((cTab)->F1_VALBRUT, PesqPict("SF1", "F1_VALBRUT")), ".", ""), ",", ".")) + CRLF + CRLF

		(cTab)->(DbSkip())
	Enddo

	(cTab)->(DbCloseArea())

	FWrite(nHandle, "</retencao>" + CRLF)
Return(lRet)
