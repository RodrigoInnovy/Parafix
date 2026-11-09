#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "MsObject.ch"
#Include "TbiConn.ch"   
#include "FileIO.ch"

/**
* Classe		:	FunGen (Baseada Classe CosanFun)
* Autor		:	Victor Hugo - Totvs Campinas
* Data			:	16/06/10
* Descricao	:	Classe com Funcionalidades Genericas da Cosan
*/                    
User Function FFunGen; Return
Class FunGen                                                	

Method New()				// Construtor
Method ProcQuery()			// Processamento de Querys          
Method ExistCpoBd()			// Verifica se determinado campo existe em dada Tabela no Banco de Dados
Method SaveAreas()			// Salva varias Areas
Method RestAreas()			// Restaura varias Areas
Method CriaArraysGd()		// Criacao dos Arrays para Objetos GetDados
Method StrType()			// Converte qualquer tipo de dado para String
Method SetEmpFil()			// Seleciona Empresas e Filiais
Method GetEmpresas()		// Coleta Empresas
Method GetNomeDtb()			// Coleta os Nomes dos Distribuidores
Method PreparaAmbiente()    // Prepara o Ambiente Protheus
Method RemoveAcentos()		// Remove acentos de Strings  
Method GetNomeSx2()			// Retorna o Nome das Tabelas no SX2
Method GetPosicoesObj() 	// Cria Arrays de Coordenadas de Objetos do Protheus
Method UsuarioAdm()			// Verifica se determinado Usuario e Administrador
Method ShowHelp()			// Exibe Dialogo de Help  
Method ChkFormula()			// Validacao de Formulas Advpl
Method WriteTextFile()		// Gravacao de Arquivos Texto         
Method ReadCsvFile()		// Leitura de Arquivos CSV 4
Method GetComboParambox()   // Coleta os Valores dos campo tipo ComboBox da funcao Parambox
Method ExistTabBD()			// Verifica se as Tabelas passadas como parametro existem no Banco de Dados

End Class

/**
* Metodo		:	New
* Autor		:	Victor Hugo - Totvs Campinas
* Data			:	16/06/10
* Descricao	:	Construtor
*/
Method New() Class FunGen

Return

/**
* Metodo		:	ProcQuery
* Autor		:	Victor Hugo - Totvs Campinas
* Data			:	16/06/10
* Descricao	:	Processamento de Instrucoes SQL
*
* Parametros	:	cQuery 	- 	String contendo a Instrucao SQL
*					nTipo 	- 	Tipo de Instrucao 
*									1 = Processa uma Consulta e retorna o Alias de Trabalho
*									2 = Processa uma Instrucao SQL e retorna o Resultado do Processamento (Logico)
*					cTabAtu	- 	Tabela a ser Atualizada no TOP ( Opcional )
*					lAviso	-	Indica se deve exibir Avisos em caso de erro no Processamento das Instrucoes ( Opcional )
*					cAlias 	- 	Alias a ser Atribuido em Consultas ( Opcional )
*
* Retorno		:	xRet 	- 	String com o alias para Consultas ( nTipo == 1 )
*						   		Logico indicando o sucesso do Processamento ( nTipo == 2 )
*/
Method ProcQuery(cQuery, nTipo, cTabAtu, lAviso, cAlias) Class FunGen

	Local 	xRet	:= Nil	
	Default nTipo	:= 1	
	Default cTabAtu	:= ""            
	Default lAviso	:= .T.
	Default cAlias 	:= GetNextAlias()

	// Consultas	
	If nTipo == 1

		If !Empty(Select(cAlias))
			(cAlias)->(dbCloseArea())		
		EndIf                       		
		TCQUERY cQuery NEW ALIAS &cAlias				

		xRet := cAlias			

		// Manutencao		
	Else

		cQuery += CRLF+" COMMIT "		          
		xRet   := (TcSqlExec(cQuery) == 0)

		If xRet          
			If !Empty(cTabAtu)
				TcRefresh(RetSqlName(cTabAtu))		
			EndIf	
		Else              
			If lAviso
				Aviso(FunName(), TcSqlError(), {"Ok"}, 3, "Erro ao processar Instrução SQL") 		
			EndIf	
		EndIf			

	EndIf

Return xRet

/**
* Metodo		:	ExistCpoBd
* Autor		:	Victor Hugo - Totvs Campinas
* Data			:	16/06/10
* Descricao	:	Verifica se determinado campo existe em dada Tabela no Banco de Dados
*
* Parametros	:	cCampo 	- 	Campo a ser analisado
*					cAlias 	- 	Alias da Tabela
*
* Retorno		:	lExist 	- 	Logico indicando a existencia do Campo
*/
Method ExistCpoBd(cCampo, cAlias) Class FunGen

	Local cQuery := ""	
	Local lExist := .F.	
	Local lDb2   := ("DB2" $ Upper(TcGetDb()))

	cQuery += " SELECT "
	If !lDb2
		cQuery += " TOP 1 "	
	EndIf                
	cQuery += cCampo+" FROM "+RetSqlName(cAlias)
	If lDb2
		cQuery += " FETCH FIRST 1 ROW ONLY "	
	EndIf

	lExist := ::ProcQuery(cQuery, 2, , .F.)

Return lExist

/**
* Metodo		:	SaveAreas
* Autor		:	Victor Hugo - Totvs Campinas
* Data			:	16/06/10
* Descricao	:	Salva Areas de Trabalho
*
* Parametros	:	aAreas 	- 	Vetor contendo Strings dos Alias a serem Salvos
*
* Retorno		:	aRet 	- 	Vetor contendo Arrays com as Areas Salvas
*/
Method SaveAreas(aAreas) Class FunGen

	Local 	nI		:= 0
	Local 	aRet 	:= {}      
	Local 	cAlias	:= ""   
	Default aAreas	:= {}

	For nI := 1 To Len(aAreas)	
		cAlias := aAreas[nI]
		aAdd(aRet, (cAlias)->(GetArea()))	
	Next nI         

	aAdd(aRet, GetArea())

Return aRet                  

/**
* Metodo		:	RestAreas
* Autor		:	Victor Hugo - Totvs Campinas
* Data			:	16/06/10
* Descricao	:	Restaura Areas de Trabalho
*
* Parametros	:	aAreas - Vetor contendo Arrays com as Areas Salvas
*/
Method RestAreas(aAreas) Class FunGen

	Local 	nI 		:= 0        
	Default aAreas  := {}

	For nI := 1 To Len(aAreas)	
		RestArea(aAreas[nI])
	Next nI

Return             

/**
* Metodo		:	CriaArraysGd
* Autor		:	Victor Hugo - Totvs Campinas
* Data			:	16/06/10
* Descricao	:	Criacao dos Arrays para Objetos GetDados
*
* Parametros	:	aHeader - Array contendo Dados dos Campos ( passar por referencia )
*					aCols   - Array que ira armazenar os Itens ( passar por referencia )
*					cAlias  - Alias contendo os Campos a serem exibidos no GetDados ( por padrao assume o Alias em foco )
*					aNaoAlt	- Vetor contendo os campos que nao deverao ser alterados ( por padrao assume vazio )
*					aCampos	- Vetor contendo os campos a serem exibidos ( por padrao exibe todos os campos em uso do Alias informado )
*
* Observacoes	:	O metodo ira criar os Arrays aHeader e aCols baseado nas informacoes do Dicionario de Dados (SX3), 
*					portanto os campos do Alias devem estar iguais ao do Dicionario
*/
Method CriaArraysGd(aHeader, aCols, cAlias, aNaoAlt, aCampos) Class FunGen

	Local cCpo			:= ""	
	Local xValor		:= ""
	Local cAltera		:= ""
	Local nUsado 		:= 0  
	Local nI			:= 0	
	Local aEstrut		:= {}
	Local aCposGd		:= {}
	Local aAreaGd		:= {}
	Local aArea			:= GetArea()
	Local aAreaSX3  	:= SX3->(GetArea())
	Private cAliasGd	:= ""
	Default cAlias		:= Alias()
	Default aHeader		:= {}
	Default aCols		:= {}	
	Default aNaoAlt		:= {}	
	Default aCampos		:= {}

	// Define o Alias do GetDados	
	cAliasGd := cAlias  
	aAreaGd  := (cAliasGd)->(GetArea())

	// Define os campos a serem exibidos	
	aEstrut := (cAliasGd)->(dbStruct())
	For nI := 1 To Len(aEstrut)
		cCpo := aEstrut[nI,1]
		If Len(aCampos) == 0
			aAdd(aCposGd, cCpo)		
		Else
			If aScan(aCampos, cCpo) > 0
				aAdd(aCposGd, cCpo)					
			EndIf		
		EndIf			
	Next nI		

	// Carrega o aHeader - Cabecalho
	If Len(aHeader) == 0
		SX3->(dbSetOrder(2))    
		For nI := 1 To Len(aCposGd)

			cCpo := PadR(aCposGd[nI], Len(getSX3Cache(aCposGd[nI], "X3_CAMPO")))

			If SX3->(dbSeek(cCpo))				
				cAltera := If(aScan(aNaoAlt, AllTrim(cCpo)) == 0, ".T.", ".F.")		

				aAdd(aHead,{AllTrim(getSX3Cache(aCpoSx3[nX], "X3_TITULO")),;
									getSX3Cache(aCposGd[nI], "X3_CAMPO"),;
									getSX3Cache(aCposGd[nI], "X3_PICTURE"),;
									getSX3Cache(aCposGd[nI], "X3_TAMANHO"),;
									getSX3Cache(aCposGd[nI], "X3_DECIMAL"),;
									cAltera                               ,;
									getSX3Cache(aCposGd[nI], "X3_USADO")  ,;
									getSX3Cache(aCposGd[nI], "X3_TIPO")	  ,;
									getSX3Cache(aCposGd[nI], "X3_F3") 	  ,;
									getSX3Cache(aCposGd[nI], "X3_CONTEXT"),;
									getSX3Cache(aCposGd[nI], "X3_CBOX")   ,;
									getSX3Cache(aCposGd[nI], "X3_RELACAO")})

			EndIf						

			SX3->(dbSkip())

		Next nI
	EndIf

	// Carrega o aCols - Itens
	nUsado := Len(aHeader)

	(cAliasGd)->(dbGoTop())
	While !(cAliasGd)->(Eof())

		aAdd(aCols, Array(nUsado+1))
		For nI := 1 To nUsado                  
			xValor := "(cAliasGd)->"+aHeader[nI,2]	
			aCols[Len(aCols)][nI] := If(aHeader[nI,8] == "D", StoD(&(xValor)) , &(xValor))
		Next nI
		aCols[Len(aCols),nUsado+1] := .F.	

		(cAliasGd)->(dbSkip())
	EndDo

	RestArea(aAreaSx3)
	RestArea(aAreaGd)
	RestArea(aArea)

Return 

/**
* Metodo		:	StrType
* Autor		:	Victor Hugo - Totvs Campinas
* Data			:	16/06/10
* Descricao	:	Converte qualquer tipo de dado para String
*
* Parametros	:	xValor - Valor a ser convertido
*
* Retorno		:	cRet - Valro convertido para String
*/
Method StrType(xValor) Class FunGen

	If ValType(xValor) == "C"
		cRet := xValor
	ElseIf ValType(xValor) == "N"
		cRet := Str(xValor)
	ElseIf ValType(xValor) == "D"
		cRet := DtoS(xValor)
	ElseIf ValType(xValor) == "L"
		cRet := If(xValor, ".T.", ".F.")
	Else
		cRet := ""	
	EndIf	

Return AllTrim(cRet)

/**
* Metodo		:	SetEmpFil
* Autor		:	Victor Hugo
* Data			: 	05/01/10
* Descricao	:	Seleciona Empresas e Filiais
*
* Parametros	:	cCodEmp 	- Codigo da Empresa
*					cCodFil 	- Codigo da Filial
*					lRpcSetEnv 	- Indica se utiliza o comando RpcSetEnv ( por padrao assume .T. )
*
* Retorno		:	Logico - Indica se a troca foi realizada
*/
Method SetEmpFil(cCodEmp, cCodFil, lRpcSetEnv) Class FunGen

	Local	lTroca		:= .T.
	Local 	nI			:= 0
	Local 	nMaxArea	:= 0
	Default cCodEmp		:= cEmpAnt
	Default cCodFil 	:= cFilAnt
	Default lRpcSetEnv  := .T.   		

	// Realiza a troca somente se a Empresa e Filial forem diferentes das atuais								
	If (lTroca := cCodEmp+cCodFil != cEmpAnt+cFilAnt)

		cEmpAnt := cCodEmp
		cFilAnt	:= cCodFil	 

		// Limpa o Cache do SX6 utilizado pela funcao SuperGetMv		
		RstMvBuff()													

		If lRpcSetEnv					                    

			RpcClearEnv()
			RpcSetType(3)
			RpcSetEnv(cEmpAnt, cFilAnt)									

		Else

			dbCloseAll()			  
			fAbreArqSem()
			OpenSM0(cEmpAnt + cFilAnt)
			OpenFile(cEmpAnt + cFilAnt)			 

		EndIf	

	EndIf	

Return lTroca                

/**
* Funcao		:	fAbreArqSem
* Autor		:	Victor Hugo - Totvs Campinas
* Data			:	16/06/10
* Descricao	:	Abre os Arquivos de Semaforo
*/
Static Function fAbreArqSem()		

	Local cArqSxe := "sxe.dbf"  
	Local cArqSxf := "sxf.dbf"

	If File(cArqSxe) .AND. File(cArqSxf)		
		oTempTable := FWTemporaryTable():New("SXE")
		oTempTable := FWTemporaryTable():New("SXF")

	EndIf	

Return

/**
* Metodo		:	RemoveAcentos
* Autor		:	Victor Hugo
* Data			: 	05/01/10
* Descricao	:	Remove Acentos de Strings
*
* Parametros	:	cString - String a ser tratada
*
* Retorno		:	cString - String sem os Acentos
*
* Observacoes	:	Este metodo e uma copia da funcao NoAcento do fonte 'NfeSefaz'
*/
Method RemoveAcentos(cString) Class FunGen

	Local cChar  := ""
	Local nX     := 0
	Local nY     := 0
	Local cVogal := "aeiouAEIOU"
	Local cAgudo := "áéíóú"+"ÁÉÍÓÚ"
	Local cCircu := "âêîôû"+"ÂÊÎÔÛ"
	Local cTrema := "äëïöü"+"ÄËÏÖÜ"
	Local cCrase := "àèìòù"+"ÀÈÌÒÙ"
	Local cTio   := "ãõ"
	Local cCecid := "çÇ"

	For nX:= 1 To Len(cString)
		cChar:=SubStr(cString, nX, 1)
		IF cChar$cAgudo+cCircu+cTrema+cCecid+cTio+cCrase
			nY:= At(cChar,cAgudo)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
			EndIf
			nY:= At(cChar,cCircu)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
			EndIf
			nY:= At(cChar,cTrema)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
			EndIf
			nY:= At(cChar,cCrase)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
			EndIf
			nY:= At(cChar,cTio)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr("ao",nY,1))
			EndIf
			nY:= At(cChar,cCecid)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr("cC",nY,1))
			EndIf
		Endif
	Next
	For nX:=1 To Len(cString)
		cChar:=SubStr(cString, nX, 1)
		If Asc(cChar) < 32 .Or. Asc(cChar) > 123 .Or. cChar $ '&'
			cString:=StrTran(cString,cChar,".")
		Endif
	Next nX
	cString := _NoTags(cString)
Return cString  

/**
* Metodo		:	PreparaAmbiente
* Autor		:	Victor Hugo
* Data			: 	14/06/10
* Descricao	:	Prepara o Ambiente Protheus				
*/
Method PreparaAmbiente(cCodEmp, cCodFil) Class FunGen                            			                                    				

	PREPARE ENVIRONMENT EMPRESA cCodEmp FILIAL cCodFil	

Return                      

/**
* Metodo		:	GetEmpresas
* Autor		:	Victor Hugo
* Data			: 	14/06/10
* Descricao	:	Coleta Empresas
*                  
* Parametros	:	cTitulo  - Titulo do Dialogo ( opcional )
*					lShowFil - Indica se deve exibir as Filiais ( por padrao assume .F. )
*					aSelEmps - Define os Codigos de Empresa para selecao
*
* Retorno		:	aRet[x,1] - Empresa
*					aRet[x,2] - Filial 
*					aRet[x,3] - Nome da Empresa
*/
Method GetEmpresas(cTitulo, lShowFil, aSelEmps) Class FunGen

	Local oDlg     
	Local oList   	
	Local oOk  		:= LoadBitmap(GetResources(), "LBOK")
	Local oNo   	:= LoadBitmap(GetResources(), "LBNO")

	Local cEnvServ  := GetEnvServer() 
	Local cIniFile  := GetAdv97()    
	Local cStartPath:= GetPvProfString(cEnvServ, "StartPath", "", cIniFile)	  	  
	Local cSigaMat 	:= cStartPath+"sigamat.emp"		

	Local nI		:= 0        
	Local nScan		:= 0

	Local aEmps		:= {}
	Local aNewEmps	:= {}		
	Local aRet		:= {}          
	Local aAreaSM0	:= {}

	Local lOk 		:= .F.
	Local lFechaSm0	:= .F.                                   

	Default cTitulo := "Selecione as Empresas" 
	Default lShowFil:= .F.
	Default aSelEmps:= {}    

	// Leitura das Empresas do SigaMat
	If Select("SM0") == 0
		lFechaSm0 := .T.
		oTempTable := FWTemporaryTable():New("SM0")					                                  		
	Else
		aAreaSM0 := SM0->(GetArea())	
	EndIf	

	SM0->(dbGoTop())
	While !SM0->(Eof())
		If lShowFil
			If aScan(aEmps, {|x| x[2] == SM0->M0_CODIGO .AND. x[3] == SM0->M0_CODFIL }) == 0
				aAdd(aEmps, {.F.,SM0->M0_CODIGO,SM0->M0_CODFIL,AllTrim(SM0->M0_NOME)+" / "+AllTrim(SM0->M0_FILIAL)})
			EndIf					
		Else	
			If aScan(aEmps, {|x| x[2] == SM0->M0_CODIGO }) == 0
				aAdd(aEmps, {.F.,SM0->M0_CODIGO,SM0->M0_NOME,SM0->M0_CODFIL})
			EndIf			
		EndIf	
		SM0->(dbSkip())
	EndDo   

	If Len(aSelEmps) > 0
		For nI := 1 to Len(aSelEmps)
			nScan := aScan(aEmps, {|x| x[2] == aSelEmps[nI] })		
			If nScan > 0
				aAdd(aNewEmps, aEmps[nScan])			
			EndIf
		Next			
		aEmps := aClone(aNewEmps)
	EndIf            	

	If lFechaSm0
		SM0->(dbCloseArea())
	Else
		RestArea(aAreaSM0)	
	EndIf	

	// Criacao do Dialogo
	DEFINE MSDIALOG oDlg TITLE cTitulo FROM 32,113 TO 240,425 PIXEL OF oMainWnd

	If lShowFil		
		@ 5,5 LISTBOX oList FIELDS COLSIZES 20,35,50 HEADER "","Empresa","Filial","Nome" SIZE 148,70 OF oDlg PIXEL
	Else
		@ 5,5 LISTBOX oList FIELDS COLSIZES 20,35,50 HEADER "","Codigo","Empresa","" SIZE 148,70 OF oDlg PIXEL		
	EndIf	
	oList:SetArray(aEmps)
	oList:cToolTip		:= "Duplo Click para Habilitar/Desabilitar"
	oList:bLDblClick	:= { || fSelEmps(@oList, @aEmps) }
	If lShowFil 
		oList:bLine	:= { || { IIf(	aEmps[oList:nAt,1], oOk, oNo), aEmps[oList:nAt,2] , aEmps[oList:nAt,3], aEmps[oList:nAt,4] } }		
	Else
		oList:bLine	:= { || { IIf(	aEmps[oList:nAt,1], oOk, oNo), aEmps[oList:nAt,2] , aEmps[oList:nAt,3] } }
	EndIf	

	@ 85,6   BUTTON "Sel. Todas" 	SIZE 30,12 ACTION {|| fSelEmps(@oList, @aEmps, .T.) } 	PIXEL OF oDlg
	@ 85,79  BUTTON "Ok" 			SIZE 30,12 ACTION {|| lOk := .T., oDlg:End() } 			PIXEL OF oDlg
	@ 85,119 BUTTON "Cancelar" 		SIZE 30,12 ACTION {|| lOk := .F., oDlg:End() }			PIXEL OF oDlg 

	ACTIVATE MSDIALOG oDlg CENTERED

	// Define as Empresas para Instalacao
	If lOk	
		aRet := {}	
		For nI := 1 To Len(aEmps)
			If aEmps[nI,1]       
				If lShowFil
					aAdd(aRet, {aEmps[nI,2],aEmps[nI,3],aEmps[nI,4]})		
				Else
					aAdd(aRet, {aEmps[nI,2],aEmps[nI,4],aEmps[nI,3]})						
				EndIf	
			EndIf	
		Next nI					
		If Len(aRet) == 0	
			::ShowHelp(cTitulo, "Nenhuma Empresa Selecionada", "Selecione ao menos uma Empresa") 
		EndIf
	EndIf	

Return aRet

/**
* Metodo		:	GetNomeDtb
* Autor		:	Victor Hugo - Totvs Campinas
* Data			:	05/07/10
* Descricao	:	Coleta os Nomes dos Distribuidores
*/
Method GetNomeDtb(cCodEmp, cCodFil) Class FunGen

	Local cNome		:= ""	
	Local aAreaSm0	:= SM0->(GetArea())	

	If SM0->(dbSeek(cCodEmp+cCodFil))
		cNome := Capital(AllTrim(SM0->M0_NOME))+" / "+Capital(AllTrim(SM0->M0_FILIAL))	
	EndIf

	RestArea(aAreaSm0)

Return cNome   	   

/**
* Funcao		:	fSelEmps
* Autor		:	Victor Hugo
* Data			: 	14/06/10
* Descricao	:	Tratativa da Selecao de Empresas
*/
Static Function fSelEmps(oList, aEmps, lMarkAll)

	Local nI 		:= 0
	Local nMarks	:= 0
	Default lMarkAll:= .F.

	If !lMarkAll
		aEmps[oList:nAt,1] := !aEmps[oList:nAt,1]
	Else	
		For nI := 1 to Len(aEmps)
			If aEmps[nI,1]
				nMarks++			
			EndIf
		Next nI
		For nI := 1 to Len(aEmps)
			aEmps[nI,1] := (nMarks < Len(aEmps))
		Next nI
	EndIf	

	oList:Refresh()

Return 

/**
* Metodo		:	GetNomeSx2
* Autor		:	Victor Hugo - Totvs Campinas
* Data			:	23/08/10
* Descricao	:	Retorna o Nome das Tabelas a partir do SX2
*
* Parametros	:	cAlias	- Alias da Tabela
*					cCodEmp - Codigo da Empresa ( por padrao assume a Empresa Atual )
*					cModo	- Variavel a ser atribuido o Modo de Acesso ( C=Compartilhado, E=Exclusivo )
*
* Retorno		:	cNomeSx2 - 	Nome da Tabela
*/
Method GetNomeSx2(cAlias, cCodEmp, cModo) Class FunGen

	Local aArea			:= GetArea()			
	Local aAreaSx2		:= SX2->(GetArea())			

	Local cNomeSx2 		:= ""	     		
	Local cDriver		:= "DBFCDX"	
	Local cAliasSx2		:= GetNextAlias()      
	Local cEnvServ  	:= GetEnvServer() 
	Local cIniFile  	:= GetAdv97()    
	Local cStartPath	:= GetPvProfString(cEnvServ, "StartPath", "", cIniFile)	  	  
	Local cArqSx2 		:= ""
		

	Local lNovoAlias    := .T.
	Local lCompart		:= .T. 
	Private cQuerySX2     := getSX2() 
	    
	Default cCodEmp		:= cEmpAnt		
	Default cModo   	:= ""		

	cArqSx2 := cStartPath+"sx2"+cCodEmp+"0.dbf"

	If !File(cArqSx2)
		Alert("Arquivo "+cArqSx2+" não encontrado")
		Return "" 	
	EndIf

	dbUseArea(lNovoAlias, cDriver, cArqSx2, cAliasSx2, lCompart)

	cAlias := PadR(cAlias, Len((cQuerySX2)->CHAVE))

	dbSelectArea(cAliasSx2)				
	(cAliasSx2)->(dbSetOrder(1))
	If (cAliasSx2)->(dbSeek(cAlias))
		cNomeSx2	:= (cQuerySX2) -> ARQUIVO
		cModo		:= (cQuerySX2) -> MODO
	EndIf

	(cAliasSx2)->(dbCloseArea())

	RestArea(aAreaSx2)
	RestArea(aArea)

Return cNomeSx2   

Static function getSX2(cAlias)
	local cQuery := ""
	Local QRY_AUX := GetNextAlias()

	cQuery += "SELECT X2_ARQUIVO AS ARQUIVO,X2_CHAVE AS CHAVE ,X2_MODO AS MODO " + CRLF
	cQuery += "FROM SX2990 " + CRLF
	cQuery += "WHERE X2_CHAVE = '" + cAlias + "'" 

	TCQuery cQuery New Alias &QRY_AUX

return QRY_AUX



/**
* Metodo		:	GetPosicoesObj
* Autor		:	Victor Hugo
* Data			:	02/12/10
* Descricao	:	Cria Arrays de Coordenadas de Objetos do Protheus
*/
Method GetPosicoesObj(aSize, aPosObj) Class FunGen

	Local aObjects 	:= {}
	Local aInfo		:= {}
	Default aSize	:= {}
	Default aPosObj	:= {}

	aAdd(aObjects, {100,100,.T.,.T.})
	aAdd(aObjects, {100,100,.T.,.T.})
	aAdd(aObjects, {100,015,.T.,.F.})   

	aSize 	:= MsAdvSize()

	aInfo 	:= {aSize[1],aSize[2],aSize[3],aSize[4],3,3}

	aPosObj := MsObjSize(aInfo, aObjects)

Return                   

/**
* Metodo		:	UsuarioAdm
* Autor		:	Victor Hugo - Totvs Campinas
* Data			:	16/06/10
* Descricao	:	Verifica se determinado usuario e Administrador
*
* Parametros	:	cUserId - ID do Usuario ( por padrao assume o Usuario logado )
*
* Retorno		:	Logico
*/
Method UsuarioAdm(cUserId) Class FunGen

	Local aGrupos	:= 	{}
	Local lAdm 		:= 	.F.
	Default cUserId	:= 	__cUserId 

	If Val(cUserId) == 0
		lAdm := .T.	
	Else   
		PswOrder(1)	
		If PswSeek(cUserId, .T.)	
			aGrupos := PswRet(1) 
			If aScan(aGrupos[1,10], "000000") <> 0 
				lAdm := .T.
			EndIf
		EndIf	
	EndIf	

Return lAdm 

/**
* Metodo		:	ShowHelp
* Autor		:	Victor Hugo
* Data			:	20/05/2011
* Descricao	:	Exibe Dialogo de Help      
*
* Parametros	:	cTitulo 	- Titulo do Dialogo
*					cProblema   - Descricao do Problema
*					cSolucao	- Descricao da Solucao
*/
Method ShowHelp(cTitulo, cProblema, cSolucao) Class FunGen

	Local aProblema		:= {}
	Local aSolucao		:= {}

	Default cTitulo 	:= FunDesc()
	Default cProblema   := ""
	Default cSolucao	:= ""  

	aProblema := getHelpVetor(cProblema)
	aSolucao  := getHelpVetor(cSolucao)

	ShowHelpDlg(cTitulo, aProblema, Len(aProblema), aSolucao, Len(aSolucao))		

Return

/**
* Funcao		:	getHelpVetor
* Autor		:	Victor Hugo
* Data			:	20/05/2011
* Descricao	:	Retorna os Vetores de Help
*
* Parametros	:	cDescriao 	- Descricao do Problema ou Solucao
*/                                                               
Static Function getHelpVetor(cDescricao)

	Local nLin	  := 0	
	Local nMaxCol := 42		
	Local aVetor  := {}

	For nLin := 1 To MlCount(cDescricao, nMaxCol)		                            
		aAdd(aVetor, MemoLine(cDescricao, nMaxCol, nLin))			
	Next nI			

Return aVetor  

/**
* Metodo		:	ChkFormula
* Autor		:	Victor Hugo - Totvs Campinas
* Data			:	27/05/11
* Descricao	:	Validacao de Formulas Advpl
*/
Method ChkFormula() Class FunGen

	Local lOk		:= .T.	
	Local cFormula	:= &(ReadVar())	
	Local bErro 	:= ErrorBlock({ |oErro| oFun:ShowHelp("Fórmula Inválida", oErro:Description, "Verifique a sintaxe da Fórmula da digitada"), lOk := .F. })	

	Begin Sequence					
		&(AllTrim(cFormula))	
	End Sequence  	   

	ErrorBlock()

Return lOk  

/**
* Metodo		:	WriteTextFile
* Autor		:	Victor Hugo
* Data			:	31/05/11
* Descricao	:	Gravacao de Arquivos Texto
*
* Parametros	:	cFile - Arquivo a ser Gravado
*					cText - Texto a ser Gravado 
*
* Retorno		:	Logico - Indica se o Log foi Gravado
*/                                                                 
Method WriteTextFile(cFile, cText) Class FunGen

	Local nHandle 	:= 0                        
	Local lWrite	:= .T.	                    

	If !File(cFile)
		nHandle := FCreate(cFile)
	Else
		nHandle := FOpen(cFile, FO_READWRITE)
		FSeek(nHandle, 0, 2)
	Endif

	If nHandle == -1
		lWrite := .F.
	Else
		cText += CRLF
		If FWrite(nHandle, cText, Len(cText)) != Len(cText)
			lWrite := .F.
		EndIf
	EndIf

	FClose(nHandle)

	If !lWrite
		Alert("Falha na gravação do Arquivo "+AllTrim(cFile))	
	EndIf

Return lWrite      

/**
* Metodo		:	ReadCsvFile
* Autor		:	Victor Hugo - Totvs Campinas
* Data			:	30/07/10
* Descricao	:	Leitura de Arquivos CSV
*
* Parametros	:	cArqCsv	- Arquivo a ser Lido
*
* Retorno		:	aArqCsv - Array com o conteudo do Arquivo
*/
Method ReadCsvFile(cArqCsv) Class FunGen

	Local cDelimTxt	:= ";"	
	Local lArqOk	:= .T.	
	Local aArqCsv 	:= {}   	

	Begin Sequence

		&& Consiste o Arquivo Informado
		If !fArqCsvOk(self, cArqCsv)
			lArqOk := .F.
			Break
		EndIf

		&& Abre o Arquivo
		If FT_FUse(cArqCsv) == -1
			lArqOk := .F.
			::ShowHelp("Arquivo Inválido", "Falha ao abrir o Arquivo "+AllTrim(cArqCsv), "Verifique o Arquivo informado") 	
			Break		
		EndIf

	End Sequence	

	&& Armazena o Conteudo do Arquivo no Array de Retorno	
	If lArqOk	

		FT_FGoTop()
		While !FT_FEof()

			aCampos	:= {}
			cCpo	:= ""	   			
			cLinha 	:= FT_FReadLn()									
			nTamLin	:= Len(cLinha)+1
			For nI := 1 To nTamLin
				cChr := SubStr(cLinha, nI, 1)
				If cChr != cDelimTxt .AND. nI != nTamLin				
					cCpo += cChr
				Else
					aAdd(aCampos, cCpo)
					cCpo := ""	 		
				EndIf
			Next nI

			aAdd(aArqCsv, aCampos)

			FT_FSkip()
		Enddo

		&& Fecha o Arquivo
		FT_FUse()

	EndIf	

Return aArqCsv                     

/**
* Funcao		:	fArqCsvOk
* Data			:	30/07/10
* Descricao	:	Validacao do Arquivo CSV Informado
*/	 
Static Function fArqCsvOk(oFunGen, cArqCsv)

	Local lOk 		:= .T.
	Local cProblema	:= ""
	Local cSolucao	:= ""
	Local cExtens	:= ""

	&& Coleta a Extensao do Arquivo informado
	cExtens := StrTran(cArqCsv, FileNoExt(cArqCsv), "")

	&& Sequencia para Validacao do Arquivo
	Begin Sequence	

		If Empty(cArqCsv)
			lOk := .F.
			Break		
		EndIf	

		If !File(cArqCsv)
			lOk 		:= .F.
			cProblema 	:= "Arquivo não encontrado"		
			cSolucao	:= "Informe um arquivo válido" 
		EndIf

		If Lower(cExtens) <> ".csv"
			lOk 		:= .F.
			cProblema	:= "O Arquivo deve possuir a extensão *.csv"							
			cSolucao    := "Informe um arquivo com extensão *.csv"
		EndIf

	End Sequence

	&& Alerta o Usuario sobre alguma inconsistencia		
	If !lOk
		oFunGen:ShowHelp("Arquivo Inválido", cProblema, cSolucao)
	EndIf	

Return lOk 

/**
* Metodo		:	GetComboParambox
* Autor		:	Victor Hugo - Totvs Campinas
* Data			:	28/06/10
* Descricao	:	Trata as Perguntas do Tipo Combo da Funcao Parambox
*
* Parametros	:	xMvPar 		- Valor do Parametro na Parambox
*					aCombo		- Vetor contendo as Opcoes do Combo
*					nTipoRet    - Tipo de Retorno ( 1 = Indice do Combo, 2 = String do Combo )
*
* Retorno		:	xRet - Tipo de Retorno parametrizado
*
* Observacoes	:	Criado para contemplar o Bug dos ComboBox da Parambox
*/   
Method GetComboParambox(xMvPar, aCombo, nTipoRet) Class FunGen

	Local xRet			:= Nil	
	Default nTipoRet 	:= 1	

	If ValType(xMvPar) == "N" 
		If nTipoRet == 1
			xRet := xMvPar	
		Else
			xRet := aCombo[xMvPar]		
		EndIf		
	ElseIf ValType(xMvPar) == "C" 
		If nTipoRet == 1
			xRet := aScan(aCombo, xMvPar)
		Else
			xRet := xMvPar
		EndIf		
	EndIf

Return xRet 

/**
* Metodo		:	ExistTabBD
* Autor		:	Victor Hugo - Totvs Campinas
* Data			:	01/03/12
* Descricao	:	Verifica se as Tabelas passadas como parametro existem no Banco de Dados
*/
method existTabBD(aTabs, cCodEmp) class FunGen

	local nI	  	:= 0	
	local lOk	  	:= .T.
	local lAviso  	:= .F.
	local cQuery  	:= ""       	
	local cTabela 	:= ""	
	default cCodEmp := cEmpAnt

	for nI := 1 to Len(aTabs)                                               
		cTabela := aTabs[nI]
		cQuery 	:= " SELECT TOP 1 R_E_C_N_O_ FROM "+::getNomeSx2(cTabela, cCodEmp)	
		if !(lOk := ::procQuery(cQuery, 2, , lAviso))
			exit		
		endIf
	next nI

Return lOk
