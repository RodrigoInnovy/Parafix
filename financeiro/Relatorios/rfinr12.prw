#include "rwmake.ch"

#DEFINE SEEK_CTB		"1"
#DEFINE SEEK_FIN		"2"
#DEFINE SEEK_DIF		"3"

#DEFINE STATUS_TOTAL	"TOTAL:"

/*/
ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿
³Fun‡…o    ³ RFINR12 ³ Autor ³ Ricardo Yamashiro   ³ Data ³ 31.05.19 ³
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´
³Descri‡…o ³ Relatório Saldo Títulos Pagar/Receber
ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ Uso	   ³ SIGAFIN						³
ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ Solicitante:	Elisa Baptistella | Chamado: #5923 	³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ Revisoes:								³
ÃÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
18.06.19 | #5923 | Elisa Baptistella | alterações diversas solicitadas em 17.06 (ver chamado)
09.07.19 | #5923 | Elisa Baptistella | filtro por tipos: imprimir e não imprimir
10.07.19 | #5923 | Elisa Baptistella | alteração de saldos p/ status p/ saldo atual, alteração divisão 09 em 09A-Latam e 09B-InterCompany
11.07.19 | #5923 | Elisa Baptistella | inclusão coluna prazo e revisão de status
19.08.19 | #5923 | Elisa Baptistella | aumentar campo invoice
17.10.19 | #6787 | Elisa Baptistella | inclusão moeda libra
07.10.19 ³ R25   ³ protheus001   ³ substituição criatrab() por FWTemporaryTable()
ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
/*/
User Function RFINR12()

	Local oReport

	private cTipos			:= ""
	private cNotTipos		:= ""
	private nCotacaoUSD		:= 0 //vinicius
	private nCotacaoEUR		:= 0 //vinicius

	//If FindFunction("TRepInUse") .And. TRepInUse()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Interface de impressao                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport := ReportDef()
	oReport:PrintDialog()
	//Else
	//	RPCPR18R3()
	//EndIf

Return

static function fPerg()

	Local aParamBox 		:= {}
	local aCliFor			:= {}
	local lPerg				:= 0

	aAdd( aCliFor , "1=Fornecedor" )
	aAdd( aCliFor , "2=Cliente" )

	aAdd(aParamBox,{1,"Data"						,Ctod("")	,""	,""	,""	,""	,80,.T.})	//MV_PAR01
	aAdd(aParamBox,{2,"Cliente/Fornecedor"			,"1",aCliFor,85,"",.T.})				//MV_PAR02
	aAdd(aParamBox,{1,"Tipos (;)"					,Space(150),"","","","",90,.F.})		//MV_PAR03
	aAdd(aParamBox,{1,"Não Consid. Tipos (;)"		,Space(150),"","","","",90,.F.})		//MV_PAR04
	aAdd(aParamBox,{1, "Cotação Moeda DOLAR", nCotacaoUSD,   "@E 99,999.9999", "Positivo()", "", ".T.", 80,  .F.}) //vinicius
	aAdd(aParamBox,{1, "Cotação Moeda EURO", nCotacaoEUR,   "@E 99,999.9999", "Positivo()", "", ".T.", 80,  .F.}) //vinicius


	lPerg	:= ParamBox(aParamBox,"Parametros",,,,.T.,,,,"RFINR12",.T.,.T.)

	cTipos				:= MV_PAR03
	cNotTipos			:= MV_PAR04
	nCotacaoUSD         := MV_PAR05 //vinicius
	nCotacaoEUR         := MV_PAR06 //vinicius

return

Static Function ReportDef()

	Local oReport
	Local oSection1,oSection2,oSection3

	titulo:= "Saldo a Pagar/Receber"
	cDesc1:= "Este programa irá emitir o relatorio"
	cDesc2:= "Saldo a Pagar/Receber"
	cPerg := "RFINR12"

	//Pergunte( cPerg , .F. )
	oReport := TReport():New("RFINR12",titulo,fPerg(), {|oReport| ReportPrint(oReport)},cDesc1+" "+cDesc2) //"Onde e' Usado"##"Emite uma rela‡„o informando onde determinados materiais selecionados"##"s„o utilizados na composi‡„o da estrutura."
	oSection1 := TRSection():New(oReport,titulo,{"TRB"},/*Array c/Ordens*/,/*Campos do SX3*/,/*Campos do SIX*/) //"Produtos"

	TRCell():New(oSection1,"CLIFOR","TRB",if(mv_par02 == "1","Fornecedor","Cliente"),/*Picture*/,06/*Tamanho*/,/*lPixel*/,{||TRB->CLIFOR})
	TRCell():New(oSection1,"NREDUZ","TRB","Nome",/*Picture*/,20/*Tamanho*/,/*lPixel*/,{||TRB->NREDUZ})
	TRCell():New(oSection1,"TITULO","TRB","Numero Título",/*Picture*/	,13	/*Tamanho*/,/*lPixel*/,{||TRB->TITULO})
	TRCell():New(oSection1,"PARCELA","TRB","Parcela",/*Picture*/	,5	/*Tamanho*/,/*lPixel*/,{||TRB->PARCELA})
	TRCell():New(oSection1,"INVOICE","TRB","Invoice",/*Picture*/	,13	/*Tamanho*/,/*lPixel*/,{||TRB->INVOICE})
	TRCell():New(oSection1,"PROCESSO","TRB","Processo",/*Picture*/	,13	/*Tamanho*/,/*lPixel*/,{||TRB->PROCESSO})
	TRCell():New(oSection1,"EMISSAO" ,"TRB","Emissão" , /*Picture*/,15 /*Tamanho*/,/*lPixel*/,{||TRB->EMISSAO})
	TRCell():New(oSection1,"VENCTO","TRB","Vencimento" ,/*Picture*/,15 /*Tamanho*/,/*lPixel*/,{||TRB->VENCTO})
	TRCell():New(oSection1,"PRAZO","TRB","Prazo" ,/*Picture*/,04 /*Tamanho*/,/*lPixel*/,{||TRB->PRAZO})
	TRCell():New(oSection1,"VALOR1" ,"TRB","Valor R$ Emissão","@E 999,999,999.99" /*Picture*/,12 /*Tamanho*/,/*lPixel*/,{||TRB->VALOR1})
	TRCell():New(oSection1,"VALOR","TRB","Moeda Estrangeira" ,"@E 999,999,999.99" /*Picture*/,12 /*Tamanho*/,/*lPixel*/,{||TRB->VALOR})
	TRCell():New(oSection1,"MOEDA","TRB","Tipo Moeda",/*Picture*/,30/*Tamanho*/,/*lPixel*/,{||TRB->MOEDA})
	TRCell():New(oSection1,"SALDO","TRB","Saldo Atual R$" ,"@E 999,999,999.99" /*Picture*/,12 /*Tamanho*/,/*lPixel*/,{||TRB->SALDO})
	//TODO TRCell():New(oSection1,"DIVISAO","TRB","Divisão",/*Picture*/,20/*Tamanho*/,/*lPixel*/,{||TRB->DIVISAO})
	TRCell():New(oSection1,"STATUS","TRB","Status",/*Picture*/,03/*Tamanho*/,/*lPixel*/,{||TRB->STATUS})
	TRCell():New(oSection1,"TIPO","TRB","Tipo",/*Picture*/,03/*Tamanho*/,/*lPixel*/,{||TRB->TIPO})
	TRCell():New(oSection1,"CONT","TRB","Contabilizado?",/*Picture*/,10/*Tamanho*/,/*lPixel*/,{||TRB->CONT})

	//TRFunction():New(oSection1:Cell("DIFERENCA"),,"SUM",,,"@e 999,999,999.99",,.F.,.T.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Section 2                                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oSection2 := TRSection():New(oReport,"Status",{"TB1"},/*Array c/Ordens*/,/*Campos do SX3*/,/*Campos do SIX*/) //"Produtos"
	TRCell():New(oSection2,"STATUS","TB1","Status",/*Picture*/,40/*Tamanho*/,/*lPixel*/,{||TB1->STATUS})
	TRCell():New(oSection2,"SALDO","TB1","Saldo Atual R$" ,"@E 999,999,999.99" /*Picture*/,12 /*Tamanho*/,/*lPixel*/,{||TB1->SALDO})

	oSection3 := TRSection():New(oReport,"Total",{"TT1"},/*Array c/Ordens*/,/*Campos do SX3*/,/*Campos do SIX*/)
	TRCell():New(oSection3,"TOTAL","TT1","Total",/*Picture*/,40/*Tamanho*/,/*lPixel*/,{||TT1->TOTAL})
	TRCell():New(oSection3,"VALOR","TT1","Valor R$" ,"@E 999,999,999.99" /*Picture*/,12 /*Tamanho*/,/*lPixel*/,{||TT1->VALOR})

	oReport:SetLandscape()
	oReport:SetDevice(4)

Return(oReport)

/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Programa  ³ReportPrin³ Autor ³ Ricardo Berti         ³ Data ³17/05/2006³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
	±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
	±±³          ³                                                            ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Retorno   ³Nenhum                                                      ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Parametros³ExpO1: Objeto Report do Relatório                           ³±±
	±±³          ³                                                            ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³          ³               ³                                            ³±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrint(oReport)

	Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(2)
	Local oSection3 := oReport:Section(3)
	local nCampo	:= 0
	local cCampo	:= ""

	private oTempTable, oTempTabl1,oTempTabl2

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Metodo TrPosition()                                                     ³
	//³                                                                        ³
	//³Posiciona em um registro de uma outra tabela. O posicionamento será     ³
	//³realizado antes da impressao de cada linha do relatorio.                ³
	//³                                                                        ³
	//³ExpO1 : Objeto Report da Secao                                          ³
	//³ExpC2 : Alias da Tabela                                                 ³
	//³ExpX3 : Ordem ou NickName de pesquisa                                   ³
	//³ExpX4 : String ou Bloco de codigo para pesquisa. A string sera macroexe-³
	//³        cutada.                                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Inicio da impressao do fluxo do relatorio                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	_dDataAnt:= ddatabase
	ddatabase:= mv_par01
	Monta_TB1()
	Monta_Total()
	Monta_TRB()

	dbSelectArea("TB1")
	dbgotop()
	oSection2:SetColSpace(5)
	oSection2:print()
	oReport:skipline(1)

	/*
	If oReport:nDevice == 4 //1-Arquivo,2-Impressora,3-email,4-Planilha e 5-Html
		oSection1:lHeaderSection := .F.
	EndIf
	*/

	oReport:SetMeter(TT1->(LastRec()))
	dbSelectArea("TT1")
	dbgotop()
	oSection3:SetColSpace(5)
	oSection3:print()
	oReport:skipline(1)

	oReport:SetMeter(TRB->(LastRec()))
	oSection1:SetColSpace(5)

	TRB->(DbGoTop())
	oSection1:Init()
	While TRB->(!Eof())
		for nCampo := 1 to len( oSection1:aCell )
			cCampo		:= oSection1:aCell[nCampo]:cName
			oSection1:Cell(cCampo):SetValue( TRB->&(cCampo) )
		next

		oSection1:printline()
		If oReport:nDevice == 4 //1-Arquivo,2-Impressora,3-email,4-Planilha e 5-Html
			oSection1:lHeaderSection := .F.
		EndIf

		oReport:IncMeter()
		TRB->(DbSkip())
	EndDo
	oSection1:Finish()

	oTempTable:Delete()
	oTempTabl1:Delete()
	oTempTabl2:Delete()

	ddatabase:= _dDataAnt

Return NIL

Static Function Monta_TRB()

	Local aDivisao		:= {} //TODO RetSx3Box(Posicione('SX3',2,'E1_XDIVISA','X3CBox()'),,,1)
	Local nTotal		:= 0
	local nSldFin		:= 0
	local nSldCtb		:= 0

	aESTRUT1 := {}
	AADD(aESTRUT1,{"CLIFOR"    , "C", 06,0})
	AADD(aESTRUT1,{"NREDUZ"    , "C", 20,0})
	AADD(aESTRUT1,{"TITULO"    , "C", 13,0})
	AADD(aESTRUT1,{"PARCELA"   , "C", 5,0})
	AADD(aESTRUT1,{"INVOICE"   , "C", 50,0})
	AADD(aESTRUT1,{"PROCESSO"  , "C", 50,0})
	AADD(aESTRUT1,{"EMISSAO"   , "D", 08,0})
	AADD(aESTRUT1,{"VENCTO"    , "D", 08,0})
	AADD(aESTRUT1,{"PRAZO"     , "N", 04,0})
	AADD(aESTRUT1,{"VALOR1"    , "N", 12,2})
	AADD(aESTRUT1,{"VALOR"     , "N", 12,2})
	AADD(aESTRUT1,{"MOEDA"     , "C", 30,0})
	AADD(aESTRUT1,{"SALDO"     , "N", 12,2})
	//AADD(aESTRUT1,{"DIVISAO"   , "C", 20,0})
	AADD(aESTRUT1,{"STATUS"    , "C", 03,0})
	AADD(aESTRUT1,{"TIPO"      , "C", 03,0})
	AADD(aESTRUT1,{"CONT"      , "C", 10,0})

	oTempTable:= FWTemporaryTable():New( "TRB" )
	oTemptable:SetFields( aESTRUT1 )
	oTempTable:AddIndex("01", {"CLIFOR","TITULO"} )
	oTempTable:Create()

	if mv_par02 == "1"

		cQuery := "SELECT * "
		cQuery += "FROM " + RetSqlName('SE2') + ' SE2 '
		cQuery += "LEFT JOIN "+RetSqlName("SA2")+" SA2 ON (A2_COD = E2_FORNECE AND A2_LOJA = E2_LOJA AND A2_FILIAL = '"+xFilial('SA2')+"' AND SA2.D_E_L_E_T_ = ' ') "
		cQuery += " WHERE "
		cQuery += "E2_FILIAL = '" + xFilial('SE2') + "' AND "
		//cQuery += "E2_MOEDA <> 1 AND "
		cQuery += "(E2_SALDO > 0 OR E2_BAIXA > '" + dtos(mv_par01) + "') AND "
		cQuery += "E2_EMIS1 < '" + dtos(mv_par01+1) + "' AND "
		cQuery += "SE2.D_E_L_E_T_ = ' ' "
		if !Empty(cTipos)
			cQuery += " AND E2_TIPO IN "+FormatIn(cTipos,";")
		endif
		if !Empty(cNotTipos)
			cQuery += " AND E2_TIPO NOT IN "+FormatIn(cNotTipos,";")
		endif
		cQuery := ChangeQuery(cQuery)

		dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), 'TMP', .F., .T.)

		dbgotop()
		while !eof()
			SWB->(DbSetOrder(8))
			SWB->(DbSeek( FwXFilial("SWB") + TMP->E2_NUM ))

			dbSelectArea("SE2")
			dbgoto(TMP->R_E_C_N_O_)
			nSaldo := SaldoTit(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,SE2->E2_NATUREZ,"P",SE2->E2_FORNECE,SE2->E2_MOEDA,mv_par01,mv_par01,SE2->E2_LOJA,,nil,1) // 1 = DT BAIXA    3 = DT DIGIT
			if SE2->E2_TIPO $ 'PA .NDF' .or. right(SE2->E2_TIPO,1) == '-'
				nSaldo:= nSaldo * -1
			endif
			_n:= 0 //TODO ascan(aDivisao,{ |x| left(x[1],2) == TMP->E2_XDIVISA})

			reclock("TRB",.t.)
			TRB->CLIFOR := TMP->E2_FORNECE
			TRB->NREDUZ := TMP->E2_NOMFOR
			TRB->TITULO 	:= TMP->E2_PREFIXO + TMP->E2_NUM
			TRB->PARCELA 	:= TMP->E2_PARCELA
			TRB->INVOICE:= SWB->WB_INVOICE //TODO TMP->E2_XINVOIC
			TRB->PROCESSO := SWB->WB_HAWB
			TRB->EMISSAO:= stod(TMP->E2_EMISSAO)
			TRB->VENCTO := stod(TMP->E2_VENCREA)
			TRB->PRAZO  := TRB->VENCTO - TRB->EMISSAO
			TRB->VALOR1 := TMP->E2_VLCRUZ
			TRB->VALOR  := nSaldo
			TRB->MOEDA  := AllTrim(Str(TMP->E2_MOEDA)) + "-" + getnewpar("MV_MOEDAP" + AllTrim(Str(TMP->E2_MOEDA)),"") //str(TMP->E2_MOEDA,1)+'-'+if(TMP->E2_MOEDA==1,'REAL',if(TMP->E2_MOEDA==2,'DOLAR',if(TMP->E2_MOEDA==5,'EURO',if(TMP->E2_MOEDA==6,'LIBRA',''))))
			TRB->SALDO  := nSaldo * if(Alltrim(TRB->MOEDA)=="1-REAIS",1,if(Alltrim(TRB->MOEDA)=="2-DOLARES",nCotacaoUSD,nCotacaoEUR))//vinicius
			//TODO TRB->DIVISAO:= "" //TODO TMP->E2_XDIVISA + if(empty(_n),'','-'+aDivisao[_n,3])
			TRB->STATUS := Status(mv_par01 - stod(TMP->E2_VENCREA))
			TRB->TIPO   := TMP->E2_TIPO
			TRB->CONT   := iif( AllTrim(TMP->E2_LA)=="S","Sim","Não")
			msunlock()

			dbSelectArea("TB1")
			if msSeek('(' + trim(TRB->STATUS))
				reclock("TB1",.f.)
				TB1->SALDO+= TRB->SALDO
				msunlock()

				nTotal		+= TRB->SALDO
			endif

			dbSelectArea("TT1")
			if AllTrim(TMP->E2_LA) == "S"
				if TT1->(msSeek( SEEK_CTB ))
					If reclock("TT1",.f.)
						TT1->VALOR	+= TRB->SALDO
						TT1->(msunlock())
					endif
					nSldCtb		:= TT1->VALOR
				endif
			endif
			if TT1->(msSeek( SEEK_FIN ))
				If reclock("TT1",.f.)
					TT1->VALOR	+= TRB->SALDO
					TT1->(msunlock())
				endif
				nSldFin		:= TT1->VALOR
			endif
			if TT1->(msSeek( SEEK_DIF ))
				If reclock("TT1",.f.)
					TT1->VALOR	:= nSldFin - nSldCtb
					TT1->(msunlock())
				endif
			endif

			dbSelectArea("TB1")
			if msSeek(STATUS_TOTAL)
				reclock("TB1",.f.)
				TB1->SALDO	:= nTotal
				msunlock()
			endif

			dbSelectArea("TMP")
			dbskip()
		enddo
	else
		cQuery := "SELECT * "
		cQuery += "FROM " + RetSqlName('SE1') + ' SE1 '
		cQuery += "LEFT JOIN "+RetSqlName("SA1")+" SA1 ON (A1_COD = E1_CLIENTE AND A1_LOJA = E1_LOJA AND A1_FILIAL = '"+xFilial('SA1')+"' AND SA1.D_E_L_E_T_ = ' ') "
		cQuery += " WHERE "
		cQuery += "E1_FILIAL = '" + xFilial('SE1') + "' AND "
		//cQuery += "E1_MOEDA <> 1 AND "
		cQuery += "(E1_SALDO > 0 OR E1_BAIXA > '" + dtos(mv_par01) + "') AND "
		cQuery += "E1_EMIS1 < '" + dtos(mv_par01+1) + "' AND "
		cQuery += "SE1.D_E_L_E_T_ = ' ' "
		if !Empty(cTipos)
			cQuery += " AND E1_TIPO IN "+FormatIn(cTipos,";")
		endif
		if !Empty(cNotTipos)
			cQuery += " AND E1_TIPO NOT IN "+FormatIn(cNotTipos,";")
		endif
		cQuery := ChangeQuery(cQuery)

		dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), 'TMP', .F., .T.)

		dbgotop()
		while !eof()

			//TODO
			/*
			dbSelectArea("ZZB")
			dbsetorder(2)
			msSeek(xFilial() + TMP->E1_PEDIDO)
			*/

			EEQ->(DbSetOrder(12)) //EEQ_FILIAL+EEQ_PREFIX+EEQ_TPTIT+EEQ_FINNUM+EEQ_PARC
			EEQ->(DbSeek( FwXFilial("EEQ") + SE1->E1_PREFIXO + SE1->E1_TIPO + SE1->E1_NUM + SE1->E1_PARCELA ))

			dbSelectArea("SE1")
			dbgoto(TMP->R_E_C_N_O_)
			nSaldo := SaldoTit(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_NATUREZ,"R",SE1->E1_CLIENTE,SE1->E1_MOEDA,mv_par01,mv_par01,SE1->E1_LOJA,,nil,1) // 1 = DT BAIXA    3 = DT DIGIT
			if SE1->E1_TIPO $ 'RA .NCC' .or. right(SE1->E1_TIPO,1) == '-'
				nSaldo:= nSaldo *-1
			endif

			//TODO
			_cDivisao		:= ""
			/*
			_n:= ascan(aDivisao,{ |x| left(x[1],2) == TMP->E1_XDIVISA})
			_cGrpVen:= posicione("SA1",1,xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA,"A1_GRPVEN")
			if TMP->E1_XDIVISA == '09'
				if _cGrpVen == '000021'
					_cDivisao := '09B-INTERCOMPANY'
				else
					_cDivisao := '09A-LATAM'
				endif
			else
				_cDivisao := TMP->E1_XDIVISA + if(empty(_n),'','-'+aDivisao[_n,3])
			endif
			*/

			reclock("TRB",.t.)
			TRB->CLIFOR := TMP->E1_CLIENTE
			TRB->NREDUZ := TMP->E1_NOMCLI
			TRB->TITULO 	:= TMP->E1_PREFIXO + TMP->E1_NUM
			TRB->PARCELA 	:= TMP->E1_PARCELA
			TRB->INVOICE	:= EEQ->EEQ_PREEMB
			TRB->PROCESSO 	:= EEQ->EEQ_PREEMB
			TRB->EMISSAO:= stod(TMP->E1_EMISSAO)
			TRB->VENCTO := stod(TMP->E1_VENCREA)
			TRB->PRAZO  := TRB->VENCTO - TRB->EMISSAO
			TRB->VALOR1 := TMP->E1_VLCRUZ
			TRB->VALOR  := nSaldo //TMP->E1_VALOR
			TRB->MOEDA  := AllTrim(Str(TMP->E1_MOEDA)) + "-" + getnewpar("MV_MOEDAP" + AllTrim(Str(TMP->E1_MOEDA)),"")
			TRB->SALDO  := nSaldo * if(Alltrim(TRB->MOEDA)=="1-REAIS",1,if(Alltrim(TRB->MOEDA)=="2-DOLARES",nCotacaoUSD,nCotacaoEUR))//vinicius
			//TODO TRB->DIVISAO:= _cDivisao //TMP->E1_XDIVISA + if(empty(_n),'','-'+aDivisao[_n,3])
			TRB->STATUS := Status(mv_par01 - stod(TMP->E1_VENCREA))
			TRB->TIPO   := TMP->E1_TIPO
			TRB->CONT   := iif( AllTrim(TMP->E1_LA)=="S","Sim","Não")
			msunlock()

			dbSelectArea("TB1")
			if msSeek('(' + trim(TRB->STATUS))
				reclock("TB1",.f.)
				TB1->SALDO+= TRB->SALDO
				msunlock()

				nTotal		+= TRB->SALDO
			endif

			dbSelectArea("TT1")
			if AllTrim(TMP->E1_LA) == "S"
				if TT1->(msSeek( SEEK_CTB ))
					If reclock("TT1",.f.)
						TT1->VALOR	+= TRB->SALDO
						TT1->(msunlock())
					endif
					nSldCtb		:= TT1->VALOR
				endif
			endif
			if TT1->(msSeek( SEEK_FIN ))
				If reclock("TT1",.f.)
					TT1->VALOR	+= TRB->SALDO
					TT1->(msunlock())
				endif
				nSldFin		:= TT1->VALOR
			endif
			if TT1->(msSeek( SEEK_DIF ))
				If reclock("TT1",.f.)
					TT1->VALOR	:= nSldFin - nSldCtb
					TT1->(msunlock())
				endif
			endif

			dbSelectArea("TB1")
			if msSeek(STATUS_TOTAL)
				reclock("TB1",.f.)
				TB1->SALDO	:= nTotal
				msunlock()
			endif

			dbSelectArea("TMP")
			dbskip()
		enddo

	endif
	dbclosearea()

Static Function Status(pDias)
	Local cRet

	if pDias < -90
		cRet:= 'a.1'
	elseif pDias < -60
		cRet:= 'a.2'
	elseif pDias < -30
		cRet:= 'a.3'
	elseif pDias < 1
		cRet:= 'a.4'
	elseif pDias < 31
		cRet:= 'b'
	elseif pDias < 61
		cRet:= 'c'
	elseif pDias < 91
		cRet:= 'd'
	elseif pDias < 121
		cRet:= 'e'
	elseif pDias < 151
		cRet:= 'f'
	elseif pDias < 181
		cRet:= 'g'
	elseif pDias < 361
		cRet:= 'h'
	else
		cRet:= 'i'
	endif

return(cRet)

Static Function Monta_TB1()

	aESTRUT := {}
	AADD(aESTRUT,{"STATUS"    , "C", 40,0})
	AADD(aESTRUT,{"SALDO"     , "N", 13,2})

	oTempTabl1:= FWTemporaryTable():New( "TB1" )
	oTemptabl1:SetFields( aESTRUT )
	oTempTabl1:AddIndex("01", {"STATUS"} )
	oTempTabl1:Create()

	reclock("TB1",.t.)
	TB1->STATUS:= '(a.1) A vencer acima de 90 dias'
	msunlock()

	reclock("TB1",.t.)
	TB1->STATUS:= '(a.2) A vencer de 61 a 90 dias'
	msunlock()

	reclock("TB1",.t.)
	TB1->STATUS:= '(a.3) A vencer de 31 a 60 dias'
	msunlock()

	reclock("TB1",.t.)
	TB1->STATUS:= '(a.4) A vencer até 30 dias'
	msunlock()

	reclock("TB1",.t.)
	TB1->STATUS:= '(b) Vencidos até 30 dias'
	msunlock()

	reclock("TB1",.t.)
	TB1->STATUS:= '(c) Vencidos de 31 a 60 dias'
	msunlock()

	reclock("TB1",.t.)
	TB1->STATUS:= '(d) Vencidos de 61 a 90 dias'
	msunlock()

	reclock("TB1",.t.)
	TB1->STATUS:= '(e) Vencidos de 91 a 120 dias'
	msunlock()

	reclock("TB1",.t.)
	TB1->STATUS:= '(f) Vencidos de 121 a 150 dias'
	msunlock()

	reclock("TB1",.t.)
	TB1->STATUS:= '(g) Vencidos de 151 a 180 dias'
	msunlock()

	reclock("TB1",.t.)
	TB1->STATUS:= '(h) Vencidos de 181 a 360 dias'
	msunlock()

	reclock("TB1",.t.)
	TB1->STATUS:= '(i) Vencidos acima de 360 dias'
	msunlock()

	reclock("TB1",.t.)
	TB1->STATUS:= STATUS_TOTAL
	msunlock()

return

Static Function Monta_Total()

	aESTRUT := {}
	AADD(aESTRUT,{"TOTAL",		"C", 40,0})
	AADD(aESTRUT,{"VALOR",		"N", 13,2})

	oTempTabl2:= FWTemporaryTable():New( "TT1" )
	oTempTabl2:SetFields( aESTRUT )
	oTempTabl2:AddIndex("01", {"TOTAL"} )
	oTempTabl2:Create()

	If reclock("TT1",.t.)
		TT1->TOTAL	:= '1-Saldo Contábil'
		TT1->(msunlock())
	EndIf

	If reclock("TT1",.t.)
		TT1->TOTAL	:= '2-Saldo Financeiro'
		TT1->(msunlock())
	EndIf

	If reclock("TT1",.t.)
		TT1->TOTAL	:= '3-Diferença'
		TT1->(msunlock())
	EndIf

return
