#Include "Protheus.ch"
#Include "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ PARFATA2  บ Autor ณ Cassandra J. Silva บ Data ณ 27/06/2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Faturamento - Previsto x Realizado.                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especํfico PARAFIX                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function PARFATA2()	&& PAR - PARAFIX / FAT - Faturamento / A - Atualiza็ใo / 1 - Sequencial

Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := ""
Local cPict         := ""
Local titulo       	:= "Faturamento - Previsto x Realizado"
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
Private nomeprog    := "PARFATA2"
Private nTipo       := 15
Private aReturn     := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey    := 0
Private cPerg       := "FATA2"
Private cbtxt      	:= Space(10)
Private cbcont     	:= 00
Private CONTFL     	:= 01
Private m_pag      	:= 01
Private wnrel      	:= "PARFATA2"
Private cString 	:= ""
Private cArquivo	:= ""
Private nArq    	:= 0

//AjustaSx1(cPerg)
If !Pergunte(cPerg,.T.)
	Return Nil
Endif

If MV_PAR09 == 1
	cPasta := cGetFile('Arquivos (*.csv) | *.csv', 'Selecione o diret๓rio - EXCEL', 1, , .T., GETF_LOCALHARD + GETF_NETWORKDRIVE + GETF_RETDIRECTORY, .T.)
	If !Empty(cPasta)
		cArquivo := "Fat_PrevxReal.csv"
		nArq     := fCreate(Alltrim(cPasta) +"\"+ cArquivo, 0)
		If nArq > 0
			cTextoCSV := "FILIAL;"
			cTextoCSV += "CLIENTE;"
			cTextoCSV += "LOJA;"
			cTextoCSV += "NOME;"
			cTextoCSV += "VENDEDOR;"
			cTextoCSV += "PRODUTO;"
			cTextoCSV += "DESCRIวรO;"
			cTextoCSV += "UM;"
			cTextoCSV += "SEGMENTO;"
			cTextoCSV += "JAN_PREVISTO;"
			cTextoCSV += "JAN_REALIZADO;"
			cTextoCSV += "FEV_PREVISTO;"
			cTextoCSV += "FEV_REALIZADO;"
			cTextoCSV += "MAR_PREVISTO;"
			cTextoCSV += "MAR_REALIZADO;"
			cTextoCSV += "ABR_PREVISTO;"
			cTextoCSV += "ABR_REALIZADO;"
			cTextoCSV += "MAI_PREVISTO;"
			cTextoCSV += "MAI_REALIZADO;"
			cTextoCSV += "JUN_PREVISTO;"
			cTextoCSV += "JUN_REALIZADO;"
			cTextoCSV += "JUL_PREVISTO;"
			cTextoCSV += "JUL_REALIZADO;"
			cTextoCSV += "AGO_PREVISTO;"
			cTextoCSV += "AGO_REALIZADO;"
			cTextoCSV += "SET_PREVISTO;"
			cTextoCSV += "SET_REALIZADO;"
			cTextoCSV += "OUT_PREVISTO;"
			cTextoCSV += "OUT_REALIZADO;"
			cTextoCSV += "NOV_PREVISTO;"
			cTextoCSV += "NOV_REALIZADO;"
			cTextoCSV += "DEZ_PREVISTO;"
			cTextoCSV += "DEZ_REALIZADO;"
			cTextoCSV += CHR(13)+CHR(10)
			fwrite(nArq, cTextoCSV)
		Endif
	Endif
Endif

Cabec1 := "CLIENTE                                    VENDEDOR                         PRODUTO                                                     UM  SEGMENTO         MES                    PREVISTO         REALIZADO"
wnrel  := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

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
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local cQuery  := ""
Local aDados  := {}

&&&&&&&&&&&&&&&& SELEวรO DADOS PREVISTO:
cQuery := " SELECT"
cQuery +=		" SC5.C5_VEND1, SC6.C6_CLI, SC6.C6_LOJA, SC6.C6_PRODUTO, SUBSTRING(SC5.C5_EMISSAO,5,2) AS MES, SUM(SC6.C6_VALOR) AS TOTAL"
cQuery += " FROM "+RetSqlName("SC5")+" SC5"
cQuery +=		" INNER JOIN "+RetSqlName("SC6")+" SC6 ON"
cQuery +=			" SC6.C6_FILIAL = SC5.C5_FILIAL AND"
cQuery +=			" SC6.C6_NUM = SC5.C5_NUM AND"
cQuery +=			" SC6.C6_CLI = SC5.C5_CLIENTE AND"
cQuery +=			" SC6.C6_LOJA = SC5.C5_LOJACLI AND"
cQuery +=			" SC6.C6_QTDENT = 0 AND"
cQuery +=			" SC6.C6_PRODUTO BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' AND"
cQuery +=			" SC6.D_E_L_E_T_ = ' '"
cQuery += " WHERE"
cQuery +=		" SC5.C5_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND"
cQuery +=		" SC5.C5_CLIENTE BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND"
cQuery +=		" SC5.C5_LOJACLI BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' AND"
cQuery +=		" SUBSTRING(SC5.C5_EMISSAO,1,4) = '"+Alltrim(Str(MV_PAR10))+"' AND"
cQuery +=		" SC5.C5_ZZPRNM = 'P' AND"
cQuery +=		" SC5.D_E_L_E_T_ = ' '"
cQuery += " GROUP BY SC5.C5_VEND1, SC6.C6_CLI, SC6.C6_LOJA, SC6.C6_PRODUTO, SUBSTRING(SC5.C5_EMISSAO,5,2)"
cQuery += " ORDER BY SC5.C5_VEND1, SC6.C6_CLI, SC6.C6_LOJA, SC6.C6_PRODUTO, SUBSTRING(SC5.C5_EMISSAO,5,2)"

If Select("QRY") <> 0
	QRY->(dbCloseArea())
Endif

TcQuery cQuery Alias "QRY" New

QRY->(dbGoTop())
Do While QRY->(!Eof())
	aAdd(aDados, { 	QRY->C5_VEND1,;
					QRY->C6_CLI,;
					QRY->C6_LOJA,;
					QRY->C6_PRODUTO,;
					QRY->MES,;
					QRY->TOTAL,; 	&& PREVISTO
					0})				&& REALIZADO
	QRY->(dbSkip())
Enddo
QRY->(dbCloseArea())


&&&&&&&&&&&&&&&& SELEวรO DADOS REALIZADO:                                          
cQuery := " SELECT"
cQuery +=		" SC5.C5_VEND1, SC6.C6_CLI, SC6.C6_LOJA, SC6.C6_PRODUTO, SUBSTRING(SD2.D2_EMISSAO,5,2) AS MES, SUM(SD2.D2_VALBRUT) AS TOTAL,"
cQuery +=		" SUM(SD2.D2_VALICM) VALICM, SUM(SD2.D2_VALIPI) VALIPI, SUM(SD2.D2_VALIMP5) VALIMP5, SUM(SD2.D2_VALIMP6) VALIMP6"
cQuery += " FROM "+RetSqlName("SC5")+" SC5"
cQuery +=		" INNER JOIN "+RetSqlName("SC6")+" SC6 ON"
cQuery +=			" SC6.C6_FILIAL = SC5.C5_FILIAL AND"
cQuery +=			" SC6.C6_NUM = SC5.C5_NUM AND"
cQuery +=			" SC6.C6_CLI = SC5.C5_CLIENTE AND"
cQuery +=			" SC6.C6_LOJA = SC5.C5_LOJACLI AND"
cQuery +=			" SC6.C6_PRODUTO BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' AND"
cQuery +=			" SC6.D_E_L_E_T_ = ' '"
cQuery +=		" INNER JOIN "+RetSqlName("SD2")+" SD2 ON"
cQuery +=			" SD2.D2_FILIAL = SC6.C6_FILIAL AND"
cQuery +=			" SD2.D2_PEDIDO = SC6.C6_NUM AND"
cQuery +=			" SD2.D2_ITEMPV = SC6.C6_ITEM AND"
cQuery +=			" SD2.D2_CLIENTE = SC6.C6_CLI AND"
cQuery +=			" SD2.D2_LOJA = SC6.C6_LOJA AND"                          
cQuery +=			" SUBSTRING(SD2.D2_EMISSAO,1,4) = '"+Alltrim(Str(MV_PAR10))+"' AND"
cQuery +=			" SD2.D2_COD BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' AND"
cQuery +=			" SD2.D_E_L_E_T_ = ' '"
cQuery += " WHERE"
cQuery +=		" SC5.C5_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND"
cQuery +=		" SC5.C5_CLIENTE BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND"
cQuery +=		" SC5.C5_LOJACLI BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' AND"
cQuery +=		" SC5.D_E_L_E_T_ = ' '"
cQuery += " GROUP BY SC5.C5_VEND1, SC6.C6_CLI, SC6.C6_LOJA, SC6.C6_PRODUTO, SUBSTRING(SD2.D2_EMISSAO,5,2)"

If Select("QRY") <> 0
	QRY->(dbCloseArea())
Endif

TcQuery cQuery Alias "QRY" New

QRY->(dbGoTop())
Do While QRY->(!Eof())
	
	nPos := 0
	nPos := Ascan(aDados, { |x| x[1] == QRY->C5_VEND1 .and. x[2] == QRY->C6_CLI .and. x[3] == QRY->C6_LOJA .and. x[4] == QRY->C6_PRODUTO .and. x[5] == QRY->MES })
	
	If nPos == 0
		aAdd(aDados, { 	QRY->C5_VEND1,;
						QRY->C6_CLI,;
						QRY->C6_LOJA,;
						QRY->C6_PRODUTO,;
						QRY->MES,;
						0,; 			&& PREVISTO
						QRY->TOTAL - QRY->VALICM - QRY->VALIPI - QRY->VALIMP5 - QRY->VALIMP6})	&& REALIZADO
	Else
		aDados[nPos,07] += QRY->TOTAL - QRY->VALICM - QRY->VALIPI - QRY->VALIMP5 - QRY->VALIMP6
	Endif
	QRY->(dbSkip())
Enddo
QRY->(dbCloseArea())

SA1->(dbSetOrder(1))
SA3->(dbSetOrder(1))
SB1->(dbSetOrder(1))

SetRegua(Len(aDados))

For nPos:=1 to Len(aDados)
	
	If lAbortPrint
		@nLin,00 PSay "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	If nLin > 55
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	
	SA1->(dbSeek( xFilial("SA1") + aDados[nPos,02] + aDados[nPos,03] ))
	SA3->(dbSeek( xFilial("SA3") + aDados[nPos,01] ))
	SB1->(dbSeek( xFilial("SB1") + aDados[nPos,04] ))
	
	&&          10        20        30        40        50        60        70        80        90        100       110       120       130       140       150       160       170       180       190       200       210       220
	&& 1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	&& CLIENTE                                    VENDEDOR                         PRODUTO                                                     UM  SEGMENTO         MES                    PREVISTO         REALIZADO
	&& 1234567890123456789012345678901234567890   123456789012345678901234567890   123456789012345 - 1234567890123456789012345678901234567890  12  123456789012345  123456789012345    999,999,999.99   999,999,999.99
	
	@ nLin, 001 PSay Substr(SA1->A1_NOME,1,40)
	@ nLin, 044 PSay Substr(SA3->A3_NOME,1,30)
	@ nLin, 077 PSay SC6->C6_PRODUTO +" - "+ Substr(SB1->B1_DESC,1,40)
	@ nLin, 137 PSay SC6->C6_UM
	@ nLin, 141 PSay SB1->B1_ZZSETOR
	@ nLin, 158 PSay aDados[nPos,05]
	@ nLin, 177 PSay Transform(aDados[nPos,06],"@E 999,999,999.99")
	@ nLin, 194 PSay Transform(aDados[nPos,07],"@E 999,999,999.99")
	nLin++
	
	If nArq > 0
		cTextoCSV := SM0->M0_CODFIL+" - "+Substr(SM0->M0_FILIAL,1,30)+";"
		cTextoCSV += SA1->A1_COD+";"
		cTextoCSV += SA1->A1_LOJA+";"
		cTextoCSV += SA1->A1_NOME+";"
		cTextoCSV += SA3->A3_NOME+";"
		cTextoCSV += SB1->B1_COD+";"
		cTextoCSV += SB1->B1_DESC+";"
		cTextoCSV += SB1->B1_UM+";"
		cTextoCSV += SB1->B1_ZZSETOR+";"
		
		If aDados[nPos,05] == "01"
			cTextoCSV += Transform(aDados[nPos,06],"@E 999,999,999.99")+";"
			cTextoCSV += Transform(aDados[nPos,07],"@E 999,999,999.99")+";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			
		ElseIf aDados[nPos,05] == "02"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += Transform(aDados[nPos,06],"@E 999,999,999.99")+";"
			cTextoCSV += Transform(aDados[nPos,07],"@E 999,999,999.99")+";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"			
			
		ElseIf aDados[nPos,05] == "03"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += Transform(aDados[nPos,06],"@E 999,999,999.99")+";"
			cTextoCSV += Transform(aDados[nPos,07],"@E 999,999,999.99")+";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"			
			
		ElseIf aDados[nPos,05] == "04"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += Transform(aDados[nPos,06],"@E 999,999,999.99")+";"
			cTextoCSV += Transform(aDados[nPos,07],"@E 999,999,999.99")+";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"			
		
		ElseIf aDados[nPos,05] == "05"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += Transform(aDados[nPos,06],"@E 999,999,999.99")+";"
			cTextoCSV += Transform(aDados[nPos,07],"@E 999,999,999.99")+";"			
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"			
					
		ElseIf aDados[nPos,05] == "06"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += Transform(aDados[nPos,06],"@E 999,999,999.99")+";"
			cTextoCSV += Transform(aDados[nPos,07],"@E 999,999,999.99")+";"			
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"			
		
		ElseIf aDados[nPos,05] == "07"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += Transform(aDados[nPos,06],"@E 999,999,999.99")+";"
			cTextoCSV += Transform(aDados[nPos,07],"@E 999,999,999.99")+";"			
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"			
		
		ElseIf aDados[nPos,05] == "08"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"			
			cTextoCSV += Transform(aDados[nPos,06],"@E 999,999,999.99")+";"
			cTextoCSV += Transform(aDados[nPos,07],"@E 999,999,999.99")+";"			
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"					
			
		ElseIf aDados[nPos,05] == "09"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += Transform(aDados[nPos,06],"@E 999,999,999.99")+";"
			cTextoCSV += Transform(aDados[nPos,07],"@E 999,999,999.99")+";"			
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"					
		
		ElseIf aDados[nPos,05] == "10"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += Transform(aDados[nPos,06],"@E 999,999,999.99")+";"
			cTextoCSV += Transform(aDados[nPos,07],"@E 999,999,999.99")+";"			
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"							
			
		ElseIf aDados[nPos,05] == "11"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"			
			cTextoCSV += Transform(aDados[nPos,06],"@E 999,999,999.99")+";"
			cTextoCSV += Transform(aDados[nPos,07],"@E 999,999,999.99")+";"			
			cTextoCSV += ";"
			cTextoCSV += ";"									
			
		ElseIf aDados[nPos,05] == "12"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"
			cTextoCSV += ";"			
			cTextoCSV += ";"
			cTextoCSV += ";"									
			cTextoCSV += Transform(aDados[nPos,06],"@E 999,999,999.99")+";"
			cTextoCSV += Transform(aDados[nPos,07],"@E 999,999,999.99")+";"			
			
		Endif
		cTextoCSV += CHR(13)+CHR(10)
		fwrite(nArq, cTextoCSV)
	Endif
	
	
Next

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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuncao    ณAjustaSX1 ณ Autor ณMarcelo Alexandre      ณ Data ณ25/06/2007ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescri…o ณAcerta o arquivo de perguntas                               ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
/*Static Function AjustaSx1(cPerg)

Local aHelpP	:= {}
Local aHelpE	:= {}
Local aHelpS	:= {}

PutSx1(cPerg,"01", "Da Filial ?           	", "", "", "mv_ch1", "C", 02, 0, 0, "G", "", "SM0", "", "", "MV_PAR01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", aHelpP,aHelpE,aHelpS)
PutSx1(cPerg,"02", "At้ Filial ?	       	", "", "", "mv_ch2", "C", 02, 0, 0, "G", "", "SM0", "", "", "MV_PAR02", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", aHelpP,aHelpE,aHelpS)
PutSx1(cPerg,"03", "Do Cliente ?			", "", "", "mv_ch3", "C", 06, 0, 0, "G", "", "CLI", "", "", "MV_PAR03", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", aHelpP,aHelpE,aHelpS)
PutSx1(cPerg,"04", "At้ Cliente ?    		", "", "", "mv_ch4", "C", 06, 0, 0, "G", "", "CLI", "", "", "MV_PAR04", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", aHelpP,aHelpE,aHelpS)
PutSx1(cPerg,"05", "Da Loja ?				", "", "", "mv_ch5", "C", 02, 0, 0, "G", "", "   ", "", "", "MV_PAR05", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", aHelpP,aHelpE,aHelpS)
PutSx1(cPerg,"06", "At้ Loja ? 		   		", "", "", "mv_ch6", "C", 02, 0, 0, "G", "", "   ", "", "", "MV_PAR06", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", aHelpP,aHelpE,aHelpS)
PutSx1(cPerg,"07", "Do Produto ?         	", "", "", "mv_ch7", "C", 15, 0, 0, "G", "", "SB1", "", "", "MV_PAR07", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", aHelpP,aHelpE,aHelpS)
PutSx1(cPerg,"08", "At้ Produto ?		    ", "", "", "mv_ch8", "C", 15, 0, 0, "G", "", "SB1", "", "", "MV_PAR08", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", aHelpP,aHelpE,aHelpS)
PutSx1(cPerg,"09", "Exporta Excel ?   		", "", "", "mv_ch9", "N", 01, 0, 1, "C", "", ""   , "", "", "MV_PAR09", "Sim", "Sim", "Sim", "", "Nใo", "Nใo", "Nใo", "", "", "", "", "", "", "", "", "", aHelpP,aHelpE,aHelpS)
PutSx1(cPerg,"10", "Ano ?		    		", "", "", "mv_chA", "N", 04, 0, 0, "G", "", "   ", "", "", "MV_PAR10", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", aHelpP,aHelpE,aHelpS)

Return Nil
*/