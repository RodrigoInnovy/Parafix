#include "protheus.ch"
#include "colors.ch"
#Include "Font.ch"
#Include "TopConn.ch"

#define PAD_LEFT 	0
#define PAD_RIGHT 	1
#define PAD_CENTER 	2

#define LARG_PAG 	2380
#define TOTAL_TOT 	2370
#define DESC_TOT 	1648

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMSRFATGF  บAutor  ณHermes Vieira Jr    บ Data ณ  27/10/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime relatorio de Pedido de vendas de acordo com os     บฑฑ
ฑฑบ          ณ parametros informados.   					              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MSRFATGF(lAuto,cNum)

	Local lReg				:= .F. 	// Verifica a exist๊ncia de Registros
	Local nLastKey			:= 0
	Local titulo   			:= "Relat๓rio de Pedido de Venda"
	Local cMens 			:= "Nใo hแ registros para os parametros informados !!"
	Local nCount			:= 0
	Local cPerg				:= "PERFAT"
	Private cNPv 	   		:= ""
	Private cEmissao		:= ""
	Private nQtdPag			:= 0
	Private oFont1 			:= TFont():New("Arial",09,14,		,.T.,,,,,.F.) //Parametros TFonte ("Tipo Fonte", ,Tamanho Fonte , , ,Italico (.T./.F.))
	Private oFont2  		:= TFont():New("Arial",07,07,		,.F.,,,,,.F.) // Normal
	Private oFont3  		:= TFont():New("Arial",09,09,.T.	,.T.,,,,,.F.) // Negrito
	Private oFont4  		:= TFont():New("Arial",09,14,.T.	,.T.,,,,,.T.) // Negrito - Sublinhado
	Private oFont5  		:= TFont():New("Arial",09,09,   	,.F.,,,,,.F.) // Negrito
	Private oPrint
	Private cPedido

	Private aColImp			:= {}

	// Instโncia็ใo do Objeto OPrint
	oPrint := TMSPrinter():New()

	ValidPerg(cPerg)

	If lAuto
		mv_par01 := cNum
		mv_par02 := cNum
		mv_par03 := Ctod("01/01/1990")
		mv_par04 := Ctod("31/12/2060")
	Else
		If !(Pergunte(cPerg,.T.))
			Return
		Endif
	Endif

	If lastKey() == 27 .or. nLastKey == 27 .or. nLastKey == 286
		return
	Endif

	MsgRun("Aguarde...", "Carregando relat๓rio...", {|| RunRel(@lReg)})

	if lReg = .F.
		if !(empty(cMens))
			MsgSTOP(cMens)
		endIf
	Else
		if msgyesno("Deseja enviar o relat๓rio por e-mail?")
			U_MSRFATHT(.T.,mv_par01)
		else
			oPrint:Preview()
		endIf
	EndIf

Return

/*/{Protheus.doc}	RunRel
Imprime relat๓rio

@author				Cassiano Gon็alves Ribeiro
@since				17/06/2013
@return				Nil
/*/
Static Function RunRel(lReg)

	Local cQuery := ""
	Local cAlias			:= getNextAlias()

	&& Query que retorna os dados do pedido de compra e os dados dos itens.
	cQuery := "SELECT "
	cQuery += "		SC5.C5_NUM, SC5.C5_EMISSAO, SC5.C5_DESC1, SC5.C5_DESC2, SC5.C5_DESC3, SC5.C5_DESC4,SC5.C5_FRETE, SC5.C5_DESPESA, SC5.C5_CLIENTE, SC5.C5_LOJACLI, "
	//cQuery += "		SC5.C5_TPFRETE, SC5.C5_ESPECI1, SC5.C5_VEND1, SC5.C5_MENNOTA, SC5.C5_MENPAD, SC5.C5_CONDPAG, SC5.C5_TRANSP,SC5.C5_VOLUME1, SC5.C5_ZZVALID,  "
	cQuery += "		SC5.C5_TPFRETE, SC5.C5_ESPECI1, SC5.C5_VEND1, SC5.C5_MENNOTA, SC5.C5_MENPAD, SC5.C5_CONDPAG, SC5.C5_TRANSP,SC5.C5_VOLUME1,  "
	cQuery += "		SA1.A1_COD, SA1.A1_NOME, SA1.A1_EMAIL, SA1.A1_END, SA1.A1_MUN, SA1.A1_EST, SA1.A1_DDD, SA1.A1_TEL, SA1.A1_FAX, SA1.A1_CEP, SA1.A1_BAIRRO, SA1.A1_EST, SA1.A1_CONTATO, SA1.A1_HPAGE,SA1.A1_CGC, SA1.A1_INSCR,"
	cQuery += "		SC6.C6_NUM, SC6.C6_ITEM, SC6.C6_PRODUTO, SC6.C6_DESCRI, SC6.C6_UM, SC6.C6_QTDVEN, SC6.C6_PRCVEN, SC6.C6_VALOR, SC6.C6_ENTREG, SC6.C6_TES,SC6.C6_PEDCLI,"
	cQuery += "		SB1.B1_IPI, SB1.B1_DESC, SE4.E4_DESCRI, SA4.A4_NOME, SA3.A3_NOME, SA3.A3_EMAIL, SB1.B1_CONV, SC6.C6_DTVALID, SC6.C6_LOTECTL "
	cQuery += "FROM " + RetSqlName("SC5") + " SC5 "
	cQuery += "		LEFT JOIN " + RetSqlName("SA1") + " SA1 ON "
	cQuery += "			SA1.A1_FILIAL = '" + xFilial("SA1") + "' AND SC5.C5_CLIENTE = A1_COD AND SC5.C5_LOJACLI = A1_LOJA AND SA1.D_E_L_E_T_ = ' ' "
	cQuery += "		INNER JOIN " + RetSqlName("SC6") + " SC6 ON "
	cQuery += "			SC6.C6_FILIAL = '" + xFilial("SC6") + "' AND SC5.C5_NUM = SC6.C6_NUM AND SC6.D_E_L_E_T_ = ' ' "
	cQuery += "		LEFT JOIN " + RetSqlName("SB1") + " SB1 ON "
	cQuery += "			SB1.B1_FILIAL = '" + xFilial("SB1") + "' AND SC6.C6_PRODUTO = SB1.B1_COD AND SB1.D_E_L_E_T_ = ' ' "
	cQuery += "		LEFT JOIN " + RetSqlName("SE4") + " SE4 ON "
	cQuery += "			SE4.E4_FILIAL = '" + xFilial("SE4") + "' AND SC5.C5_CONDPAG = SE4.E4_CODIGO AND SE4.D_E_L_E_T_ = ' ' "
	cQuery += "		LEFT JOIN " + RetSqlName("SA4") + " SA4 ON "
	cQuery += "			SA4.A4_FILIAL = '" + xFilial("SA4") + "' AND SC5.C5_TRANSP = SA4.A4_COD AND SA4.D_E_L_E_T_ = ' ' "
	cQuery += "		LEFT JOIN " + RetSqlName("SA3") + " SA3 ON "
	cQuery += "			SA3.A3_FILIAL = '" + xFilial("SA3") + "' AND SC5.C5_VEND1 = SA3.A3_COD AND SA3.D_E_L_E_T_ = ' ' "
	cQuery += "	WHERE SC5.C5_FILIAL = '" + xFilial("SC5") + "' AND SC5.D_E_L_E_T_ = ' ' AND SC5.C5_NUM >= '"+ mv_par01 +"' AND SC5.C5_NUM <= '"+ mv_par02 +"' "
	If !Empty(mv_par03) .AND. !Empty(mv_par04)
		cQuery += " AND C5_EMISSAO BETWEEN '" + DtoS(mv_par03) + "' AND '" + DtoS(mv_par04) + "' "
	EndIf
	cQuery += " ORDER BY SC5.C5_NUM, SC6.C6_ITEM"

	TCQUERY cQuery NEW ALIAS &cAlias

	TCSETFIELD(cAlias,"C5_EMISSAO","D",08,00)
	TCSETFIELD(cAlias,"C6_DTVALID","D",08,00)

	Count to nCount

	(cAlias)->(dbgotop())

	While (cAlias)->(!Eof())

		cNPv 		:= (cAlias)->C5_NUM
		TCSETFIELD(cAlias,"C5_EMISSAO","D")
		//TCSETFIELD("cAlias","C5_ZZVALID","D")
		cEMISSAO 	:= (cAlias)->C5_EMISSAO
		lReg 		:= .T.
		cPedido     := ""

		// Query que retorna a Quantidade Total de itens em um Pedido de Venda
		cQuery := "SELECT COUNT(C6_ITEM) AS Total "
		cQuery += " FROM " + RetSqlName("SC6")
		cQuery += " WHERE C6_NUM = '" + (cAlias)->C5_NUM + "' AND D_E_L_E_T_ = ' '"

		TCQUERY cQuery NEW ALIAS "cCount"

		// Atribui a Quantidade Total de itens na Variavel nCount
		nCount := cCount->Total

		// Controla a Quantidade de Paginas no Relatorio
		nQtdPag := STR((cCount->Total / 30)+ 1)
		nQtdPag := LEFT(nQtdPag, AT(".",nQtdPag)-1)

		cCount->(dbCloseArea())

		//Inicia uma Nova Pagina para Impressao
		oPrint:StartPage()

		//Define o modo de Impressao como Retrato
		oPrint:SetPortrait()  //SetLandscape -> Para definir como modo Paisagem

		IMPCAB(cNPv, cEMISSAO,cAlias)	//Funcao para impressao do Cabecalho
		IMPCLI(cAlias)	//Funcao para impressao dos dados do Cliente
		IMPPRO(cNPv,nCount,nQtdPag,cAlias)	//Funcao para impressao dos Detalhes do Produto

	End

	(cAlias)->(dbCloseArea())
Return




/*/{Protheus.doc}	IniImp
Inicializa as fun็๕es de impostos

@author				Lucas Assis Mendes
@since				04/06/2013
@return				Nil
/*/
Static Function IniImp(cAlias)

	Local aArea 	:= Lj7GetArea({"SA1"})
	Local cTipoCli	:= Posicione("SA1",1,xFilial("SA1")+(cAlias)->C5_CLIENTE+(cAlias)->C5_LOJACLI,"A1_TIPO")

	MaFisSave()
	MaFisEnd()
	//Inicializa a funcao fiscal
	MaFisIni(	(cAlias)->C5_CLIENTE	,;	// 1-Codigo Cliente/Fornecedor
	(cAlias)->C5_LOJACLI	,;	// 2-Loja do Cliente/Fornecedor
	"C"					,;	// 3-C:Cliente , F:Fornecedor
	"N"					,;	// 4-Tipo da NF
	cTipoCli			,;	// 5-Tipo do Cliente/Fornecedor
	NIL					,;
	NIL					,;
	NIL					,;
	NIL					,;
	"MATA410"			)

	Lj7RestArea(aArea)

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออ"ฑฑ
ฑฑบPrograma  ณ IMPCAB   บ Autor ณHermes Vieira Jr.	   บ Data ณ  27/10/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Impressao do cabecalho do relatorio.	  						บฑฑ
ฑฑบ          ณ Informacao: Cabecalho - Dados da Empresa;					บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function IMPCAB(cNPv, cEMISSAO,cAlias)

	Local nTopo			:= 0000  // Controle de Linhas
	Local nInicio		:= 0000  // Indica a posi็ใo da primeira coluna
	//Local cEmail 		:= AllTrim(GetMV("ZZ_SCEMAIL"))
	//Local cLogo			:= AllTrim(GetMV("ZZ_LOGO"))

	//Retorna o tamanho Horizontal e Vertical da pagina.
	nVertSize := oPrint:nVertSize()
	nHorzSize := oPrint:nHorzSize()

	//Impressao do cabe็alho do Relatorio.
	//Obs.: O Logo pode ser colocado na pasta System do Protheus, no caso s๓ referencia o nome.

	// oPrint:SayBitmap(Coluna, Linha, Caminho, Largura, Altura)
	//	oPrint:SayBitmap( 0050,  0040,cLogo,(729 * 0.50), (454 * 0.50))
	//oPrint:SayBitmap(nTopo + 0050, nInicio + 0040, cLogo, 314, 235)

	dbSelectArea("SM0")
	SM0->(dbseek(cEmPant + cFilant))

	// Texto cabe็alho da direita
	//	 oPrint:Say(Coluna, Linha, Texto, Fonte, Num de Caracteres, , ,Alinhamento - 0=Left, 1=Right e 2=Center)
	oPrint:Say(nTopo + 0050, nInicio + 2360,RTrim(SM0->M0_NOMECOM)		,oFont1,100,,,1)
	//	oPrint:Say(nTopo + 0100, nInicio + 2360, AllTrim(SM0->M0_ENDENT) + " " + AllTrim(SM0->M0_CIDENT) + "/" + AllTrim(SM0->M0_ESTENT) + " " + LEFT(AllTrim(SM0->M0_CEPENT),5) + "-" + RIGHT(AllTrim(SM0->M0_CEPENT),3)		,oFont5,100,,,1)
	//	oPrint:Say(nTopo + 0150, nInicio + 2360, "E-mail: " + Alltrim(cEmail)								   			,oFont3,100,,,1)
	//	oPrint:Say(nTopo + 0200, nInicio + 2360, "Fone: " + AllTrim(SM0->M0_TEL) + " FAX: " + AllTrim(SM0->M0_FAX)	   		,oFont5,100,,,1)
	//	oPrint:Say(nTopo + 0250, nInicio + 2360, "CNPJ: " + AllTrim(Transform(SM0->M0_CGC, "@R 99.999.999/9999-99")) + " - IE: " +  AllTrim(Transform(SM0->M0_INSC, "@R 999.999.999.999")),oFont5,100,,,1)

	// oPrint:Line(Coluna, Linha, Coluna, Linha)
	oPrint:Line(nTopo + 0310, nInicio + 0040,nTopo + 0310, nInicio + LARG_PAG)
	oPrint:Line(nTopo + 0313, nInicio + 0040,nTopo + 0313, nInicio + LARG_PAG)
	oPrint:Line(nTopo + 0410, nInicio + 0040,nTopo + 0410, nInicio + LARG_PAG)
	oPrint:Line(nTopo + 0413, nInicio + 0040,nTopo + 0413, nInicio + LARG_PAG)

	oPrint:Say(nTopo + 0335	, nInicio + 0040, "Pedido de Venda Nฐ " + cNPv		,oFont1,100,,,0)
	oPrint:Say(nTopo + 0335	, nInicio + 2360,"Data: " + DTOC(cEMISSAO)			,oFont1,100,,,1)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออ"ฑฑ
ฑฑบPrograma  ณ IMPCLI   บ Autor ณHermes Vieira Jr.	   บ Data ณ  27/10/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Impressao dos Dados do Cliente.								บฑฑ
ฑฑบ          ณ Informacoes: Nome, E-mail, Endereco, Cidade, CEP, Tel, FAX,	บฑฑ
ฑฑบ			 ณ				Contato e Bairro.								บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function IMPCLI(cAlias)
	Local nTopo			:= 0000  // Controle de Linhas
	Local nInicio		:= 0000  // Indica a posicao da primeira coluna

	//Impressใo da Estrutura dos Dados do Cliente.

	// Texto a Esquerda
	oPrint:Say(nTopo + 0430	, nInicio + 0040, "Cliente" 	,oFont3,100,,,0)
	oPrint:Say(nTopo + 0480	, nInicio + 0040, "E-mail"		,oFont3,100,,,0)
	oPrint:Say(nTopo + 0530	, nInicio + 0040, "Endere็o"	,oFont3,100,,,0)
	oPrint:Say(nTopo + 0580	, nInicio + 0040, "Cidade"	  	,oFont3,100,,,0)
	oPrint:Say(nTopo + 0630	, nInicio + 0040, "TEL"  		,oFont3,100,,,0)
	oPrint:Say(nTopo + 0680	, nInicio + 0040, "CNPJ"  		,oFont3,100,,,0)

	//Texto Centralizado
	oPrint:Say(nTopo + 0430	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"Site" 			,oFont3,100,,,0)
	oPrint:Say(nTopo + 0480	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"Contato" 			,oFont3,100,,,0)
	oPrint:Say(nTopo + 0530	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"Bairro" 			,oFont3,100,,,0)
	oPrint:Say(nTopo + 0580	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"CEP" 				,oFont3,100,,,0)
	oPrint:Say(nTopo + 0630	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"FAX"				,oFont3,100,,,0)
	oPrint:Say(nTopo + 0680	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"I.E."				,oFont3,100,,,0)

	// Texto a Esquerda
	oPrint:Say(nTopo + 0430	, nInicio + 0210, ": " + (cAlias)->A1_COD + " - " + (cAlias)->A1_NOME		,oFont5,100,,,0)
	oPrint:Say(nTopo + 0480	, nInicio + 0210, ": " + (cAlias)->A1_EMAIL		,oFont5,100,,,0)
	oPrint:Say(nTopo + 0530	, nInicio + 0210, ": " + (cAlias)->A1_END			,oFont5,100,,,0)
	oPrint:Say(nTopo + 0580	, nInicio + 0210, ": " + AllTrim((cAlias)->A1_MUN)+"/"+(cAlias)->A1_EST	   		,oFont5,100,,,0)
	oPrint:Say(nTopo + 0630	, nInicio + 0210, ": (" + (cAlias)->A1_DDD + ") " + LEFT((cAlias)->A1_TEL,4) + "-" + SUBSTR((cAlias)->A1_TEL,5,8)	 	,oFont5,100,,,0)
	If LEN(ALLTRIM((cAlias)->A1_CGC)) > 11
		oPrint:Say(nTopo + 0680	, nInicio + 0210, ": " + AllTrim(Transform((cAlias)->A1_CGC,"@R 99.999.999/9999-99"))	,oFont5,100,,,0)
	eLSE
		oPrint:Say(nTopo + 0680	, nInicio + 0210, ": " + AllTrim(Transform((cAlias)->A1_CGC,"@R 999.999.999-99"))	,oFont5,100,,,0)
	ENDIF

	//Texto Centralizado
	oPrint:Say(nTopo + 0430	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0150,": " + (cAlias)->A1_HPAGE										,oFont5,100,,,0)
	oPrint:Say(nTopo + 0480	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0150,": " + (cAlias)->A1_CONTATO										,oFont5,100,,,0)
	oPrint:Say(nTopo + 0530	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0150,": " + (cAlias)->A1_BAIRRO										,oFont5,100,,,0)
	oPrint:Say(nTopo + 0580	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0150,": " + LEFT((cAlias)->A1_CEP,5) + "-" + RIGHT((cAlias)->A1_CEP,3)	,oFont5,100,,,0)
	oPrint:Say(nTopo + 0630	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0150,": (" + (cAlias)->A1_DDD + ") " + LEFT((cAlias)->A1_FAX,4) + "-" + SUBSTR((cAlias)->A1_FAX,5,8)	,oFont5,100,,,0)
	If LEN(ALLTRIM((cAlias)->A1_INSCR)) > 6
		oPrint:Say(nTopo + 0680	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0150,": " + AllTrim(Transform((cAlias)->A1_INSCR,"@R 999.999.999.999")) ,oFont5,100,,,0)
	Else
		oPrint:Say(nTopo + 0680	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0150,": " + AllTrim((cAlias)->A1_INSCR) ,oFont5,100,,,0)
	EndIf


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออ"ฑฑ
ฑฑบPrograma  ณ IMPPRO   บ Autor ณHermes Vieira Jr.	   บ Data ณ  27/10/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Impressao dos Dados de Detalhes dos Produtos.		  		บฑฑ
ฑฑบ		     ณ Parametros: cNPv - Numero do Pedido de Compra Corrente.		บฑฑ
ฑฑบ          ณ 			   nCount - Quantidade Total de Itens. 		  		บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function IMPPRO(cNPv, nCount, nQtdPag,cALias)
	Local nTopo		:= 0750  // Controle de Linhas
	Local nInicio	:= 0000  // Indica a posi็ใo da primeira coluna
	Local nTotal	:= 0000  // Controle do Valor Total do Pedido
	Local nTotal2	:= 0000  // Controle do Valor Total do Pedido
	Local nFrete	:= 0000  // Controle do Valor Total do Pedido
	Local nDespesa	:= 0000  // Controle do Valor Total do Pedido
	Local nVTIpi	:= 0000  // Controle do Valor Total do Pedido com IPI
	Local nPag		:= 1
	Local nCont		:= 1
	Local nContP	:= 0
	Local nTamDes	:= 0
	Local nTamStr	:= 0
	Local aDescProd := {}
	Local nTMens    := 0
	// Cassiano em 22-05-13
	Local nMargens	:= 40 && Margem a esquerda e a direita
	Local nCompMarg := 60.31496063 //compensa a largura da margem.
	Local nVlr	 	:= 0
	Local nColReais	:= 11 && Numero de colunas REAIS (visiveis) que terใo a se็ใo de itens
	Local nColVirtu	:= 27 && Numero de colunas VIRTUAIS (RELATIVAS) que terใo a se็ใo de itens
	Local nLargura 	:= 0
	Local cIpi 		:= ""
	Local nTotIpi 	:= 0

	Private nLimiteHoz:= (Mm2Pix(oPrint, oPrint:nHorzSize()) - nMargens) - nCompMarg && Limite da largura imprimivel, desconsiderando a margem
	Private nTpag	:= 0
	Private nLargPag:= (nLimiteHoz - nMargens) && Largura da parte imprimivel

	&& Denifi็ใo do espa็amento das colunas dos itens do relat๓rio
	aAdd(aColImp, nMargens)  && Margem esquerda - nMargens - primeira coluna
	nVlr := nLargPag / nColVirtu && Resultado da divisใo do area horizontal dividido pelos espa็amentos virtuais
	For nI := 1 To nColReais
		If StrZero(nI, 2) $ "05/08/09/02/10"
			aAdd(aColImp, aColImp[Len(aColImp)] + (nVlr * 2))
		ElseIf StrZero(nI, 2) $ "06/07/11"
			aAdd(aColImp, aColImp[Len(aColImp)] + (nVlr * 3))
		ElseIf StrZero(nI, 2) $ "03"
			aAdd(aColImp, aColImp[Len(aColImp)] + (nVlr * 6 ))
		ElseIf StrZero(nI, 2) $ "01/04"
			aAdd(aColImp, aColImp[Len(aColImp)] + nVlr)
		EndIf
	Next nI
	// Fim Cassiano em 22-05-13

	//Box, Linhas Verticais e Dados do Cabecalho de Pedido.
	//Cassiano 22-05-13
	ImpCabIt(nTopo)
	//Fim Cassiano 22-05-13

	//Inicializa as fun็๕es de impostos
	IniImp(cAlias)// Lucas Assis Mendes em 04/06/2013

	While (cAlias)->(!Eof()) .AND. (cAlias)->C5_NUM == cNPv

		//Testa se o limite da pagina para a impressao dos produtos.
		QbPgImp(nInicio,@nTopo,@nPag,nTotal,cNPv,cEMISSAO,cAlias)

		//Box, Linhas Verticais, Linhas Horizontais e Dados do Pedido.
		//		nTamDes := LEN(ALLTRIM(cAlias->C6_DESCRI)) / 45

		nTamDes  	:= 33
		aDescProd  	:= {}
		nTMens     	:= MlCount(AllTrim((cAlias)->C6_DESCRI),nTamDes)

		aadd(aDescProd,MemoLine(AllTrim((cAlias)->C6_DESCRI),nTamDes,1))

		For _nI := 2 To nTMens
			AADD(aDescProd,Memoline(AllTrim((cAlias)->C6_DESCRI),nTamDes,_nI))
		Next _nI

		For nX := 1 To Len(aDescProd)
			if nX == 1
				//Cassiano em 22-05-13
				ImpLinVert(nTopo)
				//Fim Cassiano em 22-05-13

				//Cassiano em 22-05-13
				ImpDadIt(nTopo, nCont, aDescProd[nX],cAlias,@cIpi,@nTotIpi)
				//Fim Cassiano em 22-05-13
			else
				nTopo := nTopo + 0050

				//Testa se o limite da pagina para a impressao dos produtos.
				QbPgImp(nInicio,@nTopo,@nPag,nTotal,cNPv,cEMISSAO,cAlias)

				//Cassiano em 22-05-13
				ImpLinVert(nTopo)
				//Fim Cassiano em 22-05-13

				oPrint:Say(nTopo + 0057, aColImp[03]+03, Alltrim(aDescProd[nX]),oFont2,100,,,PAD_LEFT)

				nTamStr := nTamStr + 45
			endif
		Next

		// Calculo do Valor Total do Produtos
		nTotal = nTotal + ((cAlias)->C6_PRCVEN * (cAlias)->C6_QTDVEN)

		nTopo := nTopo + 0050

		//Incrementa Contador da Quantidade de Itens
		nCont ++

		//Se o arquivo chegou ao fim, imprime rodape.
		If nCont > nCount

			//Linhas Horizontais  -  FIM PEDIDO
			oPrint:Line(nTopo + 0040,aColImp[01],nTopo + 0040,(nLimiteHoz))

			// Calculos diversos dos itens
			TotCabIt(nTotal,nFrete,nTopo,nInicio,nDespesa,cAlias,nTotIpi)

			// Funcao de Impressao do Rodape. Parametro: Numero da linha atual
			IMPROD(@nPag, nTotal, @nTopo,cAlias)
		EndIf

		(cAlias)->(dbskip())
	EndDo

Return

/*/{Protheus.doc}	ImpDadIt
Impressao dos Campos dos Detalhes dos Produtos

@author				Cassiano Gon็alves Ribeiro
@since				22/05/2013
@return				Nil
/*/
Static Function ImpDadIt(nTopo, nCont, cDesc,cAlias,cIpi,nTotIpi)

	Local aLote		:= BscLote((cAlias)->C6_LOTECTL,(cAlias)->C6_PRODUTO)
	//	Local cOrigPrd	:= u_RetPOrig((cAlias)->C6_PRODUTO, aLote[1])

	oPrint:Say(nTopo + 0057, aColImp[01]+05, Ltrim((cAlias)->C6_ITEM)	   			,oFont2,100,,,PAD_LEFT)
	oPrint:Say(nTopo + 0057, aColImp[02]+05, Ltrim((cAlias)->C6_PRODUTO)   	   		,oFont2,100,,,PAD_LEFT)
	oPrint:Say(nTopo + 0057, aColImp[03]+03, Ltrim(cDesc /*cAlias->C6_DESCRI*/)		,oFont2,100,,,PAD_LEFT)
	oPrint:Say(nTopo + 0057, aColImp[04]+04, LTrim((cAlias)->C6_UM)					,oFont2,100,,,PAD_LEFT)
	oPrint:Say(nTopo + 0057, aColImp[06]-05, Alltrim(Transform((cAlias)->C6_QTDVEN	,PesqPict('SC6', 'C6_QTDVEN'))) ,oFont2,100,,,PAD_RIGHT)
	oPrint:Say(nTopo + 0057, aColImp[07]-05, Alltrim(Transform((cAlias)->C6_PRCVEN	,PesqPict('SC6', 'C6_VALOR')))	,oFont2,100,,,PAD_RIGHT)
	oPrint:Say(nTopo + 0057, aColImp[08]-05, Alltrim(Transform((cAlias)->C6_VALOR	,PesqPict('SC6', 'C6_VALOR')))	,oFont2,100,,,PAD_RIGHT)
	//	oPrint:Say(nTopo + 0057, aColImp[09]-07, cOrigPrd								,oFont2,100,,,PAD_RIGHT)
	oPrint:Say(nTopo + 0057, aColImp[10]-04, aLote[2]/*DTOC((cAlias)->C6_DTVALID)*/	,oFont2,100,,,PAD_RIGHT)

	dbSelectArea("SF4")
	dbSetOrder(1)
	dbSeek(xFilial("SF4") + (cAlias)->C6_TES)
	If SF4->F4_IPI == "S"
		//		oPrint:Say(nTopo + 0057, aColImp[11]-05, Alltrim(STR((cAlias)->B1_IPI,4,1))	,oFont2,100,,,1)
		cIpi := Alltrim(STR((cAlias)->B1_IPI,4,1))
	Else
		//		oPrint:Say(nTopo + 0057, aColImp[11]-05, "0.0"								,oFont2,100,,,1)
		cIpi := "0.0"
	EndIf
	SF4->(dbCloseArea())

	oPrint:Say(nTopo + 0057, aColImp[11]-05, Alltrim(cIpi)	,oFont2,100,,,1)

	// Soma o IPI
	nTotIpi := nTotIpi + VAL(cIpi)

	//Busca o valor dos impostos
	BscVlrIpst(cAlias)

	//ST
	oPrint:Say(nTopo + 0057, aColImp[12]-05, iif(MaFisRet(nCont, "IT_VALSOL") > 0,Alltrim(Transform(MaFisRet(nCont, "IT_VALSOL"),PesqPict('SC6', 'C6_VALOR'))),"0,00")		,oFont2,100,,,1)

Return

/*/{Protheus.doc}	BscLote


@author				Lucas Assis Mendes
@since				24/06/2013
@return				Nil
/*/
Static Function BscLote(cLote, cProduto)

	Local cAliasLote:= GetNextAlias()
	Local aRet		:= {"",""}

	//if Alltrim(cLote) = ''
	// Query que retorna o lote com menor validade
	cQuery := "SELECT MIN(SB8.B8_DTVALID) B8_DTVALID, SB8.B8_LOTECTL "																				+CRLF
	cQuery += "  FROM " + RetSqlName("SB8")+ " SB8"																						+CRLF
	cQuery += " WHERE SB8.B8_FILIAL = '"+ xFilial("SB8")+ "' AND SB8.B8_PRODUTO = '"+ cProduto + "' AND SB8.D_E_L_E_T_ = ' ' "+CRLF
	cQuery += "	GROUP BY SB8.B8_LOTECTL ,B8_DTVALID"																					+CRLF
	cQuery += "	ORDER BY SB8.B8_DTVALID ASC"																							+CRLF

	TCQUERY cQuery NEW ALIAS &cAliaslote

	TcSetField(cAliasLote, "B8_DTVALID", "D")

	(cAliasLote)->(dbGoTop())

	if (cAliasLote)->(!Eof())
		//cLote := (cAliasLote)->B8_LOTECTL
		aRet[1] := iif(empty(cLote), (cAliasLote)->B8_LOTECTL, cLote)
		aRet[2] := dtoc((cAliasLote)->B8_DTVALID)
	endif

	(cAliasLote)->(dbCloseArea())

Return aRet
/*/{Protheus.doc}	ImpLinVert
Imprime - Linhas Verticais - Divisao de Colunas das linhas de dados dos itens

@author				Cassiano Gon็alves Ribeiro
@since				22/05/2013
@return				Nil
/*/
Static Function ImpLinVert(nTopo)

	Local nI := 0

	//Linhas Verticais
	for nI:= 1 to Len(aColImp)
		oPrint:Line(nTopo+30, aColImp[nI],nTopo + 090,aColImp[nI])
	next nI

Return
/*/{Protheus.doc}	ImpCabIt
Cabe็alho dos itens do relat๓rio e seus objetos

@author				Cassiano Gon็alves Ribeiro
@since				22/05/2013
@return				Nil
/*/
Static Function ImpCabIt(nTopo)

	Local nI := 0

	nLargura := aColImp[03] + aColImp[04]


	// Box
	oPrint:Box(nTopo, aColImp[01], nTopo + 0050, aColImp[12])

	//Linhas Verticais
	for nI:= 2 to Len(aColImp) -1
		oPrint:Line(nTopo, aColImp[nI],nTopo + 0050,aColImp[nI])
	next nI

	// Texto
	oPrint:Say(nTopo + 0007,aColImp[01]+05,"Item"				   		,oFont3,100,,,PAD_LEFT)
	oPrint:Say(nTopo + 0007,aColImp[02]+05,"Produto"					,oFont3,100,,,PAD_LEFT)
	oPrint:Say(nTopo + 0007,aColImp[03]+05,"Descri็ใo do Produto"		,oFont3,100,,,PAD_LEFT)
	oPrint:Say(nTopo + 0007,aColImp[04]+05,"UN"							,oFont3,100,,,PAD_LEFT)
	oPrint:Say(nTopo + 0007,aColImp[06]-05,"Qtd."						,oFont3,100,,,PAD_RIGHT)
	oPrint:Say(nTopo + 0007,aColImp[07]-05,"Pr็ Unitแrio"				,oFont3,100,,,PAD_RIGHT)
	oPrint:Say(nTopo + 0007,aColImp[08]-05,"Pr็ Total"					,oFont3,100,,,PAD_RIGHT)
	oPrint:Say(nTopo + 0007,aColImp[09]-07,"Origem"						,oFont3,100,,,PAD_RIGHT)
	oPrint:Say(nTopo + 0007,aColImp[10]-04,"Validade"					,oFont3,100,,,PAD_RIGHT)
	oPrint:Say(nTopo + 0007,aColImp[11]-05,"IPI %"	   					,oFont3,100,,,PAD_RIGHT)
	oPrint:Say(nTopo + 0007,aColImp[12]-05,"ST"		   					,oFont3,100,,,PAD_RIGHT)

Return

/*/{Protheus.doc}	TotCabIt
Calculos diversos dos itens

@author				Lucas Assis Mendes
@since				03/06/2013
@param				nTotal,nFrete,nTopo,nInicio,nDespesa
@return				Nil
/*/
Static Function TotCabIt(nTotal,nFrete,nTopo,nInicio,nDespesa,cAlias,nTotIpi)

	Local nTotST		:= MaFisRet(,"NF_VALSOL")
	Local nTotDescon	:= MaFisRet(,"NF_DESCONTO")
	Local nValorTotal 	:= 0

	nFrete 		:=  (cAlias)->C5_FRETE
	nDespesa 	:= 	(cAlias)->C5_DESPESA

	nValorTotal := (nTotal + nFrete + nTotST + nDespesa) - nTotDescon


	//Box - Valor Total
	oPrint:Box(nTopo + 0060, nInicio + 1638, nTopo + 0408, nInicio + LARG_PAG)
	oPrint:Line(nTopo + 0060, nInicio + 2135,nTopo + 0408, nInicio + 2135)

	//Dados - Valor Total
	oPrint:Say(nTopo + 0065, nInicio + DESC_TOT, "Valor das Mercadorias"											,oFont3,100,,,0)
	oPrint:Say(nTopo + 0065, nInicio + TOTAL_TOT, " " + Alltrim(Transform(nTotal,PesqPict('SC6', 'C6_VALOR')))		,oFont3,100,,,1)
	oPrint:Say(nTopo + 0115, nInicio + DESC_TOT, "Valor Desconto"													,oFont3,100,,,0)
	oPrint:Say(nTopo + 0115, nInicio + TOTAL_TOT, " " + Alltrim(Transform(nTotDescon,PesqPict('SC5', 'C5_DESPESA')))	,oFont3,100,,,1)
	oPrint:Say(nTopo + 0165, nInicio + DESC_TOT, "IPI"																,oFont3,100,,,0)
	oPrint:Say(nTopo + 0165, nInicio + TOTAL_TOT, " " + Alltrim(Transform(nTotIpi,PesqPict('SC6', 'C6_VALOR')))		,oFont3,100,,,1)
	oPrint:Say(nTopo + 0215, nInicio + DESC_TOT, "ICMS ST"															,oFont3,100,,,0)
	oPrint:Say(nTopo + 0215, nInicio + TOTAL_TOT, " " + Alltrim(Transform(nTotST,PesqPict('SC6', 'C6_VALOR')))		,oFont3,100,,,1)
	oPrint:Say(nTopo + 0265, nInicio + DESC_TOT, "Valor Despesa"													,oFont3,100,,,0)
	oPrint:Say(nTopo + 0265, nInicio + TOTAL_TOT, " " + Alltrim(Transform(nDespesa,PesqPict('SC5', 'C5_DESPESA')))	,oFont3,100,,,1)
	oPrint:Say(nTopo + 0315, nInicio + DESC_TOT, "Valor Frete"														,oFont3,100,,,0)
	oPrint:Say(nTopo + 0315, nInicio + TOTAL_TOT, " " + Alltrim(Transform(nFrete,PesqPict('SC5', 'C5_FRETE')))		,oFont3,100,,,1)
	oPrint:Say(nTopo + 0365, nInicio + DESC_TOT, "Valor Total"														,oFont3,100,,,0)
	oPrint:Say(nTopo + 0365, nInicio + TOTAL_TOT, " " + Alltrim(Transform(nValorTotal,PesqPict('SC6', 'C6_VALOR')))	,oFont3,100,,,1)

	//Fecha Dados fiscais
	MaFisEnd()
	MaFisRestore()

Return

/*/{Protheus.doc}	BscVlrIpst
Busca o valor dos impostos

@author				Lucas Assis Mendes
@since				04/06/2013
@return				Nil
/*/
Static Function BscVlrIpst(cAlias)

	MaFisAdd(	(cAlias)->C6_PRODUTO	,;	// 1-Codigo do Produto ( Obrigatorio )
	(cAlias)->C6_TES		,;	// 2-Codigo do TES ( Opcional )
	(cAlias)->C6_QTDVEN	,;	// 3-Quantidade ( Obrigatorio )
	(cAlias)->C6_PRCVEN	,;	// 4-Preco Unitario ( Obrigatorio )
	0					,;	// 5-Valor do Desconto ( Opcional )
	""					,;	// 6-Numero da NF Original ( Devolucao/Benef )
	""					,;	// 7-Serie da NF Original ( Devolucao/Benef )
	0					,;	// 8-RecNo da NF Original no arq SD1/SD2
	0					,;	// 9-Valor do Frete do Item ( Opcional )
	0					,;	// 10-Valor da Despesa do item ( Opcional )
	0					,;	// 11-Valor do Seguro do item ( Opcional )
	0					,;	// 12-Valor do Frete Autonomo ( Opcional )
	(cAlias)->C6_VALOR	,;	// 13-Valor da Mercadoria ( Obrigatorio )
	0					)	// 14-Valor da Embalagem ( Opiconal )

Return

Static Function IMPROD(nPag, nTotal, nTopo,cAlias)

	Local nInicio		:= 0000  // Indica a posicao da primeira coluna

	If nTopo <= (Mm2Pix(oPrint, oPrint:nVertSize()) - 0600)

		//Funcao para imprimir rodap้
		ImpDadRd(nInicio, nPag, nTopo,cAlias) // Lucas Assis Mendes 03/06/2013
	Else
		//Encerra a Pagina Atual
		oPrint:EndPage()

		//Inicia uma Nova Pagina para Impressao
		oPrint:StartPage()

		//Define o modo de Impressใo como Retrato
		oPrint:SetPortrait()  //SetLandscape -> Para definir como modo Paisagem

		//Funcao para impressao do Cabecalho
		IMPCAB(cNPv, cEMISSAO,cAlias)
		nTopo := 0420

		nPag += 1

		//Funcao para imprimir rodap้
		ImpDadRd(nInicio, nPag, nTopo,cAlias) // Lucas Assis Mendes 03/06/2013
	EndIf

Return
/*/{Protheus.doc}	QbPgImp
Controle de Quebra de Pagina

@author				Lucas Assis Mendes
@since				07/06/2013
@param				nInicio,nTopo,NPag,nTotal,cNPv,cEMISSAO
@return				Nil
/*/
Static Function QbPgImp(nInicio,nTopo,nPag,nTotal,cNPv,cEMISSAO,cAlias)

	If (nTopo + 0100) >= 2700

		//Linhas Horizontais  -  FIM PEDIDO
		oPrint:Line(nTopo + 0040,nInicio + 0040,nTopo + 0040,nLimiteHoz /*nInicio + LARG_PAG*/)

		IMPROD(@nPag, nTotal, @nTopo,cAlias)

		//Inicia uma Nova Pagina para Impressao
		oPrint:StartPage()

		//Define o modo de Impressใo como Retrato
		oPrint:SetPortrait()   //SetLandscape -> Para definir como modo Paisagem

		//Funcao para impressao do Cabecalho
		IMPCAB(cNPv, cEMISSAO,cAlias)

		// Incrementa o contador de Paginas
		nPag := nPag + 1

		nTopo := 0450

		//Box, Linhas Verticais e Dados do Cabecalho de Pedido.
		//Cassiano 22-05-13
		ImpCabIt(@nTopo)
		//Fim Cassiano 22-05-13
	EndIf

Return
/*/{Protheus.doc}	ImpDadRd
Imprime dados do rodap้

@author				Lucas Assis Mendes
@since				03/06/2013
@param				nInicio, nPag, nTopo
@return				Nil
/*/
Static Function ImpDadRd(nInicio, nPag, nTopo,cAlias)

	Local cFrete	:= (cAlias)->C5_TPFRETE

	// Box Condicoes Gerais
	oPrint:Box(Mm2Pix(oPrint, oPrint:nVertSize()) - 0800, nInicio + 0040, Mm2Pix(oPrint, oPrint:nVertSize()) - 0440, nInicio + LARG_PAG)

	// Titulo Centralizado
	oPrint:Say (Mm2Pix(oPrint, oPrint:nVertSize()) - 0790, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"Informa็๕es Gerais"		,oFont1,100,,,2)

	// Verifica o tipo do frete
	Do Case
		Case cFrete == "C"
		cFrete := "CIF"
		Case cFrete == "F"
		cFrete := "FOB"
		Otherwise
		cFrete := ""
	EndCase

	// Textos Posicionados เ Esquerda
	oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0750, nInicio + 0060,"Forma de Pagamento"  									,oFont3,100,,,0)
	oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0750, nInicio + 0450,": " + (cAlias)->C5_CONDPAG + " - " + (cAlias)->E4_DESCRI	,oFont5,100,,,0)
	oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0700, nInicio + 0060 ,"Vendedor" 					 	   					,oFont3,100)
	oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0700, nInicio + 0450 ,": (" + (cAlias)->C5_VEND1 + ") " + (cAlias)->A3_NOME	,oFont5,100)
	//oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0650, nInicio + 0060 ,"Validade" 					 	   					,oFont3,100)
	//oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0650, nInicio + 0450 ,": "      	 										,oFont5,100)
	oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0650, nInicio + 0060 ,"Tipo Frete"  										,oFont3,100)
	oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0650, nInicio + 0450 ,": " + cFrete 										,oFont5,100)
	oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0600, nInicio + 0060 ,"Fone Comercial"  									,oFont3,100)
	//	oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0600, nInicio + 0450 ,": " + GetMv("ZZ_FONECOM")							,oFont5,100)
	oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0550, nInicio + 0060 ,"E-mail Vendedor"  									,oFont3,100)
	oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0550, nInicio + 0450 ,": " + (cAlias)->A3_EMAIL								,oFont5,100)

	// Box para a Mensagem da Nota
	oPrint:Box(Mm2Pix(oPrint, oPrint:nVertSize()) - 0420, nInicio + 0040, Mm2Pix(oPrint, oPrint:nVertSize()) - 0120, nInicio + LARG_PAG)
	oPrint:Say (Mm2Pix(oPrint, oPrint:nVertSize()) - 0410, nInicio + 0060,"Mensagem" 			   							,oFont3,100,,,0)
	oPrint:Say (Mm2Pix(oPrint, oPrint:nVertSize()) - 0410, nInicio + 0250,": " + TRANSFORM((cAlias)->C5_MENNOTA,'@!S100') 	,oFont5,100,,,0)

	dbSelectArea("SM4")
	dbSetOrder(1)
	dbSeek(xFilial("SM4") + (cAlias)->C5_MENPAD)

	oPrint:Say (Mm2Pix(oPrint, oPrint:nVertSize()) - 0360, nInicio + 0250,"  " + ALLTRIM(SM4->M4_DESCR),oFont5,100,,,0)
	SM4->(dbCloseArea())

	//Imprime o Numero de Paginas
	oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0100, nInicio + 2360,"Pแgina: " + str(nPag) + " / " + AllTrim(nQtdPag)   ,oFont3,100,,,1)

	oPrint:EndPage()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออ"ฑฑ
ฑฑบPrograma  ณ Mm2Pix   บ Autor ณWaldir Baldin		   บ Data ณ  27/10/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna a Largura da Pagina em Pixel.						บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Mm2Pix(oPrint, nMm)
	/*Retirado metodo oPrint:nLogPixelX(), pois estava ocorrendo casos em clientes
	em que a linha impressa que utliza a funcao MM2PIX saia desconfigurada*/
	//Local nValor := (nMm * oPrint:nLogPixelX()) / 25.4
	Local nValor := (nMm * 300) / 25.4
Return nValor

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValidPerg บAutor  ณHermes Vieira Jr.   บ Data ณ  15/01/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida se existe um grupo de perguntas caso contrario o    บฑฑ
ฑฑบ          ณ o grupo de perguntas e criado.                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8 - DB2                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ValidPerg(cPerg)

	Local _sAlias := Alias()
	Local aRegs := {}
	Local i,j

	dbSelectArea("SX1")
	dbSetOrder(1)
	//cPerg := PADR(cPerg,6)
	aPergunte := FWSX1Util():GetGroup(cPerg)
	cPerg := PADR(cPerg,Len(aPergunte[1,1] ))

	// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
	aAdd(aRegs, {cPerg, "01", "Pedido de "        			,"" ,"" ,"mv_ch1", "C", 06, 0, 0, "G", "", "mv_par01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SC5"})
	aAdd(aRegs, {cPerg, "02", "Pedido at้ "        			,"" ,"" ,"mv_ch2", "C", 06, 0, 0, "G", "", "mv_par02", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SC5"})
	aAdd(aRegs, {cPerg, "03", "Data de "        			,"" ,"" ,"mv_ch3", "D", 08, 0, 0, "G", "", "mv_par03", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
	aAdd(aRegs, {cPerg, "04", "Data at้ "        			,"" ,"" ,"mv_ch4", "D", 08, 0, 0, "G", "", "mv_par04", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
	//aAdd(aRegs, {cPerg, "05", "Produto de "     			,"" ,"" ,"mv_ch5", "C", 06, 0, 0, "G", "", "mv_par05", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
	//aAdd(aRegs, {cPerg, "06", "Produto at้ "     			,"" ,"" ,"mv_ch6", "C", 06, 0, 0, "G", "", "mv_par06", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
	//aAdd(aRegs, {cPerg, "03", "Onde Criar?"  			,"" ,"" ,"mv_ch3", "C", 08, 0, 0, "G", "", "mv_par03", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})

	FOR i := 1 to LEN(aRegs)
		IF !dbSeek(cPerg+aRegs[i,2])
			MsgAlert(" O item " + aRegs[i,2] + aRegs[i,3] + " do grupo de perguntas" + cPerg +  "nใo estแ cadastrado" + ", a partir de agora o grupo perguntas deverแ ser criado pelo configurador")
		EndIf
	NEXT
	dbSelectArea(_sAlias)
Return .T.