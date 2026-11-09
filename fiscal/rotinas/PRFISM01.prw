#Include "Protheus.ch"

/*/{Protheus.doc} PRFISM01
Exportacao de XML para Prefeitura de Vinhedo
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
			Aviso("Aviso", "Nao foi possivel criar o arquivo.", {"Ok"}, 1)
		Else
			Processa({|| FISM01Prc(@nHandle, dEmiDe, dEmiAte, cFornDe, cLojaDe, cFornAte, cLojaAte, cDocto)}, "Exportacao XML Vinhedo", "Processando..")

			FClose(nHandle)

			DEFINE MSDIALOG oDlg TITLE "Log de Processamento" FROM 000, 000 TO 300, 400 COLORS 0, 16777215 PIXEL

			@ 002, 004 GET oLog VAR cLog OF oDlg MULTILINE SIZE 191, 121 COLORS 0, 16777215 HSCROLL PIXEL
			oLog:lReadOnly := .T.

			@ 127, 144 BUTTON oBtnOk PROMPT "Ok" SIZE 051, 019 ACTION (oDlg:End()) OF oDlg PIXEL
			ACTIVATE MSDIALOG oDlg CENTERED
		Endif
	Endif
Return(lRet)

/*/{Protheus.doc} FISM01Par
Exportacao de XML para Prefeitura de Vinhedo
@type function
@version 12.1.33
@author Parafix
@since 20/06/2022
/*/

Static Function FISM01Par()
	Local lRet := .T.
	Local aParam := {}
	Local aRet := {}

	aAdd(aParam, {1, "Emissao De"      , CriaVar("F1_EMISSAO", .T.), PesqPict("SF1", "F1_EMISSAO"), "", ""   , "", 45                               , .F.})
	aAdd(aParam, {1, "Emissao Ate"     , CriaVar("F1_EMISSAO", .T.), PesqPict("SF1", "F1_EMISSAO"), "", ""   , "", 45                               , .T.})
	aAdd(aParam, {1, "Fornecedor De"   , CriaVar("A2_COD", .T.)    , PesqPict("SA2", "A2_COD")    , "", "SA2", "", Ceiling(TamSX3("A2_COD")[1]  * 6), .F.})
	aAdd(aParam, {1, "Loja De"         , CriaVar("A2_LOJA", .T.)   , PesqPict("SA2", "A2_LOJA")   , "", ""   , "", Ceiling(TamSX3("A2_LOJA")[1] * 6), .F.})
	aAdd(aParam, {1, "Fornecedor Ate"  , CriaVar("A2_COD", .T.)    , PesqPict("SA2", "A2_COD")    , "", "SA2", "", Ceiling(TamSX3("A2_COD")[1]  * 6), .T.})
	aAdd(aParam, {1, "Loja Ate"        , CriaVar("A2_LOJA", .T.)   , PesqPict("SA2", "A2_LOJA")   , "", ""   , "", Ceiling(TamSX3("A2_LOJA")[1] * 6), .T.})
	aAdd(aParam, {1, "Numero Documento", CriaVar("F1_DOC", .T.)    , PesqPict("SF1", "F1_DOC")    , "", "SF1", "", Ceiling(TamSX3("F1_DOC")[1]  * 6), .F.})

	lRet := ParamBox(aParam, "Parametros", @aRet, , , , , , , , , .T.)
Return(lRet)

/*/{Protheus.doc} FISM01Prc
Exportacao de XML para Prefeitura de Vinhedo
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
	Local cValor   := ""
	Local cAliq    := ""
	Local cCep     := ""
	Local cInscTom := ""
	Local cDataEmi := ""

	Default nHandle  := 0
	Default dEmiDe   := SToD("")
	Default dEmiAte  := SToD("")
	Default cFornDe  := ""
	Default cLojaDe  := ""
	Default cFornAte := ""
	Default cLojaAte := ""
	Default cDocto   := ""

	cQuery := "SELECT DISTINCT T0.F1_FORNECE" + CRLF
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
	cQuery += "	,REPLACE(T2.D1_CODISS, '.', '') AS ATIVIDADE" + CRLF
	cQuery += "FROM " + RetSQLName("SF1") + " T0" + CRLF
	cQuery += "INNER JOIN " + RetSQLName("SA2") + " T1 ON (" + CRLF
	cQuery += "		(T1.A2_FILIAL = '" + xFilial("SA2") + "')" + CRLF
	cQuery += "		AND (T1.A2_COD = T0.F1_FORNECE)" + CRLF
	cQuery += "		AND (T1.A2_LOJA = T0.F1_LOJA)" + CRLF
	cQuery += "		AND (T1.D_E_L_E_T_ = '')" + CRLF
	cQuery += "		)" + CRLF
	cQuery += "INNER JOIN " + RetSQLName("SD1") + " T2 ON (" + CRLF
	cQuery += "		(T2.D1_FILIAL = '" + xFilial("SD1") + "')" + CRLF
	cQuery += "		AND (T2.D1_DOC = T0.F1_DOC)" + CRLF
	cQuery += "		AND (T2.D1_FORNECE + T2.D1_LOJA = T0.F1_FORNECE + T0.F1_LOJA)" + CRLF
	cQuery += "		AND T2.D1_SERIE = T0.F1_SERIE " + CRLF
	cQuery += "		AND (T2.D_E_L_E_T_ = '')" + CRLF
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
	cQuery += "	AND T0.F1_ISS = '0'" + CRLF
	/*
	cQuery += "ORDER BY T0.F1_FILIAL" + CRLF
	cQuery += "	,T0.F1_FORNECE" + CRLF
	cQuery += "	,T0.F1_LOJA" + CRLF
	cQuery += "	,T0.F1_DOC" + CRLF
	cQuery += "	,T0.F1_SERIE" + CRLF
	*/
	
	cTab := MPSysOpenQuery(cQuery)

	DbSelectArea((cTab))
	Count To nRegs
	(cTab)->(DbGoTop())

	ProcRegua(nRegs)
	cLog := "Foram exportados " + AllTrim(Str(nRegs)) + " registros." + CRLF + CRLF

	FWrite(nHandle, "<Nfse>" + CRLF)

	While ((cTab)->(!Eof()))
		nI++
		IncProc("Exportando registro " + AllTrim(Str(nI)) + " de " + AllTrim(Str(nRegs)))

		nValIss  := 0
		nAliqIss := 2.00
		cDescri  := ""

		DbSelectArea("SD1")
		SD1->(DbSetOrder(1))
		If (SD1->(DbSeek(xFilial("SD1") + (cTab)->F1_DOC + (cTab)->F1_SERIE + (cTab)->F1_FORNECE + (cTab)->F1_LOJA)))
			nValIss  := SD1->D1_VALISS
			nAliqIss := Iif(!Empty(SD1->D1_ALIQISS), SD1->D1_ALIQISS, 2.00)

			DbSelectArea("SB1")
			SB1->(DbSetOrder(1))
			If (SB1->(DbSeek(xFilial("SB1") + SD1->D1_COD)))
				cDescri := AllTrim(SB1->B1_DESC)
			Endif
		Endif

		dEmissao := SToD((cTab)->F1_EMISSAO)
		cDataEmi := StrZero(Day(dEmissao), 2) + "/" + StrZero(Month(dEmissao), 2) + "/" + StrZero(Year(dEmissao), 4)
		cValor   := AllTrim(StrTran(StrTran(Transform((cTab)->F1_VALBRUT, PesqPict("SF1", "F1_VALBRUT")), ".", ""), ",", "."))
		cAliq    := AllTrim(StrTran(StrTran(Transform(nAliqIss, PesqPict("SD1", "D1_ALIQISS")), ".", ""), ",", "."))
		cCep     := StrTran(StrTran(AllTrim((cTab)->A2_CEP), ".", ""), "-", "")
		cInscTom := PadL(AllTrim(SM0->M0_INSCM), 9, "0")

		cXML := "    <EmissaoNotaTomada>" + CRLF
		cXML += "        <InscricaoTomador>" + FISM01Xml(cInscTom) + "</InscricaoTomador>" + CRLF
		cXML += "        <NumeroNota>" + FISM01Xml(AllTrim((cTab)->F1_DOC)) + "</NumeroNota>" + CRLF
		cXML += "        <DadosPrestador>" + CRLF
		cXML += "            <TipoPrestador>" + FISM01Xml(AllTrim((cTab)->A2_TIPO)) + "</TipoPrestador>" + CRLF
		cXML += "            <CpfCnpj>" + AllTrim(StrTran((cTab)->A2_CGC,".","")) + "</CpfCnpj>" + CRLF
		cXML += "            <NomePrestador>" + FISM01Xml(AllTrim((cTab)->A2_NOME)) + "</NomePrestador>" + CRLF
		cXML += "            <Logradouro>" + FISM01Xml(AllTrim((cTab)->A2_END)) + "</Logradouro>" + CRLF
		cXML += "            <Numero>" + FISM01Xml(AllTrim((cTab)->A2_NR_END)) + "</Numero>" + CRLF
		cXML += "            <Complemento>" + AllTrim(Iif(!Empty((cTab)->A2_COMPLEM), (cTab)->A2_COMPLEM, "0")) + "</Complemento>" + CRLF
		cXML += "            <Bairro>" + FISM01Xml(AllTrim((cTab)->A2_BAIRRO)) + "</Bairro>" + CRLF
		cXML += "            <Cep>" + FISM01Xml(cCep) + "</Cep>" + CRLF
		cXML += "            <Cidade>" + FISM01Xml(AllTrim((cTab)->A2_MUN)) + "</Cidade>" + CRLF
		cXML += "            <Uf>" + FISM01Xml(AllTrim((cTab)->A2_EST)) + "</Uf>" + CRLF
		cXML += "            <Pais>Brasil</Pais>" + CRLF
		cXML += "            <Email>" + FISM01Xml(AllTrim(Iif(!Empty((cTab)->A2_EMAIL), (cTab)->A2_EMAIL, "nfe@parafix.com.br"))) + "</Email>" + CRLF
		cXML += "        </DadosPrestador>" + CRLF
		cXML += "        <Atividade>" + FISM01Xml(AllTrim((cTab)->ATIVIDADE)) + "</Atividade>" + CRLF
		cXML += "        <DataEmissao>" + cDataEmi + "</DataEmissao>" + CRLF
		cXML += "        <DataCompetencia>" + cDataEmi + "</DataCompetencia>" + CRLF
		cXML += "        <ValorNf>" + cValor + "</ValorNf>" + CRLF
		cXML += "        <ValorAbatimento></ValorAbatimento>" + CRLF
		cXML += "        <ValorBaseCalculo>" + cValor + "</ValorBaseCalculo>" + CRLF
		cXML += "        <Aliquota>" + cAliq + "</Aliquota>" + CRLF
		cXML += "        <DescricaoObservacao>" + FISM01Xml(cDescri) + "</DescricaoObservacao>" + CRLF
		cXML += "        <GeraGuiaTributacao>N</GeraGuiaTributacao>" + CRLF
		cXML += "    </EmissaoNotaTomada>" + CRLF

		FWrite(nHandle, cXML)

		cLog += "CNPJ: " + AllTrim(Transform((cTab)->A2_CGC, PesqPict("SA2", "A2_CGC"))) + CRLF
		cLog += "Razao Social: " + AllTrim((cTab)->A2_NOME) + CRLF
		cLog += "Documento: " + AllTrim((cTab)->F1_DOC) + CRLF
		cLog += "Atividade: " + AllTrim((cTab)->ATIVIDADE) + CRLF
		cLog += "Data Emissao: " + DToC(SToD((cTab)->F1_EMISSAO)) + CRLF
		cLog += "Valor Bruto: " + cValor + CRLF + CRLF

		(cTab)->(DbSkip())
	Enddo

	(cTab)->(DbCloseArea())

	FWrite(nHandle, "</Nfse>" + CRLF)
Return(lRet)

/*/{Protheus.doc} FISM01Xml
Tratamento basico de caracteres reservados para XML.
@type function
@version 12.1.33
@author Parafix
@since 13/08/2026
/*/

Static Function FISM01Xml(cTexto)
	Local cRet := ""

	Default cTexto := ""

	cRet := AllTrim(cTexto)
	cRet := StrTran(cRet, "&", "&amp;")
	cRet := StrTran(cRet, "<", "&lt;")
	cRet := StrTran(cRet, ">", "&gt;")
	cRet := StrTran(cRet, Chr(34), "&quot;")
	cRet := StrTran(cRet, "'", "&apos;")
Return(cRet)
