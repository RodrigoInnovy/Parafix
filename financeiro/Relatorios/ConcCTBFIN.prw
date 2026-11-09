#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

#DEFINE	TIPO_CLIENTE			"1"
#DEFINE	TIPO_FORNECEDOR			"2"

#DEFINE SEPARADOR_TIPOS			"-"

#DEFINE ALINHAMENTO_ESQUERDA    1
#DEFINE ALINHAMENTO_CENTRO      2
#DEFINE ALINHAMENTO_DIREITA     3

#DEFINE CODIGO_CONTA			1
#DEFINE DESCRIC_CONTA			2
#DEFINE SALDO_CONTA				3
#DEFINE SALDO_FINANC			4
#DEFINE DIFER_CONTA				5

#DEFINE CAMPO_SALDO				"1"

#DEFINE CAMPO_VALOR				"2"

#DEFINE TEXTO_ATUALIZ_MOEDA			"ATUALIZACAO SALDO MOEDA ESTRANGEIRA"
#DEFINE CONSID_ATUAL_MOED_ESTRAG	"1"

//-----------------------------------------------------------------
/*/{Protheus.doc} ConcCTBFIN
Relatório de Conciliação Contábil x Financeiro

@type       Function
@author     Julio Lisboa
@since      31/08/2021
/*/
//-----------------------------------------------------------------
User Function ConcCTBFIN()

	local cTitulo				:= "Conciliação Contábil x Financeira"

	private cClienteFornec		:= ""
	private cTituloStatus		:= ""
	private cTitContabil		:= ""
	private aContas				:= {}
	private aStatus				:= {}

	private oRegua				:= nil
	private cDiretArquivo       := GetTempPath()
	private cNomeArquivo        := "Conciliacao_Contabil_x_fin_" + DTOS(DATE()) + "_" + strtran(time(),":","") + ".xml"

	oRegua	:= MsNewProcess():New( {|| fExecRelat()}, cTitulo, "Processando...",.F.)
	if fPerg()
		if MV_PAR01 == TIPO_CLIENTE
			cTituloStatus		:= "Status - CLIENTES - " + DTOC(MV_PAR02) + " até " + DTOC(MV_PAR03)
		else
			cTituloStatus		:= "Status - FORNECEDORES - " + DTOC(MV_PAR02) + " até " + DTOC(MV_PAR03)
		endif

		if MV_PAR12 == CONSID_ATUAL_MOED_ESTRAG
			cTitContabil		:= "Contabil - REMOVE LANCTO MANUAL DE ATUALIZAÇÃO CAMBIAL"
		else
			cTitContabil		:= "Contabil"
		endif

		oRegua:Activate()
	endif

return

//-----------------------------------------------------------------
static function fExecRelat()

	local oExcelApp				:= nil
	//private oExcel              := FWMsExcelEx():New()
	private oExcel              := FWMsExcel():New()

	oRegua:SetRegua1(4) //TODO
	oRegua:IncRegua1("Gerando aba Status...")
	criaAbaStatus()
	oRegua:IncRegua1("Gerando dados do Contábil...")
	geraContabil()
	oRegua:IncRegua1("Gerando dados do Financeiro...")
	geraFinanceiro()
	oRegua:IncRegua1("Gerando Conciliador...")
	geraConciliador()

	if len(aContas) > 0
		oExcel:Activate()
		oExcel:GetXMLFile( cDiretArquivo + cNomeArquivo )
	else
		MsgInfo("Nenhum registro localizado com os parâmetros informados",FunDesc())
	endif
	oExcel:DeActivate()

	if file(cDiretArquivo + cNomeArquivo)
		oExcelApp           := MsExcel():New()
		oExcelApp:WorkBooks:Open( cDiretArquivo + cNomeArquivo )
		oExcelApp:SetVisible(.T.)
		oExcelApp:Destroy()
	endif

return

//-----------------------------------------------------------------
static function criaAbaStatus()

	local cNomePlan             := "Status"

	oExcel:AddworkSheet( cNomePlan )
	oExcel:AddTable( cNomePlan , cTituloStatus )

	oExcel:AddColumn( cNomePlan , cTituloStatus, "Status",				ALINHAMENTO_ESQUERDA, 1 )
	oExcel:AddColumn( cNomePlan , cTituloStatus, "Saldo Atual",	 		ALINHAMENTO_DIREITA , 3 , .T. )

return

//-----------------------------------------------------------------
static function geraConciliador()

	local cNomePlan             := "Conciliação"
	local cNomeTabela           := "Conciliação"
	local nConta				:= 0
	local nStatus				:= 0
	local nDiferenca			:= 0
	local aItem					:= {}
	local aCelStyle				:= {}

	if len(aContas) > 0
		oExcel:AddworkSheet( cNomePlan )
		oExcel:AddTable( cNomePlan , cNomeTabela )

		oExcel:AddColumn( cNomePlan , cNomeTabela, "Conta",					ALINHAMENTO_ESQUERDA, 1 )
		oExcel:AddColumn( cNomePlan , cNomeTabela, "Descrição",				ALINHAMENTO_ESQUERDA, 1 )
		oExcel:AddColumn( cNomePlan , cNomeTabela, "Saldo Contábil", 		ALINHAMENTO_DIREITA , 3 , .T. )
		oExcel:AddColumn( cNomePlan , cNomeTabela, "Financeiro", 			ALINHAMENTO_DIREITA , 3 , .T. )
		oExcel:AddColumn( cNomePlan , cNomeTabela, "Diferença", 			ALINHAMENTO_DIREITA , 3 , .T. )

		for nConta := 1 to len(aContas)
			aItem		:= {}
			nDiferenca	:= Abs(aContas[nConta,SALDO_CONTA]) - Abs(aContas[nConta,SALDO_FINANC])

			aAdd( aItem , aContas[nConta,CODIGO_CONTA] )
			aAdd( aItem , aContas[nConta,DESCRIC_CONTA] )
			aAdd( aItem , aContas[nConta,SALDO_CONTA] )
			aAdd( aItem , aContas[nConta,SALDO_FINANC] )
			aAdd( aItem , nDiferenca )

			//TODO oExcel:SetCelFrColor("#000000")

			if Abs(nDiferenca) > 0
				//TODO oExcel:SetCelFrColor("#FF0000")
				//TODO aCelStyle		:= {5}
			else
				aCelStyle		:= {}
			endif
			oExcel:AddRow( cNomePlan , cNomeTabela , aItem , aCelStyle )
		next
	endif

	if len(aStatus) > 0
		for nStatus := 1 to len(aStatus)
			oExcel:AddRow( "Status" , cTituloStatus , aStatus[nStatus] , {} )
		next
	endif

return

//-----------------------------------------------------------------
static function geraFinanceiro()

	local nConta                := 0
	local nRegistros            := 0
	local cQryContas            := ""
	local cAliasContas          := getnextalias()
	local cNomePlan             := "Financeiro"
	local cNomeTabela           := "Financeiro"

	cQryContas      := retQueryContas()
	TcQuery cQryContas new alias &cAliasContas
	Count to nRegistros
	oRegua:SetRegua2(nRegistros)
	(cAliasContas)->(DbGoTop())

	if (cAliasContas)->(!Eof())
		oExcel:AddworkSheet( cNomePlan )
		oExcel:AddTable( cNomePlan , cNomeTabela )

		while (cAliasContas)->(!Eof())
			if nConta <= 0
				procFinanceiro( cNomePlan , cNomeTabela , (cAliasContas)->COD_CLIFOR , (cAliasContas)->LOJ_CLIFOR , @nConta , .T. )
			else
				procFinanceiro( cNomePlan , cNomeTabela , (cAliasContas)->COD_CLIFOR , (cAliasContas)->LOJ_CLIFOR , @nConta , .F. )
			endif

			if MV_PAR01 == TIPO_CLIENTE
				oRegua:IncRegua2("Processando o Cliente " + (cAliasContas)->COD_CLIFOR + "/" + (cAliasContas)->LOJ_CLIFOR + " - " + alltrim( (cAliasContas)->NOME_CLIFOR ) + "...")
			else
				oRegua:IncRegua2("Processando o fornecedor " + (cAliasContas)->COD_CLIFOR + "/" + (cAliasContas)->LOJ_CLIFOR + " - " + alltrim( (cAliasContas)->NOME_CLIFOR ) + "...")
			endif
			(cAliasContas)->(DbSkip())
		EndDo
	endif

	(cAliasContas)->(DbCloseArea())

return

//-----------------------------------------------------------------
static function procFinanceiro( cNomePlan , cNomeTabela ,  cCodCliFor , cLojaCliFor , nRegistros , lCriaColunas )

	local cQryTitulos		:= qryTitPagar(cCodCliFor,cLojaCliFor)
	local cAliasTitulos		:= getnextalias()
	local nTitulos			:= 0
	local aCamposFinanc		:= {}
	local nCampo			:= 0
	local cCampo			:= ""
	local cChaveTitulo		:= ""
	local aItem				:= {}
	local nSaldo			:= 0
	local aAreaSE1			:= SE1->(GetArea())
	local aAreaSE2			:= SE2->(GetArea())
	local nPosConta			:= 0
	local cCpoTitCol		:= "X3_TITULO" //"X3_DESCRIC"
	local cStatus			:= ""
	local lSeekTitulo		:= .F.

	if MV_PAR01 == TIPO_CLIENTE
		aAdd( aCamposFinanc , "A1_COD" )
		aAdd( aCamposFinanc , "A1_LOJA" )
		aAdd( aCamposFinanc , "A1_NOME" )
		aAdd( aCamposFinanc , "A1_CONTA" )
		aAdd( aCamposFinanc , "E1_PREFIXO" )
		aAdd( aCamposFinanc , "E1_NUM" )
		aAdd( aCamposFinanc , "E1_PARCELA" )
		aAdd( aCamposFinanc , "E1_TIPO" )
		aAdd( aCamposFinanc , "E1_EMISSAO" )
		aAdd( aCamposFinanc , "E1_VENCREA" )
		aAdd( aCamposFinanc , "E1_BAIXA" )
		aAdd( aCamposFinanc , "E1_EMIS1" )
		aAdd( aCamposFinanc , "PRAZO" )
		aAdd( aCamposFinanc , "E1_MOEDA" )
		aAdd( aCamposFinanc , "E1_VALOR" )
		aAdd( aCamposFinanc , "E1_VLCRUZ" )
		aAdd( aCamposFinanc , "E1_TXMOEDA" )
		aAdd( aCamposFinanc , "E1_SALDO" )
		aAdd( aCamposFinanc , "STATUS" )
	else
		aAdd( aCamposFinanc , "A2_COD" )
		aAdd( aCamposFinanc , "A2_LOJA" )
		aAdd( aCamposFinanc , "A2_NOME" )
		aAdd( aCamposFinanc , "A2_CONTA" )
		aAdd( aCamposFinanc , "E2_PREFIXO" )
		aAdd( aCamposFinanc , "E2_NUM" )
		aAdd( aCamposFinanc , "E2_PARCELA" )
		aAdd( aCamposFinanc , "E2_TIPO" )
		aAdd( aCamposFinanc , "E2_EMISSAO" )
		aAdd( aCamposFinanc , "E2_VENCREA" )
		aAdd( aCamposFinanc , "E2_BAIXA" )
		aAdd( aCamposFinanc , "E2_EMIS1" )
		aAdd( aCamposFinanc , "PRAZO" )
		aAdd( aCamposFinanc , "E2_MOEDA" )
		aAdd( aCamposFinanc , "E2_VALOR" )
		aAdd( aCamposFinanc , "E2_VLCRUZ" )
		aAdd( aCamposFinanc , "E2_TXMOEDA" )
		aAdd( aCamposFinanc , "E2_SALDO" )
		aAdd( aCamposFinanc , "STATUS" )
	endif

	if lCriaColunas
		nRegistros++
		for nCampo := 1 to len(aCamposFinanc)
			cCampo		:= aCamposFinanc[nCampo]

			if cCampo == "PRAZO"
				oExcel:AddColumn( cNomePlan , cNomeTabela, cCampo,		ALINHAMENTO_ESQUERDA, 1 )
			elseif cCampo == "STATUS"
				oExcel:AddColumn( cNomePlan , cNomeTabela, cCampo,		ALINHAMENTO_ESQUERDA, 1 )
			elseif alltrim(getsx3cache(cCampo,"X3_TIPO")) == "N"
				if cCampo $ "E1_MOEDA/E2_MOEDA"
					oExcel:AddColumn( cNomePlan , cNomeTabela, getsx3cache(cCampo,cCpoTitCol),		ALINHAMENTO_ESQUERDA, 1 )
				elseif cCampo $ "E1_SALDO/E2_SALDO"
					oExcel:AddColumn( cNomePlan , cNomeTabela, "Saldo R$", 							ALINHAMENTO_DIREITA , 3 , .T. )
				elseif cCampo $ "E1_TXMOEDA/E2_TXMOEDA"
					oExcel:AddColumn( cNomePlan , cNomeTabela, getsx3cache(cCampo,cCpoTitCol), 		ALINHAMENTO_DIREITA , 3 , .F. )
				else
					oExcel:AddColumn( cNomePlan , cNomeTabela, getsx3cache(cCampo,cCpoTitCol), 		ALINHAMENTO_DIREITA , 3 , .T. )
				endif
			elseif alltrim(getsx3cache(cCampo,"X3_TIPO")) == "D"
				oExcel:AddColumn( cNomePlan , cNomeTabela, getsx3cache(cCampo,cCpoTitCol),		ALINHAMENTO_DIREITA, 4 )
			else
				oExcel:AddColumn( cNomePlan , cNomeTabela, getsx3cache(cCampo,cCpoTitCol),		ALINHAMENTO_ESQUERDA, 1 )
			endif
		next
	endif

	TcQuery cQryTitulos new alias &cAliasTitulos
	Count to nTitulos
	(cAliasTitulos)->(DbGoTop())

	SE1->(DbSetOrder(2)) //E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
	SE2->(DbSetOrder(1)) //E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA

	while (cAliasTitulos)->(!Eof())
		aItem       := {}

		if MV_PAR01 == TIPO_CLIENTE
			cChaveTitulo	:= (cAliasTitulos)->E1_FILIAL
			cChaveTitulo	+= (cAliasTitulos)->E1_CLIENTE
			cChaveTitulo	+= (cAliasTitulos)->E1_LOJA
			cChaveTitulo	+= (cAliasTitulos)->E1_PREFIXO
			cChaveTitulo	+= (cAliasTitulos)->E1_NUM
			cChaveTitulo	+= (cAliasTitulos)->E1_PARCELA
			cChaveTitulo	+= (cAliasTitulos)->E1_TIPO
			lSeekTitulo		:= SE1->(DbSeek( cChaveTitulo ))
		else
			cChaveTitulo	:= (cAliasTitulos)->E2_FILIAL
			cChaveTitulo	+= (cAliasTitulos)->E2_PREFIXO
			cChaveTitulo	+= (cAliasTitulos)->E2_NUM
			cChaveTitulo	+= (cAliasTitulos)->E2_PARCELA
			cChaveTitulo	+= (cAliasTitulos)->E2_TIPO
			cChaveTitulo	+= (cAliasTitulos)->E2_FORNECE
			cChaveTitulo	+= (cAliasTitulos)->E2_LOJA
			lSeekTitulo		:= SE2->(DbSeek( cChaveTitulo ))
		endif

		If lSeekTitulo
			for nCampo := 1 to len(aCamposFinanc)
				cCampo		:= aCamposFinanc[nCampo]
				if alltrim(getsx3cache(cCampo,"X3_TIPO")) == "D"
					aAdd( aItem , STOD( (cAliasTitulos)->&(cCampo)) )
				else
					if cCampo $ "E1_MOEDA/E2_MOEDA"
						aAdd( aItem , AllTrim(Str( (cAliasTitulos)->&(cCampo) )) + "-" + getnewpar("MV_MOEDAP" + AllTrim(Str( (cAliasTitulos)->&(cCampo) )),"") )
					elseif cCampo == "PRAZO"
						if MV_PAR01 == TIPO_CLIENTE
							aAdd( aItem , STOD( (cAliasTitulos)->E1_VENCREA ) - STOD( (cAliasTitulos)->E1_EMISSAO ) )
						else
							aAdd( aItem , STOD( (cAliasTitulos)->E2_VENCREA ) - STOD( (cAliasTitulos)->E2_EMISSAO ) )
						endif
					elseif cCampo $ "E1_SALDO/E2_SALDO"
						if MV_PAR01 == TIPO_CLIENTE
							nSaldo		:= SaldoTit(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_NATUREZ,"R",SE1->E1_CLIENTE,SE1->E1_MOEDA,mv_par03,mv_par03,SE1->E1_LOJA,,nil,1)
							nSaldo		:= nSaldo * (iif( (cAliasTitulos)->E1_TXMOEDA > 0 , (cAliasTitulos)->E1_TXMOEDA , 1 ))
						else
							nSaldo		:= SaldoTit(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,SE2->E2_NATUREZ,"P",SE2->E2_FORNECE,SE2->E2_MOEDA,mv_par03,mv_par03,SE2->E2_LOJA,,nil,1)
							nSaldo		:= nSaldo * (iif( (cAliasTitulos)->E2_TXMOEDA > 0 , (cAliasTitulos)->E2_TXMOEDA , 1 ))
						endif
						aAdd( aItem , nSaldo )
					elseif cCampo == "STATUS"
						if MV_PAR01 == TIPO_CLIENTE
							cStatus		:= montaStatus( MV_PAR03 - STOD( (cAliasTitulos)->E1_VENCREA ) , nSaldo )
						else
							cStatus		:= montaStatus( MV_PAR03 - STOD( (cAliasTitulos)->E2_VENCREA ) , nSaldo )
						endif
						aAdd( aItem , cStatus )
					else
						aAdd( aItem , (cAliasTitulos)->&(cCampo) )
					endif
				endif
			next

			if MV_PAR01 == TIPO_CLIENTE
				nPosConta		:= aScan( aContas , { |x| x[CODIGO_CONTA] == (cAliasTitulos)->A1_CONTA } )
			else
				nPosConta		:= aScan( aContas , { |x| x[CODIGO_CONTA] == (cAliasTitulos)->A2_CONTA } )
			endif

			if nPosConta == 0
				if MV_PAR01 == TIPO_CLIENTE
					aAdd( aContas , { (cAliasTitulos)->A1_CONTA , (cAliasTitulos)->A1_NOME , 0 , iif(MV_PAR11==CAMPO_SALDO,nSaldo,(cAliasTitulos)->E1_VLCRUZ) , 0 , "" } )
				else
					aAdd( aContas , { (cAliasTitulos)->A2_CONTA , (cAliasTitulos)->A2_NOME , 0 , iif(MV_PAR11==CAMPO_SALDO,nSaldo,(cAliasTitulos)->E2_VLCRUZ) , 0 , "" } )
				endif
			else
				if MV_PAR01 == TIPO_CLIENTE
					aContas[nPosConta,SALDO_FINANC]	+= iif(MV_PAR11==CAMPO_SALDO,nSaldo,(cAliasTitulos)->E1_VLCRUZ)
				else
					aContas[nPosConta,SALDO_FINANC]	+= iif(MV_PAR11==CAMPO_SALDO,nSaldo,(cAliasTitulos)->E2_VLCRUZ)
				endif
			endif

			oExcel:AddRow( cNomePlan , cNomeTabela , aItem , {} )
		endif

		(cAliasTitulos)->(DbSkip())
	enddo

	restArea(aAreaSE1)
	restArea(aAreaSE2)

return

//-----------------------------------------------------------------
static function geraContabil()

	local nConta                := 0
	local nRegistros            := 0
	local cQryContas            := ""
	local cAliasContas          := getnextalias()
	local cNomePlan             := "Contabil"

	cQryContas      := retQueryContas()
	TcQuery cQryContas new alias &cAliasContas
	Count to nRegistros
	oRegua:SetRegua2(nRegistros)
	(cAliasContas)->(DbGoTop())

	if (cAliasContas)->(!Eof())
		oExcel:AddworkSheet( cNomePlan )
		oExcel:AddTable( cNomePlan , cTitContabil )

		while (cAliasContas)->(!Eof())
			if nConta <= 0
				procContabil( cNomePlan , cTitContabil , (cAliasContas)->CONTA_CLIFOR , @nConta , .T. )
			else
				procContabil( cNomePlan , cTitContabil , (cAliasContas)->CONTA_CLIFOR , @nConta , .F. )
			endif

			oRegua:IncRegua2("Processando a conta " + (cAliasContas)->CONTA_CLIFOR + "...")
			(cAliasContas)->(DbSkip())
		EndDo
	endif

	(cAliasContas)->(DbCloseArea())

return

//-----------------------------------------------------------------
static function fPerg()

	local aParamBox     := {}
	local aCampo		:= {}
	local cTiposNot		:= "'PR','PRE','PA'" + space(400)

	private bFuncTipos	:= { || opcTipos() }

	aAdd( aCampo , CAMPO_SALDO + "=" + "Saldo" )
	aAdd( aCampo , CAMPO_VALOR + "=" + "Valor" )

	aAdd(aParamBox,{2,"Cliente/Fornec."			,"1",{"1=Cliente","2=Fornecedor"},70,"",.T.})	//MV_PAR01
	aAdd(aParamBox,{1,"Data de",        		Ctod("")	,""	,""	,""	,""	,60,.T.}) //MV_PAR02
	aAdd(aParamBox,{1,"Data ate",       		Ctod("")	,""	,""	,""	,""	,60,.T.}) //MV_PAR03
	Aadd(aParambox,{1,"Codigo De",  			Space(TamSX3("A2_COD")[1]),"","","SA2","",80,.F.}) //MV_PAR04
	Aadd(aParambox,{1,"Loja De",        		Space(TamSX3("A2_LOJA")[1]),"","","","",40,.F.}) //MV_PAR05
	Aadd(aParambox,{1,"Codigo Ate", 			Space(TamSX3("A2_COD")[1]),"","","SA2","",80,.T.}) //MV_PAR06
	Aadd(aParambox,{1,"Loja Ate",       		Space(TamSX3("A2_LOJA")[1]),"","","","",40,.T.}) //MV_PAR07
	aAdd(aParamBox,{2,"Filtra Por tipos?"		,"1",{"1=Não","2=Sim"},60,"",.T.})	//MV_PAR08
	Aadd(aParambox,{1,"Tipos Titulos",			Space(400),"","Eval(bFuncTipos)","","MV_PAR08=='2'",90,.F.}) //MV_PAR09
	Aadd(aParambox,{1,"Não Considerar Tipos",	cTiposNot,"","Eval(bFuncTipos)","","MV_PAR08=='2'",90,.F.}) //MV_PAR10
	aAdd(aParamBox,{2,"Campo a Considerar"		,"1",aCampo,70,"",.T.})	//MV_PAR11
	aAdd(aParamBox,{2,"Remove Lancto Manual de Atualiz. Moeda?"		,"1",{"1=Sim","2=Não"},70,"",.T.})	//MV_PAR12

return ParamBox(aParamBox,"Parametros",,,,.T.,,,,"ConcCTBFIN",.F.,.F.)

//-----------------------------------------------------------------
static function retQueryContas()

	local cQuery            := ""

	cQuery      += "SELECT " + CRLF

	If MV_PAR01 == TIPO_CLIENTE
		cQuery      += "	DISTINCT A1_COD COD_CLIFOR,A1_LOJA LOJ_CLIFOR,A1_NOME NOME_CLIFOR,A1_CONTA CONTA_CLIFOR" + CRLF
	else
		cQuery      += "	DISTINCT A2_COD COD_CLIFOR,A2_LOJA LOJ_CLIFOR,A2_NOME NOME_CLIFOR,A2_CONTA CONTA_CLIFOR" + CRLF
	endif

	cQuery      += "FROM " + CRLF

	if MV_PAR01 == TIPO_CLIENTE
		cQuery      += "    " + RetSqlTab("SA1") + CRLF
	else
		cQuery      += "    " + RetSqlTab("SA2") + CRLF
	endif

	cQuery      += "	INNER JOIN " + CRLF
	cQuery      += "    	" + RetSqlTab("CT2") + CRLF
	cQuery      += "		ON CT2.D_E_L_E_T_ = ' ' " + CRLF
	cQuery      += "		AND CT2_DATA BETWEEN '" + dtos(MV_PAR02) + "' AND '" + dtos(MV_PAR03) + "' " + CRLF

	if MV_PAR01 == TIPO_CLIENTE
		cQuery      += "		AND ( CT2_DEBITO = A1_CONTA OR CT2_CREDIT = A1_CONTA ) " + CRLF
		cQuery      += "WHERE " + CRLF
		cQuery      += "    SA1.D_E_L_E_T_ = ' ' " + CRLF
		cQuery      += "    AND A1_COD BETWEEN '" + MV_PAR04 + "' AND '" + MV_PAR06 + "' " + CRLF
		cQuery      += "    AND A1_LOJA BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR07 + "' " + CRLF
		cQuery      += "    AND A1_CONTA <> ' ' " + CRLF
	else
		cQuery      += "		AND ( CT2_DEBITO = A2_CONTA OR CT2_CREDIT = A2_CONTA ) " + CRLF
		cQuery      += "WHERE " + CRLF
		cQuery      += "    SA2.D_E_L_E_T_ = ' ' " + CRLF
		cQuery      += "    AND A2_COD BETWEEN '" + MV_PAR04 + "' AND '" + MV_PAR06 + "' " + CRLF
		cQuery      += "    AND A2_LOJA BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR07 + "' " + CRLF
		cQuery      += "    AND A2_CONTA <> ' ' " + CRLF
	endif

	cQuery      += "ORDER BY " + CRLF

	if MV_PAR01 == TIPO_CLIENTE
		cQuery      += "    A1_COD,A1_LOJA" + CRLF
	else
		cQuery      += "    A2_COD,A2_LOJA" + CRLF
	endif

	cQuery      += "" + CRLF

return cQuery

//-----------------------------------------------------------------
static function procContabil( cNomePlan , cNomeTabela ,  cConta , nRegistros , lCriaColunas )

	local aAreaAtual        := GetArea()
	local cArqTmp           := ""

	local dDataDe           := MV_PAR02
	local dDataAte          := MV_PAR03

	local cCtaIni           := cConta
	local cCtaFim           := cConta

	local cItemIni          := Padr('',tamsx3('CTD_ITEM')[1],'')
	local cItemFim          := Padr('',tamsx3('CTD_ITEM')[1],'Z')
	local cMoeda            := "01"
	local cSaldo            := "1"
	local cTabSld           := 'CT7'
	local aSetOfBook        := CTBSetOf('')
	local cSegmento         := ""
	local cSegIni           := ""
	local cSegFim           := ""
	local cFiltSegm         := ""
	local l132              := .T.
	local cHeader           := "CT1"
	local lImpAntLP         := .F.
	local dDataLP           := stod("")
	local nDivide           := 0
	local lVlrZerado        := .F.
	local cSegmentoG        := ""
	local cSegIniG          := ""
	local cSegFimG          := ""
	local cFiltSegmG        := ""
	local lImpMov           := .T.
	local lImpSint          := .F.
	local cFilUser          := ""
	local lRecDesp0         := .F.
	local cRecDesp          := ""
	local dDtZeraRD         := stod("")
	local aSelFil           := {} //{'01'}
	local lCttSint          := .F.
	local nPosConta			:= 0
	local nSaldoAtual		:= 0
	local nVlrAtualizCamb	:= 0

	local aItem             := {}
	local aCampos           := {}

	CTGerPlan(,,,,@cArqTmp,;
		dDataDe,dDataAte,cTabSld,"",cCtaIni,cCtaFim,,,cItemIni,cItemFim,,,cMoeda,;
		cSaldo,aSetOfBook ,cSegmento,cSegIni,cSegFim,cFiltSegm,l132,.T.,,cHeader,;
		lImpAntLP,dDataLP,nDivide,lVlrZerado,,,cSegmentoG,cSegIniG,cSegFimG,cFiltSegmG,,,,,,,lImpMov,lImpSint,cFilUser,lRecDesp0,;
		cRecDesp,dDtZeraRD,,,,,,,,,aSelFil,,,,,,,,lCttSint,.T.)

	If !cArqTmp->(Eof())
		aCampos     := cArqTmp->(DbStruct())

		if lCriaColunas
			nRegistros++

			oExcel:AddColumn( cNomePlan , cNomeTabela, "Conta", 			ALINHAMENTO_ESQUERDA, 1 )
			oExcel:AddColumn( cNomePlan , cNomeTabela, "Descrição",			ALINHAMENTO_ESQUERDA, 1 )
			oExcel:AddColumn( cNomePlan , cNomeTabela, "Saldo Anterior", 	ALINHAMENTO_DIREITA , 3 , .T. )
			oExcel:AddColumn( cNomePlan , cNomeTabela, "Débito", 			ALINHAMENTO_DIREITA , 3 , .T. )
			oExcel:AddColumn( cNomePlan , cNomeTabela, "Crédito", 			ALINHAMENTO_DIREITA , 3 , .T. )
			oExcel:AddColumn( cNomePlan , cNomeTabela, "Movimento", 		ALINHAMENTO_DIREITA , 3 , .T. )

			if MV_PAR12 == CONSID_ATUAL_MOED_ESTRAG
				oExcel:AddColumn( cNomePlan , cNomeTabela, "Lancto Atualiz Moeda", 	ALINHAMENTO_DIREITA , 3 , .T. )
				oExcel:AddColumn( cNomePlan , cNomeTabela, "Saldo Atual", 			ALINHAMENTO_DIREITA , 3 , .T. )
				oExcel:AddColumn( cNomePlan , cNomeTabela, "Saldo Calculado",		ALINHAMENTO_DIREITA , 3 , .T. )
			else
				oExcel:AddColumn( cNomePlan , cNomeTabela, "Saldo Atual", 		ALINHAMENTO_DIREITA , 3 , .T. )
			endif
		endif

		while !cArqTmp->(Eof())
			nSaldoAtual			:= cArqTmp->SALDOATU

			aItem       := {}
			aAdd( aItem , cArqTmp->CONTA )
			aAdd( aItem , cArqTmp->DESCCTA )
			aAdd( aItem , cArqTmp->SALDOANT )
			aAdd( aItem , cArqTmp->SALDODEB )
			aAdd( aItem , cArqTmp->SALDOCRD )
			aAdd( aItem , cArqTmp->MOVIMENTO )

			if MV_PAR12 == CONSID_ATUAL_MOED_ESTRAG
				nVlrAtualizCamb		:= valorTaxaCambial( cArqTmp->CONTA , MV_PAR02 , MV_PAR03 )

				aAdd( aItem , nVlrAtualizCamb )
				aAdd( aItem , nSaldoAtual )

				if MV_PAR01 == TIPO_CLIENTE
					nSaldoAtual			-= nVlrAtualizCamb
				else
					nSaldoAtual			+= nVlrAtualizCamb
				endif
				aAdd( aItem , nSaldoAtual )
			else
				aAdd( aItem , nSaldoAtual )
			endif

			nPosConta		:= aScan( aContas , { |x| x[CODIGO_CONTA] == cArqTmp->CONTA } )
			if nPosConta == 0
				aAdd( aContas , { cArqTmp->CONTA , cArqTmp->DESCCTA , nSaldoAtual , 0 , 0 , "" } )
				oExcel:AddRow( cNomePlan , cNomeTabela , aItem , {} )
			endif

			cArqTmp->(dbskip())
		endDo
	endif

	cArqTmp->(DbCloseArea())
	restArea(aAreaAtual)

Return

//-----------------------------------------------------------------
static function montaStatus(nDias,nValor)

	local cRet			:= ""
	local nPosicao		:= 0

	if len(aStatus) == 0
		aAdd( aStatus , { "(a.1) A vencer acima de 90 dias",	0 } )
		aAdd( aStatus , { "(a.2) A vencer de 61 a 90 dias",		0 } )
		aAdd( aStatus , { "(a.3) A vencer de 31 a 60 dias",		0 } )
		aAdd( aStatus , { "(a.4) A vencer até 30 dias",			0 } )
		aAdd( aStatus , { "(b) Vencidos até 30 dias",			0 } )
		aAdd( aStatus , { "(c) Vencidos de 31 a 60 dias",		0 } )
		aAdd( aStatus , { "(d) Vencidos de 61 a 90 dias",		0 } )
		aAdd( aStatus , { "(e) Vencidos de 91 a 120 dias",		0 } )
		aAdd( aStatus , { "(f) Vencidos de 121 a 150 dias",		0 } )
		aAdd( aStatus , { "(g) Vencidos de 151 a 180 dias",		0 } )
		aAdd( aStatus , { "(h) Vencidos de 181 a 360 dias",		0 } )
		aAdd( aStatus , { "(i) Vencidos acima de 360 dias",		0 } )
	endif

	if nDias < -90
		nPosicao	+= 1
		cRet:= 'a.1'
	elseif nDias < -60
		nPosicao	+= 2
		cRet:= 'a.2'
	elseif nDias < -30
		nPosicao	+= 3
		cRet:= 'a.3'
	elseif nDias < 1
		nPosicao	+= 4
		cRet:= 'a.4'
	elseif nDias < 31
		nPosicao	+= 5
		cRet:= 'b'
	elseif nDias < 61
		nPosicao	+= 6
		cRet:= 'c'
	elseif nDias < 91
		nPosicao	+= 7
		cRet:= 'd'
	elseif nDias < 121
		nPosicao	+= 8
		cRet:= 'e'
	elseif nDias < 151
		nPosicao	+= 9
		cRet:= 'f'
	elseif nDias < 181
		nPosicao	+= 10
		cRet:= 'g'
	elseif nDias < 361
		nPosicao	+= 11
		cRet:= 'h'
	else
		nPosicao	+= 12
		cRet:= 'i'
	endif

	if nPosicao > 0
		aStatus[nPosicao,2]		+= nValor
	endif

return cRet

//-----------------------------------------------------------------
static function qryTitPagar(cCodigo,cLoja)

	local cQuery		:= ""

	cQuery		+= "SELECT " + CRLF
	cQuery		+= "	*" + CRLF
	cQuery		+= "FROM " + CRLF

	if MV_PAR01 == TIPO_CLIENTE
		cQuery		+= "	" + RetSqlTab("SE1") + CRLF
		cQuery		+= "INNER JOIN" + CRLF
		cQuery		+= "	" + RetSqlTab("SA1") + CRLF
		cQuery		+= "	ON SA1.D_E_L_E_T_ = ' '" + CRLF
		cQuery		+= "		AND A1_FILIAL = '" + FwXFilial("SA1") + "'" + CRLF
		cQuery		+= "		AND A1_COD = E1_CLIENTE" + CRLF
		cQuery		+= "		AND A1_LOJA = E1_LOJA" + CRLF
	else
		cQuery		+= "	" + RetSqlTab("SE2") + CRLF
		cQuery		+= "INNER JOIN" + CRLF
		cQuery		+= "	" + RetSqlTab("SA2") + CRLF
		cQuery		+= "	ON SA2.D_E_L_E_T_ = ' '" + CRLF
		cQuery		+= "		AND A2_FILIAL = '" + FwXFilial("SA2") + "'" + CRLF
		cQuery		+= "		AND A2_COD = E2_FORNECE" + CRLF
		cQuery		+= "		AND A2_LOJA = E2_LOJA" + CRLF
	endif

	cQuery		+= "WHERE " + CRLF

	if MV_PAR01 == TIPO_CLIENTE
		cQuery		+= "	SE1.D_E_L_E_T_ = ' ' " + CRLF
		cQuery		+= "	AND A1_COD = '" + cCodigo + "' " + CRLF
		cQuery		+= "	AND A1_LOJA = '" + cLoja + "' " + CRLF
		cQuery		+= "	AND E1_EMIS1 <= '" + DTOS(MV_PAR03) + "' " + CRLF
		cQuery		+= "	AND (E1_BAIXA = '' OR E1_BAIXA > '" + DTOS(MV_PAR03) + "' )" + CRLF

		if !Empty(MV_PAR09)
			cQuery		+= "	AND E1_TIPO IN (" + MV_PAR09 + ")"
		endif

		if !Empty(MV_PAR10)
			cQuery		+= "	AND E1_TIPO NOT IN (" + MV_PAR10 + ")"
		endif
	else
		cQuery		+= "	SE2.D_E_L_E_T_ = ' ' " + CRLF
		cQuery		+= "	AND A2_COD = '" + cCodigo + "' " + CRLF
		cQuery		+= "	AND A2_LOJA = '" + cLoja + "' " + CRLF
		cQuery		+= "	AND E2_EMIS1 <= '" + DTOS(MV_PAR03) + "' " + CRLF
		cQuery		+= "	AND (E2_BAIXA = '' OR E2_BAIXA > '" + DTOS(MV_PAR03) + "' )" + CRLF

		if !Empty(MV_PAR09)
			cQuery		+= "	AND E2_TIPO IN (" + MV_PAR09 + ")"
		endif

		if !Empty(MV_PAR10)
			cQuery		+= "	AND E2_TIPO NOT IN (" + MV_PAR10 + ")"
		endif
	endif

return cQuery

//-----------------------------------------------------------------
static function opcTipos()

	local cRet			:= ""
	local cTipos		:= ""
	local nTamChave		:= tamsx3("E2_TIPO")[1]
	local aTipos		:= montaTipos(@cTipos,nTamChave)
	local cTiposSelec	:= ""
	local nTipos		:= 0

	Private MvRet	:= Alltrim(ReadVar())

	If f_Opcoes(@cRet,"Tipos",aTipos,cTipos,12,49,.F.,nTamChave,Len(aTipos))
		cRet		:= StrTran( cRet , "*" , "" )
		for nTipos := 1 to len(cRet) step nTamChave
			if empty(cTiposSelec)
				cTiposSelec += "'" + substr(cRet,nTipos,nTamChave) + "'"
			else
				cTiposSelec += ",'" + substr(cRet,nTipos,nTamChave) + "'"
			endif
		next
		&MvRet	:= cTiposSelec
	endif

return .T.

//-----------------------------------------------------------------
static function montaTipos(cTipos,nTamChave)

	local aTipos		:= {}
	local cQuery		:= ""
	local cAlias		:= getnextalias()

	cQuery	+= "SELECT " + CRLF
	cQuery	+= "	* " + CRLF
	cQuery	+= "FROM " + CRLF
	cQuery	+= "	" + RetSqlTab("SX5") + CRLF
	cQuery	+= "WHERE " + CRLF
	cQuery	+= "	SX5.D_E_L_E_T_ = ' '" + CRLF
	cQuery	+= "	AND X5_TABELA = '05'" + CRLF
	cQuery	+= "	AND X5_FILIAL = '" + FwXFilial("SX5") + "'" + CRLF
	cQuery	+= "" + CRLF

	TcQuery cQuery new alias &(cAlias)

	while (cAlias)->(!eof())
		aAdd( aTipos , substr( (cAlias)->X5_CHAVE , 1 , nTamChave ) + SEPARADOR_TIPOS + alltrim((cAlias)->X5_DESCRI) )
		cTipos		+= substr( (cAlias)->X5_CHAVE , 1 , nTamChave )
		(cAlias)->(DbSkip())
	endDo

	(cAlias)->(DbCloseArea())

return aTipos

//-----------------------------------------------------------------
static function valorTaxaCambial(cConta,dDataInicio,dDataFim)

	local nRet		:= 0
	local cQuery	:= ""
	local cAlias	:= getnextalias()

	cQuery		+= "SELECT " + CRLF
	cQuery		+= "	SUM(CT2_VALOR) VALOR " + CRLF
	cQuery		+= "FROM " + CRLF
	cQuery		+= "	" + retsqltab("CT2") + CRLF
	cQuery		+= "WHERE " + CRLF
	cQuery		+= "	CT2.D_E_L_E_T_ = ' ' " + CRLF
	cQuery		+= "	AND CT2_MANUAL = '1' " + CRLF

	if MV_PAR01 == TIPO_CLIENTE
		cQuery		+= "	AND CT2_CREDIT = '" + cConta + "'" + CRLF
	else
		cQuery		+= "	AND CT2_DEBITO = '" + cConta + "'" + CRLF
	endif

	cQuery		+= "	AND CT2_DATA BETWEEN '" + DTOS(dDataInicio) + "' AND '" + DTOS(dDataFim) + "' " + CRLF
	cQuery		+= "	AND CT2_HIST LIKE '" + TEXTO_ATUALIZ_MOEDA + "%'" + CRLF
	cQuery		+= "" + CRLF

	TcQuery cQuery new Alias &cAlias

	if (cAlias)->(!Eof())
		nRet		:= (cAlias)->VALOR
	endif

	(cAlias)->(DbCloseArea())

return nRet
