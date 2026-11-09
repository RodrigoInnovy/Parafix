#include 'protheus.ch'
#Include "topconn.ch"

#define OPERAC_INCLUI 3
#define PRODUTO_ORIGEM 1
#define DESC_PROD_ORIGEM 2
#define UM_ORIGEM 3
#define LOCAL_ORIGEM 4
#define ENDERECO_ORIGEM 5
#define PRODUTO_DESTINO 6
#define DESC_PROD_DESINO 7
#define UM_DESTINO 8
#define LOCAL_DESTINO 9
#define ENDERECO_DESTINO 10
#define LOTE_ORIGEM 11
#define VALIDADE_ORIGEM 12
#define QTD1 13
#define QTD2 14
#define LOTE_DESTINO 15
#define VALIDADE_DESTINO 16

#define CODIGO_SOLICITACAO 1
#define DATA_SOLICITACAO 2
#define SOLICITANTE 3
#define TIPO_DOCUMENTO 4
#define FILIAL_ORIGEM 5
#define FILIAL_DESTINO 6
#define PRODUTO_ORIG 7
#define PRODUTO_DEST 8
#define QUANTIDADE 9
#define LOCAL_ORIG 10
#define LOCAL_DEST 11
#define TES_SAIDA 12
#define TES_ENTRADA 13
#define ENDERECO_ORIG 14
#define ENDERECO_DEST 15
#define LOTE_ORIG 16
#define LOTE_DEST 17
#define VALIDADE_ORIG 18
#define VALIDADE_DEST 19


/*/{Protheus.doc} ControleDeRecebimento
Classe respons�vel pela cria��o de fun��es uteis para manipula��o dos status da personaliza��o de
controle de recebimento
@author Cassiano
@since 02/10/2017
@version 1.0
/*/
class ControleDeRecebimento

	data nIndice        as int
	data cAlias 		as String
	data cChaveStatus	as String //nota+serie+fornecedor+loja+lote+produto
	data cLote          as String
	data cNF            as String
	data cSerie         as String
	data cLoja          as String
	data cCodFor        as String
	data cNomFor        as String
	data cCodPro        as String
	data cDescPr        as String
	data nQtd1Um        as Float
	data cUM            as String
	data nQtd2Um        as Float
	data c2UM           as String
	data dDtMov         as Date
	data cHrMov         as String
	data dDtFim         as Date
	data cHrFim         as String
	data cStatus        as String
	data cDescSt        as String
	data lPorItem       as Boolean
	data lNumSeq        as Boolean
	data lPorLote       as Boolean
	data lEstorno       as Boolean
	data cItem          as String
	data cFil           as String
	data cNumSeq        as String
	data cNumCQ			as String
	data cItemNF		as String

	method newControleDeRecebimento() constructor
	method incluiStatus()
	method excluiStatus()
	method AtualizaDataFim()
	method AdicStatus()
	method incTransferencia()
	method IncSolicTransf()
	method EnderItem()
	method getAddQuery()

	//getters
	method getcStatus()
	method getcDescST()
	method getcChaveStatus()
	method getValue()
	method getcLote()
	method getcNF()
	method getcSerie()
	method getcLoja()
	method getcCodFor()
	method getcNomFor()
	method getcCodPro()
	method getcDescPr()
	method getnQtd1Um()
	method getcUM()
	method getnQtd2Um()
	method getc2UM()
	method getdDtMov()
	method getcHrMov()
	method getdDtFim()
	method getcHrFim()


	//setters
	method setcStatus()
	method setcChaveStatus()
	method setcLote()
	method setcNF()
	method setcSerie()
	method setcLoja()
	method setcCodFor()
	method setcNomFor()
	method setcCodPro()
	method setcDescPr()
	method setnQtd1Um()
	method setcUM()
	method setnQtd2Um()
	method setc2UM()
	method setdDtMov()
	method setcHrMov()
	method setdDtFim()
	method setcHrFim()
	method setcDescSt()
	method setnIndice()
	method setlPorItem()
	method setlPorLote()
	method setlEstorno()
	method setcItem()
	method setcFil()
	method setcNumSeq()
	method setlNumSeq()
	method setcNumCQ()
	method setcItemNF()
endclass

/*/{Protheus.doc} new
Metodo construtor
@author Cassiano
@since 02/10/2017 
@version 1.0
/*/
method newControleDeRecebimento() class ControleDeRecebimento
	::cAlias := "ZA1"
	::lPorItem := .F.
	::lNumSeq := .F.
	::lPorLote := .F.
	::lEstorno := .F.
	::cFil := xFilial(::cAlias)
return

/*/{Protheus.doc} AdicStatus
@author Evandro Simenes
@since 17/10/2017 
@version 1.0
/*/
method AdicStatus() class ControleDeRecebimento
	Local nStatus := val(::cStatus)
	Local cStatus := ""
	local cAliasSD1	:= GetNextAlias()
	Local cQuery := ""
	local cItemNF := ""
	local lInclui

	cQuery := ::getAddQuery()

	If !Empty(cQuery)

		TCQUERY cQuery NEW ALIAS &cAliasSD1

		(cAliasSD1)->(DBGotop())

		While (cAliasSD1)->(!Eof())
			/*
			IF Empty((cAliasSD1)->B1_TE)
				Alert("A TES do item "+(cAliasSD1)->B1_COD+" não está preenchida")
				loop
			ENDIF
		    */
			oCtrlRec := ControleDeRecebimento():newControleDeRecebimento()
			oCtrlRec:setcFil(::cFil)
			if ::lPorLote
				oCtrlRec:setcLote(::cLote)
			else
				oCtrlRec:setcLote((cAliasSD1)->D1_LOTECTL)
			endif

			oCtrlRec:setcNumSeq((cAliasSD1)->D1_NUMSEQ)
			oCtrlRec:setcNF((cAliasSD1)->D1_DOC)
			oCtrlRec:setcSerie((cAliasSD1)->D1_SERIE)
			oCtrlRec:setcLoja((cAliasSD1)->D1_LOJA)
			oCtrlRec:setcCodFor((cAliasSD1)->D1_FORNECE)
			oCtrlRec:setcCodPro((cAliasSD1)->D1_COD)
			oCtrlRec:setcUM((cAliasSD1)->D1_UM)
			oCtrlRec:setc2UM((cAliasSD1)->D1_SEGUM)
			oCtrlRec:setdDtMov(Date())
			oCtrlRec:setcHrMov(Substr(Time(),1,5))
			oCtrlRec:setcStatus(::cStatus)
			oCtrlRec:setcDescSt(::cDescST)
			oCtrlRec:setcItemNF((cAliasSD1)->D1_ITEM)
			cItemNF := (cAliasSD1)->D1_ITEM
			If ::cStatus == "5"
				oCtrlRec:setdDtFim(Date())
				oCtrlRec:setcHrFim(Substr(Time(),1,5))
				oCtrlRec:setcItem(::cItem)
			EndIf
			oCtrlRec:setcNomFor((cAliasSD1)->A2_NOME)
			oCtrlRec:setcDescPr((cAliasSD1)->B1_DESC)

			if ::lPorItem .or. ::lPorLote
				oCtrlRec:setnQtd1Um(::nQtd1Um)
				oCtrlRec:setnQtd2Um(::nQtd2Um)
			else
				oCtrlRec:setnQtd1Um((cAliasSD1)->D1_QUANT)
				oCtrlRec:setnQtd2Um((cAliasSD1)->D1_QTSEGUM)
			endif

			lInclui := oCtrlRec:incluiStatus()

			(cAliasSD1)->(dbSkip())
		End

		(cAliasSD1)->(DBCloseArea())

	End

	//Atualiza data fim do status anterior
	if nStatus > 1
		cStatus := alltrim(str(nStatus -1))
		oCtrlRec := ControleDeRecebimento():newControleDeRecebimento()
		oCtrlRec:setcFil(::cFil)
		if ::lPorItem
			oCtrlRec:setlPorItem(.T.)
			oCtrlRec:setcCodPro(::cCodPro)
			oCtrlRec:setnQtd1Um(::nQtd1Um)
			oCtrlRec:setnQtd2Um(::nQtd2Um)
		endif
		if ::lPorLote
			oCtrlRec:setlPorLote(.T.)
			oCtrlRec:setcLote(::cLote)
		endif

		oCtrlRec:setcNF(::cNF)
		oCtrlRec:setcSerie(::cSerie)
		oCtrlRec:setcCodFor(::cCodFor)
		oCtrlRec:setcLoja(::cLoja)
		oCtrlRec:setcStatus(cStatus)
		oCtrlRec:setdDtFim(Date())
		oCtrlRec:setcHrFim(Substr(Time(),1,5))
		oCtrlRec:setcItemNF(cItemNF)

		// Incluido o tratamento para a condi��o de Beneficiamento , conforme a nova regra definida pelo
		// Cliente em 24/04/2020 - Tratativa feita pelo analista Alexandre J. Conselvan - Totvs IP Campinas
		// ATen��o -- Este processo setamos a grava��o dos dados com a mesma informa��o pois o cliente
		// utilzia a op��o de retornar e todos os processos devem ser com a mesma data e hora
		if lInclui .or. SF1->F1_TIPO = "B"
			oCtrlRec:AtualizaDataFim()
		endif
	endif

return

/*/{Protheus.doc} incluiStatus
Inclui status do controle de recebimento
@author Cassiano
@since 02/10/2017 
@version 1.0
/*/
method incluiStatus() class ControleDeRecebimento
	local aArea := GetArea()
	local cNxtAlias := GetNextAlias()
	local lInclui := .T.
	local cStSF1 := Posicione("SF1",1,xFilial("SF1") + ::cNF + ::cSerie + ::cCodFor + ::cLoja,"F1_STATUS")

	if ::cStatus == "2"
		cQuery := " SELECT DISTINCT D7_DOC "
		cQuery += "   FROM "+RetSqlName("SD7")
		cQuery += "  WHERE D7_FILIAL = '"+xFilial("SD7")+"'"
		cQuery += "    AND D7_DOC = '"+::cNF+"'"
		cQuery += "    AND D7_SERIE = '"+::cSerie+"'"
		cQuery += "    AND D7_FORNECE = '"+::cCodFor+"'"
		cQuery += "    AND D7_LOJA = '"+::cLoja+"'"
		cQuery += "	   AND D_E_L_E_T_ = ' '"

		TcQuery cQuery New Alias &cNxtAlias

		if !(cNxtAlias)->(!EOF())
			//Se status a ser gravado � 2 e n�o existe a NF no C.Q., ent�o pula para o status 3
			if !::EnderItem()
				alert("Falha no endereçamento")
				//Return //vai deixar passar, mas bloqueara o fracionamento caso tentem seguir com o processo, for�ando o usuario a fazer o endere�amento manualmente
			endif
			if cStSF1 == "C"
				lInclui := .F.
			else
				::cStatus := "3"
				::cDescSt := "Aguardando Fracionamento"
			endif
		EndIf

		(cNxtAlias)->(DbCloseArea())
	EndIf

	if lInclui
		dbselectarea(::cAlias)
		RECLOCK(::cAlias, .T.)
		ZA1->ZA1_FILIAL := ::cFil //xFilial(::cAlias)
		ZA1->ZA1_ITEM 	:= ::cItem
		ZA1->ZA1_LOTE 	:= ::cLote
		ZA1->ZA1_NF 	:= ::cNF
		ZA1->ZA1_SERIE 	:= ::cSerie
		ZA1->ZA1_LOJA 	:= ::cLoja
		ZA1->ZA1_CODFOR := ::cCodFor
		ZA1->ZA1_NOMFOR := ::cNomFor
		ZA1->ZA1_CODPRO := ::cCodPro
		ZA1->ZA1_DESCPR := ::cDescPr
		ZA1->ZA1_QTD1UM := ::nQtd1Um
		ZA1->ZA1_UM 	:= ::cUM
		ZA1->ZA1_QTD2UM := ::nQtd2Um
		ZA1->ZA1_2UM 	:= ::c2UM
		ZA1->ZA1_DTMOV 	:= ::dDtMov
		ZA1->ZA1_HRMOV 	:= ::cHrMov
		ZA1->ZA1_DTFIM 	:= ::dDtFim
		ZA1->ZA1_HRFIM 	:= ::cHrFim
		ZA1->ZA1_STATUS := ::cStatus
		ZA1->ZA1_DESCST := ::cDescSt
		ZA1->ZA1_ITEMNF := ::cItemNF
		MSUNLOCK()
	endif

	RestArea(aArea)
return lInclui

/*/{Protheus.doc} excluiStatus
Exclui status do controle de recebimento
@author Cassiano
@since 02/10/2017 
@version 1.0
/*/
method excluiStatus() class ControleDeRecebimento
	Local aArea := GetArea()
	Local oCtrlRec
	Local cQuery := ""
	Local nStatus := val(::cStatus)
	Local cStatus := ::cStatus
	local cAliasZA1	:= GetNextAlias()
	Local cNxtAlias := GetNextAlias()
	Local cNxtAlias2 := GetNextAlias()
	Local lSemD7 := .F.
	Private nStart

	//oCtrlRec:setcItemNF((cAliasSD1)->D1_ITEM)
	//cItemNF := (cAliasSD1)->D1_ITEM


	If ::cStatus == "3"
		cQuery := " SELECT DISTINCT D7_DOC "
		cQuery += "   FROM "+RetSqlName("SD7")
		cQuery += "  WHERE D7_FILIAL = '"+::cFil+"'"
		cQuery += "    AND D7_DOC = '"+::cNF+"'
		cQuery += "    AND D7_SERIE = '"+::cSerie+"'"
		cQuery += "    AND D7_FORNECE = '"+::cCodFor+"'"
		cQuery += "    AND D7_LOJA = '"+::cLoja+"'"
		If ValType(::cNumCQ) != "U"
			cQuery += "	   AND D7_NUMERO = '"+::cNumCQ+"'"
		Endif

		TcQuery cQuery New Alias &cNxtAlias

		if !(cNxtAlias)->(!EOF())
			cStatus := "2"
			nStatus := 2
			lSemD7 := .T.
		EndIf

		(cNxtAlias)->(DbCloseArea())
	EndIf

	cQuery := "SELECT ZA1_NF, ZA1_SERIE, ZA1_CODFOR, ZA1_LOJA, ZA1_LOTE, ZA1_CODPRO, ZA1_STATUS, ZA1_ITEMNF, R_E_C_N_O_"
	cQuery += "  FROM "+RetSqlName("ZA1")
	cQuery += " WHERE ZA1_FILIAL = '"+::cFil+"'"
	cQuery += "   AND D_E_L_E_T_ <> '*'"
	cQuery += "   AND ZA1_NF = '"+ cvaltochar(::cNF) +"'"
	cQuery += "   AND ZA1_SERIE = '"+ cvaltochar(::cSerie) +"'"
	cQuery += "   AND ZA1_CODFOR = '"+ cvaltochar(::cCodFor) +"'"
	cQuery += "   AND ZA1_LOJA = '"+ cvaltochar(::cLoja) +"'"
	
	// Este tratamento foi feito para atender as notas que retornan do rpocesso de beneciamento
	// Dia 22/04/2020 - Analista Alexandre j. Conselvan - Totvs IP Campinas 

	If SF1->F1_TIPO = 'B' .AND. SF1->F1_FORNECE = '000067'
		// cQuery += "   AND ZA1_STATUS = '"+::cStatus+"'"
	Else
		cQuery += "   AND ZA1_STATUS = '"+::cStatus+"'"
	Endif

	if ::lPorItem
		cQuery += " AND ZA1_CODPRO = '"+::cCodPro+"'"
	endif

	if ::lPorLote
		cQuery += " AND ZA1_LOTE = '"+::cLote+"'"
	endif
	if ::cStatus == "3"  .AND. ValType(::cItemNF) != "U"
		cQuery += "AND ZA1_ITEMNF = '"+ ::cItemNF +"'"
	endif

	TCQUERY cQuery NEW ALIAS &cAliasZA1

	(cAliasZA1)->(DBGotop())

	While (cAliasZA1)->(!Eof())
		oCtrlRec := ControleDeRecebimento():newControleDeRecebimento()
		oCtrlRec:setcFil(::cFil)
		DbSelectArea("ZA1")
		DbGoTo((cAliasZA1)->R_E_C_N_O_)
		RECLOCK("ZA1", .F.)
		dbdelete()
		MsUnlock()
		WriteSx2("ZA1")

		If nStatus > 1
			cStatus := alltrim(str(nStatus-1))
			If lSemD7
				nStatus := 1
			EndIf
			if ::lPorItem
				oCtrlRec:setlPorItem(.T.)
				oCtrlRec:setcCodPro(::cCodPro)
				oCtrlRec:setnQtd1Um(::nQtd1Um)
				oCtrlRec:setnQtd2Um(::nQtd2Um)
			endif
			if ::lPorLote
				If nStatus > 4
					oCtrlRec:setlPorLote(.T.)
					oCtrlRec:setcLote(::cLote)
				endif

				If nStatus == 3
					oCtrlRec:setlPorLote(.T.)
					oCtrlRec:setcLote(::cLote)
				EndIf

				If nStatus == 4

					cQuery := "SELECT DISTINCT D3_LOTECTL"
					cQuery += "  FROM "+RetSqlName("SD3")
					cQuery += " WHERE D3_FILIAL = '"+xFilial("SD3")+"' "
					cQuery += "   AND D_E_L_E_T_ <> '*'"
					cQuery += "   AND D3_COD = '"+::cCodPro+"'"
					cQuery += "   AND D3_ESTORNO = 'S'"
					cQuery += "   AND D3_DOC = '"+SD3->D3_DOC+"'"
					cQuery += "   AND D3_CF = 'DE4'"
					cQuery += "   AND D3_NUMSEQ = '"+SD3->D3_NUMSEQ+"'"
					cQuery += "   AND D3_LOTECTL <> '"+::cLote+"'"

					TCQUERY cQuery NEW ALIAS &cNxtAlias2

					FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG CTRLREC: "+cQuery, 0, (nStart - Seconds()), {})
					If (cNxtAlias2)->(!EOF())
						oCtrlRec:setlPorLote(.T.)
						oCtrlRec:setcLote((cNxtAlias2)->D3_LOTECTL)
						FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "ACHOU LOTE "+(cNxtAlias2)->D3_LOTECTL+" pela D3", "01",, 0, (nStart - Seconds()), {})
					ELSE
						oCtrlRec:setlPorLote(.T.)
						oCtrlRec:setcLote('')
						FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","NAO ACHOU LOTE BUSCANDO PELO LOTE "+::cLote+" pela D3", 0, (nStart - Seconds()), {})
					EndIf

					(cNxtAlias2)->(DbCloseArea())

				EndIf
			endif
			oCtrlRec:setcNF(::cNF)
			oCtrlRec:setcSerie(::cSerie)
			oCtrlRec:setcCodFor(::cCodFor)
			oCtrlRec:setcLoja(::cLoja)
			oCtrlRec:setcStatus(cStatus)
			oCtrlRec:setdDtFim(ctod(""))
			oCtrlRec:setcHrFim("")
			oCtrlRec:setcItemNF(self:cItemNF)
			oCtrlRec:AtualizaDataFim()
		endif
		(cAliasZA1)->(dbSkip())
	End

	(cAliasZA1)->(DBCloseArea())

	if nStatus == 2 .and. ::lEstorno == .F.
		//Se excluiu o documento de entrada (status 2), a pr� nota tambem foi excluida,
		//ent�o status 1 tambem deve ser excluido
		oCtrlRec := ControleDeRecebimento():newControleDeRecebimento()
		oCtrlRec:setcFil(::cFil)
		if ::lPorItem
			oCtrlRec:setlPorItem(.T.)
			oCtrlRec:setcCodPro(::cCodPro)
			oCtrlRec:setnQtd1Um(::nQtd1Um)
			oCtrlRec:setnQtd2Um(::nQtd2Um)
		endif
		if ::lPorLote
			oCtrlRec:setlPorLote(.T.)
			oCtrlRec:setcLote(::cLote)
		endif
		oCtrlRec:setcNF(::cNF)
		oCtrlRec:setcSerie(::cSerie)
		oCtrlRec:setcCodFor(::cCodFor)
		oCtrlRec:setcLoja(::cLoja)
		oCtrlRec:setcStatus("1")
		oCtrlRec:excluiStatus()
	endif

	RestArea(aArea)
return

/*/{Protheus.doc} AtualizaDataFim
Insere data fim de status
@author Cassiano
@since 02/10/2017 
@version 1.0
/*/
method AtualizaDataFim() class ControleDeRecebimento
	Local aArea := GetArea()
	local cAliasZA1	:= GetNextAlias()
	Local cQuery := ""
	cQuery := "SELECT ZA1_DTFIM, ZA1_HRFIM, R_E_C_N_O_"
	cQuery += "  FROM "+RetSqlName("ZA1")
	cQuery += " WHERE ZA1_FILIAL = '"+xFilial("ZA1")+"'"
	cQuery += "   AND D_E_L_E_T_ <> '*'"
	cQuery += "   AND ZA1_NF = '"+::cNF+"'"
	cQuery += "   AND ZA1_SERIE = '"+::cSerie+"'"
	cQuery += "   AND ZA1_CODFOR = '"+::cCodFor+"'"
	cQuery += "   AND ZA1_LOJA = '"+::cLoja+"'"
	If SF1->F1_TIPO = 'B'
		cQuery += "   AND ZA1_STATUS <= '"+::cStatus+"'"
	else
		cQuery += "   AND ZA1_STATUS = '"+::cStatus+"'"

		If ValType(::cItemNF) != "U" .AND. ::cStatus != "1"
			cQuery += "   AND ZA1_ITEMNF = '"+::cItemNF+"'"
		Endif

	Endif

	//if ::cStatus > "1" .and. (::cStatus != "3" .and. procName(1) == "EXCLUISTATUS")
	//	cQuery += "   AND ZA1_ITEMNF = '"+::cItemNF+"'"
	//endif

	if ::lPorItem
		cQuery += " AND ZA1_CODPRO = '"+::cCodPro+"'"
	endif

	if ::lPorLote
		cQuery += " AND ZA1_LOTE = '"+::cLote+"'"
	endif

	TCQUERY cQuery NEW ALIAS &cAliasZA1

	(cAliasZA1)->(DBGotop())

	While (cAliasZA1)->(!Eof())

		DbSelectArea("ZA1")
		DbGoTo((cAliasZA1)->R_E_C_N_O_)
		RECLOCK("ZA1", .F.)
		ZA1->ZA1_HRFIM 	:= ::cHrFim
		ZA1->ZA1_DTFIM 	:= ::dDtFim
		MSUNLOCK()
		(cAliasZA1)->(dbSkip())

	end
	(cAliasZA1)->(DBCloseArea())

	RestArea(aArea)
return

/*/{Protheus.doc} getValue
@author Evandro Simenes
@since 13/10/2017 
@version 1.0
/*/
method getValue(cCampo) class ControleDeRecebimento
	Local aArea := GetArea()
	Local cValue := ""

	cValue := POSICIONE(::cAlias, 4, xFilial(::cAlias) + ::cChaveStatus, cCampo)

	RestArea(aArea)
return cValue

/*/{Protheus.doc} incTransferencia
@author Cassiano Ribeiro
@since 24/10/2017
@version 1.0
/*/
method incTransferencia(aItens) class ControleDeRecebimento
	local aArea     := GetArea()
	local lRet		:= .T.
	local nX 		:= 0
	//local aAuto		:= {}
	local aTrf		:= {}
	local cDocTran	:= Nextnumero("SD3",2,"D3_DOC",.t.)
	Local cQuery := ""
	local cNxtAlias	:= GetNextAlias()
	Local itensST
	PRIVATE lMsHelpAuto := .T.
	private lMsErroAuto := .F.
	Private lAutoErrNoFile := .T.
	Private cCusmed := GetMv("MV_CUSMED")
	Private aRegSD3 := {}



	aAdd( aTrf , { cDocTran , dDataBase } )

	For nX := 1 to Len(aItens)
		cQuery := " SELECT DISTINCT 1"
		cQuery += "   FROM "+RetSqlName("SBF")
		cQuery += "  WHERE D_E_L_E_T_ <> '*'"
		cQuery += "    AND BF_FILIAL = '"+xFilial("SBF")+"'"
		cQuery += "    AND BF_PRODUTO = '"+aItens[nX,PRODUTO_ORIGEM]+"'"
		cQuery += "    AND BF_LOCAL = '"+aItens[nX,LOCAL_ORIGEM]+"'"
		cQuery += "    AND BF_LOCALIZ = '"+aItens[nX,ENDERECO_ORIGEM]+"'"
		cQuery += "    AND BF_LOTECTL = '"+aItens[nX,LOTE_ORIGEM]+"'"

		TCQUERY cQuery NEW ALIAS &cNxtAlias

		If !(cNxtAlias)->(!Eof())
			Alert("Lote "+aItens[nX,LOTE_ORIGEM]+" nao est� endere�ado corretamente.")
			lRet := .F.
		EndIf

		(cNxtAlias)->(DbCloseArea())

	NEXT nX

	IF lRet

		For nX := 1 to Len(aItens)
			/*
			aAdd( aTrf	,{	aItens[nX,PRODUTO_ORIGEM]	,;	// Produto Origem
							aItens[nX,DESC_PROD_ORIGEM]	,;	// Descricao Produto Origem
							aItens[nX,UM_ORIGEM]		,;	// Unidade Medida Prod. Origem
							aItens[nX,LOCAL_ORIGEM]		,;	// Armazem Original
							aItens[nX,ENDERECO_ORIGEM]	,;	// Endereco Original
							aItens[nX,PRODUTO_DESTINO]	,;	// Produto Destino
							aItens[nX,DESC_PROD_DESINO]	,;	// Descricao Produto Destino
							aItens[nX,UM_DESTINO]		,;	// Unidade Medida Prod. Destino
							aItens[nX,LOCAL_DESTINO]	,;	// Armazem Destino
							aItens[nX,ENDERECO_DESTINO]	,;	// Endereco Destino
							'',;							// Num Serie
							aItens[nX,LOTE_ORIGEM]		,;	// Lote Origem
							'',;                            // Sub Lote
							aItens[nX,VALIDADE_ORIGEM]	,;  // Data validade do lote origem
		                    0							,;	// Potencia
							aItens[nX,QTD1]				,;	// Quantidade
							aItens[nX,QTD2]				,;	// Qtd Segunda Unidade
							'',;                            // Estorno
							'',;                            // Sequencia
							aItens[nX,LOTE_DESTINO]		,;  // Lote Destino						
							aItens[nX,VALIDADE_DESTINO]	,;  // Data validade do lote destino
							''})	                        // Item Grade 
			*/

			//*********** Verifica se o custo medio e calculado On-Line
			If cCusmed == "O"
				PRIVATE nHdlPrv             // Endereco do arquivo de contra prova dos lanctos cont.
				PRIVATE lCriaHeader := .T.  // Para criar o header do arquivo Contra Prova
				PRIVATE cLoteEst            // Numero do lote para lancamentos do estoque
				//*********** Posiciona numero do Lote para Lancamentos do Faturamento
				dbSelectArea("SX5")
				dbSeek(xFilial()+"09EST")
				cLoteEst:=IIF(Found(),Trim(X5Descri()),"EST ")
				PRIVATE nTotal := 0      // Total dos lancamentos contabeis
				PRIVATE cArquivo         // Nome do arquivo contra prova
			EndIf


			if (!a260Processa( 	aItens[nX,PRODUTO_ORIGEM]      ,; // cCodOrig     01
				aItens[nX,LOCAL_ORIGEM]    ,; // cLocOrig     02
				aItens[nX,QTD1]  ,; // nQuant260    03
				cDocTran          ,; // cDocto       04
				dDataBase     ,; // dEmis260     05
				aItens[nX,QTD2] ,; // nQuant260D   06
				''  ,; // cNumLote     07
				aItens[nX,LOTE_ORIGEM]  ,; // cLoteDigi    08
				aItens[nX,VALIDADE_ORIGEM]  ,; // dDtValid     09
				''  ,; // cNumSerie    10
				aItens[nX,ENDERECO_ORIGEM] ,; // cLoclzOrig   11
				aItens[nX,PRODUTO_DESTINO]  ,; // cCodDest     12
				aItens[nX,LOCAL_DESTINO]  ,; // cLocDest     13
				aItens[nX,ENDERECO_DESTINO] ,; // cLocLzDest   14
				.F.           ,; // lEstorno     15
				Nil       ,; // nRecOrig     16
				Nil       ,; // nRecDest     17
				"MATA260"     ,; // cPrograma    18
				Nil           ,; // cEstFis      19
				""            ,; // cServico  20
				Nil           ,; // cTarefa   21
				""            ,; // cAtividade  22
				""            ,; // cAnomalia  23
				Nil           ,; // cEstDest  24
				aItens[nX,ENDERECO_DESTINO]       ,; // cLoclzDest  25
				""            ,; // cHrInicio  26
				"S"        ,; // cAtuEst   27
				""         ,; // cCarga   28
				""            ,; // cUnitiza  29
				Nil           ,; // cOrdTar   30
				Nil           ,; // cOrdAti   31
				""            ,; // cRHumano  32
				""            ,; // cRFisico  33
				0     ,; // nPotencia  34
				aItens[nX,LOTE_DESTINO]  ,; // cLoteDest  35
				""   ,; // cCAT83O   36
				""    ,; // cCAT83D   37
				.F.   ))  // lAtuSB2   38
				lRet := .F.
			endif
		Next nX
	EndIf
/*	If Len(aTrf) > 0
		MSExecAuto({|x,y| mata261(x,y)},aTrf,OPERAC_INCLUI)
		aLog := GetAutoGRLog()
	For nX := 1 TO Len(aLog)
			CONOUT("DEBUG SIM17(RETORNO ERRO MATA261): "+aLog[nX])
	NEXT nX
		
	If !lMsErroAuto
			lRet := .T.
			CONOUT("DEBUG SIM18: TRANSFERENCIA OK")
	Else
			CONOUT("DEBUG SIM18: TRANSFERENCIA ERRO")
			MostraErro()
	EndIf
		
		
Endif*/
	
	RestArea(aArea)
	
return lRet


method IncSolicTransf(itensST) class ControleDeRecebimento
	local aArea		:= GetArea()
	Local aCabec := {}
	Local aItens := {}
	Local lRet := .F.
	Local aLog := {}
	Local cErr := ""
	Local oModel311 := FWLoadModel( 'MATA311' )
	//Local oMenu311 :=  FWLoadMenuDef( 'MATA311' )
	//Local oView311 := FWLoadView( 'MATA311' )
	private lMsHelpAuto := .T.
	private lMsErroAuto := .F.
	private lAutoErrNoFile	:= .T.		// Habilita a gravacao de erro da rotina automatica
	private aRotina     := FWLoadMenuDef('MATA311')
	Private nStart := 0 
		
	aadd(aCabec,{"NNS_COD" 		,itensST[1][CODIGO_SOLICITACAO]	,})
	aadd(aCabec,{"NNS_DATA" 	,itensST[1][DATA_SOLICITACAO]	,})
	aadd(aCabec,{"NNS_SOLICT" 	,itensST[1][SOLICITANTE]		,})
	aadd(aCabec,{"NNS_ESPECI" 	,"SPED"		,})
	aadd(aCabec,{"NNS_CLASS" 	,itensST[1][TIPO_DOCUMENTO]		,})
	
	for nX := 1 to len(itensST)
		
		aAdd(aItens,{})
		aadd(aItens[nX],{"NNT_FILORI"	,itensST[nX][FILIAL_ORIGEM]	,})
		aadd(aItens[nX],{"NNT_FILDES"	,itensST[nX][FILIAL_DESTINO],})
		aadd(aItens[nX],{"NNT_PROD"		,itensST[nX][PRODUTO_ORIG]	,})
		aadd(aItens[nX],{"NNT_PRODD"	,itensST[nX][PRODUTO_DEST]	,})
		aadd(aItens[nX],{"NNT_QUANT"   	,itensST[nX][QUANTIDADE]	,})
		aadd(aItens[nX],{"NNT_LOCAL"   	,itensST[nX][LOCAL_ORIG]	,})
		aadd(aItens[nX],{"NNT_LOCLD"   	,itensST[nX][LOCAL_DEST]	,})
		aadd(aItens[nX],{"NNT_TS"   	,itensST[nX][TES_SAIDA]		,})
		aadd(aItens[nX],{"NNT_TE"   	,itensST[nX][TES_ENTRADA]	,})
		aadd(aItens[nX],{"NNT_LOCALI"   ,itensST[nX][ENDERECO_ORIG]	,})
		//aadd(aItens[nX],{"NNT_LOCDES"   ,itensST[nX][ENDERECO_DEST]	,})
		aadd(aItens[nX],{"NNT_LOTECT"   ,itensST[nX][LOTE_ORIG]	,})
		aadd(aItens[nX],{"NNT_LOTED"   ,itensST[nX][LOTE_DEST]	,})
		aadd(aItens[nX],{"NNT_DTVALI"   ,itensST[nX][VALIDADE_ORIG]	,})
		aadd(aItens[nX],{"NNT_DTVALD"   ,itensST[nX][VALIDADE_DEST]	,})
		
	next nX
	
	aCabec := FWVetByDic( aCabec, 'NNS' )
	aItens := FWVetByDic( aItens, 'NNT' , .T.)
	FwMvcRotAuto( oModel311, "NNS", 3, { { "NNSMASTER", aCabec }, { "NNTDETAIL", aItens }  }, .T. )
	
	if lMsErroAuto
		aLog := GetAutoGRLog()
		cErr := ""
		For nX := 1 TO Len(aLog)
			FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG SIM(RETORNO ERRO MATA311): "+aLog[nX], 0, (nStart - Seconds()), {})
			If "Mensagem do erro" $ aLog[nX]
				cErr += aLog[nX]
			EndIf
		NEXT nX
		Alert(Alltrim(cErr))
		FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01",OemToAnsi("Erro na inclus�o da Solicita��o de Transfer�ncia!"), 0, (nStart - Seconds()), {})
	else
		FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01",OemToAnsi("Solicita��o de Transfer�ncia "+itensST[1][CODIGO_SOLICITACAO]+" foi inclu�da com sucesso!"), 0, (nStart - Seconds()), {})
		MsgAlert("Solicita��o de Transfer�ncia "+itensST[1][CODIGO_SOLICITACAO]+" foi inclu�da com sucesso!")
		lRet := .T.
	endIf
	
	oModel311:DeActivate()
	
	restArea(aArea)
	
return lRet


/*/{Protheus.doc} getcLote
@author Evandro Simenes
@since 16/10/2017 
@version 1.0
/*/
method getcLote() class ControleDeRecebimento
return ::cLote

/*/{Protheus.doc} setcLote
@author Evandro Simenes
@since 16/10/2017 
@version 1.0
/*/
method setcLote(cLote) class ControleDeRecebimento
	::cLote := cLote
return

/*/{Protheus.doc} getcNF
@author Evandro Simenes
@since 16/10/2017 
@version 1.0
/*/
method getcNF() class ControleDeRecebimento
return ::cNF

/*/{Protheus.doc} setcNF
@author Evandro Simenes
@since 16/10/2017 
@version 1.0
/*/
method setcNF(cNF) class ControleDeRecebimento
	::cNF := cNF
return

/*/{Protheus.doc} getcSerie
@author Evandro Simenes
@since 16/10/2017 
@version 1.0
/*/
method getcSerie() class ControleDeRecebimento
return ::cSerie

/*/{Protheus.doc} setcSerie
@author Evandro Simenes
@since 16/10/2017 
@version 1.0
/*/
method setcSerie(cSerie) class ControleDeRecebimento
	::cSerie := cSerie
return

/*/{Protheus.doc} getcLoja
@author Evandro Simenes
@since 16/10/2017 
@version 1.0
/*/
method getcLoja() class ControleDeRecebimento
return ::cLoja

/*/{Protheus.doc} setcLoja
@author Evandro Simenes
@since 16/10/2017 
@version 1.0
/*/
method setcLoja(cLoja) class ControleDeRecebimento
	::cLoja := cLoja
return

/*/{Protheus.doc} getcCodFor
@author Evandro Simenes
@since 16/10/2017 
@version 1.0
/*/
method getcCodFor() class ControleDeRecebimento
return ::cCodFor

/*/{Protheus.doc} setcCodFor
@author Evandro Simenes
@since 16/10/2017 
@version 1.0
/*/
method setcCodFor(cCodFor) class ControleDeRecebimento
	::cCodFor := cCodFor
return

/*/{Protheus.doc} getcNomFor
@author Evandro Simenes
@since 16/10/2017 
@version 1.0
/*/
method getcNomFor() class ControleDeRecebimento
return ::cNomFor

/*/{Protheus.doc} setcNomFor
@author Evandro Simenes
@since 16/10/2017 
@version 1.0
/*/
method setcNomFor(cNomFor) class ControleDeRecebimento
	::cNomFor := cNomFor
return

/*/{Protheus.doc} getcCodPro
@author Evandro Simenes
@since 16/10/2017 
@version 1.0
/*/
method getcCodPro() class ControleDeRecebimento
return ::cCodPro

/*/{Protheus.doc} setcCodPro
@author Evandro Simenes
@since 16/10/2017 
@version 1.0
/*/
method setcCodPro(cCodPro) class ControleDeRecebimento
	::cCodPro := cCodPro
return

/*/{Protheus.doc} getcDescPr
@author Evandro Simenes
@since 16/10/2017 
@version 1.0
/*/
method getcDescPr() class ControleDeRecebimento
return ::cDescPr

/*/{Protheus.doc} setcDescPr
@author Evandro Simenes
@since 16/10/2017 
@version 1.0
/*/
method setcDescPr(cDescPr) class ControleDeRecebimento
	::cDescPr := cDescPr
return

/*/{Protheus.doc} getnQtd1Um
@author Evandro Simenes
@since 16/10/2017 
@version 1.0
/*/
method getnQtd1Um() class ControleDeRecebimento
return ::nQtd1Um

/*/{Protheus.doc} setnQtd1Um
@author Evandro Simenes
@since 16/10/2017 
@version 1.0
/*/
method setnQtd1Um(nQtd1Um) class ControleDeRecebimento
	::nQtd1Um := nQtd1Um
return

/*/{Protheus.doc} getcUM
@author Evandro Simenes
@since 16/10/2017 
@version 1.0
/*/
method getcUM() class ControleDeRecebimento
return ::cUM

/*/{Protheus.doc} setcUM
@author Evandro Simenes
@since 16/10/2017 
@version 1.0
/*/
method setcUM(cUM) class ControleDeRecebimento
	::cUM := cUM
return

/*/{Protheus.doc} getnQtd2Um
@author Evandro Simenes
@since 16/10/2017 
@version 1.0
/*/
method getnQtd2Um() class ControleDeRecebimento
return ::nQtd2Um

/*/{Protheus.doc} setnQtd2Um
@author Evandro Simenes
@since 16/10/2017 
@version 1.0
/*/
method setnQtd2Um(nQtd2Um) class ControleDeRecebimento
	::nQtd2Um := nQtd2Um
return

/*/{Protheus.doc} getc2UM
@author Evandro Simenes
@since 16/10/2017 
@version 1.0
/*/
method getc2UM() class ControleDeRecebimento
return ::c2UM

/*/{Protheus.doc} setc2UM
@author Evandro Simenes
@since 16/10/2017 
@version 1.0
/*/
method setc2UM(c2UM) class ControleDeRecebimento
	::c2UM := c2UM
return

/*/{Protheus.doc} getdDtMov
@author Evandro Simenes
@since 16/10/2017 
@version 1.0
/*/
method getdDtMov() class ControleDeRecebimento
return ::dDtMov

/*/{Protheus.doc} setdDtMov
@author Evandro Simenes
@since 16/10/2017 
@version 1.0
/*/
method setdDtMov(dDtMov) class ControleDeRecebimento
	::dDtMov := dDtMov
return

/*/{Protheus.doc} getcHrMov
@author Evandro Simenes
@since 16/10/2017 
@version 1.0
/*/
method getcHrMov() class ControleDeRecebimento
return ::cHrMov

/*/{Protheus.doc} setcHrMov
@author Evandro Simenes
@since 16/10/2017 
@version 1.0
/*/
method setcHrMov(cHrMov) class ControleDeRecebimento
	::cHrMov := cHrMov
return

/*/{Protheus.doc} getdDtFim
@author Evandro Simenes
@since 16/10/2017 
@version 1.0
/*/
method getdDtFim() class ControleDeRecebimento
return ::dDtFim

/*/{Protheus.doc} setdDtFim
@author Evandro Simenes
@since 16/10/2017 
@version 1.0
/*/
method setdDtFim(dDtFim) class ControleDeRecebimento
	::dDtFim := dDtFim
return

/*/{Protheus.doc} getcHrFim
@author Evandro Simenes
@since 16/10/2017 
@version 1.0
/*/
method getcHrFim() class ControleDeRecebimento
return ::cHrFim

/*/{Protheus.doc} setcHrFim
@author Evandro Simenes
@since 16/10/2017 
@version 1.0
/*/
method setcHrFim(cHrFim) class ControleDeRecebimento
	::cHrFim := cHrFim
return

/*/{Protheus.doc} getcDescSt
@author Evandro Simenes
@since 16/10/2017 
@version 1.0
/*/
method getcDescSt() class ControleDeRecebimento
return ::cDescSt

/*/{Protheus.doc} setcDescSt
@author Evandro Simenes
@since 16/10/2017 
@version 1.0
/*/
method setcDescSt(cDescSt) class ControleDeRecebimento
	::cDescSt := cDescSt
return

/*/{Protheus.doc} getcStatus
@author Cassiano
@since 02/10/2017 
@version 1.0
/*/
method getcStatus() class ControleDeRecebimento
return ::cStatus

/*/{Protheus.doc} setcStatus
@author Cassiano
@since 02/10/2017 
@version 1.0
/*/
method setcStatus(cStatus) class ControleDeRecebimento
	::cStatus := cStatus
return

/*/{Protheus.doc} getcChaveStatus
@author Cassiano
@since 02/10/2017 
@version 1.0
/*/
method getcChaveStatus() class ControleDeRecebimento
return ::cChaveStatus

/*/{Protheus.doc} setcChaveStatus
@author Cassiano
@since 02/10/2017 
@version 1.0
/*/
method setcChaveStatus(cChave) class ControleDeRecebimento
	::cChaveStatus := cChave
return


/*/{Protheus.doc} setnIndice
@author Evandro Simenes
@since 17/10/2017 
@version 1.0
/*/
method setnIndice(nIndice) class ControleDeRecebimento
	::nIndice := nIndice
return

/*/{Protheus.doc} setlPorItem
@author Evandro Simenes
@since 18/10/2017 
@version 1.0
/*/
method setlPorItem(lPorItem) class ControleDeRecebimento
	::lPorItem := lPorItem
return

/*/{Protheus.doc} setlPorLote
@author Evandro Simenes
@since 26/10/2017 
@version 1.0
/*/
method setlPorLote(lPorLote) class ControleDeRecebimento
	::lPorLote := lPorLote
return

/*/{Protheus.doc} setlEstorno
@author Evandro Simenes
@since 31/10/2017 
@version 1.0
/*/
method setlEstorno(lEstorno) class ControleDeRecebimento
	::lEstorno := lEstorno
return

/*/{Protheus.doc} setcItem
@author Evandro Simenes
@since 07/11/2017 
@version 1.0
/*/
method setcItem(cItem) class ControleDeRecebimento
	::cItem := cItem
return

/*/{Protheus.doc} setcFil
@author Evandro Simenes
@since 23/11/2017 
@version 1.0
/*/
method setcFil(cFil) class ControleDeRecebimento
	::cFil := cFil
return

/*/{Protheus.doc} setcNumSeq
@author Evandro Simenes
@since 04/12/2017 
@version 1.0
/*/
method setcNumSeq(cNumSeq) class ControleDeRecebimento
	::cNumSeq := cNumSeq
return

/*/{Protheus.doc} setcNumCQ
@author Augusto Krejci Bem-Haja
@since 30/01/2018 
@version 1.0
/*/
method setcNumCQ(cNumCQ) class ControleDeRecebimento
	::cNumCQ := cNumCQ
return

/*/{Protheus.doc} setcItemNF
@author Augusto Krejci Bem-Haja
@since 30/01/2018 
@version 1.0
/*/
method setcItemNF(cItemNF) class ControleDeRecebimento
	::cItemNF := cItemNF
return


/*/{Protheus.doc} setlNumSeq
@author Evandro Simenes
@since 04/12/2017 
@version 1.0
/*/
method setlNumSeq(lNumSeq) class ControleDeRecebimento
	::lNumSeq := lNumSeq
return

/*/{Protheus.doc} EnderItem
@author Evandro Simenes
@since 23/11/2017 
@version 1.0
/*/
method EnderItem(lTrans) class ControleDeRecebimento
	Local aCabSDA    := {}
	Local aItSDB     := {}
	Local aItensSDB := {}
	local cNxtAlias	:= GetNextAlias()
	Local cQuery := ""
	Local cFilbkp := cFilAnt
	Local cLocaliz := ""
	Default lTrans := .F.
	Private nStart := 0
	Private	lMsErroAuto := .F.

	cFilAnt := ::cFil

	cQuery := "SELECT DA_NUMSEQ, DA_SALDO, DA_TIPONF "
	cQuery += "  FROM "+RetSqlName("SDA")
	cQuery += " WHERE DA_FILIAL = '"+::cFil+"'"
	cQuery += "   AND D_E_L_E_T_ <> '*'"
	cQuery += "   AND DA_PRODUTO = '"+::cCodPro+"'"
	cQuery += "   AND DA_DOC = '"+::cNF+"'
	cQuery += "   AND DA_SERIE = '"+::cSerie+"'"
	cQuery += "   AND DA_CLIFOR = '"+::cCodFor+"'"
	cQuery += "   AND DA_LOJA = '"+::cLoja+"'"
	cQuery += "   AND DA_LOTECTL = '"+::cLote+"'"

	FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG CTRLREC: "+cQuery, 0, (nStart - Seconds()), {})

	TcQuery cQuery New Alias &cNxtAlias

	if (cNxtAlias)->(!EOF())
		Aadd( aCabSDA, { 'DA_PRODUTO'	, ::cCodPro		, Nil } )
		Aadd( aCabSDA, { 'DA_NUMSEQ'  	, (cNxtAlias)->DA_NUMSEQ , Nil } )

		IF  Alltrim( (cNxtAlias)->DA_TIPONF ) = "B"
			cLocaliz := SuperGetMv("MV_ZZLOCBE",.F.,"BENEFICIAMENTO")
		ElseIf lTrans
			cLocaliz := SuperGetMv("MV_ZZLOCAR",.F.,"AGUARDANDO")
		Else
			cLocaliz := SuperGetMv("MV_ZZLOCFR",.F.,"FRACIONAMENTO")
		EndIf

		//Dados do item que ser� endere�ado
		aItSDB := {{"DB_ITEM"	  ,"0001"	  ,Nil},;
			{"DB_ESTORNO"  ," "	      ,Nil},;
			{"DB_LOCALIZ"  ,cLocaliz ,Nil},;
			{"DB_DATA"	  ,dDataBase  ,Nil},;
			{"DB_QUANT"  ,(cNxtAlias)->DA_SALDO        ,Nil}}

		aadd(aItensSDB,aItSDB)

		//Executa o endere�amento do item
		MATA265( aCabSDA, aItensSDB, 3)
		If lMsErroAuto
			MostraErro()
			Return .F.
		Endif
	endIf

	(cNxtAlias)->(DbCloseArea())

	cFilAnt := cFilbkp

Return .T.

/*/{Protheus.doc} getAddQuery
@author Evandro Simenes
@since 05/12/2017 
@version 1.0
/*/

method getAddQuery() class ControleDeRecebimento
	Local cQuery := ""

	Do Case
	Case ::cStatus == "5"
		cQuery := "SELECT '0' D1_NUMSEQ, ZA1.ZA1_LOTE D1_LOTECTL, ZA1.ZA1_NF D1_DOC, "
		cQuery += "  ZA1.ZA1_SERIE D1_SERIE, ZA1.ZA1_LOJA D1_LOJA, ZA1.ZA1_CODFOR D1_FORNECE, "
		cQuery += "  ZA1.ZA1_CODPRO D1_COD, ZA1.ZA1_QTD1UM D1_QUANT, ZA1.ZA1_UM D1_UM, "
		cQuery += "  ZA1.ZA1_QTD2UM D1_QTSEGUM, ZA1.ZA1_2UM D1_SEGUM, ZA1.ZA1_NOMFOR A2_NOME,"
		cQuery += " ZA1.ZA1_DESCPR B1_DESC, SB1.B1_TE, ZA1.ZA1_CODPRO B1_COD, ZA1.ZA1_ITEMNF D1_ITEM "
		cQuery += "  FROM "+RetSqlName("ZA1")+" ZA1, "+RetSqlName("SB1")+" SB1"
		cQuery += " WHERE ZA1.ZA1_FILIAL = '"+xFilial("ZA1")+"'"
		cQuery += "   AND SB1.B1_FILIAL = '"+xFilial("SB1")+"'"
		cQuery += "   AND ZA1.D_E_L_E_T_ <> '*'"
		cQuery += "   AND SB1.D_E_L_E_T_ <> '*'"
		cQuery += "   AND ZA1.ZA1_NF = '"+::cNF+"'"
		cQuery += "   AND ZA1.ZA1_SERIE = '"+::cSerie+"'"
		cQuery += "   AND ZA1.ZA1_CODFOR = '"+::cCodFor+"'"
		cQuery += "   AND ZA1.ZA1_LOJA = '"+::cLoja+"'"
		cQuery += "   AND ZA1.ZA1_CODPRO = SB1.B1_COD"
		cQuery += "   AND ZA1.ZA1_STATUS = '4'"

		if ::lPorItem
			cQuery += " AND ZA1.ZA1_CODPRO = '"+::cCodPro+"'"
		endif

		if ::lPorLote
			cQuery += " AND ZA1.ZA1_LOTE = '"+::cLote+"'"
		endif
	Case ::cStatus == "3"
		cQuery := "SELECT SD1.D1_NUMSEQ, SD1.D1_LOTECTL, SD1.D1_DOC, SD1.D1_SERIE, "
		cQuery += "  SD1.D1_LOJA, SD1.D1_FORNECE, SD1.D1_COD, SD1.D1_QUANT, SD1.D1_UM, "
		cQuery += "  SD1.D1_QTSEGUM, SD1.D1_SEGUM, "

		/// iremos posicionar no SF1 para verificar o tipo do processo.
		dbselectArea("SF1")
		DBSetOrder(1)
		DBSeek(xFilial("SF1") + ::cNF + ::cSerie + ::cCodFor + ::cLoja ) 

		IF SF1->F1_TIPO = "B"
			cQuery += " SA1.A1_NOME AS A2_NOME, "
		else
			cQuery += " SA2.A2_NOME AS A2_NOME, "
		Endif

		cQuery += "  SB1.B1_DESC, SB1.B1_TE, SB1.B1_COD, SD1.D1_ITEM"
		cQuery += "  FROM "+RetSqlName("SD1")+" SD1, "

		IF SF1->F1_TIPO = "B"
			cQuery += RetSqlName("SA1")+" SA1,"
		else
			cQuery += RetSqlName("SA2")+" SA2,"
		Endif

		cQuery += RetSqlName("SB1")+" SB1"
		cQuery += " WHERE SD1.D1_FILIAL = '"+xFilial("SD1")+"'"
		cQuery += "   AND SB1.B1_FILIAL = '"+xFilial("SB1")+"'"
		cQuery += "   AND SD1.D_E_L_E_T_ <> '*'"
		cQuery += "   AND SB1.D_E_L_E_T_ <> '*'"
		cQuery += "   AND SD1.D1_DOC = '"+::cNF+"'"
		cQuery += "   AND SD1.D1_SERIE = '"+::cSerie+"'"
		cQuery += "   AND SD1.D1_FORNECE = '"+::cCodFor+"'"
		cQuery += "   AND SD1.D1_LOJA = '"+::cLoja+"'"
		cQuery += "   AND SD1.D1_COD = SB1.B1_COD"

		IF SF1->F1_TIPO = "B"
			cQuery += "   AND SA1.A1_FILIAL = '"+xFilial("SA1")+"'"
			cQuery += "   AND SA1.D_E_L_E_T_ <> '*'"
			cQuery += "   AND SD1.D1_FORNECE = SA1.A1_COD"
			cQuery += "   AND SD1.D1_LOJA = SA1.A1_LOJA"
		else
			cQuery += "   AND SA2.A2_FILIAL = '"+xFilial("SA2")+"'"
			cQuery += "   AND SA2.D_E_L_E_T_ <> '*'"
			cQuery += "   AND SD1.D1_FORNECE = SA2.A2_COD"
			cQuery += "   AND SD1.D1_LOJA = SA2.A2_LOJA"
		ENDIF

		cQuery += "	  AND SD1.D1_NUMCQ = '" + ::cNumCQ +"'"

		If ::cStatus <> "1" .and. ::cFil == cFilAnt
			cQuery += "   AND EXISTS (SELECT ZA1_NF "
			cQuery += "                 FROM "+RetSqlName("ZA1")
			cQuery += "                WHERE ZA1_FILIAL = '"+::cFil+"'"
			cQuery += "                  AND D_E_L_E_T_ <> '*'"
			cQuery += "                  AND ZA1_NF = '"+::cNF+"'"
			cQuery += "                  AND ZA1_SERIE = '"+::cSerie+"'"
			cQuery += "                  AND ZA1_CODFOR = '"+::cCodFor+"'"
			cQuery += "                  AND ZA1_STATUS = '1'"
			cQuery += "                  AND ZA1_LOJA = '"+::cLoja+"' )"
		EndIf

		if ::lPorItem
			cQuery += " AND SD1.D1_COD = '"+::cCodPro+"'"
		endif

		if ::lPorLote
			cQuery += " AND SD1.D1_LOTECTL = '"+::cLote+"'"
		endif
	OTHERWISE
		// IF CTIPO = "N"
		IF CTIPO $ "N/B"
			cQuery := "SELECT SD1.D1_NUMSEQ, SD1.D1_LOTECTL, SD1.D1_DOC, SD1.D1_SERIE, "
			cQuery += " SD1.D1_LOJA, SD1.D1_FORNECE, SD1.D1_COD, SD1.D1_QUANT, SD1.D1_UM,"
			cQuery += " SD1.D1_QTSEGUM, SD1.D1_SEGUM, "

			IF CTIPO = "B"
				cQuery += " SA1.A1_NOME  AS A2_NOME, "
			else
				cQuery += " SA2.A2_NOME  AS A2_NOME, "
			Endif

			cQuery += " SB1.B1_DESC, SB1.B1_TE, SB1.B1_COD, SD1.D1_ITEM"
			cQuery += "  FROM "+RetSqlName("SD1")+" SD1, "
			IF CTIPO = "B"
				cQuery += RetSqlName("SA1")+" SA1,"
			else
				cQuery += RetSqlName("SA2")+" SA2,"
			Endif

			cQuery += RetSqlName("SB1")+" SB1"
			cQuery += " WHERE SD1.D1_FILIAL = '"+xFilial("SD1")+"'"
			cQuery += "   AND SB1.B1_FILIAL = '"+xFilial("SB1")+"'"
			cQuery += "   AND SD1.D_E_L_E_T_ <> '*'"
			cQuery += "   AND SB1.D_E_L_E_T_ <> '*'"
			cQuery += "   AND SD1.D1_DOC = '"+::cNF+"'"
			cQuery += "   AND SD1.D1_SERIE = '"+::cSerie+"'"
			cQuery += "   AND SD1.D1_FORNECE = '"+::cCodFor+"'"
			cQuery += "   AND SD1.D1_LOJA = '"+::cLoja+"'"
			cQuery += "   AND SD1.D1_COD = SB1.B1_COD"

			IF CTIPO = "B"
				cQuery += "   AND SA1.A1_FILIAL = '"+xFilial("SA1")+"'"
				cQuery += "   AND SA1.D_E_L_E_T_ <> '*'"
				cQuery += "   AND SD1.D1_FORNECE = SA1.A1_COD"
				cQuery += "   AND SD1.D1_LOJA = SA1.A1_LOJA"

			else
				cQuery += "   AND SA2.A2_FILIAL = '"+xFilial("SA2")+"'"
				cQuery += "   AND SA2.D_E_L_E_T_ <> '*'"
				cQuery += "   AND SD1.D1_FORNECE = SA2.A2_COD"
				cQuery += "   AND SD1.D1_LOJA = SA2.A2_LOJA"

			Endif



			If ::cStatus <> "1" .and. ::cFil == cFilAnt
				cQuery += "   AND EXISTS (SELECT ZA1_NF "
				cQuery += "                 FROM "+RetSqlName("ZA1")
				cQuery += "                WHERE ZA1_FILIAL = '"+::cFil+"'"
				cQuery += "                  AND D_E_L_E_T_ <> '*'"
				cQuery += "                  AND ZA1_NF = '"+::cNF+"'"
				cQuery += "                  AND ZA1_SERIE = '"+::cSerie+"'"
				cQuery += "                  AND ZA1_CODFOR = '"+::cCodFor+"'"
				cQuery += "                  AND ZA1_STATUS = '1'"
				cQuery += "                  AND ZA1_LOJA = '"+::cLoja+"' )"
			EndIf

			if ::lPorItem
				cQuery += " AND SD1.D1_COD = '"+::cCodPro+"'"
			endif

			if ::lPorLote
				cQuery += " AND SD1.D1_LOTECTL = '"+::cLote+"'"
			endif
		ENDIF
	EndCase
Return cQuery
