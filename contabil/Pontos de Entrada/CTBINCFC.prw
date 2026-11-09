#INCLUDE "rwmake.ch"
#INCLUDE "Totvs.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTBINCFC º Autor ³ J.DONIZETE R.SILVA º Data ³  14/02/08    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Programa para carga de clientes e fornecedores no plano de º±±
±±º          ³ contas.                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Chamado pelos pontos de entrada M020INC/M030INC/Outros.    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºData      ³ Alterações                                                 º±±
±±º          ³                                                             ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CTBINCFC(_cCad)

// Parâmetros
//	_cCad
//		1 = Clientes
//		2 = Fornecedores

// Declaração das Variáveis.
Local _xAreaCF 	:= Iif(_cCad=="1",SA1->(GetArea()),SA2->(GetArea()))
Local _xAreaCT1		:= {}
Local _xAreaSM0		:= {}
Local _xAreaSX2 	:= {}

Local _cNome		:= Iif(_cCad=="1",SA1->A1_NOME,SA2->A2_NOME)
Local _cCod			:= Iif(_cCad=="1",SA1->A1_COD+SA1->A1_LOJA,SA2->A2_COD+SA2->A2_LOJA)
Local _cEst			:= Iif(_cCad=="1",SA1->A1_EST,SA2->A2_EST)
Local _cConta		:= ""
Local _cCtaSint		:= ""
Local _cAlias		:= Iif(_cCad=="1","SA1","SA2")
Local  cCompEmp     := FWModeAccess(_cAlias)
Local _cNtSped      := Iif(_cCad=="1","01","02") // Incluido por Alexandre em 01/04/2010


Local _aCad		  	:= {}
Local _lCria		:= .f. // Esta variável define se será criado ou não conta analítica. A alteração da mesma
Local lMsErroAuto   := .F.
Local lMsHelpAuto   := .T.




Local _cModoSA1SA2 	:= ""
Local _cModoCT1 	:= ""
Local _cUf		    := Iif(_cCad=="1",SA1->A1_EST,SA2->A2_EST)
Local _cTipo		:= SubStr(Iif(_cCad=="1",SA1->A1_COD,SA2->A2_COD),1,1)	
Local _cFilial		:= ""
Local _cEmpAnt		:= "" //cEmpAnt // Guardar a empresa atual
Local _cFilAnt		:= cFilAnt // Guardar a filial atual
Local _lCriaEmp		:= .f.
Local _lSA1SA2C		:= .f.
Local _lProc		:= .t.
Local lVersao   	:= VAL(GetVersao(.F.)) > 11
	
// Não processa se não houver parâmetros.
If !_cCad $ "1,2"
	Return(.f.)
EndIf

// Processa somente se o módulo for SIGACTB e a opção for de Inclusão.
If Upper(Alltrim(GetMv("MV_MCONTAB"))) == "CTB"
	
	// Verifica o compartilhamento de arquivos.
	dbSelectArea("SX2")
	_xAreaSX2 := GetArea()
	dbSetOrder(1)
	If dbSeek(_cAlias)
		_cModoSA1SA2 := cCompEmp
	Else
		MsgStop("Alias "+_cAlias+" não encontrado no SX2.","CTBIMPFC")
		RestArea(_xAreaSX2)
		DbSelectArea(_cAlias)
		RestArea(_xAreaCF)
		Return(.f.)
	EndIf
	If dbSeek("CT1")
		_cModoCT1 := cCompEmp
	Else
		MsgStop("Alias CT1 não encontrado no SX2.","CTBIMPFC")
		RestArea(_xAreaSX2)
		DbSelectArea(_cAlias)
		RestArea(_xAreaCF)
		Return(.f.)
	EndIf
	
	If _cModoSA1SA2=="E" .And. _cModoCT1=="C"
		MsgStop("Conflito de compartilhamento: "+_cAlias+"=Exclusivo e CT1=Compartilhado.","CTBIMPFC")
		DbSelectArea(_cAlias)
		RestArea(_xAreaCF)
		Return(.f.)
	Endif
	
	//Restaura SX2.
	RestArea(_xAreaSX2)
	
	dbSelectArea(_cAlias)
	//_xAreaCF := GetArea()
	
	If (_cModoSA1SA2=="E" .And. _cModoCT1=="E") .Or. (_cModoSA1SA2=="C" .And. _cModoCT1=="C")
		_cFilial := Iif(_cCad=="1",SA1->A1_FILIAL,SA2->A2_FILIAL)
		cFilAnt	:= _cFilial
	ElseIf _cModoSA1SA2=="C" .And. _cModoCT1=="E"
		_lSA1SA2C := .t.
	EndIf
	
	// Este escopo deve ser atualizado com as regras definidas pelo Contador.
	If _cCad == "1"
		Do case
			Case !_cUf $ "EX" .AND. _cTipo $ "0123456789" // Clientes Nacionais.
				_cCtaSint	:= "11050201"
				_lCria := .t.
			Case _cUf $ "EX" .AND. _cTipo $ "0123456789" // Clientes Estrangeiros.
				_cCtaSint	:= "11050202"
				_lCria := .t.
		EndCase
		
	Else
		Do case
			Case !_cUf $ "EX" .AND. _cTipo $ "0123456789" // Fornecedores Nacionais
				_cCtaSint := "21010101"
				_lCria := .t.
			Case _cUf $ "EX" .AND. _cTipo $ "0123456789" // Fornecedores Estrangeiros
				_cCtaSint := "21010102"
				_lCria := .t.
		EndCase
	EndIf
	
	If _lCria
		
		_cConta := _cCtaSint + _cCod
		
		
		dbSelectArea("SM0")
		_xAreaSM0 := GetArea()
		dbSetOrder(1)
		
		While !Eof() .And. _lProc
		/*
			If _lProc
				If (SM0->M0_CODIGO <> cEmpAnt)
					dbSkip()
					Loop
				EndIf
			EndIf
		*/
			If _lSA1SA2C
				cFilAnt	 := SM0->M0_CODFIL
				_cFilial := cFilAnt
			Else
				_lProc := .f.
			EndIf
		
			dbSelectArea("CT1")
			_xAreaCT1 := GetArea()
			dbSetOrder(1)
			DbSeek(_cFilial + _cConta)
			// Se encontrar, atualiza a descrição do plano de contas.
			If Found()
				If CT1->CT1_DESC01 <> _cNome
					If RecLock("CT1",.f.) // Atualiza a razão social
						CT1->CT1_DESC01 := _cNome
						msunlock()
					EndIf
				EndIf
				// Caso não encontre a conta no plano de contas, criar a mesma.
			Else

				If !lVersao
					// Alimenta matriz com os dados do registro a ser criado.
					aAdd( _aCad , { "CT1_FILIAL"  , _cFilial       , Nil } )
					aAdd( _aCad , { "CT1_CONTA "  , _cConta        , Nil } )
					aAdd( _aCad , { "CT1_DESC01"  , _cNome         , Nil } )
					aAdd( _aCad , { "CT1_CLASSE"  , "2"            , Nil } )
					aAdd( _aCad , { "CT1_NORMAL"  , _cCad          , Nil } )
					//aAdd( _aCad , { "CT1_RES"     , _cCod          , Nil } )
					aAdd( _aCad , { "CT1_ACITEM"  , "2"            , Nil } )
					aAdd( _aCad , { "CT1_ACCUST"  , "2"            , Nil } )
					aAdd( _aCad , { "CT1_ACCLVL"  , "2"            , Nil } )
					aAdd( _aCad , { "CT1_CCOBRG"  , "2"            , Nil } )
					aAdd( _aCad , { "CT1_ITOBRG"  , "2"            , Nil } )
					aAdd( _aCad , { "CT1_CLOBRG"  , "2"            , Nil } )
					aAdd( _aCad , { "CT1_CTAVM "  , ""             , Nil } )
					aAdd( _aCad , { "CT1_RGNV1 "  , "N"             , Nil } )
					aAdd( _aCad , { "CT1_NTSPED " , If(_cCad == '1','01','02')             , Nil } )
					aAdd( _aCad , { "CT1_NATCTA " , If(_cCad == '1','01','02')             , Nil } )
					aAdd( _aCad , { "CT1_BOOK  "  , "001/002/003/004/005"           , Nil } )
					aAdd(_aCad ,  {'CT1_PVARC'   ,"2", Nil} )

					// Inclui a conta contábil através de rotina automática.
					MSExecAuto({|x,y| CTBA020(x,y)},_aCad,3)
					If lMsErroAuto
						MostraErro()
						Alert("Não foi possível incluir registro.")
					Endif
				Else
					CtaCtbMVc(_cFilial,_cConta,_cNome,_cCad)
				EndIf
			Endif

			criaContaRef(_cFilial, _cConta, _cAlias)	
			
			dbSelectArea("SM0")
			dbSkip()
			
		EndDo
		
		// Restaura dados da empresa anterior.
		//cEmpAnt := _cEmpAnt
		cFilAnt	:= _cFilAnt
		
		// Restaura áreas de trabalho.
		RestArea(_xAreaSM0)
		RestArea(_xAreaCT1)
		
	EndIf
	
	// Restaura áreas de trabalho.
	RestArea(_xAreaCF)
	
	// Atualiza a conta no cadastro do Cliente.
	If _cCad=="1"
		If Empty(SA1->A1_CONTA)
			If Reclock(_cAlias, .F.)
				REPLACE SA1->A1_CONTA	with _cConta
				MsUnlock()
			EndIf
		Endif
	Else
		If Empty(SA2->A2_CONTA)
			If Reclock(_cAlias, .F.)
				REPLACE SA2->A2_CONTA	with _cConta
				MsUnlock()
			EndIf
		EndIf
	Endif
Endif

Return(.t.)

/**
 * funcao	:	criaContaRef
 * autor	:	Victor Hugo
 * data		:	08/11/11
 * descricao:	Criacao de Conta Referencial
 */
static function criaContaRef(cCodFil, cConta, cAlias)
	
	local aArea		:= GetArea()
		
	local oFun	  	:= FunGen():new()
	
	local nRegsCVD	:= 0
		
	local cQueryCVD	:= ""	
	local cAliasCVD	:= ""
	local cQueryCVN	:= ""		
	local cAliasCVN	:= ""		
	local cEntRef 	:= getMV("ZZ_ENTREF") 
	local cCodPla 	:= getMV("ZZ_CODPLA")             
	local cCtaRef 	:= if((cAlias == "SA1"), if(SA1->A1_TIPO == "X",getMV("ZZ_CTREFCI"), getMV("ZZ_CTREFCN")), if(SA2->A2_TIPO == "X",getMV("ZZ_CTREFFI"), getMV("ZZ_CTREFFN")))
		
	cCodFil := if(Empty(xFilial("CVD")), xFilial("CVD"), cCodFil) 
		
	cQueryCVD := " SELECT CVD_CONTA "
	cQueryCVD += " FROM "+retSqlName("CVD")+" CVD " 
	cQueryCVD += " WHERE CVD_FILIAL = '"+cCodFil+"' AND RTrim(CVD_CONTA) = '"+allTrim(cConta)+"' AND "
	cQueryCVD += " RTrim(CVD_ENTREF) = '"+allTrim(cEntRef)+"' AND RTrim(CVD_CODPLA) = '"+allTrim(cCodPla)+"' AND CVD.D_E_L_E_T_ = ' ' " 

	cAliasCVD := oFun:procQuery(cQueryCVD) 
	
	dbSelectArea(cAliasCVD)
	
	Count to nRegsCVD
	
	cQueryCVN := " SELECT IsNull(CVN_TPUTIL, '') TPUTIL "
	cQueryCVN += " FROM "+RetSqlName("CVN")+" CVN "
	cQueryCVN += " WHERE "
	cQueryCVN += " CVN.CVN_FILIAL = '"+xFilial("CVN")+"' " 
	cQueryCVN += " AND  CVN.D_E_L_E_T_ = ' ' "
	
	cQueryCVN += " AND  Rtrim(CVN.CVN_CTAREF) = '"+AllTrim(cCtaRef)+"' "
 	
	cAliasCVN := oFun:procQuery(cQueryCVN)		
		
	if (nRegsCVD == 0)
		
		CVD->(recLock("CVD", .T.))
			CVD->CVD_FILIAL := cCodFil
			CVD->CVD_CONTA	:= cConta
			CVD->CVD_ENTREF	:= cEntRef
			CVD->CVD_CODPLA	:= cCodPla
			CVD->CVD_CTAREF	:= cCtaRef 
			CVD->CVD_VERSAO := "0001" //ADD CAMPO COM VERSAO DA CONTA
			CVD->CVD_TPUTIL	:= (cAliasCVN)->TPUTIL
		
		CVD->(msUnlock())
			
	endIf
	
	(cAliasCVD)->(dbCloseArea())
	(cAliasCVN)->(dbCloseArea())
						        
	RestArea(aArea)						
						
return

Static Function CtaCtbMVc(_cFilial,_cConta,_cNome,_cCad)
	Local nOpcAuto :=0
	Local nX
	Local oCT1
	Local aLog
	Local cLog    :=""
	Local lRet    := .T.
	Local oView   := fwViewActive()
	Static __oModelAut := NIL //variavel oModel para substituir msexecauto em MVC
    //	local oSa2Mast:= oView:getModel():getModel("SA2MASTER")

	If __oModelAut == Nil //somente uma unica vez carrega o modelo CTBA020-Plano de Contas CT1
		__oModelAut := FWLoadModel('CTBA020')
	EndIf

	nOpcAuto:=3

	__oModelAut:SetOperation(nOpcAuto) // 3 - Inclusão | 4 - Alteração | 5 - Exclusão
	__oModelAut:Activate() //ativa modelo

	oCT1 := __oModelAut:GetModel('CT1MASTER')  
	oCT1:SETVALUE('CT1_FILIAL'	,_cFilial)
	oCT1:SETVALUE('CT1_CONTA'	,alltrim(_cConta))
	oCT1:SETVALUE('CT1_DESC01'  ,alltrim(_cNome))
	oCT1:SETVALUE('CT1_CLASSE'  ,'2')
	oCT1:SETVALUE('CT1_NORMAL'  ,_cCad)
	//oCT1:SETVALUE('CT1_RES'  ,_cCod)
	oCT1:SETVALUE('CT1_ACITEM'  ,"2")
	oCT1:SETVALUE('CT1_ACCUST'  ,"2")
	oCT1:SETVALUE('CT1_ACCLVL'  ,"2")
	oCT1:SETVALUE('CT1_CCOBRG'  ,"2")   
	oCT1:SETVALUE('CT1_CLOBRG'  ,"2")
	oCT1:SETVALUE('CT1_CTAVM' 	,"")
	oCT1:SETVALUE('CT1_RGNV1'   ,"N")
	oCT1:SETVALUE('CT1_NTSPED'  ,If(_cCad == '1','01','02'))
	oCT1:SETVALUE('CT1_NATCTA'  ,If(_cCad == '1','01','02'))
	oCT1:SETVALUE('CT1_BOOK' 	, "001/002/003/004/005" )
	oCT1:SETVALUE('CT1_PVARC'   ,"2") //ADD CAMPO PARA VIR PREENCHIDO = 2-NAO


	If __oModelAut:VldData() //validacao dos dados pelo modelo

		__oModelAut:CommitData() //gravacao dos dados

	Else
		aLog := __oModelAut:GetErrorMessage() //Recupera o erro do model quando nao passou no VldData

		//laco para gravar em string cLog conteudo do array aLog
		For nX := 1 to Len(aLog)
			If !Empty(aLog[nX])
				cLog += Alltrim(aLog[nX]) //+CRLF
			EndIf
		Next nX

		lMsErroAuto := .T. //seta variavel private como erro
		AutoGRLog(cLog) //grava log para exibir com funcao mostraerro
		mostraerro()
		lRet := .F. //retorna false
	EndIf

	//oSa2Mast:loadValue("A2_CONTA", Lower(_cConta))
	//oView:refresh()

	__oModelAut:DeActivate() //desativa modelo	

Return
