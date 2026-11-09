#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "fileio.ch"
#INCLUDE "Rwmake.ch"

/*
Funcao QIMPNFSE 
Autor Mailson Silva	        
Data 07/07/2018
*/

User Function QIMPNFSE()
Local oIMPNFE

PRIVATE lMsErroAuto := .F.      

IF ( IsBlind() ) //abre empresa 01
	RpcSetType( 3 )
	PREPARE ENVIRONMENT EMPRESA( "01" ) FILIAL ( "01" ) MODULO ( "SIGACOM" )
	InitPublic()
	SetsDefault()
	SetModulo( "SIGACOM" , "COM" )  
	
	GeraQNFE(cEmpAnt,cFilAnt)
Else
	@ 200,001 TO 450,500 DIALOG oIMPNFE TITLE "Importacao de NFSE"
	@ 020,015 SAY "Este Programa executa a Importacao de XMLs"
	@ 030,015 SAY "para a empresa corrente."
	@ 040,015 SAY ""
	@ 050,015 SAY ""
	@ 070,015 SAY ""
	@ 080,015 SAY ""
	@ 010,010 TO 103,241
	@ 105,176 BMPBUTTON TYPE 01  ACTION (Processa({||GeraQNFE(cEmpAnt,cFilAnt)}),oIMPNFE:End()) 
	@ 105,206 BMPBUTTON TYPE 02  ACTION Close(oIMPNFE)
	ACTIVATE DIALOG oIMPNFE CENTERED
EndIF
    
Return .T.

Static Function GeraQNFE(_Emp,_Fil)
Local aSM0 := {}
Local aCabec := {}
Local aItens := {}
Local aLinha := {}
Local aRetNFE:= {}
Local cDirNFE:=""
Local oXML := nil
Local cErro := ""
Local cAviso := ""
Local _nX:= 0
Local _nI:= 0
Local cTexto    := ''
Local cFile     := ''
Local cFileLog  := ''
Local cMask     := 'Arquivos Texto (*.TXT)|*.txt|'  
Local _cDoc 	:= ""
Local _cSerie 	:= ""
Local _cForn 	:= ""
Local _cLoja 	:= ""
Local _cNaturez := "" 
Local _cProd	:= ""
Local _cTes		:= ""
Local _NfRef := ""
Local nValorTot	:= 0
Local nQtdTrad	:= 0

Local _cCCus    := ""
Local _cConta   := ""

Local _lClassifica 	:=  GetMv('MV_QCLASV',,.F.) 
Local _lZerSer		:=  SuperGetMV('MV_QZSERZ',.F.,.T.,PADR(' ',TAMSX3("D1_FILIAL")[1]))
Local _cCpTes 		:=  "D1_TES"//Alltrim(UPPER(SuperGetMV('MV_QCPTES',.F.,"D1_TES",PADR(' ',TAMSX3("D1_FILIAL")[1]))))
Local _lImporta		:= .F.
Local lNfRef := .F.   
Local _aTesAcl:= {} 
  
Local pTipoDoc := "3"

Local pTpEvInfo:= "1"
Local pTpEvAvis:= "2"
Local pTpEvERRO:= "3"

Local pAlteraY := "1"
Local pAlteraN := "2"

Local pSitua3 := "3"
Local pSitua4 := "4"
Local pSitua5 := "5"
Local pSitua6 := "6"

//declaracao Tratamento de erros
Local _cEnvLog		:= 	SuperGetMv("QUIRENVL",.F.,"") //Ativa envio de log para 
Local bError 
Local oError
Private _cError:= ""
bError := ErrorBlock( { |oError| MyError( oError ) } )
//Fim declaracao de tratamento de erros


cDirNFE := GetMv('MQ_QDRNFSE',,'\Receiver\NFSE\XMLTraduzidos\')
cDirErr	:= GetMv('MQ_QERNFSE',,'\Receiver\NFSE\XMLErroIntegracao\')
cDirProc:= GetMv('MQ_QDPNFSE',,'\Receiver\NFSE\XMLProcessados\')

If Substr(cDirNFE,len(cDirNFE),1) <> "\"
	cDirNFE+="\"
endif

If Substr(cDirErr,len(cDirErr),1) <> "\"
	cDirErr+="\"
endif

If Substr(cDirProc,len(cDirProc),1) <> "\"
	cDirProc+="\"
endif

aFiles := Directory(cDirNFE+"Nfse*.XML")

If Len(aFiles) == 0
	If !IsBlind(); 	MsgAlert("Nao ha arquivos para integracao."); endif
	Return
EndIf

aSM0 := FWLoadSM0()

For _nX:= 1 to Len(aFiles)

	aCabec := {}
	aItens := {}
	cErro  := ""
	_NfRef := ""
	_SerRef:= ""
	_EmpXML:= "" 
	_FilXML:= ""	
	lMsErroAuto := .F.
	_lImporta	:= .T.
    _lRemove 	:= .T.
	_aTesAcl:={}     	
	
	BEGIN SEQUENCE

	_cNomArq:=cDirNFE+aFiles[_nX][1]

	oXML := XmlParserFile(_cNomArq,"_",@cAviso,@cErro) //Parse XML
	
	If XmlChildEx(oXML,UPPER("_tcNfse"))== nil
		_cTmpTxt:= "Inconsistencia na estrutura do arquivo!,Não foi possivel ler o XML!"+_cNomArq
		U_QEXPEVENTO("", "", "", pTipoDoc, _cTmpTxt, pTpEvERRO, pAlteraY, pSitua4, AllTrim(SM0->M0_CODFIL), "")		
		cTexto += "Erro:"+_cTmpTxt + CRLF					
		_lImporta := .F.
	Else //If  ValType(oXML:_tcNfse) <> "U"

		//Verificar empresa tomadora
		If XmlChildEx(oXML:_tcNfse:_InfNfse:_DeclaracaoPrestacaoServico:_InfDeclaracaoPrestacaoServico:_Tomador:_IdentificacaoTomador:_CpfCnpj,"_CNPJ") <> nil  
			_EmpXML := Alltrim(oXML:_tcNfse:_InfNfse:_DeclaracaoPrestacaoServico:_InfDeclaracaoPrestacaoServico:_Tomador:_IdentificacaoTomador:_CpfCnpj:_Cnpj:TEXT) 
			_nAT:=AScan( aSM0,  { |x| x[18] ==_EmpXML}) //busca pela posicao do cnpj
			If _nAT > 0
				_EmpXML := aSM0[_nAT][1] //pega o codigo de empresa
			Else
				U_QEXPEVENTO("", "", "", pTipoDoc, "Verificar Inconsistencia: Cnpj do Tomador nao consta na Sigamat!", pTpEvERRO, pAlteraY, pSitua4, AllTrim(SM0->M0_CODFIL), "")		
				cTexto += "Erro: Verificar Inconsistencia: Cnpj do Tomador nao consta na Sigamat!" + CRLF							
				_lImporta := .F.	
			EndIf
		EndIf   
		
		If !XmlChildEx(oXML:_tcNfse:_InfNfse:_DeclaracaoPrestacaoServico:_InfDeclaracaoPrestacaoServico:_Tomador,"_INFTRAD") <> nil  
			U_QEXPEVENTO("", "", "", pTipoDoc, "Verificar Inconsistencia: tag _INFTRAD não informada.", pTpEvERRO, pAlteraY, pSitua4, AllTrim(SM0->M0_CODFIL), "")		
			cTexto += "Erro: Verificar Inconsistencia: tag _INFTRAD não informada." + CRLF
			_lImporta := .F.
		endif
		
		If _lImporta		
		    //filial tomadora
			If XmlChildEx(oXML:_tcNfse:_InfNfse:_DeclaracaoPrestacaoServico:_InfDeclaracaoPrestacaoServico:_Tomador:_InfTrad,"_XCODESTABTOMADOR") <> nil  
				_FilXML:=Alltrim(oXML:_tcNfse:_InfNfse:_DeclaracaoPrestacaoServico:_InfDeclaracaoPrestacaoServico:_Tomador:_InfTrad:_xCodEstabTomador:TEXT)
			else
				U_QEXPEVENTO("", "", "", pTipoDoc, "Verificar Inconsistencia: Cod Filial do Tomador nao consta no XML!", pTpEvERRO, pAlteraY, pSitua4, AllTrim(SM0->M0_CODFIL), "")		
				cTexto += "Erro: Verificar Inconsistencia: Cod Filial do Tomador nao consta nao consta no XML!" + CRLF		
				_lImporta := .F.
			EndIf   
			//verifica se deve importar apenas para a filial logada       
			If SuperGetMV('MV_QFILIAL',.F.,.T.,PADR(' ',TAMSX3("D1_FILIAL")[1])) 
				If _FilXML <> cFilAnt  			
					_lImporta := .F.					
					_lRemove := .F.
				Endif
			Else				
				cFilAnt := _FilXML
			Endif	
			//Dados do cabecalho//
			If(GetMV('MV_QNFEPAD',,.T.)==.T.) //verificar tamanho do campo/se usa zero a esquerda
				_cDoc := STRZERO(Val(oXML:_tcNfse:_InfNfse:_Numero:TEXT),tamsx3("F1_DOC")[1],0)  
				If XmlChildEx(oXML:_tcNfse:_InfNfse,"_SERIE") <> nil
					_cSerie := Alltrim(oXML:_tcNfse:_InfNfse:_Serie:TEXT)
					If VAL(_cSerie) > 0 .or. (_lZerSer .and. (_cSerie=="0" .or. _cSerie=="00" .or. _cSerie=="000"))//If VAL(oXML:_tcNfse:_InfNfse:_Serie:TEXT) > 0 .or. _lZerSer  
						_cSerie := STRZERO(Val(_cSerie),tamsx3("F1_SERIE")[1],0)
					//else
						//_cSerie := oXML:_tcNfse:_InfNfse:_INFNFE:_Serie:TEXT
					endif				
				else
					_cSerie:=" "
				EndIf
			Else
				_cDoc := oXML:_tcNfse:_InfNfse:_INFNFE:_Numero:TEXT
				If XmlChildEx(oXML:_tcNfse:_InfNfse,"_SERIE") <> nil  				
					_cSerie := Alltrim(oXML:_tcNfse:_InfNfse:_Serie:TEXT)//_cSerie := oXML:_tcNfse:_InfNfse:_INFNFE:_Serie:TEXT
				else
					_cSerie:=" "
				EndIf
			Endif		
			_cUF  := oXML:_tcNfse:_InfNfse:_PrestadorServico:_Endereco:_UF:TEXT
			_dData:= StoD(Substr(oXML:_tcNfse:_InfNfse:_DataEmissao:TEXT,1,4) + Substr(oXML:_tcNfse:_InfNfse:_DataEmissao:TEXT,6,2) + Substr(oXML:_tcNfse:_InfNfse:_DataEmissao:TEXT,9,2))
			If XmlChildEx(oXML:_tcNfse:_InfNfse,"_CODIGOVERIFICACAO") <> nil  
				_cChave := oXML:_tcNfse:_InfNfse:_CodigoVerificacao:TEXT                                                                  
			else
				_cChave := ""
			EndIF
	
			//Verificar prestador//
			If XmlChildEx(oXML:_tcNfse:_InfNfse:_PrestadorServico:_IdentificacaoPrestador:_CpfCnpj,"_CNPJ") <> nil  
				_CNPJ := Alltrim(oXML:_tcNfse:_InfNfse:_PrestadorServico:_IdentificacaoPrestador:_CpfCnpj:_CNPJ:TEXT) 
			ElseIf XmlChildEx(oXML:_tcNfse:_InfNfse:_PrestadorServico:_IdentificacaoPrestador:_CpfCnpj,"_CPF") <> nil  
				_CNPJ := Alltrim(oXML:_tcNfse:_InfNfse:_PrestadorServico:_IdentificacaoPrestador:_CpfCnpj:_CPF:TEXT) 
			Else                                            
				U_QEXPEVENTO("", "", "", pTipoDoc, "Verificar Inconsistencia: CNPJ/CPF Prestador nao informado.", pTpEvERRO, pAlteraY, pSitua4, AllTrim(SM0->M0_CODFIL), "")		
				cTexto += "Erro: Verificar Inconsistencia: CNPJ/CPF Prestador nao informado!" + CRLF						
				_lImporta := .F.	
	   		EndIf  		
		
			cTexto += Replicate( '-', 128 ) + CRLF		
			cTexto += 'Empresa 			: ' + SM0->M0_CODIGO + '/' + SM0->M0_NOME + CRLF + CRLF
			cTexto += 'Nota				: ' + _cDoc + CRLF
			cTexto += 'Data de Emissao	: ' + DtoC(_dData) + CRLF
			cTexto += 'Data de Digitacao: ' + DtoC(Date()) + CRLF	

			dbSelectArea("SA2") 
			dbSetOrder(3)
			If SA2->(dbSeek(xFilial("SA2")+_CNPJ))			
				//_cTipo := "N"
				_cForn := SA2->A2_COD
				_cLoja := SA2->A2_LOJA
				_cNaturez := SA2->A2_NATUREZ
				cTexto += 'Fornecedor: ' + SA2->A2_COD + '/' + SA2->A2_LOJA + " - " + ALLTRIM(SA2->A2_NOME) + CRLF
			Else
				U_QEXPEVENTO(_cDoc, _cSerie, _CNPJ, pTipoDoc, "Fornecedor nao encontrado. CNPJ: " + TransForm(_CNPJ,"@R 99.999.999/9999-99"), pTpEvERRO, pAlteraY, pSitua4,AllTrim(SM0->M0_CODFIL), _cChave)
				cTexto += 'Fornecedor nao encontrado. CNPJ: ' + TransForm(_CNPJ,"@R 99.999.999/9999-99") + CRLF 
				_lImporta := .F.
			Endif			

			If !XmlChildEx(oxml:_tcNfse:_InfNfse:_DeclaracaoPrestacaoServico:_InfDeclaracaoPrestacaoServico:_Servico,"_INFITEM") <> nil
				U_QEXPEVENTO(_cDoc, _cSerie, _CNPJ, pTipoDoc, "Item não informado para a NFS:" + _cDoc, pTpEvERRO, pAlteraY, pSitua4, AllTrim(SM0->M0_CODFIL), _cChave)
				cTexto += "Item não informado para a NFS:" + _cDoc + CRLF 
				_lImporta := .F.
			Endif
					
			If _lImporta					
				DbSelectArea("SF1")
				SF1->(DBSetOrder(1))
				If !SF1->(dbSeek(_FilXML+_cDoc+PADR(" ",tamsx3("F1_SERIE")[1])+_cForn+_cLoja))   //VERIFICAR SE A NF JA FOI LANcaDA				
					//aadd(aCabec,{"F1_FILIAL" ,cFilAnt})
					aadd(aCabec,{"F1_TIPO"   ,"N", Nil})
					aadd(aCabec,{"F1_FORMUL" ,"N", Nil})
					aadd(aCabec,{"F1_DOC"    ,_cDoc, Nil})
					aadd(aCabec,{"F1_SERIE"  ,_cSerie, Nil})
					aadd(aCabec,{"F1_EMISSAO",_dData, Nil})
					aadd(aCabec,{"F1_DESPESA", 0, Nil})
					aadd(aCabec,{"F1_FORNECE",_cForn, Nil})
					aadd(aCabec,{"F1_LOJA"   ,_cLoja, Nil})
					aadd(aCabec,{"F1_EST"	 ,_cUF, Nil})
					aadd(aCabec,{"F1_ESPECIE","NFS", Nil})           
					//Condicao de pagamento                 
						If XmlChildEx(oxml:_tcNfse:_InfNfse,"_COBR") <> NIL
							If XmlChildEx(oxml:_tcNfse:_InfNfse:_COBR,"_XCONDPAGTO") <> NIL
								aadd(aCabec,{"F1_COND", oxml:_tcNfse:_InfNfse:_COBR:_xCondPagto:TEXT})
							Else
								aAdd(aCabec,{"F1_COND", GetMv('MV_QCONDPG',,'001'),NIL})
							EndIf                 
						Endif
   					aAdd(aCabec,{"F1_TES"		,'' ,NIL})
					aadd(aCabec,{"F1_DESCONT" 	, 0 , Nil})
					aadd(aCabec,{"F1_SEGURO" 	, 0 , Nil})
					aadd(aCabec,{"F1_FRETE" 	, 0 , Nil})
					aadd(aCabec,{"F1_VALMERC" 	, Val(oxml:_tcNfse:_InfNfse:_DeclaracaoPrestacaoServico:_InfDeclaracaoPrestacaoServico:_Servico:_Valores:_ValorServicos:TEXT), Nil})
					aadd(aCabec,{"F1_VALBRUT" 	, Val(oxml:_tcNfse:_InfNfse:_DeclaracaoPrestacaoServico:_InfDeclaracaoPrestacaoServico:_Servico:_Valores:_ValorServicos:TEXT), Nil}) 
					aadd(aCabec,{"F1_MOEDA" 	, 1 , Nil}) 
					aadd(aCabec,{"F1_TXMOEDA" 	, 0 , Nil}) 
					IF(_lClassifica)
						aadd(aCabec,{"F1_STATUS" 	, "A" , Nil})					
						aadd(aCabec,{"F1_CODNFE" 	,_cChave, Nil})					
					EndIF
					//
					//Dados dos itens
					//
					If !ValType(oxml:_tcNfse:_InfNfse:_DeclaracaoPrestacaoServico:_InfDeclaracaoPrestacaoServico:_Servico:_InfItem:_InfTradItem:_tcInfTradItem) == "A"
						XmlNode2Arr(oxml:_tcNfse:_InfNfse:_DeclaracaoPrestacaoServico:_InfDeclaracaoPrestacaoServico:_Servico:_InfItem:_InfTradItem:_tcInfTradItem, "_tcInfTradItem" )
					EndIf   

					For _nI := 1 TO LEN(oxml:_tcNfse:_InfNfse:_DeclaracaoPrestacaoServico:_InfDeclaracaoPrestacaoServico:_Servico:_InfItem:_InfTradItem:_tcInfTradItem)							
				   					
						aLinha 		:= {}
						nQtdTrad	:= 0
						nValor   := 0
						_cProd 		:= ""
						_cCCus		:= ""
						_cConta		:= ""
						
						//Busca produtos
						If XmlChildEx(oxml:_tcNfse:_InfNfse:_DeclaracaoPrestacaoServico:_InfDeclaracaoPrestacaoServico:_Servico:_InfItem:_InfTradItem:_tcInfTradItem[_nI],"_XCODPRODUTO") <> nil                  
							_cProd := ALLTRIM(UPPER(ALLTRIM(oxml:_tcNfse:_InfNfse:_DeclaracaoPrestacaoServico:_InfDeclaracaoPrestacaoServico:_Servico:_InfItem:_InfTradItem:_tcInfTradItem[_nI]:_xCodProduto:TEXT)))
							
							dbSelectArea("SB1")
							dbSetOrder(1)
							dbGoTop()
							IF !SB1->(DBSEEK(xFilial("SB1")+_cProd))
								U_QEXPEVENTO(_cDoc, _cSerie, _CNPJ, pTipoDoc, "Codigo do produto invalido.", pTpEvERRO, pAlteraY, pSitua4, AllTrim(SM0->M0_CODFIL), _cChave)
						   		cTexto += "Codigo do produto invalido. Produto: " + _cProd + CRLF								
								_lImporta:=.F.							  
							EndIf
						Else
					   		U_QEXPEVENTO(_cDoc, _cSerie, _CNPJ, pTipoDoc, "Codigo do produto nao preenchido no XML", pTpEvERRO, pAlteraY, pSitua4, AllTrim(SM0->M0_CODFIL), _cChave)
					   		cTexto += "Codigo do produto nao preenchido no XML" + CRLF
					   		_lImporta := .F.
					   	EndIf    					
								
						If _lImporta			                                                                                                                                                                    
							nValor	:= Val(oxml:_tcNfse:_InfNfse:_DeclaracaoPrestacaoServico:_InfDeclaracaoPrestacaoServico:_Servico:_InfItem:_InfTradItem:_tcInfTradItem[_nI]:_vValorTotal:TEXT)
							nQtdTrad 	:= VAL(oxml:_tcNfse:_InfNfse:_DeclaracaoPrestacaoServico:_InfDeclaracaoPrestacaoServico:_Servico:_InfItem:_InfTradItem:_tcInfTradItem[_nI]:_vQtde:TEXT)								
							
							//array  
							aadd(aLinha,{"D1_FILIAL" 	, _FilXML				,Nil})        
							aAdd(aLinha,{"D1_ITEM"    	, StrZero(_nI,TAMSX3("D1_ITEM")[1]) ,NIL})  
							aadd(aLinha,{"D1_COD"  	 	, padr(_cProd,TAMSX3("D1_COD")[1])	,Nil})   
							aadd(aLinha,{"D1_QUANT"  	, nQtdTrad				,Nil})
							aadd(aLinha,{"D1_VUNIT"   	, ROUND(nValor / nQtdTrad,TamSX3("D1_VUNIT")[2]) 	,Nil})
							aadd(aLinha,{"D1_TOTAL"   	, nValor 			,Nil})			
							aadd(aLinha,{"D1_FORNECE"	,_cForn					,NIL})
							aadd(aLinha,{"D1_LOJA"    	,_cLoja					,NIL})
							
							If(_lClassifica) // .or. !_cCpTes=="D1_TES" //TES DE ENTRADA
								//oXML:_tcNfse:_InfNfse:_CFOPENTRADA
								If XmlChildEx(oxml:_tcNfse:_InfNfse,"_CFOPENTRADA") <> nil
									_cTes		:= oXML:_tcNfse:_InfNfse:_CfopEntrada:TEXT
									dbSelectArea("SF4")
									dbSetOrder(1) 
									dbGoTop()
									If LEN(_cTes)==3 .and. SF4->(dbSeek(xFilial("SF4")+_cTes))
										//aadd(aLinha,{"D1_TES", _cTes,Nil})  									
										//aadd(aLinha,{"D1_CF", SF4->F4_CF,Nil})
										if _lClassifica
											aadd(aLinha,{"D1_TES",_cTes,Nil})//"D1_TES"
										endif 

										//if !_cCpTes=="D1_TES"
										//	_cItem:=aLinha[2,2]
										//	aadd(_aTesAcl, {_cTes,_cItem})
										//endif  
									Else
										U_QEXPEVENTO(_cDoc, _cSerie, _CNPJ, pTipoDoc, "Codigo TES invalido.", pTpEvERRO, pAlteraY, pSitua4, AllTrim(SM0->M0_CODFIL), _cChave)
										cTexto += "Codigo TES invalido. TES: " + _cTes + CRLF								
										_lImporta:=.F.							  									
									EndIf
								else
									U_QEXPEVENTO(_cDoc, _cSerie, _CNPJ, pTipoDoc, "Codigo TES nao informado.", pTpEvERRO, pAlteraY, pSitua4, AllTrim(SM0->M0_CODFIL), _cChave)
									cTexto += "Codigo TES nao informado. TES: " + _cTes + CRLF								
									_lImporta:=.F.	
								endif
							EndIf
							
							//CC - Centro de Custos 
							//Regra - caso venha centro de custos do QUIRIUS usa, caso contrario pega do pedido de compras.
							If XmlChildEx(oxml:_tcNfse:_InfNfse:_DeclaracaoPrestacaoServico:_InfDeclaracaoPrestacaoServico:_Servico:_InfItem:_InfTradItem:_tcInfTradItem[_nI],"_XCENTROCUSTO") != NIL
								_cCCus:=oxml:_tcNfse:_InfNfse:_DeclaracaoPrestacaoServico:_InfDeclaracaoPrestacaoServico:_Servico:_InfItem:_InfTradItem:_tcInfTradItem[_nI]:_XCENTROCUSTO:TEXT
							EndIf

							//Conta Contabil
							//Regra - caso venha centro de custos do QUIRIUS usa, caso contrario pega do pedido de compras.
							If XmlChildEx(oxml:_tcNfse:_InfNfse:_DeclaracaoPrestacaoServico:_InfDeclaracaoPrestacaoServico:_Servico:_InfItem:_InfTradItem:_tcInfTradItem[_nI],"_XCONTCONTAB") != NIL
								//aadd(aLinha,{"D1_CONTA" , oxml:_tcNfse:_InfNfse:_DeclaracaoPrestacaoServico:_InfDeclaracaoPrestacaoServico:_Servico:_InfItem:_InfTradItem:_tcInfTradItem[_nI]:_xContContab:TEXT,Nil})
								_cConta:= oxml:_tcNfse:_InfNfse:_DeclaracaoPrestacaoServico:_InfDeclaracaoPrestacaoServico:_Servico:_InfItem:_InfTradItem:_tcInfTradItem[_nI]:_xContContab:TEXT
							EndIf												
							//Pedido de compra
							If XmlChildEx(oxml:_tcNfse:_InfNfse:_DeclaracaoPrestacaoServico:_InfDeclaracaoPrestacaoServico:_Servico:_InfItem:_InfTradItem:_tcInfTradItem[_nI],"_CPEDIDO") != NIL
								cPedido:= StrZero(Val(oxml:_tcNfse:_InfNfse:_DeclaracaoPrestacaoServico:_InfDeclaracaoPrestacaoServico:_Servico:_InfItem:_InfTradItem:_tcInfTradItem[_nI]:_cPedido:TEXT),TAMSX3("D1_PEDIDO")[1])
								cItemPC:= StrZero(Val(oxml:_tcNfse:_InfNfse:_DeclaracaoPrestacaoServico:_InfDeclaracaoPrestacaoServico:_Servico:_InfItem:_InfTradItem:_tcInfTradItem[_nI]:_nOrdemCompra:TEXT),TAMSX3("D1_ITEMPC")[1])
								
								dbSelectArea("SC7")
								SC7->(dbSetOrder(4))
								SC7->(dbGoTop())
								If SC7->(dbSeek(xFilial("SC7")+_cProd+REPLICATE(" ",TAMSX3("C7_PRODUTO")[1] - Len(_cProd)) + cPedido +cItemPC))									
									If SC7->C7_CONAPRO == "L" 
										If nQtdTrad > (SC7->C7_QUANT - (SC7->C7_QUJE + C7_QTDACLA))
											U_QEXPEVENTO(_cDoc, _cSerie, _CNPJ, pTipoDoc, "Quantidade da Nota maior que o disponivel no Pedido de Compra!Pedido:"+cPedido+" Item:"+ cItemPC, pTpEvERRO, pAlteraY, pSitua4, AllTrim(SM0->M0_CODFIL), _cChave)	
											cTexto += "Quantidade da Nota maior que o disponivel no Pedido de Compra! Pedido:"+cPedido+" Item:"+ cItemPC + CRLF
											_lImporta := .F.
										Else 
											aadd(aLinha,{"D1_PEDIDO",SC7->C7_NUM	,Nil})
											aadd(aLinha,{"D1_ITEMPC",SC7->C7_ITEM	,Nil})
											if Empty(_cCCus)//Caso não tenha vindo do QUIRIUS pega do pedido de compras
												_cCCus:=SC7->C7_CC
											endif
											if Empty(_cConta)//Caso não tenha vindo do QUIRIUS pega do pedido de compras
												_cConta:=SC7->C7_CONTA
											endif
										EndIf 
									ELSE 
										U_QEXPEVENTO(_cDoc, _cSerie, _CNPJ, pTipoDoc, "Pedido de Compra aguardando aprovacao! Pedido:"+cPedido+" Item:"+ cItemPC, pTpEvERRO, pAlteraY, pSitua4, AllTrim(SM0->M0_CODFIL), _cChave)	
										cTexto += "Pedido de Compra aguardando aprova?o! Pedido:"+cPedido+" Item:"+ cItemPC + CRLF
										_lImporta := .F.										
									Endif
								Else
									U_QEXPEVENTO(_cDoc, _cSerie, _CNPJ, pTipoDoc, "Pedido ou Item de Compra nao encontrado! Pedido:"+cPedido+" Item:"+ cItemPC, pTpEvERRO, pAlteraY, pSitua4, AllTrim(SM0->M0_CODFIL), _cChave)
									cTexto += "Pedido ou Item de Compra nao encontrado! Pedido:"+cPedido+" Item:"+ cItemPC + CRLF
									_lImporta := .F.
								EndIf
							EndIf

							//Centro de Custos
							if !Empty(_cCCus)
								aadd(aLinha,{"D1_CC"  , _cCCus 		,Nil})
							endif
							//Conta Contabil
							if !Empty(_cConta)
								aadd(aLinha,{"D1_CONTA"  , _cConta 		,Nil})
							endif
							   							
							If _lClassifica 
								aadd(aLinha,{"AUTDELETA" , "N" , Nil}) // Incluir sempre no ?timo elemento do array de cada item
							Endif
							
							aadd(aItens,aLinha) 
						EndIf											
				    next _nI
				    
					If _lImporta
						lMsErroAuto := .F.
						If _lClassifica //Documento de entrada					
							//MATA103(aCabec,aItens, 3 , .F.)
							MsExecAuto({|x,y,z,w|Mata103(x,y,z,w)},aCabec, aItens,3,.F.)
						Else //Pr?nota
						 	//MSExecAuto({|x,y,z|Mata140(x,y,z)},aCabec,aItens,3)  
							MSExecAuto({|x,y,z,a,b| MATA140(x,y,z,a,b)}, aCabec, aItens, 3,,)
						EndIf
						
						If lMsErroAuto							
							cErro := AllTrim(MemoRead(NomeAutoLog()))    
							
							//log
							cTexto += 'Status: Nao importado. Verificar inconsistencias.' + CRLF   
							cTexto += 'Erro: ' + CRLF + cErro
																		
							//Gera arquivo de eventos
							U_QEXPEVENTO(_cDoc, _cSerie, _CNPJ, pTipoDoc, "Verificar Inconsistencia: " + StrTran(NoAcento(AnsiToOem(cErro)),"<",""), pTpEvERRO, pAlteraY, pSitua4, AllTrim(SM0->M0_CODFIL), _cChave)
							_lImporta := .F.												
						Else	

							If Len(_aTesAcl) > 0
								dbSelectArea("SD1")
								DbSetOrder(1) 
								dbGoTop()
								dbSeek(Alltrim(SM0->M0_CODFIL)+_cDoc+_cSer+_cForn+_cLoja)  
								While !SD1->(Eof()) .and. Alltrim(SM0->M0_CODFIL)+_cDoc+_cSer+_cForn+_cLoja==SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)
									_nTPos:= aScan(_aTesAcl,{|x| AllTrim(x[2])==SD1->D1_ITEM})
									if _nTPos>0
										if !Empty(_aTesAcl[_nTPos,1])
											RecLock("SD1", .F.)		
											//SD1->D1_IDENTB6 := _aTesAcl[_nTPos,1]
											_cTmp:="SD1->"+_cCpTes+":= _aTesAcl[_nTPos,1]"
											&(_cTmp)
											MsUnLock()
										endif
									endif
									SD1->(dbskip())
								enddo
							EndIf  


							//log e arquivo de eventos
							_cDescr:= IIF(_lClassifica,'Nota Fiscal Integrada', 'Pre Nota Integrada - Classificar')
							_cSitu:= IIF(_lClassifica,pSitua5,pSitua3)
			   				U_QEXPEVENTO(_cDoc, _cSerie, _CNPJ, pTipoDoc, _cDescr, pTpEvInfo, pAlteraN, _cSitu, AllTrim(SM0->M0_CODFIL), _cChave)					
							cTexto += 'Status: ' + _cDescr + CRLF + CRLF
						EndIf
					EndIf				
				Else
					//log e arquivo de eventos
					U_QEXPEVENTO(_cDoc, _cSerie, _CNPJ, pTipoDoc, 'Nao importado. Nota fiscal ja existente no Protheus', pTpEvERRO, pAlteraY, pSitua4, AllTrim(SM0->M0_CODFIL), _cChave)					
					cTexto += 'Status: Nao importado. Nota fiscal ja existente no Protheus.' + CRLF + CRLF
					_lImporta := .F.
				EndIf
			EndIf
		EndIf
	EndIF

	RECOVER
		
		_cTmpTxt:= "Inconsistencia na estrutura do arquivo!"+_cNomArq+" falha:"+_cError
		U_QEXPEVENTO("", "", "", pTipoDoc, _cTmpTxt, pTpEvERRO, pAlteraY, pSitua4, AllTrim(SM0->M0_CODFIL), "")		
		cTexto += "Erro:"+_cTmpTxt + CRLF					
		_lImporta := .F.
		
		cTo := _cEnvLog//Ativa envio de log para 
    	if !Empty(cTo)
			cSubject := _cTmpTxt
			cCC := ""
			cAttach := cDirNFE+aFiles[_nX][1]
			cMsg:= _cError
			U_GREnvM(, cTo, cCC, cSubject, cMsg, cAttach)//Evnia email
		endif
	END SEQUENCE 
	
	If SuperGetMV('MV_QFILIAL',.F.,.T.,PADR(' ',TAMSX3("D1_FILIAL")[1])) .and. !_lRemove
		//tratamento para não remover arquivos de filiais diferentes
	Else	
		//Copia arquivos para os diretorios
		If _lImporta                                                    
			//XMLProcessados
			__CopyFile(cDirNFE+aFiles[_nX,1],cDirProc+aFiles[_nX,1])	
		Else                
			//XMLErroIntegracao
			__CopyFile(cDirNFE+aFiles[_nX,1],cDirErr+aFiles[_nX,1])	
		EndIf
		//Apaga arquivo da pasta \XMLTraduzidos\
		FErase(cDirNFE+aFiles[_nX,1])      
	Endif
Next _nX

If !IsBlind()

	If alltrim(cTexto) == ''
		cTexto := "Nao ha arquivos para integracao."+ CRLF + CRLF
	Endif
	cTexto += "Versao: 01.03.2021" + CRLF + CRLF
		
	cFileLog := MemoWrite( CriaTrab( , .F. ) + '.log', cTexto )
	
	Define Font oFont Name 'Mono AS' Size 5, 12
	
	Define MsDialog oDlg Title 'Atualizacao concluida.' From 3, 0 to 340, 417 Pixel
	
	@ 5, 5 Get oMemo Var cTexto Memo Size 200, 145 Of oDlg Pixel
	oMemo:bRClicked := { || AllwaysTrue() }
	oMemo:oFont     := oFont
	
	Define SButton From 153, 175 Type  1 Action oDlg:End() Enable Of oDlg Pixel // Apaga
	Define SButton From 153, 145 Type 13 Action ( cFile := cGetFile( cMask, '' ), If( cFile == '', .T., ;
	MemoWrite( cFile, cTexto ) ) ) Enable Of oDlg Pixel // Salva e Apaga //'Salvar Como...'
	
	Activate MsDialog oDlg Center
EndIf  


IF ( IsBlind() )
	RESET ENVIRONMENT
EndIF   

Return(.T.)   


//################################
//################################
//################################
Static Function MyError( oError )
	_cError:= oError:Description
	BREAK
Return( NIL )
