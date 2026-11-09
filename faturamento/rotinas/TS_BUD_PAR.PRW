#Include "Protheus.ch"
#Include "Topconn.ch"

/*----------------------------------------------------------------------------------------------------------------------------------------------
Tuning Sistemas: Programa Budget Parafix
Elaborado por: Alex Kubo em 04/03/2016
Finalidade: Rotina personalizada de budget com base no calendário contábil X cadastro de cliente X produto (receitas)
e calendário contábil X plano de contas X centros de custo (despesas)
Informações e histórico:
Consultas padrão específicas: 	Z5_CAL (descr Z5 CAL C/EXERC)
Z6_CLI (descr Z6 CONS CLIENTE)
Z6_PRO (descr Z6 PROD PRVENDA)
Gatilhos:                       Z6_PRODUTO, Z6_QUANT e Z6_PRECO (->Z6_TOTAL)
Z6_CLIENTE (->Z6_LOJA ->Z6_NREDUZ)
Primeira validação e compilação na base de produção do cliente: 24/03/2016
----------------------------------------------------------------------------------------------------------------------------------------------*/

user function TS_BUD_PAR()

	//browse
	local 	aCores 		:= {}
	private cAlias      := "SZ5"
	private cCadastro 	:= "Budget Parafix"
	private aRotina	  	:= {}
	//assistente
	private cCalend		:=CriaVar("Z5_CALEND"	, .T.)
	private cExerc 		:=CriaVar("Z5_EXERC"	, .T.)
	private cTipo  		:=CriaVar("Z5_TIPO"		, .T.)
	private aTipoItens
	private cDoc, cComboTipo, lNovo := .T.
	//acols
	private aHeader		:= {}
	private aCols		:= {}
	private aRecno      := {}
	private dData  		:=CriaVar("Z5_DATA"		, .T.)
	private cFirmado  	:=CriaVar("Z5_FIRMADO"	, .T.)
	private cRevisao  	:=space(TamSX3("Z5_REVISAO")[1])
	private cRevbase
	private cUser 		:=alltrim(UsrRetName(RetCodUsr()))
	private cRD
	private cQuery
	private aClientes := {}
	private aAlterar  := {}

	AADD(aRotina,{"Pesquisar"	,"AxPesqui"	,0,1})
	AADD(aRotina,{"Visualizar"	,"U_VISITE"	,0,2})
	AADD(aRotina,{"Incluir" 	,"U_INCASP1",0,3})
	AADD(aRotina,{"Alterar"		,"U_ALTABR"	,0,4})
	AADD(aRotina,{"Firmar"      ,"U_BUDATU"	,0,5})
	AADD(aRotina,{"Replicar doc"		,"U_REPBUD"	,0,7})
	AADD(aRotina,{"Legenda"		,"U_MNTLEG"	,0,6})

	AADD(aCores,{"Z5_TIPO == 'R' .AND. Z5_FIRMADO == 'S'" 		,"BR_VERDE" 	})
	AADD(aCores,{"Z5_TIPO == 'D' .AND. Z5_FIRMADO == 'S'" 		,"BR_VERMELHO" 	})
	AADD(aCores,{"Z5_TIPO == 'F' .AND. Z5_FIRMADO == 'S'" 		,"BR_AZUL" 	})
	AADD(aCores,{"Z5_FIRMADO == 'A'" 	  						,"BR_AMARELO" 	})
	AADD(aCores,{"Z5_FIRMADO == 'N'" 							,"BR_PRETO" 	})

	CLIQRY()
	dData := date()
	dbSelectArea(cAlias)
	dbSetOrder(1)
	mBrowse(6,1,22,75,cAlias,,,,,,aCores)

return

//funções principais
//XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

//-----------------------------------------------------------------------------------------------------------------------------------------
//visualiza os registros SZ6
user Function VISITE()

	iif(Z5_TIPO = "D", cRD := "D", cRD := "R")
	FHEADER()
	FACOLS()
	cDoc := SZ5->Z5_DOC
	GERQRY()
	POPACOLS()
	QRY->(DbCloseArea())
	aTitgrid := {"Visualizar itens do documento "," "}
	EXBGRD()

return

//assistente de inclusao
//-----------------------------------------------------------------------------------------------------------------------------------------
user function INCASP1()

	local oTipo, cCombo := space(30)
	local oDlg
	local bCancel	:= {|| RollBackSX8(),oDlg:End()}
	local bOk		:= {|| INCASP2(), oDlg:End()}
	local cLinha1    := "Este assistente permite a inclusão de novo budget de receitas, despesas ou forecast."
	local cLinha2    := "Passo 1: selecione a opção desejada:"

	LMPVAR()
	aTipoItens 	:= {"Budget Receitas","Budget Despesas","Forecast"}
	cComboTipo := ""
	Define MsDialog oDlg From 0,0 to 250,500 Title "Assistente de inclusão Passo 1/4" Pixel
	@ 10,10		Say cLinha1 of oDlg Pixel
	@ 20,10		Say cLinha2 of oDlg Pixel
	oTipo:= tComboBox():New(40,10,{|u|if(PCount()>0,cComboTipo:=u,cComboTipo)},aTipoItens,90,20,oDlg,,,,,,.T.,,,,,,,,,"cComboTipo")
	Activate MsDialog oDlg Centered on Init EnchoiceBar(oDlg,bOK,bCancel)

return

//-----------------------------------------------------------------------------------------------------------------------------------------
static function INCASP2()

	local oDlg
	local bCancel	:= {||oDlg:End()}
	local cLinha1    := "Passo 2: deseja gerar novo " + cComboTipo + " ou uma revisão?"
	local cLinha2    := "________________________________________________________________________"
	local cLinha3    := " ->Um novo " + cComboTipo + " é baseado na tabela de preços do sistema"
	local cLinha4    := " ->Uma revisão é baseada em um " + cComboTipo + " já cadastrado"

	Define MsDialog oDlg From 0,0 to 250,500 Title "Assistente de inclusão Passo 2/4" Pixel
	@ 10,10 	Say cLinha1 of oDlg Pixel
	@ 10,10 	Say cLinha2 of oDlg Pixel
	@ 20,10 	Say cLinha3 of oDlg Pixel
	@ 30,10 	Say cLinha4 of oDlg Pixel
	@ 50,10 	button "Novo " + cComboTipo  size 60, 15 Pixel of oDlg action (lNovo := .T., oDlg:End())
	@ 50,75 	button "Gerar Revisão" 		 size 60, 15 Pixel of oDlg action (lNovo := .F., oDlg:End())
	@ 50,150 	button "Cancelar"  size 30, 15 Pixel of oDlg action (oDlg:End())
	Activate MsDialog oDlg Centered

	INCASP3()

return

//-----------------------------------------------------------------------------------------------------------------------------------------
static function INCASP3()

	local oDlg
	local bCancel	:= {|| oDlg:End()}
	local bOk

	do case
		case cComboTipo = aTipoItens[1]
		cTipo := "R"
		cRD := "R"
		bOk	:= {|| MNTREC(), oDlg:End()}
		case cComboTipo = aTipoItens[2]
		cTipo := "D"
		cRD := "D"
		bOk	:= {|| MNTDES(), oDlg:End()}
		case cComboTipo = aTipoItens[3]
		cTipo := "F"
		cRD := "R"
		bOk	:= {|| MNTREC(), oDlg:End()}
	endcase

	iif(lNovo, cLinha := "Passo 3: Entre com o calendário contábil e exercício:", cLinha := "Passo 3: Entre com o calendário contábil, exercício e revisão base:")
	Define MsDialog oDlg From 0,0 to 250,500 Title "Assistente de inclusão Passo 3/4" Pixel
	@ 10,10		Say 	cLinha  of oDlg Pixel
	@ 30,10		Say 	"Calendario" 	of oDlg 		   		Pixel
	@ 30,40		MsGet 	cCalend 		of oDlg F3 "Z5CAL" 	Pixel Size 20,7
	@ 30,80		Say 	"Exercicio" 	of oDlg 		   		Pixel
	@ 30,120	MsGet 	cExerc	   		of oDlg 		 		Pixel Size 20,7
	if !lNovo
		@ 30,160 Say 	"Revisão base" 	of oDlg Pixel
		@ 30,200 MsGet 	cRevisao    	of oDlg Pixel Size 20,7	Valid VLDREV()
		bOk	:= {|| CLOREV(), oDlg:End()}
	endif
	Activate MsDialog oDlg Centered on Init EnchoiceBar(oDlg,bOK,bCancel)

return

//-----------------------------------------------------------------------------------------------------------------------------------------
//altera documento aberto
user Function ALTABR()

	if SZ5->Z5_FIRMADO = "A"
		iif(Z5_TIPO = "D", cRD := "D", cRD := "R")
		FHEADER()
		FACOLS()
		cDoc := SZ5->Z5_DOC
		GERQRY()
		POPACOLS()
		QRY->(DbCloseArea())
		aTitgrid := {"Alterar documento aberto ","Alterar, excluir ou incluir valores na revisão"}
		EXBGRD()
	else
		alert("Somente é possível alterar um documento com status aberto. Neste caso, gere uma nova revisão.")
	endif

return

//marcar revisão como atual
//-----------------------------------------------------------------------------------------------------------------------------------------
user function BUDATU()

	local lRet := .T.

	do case
		case Z5_FIRMADO = "A"
		cCalend := alltrim(SZ5->Z5_CALEND)
		cExerc := alltrim(SZ5->Z5_EXERC)
		cTipo := alltrim(SZ5->Z5_TIPO)
		cRevisao := alltrim(SZ5->Z5_REVISAO)
		lRet := MsgNoYes("Deseja firmar o documento " + alltrim(Z5_DOC) + "?")
		iif (lRet, ALTFIR(),)
		LMPVAR()
		case Z5_FIRMADO = "S"
		alert("Documento já firmado.")
		otherwise
		alert("Não é possível firmar um documento obsoleto. Neste caso, crie uma nova revisão.")
	endcase

return

//-----------------------------------------------------------------------------------------------------------------------------------------
//legenda
user function MNTLEG()

	local aLegenda:={}
	AADD(aLegenda,{"BR_VERDE"	, "Budget Receita"	})
	AADD(aLegenda,{"BR_VERMELHO", "Budget Despesa"	})
	AADD(aLegenda,{"BR_AZUL"	, "Forecast Receita"})
	AADD(aLegenda,{"BR_AMARELO"	, "Revisão aberta"	})
	AADD(aLegenda,{"BR_PRETO"	, "Revisão anterior"})
	BrwLegenda(cCadastro,"Status do budget",aLegenda)

return

//-----------------------------------------------------------------------------------------------------------------------------------------
//replicar budget
user function REPBUD()

	local oTipo, cCombo := space(30)
	local oDlg
	local bOk		:= {|| GERREP(), oDlg:End()}
	local bCancel	:= {|| oDlg:End()}
	local cLinha    := "Entre com o novo calendário e o tipo de documento a gerar:"

	iif(SZ5->Z5_TIPO = "D", aTipoItens := {"Budget Despesas"}, aTipoItens 	:= {"Budget Receitas","Forecast"})
	Define MsDialog oDlg From 0,0 to 250,500 Title "Replicar documento para outro calendário" Pixel
	@ 10,10		Say 	cLinha  of oDlg Pixel
	@ 30,10		Say 	"Calendario" 	of oDlg 		   		Pixel
	@ 30,40		MsGet 	cCalend 		of oDlg F3 "Z5CAL" 	Pixel Size 20,7
	@ 30,80		Say 	"Exercicio" 	of oDlg 		   		Pixel
	@ 30,120	MsGet 	cExerc	   		of oDlg 		 		Pixel Size 20,7
	oTipo:= tComboBox():New(50,10,{|u|if(PCount()>0,cComboTipo:=u,cComboTipo)},aTipoItens,90,20,oDlg,,,,,,.T.,,,,,,,,,"cComboTipo")
	Activate MsDialog oDlg Centered on Init EnchoiceBar(oDlg,bOK,bCancel)

//funções auxiliares
//XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

//gerar a réplica do documento em outro calendário
//-----------------------------------------------------------------------------------------------------------------------------------------
static function GERREP()

	local cDocbase, aCampos := {}
	Local aCpoSx3 := FWSX3Util():GetAllFields("SZ6", .f.)


	aCampos := {}
	do case
		case cComboTipo = "Budget Despesas"
		cTipo := "D"
		case cComboTipo = "Budget Receitas"
		cTipo := "R"
		case cComboTipo = "Forecast"
		cTipo := "F"
	endcase
	ULTREV()
	cDocbase := SZ5->Z5_DOC
	cDoc := SZ5->Z5_DOC
	cRevbase := SZ5->Z5_REVISAO
	dbselectarea("SZ6")
	dbgotop()

	For nX := 1 to Len(aCpoSx3)
		aAdd(aCampos,{getSX3Cache(aCpoSx3[nX], "X3_CAMPO")})
	Next nX



	SX3->(DbCloseArea())
	GERQRY()
	cDoc := cCalend + cExerc + cTipo + cRevisao
	ALTFIR()
	//grava SZ5
	dbselectarea("SZ5")
	dbgotop()
	RecLock("SZ5",.T.)
	SZ5->Z5_FILIAL 		:= xFilial("SZ5")
	SZ5->Z5_DOC         := cDoc
	SZ5->Z5_CALEND		:= cCalend
	SZ5->Z5_EXERC		:= CExerc
	SZ5->Z5_REVISAO		:= cRevisao
	SZ5->Z5_REVBASE     := cRevbase
	SZ5->Z5_DATA 		:= dData
	SZ5->Z5_FIRMADO     := "A"
	SZ5->Z5_TIPO	    := cTipo
	SZ5->(MsUnlock())
	//grava SZ6
	dbselectarea("QRY")
	dbgotop()
	while !eof()
		dbselectarea("SZ6")
		RecLock("SZ6",.T.)
		for i:=1 to len(aCampos)
			do case
				case aCampos[i,1] = "Z6_DOC"
				SZ6->Z6_DOC = cDoc
				case aCampos[i,1] = "Z6_HIST"
				SZ6->Z6_HIST = ""
				otherwise
				SZ6->&(aCampos[i,1]) := QRY->&(aCampos[i,1])
			endcase
		next
		SZ6->(MsUnlock())
		dbselectarea("QRY")
		dbskip()
	enddo
	SZ6->(DbCloseArea())
	QRY->(DbCloseArea())
	msginfo("Replicação do documento gerada com sucesso.")

return

//gerar nova revisão do budget
//-----------------------------------------------------------------------------------------------------------------------------------------
user function BUDREV()

	ENTREV()
	cRD := "R"

return

//entra com a revisao para marcar como usada ou criar nova revisao
//-----------------------------------------------------------------------------------------------------------------------------------------
static Function ENTREV()

	local oDlg, oGet, bOk, cTit
	local bCancel	:={|| RollBackSX8(),oDlg:End()}

	do case
		case procname(1) = "U_BUDATU"
		bOk	:={|| ALTFIR(),oDlg:End()}
		cTit := "Marcar revisão como atual"
		case procname(1) = "U_BUDREV"
		bOk	:={|| CLOREV(),oDlg:End()}
		cRD := "R"
		cTit := "Revisão de budget"
	endcase
	LMPVAR()
	Define MsDialog oDlg From 0,0 to 150,700 Title cTit				Pixel
	@ 15,10  Say 	"Cal. contabil" 		of oDlg 		 		Pixel
	@ 15,40	 MsGet 	cCalend 			   	of oDlg F3 "Z5CAL" 	Pixel Size 20,7
	@ 15,80	 Say 	"Exercicio" 			of oDlg 		   		Pixel
	@ 15,110 MsGet 	cExerc	   				of oDlg 		  		Pixel Size 20,7
	@ 15,150 Say 	"Revisão base" 			of oDlg 		  		Pixel
	@ 15,210 MsGet 	cRevisao   				of oDlg 		 		Pixel Size 20,7		Valid VLDREV()
	Activate MsDialog oDlg Centered on Init EnchoiceBar(oDlg,bOK,bCancel)

return

//-----------------------------------------------------------------------------------------------------------------------------------------
//monta inclusao do budget receitas
static function MNTREC()

	FHEADER()
	FACOLS()
	ULTREV()
	//monta o budget
	cQuery := "SELECT RTRIM(A1_NREDUZ) AS Z6_NREDUZ, CTG_PERIOD AS Z6_PERIODO,"
	cQuery += " A7_CLIENTE AS Z6_CLIENTE, A7_LOJA AS Z6_LOJA, A7_PRODUTO AS Z6_PRODUTO, B1_PRV1 AS Z6_PRECO, B1_DESC AS Z6_PRDESC,"
	cQuery += " 0 AS Z6_QUANT, 0 AS Z6_TOTAL, 0 AS Z6_QTDSEGU"
	cQuery += " FROM " + retsqlname("SA7") + " SA7"
	cQuery += " FULL OUTER JOIN " + retsqlname("CTG") + " CTG ON CTG_CALEND = '" + alltrim(cCalend) + "' AND CTG_EXERC = '" + alltrim(cExerc) + "'"
	cQuery += " AND CTG_STATUS = '1' AND CTG.D_E_L_E_T_ = ' '"
	cQuery += " INNER JOIN " + retsqlname("SB1") + " SB1 ON A7_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = ' ' AND B1_ATIVO = 'S' AND B1_MSBLQL = '2'"
	cQuery += " INNER JOIN " + retsqlname("SA1") + " SA1 ON A1_COD = A7_CLIENTE AND SA1.D_E_L_E_T_ = ' '"
	cQuery += " ORDER BY CTG_EXERC, CTG_PERIOD, A1_COD, A1_LOJA, B1_COD"
	cQuery := ChangeQuery(cQuery)
	TCQUERY cQuery Alias QRY New
	dbselectarea("QRY")
	dbgotop()

	nItem := 0
	aLinha := {}
	aLinha := array(Len(aHeader)+1)
	while !eof()
		nItem++
		cItem := StrZero(nItem, TamSX3("Z6_ITEM")[1])
		for j:=1 to len(aHeader)
			iif(aHeader[j,2] = "Z6_ITEM", aLinha[j] := cItem, aLinha[j] := QRY->&(aHeader[j,2]))
		next
		aLinha[len(aHeader)+1] := .F.
		AADD(aCols, aclone(aLinha))
		dbskip()
	enddo
	aCols[1, len(aHeader)+1] := .T.
	QRY->(DbCloseArea())
	aTitgrid := {"Incluir Budget - Receitas","Alterar, inserir ou excluir RECEITAS"}
	EXBGRD()

return

//-----------------------------------------------------------------------------------------------------------------------------------------
//monta inclusao do budget despesas
static function MNTDES()

	local ncount

	FHEADER()
	FACOLS()
	ULTREV()
	//monta o budget
	cQuery := "SELECT CTG_PERIOD AS Z6_PERIODO, I3_CUSTO AS Z6_CCUSTO, CT1_CONTA AS Z6_CONTAC, 0 AS Z6_TOTAL"
	cQuery += " FROM " + retsqlname("CTG") + " CTG"
	cQuery += " FULL OUTER JOIN " + retsqlname("SI3") + " SI3 ON SI3.D_E_L_E_T_ = ' '"
	cQuery += " FULL OUTER JOIN " + retsqlname("CT1") + " CT1 ON CT1.D_E_L_E_T_ = ' '"
	cQuery += " ORDER BY CTG_EXERC, CTG_PERIOD, I3_CUSTO, CT1_CONTA"
	cQuery := ChangeQuery(cQuery)
	TCQUERY cQuery Alias QRY New
	dbselectarea("QRY")
	dbgotop()
	POPACOLS()
	QRY->(DbCloseArea())
	aTitgrid := {"Incluir Budget - Despesas","Alterar, inserir ou excluir DESPESAS"}
	EXBGRD()

return

//-----------------------------------------------------------------------------------------------------------------------------------------
//exibe a grid para alterar dados do budget
static function EXBGRD()

	local oDlg, oClientes
	local oGet
	local bOk
	local bCancel 	:= {|| RollBackSX8(),oDlg:End()}
	local lTrava
	local cComboCli := space(TamSX3("A1_NREDUZ")[1])
	private aColsTemp2 := {}, aColsTemp1 := {}

	lTrava = .T.
	do case
		case procname(1) = "MNTREC"
		bOk := {|| cComboCli := "Todos", ATACOLS(cComboCli), aCols := aclone(aColsTemp1), GRVBUD(), oDlg:End()}
		case procname(1) = "MNTDES"
		bOk := {|| GRVBUD(), oDlg:End()}
		case cRD = "R" .AND. procname(1) = "GERREV"
		bOk := {|| cComboCli := "Todos", ATACOLS(cComboCli), aCols := aclone(aColsTemp1), GRVREV(), oDlg:End()}
		bCancel := {|| DELCLO(), oDlg:End()}   
		case cRD = "R" .AND. procname(1) = "U_ALTABR"
		bOk := {|| cComboCli := "Todos", ATACOLS(cComboCli), aCols := aclone(aColsTemp1), GRVREV(), oDlg:End()}
		bCancel := {|| RollBackSX8(), oDlg:End()}
		case cRD = "D" .AND. procname(1) = "GERREV" 
		bOk := {|| GRVREV(), oDlg:End()}
		bCancel := {|| DELCLO(), oDlg:End()}
		case cRD = "D" .AND. procname(1) = "U_ALTABR"
		bOk := {|| GRVREV(), oDlg:End()}
		bCancel := {|| RollBackSX8(), oDlg:End()}
		case procname(1) = "U_VISITE"
		bOk := {||oDlg:End()}
		lTrava = .F.
		aAlterar := {}
	endcase
	dbselectarea("SZ6")
	Define MsDialog oDlg From 0,0 to 550,1200 Title aTitgrid[1] Pixel
	@ 5,10 Say aTitgrid[2] of oDlg Pixel
	if cRD = "R"
		oClientes:= tComboBox():New(20,10,{|u|if(PCount()>0,cComboCli:=u,cComboCli)},aClientes,120,20,oDlg,,{|| ATACOLS(cComboCli), oGet:ForceRefresh()},,,,.T.,,,,,,,,,"cComboCli")
		aColsTemp1 := aclone(aCols)
		aColsTemp2 := {}
	endif
	oGet:=MsGetDados():New(40,1,250,600,3,"AlwaysTrue()","Alwaystrue()","+Z6_ITEM",lTrava,aAlterar,,,99999)
	Activate MsDialog oDlg Centered on Init EnchoiceBar(oDlg,bOK,bCancel)

return

//-----------------------------------------------------------------------------------------------------------------------------------------
//modifica dinamicamente o aCols por cliente
static function ATACOLS(cComboCli)

	local aLinha := array(len(aheader)+1), n := GdFieldPos("Z6_NREDUZ",aHeader)

	aColsTemp1 := aclone(aColsTemp2)
	for i:=1 to len(aCols)
		for j:=1 to len(aHeader)+1
			aLinha[j] := aCols[i,j]
		next
		aadd(aColsTemp1, aclone(aLinha))
	next
	aCols := {}
	aColsTemp2 := {}
	for i:=1 to len(aColsTemp1)
		for j:=1 to len(aHeader)+1
			aLinha[j] := aColsTemp1[i,j]
		next
		do case
			case aColsTemp1[i, n] = alltrim(cComboCli) .OR. cComboCli = "Todos"
			aadd(aCols, aclone(aLinha))
			case aColsTemp1[i, n] <> alltrim(cComboCli) .AND. cComboCli <> "Todos"
			aadd(aColsTemp2, aclone(aLinha))
		endcase
	next

return

//-----------------------------------------------------------------------------------------------------------------------------------------
//grava o novo budget
static function GRVBUD()

	local nCont, aTam := {}, lGrav := .F.

	nCont := 0
	cDoc := alltrim(cCalend) + alltrim(cExerc) + alltrim(cTipo) + alltrim(cRevisao)
	RecLock("SZ5",.T.)
	SZ5->Z5_FILIAL 		:= xFilial("SZ5")
	SZ5->Z5_DOC         := cDoc
	SZ5->Z5_CALEND		:= cCalend
	SZ5->Z5_EXERC		:= CExerc
	SZ5->Z5_REVISAO		:= cRevisao
	SZ5->Z5_REVBASE     := "000"
	SZ5->Z5_DATA 		:= dData
	SZ5->Z5_FIRMADO     := "A"
	SZ5->Z5_TIPO	    := cTipo
	SZ5->(MsUnlock())
	for i:=1 to Len(aCols)
		if !aCols[i,Len(aHeader)+1] .AND. aCols[i,gdfieldpos("Z6_TOTAL")] > 0 //elimina deletados e registros sem valor
			lGrav := .T.
			nCont ++
			aTam := tamsx3("Z6_ITEM")
			RecLock("SZ6",.T.)
			for j:=1 to len(aHeader)
				SZ6->&(aHeader[j,2]):=aCols[i,j]
			next j
			SZ6->Z6_FILIAL 		:= xFilial("SZ6")
			SZ6->Z6_DOC         := cDoc
			SZ6->Z6_ITEM        := StrZero(nCont,TamSX3("Z6_ITEM")[1])
			SZ6->Z6_HIST        := "Gerado por: " + cUser
			SZ6->(MsUnlock())
		endif
	next i

	ConfirmSX8()
	if lGrav
		ALTFIR()
		msginfo("O budget " + cCalend + " exercicio " + cExerc + " revisão " + cRevisao + " foi gerado com sucesso.")
	else
		alert("O budget não foi gerado.")
	endif
	LMPVAR()
return

//-----------------------------------------------------------------------------------------------------------------------------------------
//calcula a ultima revisao
static function ULTREV()

	local cQuery, ncount

	//calcula a revisao atual
	cQuery := "SELECT MAX(Z5_REVISAO) AS Z5_MAXREV FROM " + retsqlname("SZ5") + " SZ5"
	cQuery += " WHERE Z5_CALEND = '" + alltrim(cCalend) + "' AND Z5_EXERC = '" + alltrim(cExerc) + "'"
	cQuery += " AND Z5_TIPO = '" + alltrim(cTipo) + "' AND SZ5.D_E_L_E_T_ = ' '"
	cQuery += " AND SZ5.D_E_L_E_T_ = ' '"
	cQuery := ChangeQuery(cQuery)
	TCQUERY cQuery Alias QRY New
	dbselectarea("QRY")
	iif(empty(QRY->Z5_MAXREV), cRevisao := StrZero(0,TamSX3("Z5_REVISAO")[1]), cRevisao := StrZero(val(QRY->Z5_MAXREV)+1,TamSX3("Z5_REVISAO")[1]))
	QRY->(DbCloseArea())

return

//-----------------------------------------------------------------------------------------------------------------------------------------
//torna o budget selecionado em uso
static function ALTFIR()

	iif(procname(1) = "U_BUDATU", cFirmado := "S", cFirmado := "A")
	dbselectarea("SZ5")
	dbgotop()
	while !eof()
		if SZ5->Z5_CALEND = alltrim(cCalend) .AND. SZ5->Z5_EXERC = alltrim(cExerc) .AND. SZ5->Z5_TIPO = alltrim(cTipo)
			RecLock("SZ5",.F.)
			if SZ5->Z5_REVISAO = alltrim(cRevisao)
				SZ5->Z5_FIRMADO = cFirmado
			else
				if cFirmado = "S" .OR. (cFirmado = "A" .AND. SZ5->Z5_FIRMADO = "A")
					SZ5->Z5_FIRMADO = "N"
				endif
			endif
			SZ5->(MsUnlock())
		endif
		dbskip()
	enddo

return

//-----------------------------------------------------------------------------------------------------------------------------------------
//clona a revisao base
static function CLOREV()

	local cQuery, aCamposZ5, aCamposZ6
	Local aCpoSZ5 := FWSX3Util():GetAllFields("SZ5", .f.)
	Local aCpoSZ6 := FWSX3Util():GetAllFields("SZ6", .f.)


	cRevbase := cRevisao
	ULTREV()
	aCamposZ5 := {}
	aCamposZ6 := {}
	dbselectarea("SZ6")
	dbgotop()
	DbSelectArea("SX3")
	DbSetOrder(1)
	DBGotop()


	For nI := 1 to Len(aCpoSZ5)

		aAdd(aCamposZ5,{getSX3Cache(aCpoSZ5[nI], "X3_CAMPO")})

	Next nI

	For nX := 1 to Len(aCpoSZ6)

		aAdd(aCamposZ6,{getSX3Cache(aCpoSZ6[nX], "X3_CAMPO")})

	Next nX





	cDoc := alltrim(cCalend) + alltrim(cExerc) + alltrim(cTipo) + alltrim(cRevbase)
	GERQRY()
	cDoc := alltrim(cCalend) + alltrim(cExerc) + alltrim(cTipo) + alltrim(cRevisao)
	RecLock("SZ5",.T.)
	for i:=1 to len(aCamposZ5)
		do case
			case aCamposZ5[i,1] = "Z5_DOC"
			SZ5->Z5_DOC := cDoc
			case aCamposZ5[i,1] = "Z5_REVISAO"
			SZ5->Z5_REVISAO := cRevisao
			case aCamposZ5[i,1] = "Z5_REVBASE"
			SZ5->Z5_REVBASE := cRevbase
			case aCamposZ5[i,1] = "Z5_DATA"
			SZ5->Z5_DATA := dData
			otherwise
			SZ5->&(aCamposZ5[i,1]) := QRY->&(aCamposZ5[i,1])
		endcase
	next i
	SZ5->(MsUnlock())
	dbselectarea("QRY")
	while !eof()
		RecLock("SZ6",.T.)
		for i:=1 to len(aCamposZ6)
			do case
				case aCamposZ6[i,1] = "Z6_DOC"
				SZ6->Z6_DOC := cDoc
				otherwise
				SZ6->&(aCamposZ6[i,1]) := QRY->&(aCamposZ6[i,1])
			endcase
		next i
		SZ6->(MsUnlock())
		dbselectarea("QRY")
		dbskip()
	enddo
	QRY->(DbCloseArea())
	SZ6->(DbCloseArea())
	GERREV()

return

//-----------------------------------------------------------------------------------------------------------------------------------------
//gerar nova revisao
static function GERREV()

	local aLinha

	FHEADER()
	FACOLS()
	GERQRY()
	POPACOLS()
	QRY->(DbCloseArea())
	aTitgrid := {"Revisão de " + cComboTipo,"Alterar, excluir ou incluir valores na revisão"}
	EXBGRD()

return

//-----------------------------------------------------------------------------------------------------------------------------------------
//grava revisao
static function GRVREV()

	local aLinha, nItens := 0, cHist:= ""

	dbselectarea("SZ6")
	//grava dados alterados e exclui deletados
	for i:=1 to len(aRecno)
		dbgoto(aRecno[i])
		RecLock("SZ6",.F.)
		if aCols[i+1,len(aHeader)+1]
			dbdelete()
		else
			cHist := ""
			for j:=1 to len(aHeader)
				if SZ6->&(aHeader[j,2]) <> aCols[i+1,j]
					iif(aHeader[j,8] = "N", cHist += "->Alt: " + alltrim(aHeader[j,1]) + ":" + alltrim(cvaltochar(aCols[i+1,j])) + " ",)
					iif(aHeader[j,8] = "C", cHist += "->Alt: " + alltrim(aHeader[j,1]) + ":" + alltrim(aCols[i+1,j]) + " ",)
					SZ6->Z6_DOC := cDoc
					SZ6->Z6_HIST := cHist
					SZ6->&(aHeader[j,2]) := aCols[i+1,j]
				endif
			next
		endif
		SZ6->(MsUnlock())
	next i
	//grava campos adicionais
	if len(aCols) - len(aRecno) > 1
		nItens := len(aRecno)
		for i:=len(aRecno)+2 to len(aCols)
			if !aCols[i,len(aHeader)+1]
				nItens ++
				RecLock("SZ6",.T.)
				for j:=1 to len(aHeader)
					SZ6->&(aHeader[j,2]) := aCols[i,j]
				next
				SZ6->Z6_FILIAL 		:= xFilial("SZ6")
				SZ6->Z6_DOC			:= cDoc
				SZ6->Z6_HIST        := "Registro adicionado na revisão"
				SZ6->Z6_ITEM        := StrZero(nItens,TamSX3("Z6_ITEM")[1])
				SZ6->(MsUnlock())
			endif
		next
	endif
	SZ6->(DbCloseArea())
	msginfo("A revisão foi gravada com sucesso")
	ALTFIR()

return

//-----------------------------------------------------------------------------------------------------------------------------------------
//limpa variaveis para msget
static function LMPVAR()

	cCalend 	:= space(TamSX3("Z5_CALEND")	[1])
	cExerc 		:= space(TamSX3("Z5_EXERC")		[1])
	cRevisao 	:= space(TamSX3("Z5_REVISAO")	[1])
	cTipo	 	:= space(TamSX3("Z5_TIPO") 		[1])

return

//-----------------------------------------------------------------------------------------------------------------------------------------
//valida se exste a revisao digitada
static function VLDREV()

	local lRet := .T.

	lRet := existcpo("SZ5",alltrim(cCalend) + alltrim(cExerc) + alltrim(cTipo) + alltrim(cRevisao),1)
	iif (!lRet, msgalert("Revisão não existe."),)
return (lRet)

//-----------------------------------------------------------------------------------------------------------------------------------------
//monta aHeader
Static Function FHEADER()

	local cCabec
	local aCabec
	Local aCpoSx3 := FWSX3Util():GetAllFields("SZ6", .f.)

	aHeader := {}
	cCabec 	:= ""

	do case
		case cRD = "R" .AND. procname(1) <> "U_VISITE"
		aCabec  := {"Z6_FILIAL", "Z6_DOC", "Z6_CCUSTO", "Z6_CONTAC", "Z6_HIST"}
		case cRD = "D" .AND. procname(1) <> "U_VISITE"
		aCabec  := {"Z6_FILIAL", "Z6_DOC", "Z6_PRODUTO", "Z6_PRDESC", "Z6_QUANT", "Z6_PRECO", "Z6_CLIENTE", "Z6_LOJA", "Z6_NREDUZ", "Z6_HIST"}
		case cRD = "R" .AND. procname(1) = "U_VISITE"
		aCabec  := {"Z6_FILIAL", "Z6_DOC", "Z6_CCUSTO", "Z6_CONTAC"}
		case cRD = "D" .AND. procname(1) = "U_VISITE"
		aCabec  := {"Z6_FILIAL", "Z6_DOC", "Z6_PRODUTO", "Z6_PRDESC", "Z6_QUANT", "Z6_PRECO", "Z6_CLIENTE", "Z6_LOJA", "Z6_NREDUZ"}
	endcase
	do case
		case cRD = "R"
		aAlterar := {"Z6_PERIODO", "Z6_CLIENTE", "Z6_LOJA", "Z6_PRODUTO", "Z6_PRECO", "Z6_QUANT", "Z6_QTDSEGU"}
		case cRD = "D"
		aAlterar := {"Z6_PERIODO", "Z6_CCUSTO", "Z6_CONTAC", "Z6_TOTAL"}
	endcase
	for i:=1 to len(aCabec)
		cCabec += "X3_CAMPO <> '" + aCabec[i] + iif(i = len(aCabec), "'", "' .AND. ")
	next
	
	For nX := 1 to Len(aCpoSx3)
		if &cCabec		
			nUsado++
			aAdd(aHead, {AllTrim(getSX3Cache(aCpoSx3[nX], "X3_TITULO")),;
			getSX3Cache(aCpoSx3[nX], "X3_CAMPO"),;
			getSX3Cache(aCpoSx3[nX], "X3_PICTURE"),;
			getSX3Cache(aCpoSx3[nX], "X3_TAMANHO"),;
			getSX3Cache(aCpoSx3[nX], "X3_DECIMAL"),;
			getSX3Cache(aCpoSx3[nX], "X3_VLDUSER"),;
			getSX3Cache(aCpoSx3[nX], "X3_USADO")  ,;
			getSX3Cache(aCpoSx3[nX], "X3_TIPO")	  ,;
			getSX3Cache(aCpoSx3[nX], "X3_F3") 	  ,;
			getSX3Cache(aCpoSx3[nX], "X3_CONTEXT")})
		EndIf
	Next nX

return

//-----------------------------------------------------------------------------------------------------------------------------------------
//monta acols
static function FACOLS()

	aCols := {}
	aRecno := {}
	AADD(aCols,Array(Len(aHeader)+1))
	For i:=1 to Len(aHeader)
		aCols[1,i]:=CriaVar(aHeader[i,2],.T.)
	Next i
	aCols[1,Len(aHeader)+1]:=.F.

return

//-----------------------------------------------------------------------------------------------------------------------------------------
//popular aCols
static function POPACOLS()

	local aLinha
	local nItem, cItem

	nItem := 0
	aRecno := {}
	aLinha := {}
	aLinha := array(Len(aHeader)+1)
	while !eof()
		nItem++
		cItem := StrZero(nItem, TamSX3("Z6_ITEM")[1])
		for j:=1 to len(aHeader)
			iif(aHeader[j,2] = "Z6_ITEM", aLinha[j] := cItem, aLinha[j] := QRY->&(aHeader[j,2]))
		next
		aLinha[len(aHeader)+1] := .F.
		if procname(1) <> "MNTREC" .AND. procname(1) <> "MNTDES"
			AADD(aRecno, QRY->R_E_C_N_O_)
		endif
		AADD(aCols, aclone(aLinha))
		dbskip()
	enddo
	aCols[1, len(aHeader)+1] := .T.

return

//-----------------------------------------------------------------------------------------------------------------------------------------
//query para popular acols
static Function GERQRY()

	cQuery := "SELECT * FROM " + RetSqlName("SZ6") + " SZ6 "
	cQuery += " INNER JOIN " + RetSqlName("SZ5") + " SZ5 ON Z5_DOC = Z6_DOC"
	cQuery += " WHERE Z5_FILIAL = '" + xFilial("SZ5") + "' AND Z5_DOC = '" + alltrim(cDoc) + "' AND SZ5.D_E_L_E_T_ = ' ' AND SZ6.D_E_L_E_T_ = ' '"
	cQuery += " ORDER BY Z6_PERIODO, Z6_CLIENTE, Z6_PRODUTO, Z6_ITEM"
	cQuery := ChangeQuery(cQuery)
	TCQUERY cQuery Alias QRY New
	dbselectarea("QRY")
	dbgotop()

return

//-----------------------------------------------------------------------------------------------------------------------------------------
//query para trazer os clientes
static Function CLIQRY()

	local nReg := 0

	cQuery := "SELECT A1_NREDUZ FROM " + RetSqlName("SA1") + " SA1 WHERE D_E_L_E_T_ = ' ' AND A1_MSBLQL = '2'"
	cQuery := ChangeQuery(cQuery)
	TCQUERY cQuery Alias QRY New
	dbselectarea("QRY")
	count to nReg
	aClientes := array(nReg+1)
	aClientes[1] := "Todos"
	dbgotop()
	for i:=1 to nReg
		aClientes[i+1] := QRY->A1_NREDUZ
		dbskip()
	next
	QRY->(DbCloseArea())

return

//-----------------------------------------------------------------------------------------------------------------------------------------
//deleta clone gerado na revisão cancelada
static Function DELCLO()

	local aArea := getarea()
	dbselectarea("SZ5")
	dbseek(xFilial("SZ5") + alltrim(cDoc))
	RecLock("SZ5",.F.)
	dbdelete()
	SZ5->(MsUnlock())
	dbselectarea("SZ6")
	dbgotop()
	while !eof()
		if SZ6->Z6_DOC = cDoc
			RecLock("SZ6",.F.)
			dbdelete()
			SZ6->(MsUnlock())
		endif
		dbskip()
	enddo
	restarea(aArea)

return
