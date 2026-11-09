#Include "Protheus.ch"
#Include "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ PARFATA1  บ Autor ณ Cassandra J. Silva บ Data ณ 20/06/2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relat๓rio Movimento Contแbil e Fiscal. 1% Desonera็ใo      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especํfico PARAFIX                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

// Alterado por Gesse - TOTVS IP
// Alterado por Thiago - TOTVS IP

User Function PARFATAX()	&& PAR - PARAFIX / FAT - Faturamento / A - Atualiza็ใo / 1 - Sequencial
	Local cDesc1			:= "Este programa tem como objetivo imprimir relatorio "
	Local cDesc2			:= "de acordo com os parametros informados pelo usuario."
	Local cDesc3			:= ""
	Local cPict			:= ""
	Local titulo			:= "Recebimento Lํquido - Movimento Fiscal/Contแbil"
	Local nLin				:= 80
	Local Cabec1			:= ""
	Local Cabec2			:= ""
	Local imprime			:= .T.
	Local aOrd				:= {}
	Private cPasta		:= ""
	Private cTextoCSV 	:= ""
	Private lEnd			:= .F.
	Private lAbortPrint	:= .F.
	Private CbTxt			:= ""
	Private limite		:= 220
	Private tamanho		:= "G"
	Private nomeprog		:= "PARFATA1"
	Private nTipo			:= 15
	Private aReturn		:= {"Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
	Private nLastKey		:= 0
	Private cPerg			:= "PARFATA1"
	Private cbtxt      	:= Space(10)
	Private cbcont     	:= 00
	Private CONTFL     	:= 01
	Private m_pag      	:= 01
	Private wnrel      	:= "PARFATA1"
	Private cString		:= ""
	Private cArquivo		:= ""
	Private nArq			:= 0

	//AjustaSx1(cPerg)
	If !Pergunte(cPerg, .T.)
		Return
	EndIf
	/* Retirada a gravacao da desoneracao pelo relatorio, que sera gravada pelos PEs M460FIM - Faturamento e GQRENTR - Nota de Entrada
	AjDesonera()
	AjDevol()    
    */
	If MV_PAR13 == 1
		cPasta := cGetFile('Arquivos (*.csv) | *.csv', 'Selecione o diret๓rio - EXCEL', 1, , .T., GETF_LOCALHARD + GETF_NETWORKDRIVE + GETF_RETDIRECTORY, .T.)
		If !Empty(cPasta)
			cArquivo := "Rec_Liquido.csv"
			nArq     := fCreate(Alltrim(cPasta) +"\"+ cArquivo, 0)

			If MV_PAR11 == 1	&& Sint้tico
				If nArq > 0
					cTextoCSV := "FILIAL;"
					cTextoCSV += "NOME;"
					cTextoCSV += "CF;"
					cTextoCSV += "DESCRICAO;"
					cTextoCSV += "TOTAL;"
					cTextoCSV += "ICMS;"
					cTextoCSV += "IPI;"
					cTextoCSV += "BASE PIS/COF;"
					cTextoCSV += "PIS;"
					cTextoCSV += "COFINS;"
					cTextoCSV += "LIQUIDO;"
					cTextoCSV += CRLF
					fwrite(nArq, cTextoCSV)
				EndIf
			Else
				If MV_PAR12 == 1	&& Por Cliente
					If nArq > 0
						cTextoCSV := "FILIAL;"
						cTextoCSV += "CLIENTE;"
						cTextoCSV += "NOME;"
						cTextoCSV += "VENDEDOR;"
						cTextoCSV += "PAIS;"
						cTextoCSV += "PRODUTO;"
						cTextoCSV += "DESCRIวรO;" 
						cTextoCSV += "LIN.PROD;"
						cTextoCSV += "UM;"
						cTextoCSV += "QUANTIDADE;"
						cTextoCSV += "TOTAL;"
						cTextoCSV += "LIQUIDO;"
						cTextoCSV += CRLF
						fwrite(nArq, cTextoCSV)
					EndIf
				Else
					If nArq > 0
						cTextoCSV := "FILIAL;"
						cTextoCSV += "PRODUTO;"
						cTextoCSV += "DESCRIวรO;"
						cTextoCSV += "LIN.PROD;"
						cTextoCSV += "UM;"
						cTextoCSV += "QUANTIDADE;"
						cTextoCSV += "TOTAL;"
						cTextoCSV += "ICMS;"
						cTextoCSV += "IPI;"
						cTextoCSV += "BASE PIS/COF;"
						cTextoCSV += "PIS;"
						cTextoCSV += "COFINS;"
						cTextoCSV += "LIQUIDO;"
						cTextoCSV += CRLF
						fwrite(nArq, cTextoCSV)
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf

	If MV_PAR11 == 1	&& Sint้tico
		Cabec1 := "   FILIAL                                  CFOP                                              TOTAL              ICMS                IPI      BASE PIS/COFINS               PIS             COFINS      RECEBIMENTO LอQUIDO"
	Else
		If MV_PAR12 == 1	&& Por Cliente
			//Cabec1 := "FILIAL     CLIENTE                              VENDEDOR                 PAIS                          PRODUTO                                              UM         QUANTIDADE              TOTAL     RECEBIMENTO LอQUIDO"
			Cabec1 := "FILIAL     CLIENTE                              VENDEDOR             PAIS            PRODUTO                                        LIN.PROD                UM         QUANTIDADE              TOTAL     RECEBIMENTO LอQUIDO"
		Else 				&& Por Produto
			//Cabec1 := "FILIAL  PRODUTO                                                                  UM     QUANTIDADE            TOTAL            ICMS              IPI   BASE PIS/COFINS              PIS           COFINS    RECEBIM. LอQUIDO"
			Cabec1 := "FILIAL  PRODUTO                                     	 LIN.PROD              UM     QUANTIDADE            TOTAL            ICMS              IPI   BASE PIS/COFINS              PIS           COFINS    RECEBIM. LอQUIDO"
		EndIf
	EndIf

	wnrel := SetPrint(cString, NomeProg, cPerg, @titulo, cDesc1, cDesc2, cDesc3, .T., aOrd, .T., Tamanho,, .T.)

	If nLastKey == 27
		Return
	EndIf

	SetDefault(aReturn, cString)

	If nLastKey == 27
		Return
	EndIf

	nTipo := If(aReturn[4] == 1, 15, 18)

	RptStatus({|| RunReport(Cabec1, Cabec2, Titulo, nLin)}, Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  20/06/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function RunReport(Cabec1, Cabec2, Titulo, nLin)
	Local cQuery		:= ""
	Local cNatOper	:= ""
	Local cCFOP		:= ""
	Local cGrpCF		:= ""
	Local cSepara		:= ""
	Local cPaisDes	:= ""
	Local cCodVend	:= ""
	Local cVendedor	:= ""
	Local cTitTot		:= ""
	Local aTotais		:= {}
	Local aGeral		:= {}
	Local nVlrLiq		:= 0
	Local nFina		:= 0
	Local cDesc        := X5DESCRI()

	SA1->(DbSetOrder(1))
	SB1->(DbSetOrder(1))
	SX5->(DbSetOrder(1))

	&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
	&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& FILTRA DADOS DO FATURAMENTO (VENDAS):
	&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
	cQuery				:=	"	SELECT "																												+ CRLF	
	If MV_PAR11 == 1	&& Sint้tico
		cQuery			+=	"		D2_FILIAL FILIAL, D2_CF CF, "																					+ CRLF
		cQuery			+=	"		SUM(D2_QUANT) QUANT, SUM(D2_VALBRUT) VALBRUT, SUM(D2_VALICM) VALICM, SUM(D2_VALIPI) VALIPI, "			+ CRLF
		cQuery			+=	"		SUM(D2_BASIMP5) BASIMP5, SUM(D2_VALIMP5) VALIMP5, SUM(D2_BASIMP6) BASIMP6, SUM(D2_VALIMP6) VALIMP6, SUM(D2_ZDESON ) DESONERA "	+ CRLF
	Else				&& Analํtico
		If MV_PAR12 == 1	&& Por Cliente
			cQuery		+=	"		D2_FILIAL FILIAL, "																								+ CRLF
			cQuery		+=	"		CASE "																												+ CRLF
			cQuery		+=	"			WHEN SUBSTRING(D2_CF, 01, 01) IN ('1', '2', '3')	THEN 'GRPCF1' "										+ CRLF
			cQuery		+=	"			WHEN SUBSTRING(D2_CF, 01, 01) IN ('5', '6')		THEN 'GRPCF2' "										+ CRLF
			cQuery		+=	"			WHEN SUBSTRING(D2_CF, 01, 01) IN ('7')				THEN 'GRPCF3' "										+ CRLF
			cQuery		+=	"		END CF, "																											+ CRLF
			cQuery		+=	"		D2_CLIENTE CLIENTE, D2_LOJA LOJA, F2_VEND1 VENDEDOR, D2_COD COD, D2_UM UM, "								+ CRLF
			cQuery		+=	"		SUM(D2_QUANT) QUANT, SUM(D2_VALBRUT) VALBRUT, SUM(D2_VALICM) VALICM, "									+ CRLF
			cQuery		+=	"		SUM(D2_VALIPI) VALIPI, SUM(D2_BASIMP5) BASIMP5, SUM(D2_VALIMP5) VALIMP5, "								+ CRLF
			cQuery		+=	"		SUM(D2_BASIMP6) BASIMP6, SUM(D2_VALIMP6) VALIMP6, SUM(D2_ZDESON ) DESONERA "															+ CRLF
		Else 				&& Por Produto
			cQuery		+=	"		D2_FILIAL FILIAL, "																								+ CRLF
			cQuery		+=	"		CASE "																												+ CRLF
			cQuery		+=	"			WHEN SUBSTRING(D2_CF, 01, 01) IN ('1', '2', '3')	THEN 'GRPCF1' "										+ CRLF
			cQuery		+=	"			WHEN SUBSTRING(D2_CF, 01, 01) IN ('5', '6')		THEN 'GRPCF2' "										+ CRLF
			cQuery		+=	"			WHEN SUBSTRING(D2_CF, 01, 01) IN ('7')				THEN 'GRPCF3' "										+ CRLF
			cQuery		+=	"		END CF, "																											+ CRLF
			cQuery		+=	"		D2_COD COD, D2_UM UM, "																							+ CRLF
			cQuery		+=	"		SUM(D2_QUANT) QUANT, SUM(D2_VALBRUT) VALBRUT, SUM(D2_VALICM) VALICM, SUM(D2_VALIPI) VALIPI, "			+ CRLF
			cQuery		+=	"		SUM(D2_BASIMP5) BASIMP5, SUM(D2_VALIMP5) VALIMP5, SUM(D2_BASIMP6) BASIMP6, SUM(D2_VALIMP6) VALIMP6, SUM(D2_ZDESON ) DESONERA "	+ CRLF
		EndIf
	EndIf
	cQuery				+=	"	FROM "																													+ CRLF
	cQuery				+=	"		"				+ RetSqlName("SD2") + " SD2 "																	+ CRLF
	cQuery				+=	"		INNER JOIN "	+ RetSqlName("SF4") + " SF4 ON "																+ CRLF
	cQuery			 	+=	"			F4_FILIAL = '"+xFilial("SF4")+"' AND "																					+ CRLF
	cQuery				+=	"			F4_CODIGO = D2_TES AND "																						+ CRLF
	cQuery				+=	"			F4_DUPLIC = 'S' AND "																						+ CRLF
	cQuery				+=	"			F4_ESTOQUE = 'S' AND "																						+ CRLF
	cQuery				+=	"			SF4.D_E_L_E_T_ = ' ' "																						+ CRLF
	cQuery				+=	"		INNER JOIN "	+ RetSqlName("SF2") + " SF2 ON "																+ CRLF
	cQuery				+=	"			F2_FILIAL = D2_FILIAL AND "																					+ CRLF
	cQuery				+=	"			F2_DOC = D2_DOC AND "																						+ CRLF
	cQuery				+=	"			F2_SERIE = D2_SERIE AND "																					+ CRLF
	cQuery				+=	"			F2_CLIENTE = D2_CLIENTE AND "																				+ CRLF
	cQuery				+=	"			F2_LOJA = D2_LOJA AND "																						+ CRLF
	cQuery				+=	"			F2_TIPO NOT IN ('D','B') AND "																				+ CRLF
	cQuery				+=	"			SF2.D_E_L_E_T_ = ' ' "																						+ CRLF
	cQuery				+=	"	WHERE "																												+ CRLF
	cQuery				+=	"		D2_FILIAL BETWEEN '"		+ MV_PAR01			+ "' AND '" + MV_PAR02			+ "' AND "						+ CRLF
	cQuery				+=	"		D2_CLIENTE BETWEEN '"	+ MV_PAR03			+ "' AND '" + MV_PAR04			+ "' AND "						+ CRLF
	cQuery				+=	"		D2_LOJA BETWEEN '"		+ MV_PAR05			+ "' AND '" + MV_PAR06			+ "' AND "						+ CRLF
	cQuery				+=	"		D2_EMISSAO BETWEEN '"	+ DTOS(MV_PAR07)	+ "' AND '" + DTOS(MV_PAR08)	+ "' AND "						+ CRLF
	cQuery				+=	"		D2_COD BETWEEN '"			+ MV_PAR09			+ "' AND '" + MV_PAR10			+ "' AND "						+ CRLF
	cQuery				+=	"		SUBSTRING(D2_CF, 1, 2) != '71' AND "																			+ CRLF
	cQuery				+=	"		SD2.D_E_L_E_T_ = ' ' "																							+ CRLF
	cQuery				+=	"	GROUP BY "																												+ CRLF
	If MV_PAR11 == 1	&& Sint้tico
		cQuery			+=	"		D2_FILIAL, D2_CF "																								+ CRLF
	Else
		If MV_PAR12 == 1	&& Por Cliente
			cQuery		+=	"		D2_FILIAL, D2_CF, D2_CLIENTE, D2_LOJA, F2_VEND1, D2_COD, D2_UM "											+ CRLF
		Else 				&& Por Produto
			cQuery		+=	"		D2_FILIAL, D2_CF, D2_COD, D2_UM "																				+ CRLF
		EndIf
	EndIf
	cQuery				+=	"UNION ALL "																												+ CRLF
	&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
	&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& FILTRA DADOS DO FATURAMENTO (EXPORTAวรO):
	&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
	cQuery				+=	"	SELECT "																												+ CRLF
	If MV_PAR11 == 1	&& Sint้tico
		cQuery			+=	"		D2_FILIAL FILIAL, D2_CF CF, "																					+ CRLF
		cQuery			+=	"		SUM(D2_QUANT) QUANT, SUM(D2_VALBRUT) VALBRUT, SUM(D2_VALICM) VALICM, SUM(D2_VALIPI) VALIPI, "			+ CRLF
		cQuery			+=	"		SUM(D2_BASIMP5) BASIMP5, SUM(D2_VALIMP5) VALIMP5, SUM(D2_BASIMP6) BASIMP6, SUM(D2_VALIMP6) VALIMP6, 0 AS DESONERA  "	+ CRLF
	Else				&& Analํtico
		If MV_PAR12 == 1	&& Por Cliente
			cQuery		+=	"		D2_FILIAL FILIAL, "																								+ CRLF
			cQuery		+=	"		CASE "																												+ CRLF
			cQuery		+=	"			WHEN SUBSTRING(D2_CF, 01, 01) IN ('1', '2', '3')	THEN 'GRPCF1' "										+ CRLF
			cQuery		+=	"			WHEN SUBSTRING(D2_CF, 01, 01) IN ('5', '6')		THEN 'GRPCF2' "										+ CRLF
			cQuery		+=	"			WHEN SUBSTRING(D2_CF, 01, 01) IN ('7')				THEN 'GRPCF3' "										+ CRLF
			cQuery		+=	"		END CF, "																											+ CRLF
			cQuery		+=	"		D2_CLIENTE CLIENTE, D2_LOJA LOJA, F2_VEND1 VENDEDOR, D2_COD COD, D2_UM UM, "								+ CRLF
			cQuery		+=	"		SUM(D2_QUANT) QUANT, SUM(D2_VALBRUT) VALBRUT, SUM(D2_VALICM) VALICM, SUM(D2_VALIPI) VALIPI, "			+ CRLF
			cQuery		+=	"		SUM(D2_BASIMP5) BASIMP5, SUM(D2_VALIMP5) VALIMP5, SUM(D2_BASIMP6) BASIMP6, SUM(D2_VALIMP6) VALIMP6, 0 AS DESONERA  "	+ CRLF
		Else 				&& Por Produto
			cQuery		+=	"		D2_FILIAL FILIAL, "																								+ CRLF
			cQuery		+=	"		CASE "																												+ CRLF
			cQuery		+=	"			WHEN SUBSTRING(D2_CF	, 01, 01) IN ('1', '2', '3')	THEN 'GRPCF1' "									+ CRLF
			cQuery		+=	"			WHEN SUBSTRING(D2_CF, 01, 01) IN ('5', '6')		THEN 'GRPCF2' "										+ CRLF
			cQuery		+=	"			WHEN SUBSTRING(D2_CF, 01, 01) IN ('7')				THEN 'GRPCF3' "										+ CRLF
			cQuery		+=	"		END CF, "																											+ CRLF
			cQuery		+=	"		D2_COD COD, D2_UM UM, "																							+ CRLF
			cQuery		+=	"		SUM(D2_QUANT) QUANT, SUM(D2_VALBRUT) VALBRUT, SUM(D2_VALICM) VALICM, SUM(D2_VALIPI) VALIPI, "			+ CRLF
			cQuery		+=	"		SUM(D2_BASIMP5) BASIMP5, SUM(D2_VALIMP5) VALIMP5, SUM(D2_BASIMP6) BASIMP6, SUM(D2_VALIMP6) VALIMP6, 0 AS DESONERA  "	+ CRLF
		EndIf
	EndIf
	cQuery				+=	"	FROM "																													+ CRLF
	cQuery				+=	"		"				+ RetSqlName("SD2") + " SD2 "																	+ CRLF
	cQuery				+=	"		INNER JOIN "	+ RetSqlName("SF2") + " SF2 ON "																+ CRLF
	cQuery				+=	"			F2_FILIAL = D2_FILIAL AND "																					+ CRLF
	cQuery				+=	"			F2_DOC = D2_DOC AND "																						+ CRLF
	cQuery				+=	"			F2_SERIE = D2_SERIE AND "																					+ CRLF
	cQuery				+=	"			F2_CLIENTE = D2_CLIENTE AND "																				+ CRLF
	cQuery				+=	"			F2_LOJA = D2_LOJA AND "																						+ CRLF
	cQuery				+=	"			F2_TIPO NOT IN ('D','B') AND "																				+ CRLF
	cQuery				+=	"			SF2.D_E_L_E_T_ = ' ' "																						+ CRLF
	cQuery				+=	"	WHERE "																												+ CRLF
	cQuery				+=	"		D2_FILIAL BETWEEN '"		+ MV_PAR01			+ "' AND '" + MV_PAR02			+ "' AND "						+ CRLF
	cQuery				+=	"		D2_CLIENTE BETWEEN '"	+ MV_PAR03			+ "' AND '" + MV_PAR04			+ "' AND "						+ CRLF
	cQuery				+=	"		D2_LOJA BETWEEN '"		+ MV_PAR05			+ "' AND '" + MV_PAR06			+ "' AND "						+ CRLF
	cQuery				+=	"		D2_EMISSAO BETWEEN '"	+ DTOS(MV_PAR07)	+ "' AND '" + DTOS(MV_PAR08)	+ "' AND "						+ CRLF
	cQuery				+=	"		D2_COD BETWEEN '"			+ MV_PAR09			+ "' AND '" + MV_PAR10			+ "' AND "						+ CRLF
	cQuery				+=	"		SUBSTRING(D2_CF, 1, 2) = '71' AND "																			+ CRLF
	cQuery				+=	"		SD2.D_E_L_E_T_ = ' ' "																							+ CRLF
	cQuery				+=	"	GROUP BY "																												+ CRLF
	If MV_PAR11 == 1	&& Sint้tico
		cQuery			+=	"		D2_FILIAL, D2_CF "																								+ CRLF
	Else
		If MV_PAR12 == 1	&& Por Cliente
			cQuery		+=	"		D2_FILIAL, D2_CF, D2_CLIENTE, D2_LOJA, F2_VEND1, D2_COD, D2_UM "											+ CRLF
		Else 				&& Por Produto
			cQuery		+=	"		D2_FILIAL, D2_CF, D2_COD, D2_UM "																				+ CRLF
		EndIf
	EndIf
	cQuery				+=	"UNION ALL "																												+ CRLF
	&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
	&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& FILTRA DADOS DO COMPRAS (DEVOLUวีES):
	&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
	cQuery				+=	"	SELECT "																												+ CRLF
	If MV_PAR11 == 1	&& Sint้tico
		cQuery			+=	"		D1_FILIAL FILIAL, D1_CF CF, "																					+ CRLF
		cQuery			+=	"		SUM(D1_QUANT) QUANT, SUM(D1_TOTAL) VALBRUT, SUM(D1_VALICM) VALICM, SUM(D1_VALIPI) VALIPI, "			+ CRLF
		cQuery			+=	"		SUM(D1_BASIMP5) BASIMP5, SUM(D1_VALIMP5) VALIMP5, SUM(D1_BASIMP6) BASIMP6, SUM(D1_VALIMP6) VALIMP6, SUM(D1_ZDESON ) AS DESONERA "	+ CRLF
	Else				&& Analํtico
		If MV_PAR12 == 1	&& Por FORNECEDOR
			cQuery		+=	"		D1_FILIAL FILIAL, "																								+ CRLF
			cQuery		+=	"		CASE "																												+ CRLF
			cQuery		+=	"			WHEN SUBSTRING(D1_CF, 01, 01) IN ('1', '2', '3')	THEN 'GRPCF1' "										+ CRLF
			cQuery		+=	"			WHEN SUBSTRING(D1_CF, 01, 01) IN ('5', '6')		THEN 'GRPCF2' "										+ CRLF
			cQuery		+=	"			WHEN SUBSTRING(D1_CF, 01, 01) IN ('7')				THEN 'GRPCF3' "										+ CRLF
			cQuery		+=	"		END CF, "																											+ CRLF
			cQuery		+=	"		D1_FORNECE CLIENTE, D1_LOJA LOJA, '' VENDEDOR, D1_COD COD, D1_UM UM, "									+ CRLF
			cQuery		+=	"		SUM(D1_QUANT) QUANT, SUM(D1_TOTAL) VALBRUT, SUM(D1_VALICM) VALICM, SUM(D1_VALIPI) VALIPI, "			+ CRLF
			cQuery		+=	"		SUM(D1_BASIMP5) BASIMP5, SUM(D1_VALIMP5) VALIMP5, SUM(D1_BASIMP6) BASIMP6, SUM(D1_VALIMP6) VALIMP6, SUM(D1_ZDESON ) AS DESONERA "	+ CRLF
		Else 				&& Por Produto
			cQuery		+=	"		D1_FILIAL FILIAL, "																								+ CRLF
			cQuery		+=	"		CASE "																												+ CRLF
			cQuery		+=	"			WHEN SUBSTRING(D1_CF, 01, 01) IN ('1', '2', '3')	THEN 'GRPCF1' "										+ CRLF
			cQuery		+=	"			WHEN SUBSTRING(D1_CF, 01, 01) IN ('5', '6')		THEN 'GRPCF2' "										+ CRLF
			cQuery		+=	"			WHEN SUBSTRING(D1_CF, 01, 01) IN ('7')				THEN 'GRPCF3' "										+ CRLF
			cQuery		+=	"		END CF, "																											+ CRLF
			cQuery		+=	"		D1_COD COD, D1_UM UM, "																							+ CRLF	
			cQuery		+=	"		SUM(D1_QUANT) QUANT, SUM(D1_TOTAL) VALBRUT, SUM(D1_VALICM) VALICM, SUM(D1_VALIPI) VALIPI, "			+ CRLF
			cQuery		+=	"		SUM(D1_BASIMP5) BASIMP5, SUM(D1_VALIMP5) VALIMP5, SUM(D1_BASIMP6) BASIMP6, SUM(D1_VALIMP6) VALIMP6, SUM(D1_ZDESON ) AS DESONERA "	+ CRLF
		EndIf
	EndIf
	cQuery				+=	"	FROM "																													+ CRLF
	cQuery				+=	"		"				+ RetSqlName("SD1") + " SD1 "																	+ CRLF
	cQuery				+=	"		INNER JOIN "	+ RetSqlName("SF1") + " SF1 ON "																+ CRLF
	cQuery				+=	"		F1_FILIAL = D1_FILIAL AND "																						+ CRLF
	cQuery				+=	"		F1_DOC = D1_DOC AND "																							+ CRLF
	cQuery				+=	"		F1_SERIE = D1_SERIE AND "																						+ CRLF
	cQuery				+=	"		F1_FORNECE = D1_FORNECE AND "																					+ CRLF
	cQuery				+=	"		F1_LOJA = D1_LOJA AND "																							+ CRLF
	cQuery				+=	"		F1_TIPO = 'D' AND "																								+ CRLF
	cQuery				+=	"		SF1.D_E_L_E_T_ = ' ' "																							+ CRLF
	cQuery				+=	"	WHERE "																												+ CRLF
	cQuery				+=	"		D1_FILIAL BETWEEN '"		+ MV_PAR01			+ "' AND '" + MV_PAR02			+ "' AND "						+ CRLF
	cQuery				+=	"		D1_FORNECE BETWEEN '"	+ MV_PAR03			+ "' AND '" + MV_PAR04			+ "' AND "						+ CRLF
	cQuery				+=	"		D1_LOJA BETWEEN '"		+ MV_PAR05			+ "' AND '" + MV_PAR06			+ "' AND "						+ CRLF
	cQuery				+=	"		D1_EMISSAO BETWEEN '"	+ DTOS(MV_PAR07)	+ "' AND '" + DTOS(MV_PAR08)	+ "' AND "						+ CRLF
	cQuery				+=	"		D1_COD BETWEEN '"			+ MV_PAR09			+ "' AND '" + MV_PAR10			+ "' AND "						+ CRLF
	cQuery				+=	"		(D1_TES = '0RR' AND D1_CF NOT IN ('1949', '2949', '3949') OR D1_TES != '0RR') AND "						+ CRLF
	cQuery				+=	"		SD1.D_E_L_E_T_ = ' ' "																							+ CRLF
	cQuery				+=	"	GROUP BY "																												+ CRLF
	If MV_PAR11 == 1	&& Sint้tico
		cQuery			+=	"		D1_FILIAL, D1_CF "																								+ CRLF
	Else
		If MV_PAR12 == 1	&& Por FORNECEDOR
			cQuery		+=	"		D1_FILIAL, D1_CF, D1_FORNECE, D1_LOJA, D1_COD, D1_UM "														+ CRLF
		Else 				&& Por Produto
			cQuery		+=	"		D1_FILIAL, D1_CF, D1_COD, D1_UM "																				+ CRLF
		EndIf
	EndIf
	cQuery				+=	"ORDER BY "																												+ CRLF
	If MV_PAR11 == 1	&& Sint้tico
		cQuery			+=	"	FILIAL, CF "																											+ CRLF
	Else
		If MV_PAR12 == 1	&& Por Cliente
			cQuery		+=	"	FILIAL, CF, CLIENTE, LOJA, VENDEDOR, COD "																		+ CRLF
		Else 				&& Por Produto
			cQuery		+=	"	FILIAL, CF, COD "																										+ CRLF
		EndIf
	EndIf

	If Select("QRY") != 0
		QRY->(dbCloseArea())
	EndIf

	MemoWrit("\PARFATA1.TXT", cQuery)
	
	TcQuery cQuery Alias "QRY" New

	SetRegua(QRY->(RecCount()))

	cCFOP		:= "1/2/3"
	cGrpCF		:= "GRPCF1"
	aTotais	:= {0, 0, 0, 0, 0, 0, 0, 0}
	aGeral		:= {0, 0, 0, 0, 0, 0, 0, 0}
	
	cSepara := QRY->CF

	QRY->(DbGoTop())
	Do While QRY->(!Eof())
		If Substr(QRY->CF, 01, 01) $ "1/2/3" .Or. QRY->CF == "GRPCF1"
			nVlrLiq := (QRY->VALBRUT + QRY->VALIPI) - QRY->VALICM - QRY->VALIPI - QRY->VALIMP5 - QRY->VALIMP6 - QRY->DESONERA
		Else
			nVlrLiq := QRY->VALBRUT - QRY->VALICM - QRY->VALIPI - QRY->VALIMP5 - QRY->VALIMP6 - QRY->DESONERA
		EndIf

		If MV_PAR11 == 1	&& Sint้tico
			SX5->(DbSeek(xFilial("SX5") + "13" + QRY->CF))
			cNatOper := AllTrim(cDesc)
		Else
			If MV_PAR12 == 1	&& Por Cliente
				cCodVend := QRY->VENDEDOR
			EndIf
		EndIf

		If lAbortPrint
			@nLin,00 PSay "*** CANCELADO PELO OPERADOR ***"
			Exit
		EndIf

		If nLin > 55
			Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
			nLin := 8
		EndIf

		If MV_PAR11 == 1	&& Sint้tico
			&&           10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180       190       200       210       220
			&& 01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
			&& FILIAL                                  CFOP                                              TOTAL              ICMS                IPI      BASE PIS/COFINS               PIS             COFINS      RECEBIMENTO LอQUIDO
			&& 12 - 123456789012345678901234567890     1234 - 123456789012345678901234567890     999,999,999.99    999,999,999.99     999,999,999.99      999,999,999.99     999,999,999.99     999,999,999.99          999,999,999.99

			@ nLin, 004 PSay QRY->FILIAL + " - " + Substr(SM0->M0_FILIAL, 01, 30)
			@ nLin, 044 PSay QRY->CF + " - " + Substr(cNatOper, 01, 30)

			If Substr(QRY->CF, 01, 01) $ "1/2/3"
				@ nLin, 086 PSay Transform(QRY->VALBRUT + QRY->VALIPI, "@E 999,999,999.99")
			Else
				@ nLin, 086 PSay Transform(QRY->VALBRUT, "@E 999,999,999.99")
			EndIf

			@ nLin, 104 PSay Transform(QRY->VALICM,	"@E 999,999,999.99")
			@ nLin, 123 PSay Transform(QRY->VALIPI,	"@E 999,999,999.99")
			@ nLin, 143 PSay Transform(QRY->BASIMP5,	"@E 999,999,999.99")
			@ nLin, 162 PSay Transform(QRY->VALIMP6,	"@E 999,999,999.99")
			@ nLin, 181 PSay Transform(QRY->VALIMP5,	"@E 999,999,999.99")
			@ nLin, 205 PSay Transform(nVlrLiq,		"@E 999,999,999.99")

			If nArq > 0
				cTextoCSV := QRY->FILIAL											+ ";"
				cTextoCSV += SM0->M0_FILIAL										+ ";"
				cTextoCSV += QRY->CF												+ ";"
				cTextoCSV += cNatOper											+ ";"
				cTextoCSV += Transform(QRY->VALBRUT,	"@E 999,999,999.99")	+ ";"
				cTextoCSV += Transform(QRY->VALICM,	"@E 999,999,999.99")	+ ";"
				cTextoCSV += Transform(QRY->VALIPI,	"@E 999,999,999.99")	+ ";"
				cTextoCSV += Transform(QRY->BASIMP5,	"@E 999,999,999.99")	+ ";"
				cTextoCSV += Transform(QRY->VALIMP6,	"@E 999,999,999.99")	+ ";"
				cTextoCSV += Transform(QRY->VALIMP5,	"@E 999,999,999.99")	+ ";"
				cTextoCSV += Transform(nVlrLiq,			"@E 999,999,999.99")	+ ";"
				cTextoCSV += CRLF
				fwrite(nArq, cTextoCSV)
			EndIf
		Else
			If MV_PAR12 == 1	&& Por Cliente
				SB1->(DbSeek(xFilial("SB1") + QRY->COD))
				SA1->(DbSeek(xFilial("SA1") + QRY->CLIENTE + QRY->LOJA))
				cPaisDes	:= Posicione("SYA", 1, xFilial("SYA") + SA1->A1_PAIS,											"YA_DESCR"		)
				cVendedor	:= Posicione("SA3", 1, xFilial("SA3") + cCodVend,												"A3_NREDUZ"	)
				&&           10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180       190       200       210       220
				&& 01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
				&& FILIAL     CLIENTE                              VENDEDOR             PAIS            PRODUTO                                        LIN.PROD				   UM         QUANTIDADE              TOTAL     RECEBIMENTO LอQUIDO
				&&   12       123456/12 - 12345678901234567890     12345678901234567890 123456789012345 1234567890 - 123456789012345678901234567890    01234567890		   	   12      99,999,999.99     999,999,999.99          999,999,999.99

				@ nLin, 002 PSay QRY->FILIAL
				@ nLin, 011 PSay QRY->CLIENTE + "/" + QRY->LOJA + " - " + SubStr(SA1->A1_NREDUZ, 01, 20)
				@ nLin, 048 PSay cVendedor
				@ nLin, 069 PSay cPaisDes
				@ nLin, 085 PSay AllTrim(QRY->COD) + " - " + Substr(SB1->B1_DESC, 01, 30)
				@ nLin, 132 PSay SB1->B1_ZZLP
				@ nLin, 156 PSay QRY->UM
				@ nLin, 164 PSay Transform(QRY->QUANT,		"@E 999,999,999.99")
				@ nLin, 182 PSay Transform(QRY->VALBRUT,	"@E 999,999,999.99")
				@ nLin, 206 PSay Transform(nVlrLiq,		"@E 999,999,999.99")

				If nArq > 0
					cTextoCSV := QRY->FILIAL											+ ";"
					cTextoCSV += QRY->CLIENTE + "/" + QRY->LOJA					+ ";"
					cTextoCSV += SA1->A1_NREDUZ										+ ";"
					cTextoCSV += cVendedor											+ ";"
					cTextoCSV += cPaisDes											+ ";"
					cTextoCSV += QRY->COD											+ ";"
					cTextoCSV += SB1->B1_DESC										+ ";"           
					cTextoCSV += SB1->B1_ZZLP										+ ";"
					cTextoCSV += QRY->UM											+ ";"
					cTextoCSV += Transform(QRY->QUANT,		"@E 999,999,999.99")	+ ";"
					cTextoCSV += Transform(QRY->VALBRUT,	"@E 999,999,999.99")	+ ";"
					cTextoCSV += Transform(nVlrLiq,			"@E 999,999,999.99")	+ ";"
					cTextoCSV += CRLF
					fwrite(nArq, cTextoCSV)
				EndIf
			Else 				&& Por Produto
				SB1->(DbSeek(xFilial("SB1") + QRY->COD))

				&&           10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180       190       200       210       220
				&& 01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
				&& FILIAL  PRODUTO                                           	LIN.PROD            UM     QUANTIDADE            TOTAL            ICMS              IPI   BASE PIS/COFINS              PIS           COFINS    RECEBIM. LอQUIDO
				&&   12    123456789012345 - 123456789012345678901234567890  	1234567890          12  99,999,999.99   999,999,999.99  999,999,999.99   999,999,999.99    999,999,999.99   999,999,999.99   999,999,999.99      999,999,999.99

				@ nLin, 002 PSay QRY->FILIAL
				@ nLin, 008 PSay QRY->COD + " - " + Substr(SB1->B1_DESC, 01, 30)
				@ nLin, 061 PSay SB1->B1_ZZLP
				@ nLin, 081 PSay QRY->UM
				@ nLin, 085 PSay Transform(QRY->QUANT,		"@E 999,999,999.99")
				@ nLin, 101 PSay Transform(QRY->VALBRUT,	"@E 999,999,999.99")
				@ nLin, 117 PSay Transform(QRY->VALICM,	"@E 999,999,999.99")
				@ nLin, 134 PSay Transform(QRY->VALIPI,	"@E 999,999,999.99")
				@ nLin, 152 PSay Transform(QRY->BASIMP5,	"@E 999,999,999.99")
				@ nLin, 169 PSay Transform(QRY->VALIMP6,	"@E 999,999,999.99")
				@ nLin, 186 PSay Transform(QRY->VALIMP5,	"@E 999,999,999.99")
				@ nLin, 206 PSay Transform(nVlrLiq,		"@E 999,999,999.99")
				If nArq > 0
					cTextoCSV := QRY->FILIAL										+ ";"
					cTextoCSV += QRY->COD											+ ";"
					cTextoCSV += SB1->B1_DESC										+ ";"    
					cTextoCSV += SB1->B1_ZZLP										+ ";"
					cTextoCSV += QRY->UM											+ ";"
					cTextoCSV += Transform(QRY->QUANT,		"@E 999,999,999.99")	+ ";"
					cTextoCSV += Transform(QRY->VALBRUT,	"@E 999,999,999.99")	+ ";"
					cTextoCSV += Transform(QRY->VALICM,	"@E 999,999,999.99")	+ ";"
					cTextoCSV += Transform(QRY->VALIPI,	"@E 999,999,999.99")	+ ";"
					cTextoCSV += Transform(QRY->BASIMP5,	"@E 999,999,999.99")	+ ";"
					cTextoCSV += Transform(QRY->VALIMP6,	"@E 999,999,999.99")	+ ";"
					cTextoCSV += Transform(QRY->VALIMP5,	"@E 999,999,999.99")	+ ";"
					cTextoCSV += Transform(nVlrLiq,			"@E 999,999,999.99")	+ ";"
					cTextoCSV += CRLF
					fwrite(nArq, cTextoCSV)
				EndIf
			EndIf
		EndIf
		nLin ++

		aTotais[1] += IIf(MV_PAR11 == 1, 0, QRY->QUANT)
		aTotais[2] += QRY->VALBRUT
		aTotais[3] += QRY->VALICM
		aTotais[4] += QRY->VALIPI
		aTotais[5] += QRY->BASIMP5
		aTotais[6] += QRY->VALIMP6
		aTotais[7] += QRY->VALIMP5
		aTotais[8] += nVlrLiq

		If Substr(QRY->CF, 01, 01) $ "1/2/3" .Or. QRY->CF == "GRPCF1"
			aGeral[1] -= IIf(MV_PAR11 == 1, 0, QRY->QUANT)
			aGeral[2] -= QRY->VALBRUT
			aGeral[3] -= QRY->VALICM
			aGeral[4] -= QRY->VALIPI
			aGeral[5] -= QRY->BASIMP5
			aGeral[6] -= QRY->VALIMP6
			aGeral[7] -= QRY->VALIMP5
			aGeral[8] -= nVlrLiq
		Else
			aGeral[1] += IIf(MV_PAR11 == 1, 0, QRY->QUANT)
			aGeral[2] += QRY->VALBRUT
			aGeral[3] += QRY->VALICM
			aGeral[4] += QRY->VALIPI
			aGeral[5] += QRY->BASIMP5
			aGeral[6] += QRY->VALIMP6
			aGeral[7] += QRY->VALIMP5
			aGeral[8] += nVlrLiq
		EndIf

		QRY->(dbSkip())

		If !(Substr(QRY->CF, 01, 01) $ cCFOP) .And. !(QRY->CF $ cGrpCF)
			If cCFOP == "1/2/3" .Or. QRY->CF == "GRPCF1"
				cTitTot := ">>> TOTAL DEVOLUวีES (-)"
			ElseIf cCFOP == "5/6" .Or. QRY->CF == "GRPCF2"
				cTitTot := ">>> TOTAL VENDAS (+)"
			Else
				cTitTot := ">>> TOTAL EXPORTAวรO (+)"
			EndIf

			@ nLin, 000 PSay Replicate("_", 220)
			nLin ++
			If MV_PAR11 == 1	&& Sint้tico
				@ nLin, 044 PSay cTitTot
				@ nLin, 086 PSay Transform(aTotais[2], "@E 999,999,999.99")
				@ nLin, 104 PSay Transform(aTotais[3], "@E 999,999,999.99")
				@ nLin, 123 PSay Transform(aTotais[4], "@E 999,999,999.99")
				@ nLin, 143 PSay Transform(aTotais[5], "@E 999,999,999.99")
				@ nLin, 162 PSay Transform(aTotais[6], "@E 999,999,999.99")
				@ nLin, 181 PSay Transform(aTotais[7], "@E 999,999,999.99")
				@ nLin, 205 PSay Transform(aTotais[8], "@E 999,999,999.99")
			Else
				If cSepara != QRY->CF
					@ nLin, 010 PSay cTitTot
					If MV_PAR12 == 1	&& Por Cliente
						@ nLin, 164 PSay Transform(aTotais[1], "@E 999,999,999.99")
						@ nLin, 182 PSay Transform(aTotais[2], "@E 999,999,999.99")
						@ nLin, 206 PSay Transform(aTotais[8], "@E 999,999,999.99")
					Else 				&& Por Produto
						@ nLin, 085 PSay Transform(aTotais[1], "@E 999,999,999.99")
						@ nLin, 101 PSay Transform(aTotais[2], "@E 999,999,999.99")
						@ nLin, 117 PSay Transform(aTotais[3], "@E 999,999,999.99")
						@ nLin, 134 PSay Transform(aTotais[4], "@E 999,999,999.99")
						@ nLin, 152 PSay Transform(aTotais[5], "@E 999,999,999.99")
						@ nLin, 169 PSay Transform(aTotais[6], "@E 999,999,999.99")
						@ nLin, 186 PSay Transform(aTotais[7], "@E 999,999,999.99")
						@ nLin, 206 PSay Transform(aTotais[8], "@E 999,999,999.99")
					EndIf
					cSepara := QRY->CF
				EndIf
			EndIf
			nLin += 2

			If nArq > 0
				If MV_PAR11 == 1	&& Sint้tico
					cTextoCSV := ""												+ ";"
					cTextoCSV += cTitTot											+ ";"
					cTextoCSV += ""												+ ";"
					cTextoCSV += ""												+ ";"
					cTextoCSV += Transform(aTotais[2], "@E 999,999,999.99")	+ ";"
					cTextoCSV += Transform(aTotais[3], "@E 999,999,999.99")	+ ";"
					cTextoCSV += Transform(aTotais[4], "@E 999,999,999.99")	+ ";"
					cTextoCSV += Transform(aTotais[5], "@E 999,999,999.99")	+ ";"
					cTextoCSV += Transform(aTotais[6], "@E 999,999,999.99")	+ ";"
					cTextoCSV += Transform(aTotais[7], "@E 999,999,999.99")	+ ";"
					cTextoCSV += Transform(aTotais[8], "@E 999,999,999.99")	+ ";"
					cTextoCSV += CRLF
					fwrite(nArq, cTextoCSV)
				Else
					If MV_PAR12 == 1	&& Por Cliente
						cTextoCSV := ""												+ ";"
						cTextoCSV += ""												+ ";"
						cTextoCSV += ""												+ ";"
						cTextoCSV += ""												+ ";"
						cTextoCSV += ""												+ ";"
						cTextoCSV += ""												+ ";" 
						cTextoCSV += ""												+ ";"
						cTextoCSV += cTitTot											+ ";"
						cTextoCSV += ""												+ ";"
						cTextoCSV += Transform(aTotais[1], "@E 999,999,999.99")	+ ";"
						cTextoCSV += Transform(aTotais[2], "@E 999,999,999.99")	+ ";"
						cTextoCSV += Transform(aTotais[8], "@E 999,999,999.99")	+ ";"
						cTextoCSV += CRLF
						fwrite(nArq, cTextoCSV)
					Else 				&& Por Produto
						cTextoCSV := ""												+ ";"
						cTextoCSV += ""												+ ";"  
						cTextoCSV += ""												+ ";"
						cTextoCSV += cTitTot											+ ";"
						cTextoCSV += ""												+ ";"
						cTextoCSV += Transform(aTotais[1], "@E 999,999,999.99")	+ ";"
						cTextoCSV += Transform(aTotais[2], "@E 999,999,999.99")	+ ";"
						cTextoCSV += Transform(aTotais[3], "@E 999,999,999.99")	+ ";"
						cTextoCSV += Transform(aTotais[4], "@E 999,999,999.99")	+ ";"
						cTextoCSV += Transform(aTotais[5], "@E 999,999,999.99")	+ ";"
						cTextoCSV += Transform(aTotais[6], "@E 999,999,999.99")	+ ";"
						cTextoCSV += Transform(aTotais[7], "@E 999,999,999.99")	+ ";"
						cTextoCSV += Transform(aTotais[8], "@E 999,999,999.99")	+ ";"
						cTextoCSV += CRLF
						fwrite(nArq, cTextoCSV)
					EndIf
				EndIf
			EndIf

			If cCFOP == "1/2/3"
				cCFOP	:= "5/6"
				cGrpCF	:= "GRPCF2"
			ElseIf cCFOP == "5/6"
				cCFOP := "7"
				cGrpCF	:= "GRPCF3"
			EndIf

			aTotais[1] := 0
			aTotais[2] := 0
			aTotais[3] := 0
			aTotais[4] := 0
			aTotais[5] := 0
			aTotais[6] := 0
			aTotais[7] := 0
			aTotais[8] := 0
		EndIf
	Enddo
	QRY->(dbCloseArea())

	If MV_PAR11 == 1	&& Sint้tico
		nLin ++
		@ nLin, 044 PSay ">>> RECEITA LIQUIDA"
		//@ nLin, 095 PSay Transform(aGeral[1], "@E 999,999,999.99")
		@ nLin, 085 PSay Transform(aGeral[2], "@E 999,999,999.99")
		@ nLin, 104 PSay Transform(aGeral[3], "@E 999,999,999.99")
		@ nLin, 123 PSay Transform(aGeral[4], "@E 999,999,999.99")
		@ nLin, 143 PSay Transform(aGeral[5], "@E 999,999,999.99")
		@ nLin, 162 PSay Transform(aGeral[6], "@E 999,999,999.99")
		@ nLin, 181 PSay Transform(aGeral[7], "@E 999,999,999.99")
		@ nLin, 205 PSay Transform(aGeral[8], "@E 999,999,999.99")
		nLin += 2
	Else
		If MV_PAR12 == 1	&& Por Cliente
			@ nLin, 010 PSay ">>> RECEITA LIQUIDA"
			@ nLin, 164 PSay Transform(aGeral[1], "@E 999,999,999.99")
			@ nLin, 182 PSay Transform(aGeral[2], "@E 999,999,999.99")
			//@ nLin, 126 PSay Transform(aGeral[3], "@E 999,999,999.99")
			//@ nLin, 142 PSay Transform(aGeral[4], "@E 999,999,999.99")
			//@ nLin, 158 PSay Transform(aGeral[5], "@E 999,999,999.99")
			//@ nLin, 174 PSay Transform(aGeral[6], "@E 999,999,999.99")
			//@ nLin, 190 PSay Transform(aGeral[7], "@E 999,999,999.99")
			@ nLin, 206 PSay Transform(aGeral[8], "@E 999,999,999.99")
		Else 				&& Por Produto
			@ nLin, 009 PSay ">>> RECEITA LIQUIDA"
			@ nLin, 085 PSay Transform(aGeral[1], "@E 999,999,999.99")
			@ nLin, 101 PSay Transform(aGeral[2], "@E 999,999,999.99")
			@ nLin, 117 PSay Transform(aGeral[3], "@E 999,999,999.99")
			@ nLin, 134 PSay Transform(aGeral[4], "@E 999,999,999.99")
			@ nLin, 152 PSay Transform(aGeral[5], "@E 999,999,999.99")
			@ nLin, 169 PSay Transform(aGeral[6], "@E 999,999,999.99")
			@ nLin, 186 PSay Transform(aGeral[7], "@E 999,999,999.99")
			@ nLin, 206 PSay Transform(aGeral[8], "@E 999,999,999.99")
		EndIf
		nLin += 2
	EndIf

	&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
	&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& FILTRA DADOS DO FINANCEIRO:
	&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
	cQuery := " SELECT SE1.E1_FILIAL FILIAL, SUM(SE1.E1_VLCRUZ) E1_VLCRUZ"
	cQuery += " FROM "+RetSqlName("SE1")+" SE1"
	cQuery += " WHERE"
	cQuery +=		" SE1.E1_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND"
	cQuery +=		" SE1.E1_CLIENTE BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND"
	cQuery +=		" SE1.E1_LOJA BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' AND"
	cQuery +=		" SE1.E1_EMISSAO BETWEEN '"+DTOS(MV_PAR07)+"' AND '"+DTOS(MV_PAR08)+"' AND"
	cQuery +=		" SE1.E1_PREFIXO = 'BTB' AND"
	cQuery +=		" SE1.D_E_L_E_T_ = ' '"
	cQuery += " GROUP BY E1_FILIAL"

	If Select("QRY") <> 0
		QRY->(dbCloseArea())
	EndIf

	TcQuery cQuery Alias "QRY" New

	QRY->(dbGoTop())
	nFina := QRY->E1_VLCRUZ
	QRY->(dbCloseArea())

	If nLin > 55
		Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, nTipo)
		nLin := 8
	EndIf

	aGeral[2] += nFina
	aGeral[8] += nFina

	If MV_PAR11 == 1	&& Sint้tico
		&&           10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180       190       200       210       220
		&& 01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
		&& FILIAL                                  CFOP                                              TOTAL              ICMS                IPI      BASE PIS/COFINS               PIS             COFINS      RECEBIMENTO LอQUIDO
		&& 12 - 123456789012345678901234567890     1234 - 123456789012345678901234567890     999,999,999.99    999,999,999.99     999,999,999.99      999,999,999.99     999,999,999.99     999,999,999.99          999,999,999.99

		@ nLin, 004 PSay SM0->M0_CODFIL + " - " + Substr(SM0->M0_FILIAL, 01, 30)
		@ nLin, 044 PSay "Back To Back"
		@ nLin, 082 PSay Transform(nFina,	"@E 999,999,999.99")
		@ nLin, 100 PSay Transform(0,		"@E 999,999,999.99")
		@ nLin, 119 PSay Transform(0,		"@E 999,999,999.99")
		@ nLin, 139 PSay Transform(0,		"@E 999,999,999.99")
		@ nLin, 158 PSay Transform(0,		"@E 999,999,999.99")
		@ nLin, 177 PSay Transform(0,		"@E 999,999,999.99")
		@ nLin, 201 PSay Transform(nFina,	"@E 999,999,999.99")
		If nArq > 0
			cTextoCSV := SM0->M0_CODFIL								+ ";"
			cTextoCSV += SM0->M0_FILIAL								+ ";"
			cTextoCSV += ""											+ ";"
			cTextoCSV += "Back To Back"								+ ";"
			cTextoCSV += Transform(nFina,	"@E 999,999,999.99")	+ ";"
			cTextoCSV += Transform(0,		"@E 999,999,999.99")	+ ";"
			cTextoCSV += Transform(0,		"@E 999,999,999.99")	+ ";"
			cTextoCSV += Transform(0,		"@E 999,999,999.99")	+ ";"
			cTextoCSV += Transform(0,		"@E 999,999,999.99")	+ ";"
			cTextoCSV += Transform(0,		"@E 999,999,999.99")	+ ";"
			cTextoCSV += Transform(nFina,	"@E 999,999,999.99")	+ ";"
			cTextoCSV += CRLF
			fwrite(nArq, cTextoCSV)
		EndIf
	Else
		If MV_PAR12 == 1	&& Por Cliente
			&&           10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180       190       200       210       220
			&& 01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
			&& FILIAL     CLIENTE                              VENDEDOR                 PAIS                          PRODUTO                                              UM         QUANTIDADE              TOTAL     RECEBIMENTO LอQUIDO
			&&   12       123456/12 - 12345678901234567890     12345678901234567890     1234567890123456789012345     123456789012345 - 123456789012345678901234567890     12      99,999,999.99     999,999,999.99          999,999,999.99

			@ nLin, 011 PSay "Back To Back"
			@ nLin, 164 PSay Transform(0,		"@E 999,999,999.99")
			@ nLin, 182 PSay Transform(nFina,	"@E 999,999,999.99")
			@ nLin, 206 PSay Transform(nFina,	"@E 999,999,999.99")

			If nArq > 0
				cTextoCSV := ";"
				cTextoCSV += ";"
				cTextoCSV += ";"
				cTextoCSV += ";"
				cTextoCSV += ";"
				cTextoCSV += ";" 
				cTextoCSV += ";"
				cTextoCSV += "Back To Back"								+ ";"
				cTextoCSV += ""											+ ";"
				cTextoCSV += Transform(0,		"@E 999,999,999.99")	+ ";"
				cTextoCSV += Transform(nFina,	"@E 999,999,999.99")	+ ";"
				cTextoCSV += Transform(nFina,	"@E 999,999,999.99")	+ ";"
				cTextoCSV += CRLF
				fwrite(nArq, cTextoCSV)
			EndIf
		Else 				&& Por Produto
			&&           10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180       190       200       210       220
			&& 01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
			&& FILIAL  PRODUTO                                                                  UM     QUANTIDADE            TOTAL            ICMS              IPI   BASE PIS/COFINS              PIS           COFINS    RECEBIM. LอQUIDO
			&&   12    123456789012345 - 123456789012345678901234567890                         12  99,999,999.99   999,999,999.99  999,999,999.99   999,999,999.99    999,999,999.99   999,999,999.99   999,999,999.99      999,999,999.99
			@ nLin, 008 PSay "Back To Back"
			@ nLin, 085 PSay Transform(0,		"@E 999,999,999.99")
			@ nLin, 101 PSay Transform(nFina,	"@E 999,999,999.99")
			@ nLin, 117 PSay Transform(0,		"@E 999,999,999.99")
			@ nLin, 134 PSay Transform(0,		"@E 999,999,999.99")
			@ nLin, 152 PSay Transform(0,		"@E 999,999,999.99")
			@ nLin, 169 PSay Transform(0,		"@E 999,999,999.99")
			@ nLin, 186 PSay Transform(0,		"@E 999,999,999.99")
			@ nLin, 206 PSay Transform(nFina,	"@E 999,999,999.99")
			If nArq > 0
				cTextoCSV := ";"
				cTextoCSV += ";"
				cTextoCSV += ";"			
				cTextoCSV += "Back To Back"+";"
				cTextoCSV += ";"
				cTextoCSV += Transform(0,		"@E 999,999,999.99")	+ ";"
				cTextoCSV += Transform(nFina,	"@E 999,999,999.99")	+ ";"
				cTextoCSV += Transform(0,		"@E 999,999,999.99")	+ ";"
				cTextoCSV += Transform(0,		"@E 999,999,999.99")	+ ";"
				cTextoCSV += Transform(0,		"@E 999,999,999.99")	+ ";"
				cTextoCSV += Transform(0,		"@E 999,999,999.99")	+ ";"
				cTextoCSV += Transform(0,		"@E 999,999,999.99")	+ ";"
				cTextoCSV += Transform(nFina,	"@E 999,999,999.99")	+ ";"
				cTextoCSV += CRLF
				fwrite(nArq, cTextoCSV)
			EndIf
		EndIf
	EndIf
	nLin ++

	If MV_PAR11 == 1	&& Sint้tico
		@ nLin, 001 PSay Replicate("=", 219)
		nLin ++
		@ nLin, 044 PSay ">>> TOTAL LIQUIDO"
		//@ nLin, 195 PSay Transform(aGeral[1], "@E 999,999,999.99")
		@ nLin, 085 PSay Transform(aGeral[2], "@E 999,999,999.99")
		@ nLin, 104 PSay Transform(aGeral[3], "@E 999,999,999.99")
		@ nLin, 123 PSay Transform(aGeral[4], "@E 999,999,999.99")
		@ nLin, 143 PSay Transform(aGeral[5], "@E 999,999,999.99")
		@ nLin, 162 PSay Transform(aGeral[6], "@E 999,999,999.99")
		@ nLin, 181 PSay Transform(aGeral[7], "@E 999,999,999.99")
		@ nLin, 205 PSay Transform(aGeral[8], "@E 999,999,999.99")
		nLin += 0
		If nArq > 0
			cTextoCSV := ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ">>> TOTAL LIQUIDO;"
			//cTextoCSV += Transform(aGeral[1], "@E 999,999,999.99")+";"
			cTextoCSV += Transform(aGeral[2], "@E 999,999,999.99")+";"
			cTextoCSV += Transform(aGeral[3], "@E 999,999,999.99")+";"
			cTextoCSV += Transform(aGeral[4], "@E 999,999,999.99")+";"
			cTextoCSV += Transform(aGeral[5], "@E 999,999,999.99")+";"
			cTextoCSV += Transform(aGeral[6], "@E 999,999,999.99")+";"
			cTextoCSV += Transform(aGeral[7], "@E 999,999,999.99")+";"
			cTextoCSV += Transform(aGeral[8], "@E 999,999,999.99")+";"
			cTextoCSV += CRLF
			fwrite(nArq, cTextoCSV)
		EndIf
	Else
		If MV_PAR12 == 1	&& Por Cliente
			@ nLin, 010 PSay ">>> TOTAL LIQUIDO"
			@ nLin, 164 PSay Transform(aGeral[1], "@E 999,999,999.99")
			@ nLin, 182 PSay Transform(aGeral[2], "@E 999,999,999.99")
			//@ nLin, 126 PSay Transform(aGeral[3], "@E 999,999,999.99")
			//@ nLin, 142 PSay Transform(aGeral[4], "@E 999,999,999.99")
			//@ nLin, 158 PSay Transform(aGeral[5], "@E 999,999,999.99")
			//@ nLin, 174 PSay Transform(aGeral[6], "@E 999,999,999.99")
			//@ nLin, 190 PSay Transform(aGeral[7], "@E 999,999,999.99")
			@ nLin, 206 PSay Transform(aGeral[8], "@E 999,999,999.99")
		Else 				&& Por Produto
			@ nLin, 009 PSay ">>> TOTAL LIQUIDO"
			@ nLin, 085 PSay Transform(aGeral[1], "@E 999,999,999.99")
			@ nLin, 101 PSay Transform(aGeral[2], "@E 999,999,999.99")
			@ nLin, 117 PSay Transform(aGeral[3], "@E 999,999,999.99")
			@ nLin, 134 PSay Transform(aGeral[4], "@E 999,999,999.99")
			@ nLin, 152 PSay Transform(aGeral[5], "@E 999,999,999.99")
			@ nLin, 169 PSay Transform(aGeral[6], "@E 999,999,999.99")
			@ nLin, 186 PSay Transform(aGeral[7], "@E 999,999,999.99")
			@ nLin, 206 PSay Transform(aGeral[8], "@E 999,999,999.99")
		EndIf
		nLin += 2
		If nArq > 0
			If MV_PAR12 == 1	&& Por Cliente
				cTextoCSV := ";"
				cTextoCSV += ";"
				cTextoCSV += ">>> TOTAL LIQUIDO"+";"
				cTextoCSV += ";"
				cTextoCSV += ";"
				cTextoCSV += ";"
				cTextoCSV += ";"
				cTextoCSV += ";"
				cTextoCSV += ";"
				cTextoCSV += Transform(aGeral[1], "@E 999,999,999.99")+";"
				cTextoCSV += Transform(aGeral[2], "@E 999,999,999.99")+";"
				//cTextoCSV += Transform(aGeral[3], "@E 999,999,999.99")+";"
				//cTextoCSV += Transform(aGeral[4], "@E 999,999,999.99")+";"
				//cTextoCSV += Transform(aGeral[5], "@E 999,999,999.99")+";"
				//cTextoCSV += Transform(aGeral[6], "@E 999,999,999.99")+";"
				//cTextoCSV += Transform(aGeral[7], "@E 999,999,999.99")+";"
				cTextoCSV += Transform(aGeral[8], "@E 999,999,999.99")+";"
				cTextoCSV += CRLF
				fwrite(nArq, cTextoCSV)
			Else
				cTextoCSV := ";"
				cTextoCSV += ";"
				cTextoCSV += ";"
				cTextoCSV += ">>> TOTAL LIQUIDO"+";"
				cTextoCSV += ";"
				cTextoCSV += Transform(aGeral[1], "@E 999,999,999.99")+";"
				cTextoCSV += Transform(aGeral[2], "@E 999,999,999.99")+";"
				cTextoCSV += Transform(aGeral[3], "@E 999,999,999.99")+";"
				cTextoCSV += Transform(aGeral[4], "@E 999,999,999.99")+";"
				cTextoCSV += Transform(aGeral[5], "@E 999,999,999.99")+";"
				cTextoCSV += Transform(aGeral[6], "@E 999,999,999.99")+";"
				cTextoCSV += Transform(aGeral[7], "@E 999,999,999.99")+";"
				cTextoCSV += Transform(aGeral[8], "@E 999,999,999.99")+";"
				cTextoCSV += CRLF
				fwrite(nArq, cTextoCSV)
			EndIf
		EndIf
	EndIf

	Set Device To Screen

	If aReturn[5] == 1
		dbCommitAll()
		Set Printer To
		OurSpool(wnrel)
	EndIf

	MS_FLUSH()

	If nArq > 0
		fClose(nArq)
		fExpExcel(cArquivo, Alltrim(cPasta))
	EndIf
Return

&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
Static Function fExpExcel(cArquivo, cPasta)
	Local oExcelApp

	CpyS2T(cArquivo, cPasta, .T.)
	If 	!ApOleClient("MsExcel")
		MsgStop("MsExcel nใo instalado")
	Else
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open(cPasta + cArquivo) // Abre uma planilha
		oExcelApp:SetVisible(.T.)
	EndIf
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuncao    ณAjustaSX1 ณ Autor ณMarcelo Alexandre      ณ Data ณ25/06/2007ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
/*Static Function AjustaSx1(cPerg)
	Local aHelpP	:= {}
	Local aHelpE	:= {}
	Local aHelpS	:= {}

	PutSx1(cPerg, "01", "Da Filial ?",				"", "", "mv_ch1", "C", 02, 0, 0, "G", "", "SM0", "", "", "MV_PAR01", "",				"",					"",					"",	"",					"",					"",					"", "", "", "", "", "", "", "", "", aHelpP,aHelpE,aHelpS)
	PutSx1(cPerg, "02", "At้ Filial ?",			"", "", "mv_ch2", "C", 02, 0, 0, "G", "", "SM0", "", "", "MV_PAR02", "",				"",					"",					"",	"",					"",					"",					"", "", "", "", "", "", "", "", "", aHelpP,aHelpE,aHelpS)
	PutSx1(cPerg, "03", "Do Cliente ?",			"", "", "mv_ch3", "C", 06, 0, 0, "G", "", "CLI", "", "", "MV_PAR03", "",				"",					"",					"",	"",					"",					"",					"", "", "", "", "", "", "", "", "", aHelpP,aHelpE,aHelpS)
	PutSx1(cPerg, "04", "At้ Cliente ?",			"", "", "mv_ch4", "C", 06, 0, 0, "G", "", "CLI", "", "", "MV_PAR04", "",				"",					"",					"",	"",					"",					"",					"", "", "", "", "", "", "", "", "", aHelpP,aHelpE,aHelpS)
	PutSx1(cPerg, "05", "Da Loja ?",				"", "", "mv_ch5", "C", 02, 0, 0, "G", "", "   ", "", "", "MV_PAR05", "",				"",					"",					"",	"",					"",					"",					"", "", "", "", "", "", "", "", "", aHelpP,aHelpE,aHelpS)
	PutSx1(cPerg, "06", "At้ Loja ?",				"", "", "mv_ch6", "C", 02, 0, 0, "G", "", "   ", "", "", "MV_PAR06", "",				"",					"",					"",	"",					"",					"",					"", "", "", "", "", "", "", "", "", aHelpP,aHelpE,aHelpS)
	PutSx1(cPerg, "07", "Da Data de Emissao ?",	"", "", "mv_ch7", "D", 08, 0, 0, "G", "", ""   , "", "", "MV_PAR07", "",				"",					"",					"",	"",					"",					"",					"", "", "", "", "", "", "", "", "", aHelpP,aHelpE,aHelpS)
	PutSx1(cPerg, "08", "At้ Data de Emissao ?",	"", "", "mv_ch8", "D", 08, 0, 0, "G", "", ""   , "", "", "MV_PAR08", "",				"",					"",					"",	"",					"",					"",					"", "", "", "", "", "", "", "", "", aHelpP,aHelpE,aHelpS)
	PutSx1(cPerg, "09", "Do Produto ?",			"", "", "mv_ch9", "C", 15, 0, 0, "G", "", "SB1", "", "", "MV_PAR09", "",				"",					"",					"",	"",					"",					"",					"", "", "", "", "", "", "", "", "", aHelpP,aHelpE,aHelpS)
	PutSx1(cPerg, "10", "At้ Produto ?",			"", "", "mv_chA", "C", 15, 0, 0, "G", "", "SB1", "", "", "MV_PAR10", "",				"",					"",					"",	"",					"",					"",					"", "", "", "", "", "", "", "", "", aHelpP,aHelpE,aHelpS)
	PutSx1(cPerg, "11", "Modelo ?",					"", "", "mv_chB", "N", 01, 0, 1, "C", "", ""   , "", "", "MV_PAR11", "Sint้tico",	"Sint้tico",		"Sint้tico",		"",	"Analํtico",		"Analํtico",		"Analํtico",		"", "", "", "", "", "", "", "", "", aHelpP,aHelpE,aHelpS)
	PutSx1(cPerg, "12", "Modelo Analitico ?",		"", "", "mv_chC", "N", 01, 0, 1, "C", "", ""   , "", "", "MV_PAR12", "Por Cliente",	"Por Cliente",	"Por Cliente",	"",	"Por Produto",	"Por Produto",	"Por Produto",	"", "", "", "", "", "", "", "", "", aHelpP,aHelpE,aHelpS)
	PutSx1(cPerg, "13", "Exporta Excel ?",			"", "", "mv_chD", "N", 01, 0, 1, "C", "", ""   , "", "", "MV_PAR13", "Sim",			"Sim",				"Sim",				"",	"Nใo",				"Nใo",				"Nใo",				"", "", "", "", "", "", "", "", "", aHelpP,aHelpE,aHelpS)
Return

*/
Static Function AjDesonera()
local cSql := ""
Local nPerDeso := Val(GetMV("MV_ZZPDESO"))

 cSql  := ""
 cSql  :=  cSql + " SELECT R_E_C_N_O_ REGISTRO FROM "
 cSql  :=  cSql + RetSqlName("SD2")
 cSql  :=  cSql + " WHERE D_E_L_E_T_  = ' '                      AND "
 cSql  :=  cSql + "       D2_FILIAL   = '"+xfilial("SD2")+"'     AND "
 cSql  :=  cSql + "       D2_ZDESON   = 0                        AND  "
 cSql  :=  cSql + "       SUBSTRING(D2_CF,1,1) < '7' "

if select("OPNW")> 0
	dbSelectArea("OPNW")
	dbCloseArea()
	dbselectarea("SD2")
endif

dbUseArea(.T.,"TOPCONN",TcGenQry(,, cSql),"OPNW",.T.,.T.)
sb5->(dbsetorder(1))
dbSelectArea("OPNW")

while !opnw->(eof())
	dbselectarea("SD2")
	sd2->(dbgoto(opnw->registro))
	if sb5->(dbseek(xfilial("SB5") + sd2->d2_cod )) 
		if sb5->b5_inspat == "1" .and. !empty(sb5->b5_codativ) .and. nPerDeso > 0
			sd2->(RecLock("SD2",.f.))
			//sd2->d2_zdeson := sd2->d2_BASIMP5 * 0.01  //(sd2->d2_valbrut - ( sd2->d2_valicm + sd2->d2_valipi + sd2->d2_valimp5 + sd2->d2_valimp6)) * 0.01	
			sd2->d2_zdeson := sd2->d2_BASIMP5 * (nPerDeso/100)	
			sd2->(MsUnlock())	
		endif
	endif
	dbSelectArea("OPNW")
	opnw->(dbskip())
end-while

dbCloseArea()
dbselectarea("SD2")
return()
        

Static Function AjDevol()
local cSql := "" 
local nPerDeso := Val(GetMV("MV_ZZPDESO"))  

 cSql  := ""
 cSql  :=  cSql + " SELECT R_E_C_N_O_ REGISTRO FROM "
 cSql  :=  cSql + RetSqlName("SD1")
 cSql  :=  cSql + " WHERE D_E_L_E_T_  = ' '                      AND "
 cSql  :=  cSql + "       D1_FILIAL   = '"+xfilial("SD1")+"'     AND "
 cSql  :=  cSql + "       D1_ZDESON   = 0                        AND  "
 cSql  :=  cSql + "       SUBSTRING(D1_CF,1,1) < '3' "

if select("OPNW")> 0
	dbSelectArea("OPNW")
	dbCloseArea()
	dbselectarea("SD1")
endif

dbUseArea(.T.,"TOPCONN",TcGenQry(,, cSql),"OPNW",.T.,.T.)
sb5->(dbsetorder(1))
dbSelectArea("OPNW")

while !opnw->(eof())
	dbselectarea("SD1")
	sd1->(dbgoto(opnw->registro))
	if sb5->(dbseek(xfilial("SB5") + sd1->d1_cod )) 
		if sb5->b5_inspat == "1" .and. !empty(sb5->b5_codativ)
			sd1->(RecLock("SD1",.f.))
			//sd1->d1_zdeson := sd1->d1_BASIMP5 * 0.01  //(sd1->d1_total - ( sd1->d1_valicm + sd1->d1_valimp5 + sd1->d1_valimp6)) * 0.01	
			sd1->d1_zdeson := sd1->d1_BASIMP5 * (nPerDeso/100)	
			sd1->(MsUnlock())	
		endif
	endif
	dbSelectArea("OPNW")
	opnw->(dbskip())
end-while                                

dbCloseArea()
dbselectarea("SD1")
return()