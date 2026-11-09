#Include "Protheus.ch"
#Include "TopConn.ch"

/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±         
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥ PARFATA1  ∫ Autor ≥ Cassandra J. Silva ∫ Data ≥ 20/06/2012 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Descricao ≥ RelatÛrio Movimento Cont·bil e Fiscal.                     ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ EspecÌfico PARAFIX                                         ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/
User Function PARFATA3()	&& PAR - PARAFIX / FAT - Faturamento / A - AtualizaÁ„o / 1 - Sequencial

Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := " com desoneracao de 1%"
Local cPict         := ""
Local titulo       	:= "Recebimento LÌquido - Movimento Fiscal/Cont·bil"
Local nLin         	:= 80
Local Cabec1       	:= ""
Local Cabec2       	:= ""
Local imprime      	:= .T.
Local aOrd 			:= {}
Private cPasta    	:= ""
Private cTextoCSV 	:= ""
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 220
Private tamanho     := "G"
Private nomeprog    := "PARFATA3"
Private nTipo       := 15
Private aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey    := 0
Private cPerg       := "PARFATA3"
Private cbtxt      	:= Space(10)
Private cbcont     	:= 00
Private CONTFL     	:= 01
Private m_pag      	:= 01
Private wnrel      	:= "PARFATA3"
Private cString 	:= ""
Private cArquivo	:= ""
Private nArq    	:= 0

//AjustaSx1(cPerg)


If !Pergunte(cPerg,.T.)
	Return Nil
Endif

AjDesonera()
AjDevol()


If MV_PAR13 == 1
	cPasta := cGetFile('Arquivos (*.csv) | *.csv', 'Selecione o diretÛrio - EXCEL', 1, , .T., GETF_LOCALHARD + GETF_NETWORKDRIVE + GETF_RETDIRECTORY, .T.)
	If !Empty(cPasta)
		cArquivo := "Rec_Liquido.csv"
		nArq     := fCreate(Alltrim(cPasta) +"\"+ cArquivo, 0)
		
		If MV_PAR11 == 1	&& SintÈtico
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
				cTextoCSV += CHR(13)+CHR(10)
				fwrite(nArq, cTextoCSV)
			Endif
		Else
			If MV_PAR12 == 1	&& Por Cliente
				If nArq > 0
					cTextoCSV := "FILIAL;"
					cTextoCSV += "CLIENTE;"
					cTextoCSV += "NOME;"
					cTextoCSV += "VENDEDOR;"
					cTextoCSV += "PAIS;"
					cTextoCSV += "PRODUTO;"
					cTextoCSV += "DESCRI«√O;"
					cTextoCSV += "UM;"
					cTextoCSV += "QUANTIDADE;"
					cTextoCSV += "TOTAL;"
					cTextoCSV += "LIQUIDO;"
					cTextoCSV += CHR(13)+CHR(10)
					fwrite(nArq, cTextoCSV)
				Endif
			Else
				If nArq > 0
					cTextoCSV := "FILIAL;"
					cTextoCSV += "PRODUTO;"
					cTextoCSV += "DESCRI«√O;"
					cTextoCSV += "CF;"
					cTextoCSV += "TOTAL;"
					cTextoCSV += "ICMS;"
					cTextoCSV += "IPI;"
					cTextoCSV += "BASE PIS/COF;"
					cTextoCSV += "PIS;"
					cTextoCSV += "COFINS;"
					cTextoCSV += "LIQUIDO;"
					cTextoCSV += CHR(13)+CHR(10)
					fwrite(nArq, cTextoCSV)
				Endif
			Endif
		Endif
	Endif
Endif

If MV_PAR11 == 1	&& SintÈtico
	Cabec1 := "       FILIAL                               CFOP                                               TOTAL              ICMS                IPI      BASE PIS/COFINS               PIS             COFINS      RECEBIMENTO LÕQUIDO"
Else
	If MV_PAR12 == 1	&& Por Cliente
		Cabec1 := "FILIAL     CLIENTE                              VENDEDOR                 PAIS                          PRODUTO                                              UM         QUANTIDADE              TOTAL     RECEBIMENTO LÕQUIDO"
	Else 				&& Por Produto
		Cabec1 := "FILIAL   PRODUTO             DESCRI«√O                                         CFOP          TOTAL               ICMS                IPI      BASE PIS/COFINS               PIS             COFINS      RECEBIMENTO LÕQUIDO"
	Endif
Endif

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return Nil
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return Nil
Endif

nTipo := If(aReturn[4]==1,15,18)

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return Nil


/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫FunáÑo    ≥RUNREPORT ∫ Autor ≥ AP6 IDE            ∫ Data ≥  20/06/12   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫DescriáÑo ≥ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ∫±±
±±∫          ≥ monta a janela com a regua de processamento.               ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ Programa principal                                         ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local cQuery  := ""
Local cNatOper:= ""
Local cCFOP   := ""
Local cSepara := ""
Local aTotais := {}
Local aGeral  := {}
Local nVlrLiq := 0
Local nFina   := 0
Local cDesc   := X5DESCRI()
SA1->(dbSetOrder(1))
SB1->(dbSetOrder(1))
SX5->(dbSetOrder(1))

&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& FILTRA DADOS DO FATURAMENTO (VENDAS):
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

cQuery := " SELECT"

If MV_PAR11 == 1	&& SintÈtico
	cQuery +=	" SD2.D2_FILIAL FILIAL, SD2.D2_CF CF, SUM(SD2.D2_VALBRUT) VALBRUT, SUM(SD2.D2_VALICM) VALICM, SUM(SD2.D2_VALIPI) VALIPI,"
	cQuery +=	" SUM(SD2.D2_BASIMP5) BASIMP5, SUM(SD2.D2_VALIMP5) VALIMP5, SUM(SD2.D2_BASIMP6) BASIMP6, SUM(SD2.D2_VALIMP6) VALIMP6, SUM(D2_ZDESON ) DESONERA "
	
Else				&& AnalÌtico
	
	If MV_PAR12 == 1	&& Por Cliente
		cQuery +=	" SD2.D2_FILIAL FILIAL, SD2.D2_CF CF, SD2.D2_CLIENTE CLIENTE, SD2.D2_LOJA LOJA, SUM(SD2.D2_VALBRUT) VALBRUT, SUM(SD2.D2_VALICM) VALICM,"
		cQuery +=	" SUM(SD2.D2_VALIPI) VALIPI, SUM(SD2.D2_BASIMP5) BASIMP5, SUM(SD2.D2_VALIMP5) VALIMP5, SUM(SD2.D2_BASIMP6) BASIMP6, SUM(SD2.D2_VALIMP6) VALIMP6,  SUM(D2_ZDESON ) DESONERA"
		
	Else 				&& Por Produto
		cQuery +=	" SD2.D2_FILIAL FILIAL, SD2.D2_CF CF, SD2.D2_COD COD, SUM(SD2.D2_VALBRUT) VALBRUT, SUM(SD2.D2_VALICM) VALICM, SUM(SD2.D2_VALIPI) VALIPI,"
		cQuery +=	" SUM(SD2.D2_BASIMP5) BASIMP5, SUM(SD2.D2_VALIMP5) VALIMP5, SUM(SD2.D2_BASIMP6) BASIMP6, SUM(SD2.D2_VALIMP6) VALIMP6,  SUM(D2_ZDESON ) DESONERA"
	Endif
Endif

cQuery += " FROM "+RetSqlName("SD2")+" SD2"
cQuery +=		" INNER JOIN "+RetSqlName("SF4")+" SF4 ON"
cQuery +=				" SF4.F4_FILIAL = SD2.D2_FILIAL AND"
cQuery +=				" SF4.F4_CODIGO = SD2.D2_TES AND"
cQuery +=				" SF4.F4_DUPLIC = 'S' AND"
cQuery +=				" SF4.F4_ESTOQUE = 'S' AND"
cQuery +=				" SF4.D_E_L_E_T_ = ' '"
cQuery +=		" INNER JOIN "+RetSqlName("SF2")+" SF2 ON"
cQuery +=				" SF2.F2_FILIAL = SD2.D2_FILIAL AND"
cQuery +=				" SF2.F2_DOC = SD2.D2_DOC AND"
cQuery +=				" SF2.F2_SERIE = SD2.D2_SERIE AND"
cQuery +=				" SF2.F2_CLIENTE = SD2.D2_CLIENTE AND"
cQuery +=				" SF2.F2_LOJA = SD2.D2_LOJA AND"
cQuery +=				" SF2.F2_TIPO NOT IN ('D','B') AND"
cQuery +=				" SF2.D_E_L_E_T_ = ' '"
cQuery += " WHERE"
cQuery +=		" SD2.D2_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND"
cQuery +=		" SD2.D2_CLIENTE BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND"
cQuery +=		" SD2.D2_LOJA BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' AND"
cQuery +=		" SD2.D2_EMISSAO BETWEEN '"+DTOS(MV_PAR07)+"' AND '"+DTOS(MV_PAR08)+"' AND"
cQuery +=		" SD2.D2_COD BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"' AND"
cQuery +=		" SUBSTRING(SD2.D2_CF,1,2) <> '71' AND"
cQuery +=		" SD2.D_E_L_E_T_ = ' '"
cQuery += " GROUP BY"

If MV_PAR11 == 1	&& SintÈtico
	cQuery +=	" SD2.D2_FILIAL, SD2.D2_CF"
Else
	If MV_PAR12 == 1	&& Por Cliente
		cQuery		+=	"		D2_FILIAL, D2_CF, D2_CLIENTE, D2_LOJA, F2_VEND1, D2_COD, D2_UM "
	Else 				&& Por Produto
		cQuery +=	" SD2.D2_FILIAL, SD2.D2_CF, SD2.D2_COD"
	Endif
Endif

cQuery += " UNION ALL"

&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& FILTRA DADOS DO FATURAMENTO (EXPORTA«√O):
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

cQuery += " SELECT"

If MV_PAR11 == 1	&& SintÈtico
	cQuery +=	" SD2.D2_FILIAL FILIAL, SD2.D2_CF CF, SUM(SD2.D2_VALBRUT) VALBRUT, SUM(SD2.D2_VALICM) VALICM, SUM(SD2.D2_VALIPI) VALIPI,"
	cQuery +=	" SUM(SD2.D2_BASIMP5) BASIMP5, SUM(SD2.D2_VALIMP5) VALIMP5, SUM(SD2.D2_BASIMP6) BASIMP6, SUM(SD2.D2_VALIMP6) VALIMP6, 0 AS DESONERA "
	
Else				&& AnalÌtico
	
	If MV_PAR12 == 1	&& Por Cliente
		cQuery +=	" SD2.D2_FILIAL FILIAL, SD2.D2_CF CF, SD2.D2_CLIENTE CLIENTE, SD2.D2_LOJA LOJA, F2_VEND1 VENDEDOR, D2_COD COD, D2_UM UM, SUM(D2_QUANT) QUANT, SUM(SD2.D2_VALBRUT) VALBRUT, "
		cQuery +=	" SUM(SD2.D2_VALICM) VALICM, SUM(SD2.D2_VALIPI) VALIPI, SUM(SD2.D2_BASIMP5) BASIMP5, SUM(SD2.D2_VALIMP5) VALIMP5, SUM(SD2.D2_BASIMP6) BASIMP6, SUM(SD2.D2_VALIMP6) VALIMP6, 0 AS DESONERA"
		
	Else 				&& Por Produto
		cQuery +=	" SD2.D2_FILIAL FILIAL, SD2.D2_CF CF, SD2.D2_COD COD, SUM(SD2.D2_VALBRUT) VALBRUT, SUM(SD2.D2_VALICM) VALICM, SUM(SD2.D2_VALIPI) VALIPI,"
		cQuery +=	" SUM(SD2.D2_BASIMP5) BASIMP5, SUM(SD2.D2_VALIMP5) VALIMP5, SUM(SD2.D2_BASIMP6) BASIMP6, SUM(SD2.D2_VALIMP6) VALIMP6, 0 AS DESONERA"
	Endif
Endif

cQuery += " FROM "+RetSqlName("SD2")+" SD2"
cQuery += " WHERE"
cQuery +=		" SD2.D2_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND"
cQuery +=		" SD2.D2_CLIENTE BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND"
cQuery +=		" SD2.D2_LOJA BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' AND"
cQuery +=		" SD2.D2_EMISSAO BETWEEN '"+DTOS(MV_PAR07)+"' AND '"+DTOS(MV_PAR08)+"' AND"
cQuery +=		" SD2.D2_COD BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"' AND"
cQuery +=		" SUBSTRING(SD2.D2_CF,1,2) = '71' AND"
cQuery +=		" SD2.D_E_L_E_T_ = ' '"
cQuery += " GROUP BY"

If MV_PAR11 == 1	&& SintÈtico
	cQuery +=	" SD2.D2_FILIAL, SD2.D2_CF"
Else
	If MV_PAR12 == 1	&& Por Cliente
		
		cQuery +=	" SD2.D2_FILIAL, SD2.D2_CF, SD2.D2_CLIENTE, SD2.D2_LOJA, F2_VEND1, D2_COD, D2_UM "
	Else 				&& Por Produto
		cQuery +=	" SD2.D2_FILIAL, SD2.D2_CF, SD2.D2_COD"
	Endif
Endif

cQuery += " UNION ALL"

&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& FILTRA DADOS DO COMPRAS (DEVOLU«’ES):
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

cQuery += " SELECT"

If MV_PAR11 == 1	&& SintÈtico
	cQuery +=	" SD1.D1_FILIAL FILIAL, SD1.D1_CF CF, SUM(SD1.D1_TOTAL) VALBRUT, SUM(SD1.D1_VALICM) VALICM, SUM(SD1.D1_VALIPI) VALIPI,"
	cQuery +=	" SUM(SD1.D1_BASIMP5) BASIMP5, SUM(SD1.D1_VALIMP5) VALIMP5, SUM(SD1.D1_BASIMP6) BASIMP6, SUM(SD1.D1_VALIMP6) VALIMP6, SUM(D1_ZDESON ) AS DESONERA"
	
Else				&& AnalÌtico
	
	If MV_PAR12 == 1	&& Por FORNECE
		cQuery +=	" SD1.D1_FILIAL FILIAL, SD1.D1_CF CF, SD1.D1_FORNECE CLIENTE, SD1.D1_LOJA LOJA,'' VENDEDOR, D1_COD COD, D1_UM UM, SUM(D1_QUANT) QUANT, SUM(SD1.D1_TOTAL) VALBRUT, SUM(SD1.D1_VALICM) VALICM,"
		cQuery +=	" SUM(SD1.D1_VALIPI) VALIPI, SUM(SD1.D1_BASIMP5) BASIMP5, SUM(SD1.D1_VALIMP5) VALIMP5, SUM(SD1.D1_BASIMP6) BASIMP6, SUM(SD1.D1_VALIMP6) VALIMP6, SUM(D1_ZDESON ) AS DESONERA"
		
	Else 				&& Por Produto
		cQuery +=	" SD1.D1_FILIAL FILIAL, SD1.D1_CF CF, SD1.D1_COD COD, SUM(SD1.D1_TOTAL) VALBRUT, SUM(SD1.D1_VALICM) VALICM, SUM(SD1.D1_VALIPI) VALIPI,"
		cQuery +=	" SUM(SD1.D1_BASIMP5) BASIMP5, SUM(SD1.D1_VALIMP5) VALIMP5, SUM(SD1.D1_BASIMP6) BASIMP6, SUM(SD1.D1_VALIMP6) VALIMP6, SUM(D1_ZDESON ) AS DESONERA"
	Endif
Endif

cQuery += " FROM "+RetSqlName("SD1")+" SD1"
cQuery +=		" INNER JOIN "+RetSqlName("SF1")+" SF1 ON"
cQuery +=				" SF1.F1_FILIAL = SD1.D1_FILIAL AND"
cQuery +=				" SF1.F1_DOC = SD1.D1_DOC AND"
cQuery +=				" SF1.F1_SERIE = SD1.D1_SERIE AND"
cQuery +=				" SF1.F1_FORNECE = SD1.D1_FORNECE AND"
cQuery +=				" SF1.F1_LOJA = SD1.D1_LOJA AND"
cQuery +=				" SF1.F1_TIPO = 'D' AND"
cQuery +=				" SF1.D_E_L_E_T_ = ' '"
cQuery += " WHERE"
cQuery +=		" SD1.D1_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND"
cQuery +=		" SD1.D1_FORNECE BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND"
cQuery +=		" SD1.D1_LOJA BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' AND"
cQuery +=		" SD1.D1_EMISSAO BETWEEN '"+DTOS(MV_PAR07)+"' AND '"+DTOS(MV_PAR08)+"' AND"
cQuery +=		" SD1.D1_COD BETWEEN '"+MV_PAR09+"' AND '"+MV_PAR10+"' AND"
cQuery +=		" SD1.D_E_L_E_T_ = ' '"
cQuery += " GROUP BY"

If MV_PAR11 == 1	&& SintÈtico
	cQuery +=	" SD1.D1_FILIAL, SD1.D1_CF"
Else
	If MV_PAR12 == 1	&& Por FORNECE
		cQuery +=	" SD1.D1_FILIAL, SD1.D1_CF, SD1.D1_FORNECE, SD1.D1_LOJA, D1_COD, D1_UM "
	Else 				&& Por Produto
		cQuery +=	" SD1.D1_FILIAL, SD1.D1_CF, SD1.D1_COD"
	Endif
Endif

//cQuery += " ORDER BY FILIAL, CF"
cQuery				+=	"ORDER BY "																												+ CRLF
If MV_PAR11 == 1	&& SintÈtico
	cQuery			+=	"	FILIAL, CF "																											+ CRLF
Else
	If MV_PAR12 == 1	&& Por Cliente
		cQuery		+=	"	FILIAL, CF, CLIENTE, LOJA, VENDEDOR, COD "																		+ CRLF
	Else 				&& Por Produto
		cQuery		+=	"	FILIAL, CF, COD "																										+ CRLF
	EndIf
EndIf
If Select("QRY") <> 0
	QRY->(dbCloseArea())
Endif

TcQuery cQuery Alias "QRY" New

SetRegua(QRY->(RecCount()))

cCFOP   := "1/2/3"
aTotais := {0,0,0,0,0,0,0,0} //Alterado
aGeral  := {0,0,0,0,0,0,0,0} //Alterado

cSepara := QRY->CF

QRY->(dbGoTop())
Do While QRY->(!Eof())
	
	If Substr(QRY->CF,1,1) $ "1/2/3"
		E5_ZZVLMD1 := (QRY->VALBRUT+QRY->VALIPI) - QRY->VALICM - QRY->VALIPI - QRY->VALIMP5 - QRY->VALIMP6 - QRY->DESONERA
	Else
		nVlrLiq := QRY->VALBRUT - QRY->VALICM - QRY->VALIPI - QRY->VALIMP5 - QRY->VALIMP6 - QRY->DESONERA
	Endif
	
 //	SX5->(dbSeek( xFilial("SX5") + "13" + QRY->CF ))
 //	cNatOper := AllTrim(SX5->X5_DESCRI)
 	
 	If MV_PAR11 == 1	&& SintÈtico
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
	Endif
	
	If nLin > 55
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	If MV_PAR11 == 1	&& SintÈtico
		&&          10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180       190       200       210       220
		&& 1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
		&&    FILIAL                                  CFOP                                              TOTAL              ICMS                IPI      BASE PIS/COFINS               PIS             COFINS      RECEBIMENTO LÕQUIDO
		&&    12 - 123456789012345678901234567890     1234 - 123456789012345678901234567890     999,999,999.99    999,999,999.99     999,999,999.99      999,999,999.99     999,999,999.99     999,999,999.99          999,999,999.99
		
		@ nLin, 004 PSay QRY->FILIAL+" - "+Substr(SM0->M0_FILIAL,1,30)
		@ nLin, 044 PSay QRY->CF+" - "+Substr(cNatOper,1,30)
		
		If Substr(QRY->CF,1,1) $ "1/2/3"
			@ nLin, 086 PSay Transform(QRY->VALBRUT + QRY->VALIPI, "@E 999,999,999.99")
		Else
			@ nLin, 086 PSay Transform(QRY->VALBRUT, "@E 999,999,999.99")
		Endif
		
		@ nLin, 104 PSay Transform(QRY->VALICM, "@E 999,999,999.99")
		@ nLin, 123 PSay Transform(QRY->VALIPI, "@E 999,999,999.99")
		@ nLin, 143 PSay Transform(QRY->BASIMP5, "@E 999,999,999.99")
		@ nLin, 162 PSay Transform(QRY->VALIMP6, "@E 999,999,999.99")
		@ nLin, 181 PSay Transform(QRY->VALIMP5, "@E 999,999,999.99")
		@ nLin, 205 PSay Transform(nVlrLiq, "@E 999,999,999.99")
		
		If nArq > 0
			cTextoCSV := QRY->FILIAL+";"
			cTextoCSV += SM0->M0_FILIAL+";"
			cTextoCSV += QRY->CF+";"
			cTextoCSV += cNatOper+";"
			cTextoCSV += Transform(QRY->VALBRUT, "@E 999,999,999.99")+";"
			cTextoCSV += Transform(QRY->VALICM, "@E 999,999,999.99")+";"
			cTextoCSV += Transform(QRY->VALIPI, "@E 999,999,999.99")+";"
			cTextoCSV += Transform(QRY->BASIMP5, "@E 999,999,999.99")+";"
			cTextoCSV += Transform(QRY->VALIMP6, "@E 999,999,999.99")+";"
			cTextoCSV += Transform(QRY->VALIMP5, "@E 999,999,999.99")+";"
			cTextoCSV += Transform(nVlrLiq, "@E 999,999,999.99")+";"
			cTextoCSV += CHR(13)+CHR(10)
			fwrite(nArq, cTextoCSV)
		Endif
		
	Else
		
		If MV_PAR12 == 1	&& Por Cliente
			/*
			SA1->(dbSeek( xFilial("SA1") + QRY->CLIENTE + QRY->LOJA ))
			
			&&          10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180       190       200       210       220
			&& 1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
			&&  FILIAL  CLIENTE                                                          CFOP             TOTAL              ICMS                IPI      BASE PIS/COFINS               PIS             COFINS      RECEBIMENTO LÕQUIDO
			&&    12    123456/12 - 12345678901234567890123456789012345678901234567890   1234     999,999,999.99    999,999,999.99     999,999,999.99      999,999,999.99     999,999,999.99     999,999,999.99          999,999,999.99
			
			@ nLin, 004 PSay QRY->FILIAL
			@ nLin, 010 PSay QRY->CLIENTE+"/"+QRY->LOJA+" - "+Substr(SA1->A1_NOME,1,50)
			@ nLin, 075 PSay QRY->CF
			@ nLin, 084 PSay Transform(QRY->VALBRUT, "@E 999,999,999.99")
			@ nLin, 102 PSay Transform(QRY->VALICM, "@E 999,999,999.99")
			@ nLin, 121 PSay Transform(QRY->VALIPI, "@E 999,999,999.99")
			@ nLin, 141 PSay Transform(QRY->BASIMP5, "@E 999,999,999.99")
			@ nLin, 160 PSay Transform(QRY->VALIMP6, "@E 999,999,999.99")
			@ nLin, 179 PSay Transform(QRY->VALIMP5, "@E 999,999,999.99")
			@ nLin, 203 PSay Transform(nVlrLiq, "@E 999,999,999.99")
			
			If nArq > 0
				cTextoCSV := QRY->FILIAL+";"
				cTextoCSV += QRY->CLIENTE+"/"+QRY->LOJA+";"
				cTextoCSV += SA1->A1_NOME+";"
				cTextoCSV += QRY->CF+";"
				cTextoCSV += Transform(QRY->VALBRUT, "@E 999,999,999.99")+";"
				cTextoCSV += Transform(QRY->VALICM, "@E 999,999,999.99")+";"
				cTextoCSV += Transform(QRY->VALIPI, "@E 999,999,999.99")+";"
				cTextoCSV += Transform(QRY->BASIMP5, "@E 999,999,999.99")+";"
				cTextoCSV += Transform(QRY->VALIMP6, "@E 999,999,999.99")+";"
				cTextoCSV += Transform(QRY->VALIMP5, "@E 999,999,999.99")+";"
				cTextoCSV += Transform(nVlrLiq, "@E 999,999,999.99")+";"
				cTextoCSV += CHR(13)+CHR(10)
				fwrite(nArq, cTextoCSV)
			Endif            */
				SB1->(DbSeek(xFilial("SB1") + QRY->COD))
				SA1->(DbSeek(xFilial("SA1") + QRY->CLIENTE + QRY->LOJA))
				cPaisDes	:= Posicione("SYA", 1, xFilial("SYA") + SA1->A1_PAIS,											"YA_DESCR"		)
				cVendedor	:= Posicione("SA3", 1, xFilial("SA3") + cCodVend,												"A3_NREDUZ"	)
				&&           10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180       190       200       210       220
				&& 01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
				&& FILIAL     CLIENTE                              VENDEDOR                 PAIS                          PRODUTO                                              UM         QUANTIDADE              TOTAL     RECEBIMENTO LÕQUIDO
				&&   12       123456/12 - 12345678901234567890     12345678901234567890     1234567890123456789012345     123456789012345 - 123456789012345678901234567890     12      99,999,999.99     999,999,999.99          999,999,999.99

				@ nLin, 002 PSay QRY->FILIAL
				@ nLin, 011 PSay QRY->CLIENTE + "/" + QRY->LOJA + " - " + SubStr(SA1->A1_NREDUZ, 01, 20)
				@ nLin, 048 PSay cVendedor
				@ nLin, 073 PSay cPaisDes
				@ nLin, 103 PSay QRY->COD + " - " + Substr(SB1->B1_DESC, 01, 30)
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
					cTextoCSV += QRY->UM												+ ";"
					cTextoCSV += Transform(QRY->QUANT,		"@E 999,999,999.99")	+ ";"
					cTextoCSV += Transform(QRY->VALBRUT,	"@E 999,999,999.99")	+ ";"
					cTextoCSV += Transform(nVlrLiq,			"@E 999,999,999.99")	+ ";"
					cTextoCSV += CRLF
					fwrite(nArq, cTextoCSV)
				EndIf			                     
		Else 				&& Por Produto
			
			SB1->(dbSeek( xFilial("SB1") + QRY->COD ))
			
			&&          10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180       190       200       210       220
			&& 1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
			&& FILIAL  PRODUTO                                                               CFOP            TOTAL              ICMS                IPI      BASE PIS/COFINS               PIS             COFINS      RECEBIMENTO LÕQUIDO
			&&   12    123456789012345 - 12345678901234567890123456789012345678901234567890  1234    999,999,999.99    999,999,999.99     999,999,999.99      999,999,999.99     999,999,999.99     999,999,999.99          999,999,999.99
			
			@ nLin, 004 PSay QRY->FILIAL
			@ nLin, 009 PSay QRY->COD+" - "+Substr(SB1->B1_DESC,1,50)
			@ nLin, 079 PSay QRY->CF
			@ nLin, 087 PSay Transform(QRY->VALBRUT, "@E 999,999,999.99")
			@ nLin, 105 PSay Transform(QRY->VALICM, "@E 999,999,999.99")
			@ nLin, 124 PSay Transform(QRY->VALIPI, "@E 999,999,999.99")
			@ nLin, 144 PSay Transform(QRY->BASIMP5, "@E 999,999,999.99")
			@ nLin, 163 PSay Transform(QRY->VALIMP6, "@E 999,999,999.99")
			@ nLin, 182 PSay Transform(QRY->VALIMP5, "@E 999,999,999.99")
			@ nLin, 206 PSay Transform(nVlrLiq, "@E 999,999,999.99")
			
			If nArq > 0
				cTextoCSV := QRY->FILIAL+";"
				cTextoCSV += QRY->COD+";"
				cTextoCSV += SB1->B1_DESC+";"
				cTextoCSV += QRY->CF+";"
				cTextoCSV += Transform(QRY->VALBRUT, "@E 999,999,999.99")+";"
				cTextoCSV += Transform(QRY->VALICM, "@E 999,999,999.99")+";"
				cTextoCSV += Transform(QRY->VALIPI, "@E 999,999,999.99")+";"
				cTextoCSV += Transform(QRY->BASIMP5, "@E 999,999,999.99")+";"
				cTextoCSV += Transform(QRY->VALIMP6, "@E 999,999,999.99")+";"
				cTextoCSV += Transform(QRY->VALIMP5, "@E 999,999,999.99")+";"
				cTextoCSV += Transform(nVlrLiq, "@E 999,999,999.99")+";"
				cTextoCSV += CHR(13)+CHR(10)
				fwrite(nArq, cTextoCSV)
			Endif
			
		Endif
	Endif
	nLin++
	
	aTotais[1] += IIf(MV_PAR11 == 1, 0, QRY->QUANT)  //Alterado
	aTotais[2] += QRY->VALBRUT
	aTotais[3] += QRY->VALICM
	aTotais[4] += QRY->VALIPI
	aTotais[5] += QRY->BASIMP5
	aTotais[6] += QRY->VALIMP6
	aTotais[7] += QRY->VALIMP5
	aTotais[8] += nVlrLiq

	If Substr(QRY->CF,1,1) $ "1/2/3"
		aGeral[1] -= IIf(MV_PAR11 == 1, 0, QRY->QUANT)  //Alterado
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
	Endif
	
	QRY->(dbSkip())
	
	If !(Substr(QRY->CF,1,1) $ cCFOP)
		
		If MV_PAR11 == 1	&& SintÈtico
			@ nLin, 001 PSay Replicate("_",219)
			nLin++
			
			If cCFOP = "1/2/3"
				@ nLin, 044 PSay ">>> TOTAL DEVOLU«’ES (-)"
			ElseIf cCFOP = "5/6"
				@ nLin, 044 PSay ">>> TOTAL VENDAS (+)"
			Else
				@ nLin, 044 PSay ">>> TOTAL EXPORTA«√O (+)"
			Endif
			
			@ nLin, 086 PSay Transform(aTotais[2], "@E 999,999,999.99")
			@ nLin, 104 PSay Transform(aTotais[3], "@E 999,999,999.99")
			@ nLin, 123 PSay Transform(aTotais[4], "@E 999,999,999.99")
			@ nLin, 143 PSay Transform(aTotais[5], "@E 999,999,999.99")
			@ nLin, 162 PSay Transform(aTotais[6], "@E 999,999,999.99")
			@ nLin, 181 PSay Transform(aTotais[7], "@E 999,999,999.99")
			@ nLin, 205 PSay Transform(aTotais[8], "@E 999,999,999.99")
			nLin++
			nLin++
		Else
			If cSepara <> QRY->CF
				@ nLin, 001 PSay Replicate("_",219)
				nLin++
				
				If MV_PAR12 == 1	&& Por Cliente
					@ nLin, 010 PSay ">>> TOTAL CFOP"
					@ nLin, 084 PSay Transform(aTotais[1], "@E 999,999,999.99")
					@ nLin, 102 PSay Transform(aTotais[2], "@E 999,999,999.99")
				  /*	@ nLin, 121 PSay Transform(aTotais[3], "@E 999,999,999.99")
				   	@ nLin, 141 PSay Transform(aTotais[4], "@E 999,999,999.99")
					@ nLin, 160 PSay Transform(aTotais[5], "@E 999,999,999.99")
					@ nLin, 179 PSay Transform(aTotais[6], "@E 999,999,999.99")
					@ nLin, 203 PSay Transform(aTotais[7], "@E 999,999,999.99")    */ 
					@ nLin, 206 PSay Transform(aTotais[8], "@E 999,999,999.99")
				Else 				&& Por Produto
					@ nLin, 009 PSay ">>> TOTAL CFOP"
					@ nLin, 087 PSay Transform(aTotais[1], "@E 999,999,999.99")
					@ nLin, 105 PSay Transform(aTotais[2], "@E 999,999,999.99")
					@ nLin, 124 PSay Transform(aTotais[3], "@E 999,999,999.99")
					@ nLin, 144 PSay Transform(aTotais[4], "@E 999,999,999.99")
					@ nLin, 163 PSay Transform(aTotais[5], "@E 999,999,999.99")
					@ nLin, 182 PSay Transform(aTotais[6], "@E 999,999,999.99")
					@ nLin, 206 PSay Transform(aTotais[7], "@E 999,999,999.99") 
					@ nLin, 206 PSay Transform(aTotais[8], "@E 999,999,999.99")
				Endif
				nLin += 2
				cSepara := QRY->CF
			Endif
		Endif 
		// Inclus„o PARFATA1 - Inicio
		If cCFOP == "1/2/3"
			cTitTot := ">>> TOTAL DEVOLU«’ES (-)"
		ElseIf cCFOP == "5/6"
			cTitTot := ">>> TOTAL VENDAS (+)"
		Else
			cTitTot := ">>> TOTAL EXPORTA«√O (+)"
		EndIf 
		
		If nArq > 0
				If MV_PAR11 == 1	&& SintÈtico
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
		// FIM
		If cCFOP = "1/2/3"
			cCFOP := "5/6"
		ElseIf cCFOP = "5/6"
			cCFOP := "7"
		Endif
		
		aTotais[1] := 0
		aTotais[2] := 0
		aTotais[3] := 0
		aTotais[4] := 0
		aTotais[5] := 0
		aTotais[6] := 0
		aTotais[7] := 0
		aTotais[8] := 0	
	Endif
Enddo
QRY->(dbCloseArea())

If MV_PAR11 == 1	&& SintÈtico
	nLin++
	@ nLin, 044 PSay ">>> RECEITA LIQUIDA"  
	//@ nLin, 095 PSay Transform(aGeral[1], "@E 999,999,999.99")
	@ nLin, 086 PSay Transform(aGeral[2], "@E 999,999,999.99")
	@ nLin, 104 PSay Transform(aGeral[3], "@E 999,999,999.99")
	@ nLin, 123 PSay Transform(aGeral[4], "@E 999,999,999.99")
	@ nLin, 143 PSay Transform(aGeral[5], "@E 999,999,999.99")
	@ nLin, 162 PSay Transform(aGeral[6], "@E 999,999,999.99")
	@ nLin, 181 PSay Transform(aGeral[7], "@E 999,999,999.99")
	@ nLin, 205 PSay Transform(aGeral[8], "@E 999,999,999.99")
	nLin++
	nLin++
Else
	If MV_PAR12 == 1	&& Por Cliente
		@ nLin, 010 PSay ">>> RECEITA LIQUIDA"
		@ nLin, 084 PSay Transform(aGeral[1], "@E 999,999,999.99")
		@ nLin, 102 PSay Transform(aGeral[2], "@E 999,999,999.99")
		/*@ nLin, 121 PSay Transform(aGeral[3], "@E 999,999,999.99")
		@ nLin, 141 PSay Transform(aGeral[4], "@E 999,999,999.99")
		@ nLin, 160 PSay Transform(aGeral[5], "@E 999,999,999.99")
		@ nLin, 179 PSay Transform(aGeral[6], "@E 999,999,999.99")
		@ nLin, 203 PSay Transform(aGeral[7], "@E 999,999,999.99")*/
		@ nLin, 206 PSay Transform(aGeral[8], "@E 999,999,999.99")		
	Else 				&& Por Produto
		@ nLin, 009 PSay ">>> RECEITA LIQUIDA"
		@ nLin, 087 PSay Transform(aGeral[1], "@E 999,999,999.99")
		@ nLin, 105 PSay Transform(aGeral[2], "@E 999,999,999.99")
		@ nLin, 124 PSay Transform(aGeral[3], "@E 999,999,999.99")
		@ nLin, 144 PSay Transform(aGeral[4], "@E 999,999,999.99")
		@ nLin, 163 PSay Transform(aGeral[5], "@E 999,999,999.99")
		@ nLin, 182 PSay Transform(aGeral[6], "@E 999,999,999.99")
		@ nLin, 206 PSay Transform(aGeral[7], "@E 999,999,999.99")
	Endif
	nLin++
	nLin++
Endif



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
Endif

TcQuery cQuery Alias "QRY" New

QRY->(dbGoTop())
nFina := QRY->E1_VLCRUZ
QRY->(dbCloseArea())

If nLin > 55
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 8
Endif

//aGeral[1] += nFina
//aGeral[7] += nFina
aGeral[2] += nFina
aGeral[8] += nFina

If MV_PAR11 == 1	&& SintÈtico
	&&          10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180       190       200       210       220
	&& 1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	&&    FILIAL                                  CFOP                                              TOTAL              ICMS                IPI      BASE PIS/COFINS               PIS             COFINS      RECEBIMENTO LÕQUIDO
	&&    12 - 123456789012345678901234567890     1234 - 123456789012345678901234567890     999,999,999.99    999,999,999.99     999,999,999.99      999,999,999.99     999,999,999.99     999,999,999.99          999,999,999.99
	
   /*	@ nLin, 004 PSay SM0->M0_CODFIL+" - "+Substr(SM0->M0_FILIAL,1,30)
	@ nLin, 044 PSay "Back To Back"
	@ nLin, 086 PSay Transform(nFina, "@E 999,999,999.99")
	@ nLin, 104 PSay Transform(0, "@E 999,999,999.99")
	@ nLin, 123 PSay Transform(0, "@E 999,999,999.99")
	@ nLin, 143 PSay Transform(0, "@E 999,999,999.99")
	@ nLin, 162 PSay Transform(0, "@E 999,999,999.99")
	@ nLin, 181 PSay Transform(0, "@E 999,999,999.99")
	@ nLin, 205 PSay Transform(nFina, "@E 999,999,999.99")
	
	If nArq > 0
		cTextoCSV := SM0->M0_CODFIL+";"
		cTextoCSV += SM0->M0_FILIAL+";"
		cTextoCSV += ";"
		cTextoCSV += "Back To Back;"
		cTextoCSV += Transform(nFina, "@E 999,999,999.99")+";"
		cTextoCSV += Transform(0, "@E 999,999,999.99")+";"
		cTextoCSV += Transform(0, "@E 999,999,999.99")+";"
		cTextoCSV += Transform(0, "@E 999,999,999.99")+";"
		cTextoCSV += Transform(0, "@E 999,999,999.99")+";"
		cTextoCSV += Transform(0, "@E 999,999,999.99")+";"
		cTextoCSV += Transform(nFina, "@E 999,999,999.99")+";"
		cTextoCSV += CHR(13)+CHR(10)
		fwrite(nArq, cTextoCSV)
	Endif               */      
	          
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
		
		
		&&          10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180       190       200       210       220
		&& 1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
		&&  FILIAL  CLIENTE                                                          CFOP             TOTAL              ICMS                IPI      BASE PIS/COFINS               PIS             COFINS      RECEBIMENTO LÕQUIDO
		&&    12    123456/12 - 12345678901234567890123456789012345678901234567890   1234     999,999,999.99    999,999,999.99     999,999,999.99      999,999,999.99     999,999,999.99     999,999,999.99          999,999,999.99
		/*
		@ nLin, 010 PSay "Back To Back"
		@ nLin, 084 PSay Transform(nFina, "@E 999,999,999.99")
		@ nLin, 102 PSay Transform(0, "@E 999,999,999.99")
		@ nLin, 121 PSay Transform(0, "@E 999,999,999.99")
		@ nLin, 141 PSay Transform(0, "@E 999,999,999.99")
		@ nLin, 160 PSay Transform(0, "@E 999,999,999.99")
		@ nLin, 179 PSay Transform(0, "@E 999,999,999.99")
		@ nLin, 203 PSay Transform(nFina, "@E 999,999,999.99")
		
		If nArq > 0
			cTextoCSV := ";"
			cTextoCSV += ";"
			cTextoCSV += "Back To Back"+";"
			cTextoCSV += ";"
			cTextoCSV += Transform(nFina, "@E 999,999,999.99")+";"
			cTextoCSV += Transform(0	, "@E 999,999,999.99")+";"
			cTextoCSV += Transform(0	, "@E 999,999,999.99")+";"
			cTextoCSV += Transform(0	, "@E 999,999,999.99")+";"
			cTextoCSV += Transform(0	, "@E 999,999,999.99")+";"
			cTextoCSV += Transform(0	, "@E 999,999,999.99")+";"
			cTextoCSV += Transform(nFina, "@E 999,999,999.99")+";"
			cTextoCSV += CHR(13)+CHR(10)
			fwrite(nArq, cTextoCSV)
		Endif
		 */
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
			cTextoCSV += "Back To Back"								+ ";"
			cTextoCSV += ""											+ ";"
			cTextoCSV += Transform(0,		"@E 999,999,999.99")	+ ";"
			cTextoCSV += Transform(nFina,	"@E 999,999,999.99")	+ ";"
			cTextoCSV += Transform(nFina,	"@E 999,999,999.99")	+ ";"
			cTextoCSV += CRLF
			fwrite(nArq, cTextoCSV)
		EndIf		 
	Else 				&& Por Produto
		
		
		&&          10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180       190       200       210       220
		&& 1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
		&& FILIAL  PRODUTO                                                               CFOP            TOTAL              ICMS                IPI      BASE PIS/COFINS               PIS             COFINS      RECEBIMENTO LÕQUIDO
		&&   12    123456789012345 - 12345678901234567890123456789012345678901234567890  1234    999,999,999.99    999,999,999.99     999,999,999.99      999,999,999.99     999,999,999.99     999,999,999.99          999,999,999.99
		/*
		@ nLin, 009 PSay "Back To Back"
		@ nLin, 087 PSay Transform(nFina, "@E 999,999,999.99")
		@ nLin, 105 PSay Transform(0, "@E 999,999,999.99")
		@ nLin, 124 PSay Transform(0, "@E 999,999,999.99")
		@ nLin, 144 PSay Transform(0, "@E 999,999,999.99")
		@ nLin, 163 PSay Transform(0, "@E 999,999,999.99")
		@ nLin, 182 PSay Transform(0, "@E 999,999,999.99")
		@ nLin, 206 PSay Transform(nFina, "@E 999,999,999.99")
		
		If nArq > 0
			cTextoCSV := ";"
			cTextoCSV += ";"
			cTextoCSV += "Back To Back"+";"
			cTextoCSV += ";"
			cTextoCSV += Transform(nFina, "@E 999,999,999.99")+";"
			cTextoCSV += Transform(0, "@E 999,999,999.99")+";"
			cTextoCSV += Transform(0, "@E 999,999,999.99")+";"
			cTextoCSV += Transform(0, "@E 999,999,999.99")+";"
			cTextoCSV += Transform(0, "@E 999,999,999.99")+";"
			cTextoCSV += Transform(0, "@E 999,999,999.99")+";"
			cTextoCSV += Transform(nFina, "@E 999,999,999.99")+";"
			cTextoCSV += CHR(13)+CHR(10)
			fwrite(nArq, cTextoCSV)
		Endif */
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
	Endif
Endif
nLin++

If MV_PAR11 == 1	&& SintÈtico
	@ nLin, 001 PSay Replicate("=",219)
	nLin++
	@ nLin, 044 PSay ">>> TOTAL LIQUIDO"
	@ nLin, 086 PSay Transform(aGeral[1], "@E 999,999,999.99")
	@ nLin, 104 PSay Transform(aGeral[2], "@E 999,999,999.99")
	@ nLin, 123 PSay Transform(aGeral[3], "@E 999,999,999.99")
	@ nLin, 143 PSay Transform(aGeral[4], "@E 999,999,999.99")
	@ nLin, 162 PSay Transform(aGeral[5], "@E 999,999,999.99")
	@ nLin, 181 PSay Transform(aGeral[6], "@E 999,999,999.99")
	@ nLin, 205 PSay Transform(aGeral[7], "@E 999,999,999.99")
	nLin++
	nLin++
	
	If nArq > 0
		cTextoCSV := ";"
		cTextoCSV += ";"
		cTextoCSV += ";"
		cTextoCSV += ">>> TOTAL LIQUIDO;"
		cTextoCSV += Transform(aGeral[1], "@E 999,999,999.99")+";"
		cTextoCSV += Transform(aGeral[2], "@E 999,999,999.99")+";"
		cTextoCSV += Transform(aGeral[3], "@E 999,999,999.99")+";"
		cTextoCSV += Transform(aGeral[4], "@E 999,999,999.99")+";"
		cTextoCSV += Transform(aGeral[5], "@E 999,999,999.99")+";"
		cTextoCSV += Transform(aGeral[6], "@E 999,999,999.99")+";"
		cTextoCSV += Transform(aGeral[7], "@E 999,999,999.99")+";"
		cTextoCSV += CHR(13)+CHR(10)
		fwrite(nArq, cTextoCSV)
	Endif
	
Else
	If MV_PAR12 == 1	&& Por Cliente
		@ nLin, 010 PSay ">>> TOTAL LIQUIDO"
		@ nLin, 084 PSay Transform(aGeral[1], "@E 999,999,999.99")
		@ nLin, 102 PSay Transform(aGeral[2], "@E 999,999,999.99")
		@ nLin, 121 PSay Transform(aGeral[3], "@E 999,999,999.99")
		@ nLin, 141 PSay Transform(aGeral[4], "@E 999,999,999.99")
		@ nLin, 160 PSay Transform(aGeral[5], "@E 999,999,999.99")
		@ nLin, 179 PSay Transform(aGeral[6], "@E 999,999,999.99")
		@ nLin, 203 PSay Transform(aGeral[7], "@E 999,999,999.99")
	Else 				&& Por Produto
		@ nLin, 009 PSay ">>> TOTAL LIQUIDO"
		@ nLin, 087 PSay Transform(aGeral[1], "@E 999,999,999.99")
		@ nLin, 105 PSay Transform(aGeral[2], "@E 999,999,999.99")
		@ nLin, 124 PSay Transform(aGeral[3], "@E 999,999,999.99")
		@ nLin, 144 PSay Transform(aGeral[4], "@E 999,999,999.99")
		@ nLin, 163 PSay Transform(aGeral[5], "@E 999,999,999.99")
		@ nLin, 182 PSay Transform(aGeral[6], "@E 999,999,999.99")
		@ nLin, 206 PSay Transform(aGeral[7], "@E 999,999,999.99")
	Endif
	nLin++
	nLin++
	
	If nArq > 0
		cTextoCSV := ";"
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
		cTextoCSV += CHR(13)+CHR(10)
		fwrite(nArq, cTextoCSV)
	Endif
Endif           

Set Device To Screen

If aReturn[5]==1
	dbCommitAll()
	Set Printer To
	OurSpool(wnrel)
Endif

MS_FLUSH()

If nArq > 0
	fClose(nArq)
	fExpExcel( cArquivo, Alltrim(cPasta) )
Endif

Return Nil


&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
Static Function fExpExcel(cArquivo, cPasta)

Local oExcelApp

CpyS2T( cArquivo, cPasta, .T. )
If 	!ApOleClient( 'MsExcel' )
	MsgStop( 'MsExcel nao instalado' )
Else
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open( cPasta + cArquivo ) // Abre uma planilha
	oExcelApp:SetVisible(.T.)
EndIf

Return Nil



/*/
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±⁄ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø±±
±±≥Funcao    ≥AjustaSX1 ≥ Autor ≥Marcelo Alexandre      ≥ Data ≥25/06/2007≥±±
±±√ƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥±±
±±≥DescriáÖo ≥Acerta o arquivo de perguntas                               ≥±±
±±¿ƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
/*/
/*Static Function AjustaSx1(cPerg)

Local aHelpP	:= {}
Local aHelpE	:= {}
Local aHelpS	:= {}

PutSx1(cPerg,"01", "Da Filial ?           	", "", "", "mv_ch1", "C", 02, 0, 0, "G", "", "SM0", "", "", "MV_PAR01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", aHelpP,aHelpE,aHelpS)
PutSx1(cPerg,"02", "AtÈ Filial ?	       	", "", "", "mv_ch2", "C", 02, 0, 0, "G", "", "SM0", "", "", "MV_PAR02", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", aHelpP,aHelpE,aHelpS)
PutSx1(cPerg,"03", "Do Cliente ?		", "", "", "mv_ch3", "C", 06, 0, 0, "G", "", "CLI", "", "", "MV_PAR03", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", aHelpP,aHelpE,aHelpS)
PutSx1(cPerg,"04", "AtÈ Cliente ?    		", "", "", "mv_ch4", "C", 06, 0, 0, "G", "", "CLI", "", "", "MV_PAR04", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", aHelpP,aHelpE,aHelpS)
PutSx1(cPerg,"05", "Da Loja ?			", "", "", "mv_ch5", "C", 02, 0, 0, "G", "", "   ", "", "", "MV_PAR05", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", aHelpP,aHelpE,aHelpS)
PutSx1(cPerg,"06", "AtÈ Loja ? 		   	", "", "", "mv_ch6", "C", 02, 0, 0, "G", "", "   ", "", "", "MV_PAR06", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", aHelpP,aHelpE,aHelpS)
PutSx1(cPerg,"07", "Da Data de Emissao ?	", "", "", "mv_ch7", "D", 08, 0, 0, "G", "", ""   , "", "", "MV_PAR07", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", aHelpP,aHelpE,aHelpS)
PutSx1(cPerg,"08", "AtÈ Data de Emissao ?	", "", "", "mv_ch8", "D", 08, 0, 0, "G", "", ""   , "", "", "MV_PAR08", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", aHelpP,aHelpE,aHelpS)
PutSx1(cPerg,"09", "Do Produto ?         	", "", "", "mv_ch9", "C", 15, 0, 0, "G", "", "SB1", "", "", "MV_PAR09", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", aHelpP,aHelpE,aHelpS)
PutSx1(cPerg,"10", "AtÈ Produto ?		", "", "", "mv_chA", "C", 15, 0, 0, "G", "", "SB1", "", "", "MV_PAR10", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", aHelpP,aHelpE,aHelpS)
PutSx1(cPerg,"11", "Modelo ?           		", "", "", "mv_chB", "N", 01, 0, 1, "C", "", ""   , "", "", "MV_PAR11", "SintÈtico", "SintÈtico", "SintÈtico", "", "AnalÌtico", "AnalÌtico", "AnalÌtico", "", "", "", "", "", "", "", "", "", aHelpP,aHelpE,aHelpS)
PutSx1(cPerg,"12", "Modelo Analitico ?   	", "", "", "mv_chC", "N", 01, 0, 1, "C", "", ""   , "", "", "MV_PAR12", "Por Cliente", "Por Cliente", "Por Cliente", "", "Por Produto", "Por Produto", "Por Produto", "", "", "", "", "", "", "", "", "", aHelpP,aHelpE,aHelpS)
PutSx1(cPerg,"13", "Exporta Excel ?   		", "", "", "mv_chD", "N", 01, 0, 1, "C", "", ""   , "", "", "MV_PAR13", "Sim", "Sim", "Sim", "", "N„o", "N„o", "N„o", "", "", "", "", "", "", "", "", "", aHelpP,aHelpE,aHelpS)

Return Nil

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
			//sd2->d2_zdeson := sd2->d2_BASIMP5 * 0.025  //(sd2->d2_valbrut - ( sd2->d2_valicm + sd2->d2_valipi + sd2->d2_valimp5 + sd2->d2_valimp6)) * 0.01	
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
		if sb5->b5_inspat == "1" .and. !empty(sb5->b5_codativ)  .and. nPerDeso > 0
			sd1->(RecLock("SD1",.f.))
			//sd1->d1_zdeson := sd1->d1_BASIMP5 * 0.025  //(sd1->d1_total - ( sd1->d1_valicm + sd1->d1_valimp5 + sd1->d1_valimp6)) * 0.01	
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
	