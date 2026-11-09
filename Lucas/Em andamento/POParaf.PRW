#INCLUDE "Eicpo150.ch"
#INCLUDE "AvPrint.ch"
#INCLUDE "Font.ch"
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"

#DEFINE INGLES                     1
#DEFINE PORTUGUES                  2
#DEFINE DLG_CHARPIX_H              15.1
#DEFINE DLG_CHARPIX_W               7.9

Static aMarcados := {}, nMarcados

//+-----------------------------------------------------------------------------------//
//|Empresa...: PARAFIX
//|Funcao....: POParaf
//|Autor.....: Fernando Pereira
//|Data......: 13 de Fevereiro de 2019, 08:00
//|Uso.......: SIGAEIC
//|Versao....: Protheus - 12
//|Descricao.: Impressão do PO em Crystal
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
User Function POPARAF()
	*-----------------------------------------*
	SetPrvt("CPOINT1P,LPOINT1P,CPOINT2P,LPOINT2P,CMARCA,LINVERTE")
	SetPrvt("APOS,AROTINA,BFUNCAO,NCONT")
	SetPrvt("NTOTAL,NTOTALGERAL,NIDIOMA,CCADASTRO,NPAGINA,ODLGIDIOMA")
	SetPrvt("NVOLTA,ORADIO1,LEND,OPRINT>,LINHA,PTIPO")
	SetPrvt("CINDEX,CCOND,NINDEX,NOLDAREA,OFONT1")
	SetPrvt("OFONT2,OFONT3,OFONT4,OFONT5,OFONT6,OFONT7")
	SetPrvt("OFONT8,OFONT9,OPRN,AFONTES,CCLICOMP,CTELCOM, CFAXCOM, CEMAILCOM ,ACAMPOS")
	SetPrvt("CNOMARQ,AHEADER,LCRIAWORK,CPICTQTDE,CPICT1TOTAL")
	SetPrvt("CPICT2TOTAL,CQUERY,OFONT10,OFNT,C2ENDSM0,C2ENDSA2")
	SetPrvt("CCOMMISSION,C2ENDSYT,CTERMS,CDESTINAT,CREPR,CCGC")
	SetPrvt("CNR,CPOINTS,I,N1,N2,NNUMERO")
	SetPrvt("BACUMULA,BWHILE,LPULALINHA,NTAM,CDESCRITEM,CREMARKS")
	SetPrvt("XLINHA,Per01,Per02,Per03,Per04,Per05,Per06,Per07,Per08","cSEQREL")

	Private cPerg     := "EICPO1"
	Private aButtons  := {}
	Private csim      := ""
	Private _PictPo   := "@!"
	Private cPictPeso := "999,999.9999
	Private nPLiqT    := 0
	Private nTotEmb   := 0
	//Private cNome2     := IF(GetMv("MV_ID_CLI")='S',SA1->A1_NOME,SY1->Y1_NOME)
	Private cNome2     := IF(GetMv("MV_ID_CLI")='S',SA1->A1_NOME,Posicione("SY1",1,xFilial("SY1")+SW2->W2_COMPRA,"Y1_NOME"))
	Private cTel2      := IF(GetMv("MV_ID_CLI")='S',"",SY1->Y1_TEL)
	Private	cFAX2      := IF(GetMv("MV_ID_CLI")='S',"",SY1->Y1_FAX)
	Private cEmail2	  := IF(GetMv("MV_ID_CLI")='S',"",SY1->Y1_EMAIL)

	//cPerg:=Padr(cPerg,10)

	cMarca      := GetMark()
	aMarcados   := {}
	lInverte    := .F.
	aPos        := {8,4,11,74}
	bFuncao     := {|| PO150Impr() }
	nCont       := 0
	nTotal      := 0
	nTotalGeral := 0
	nIdioma     := INGLES
	cCadastro   := STR0032 //"Seleção de Purchase Order"
	aRotina     := {{ STR0029,"AxPesqui"     , 0 , 1},;
		{ STR0030,"Eval(bFuncao)", 0 , 0}}

	SA5->(DBSETORDER(2))

	E_ARQCRW(.T.,.T.,.T.)

	dbSelectArea("SW2")
	SW2->(MarkBrow("SW2","W2_OK",,,,cMarca,,,,,"U_POSTMarca()")) //EMISSAO

	SA5->(DBSETORDER(1))

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: POSTMarca()
//|Descricao.: Marca de desmarca pedido para impressão
//|Observação:
//+-----------------------------------------------------------------------------------//
	*-----------------------------------------*
User Function POSTMarca()
	*-----------------------------------------*
	Local nPos := aScan(aMarcados,SW2->(RecNo()))

	If SoftLock("SW2")
		If SW2->W2_OK == cMarca
			SW2->W2_OK := ""
			If nPos > 0
				aDel(aMarcados,nPos)
				aSize(aMarcados,Len(aMarcados)-1)
			Endif
		Else
			SW2->W2_OK := cMarca
			If nPos = 0
				aAdd(aMarcados,SW2->(Recno()))
			Endif
		Endif
	Endif

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: PO150Impr()
//|Descricao.: Tela para impressão.
//|Observação:
//+-----------------------------------------------------------------------------------//
	*-----------------------------------------*
Static FUNCTION PO150Impr()
	*-----------------------------------------*
	//VERPERGSX1()
	//Pergunte(cPerg,.T. )

	oDlgIdioma := nVolta := oRadio1 := Nil
	lEnd := nil

	@ (9*DLG_CHARPIX_H),(10*DLG_CHARPIX_W) TO (17*DLG_CHARPIX_H),(45*DLG_CHARPIX_W) DIALOG oDlgIdioma TITLE AnsiToOem(STR0033) //"Seleção"

	@  8,10 TO 48,80 TITLE STR0034 //"Selecione o Idioma"

	nVolta:=0

	oRadio1 := oSend( TRadMenu(), "New", 17, 13, {STR0035,STR0036},{|u| If(PCount() == 0, nIdioma, nIdioma := u)}, oDlgIdioma,,,,,, .F.,, 55, 13,, .F., .T., .T. ) //"Inglês"###"Idioma Corrente"

	oSend( SButton(), "New", 01, 90,5, {|| Pergunte(cPerg,.T. )})
	oSend( SButton(), "New", 18, 90,1, {|| nVolta:=1, oSend(oDlgIdioma, "End")}, oDlgIdioma, .T.,,)
	oSend( SButton(), "New", 37, 90,2, {|| oSend(oDlgIdioma,"End")}, oDlgIdioma, .T.,,)

	ACTIVATE DIALOG oDlgIdioma CENTERED

	Per01 := mv_par01
	Per02 := mv_par02
	Per03 := mv_par03
	Per04 := mv_par04
	Per05 := mv_par05
	Per06 := mv_par06
	Per07 := mv_par07
	Per08 := mv_par08

	IF nVolta == 1
		PO150Report()
	Endif

Return(NIL)

//+-----------------------------------------------------------------------------------//
//|Funcao....: PO150Report()
//|Descricao.: Verifica se há pedidos marcados para inicio da impressão
//|Observação:
//+-----------------------------------------------------------------------------------//
	*-----------------------------------------*
Static FUNCTION PO150Report()
	*-----------------------------------------*
	cIndex    := cCond := nIndex := Nil
	nOldArea  := ALIAS()
	cCliComp  := ""
	CTELCOM   := ""
	CFAXCOM   := ""
	CEMAILCOM := ""
	aCampos   := {}
	cNomArq   := Nil
	aHeader   := {}
	lCriaWork :=.T.

	cPictQtde   := '@E 999,999,999.99'
	cPict1Total := '@E 999,999,999,999.99'
	cPict2Total := '@E 99,999,999,999,999.99'

	nMarcados := Len(aMarcados)

	If nMarcados == 0
		MsgInfo(STR0037,STR0038)
	Else
		dbSelectArea("SW2")

		Processa({|| PO150Det() })

		dbSelectArea("SW2")
		SW2->(dbGoTop())
	EndIf

	aMarcados := {}

Return .T.

//+-----------------------------------------------------------------------------------//
//|Funcao....: PO150Det()
//|Descricao.: Verifica pedidos marcados para chamada da função de Impressão
//|Observação:
//+-----------------------------------------------------------------------------------//
	*-----------------------------------------*
Static Function PO150Det()
	*-----------------------------------------*
	ProcRegua(nMarcados)

	For nMarcados:=1 To Len(aMarcados)

		SW2->(dbGoTo(aMarcados[nMarcados]))
		IncProc("Imprimindo...")

		nTotal  := nTotalGeral := 0
		nPagina := 1
		nCont   := 0
		cSEQREL := GETSXENUM("SY0","Y0_SEQREL")

		PO150Cabec()

		dbSelectArea("SW3")
		SW3->(dbSetOrder(1))
		SW3->(dbSeek(xFilial()+SW2->W2_PO_NUM))

		While SW3->(!Eof()) .AND.;
				SW3->W3_FILIAL == XFILIAL("SW3") .AND. ;
				SW3->W3_PO_NUM == SW2->W2_PO_NUM

			If SW3->W3_SEQ #0
				SW3->(dbSkip())
				LOOP
			Endif

			PO150Item()

			SW3->(dbSkip())

		Enddo

		nPLiqT    := 0
		nTotEmb   := 0

		If SW2->W2_PACKING <> 0
			//PO150Pack()
		EndIf

		cCliComp  := cNome2
		CTELCOM   := cTel2
		CFAXCOM   := cFAX2
		CEMAILCOM := cEmail2

		PO150Totais()
		PO150Doc()
		PO150Remarks()
		PO150Aprov()
		PO150Cargo(SW2->W2_PO_NUM)

		HEADER_P->AVG_C08_60 := cCliComp

		HEADER_P->AVG_C15_20 := Alltrim(TRANS(SW2->W2_INLAND,E_TrocaVP(nIdioma,cPict2Total)))   // COLOCAR O INLAND CHARGE
		HEADER_P->AVG_C16_20 := Alltrim(TRANS(SW2->W2_PACKING,E_TrocaVP(nIdioma,cPict2Total)))  // COLOCAR O PAKING CHARGE
		HEADER_P->AVG_C17_20 := Alltrim(TRANS(SW2->W2_FRETEIN,E_TrocaVP(nIdioma,cPict2Total)))  // COLOCAR O INT'L FREIGHT

		//	HEADER_P->AVG_C14_30 := "Phone : "+CTELCOM
		//	HEADER_P->AVG_C15_30 := "Fax     : "+CFAXCOM
		//	HEADER_P->AVG_C16_30 := "E-mail: "+CEMAILCOM

		HEADER_P->AVG_C03_30 := Alltrim(DATA_MES(SW2->W2_PO_DT))

		//HEADER_P->AVG_C11_60 := SW2->W2_DES_IPI // Description of package

		dbSelectArea("SW2")

		SW2->(RecLock("SW2",.F.))
		SW2->W2_EMITIDO := "S" //PO Impresso
		SW2->W2_OK      := ""  //PO Desmarcado
		SW2->(MsUnLock())

		AvgCrw32("POPARAF.RPT","PURCHASE ORDER - " + AllTrim(SW2->W2_PO_NUM),cSEQREL)

	Next

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: PO150Cabec()
//|Descricao.: Preenche dados do cabeçalho
//|Observação:
//+-----------------------------------------------------------------------------------//
	*-----------------------------------------*
Static FUNCTION PO150Cabec()
	*-----------------------------------------*
	c2EndSM0 := c2EndSA2 := cCommission := c2EndSYT := cTerms := ""
	cDestinat := cRepr := cCGC := cNr := cDestino := cPais := cOrigem := ""

	HEADER_P->(DBAPPEND())
	HEADER_P->AVG_SEQREL := cSEQREL
	HEADER_P->AVG_CHAVE  := SW2->W2_PO_NUM
	HEADER_P->AVG_C06_20 := SW2->W2_NR_PRO // Numero da Proforma
	HEADER_P->AVG_C20_20 := Alltrim(DATA_MES(SW2->W2_DT_PRO)) // Data da Proforma

	SYT->( DBSETORDER( 1 ) )
	SYT->( DBSEEK( xFilial("SYT")+SW2->W2_IMPORT ) )

	IF GetMv("MV_ID_CLI") == 'S'
		//-----------> Cliente.
		SA1->( DBSETORDER( 1 ) )
		SA1->( DBSEEK( xFilial("SA1")+SW2->W2_CLIENTE ) )
	ELSE
		// --------->  Comprador.
		SY1->( DBSETORDER(1) )
		SY1->( DBSEEK( xFilial("SY1")+SW2->W2_COMPRA ) )
	ENDIF

	//----------->  Fornecedor.
	SA2->( DBSETORDER( 1 ) )
	SA2->( DBSEEK( xFilial()+SW2->W2_FORN+SW2->W2_FORLOJ ) )
	cNomeA2	 := SA2->A2_NOME
	cEndA2	 := Alltrim(SA2->A2_END)//+" - "+Alltrim(SA2->A2_BAIRRO)
	cContato := SA2->A2_CONTATO
	cTel	 := SA2->A2_COMPLEMEM // Alltrim(SA2->A2_DDI)+" "+Alltrim(SA2->A2_DDD)+" "+SA2->A2_TEL
	cFax	 := "" //Alltrim(SA2->A2_DDI)+" "+Alltrim(SA2->A2_DDD)+" "+SA2->A2_FAX
	cEmail	 := SA2->A2_EMAIL //SA2->A2_X_MAIL //SA2->A2_EMAIL

	//----------->  Paises.
	SYA->( DBSETORDER( 1 ) )
	SYA->( DBSEEK( xFilial()+SA2->A2_PAIS ) )
	c2EndSM01 := IF( !EMPTY(SA2->A2_MUN   ), ALLTRIM(SA2->A2_MUN   )+' - ', "" )
	//c2EndSM02 := Alltrim(SA2->A2_BAIRRO) + " - "+IF( !EMPTY(SA2->A2_BAIRRO), ALLTRIM(SA2->A2_BAIRRO)+' - ', "" )
	c2EndSM03 := IF( !EMPTY(SA2->A2_ESTADO), ALLTRIM(SA2->A2_ESTADO)+' - ', "" )+ IF( !EMPTY(SYA->YA_PAIS_I ), ALLTRIM(SYA->YA_PAIS_I )+' - ', "" )
	c2EndSA2 := Alltrim(SA2->A2_BAIRRO)+" - "+ IF( !EMPTY(SYA->YA_PAIS_I ), ALLTRIM(SYA->YA_PAIS_I )+'  ', "" )
	//c2EndSA2 := LEFT( c2EndSA2, LEN(c2EndSA2)-2 )

	//-----------> Pedidos.
	IF SW2->W2_COMIS $ cSim
		//cCommission :=SW2->W2_MOEDA+" "+TRANS(SW2->W2_VAL_COM,E_TrocaVP(nIdioma,'@E 9,999,999,999.9999'))
		cCommission :=SW2->W2_ZZMOED+" "+TRANS(SW2->W2_VAL_COM,E_TrocaVP(nIdioma,'@E 9,999,999,999.9999'))
		IF( SW2->W2_TIP_COM == "1", cCommission:=TRANS(SW2->W2_PER_COM,E_TrocaVP(nIdioma,'@E 999.99'))+"%", )
			IF( SW2->W2_TIP_COM == "4", cCommission:=SW2->W2_OUT_COM, )
			ENDIF

			//----------->  Fornecedor.
			SA2->( DBSETORDER( 1 ) )
			SA2->( DBSEEK( xFilial()+SW2->W2_FORN+SW2->W2_FORLOJ ) )

			cNome     := ALLTRIM(SYT->YT_NOME)
			c2EndSM01 := alltrim(SYT->YT_ENDE)+" "+alltrim(SYT->YT_NR_END)+" - "+alltrim(SYT->YT_BAIRRO)
			c2EndSM02 := IF( !EMPTY(SYT->YT_CIDADE), ALLTRIM(SYT->YT_CIDADE)+' - ', "" )+IF( !EMPTY(SYT->YT_ESTADO), ALLTRIM(SYT->YT_ESTADO), "" )
			c2EndSM03 := IF( !EMPTY(SYT->YT_CEP), TRANS(SYT->YT_CEP,"@R 99999-999"), "" ) + " - "+ IF( !EMPTY(ALLTRIM(SM0->M0_CGC)), "CNPJ: "+TRANS(SM0->M0_CGC,"@R 99.999.999/9999-99"), "" )

			HEADER_P->AVG_C11_60 := cNome
			HEADER_P->AVG_C13_60 := c2EndSM01
			HEADER_P->AVG_C14_60 := c2EndSM02
			HEADER_P->AVG_C24_60 := c2EndSM03

			//-----------> Portos.
			SY9->( DBSETORDER( 2 ) )
			SY9->( DBSEEK( xFilial()+SW2->W2_DEST ) )

			cDestinat := ALLTRIM(SW2->W2_DEST) + " - " + ALLTRIM(SY9->Y9_DESCR)

			//-----------> Agentes Embarcadores.
			SY4->( DBSETORDER( 1 ) )
			SY4->( DBSEEK( xFilial()+SW2->W2_FORWARD ) )
			HEADER_P->AVG_C09_60 := Alltrim(SY4->Y4_NOME)

			//-----------> Agentes Compradores.
			SY1->(DBSEEK(xFilial()+SW2->W2_COMPRA))

			//-----------> Produtos X Fornecedor.
			dbSelectArea("SW3")
			SW3->(dbSetOrder(1))
			SW3->(dbSeek(xFilial()+SW2->W2_PO_NUM))

			SA5->( DBSETORDER( 12 ) )
			SA5->( DBSEEK( xFilial()+SW3->W3_FABR+SW3->W3_FABLOJ+SW3->W3_COD_I ) )
			cCodFor := SA5->A5_FABR

			If TRIM(cCodFor) == ""
				SA2->( DBSETORDER( 1 ) )
				SA2->( DBSEEK( xFilial()+SW3->W3_FABR+"01" ) )
				cPais := SA2->A2_PAIS
			Else
				SA2->( DBSETORDER( 1 ) )
				SA2->( DBSEEK( xFilial()+cCodFor ) )
				cPais := SA2->A2_PAIS
			EndIf

			SYA->( DBSETORDER( 1 ) )
			SYA->( DBSEEK( xFilial()+cPais ) )
			cOrigem := SYA->YA_PAIS_I

			//-----------> País Origem
			SYR->(DBSETORDER(1))
			SYR->(DBSEEK(xFilial("SYR")+SW2->W2_TIPO_EM+SW2->W2_ORIGEM))
			cCodOr := SYR->YR_PAIS_OR

			SYA->( DBSETORDER( 1 ) )
			SYA->( DBSEEK( xFilial()+cCodOr ) )
			cPOrigem := SYA->YA_PAIS_I	//SIGLA

			// Fornecedor
			HEADER_P->AVG_C01_60 := Alltrim(cNomeA2)
			HEADER_P->AVG_C02_60 := Alltrim(cEndA2)
			HEADER_P->AVG_C03_60 := Alltrim(c2EndSA2) //+" ,"+" "+Alltrim(Transform(SA2->A2_CEP,"99999999"))

			// Place of Delivery
			//HEADER_P->AVG_C04_60 := Alltrim(SM0->M0_NOME)
			//HEADER_P->AVG_C05_60 := Alltrim(SM0->M0_ENDENT)
			//HEADER_P->AVG_C06_60 := Alltrim(SM0->M0_CIDENT)+" - "+Alltrim(SM0->M0_ESTENT)+" - Brazil"
			//HEADER_P->AVG_C01_10 := Alltrim(Transform(SM0->M0_CEPENT,"@E 99999-999"))

			cRepr:=IF(nIdioma==INGLES,cContato,cContato)

			//HEADER_P->AVG_C08_30 := Alltrim(cContato)
			HEADER_P->AVG_C01_20 := Alltrim(cEmail)
			//HEADER_P->AVG_C02_20 := Alltrim(cFax)
			HEADER_P->AVG_C05_60 := Alltrim(cTel)
			HEADER_P->AVG_C04_30 := Alltrim(cOrigem)
			//ALTERADO FERNANDO -> INCLUSO  :_cQrySya += "AND SYR.YR_VIA    = '" + SW2->W2_TIPO_EM + "' "  VIA DE TRANSPORTE
			_cQrySya := "SELECT SYA.YA_DESCR "
			_cQrySya += "FROM " + RetSqlName("SYA") + " SYA "
			_cQrySya += "WHERE	SYA.D_E_L_E_T_ = '' "
			//_cQrySya += "AND SYA.YA_FILIAL = '" + xFilial("SYA") + "' "
			//_cQrySya += "AND SYA.YA_CODGI = (	SELECT SYR.YR_PAIS_DE "
			//_cQrySya += "						FROM " + RetSqlName("SYR") + " SYR "
			//_cQrySya += "						WHERE	SYR.D_E_L_E_T_ = '' "
			//_cQrySya += "								AND SYR.YR_FILIAL = '" + xFilial("SYR") + "' "
			//_cQrySya += "								AND SYR.YR_VIA    = '" + SW2->W2_TIPO_EM + "' "
			//_cQrySya += "								AND SYR.YR_ORIGEM = '" + SW2->W2_ORIGEM + "' "
			//_cQrySya += "								AND SYR.YR_DESTINO = '" + SW2->W2_DEST + "' ) "

			If Select("TRBSYA") > 0
				TRBSYA->(DbCloseArea())
			Endif

			Tcquery	_cQrySya New Alias "TRBSYA"

			HEADER_P->AVG_C05_30 := Posicione("SY9",2,xFilial("SY9")+SW2->W2_DEST,"Y9_CIDADE") //"Country of Final Destination: "
			HEADER_P->AVG_C06_30 := SYR->YR_CID_ORI                //Alltrim(SW2->W2_ORIGEM)
			HEADER_P->AVG_C03_20 := Alltrim(cPOrigem)           //"Country of Shipment: "
			HEADER_P->AVG_C02_30 := Alltrim(SY1->Y1_NOME) //

			//HEADER_P->AVG_C07_20 := AllTrim(Transf(nPLiqT,cPictPeso))          // Pelo Liquido Total Net Weight
			HEADER_P->AVG_C04_20 := AllTrim(Transf(SW2->W2_PESO_B,cPictPeso))    // Peso Bruto Total Gross Weight

			//HEADER_P->AVG_C03_20 := Alltrim(SY1->Y1_TEL) //"Telephone: "
			//HEADER_P->AVG_C04_20 := Alltrim(SY1->Y1_FAX) //"Fax: "
			//HEADER_P->AVG_C04_30 := Alltrim(SY1->Y1_EMAIL)

			Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: PO150Item()
//|Descricao.: Preenche dados dos itens
//|Observação:
//+-----------------------------------------------------------------------------------//
			*-----------------------------------------*
Static FUNCTION PO150Item()
	*-----------------------------------------*
	cDescrItem := ""

	DETAIL_P->(DBAPPEND())
	DETAIL_P->AVG_SEQREL := cSEQREL
	DETAIL_P->AVG_CHAVE  := SW2->W2_PO_NUM

	DETAIL_P->AVG_C05_20 := SW3->W3_PART_N


	//-----------> Unidade Requisitante (C.Custo).
	SY3->( DBSETORDER( 1 ) )
	SY3->( DBSEEK( xFilial()+SW3->W3_CC ) )

	//-----------> Fornecedores.
	SA2->( DBSETORDER( 1 ) )
	SA2->( DBSEEK( xFilial()+SW3->W3_FABR ) )

	//-----------> Reg. Ministerio.
	SYG->( DBSETORDER( 1 ) )
	SYG->( DBSEEK( xFilial()+SW2->W2_IMPORT+SW3->W3_FABR+SW3->W3_COD_I ) )

	//-----------> Produtos (Itens) e Textos.
	SB1->( DBSETORDER( 1 ) )
	SB1->( DBSEEK( xFilial()+SW3->W3_COD_I ) )
	cCodItem := SB1->B1_COD

	nCont := nCont+1

	cDescrItem := MSMM(IF( nIdioma==INGLES, SB1->B1_DESC_I, SB1->B1_DESC_P ),240)

	IF Empty(cDescrItem)
		cDescrItem := SB1->B1_DESC
	Endif

	//DETAIL_P->AVG_C01_10 := "lote" //SW3->W3_XLOTECT //STRZERO(nCont,3)
	DETAIL_P->AVG_C01_20 := Alltrim(cCodItem)
	//DETAIL_P->AVG_C03_10 := Alltrim(SB1->B1_GRUPO)
	_cNcm := Posicione("SYD",1,xFilial("SYD")+SW3->W3_TEC,"YD_DESC_P")
	DETAIL_P->AVG_C03_60 := "NCM: "+Alltrim(SW3->W3_TEC)+"-"+Alltrim(_cNcm)

	//DETAIL_P->AVG_C05_10 := BUSCA_UM(SW3->W3_COD_I+SW3->W3_FABR+SW3->W3_FABLOJ+SW3->W3_FORN+SW3->W3_FORLOJ,SW3->W3_CC+SW3->W3_SI_NUM)
	//If SW3->W3_XTPUN == '2'
	//DETAIL_P->AVG_C05_10 := SW3->W3_XUN1
	If SW3->W3_XTPUN == '2'
		DETAIL_P->AVG_C05_10 := SW3->W3_XUN2
		DETAIL_P->AVG_C04_20 := Alltrim(TRANS(SW3->W3_XQTUN2,E_TrocaVP(nIdioma,cPictQtde)))
		DETAIL_P->AVG_C02_20 := Alltrim(TRANS(SW3->W3_XVLUN2,E_TrocaVP(nIdioma,'@E 999,999.99999')))
		DETAIL_P->AVG_C03_20 := Alltrim(TRANS(SW3->W3_XQTUN2*SW3->W3_XVLUN2,E_TrocaVP(nIdioma,cPict1Total)))
	Else
		DETAIL_P->AVG_C05_10 := DETAIL_P->AVG_C05_10 := BUSCA_UM(SW3->W3_COD_I+SW3->W3_FABR+SW3->W3_FABLOJ+SW3->W3_FORN+SW3->W3_FORLOJ,SW3->W3_CC+SW3->W3_SI_NUM)
		DETAIL_P->AVG_C04_20 := Alltrim(TRANS(SW3->W3_QTDE,E_TrocaVP(nIdioma,cPictQtde)))
		DETAIL_P->AVG_C02_20 := Alltrim(TRANS(SW3->W3_PRECO,E_TrocaVP(nIdioma,'@E 999,999.99999')))
		DETAIL_P->AVG_C03_20 := Alltrim(TRANS(SW3->W3_QTDE*SW3->W3_PRECO,E_TrocaVP(nIdioma,cPict1Total)))
	Endif
	DETAIL_P->AVG_C01100 := Alltrim(cDescrItem)
	//DETAIL_P->AVG_C04_20 := Alltrim(TRANS(SW3->W3_QTDE,E_TrocaVP(nIdioma,cPictQtde)))
	//DETAIL_P->AVG_C02_20 := Alltrim(TRANS(SW3->W3_PRECO,E_TrocaVP(nIdioma,'@E 999,999.99999')))
	//DETAIL_P->AVG_C03_20 := Alltrim(TRANS(SW3->W3_QTDE*SW3->W3_PRECO,E_TrocaVP(nIdioma,cPict1Total)))

	DETAIL_P->AVG_C01_10 := DTOC(SW3->W3_DT_EMB)
	//DETAIL_P->AVG_D02_08 := SW3->W3_DT_ENTR   --- alterado

	**** Embalagem
	//DETAIL_P->AVG_C05_10 := "qtd emb" //SW3->W3_XQTEMB  // Quantidade na Embalagem
	//DETAIL_P->AVG_C03_10 := "SW3->W3_XPEMB"   + " " +BUSCA_UM(SW3->W3_COD_I+SW3->W3_FABR+SW3->W3_FORN,SW3->W3_CC+SW3->W3_SI_NUM)// Package
	//DETAIL_P->AVG_C05_20 := "SW3->W3_XDESEMB" // Descriçao Embalagem

	nTotal := nTotal + SW3->W3_QTDE*SW3->W3_PRECO

	**** Analizar Fernando
	nPLiqT  += SW3->W3_QTDE
	nTotEmb += 00.00 //VaL(SW3->W3_XQTEMB)  // Quantidade na Embalagem

	HEADER_P->AVG_C07_20 := AllTrim(Transf(nPLiqT,cPictPeso))          // Pelo Liquido Total Net Weight
	HEADER_P->AVG_C01_10 := AllTrim(Transf(Str(nTotEmb,4,0),"9999"))  //AllTrim(Transf(Strzero(nTotEmb,4,0),"9999"))

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: PO150Pack()
//|Descricao.: Preenche valor do Packing do PO
//|Observação:
//+-----------------------------------------------------------------------------------//
	*-----------------------------------------*
Static FUNCTION PO150Pack()
	*-----------------------------------------*
	DETAIL_P->(DBAPPEND())
	DETAIL_P->AVG_SEQREL := cSEQREL
	DETAIL_P->AVG_CHAVE  := SW2->W2_PO_NUM

	nCont := nCont+1

	//DETAIL_P->AVG_C01_10 := STRZERO(nCont,3)
	//DETAIL_P->AVG_C01100 := "Packing"
	//DETAIL_P->AVG_C02_20 := Alltrim(TRANS(SW2->W2_PACKING,E_TrocaVP(nIdioma,'@E 999,999,999.999')))
	//DETAIL_P->AVG_C03_20 := Alltrim(TRANS(SW2->W2_PACKING,E_TrocaVP(nIdioma,cPict1Total)))

	//nTotal := nTotal + SW2->W2_PACKING

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: PO150Remarks()
//|Descricao.: Preenche Observações do PO
//|Observação:
//+-----------------------------------------------------------------------------------//
	*-----------------------------------------*
Static FUNCTION PO150Remarks()
	*-----------------------------------------*
	Local nTam:=140

	cRemarks := ""
	cRemarks := MSMM(SW2->W2_OBS,1800)

	HEADER_P->AVG_C04150:=MEMOLINE(cRemarks,nTam,1)
	HEADER_P->AVG_C05150:=MEMOLINE(cRemarks,nTam,2)
	HEADER_P->AVG_C06150:=MEMOLINE(cRemarks,nTam,3)
	HEADER_P->AVG_C15_60:=MEMOLINE(cRemarks,nTam,4)
	HEADER_P->AVG_C16_60:=MEMOLINE(cRemarks,nTam,5)

	//		HEADER_P->AVG_C09150:=MEMOLINE(cRemarks,nTam,6)
	//		HEADER_P->AVG_C10150:=MEMOLINE(cRemarks,nTam,7)
	//		HEADER_P->AVG_C11150:=MEMOLINE(cRemarks,nTam,8)
	//		HEADER_P->AVG_C12150:=MEMOLINE(cRemarks,nTam,9)
	//		HEADER_P->AVG_C13150:=MEMOLINE(cRemarks,nTam,10)
	//		HEADER_P->AVG_C14150:=MEMOLINE(cRemarks,nTam,11)
	//		HEADER_P->AVG_C15150:=MEMOLINE(cRemarks,nTam,12)

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: PO150Totais()
//|Descricao.: Preenche total do PO
//|Observação:
//+-----------------------------------------------------------------------------------//
	*-----------------------------------------*
Static FUNCTION PO150Totais()
	*-----------------------------------------*

	nTotSum := nTotal + SW2->W2_INLAND + SW2->W2_PACKING + SW2->W2_FRETEIN

	HEADER_P->AVG_C07_30 := Alltrim(TRANS(nTotal ,E_TrocaVP(nIdioma,cPict2Total)))
	HEADER_P->AVG_C08_30 := Alltrim(TRANS(nTotSum,E_TrocaVP(nIdioma,cPict2Total)))


Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: PO150Doc()
//|Descricao.: Informações complementares do Rodapé do PO
//|Observação:
//+-----------------------------------------------------------------------------------//
	*-----------------------------------------*
Static FUNCTION PO150Doc()
	*-----------------------------------------*
	Local aDados := FWGetSX5("Y3")

	cTerms := ""
	DtEmb  := ""
	DtETA  := ""

	//-----------> Condicoes de Pagamento.
	SY6->( DBSETORDER( 1 ) )
	SY6->( DBSEEK( xFilial()+SW2->W2_COND_PA+STR(SW2->W2_DIAS_PA,3,0) ) )

	IF nIdioma == INGLES
		cTerms := MSMM(SY6->Y6_DESC_I,48)
	ELSE
		cTerms := MSMM(SY6->Y6_DESC_P,48)
	ENDIF
	STRTRAN(cTerms, CHR(13)+CHR(10), " ")

	//-----------> Importador.
	SYT->( DBSETORDER( 1 ) )
	SYT->( DBSEEK( xFilial()+SW2->W2_IMPORT ) )

	//-----------> Agentes Embarcadores.
	SYQ->( DBSETORDER( 1 ) )
	SYQ->( DBSEEK( xFilial()+SW2->W2_TIPO_EMB ) )

	//-----------> Embarque.
	SW3->( DBSETORDER( 1 ) )
	SW3->( DBSEEK( xFilial()+SW2->W2_PO_NUM ) )
	DtEmb := DTOC(SW3->W3_DT_EMB)
	DtETA := SW3->W3_DT_ENTR

	HEADER_P->AVG_C07_60 := Alltrim(cTerms)          	//"Payment Terms:
	HEADER_P->AVG_C02_10 := Alltrim(SW2->W2_INCOTER) 	//"Delivery Terms:
	HEADER_P->AVG_C01_10 := DtEmb                    	//"Delivery Time:

	//LRS - 16/03/2015 - Pegar o tipo via Transporte de acordo com o Idioma do relatorio
	SX5->(DbSetOrder(1))
	SX5->(dbSeek(xFilial("SX5")+"Y3"+Alltrim(SubStr(SYQ->YQ_COD_DI,1,1))))

	For nAtual := 1 To Len(aDados)
		If nIdioma == INGLES
			HEADER_P->AVG_C05_20 := aDados[nAtual][4]
		ElseIF nIdioma == PORTUGUES
			HEADER_P->AVG_C05_20 := aDados[nAtual][4]
		ElseIF nIdioma == ESPANHOL
			HEADER_P->AVG_C05_20 := aDados[nAtual][4]
		EndIF

	Next nAtual



	//HEADER_P->AVG_C05_20 := Alltrim(SYQ->YQ_DESCR) 		// "Packing:

	//HEADER_P->AVG_C03_10 := Alltrim(SW2->W2_AGENTE)  	//"Transport Company:
	//HEADER_P->AVG_C07_20 := Alltrim(SYT->YT_NOME)    	//"Importer:
	//HEADER_P->AVG_D02_08 := DtETA                    	//"ETA:
	//HEADER_P->AVG_C04_10 := Alltrim(SW2->W2_MOEDA)  	// "Simbolo da Moeda
	HEADER_P->AVG_C04_10 := Alltrim(SW2->W2_ZZMOED)  	// "Simbolo da Moeda

	HEADER_P->AVG_C08_20 := "Cargo" //SY1->Y1_XCARGO 	//"Cargo Comprador
	//HEADER_P->AVG_C09_20 := Alltrim(Per02)          	//"Com. Invoice Copy:
	//HEADER_P->AVG_C10_20 := Alltrim(Per03)          	//"Packing List:
	//HEADER_P->AVG_C11_20 := Alltrim(Per04)          	//"AWB/ BL Original:
	//HEADER_P->AVG_C12_20 := Alltrim(Per05)          	//"AWB/ BL Copy:

Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: PO150Aprov()
//|Descricao.: Verifica aprovador
//|Observação:
//+-----------------------------------------------------------------------------------//
	*-----------------------------------------*
Static FUNCTION PO150Aprov()
	*-----------------------------------------*
	Local xAprov := "", aAprov:={"","","",""}
	Local cUser  := UsrFullName(SCR->CR_USER)
	Local cUser2 := UsrFullName(SAJ->AJ_USER)

	cAprov    := ""

	//-----------> Cadastro de Aprovadores
	SAL->(DBSETORDER(1))

	If SAL->(DBSEEK(xFilial("SAL")+Per06))
		cAprov := SAL->AL_COD

		aAprov:={"","","",""}
		nAprov:=1
		Do While !SAL->(EOF()) .and. cAprov == SAL->AL_COD .AND. nAprov <= 4

			xAprov:=Left(SAL->AL_DESC,30)

			aAprov[nAprov]:=xAprov

			//aadd(aAprov,xAprov)
			nAprov++
			SAL->(dbskip())
		EndDo

	EndIf

	***** novo
	cComprador:= ""
	cAlter	  := ""
	cAprov	  := ""
	lNewAlc	  := .F.
	lLiber 	  := .F.
	lRejeit	  := .F.

	cTipoSC7:= IIF((SC7->C7_TIPO == 1 .OR. SC7->C7_TIPO == 3),"PC","AE")

	If cTipoSC7 == "PC"

		dbSelectArea("SCR")
		dbSetOrder(1)
		If dbSeek(xFilial("SCR")+cTipoSC7+SW2->W2_PO_SIGA)
			cTst = ''
		Else
			If dbSeek(xFilial("SCR")+"IP"+SW2->W2_PO_SIGA)
				cTst = ''
			EndIf
		EndIf

	Else

		dbSelectArea("SCR")
		dbSetOrder(1)
		dbSeek(xFilial("SCR")+cTipoSC7+SW2->W2_PO_SIGA)
	EndIf

	If !Empty(SC7->C7_APROV) .Or. (Empty(SC7->C7_APROV) .And. SCR->CR_TIPO == "IP")

		lNewAlc := .T.
		cComprador := UsrFullName(SC7->C7_USER)
		If SC7->C7_CONAPRO != "B"
			IF SC7->C7_CONAPRO == "R"
				lRejeit	  := .T.
			Else
				lLiber    := .T.
			EndIf
		EndIf

		While !Eof() .And. SCR->CR_FILIAL+Alltrim(SCR->CR_NUM) == xFilial("SCR")+Alltrim(SC7->C7_NUM) .And. SCR->CR_TIPO $ "PC|AE|IP"
			cAprov += AllTrim(cUser)+" ["
			Do Case
			Case SCR->CR_STATUS=="02" //Pendente
				cAprov += "BLQ"
			Case SCR->CR_STATUS=="03" //Liberado
				cAprov += "Ok"
			Case SCR->CR_STATUS=="04" //Bloqueado
				cAprov += "BLQ"
			Case SCR->CR_STATUS=="05" //Nivel Liberado
				cAprov += "##"
			Case SCR->CR_STATUS=="06" //Rejeitado
				cAprov += "REJ"

			OtherWise                 //Aguar.Lib
				cAprov += "??"
			EndCase
			cAprov += "] - "
			dbSelectArea("SCR")
			dbSkip()
		Enddo
		If !Empty(SC7->C7_GRUPCOM)
			dbSelectArea("SAJ")
			dbSetOrder(1)
			dbSeek(xFilial("SAJ")+SC7->C7_GRUPCOM)
			While !Eof() .And. SAJ->AJ_FILIAL+SAJ->AJ_GRCOM == xFilial("SAJ")+SC7->C7_GRUPCOM
				If SAJ->AJ_USER != SC7->C7_USER
					If SAJ->(FieldPos("AJ_MSBLQL") > 0)
						If SAJ->AJ_MSBLQL == "1"
							dbSkip()
							LOOP
						EndIf
					EndIf
					cAlter += AllTrim(cUser2)+"/"
				EndIf
				dbSelectArea("SAJ")
				dbSkip()
			EndDo
		EndIf
	EndIf


	//HEADER_P->AVG_C02150 := xAprov

	//	Header_P->AVG_C09_30:= aAprov[1]
	//	Header_P->AVG_C10_30:= aAprov[2]
	//	Header_P->AVG_C11_30:= aAprov[3]
	//	Header_P->AVG_C12_30:= aAprov[4]


Return


//+-----------------------------------------------------------------------------------//
//|Funcao....: PO150Cargo(
//|Descricao.: Verifica Cargo
//|Observação:
//+-----------------------------------------------------------------------------------//
	*-----------------------------------------*
Static FUNCTION PO150Cargo(cPoNum)
	*-----------------------------------------*
	Local aCargos:={"","","",""}
	Local cAlias := GetNextAlias()
	Local cQuery := ""
	/*
	cCodAprov := ""
	cCargo	  := ""

	//-----------> Cadastro de Cargo de Aprovadores
	SAL->( DBSETORDER(1))
	If SAL->( DBSEEK( xFilial()+Per06))
		cAprov := SAL->AL_COD
		nCargo :=1
		Do While !SAL->(EOF()) .and. cAprov == SAL->AL_COD .AND. nCargo <= 4
			cCodAprov := SAL->AL_APROV
			SAK->(DBSETORDER(1))
			If SAK->(DBSEEK(xFilial()+cCodAprov))
				cNomeProv := Alltrim(SAK->AK_NOME)

				aCargos[nCargo]:=cNomeProv
				//AADD(aCargos,cCargo)
				nCargo++
			EndIf
			SAL->(dbskip())
		EndDo

		//Header_P->AVG_C13_30:= aCargos[1]
		Header_P->AVG_C04_30:= aCargos[1]
		//Header_P->AVG_C15_30:= aCargos[3]
		//Header_P->AVG_C16_30:= aCargos[4]


		//HEADER_P->AVG_C03150 := xCargos

	EndIf*/

	cQuery	:=	"SELECT "											
	cQuery	+=	"	AK_NOME "										
	cQuery	+=	"FROM "												
	cQuery	+=	"	"				+ RetSqlName("SCR")	+ " SCR "	
	cQuery	+=	"INNER JOIN " + RetSqlName("SAK")	+ " SAK ON"		
	cQuery	+=	"	AK_FILIAL = '"	+ xFilial("SAK")	+ "' AND "	
	cQuery	+=	"	AK_COD = CR_LIBAPRO AND "						
	cQuery	+=	"	SAK.D_E_L_E_T_ =  ' ' "							
	cQuery	+=	"WHERE "											
	cQuery	+=	"	CR_FILIAL = '"	+ xFilial("SCR")	+ "' AND "	
	cQuery	+=	"	CR_NUM = '"		+ cPoNum	+ "' AND"			
	cQuery	+=	"	CR_TIPO IN ('PC') AND "							
	cQuery	+=	"	CR_DATALIB <> ' ' AND "							
	cQuery	+=	"	CR_LIBAPRO <> ' ' AND "							
	cQuery	+=	"	SCR.D_E_L_E_T_ =  ' ' "							

	cQuery := ChangeQuery(cQuery)
		
	TcQuery cQuery New Alias &cAlias

	If !(Eof()) .and. !(Bof())
		Header_P->AVG_C04_30:= AllTrim((cAlias)->AK_NOME)
	Endif

	(cAlias)->(DbCloseArea())
Return

//+-----------------------------------------------------------------------------------//
//|Funcao....: DATA_MES(<x>)
//|Descricao.: Função para traz a a data e o mes.
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static Function DATA_MES(x)
	*-----------------------------------------*
	Local lRet := ""

	lRet := SUBSTR(DTOC(x),1,2)+" "+IIF(nIdioma == INGLES,SUBSTR(CMONTH(x),1,3),SUBSTR(Nome_Mes(MONTH(x)),1,3))+" "+LEFT(DTOS(x),4)

Return(lRet)

//+-----------------------------------------------------------------------------------//
//|Funcao....: VERPERGSX1()
//|Descricao.: Inclusão de Parametros no arquivo SX1
//|Observação:
//+-----------------------------------------------------------------------------------//
*-----------------------------------------*
Static FUNCTION VERPERGSX1()
	*-----------------------------------------*
	Local nX := 0
	Local nY := 0
	Local aAreaAnt := GetArea()
	Local aAreaSX1 := SX1->(GetArea())
	Local aRegistro := {}

	aRegistro:= {}
	AADD(aRegistro,{cPerg,"01","Invoice Original","mv_ch1","C", 2,0,0,"G","","mv_par01"})
	AADD(aRegistro,{cPerg,"02","Copia Invoice   ","mv_ch2","C", 2,0,0,"G","","mv_par02"})
	AADD(aRegistro,{cPerg,"03","Packing List    ","mv_ch3","C", 2,0,0,"G","","mv_par03"})
	AADD(aRegistro,{cPerg,"04","AWB/BL Original ","mv_ch4","C", 2,0,0,"G","","mv_par04"})
	AADD(aRegistro,{cPerg,"05","Copia AWB/BL    ","mv_ch5","C", 2,0,0,"G","","mv_par05"})
	AADD(aRegistro,{cPerg,"06","Grupo Aprovação ","mv_ch6","C", 6,0,0,"G","","mv_par06","SAL"})
	aAdd(aRegistro,{"X1_GRUPO","X1_ORDEM","X1_PERGUNT","X1_VARIAVL","X1_TIPO","X1_TAMANHO","X1_DECIMAL","X1_PRESEL","X1_GSC","X1_VALID","X1_VAR01","X1_F3"})

	dbSelectArea("SX1")
	dbSetOrder(1)
	For ny:=1 to Len(aRegistro)-1
		If !dbSeek(aRegistro[ny,1]+aRegistro[ny,2])
			SX1->(RecLock("SX1",.T.))
			For j:=1 to Len(aRegistro[ny])
				FieldPut(FieldPos(aRegistro[Len(aRegistro)][j]),aRegistro[ny,j])
			Next j
			SX1->(MsUnlock())
		EndIf
	Next ny
	RestArea(aAreaSX1)
	RestArea(aAreaAnt)

Return
