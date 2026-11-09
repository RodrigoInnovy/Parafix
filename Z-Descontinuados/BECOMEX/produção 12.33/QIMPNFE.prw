#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "fileio.ch"
#INCLUDE "Rwmake.ch"
               
/*
???????????????????????????????????????
???????????????????????????????????????
??un?o    ?IMPNFE ?Autor ?Mailson Silva	        ?Data ?6/01/2014 ??
???????????????????????????????????????
??         ?otina de integra?o de NFe DFe-Receiver x Protheus		   ??
???????????????????????????????????????
/*/

User Function QIMPNFE()
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
	@ 200,001 TO 450,500 DIALOG oIMPNFE TITLE "Importacao de NFE"
	@ 020,015 SAY "Este Programa executa a Importacao de XMLs"
	@ 030,015 SAY "para a empresa corrente."
	@ 040,015 SAY ""
	@ 050,015 SAY ""
	@ 070,015 SAY ""
	@ 080,015 SAY ""
	@ 010,010 TO 103,241
   //	@ 105,146 BMPBUTTON TYPE 05  ACTION Pergunte("EXFCAO",.T.) 
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
//Local _nY:= 0
Local cTexto    := ''
Local cFile     := ''
Local cFileLog  := ''
Local cMask     := 'Arquivos Texto (*.TXT)|*.txt|'  
Local _cTipo 	:= ""
Local _cForn 	:= ""
Local _cLoja 	:= ""
Local _cNaturez := "" 
Local _cProd	:= ""
Local _NfRef := ""
Local nValorTot	:= 0
Local nQtdTrad	:= 0
Local nQtdP3	:= 0
//Local strQtdP3 	:= ''
Local _lClassifica 	:=  SuperGetMV('MV_QCLASS',.F.,.F.,PADR(' ',TAMSX3("D1_FILIAL")[1])) 
Local _cCpTes 		:=  Alltrim(UPPER(SuperGetMV('MV_QCPTES',.F.,"D1_TES",PADR(' ',TAMSX3("D1_FILIAL")[1]))))
Local _lZerSer		:=  SuperGetMV('MV_QZSERZ',.F.,.T.,PADR(' ',TAMSX3("D1_FILIAL")[1]))
Local _lFciIt		:=  SuperGetMV('MV_QFCIIT',.F.,.T.,PADR(' ',TAMSX3("D1_FILIAL")[1])) //Preenche ou não a FCI nos itens do documento
Local _lTamPad		:=  SuperGetMV('MV_QNFEPAD',.F.,.T.,PADR(' ',TAMSX3("D1_FILIAL")[1]))  //verificar tamanho do campo/usa zero a esq
Local _lVldFil		:=  SuperGetMV('MV_QFILIAL',.F.,.T.,PADR(' ',TAMSX3("D1_FILIAL")[1]))
Local _cSpecie		:=  SuperGetMv('MQ_ESPNFE',.F.,'SPED',PADR(' ',TAMSX3("D1_FILIAL")[1]))
Local _lNcmX		:=  SuperGetMv('MQ_NCMXML',.F.,.T.,PADR(' ',TAMSX3("D1_FILIAL")[1]))
Local _cCodPg 		:=	SuperGetMv('MV_QCONDPG',.F.,'001',PADR(' ',TAMSX3("D1_FILIAL")[1])) //Condicao de pagamento padrao
Local _lFreSeg 		:=	SuperGetMv('MV_QFRESEG',.F.,.F.,PADR(' ',TAMSX3("D1_FILIAL")[1])) //Condicao de pagamento padrao
//Local _lClasTes 	:=  SuperGetMV('MV_QCLAST',.F.,.F.,PADR(' ',TAMSX3("D1_FILIAL")[1]))
Local _lImporta		:= .F.
Local lNfRef := .F.    
  
Local pTipoDoc := "1"

Local pTpEvInfo:= "1"
Local pTpEvAvis:= "2"
Local pTpEvERRO:= "3"

Local pAlteraY := "1"
Local pAlteraN := "2"

Local pSitua3 := "3"
Local pSitua4 := "4"
Local pSitua5 := "5"
Local pSitua6 := "6"
Local _IDENTB6:= {}
Local _aTesAcl:= {}
//Local aTotais := {}
Local _nTmIt  := TamSx3("D1_ITEM")[1]
Local _cItem  := ""
Local _nTPos  := 0
Local _cCCus  := ""
Local _cConta := ""
Local _cLocal := ""
Local _cNomArq:= ""
//Local _aRefIt := {}
Local _aRefCh := {}
Local _nI:= 0
Local _ich:= 0
Local _objTmp:=nil

//declaracao Tratamento de erros
Local _cEnvLog		:= 	SuperGetMv("QUIRENVL",.F.,"") //Ativa envio de log para 
Local bError 
Local oError
Private _cError:= ""
bError := ErrorBlock( { |oError| MyError( oError ) } )
//Fim declaracao de tratamento de erros


Private _cCfoSrv:= SuperGetMV('MV_QCFSRV',.F.,"6124/5124",PADR(' ',TAMSX3("D1_FILIAL")[1]))
Private _lEntBen:=.F. //Entrada de Beneficiamento
Private _nVlItem:=0
Private _nVlIteX:=0

cDirNFE := SuperGetMV('MV_QIMPNFE',.F.,'\Receiver\NFE\XMLTraduzidos\') //,PADR(' ',TAMSX3("D1_FILIAL")[1]) - removido para buscar o parametro por filial
cDirErr	:= SuperGetMV('MV_QDERNFE',.F.,'\Receiver\NFE\XMLErroIntegracao\')
cDirProc:= SuperGetMV('MV_QDPRNFE',.F.,'\Receiver\NFE\XMLProcessados\')

If Substr(cDirNFE,len(cDirNFE),1) != "\"
	cDirNFE+="\"
endif

If Substr(cDirErr,len(cDirErr),1) != "\"
	cDirErr+="\"
endif

If Substr(cDirProc,len(cDirProc),1) != "\"
	cDirProc+="\"
endif

aFiles := Directory(cDirNFE+"*.XML")

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
	_cCondP:= ""
	_EmpXML:= "" 
	_FilXML:= ""	
	_IDENTB6:= {}
	_aTesAcl:={} 
	_cItem	:= REPLICATE("0",_nTmIt)//Inicializa
	_lImporta:= .T.
	lMsErroAuto := .F.
	_lRemove := .T.	
	lNfRef := .F.
	_lEntBen:=.F. //Entrada de Beneficiamento
	_objTmp:=nil

	BEGIN SEQUENCE

	_cNomArq:=cDirNFE+aFiles[_nX][1]

	oXML := XmlParserFile(_cNomArq,"_",@cAviso,@cErro) //Parse XML
	
	If XmlChildEx(oXML,"_NFEPROC")== nil //ValType(oXML:_NFEPROC) == "U" //
		_cTmpTxt:= "Inconsistencia na estrutura do arquivo!,Não foi possivel ler o XML!"+_cNomArq
		U_QEXPEVENTO("", "", "", pTipoDoc, _cTmpTxt, pTpEvERRO, pAlteraY, pSitua4, AllTrim(SM0->M0_CODFIL), "")		
		cTexto += "Erro:"+_cTmpTxt + CRLF					
		_lImporta := .F.
	else
		//verificar tags
		If XmlChildEx(oXML:_NFEPROC:_NFE:_INFNFE:_EMIT,"_INFTRAD") != nil .AND. XmlChildEx(oXML:_NFEPROC:_NFE:_INFNFE:_DEST,"_INFTRAD") != nil
				//Dados do cabecalho//
			If(_lTamPad) //verificar tamanho do campo/usa zero a esq
				_cDoc := STRZERO(Val(oXML:_NFEPROC:_NFE:_INFNFE:_IDE:_NNF:TEXT),tamsx3("F1_DOC")[1],0)
				_cSer := Alltrim(oXML:_NFEPROC:_NFE:_INFNFE:_IDE:_SERIE:TEXT)
				If VAL(_cSer) > 0 .or. (_lZerSer .and. (_cSer=="0" .or. _cSer=="00" .or. _cSer=="000"))//If VAL(oXML:_NFEPROC:_NFE:_INFNFE:_IDE:_SERIE:TEXT) > 0 .or. _lZerSer
					_cSer := STRZERO(VAL(_cSer),tamsx3("F1_SERIE")[1],0)
				Endif
			Else
				_cDoc := oXML:_NFEPROC:_NFE:_INFNFE:_IDE:_NNF:TEXT
				_cSer := oXML:_NFEPROC:_NFE:_INFNFE:_IDE:_SERIE:TEXT
			Endif	
				//log
				cTexto += Replicate( '-', 128 ) + CRLF		
				cTexto += 'Empresa : ' + SM0->M0_CODIGO + '/' + SM0->M0_NOME + CRLF + CRLF
				cTexto += 'Nota/Serie: ' + _cDoc + "/" + _cSer + CRLF
				
			_cTipo:= oXML:_NFEPROC:_INTEGRACAO:_TipoRecebimento:TEXT		
			_cUF  := oXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_ENDEREMIT:_UF:TEXT
			If XmlChildEx(oXML:_NFEPROC:_NFE:_INFNFE:_IDE,"_DEMI") != nil  
				_dData:= StoD(Substr(oXML:_NFEPROC:_NFE:_INFNFE:_IDE:_DEMI:TEXT,1,4) + Substr(oXML:_NFEPROC:_NFE:_INFNFE:_IDE:_DEMI:TEXT,6,2) + Substr(oXML:_NFEPROC:_NFE:_INFNFE:_IDE:_DEMI:TEXT,9,2))
			elseif XmlChildEx(oXML:_NFEPROC:_NFE:_INFNFE:_IDE,"_DHEMI") != nil  
				_dData:= StoD(Substr(oXML:_NFEPROC:_NFE:_INFNFE:_IDE:_DHEMI:TEXT,1,4) + Substr(oXML:_NFEPROC:_NFE:_INFNFE:_IDE:_DHEMI:TEXT,6,2) + Substr(oXML:_NFEPROC:_NFE:_INFNFE:_IDE:_DHEMI:TEXT,9,2))
			ELSE
				U_QEXPEVENTO(_cDoc, _cSer, _CNPJ, pTipoDoc, "Data de emissao nao informada", pTpEvERRO, pAlteraY, pSitua4,AllTrim(SM0->M0_CODFIL), _cChave)
				cTexto += 'Data de emissao nao informada' + CRLF 
				_lImporta := .F.
			endif
			_CNPJ := ALLTRIM(oXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_CNPJ:TEXT)		
				//log
				cTexto += 'Data de Emissao: ' + DtoC(_dData) + CRLF
				cTexto += 'Data de Digitacao: ' + DtoC(Date()) + CRLF	

			//Verificar empresa//
			If XmlChildEx(oXML:_NFEPROC:_NFE:_INFNFE:_DEST,"_CNPJ") != nil  
				_EmpXML := Alltrim(oXML:_NFEPROC:_NFE:_INFNFE:_DEST:_CNPJ:TEXT) 
				_nAT:=AScan( aSM0,  { |x| x[18] ==_EmpXML}) //busca a posicao do cnpj
				if _nAt==0 .and. cEmpAnt == "99"
					_nAt:=1
				endif

				If _nAT > 0
					_EmpXML := aSM0[_nAT][1] //pega o codigo de empresa 
					_FilXML := aSM0[_nAT][2] //pega o codigo de filial 
				Else
					//cTexto += "Erro: Verificar Inconsistencia: Cnpj Empresa do XML nao consta na sigamat!" + CRLF	
					_cTmpTxt:="Verificar Inconsistencia: Cnpj Empresa do XML nao consta na sigamat!"
					cTexto += "Erro:"+_cTmpTxt + CRLF	
					U_QEXPEVENTO("", "", "", pTipoDoc, _cTmpTxt, pTpEvERRO, pAlteraY, pSitua4, AllTrim(SM0->M0_CODFIL), "")	
					_lImporta := .F.	
				EndIf
			EndIf

			//VERIFICAR SE A NF JA FOI LANCADA
			_cChave := SUBSTR(oXML:_NFEPROC:_NFE:_INFNFE:_ID:TEXT,4,LEN(oXML:_NFEPROC:_NFE:_INFNFE:_ID:TEXT))
			conout("Chave pesquisada QIMPNFE ln205|"+_cChave+"|")							
			If NFCadastrada(AllTrim(_cChave))
				U_QEXPEVENTO(_cDoc, _cSer, _CNPJ, pTipoDoc, 'Nao importado. Nota fiscal ja existente no Protheus', pTpEvERRO, pAlteraY, pSitua4, AllTrim(SM0->M0_CODFIL), _cChave)					
				cTexto += 'Status: Nao importado. Nota fiscal ja existente no Protheus.' + CRLF + CRLF
				_lImporta := .F.
			EndIf			   		
		Else
			U_QEXPEVENTO("", "", "", pTipoDoc, "Verificar Inconsistencia: Tag <INFTRAD> nao consta no XML! arquivo:" + aFiles[_nX][1], pTpEvERRO, pAlteraY, pSitua4, AllTrim(SM0->M0_CODFIL), "")		
			cTexto += "Erro: Verificar Inconsistencia: Tag <INFTRAD> nao consta no XML!" + CRLF				
			_lImporta := .F.	
		EndIf

		If _lImporta     
			If XmlChildEx(oXML:_NFEPROC:_NFE:_INFNFE:_DEST:_INFTRAD,"_XCODESTABELECIMENTO") != nil  	
				If _lVldFil 
					If _FilXML != cFilAnt  			
						//_lImporta := .F.					
						_lRemove := .F.
						//cTexto += "Aviso: Arquivo nao importado, Filial do XML difere da filial logada!" + CRLF
						_cTmpTxt:="Arquivo nao importado, Filial do XML difere da filial logada!"
						cTexto += "Erro:"+_cTmpTxt + CRLF	
						U_QEXPEVENTO("", "", "", pTipoDoc, _cTmpTxt, pTpEvERRO, pAlteraY, pSitua4, AllTrim(SM0->M0_CODFIL), "")	
						_lImporta := .F.
					Endif
				Else				
					cFilAnt := _FilXML
				Endif
			EndIf
			
			If AllTrim(_EmpXML) == ""
				U_QEXPEVENTO("", "", "", pTipoDoc, "Verificar Inconsistencia: Cod Empresa nao esta no XML!", pTpEvERRO, pAlteraY, pSitua4, AllTrim(SM0->M0_CODFIL), "")		
				cTexto += "Erro: Verificar Inconsistencia: Cod Empresa no XML nao consta na sigamat!" + CRLF			
				_lImporta := .F.
			EndIf
			If AllTrim(_FilXML) == ""
				U_QEXPEVENTO("", "", "", pTipoDoc, "Verificar Inconsistencia: Cod Filial nao esta no XML!", pTpEvERRO, pAlteraY, pSitua4, AllTrim(SM0->M0_CODFIL), "")		
				cTexto += "Erro: Verificar Inconsistencia: Cod Filial no XML nao consta na sigamat!" + CRLF					
				_lImporta := .F.
			EndIf   		  
							

			If _cTipo == "1" //1=Normal
				
				if XmlChildEx(oXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_INFTRAD,"_XCODFORNECEDOR") == Nil .or. XmlChildEx(oXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_INFTRAD,"_XCODLOJA") == Nil
					_cTmpTxt:= "Verificar Inconsistencia: nao foi encontrado cod fornecedor ou loja!"+_cNomArq
					U_QEXPEVENTO("", "", "", pTipoDoc, _cTmpTxt, pTpEvERRO, pAlteraY, pSitua4, AllTrim(SM0->M0_CODFIL), "")		
					cTexto += "Erro:"+_cTmpTxt + CRLF					
					_lImporta := .F.
				else
				
					_cForn := PADR(ALLTRIM(oXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_INFTRAD:_XCODFORNECEDOR:TEXT),TAMSX3("A2_COD")[1])
					_cLoja := PADR(ALLTRIM(oXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_INFTRAD:_XCODLOJA:TEXT),TAMSX3("A2_LOJA")[1])
					
					dbSelectArea("SA2")
					dbSetOrder(1) 
					dbGoTop()
					If SA2->(dbSeek(xFilial("SA2")+_cForn+_cLoja))
						_cTipo := "N"
						_cForn := SA2->A2_COD
						_cLoja := SA2->A2_LOJA
						_cNaturez := SA2->A2_NATUREZ					
						//log
						cTexto += 'Fornecedor: ' + SA2->A2_COD + '/' + SA2->A2_LOJA + " - " + ALLTRIM(SA2->A2_NOME) + CRLF
					Else
						U_QEXPEVENTO(_cDoc, _cSer, _CNPJ, pTipoDoc, "Fornecedor nao encontrado. CNPJ: " + TransForm(_CNPJ,"@R 99.999.999/9999-99"), pTpEvERRO, pAlteraY, pSitua4,AllTrim(SM0->M0_CODFIL), _cChave)
						cTexto += 'Fornecedor nao encontrado. CNPJ: ' + TransForm(_CNPJ,"@R 99.999.999/9999-99") + CRLF 
						_lImporta := .F.
					Endif
				endif
			elseIf _cTipo == "2" //2=Devolução
				/* RESOLVIDO EM 12/02/2020 com Diego, Admir e Luiz que ser?sado o CNPJ
				_cForn := PADR(ALLTRIM(oXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_INFTRAD:_XCODFORNECEDOR:TEXT),TAMSX3("A1_COD")[1])
				_cLoja := PADR(ALLTRIM(oXML:_NFEPROC:_NFE:_INFNFE:_EMIT:_INFTRAD:_XCODLOJA:TEXT),TAMSX3("A1_LOJA")[1])
				*/
				dbSelectArea("SA1")
				dbSetOrder(3)//dbSetOrder(1) 
				dbGoTop()
				If SA1->(dbSeek(xFilial("SA1")+_CNPJ))//SA1->(dbSeek(xFilial("SA1")+_cForn+_cLoja))
					_cTipo := "D"
					_cForn := SA1->A1_COD
					_cLoja := SA1->A1_LOJA
					_cNaturez := SA1->A1_NATUREZ					
					//log
					cTexto += 'Cliente: ' + SA1->A1_COD + '/' + SA1->A1_LOJA + " - " + ALLTRIM(SA1->A1_NOME) + CRLF
				Else
					U_QEXPEVENTO(_cDoc, _cSer, _CNPJ, pTipoDoc, "Fornecedor nao encontrado. CNPJ: " + TransForm(_CNPJ,"@R 99.999.999/9999-99"), pTpEvERRO, pAlteraY, pSitua4,AllTrim(SM0->M0_CODFIL), _cChave)
					cTexto += 'Cliente nao encontrado. CNPJ: ' + TransForm(_CNPJ,"@R 99.999.999/9999-99") + CRLF 
					_lImporta := .F.
				Endif
			ElseIf _cTipo == "3" //BENEFICIAMENTO
				
				dbSelectArea("SA1")
				SA1->(dbSetOrder(3))
				If SA1->(dbSeek(xFilial("SA1")+_CNPJ))
					_cTipo := "B"  //tipo 3 = BENEFICIAMENTO
					_cForn := SA1->A1_COD
					_cLoja := SA1->A1_LOJA
					_cNaturez := SA1->A1_NATUREZ
					
					//log
					cTexto += 'Cliente: ' + _cForn + "/" + _cLoja + ALLTRIM(SA1->A1_NOME) + CRLF
				Else
					U_QEXPEVENTO(_cDoc, _cSer, _CNPJ, pTipoDoc, "Cliente nao encontrado. CPF: " + TransForm(_CNPJ,"@R 99.999.999/9999-99"), pTpEvERRO, pAlteraY, pSitua4, AllTrim(SM0->M0_CODFIL), _cChave)
					cTexto += 'Cliente nao encontrado. CPF: ' + TransForm(_CNPJ,"@R 99.999.999/9999-99") + CRLF
					_lImporta := .F.
				Endif
			ELSE
				U_QEXPEVENTO(_cDoc, _cSer, _CNPJ, pTipoDoc, "Tipo de Recebimento nao cadastrado.", pTpEvERRO, pAlteraY, pSitua4, AllTrim(SM0->M0_CODFIL), _cChave)
				cTexto += "Tipo de Recebimento não cadastrado." + CRLF
				_lImporta := .F.
			EndIf
			
			//NF de referencia
			If _lImporta .and. XmlChildEx(oxml:_NFEPROC:_NFE:_INFNFE:_IDE,"_NFREF") != Nil .and. _cTipo $ "N/D"    
				If _cTipo == "N" //1=Normal
					_lEntBen:=.T.
				ENDIF

				If !ValType(oxml:_NFEPROC:_NFE:_INFNFE:_IDE:_NFREF) == "A" //mais de uma NF 
					XmlNode2Arr(oxml:_NFEPROC:_NFE:_INFNFE:_IDE:_NFREF, "_NFREF" )
				EndIf
					
				For _nI := 1 TO LEN(oxml:_NFEPROC:_NFE:_INFNFE:_IDE:_NFREF)
					_cChv:= oxml:_NFEPROC:_NFE:_INFNFE:_IDE:_NFREF[_nI]:_REFNFE:TEXT
					cTexto += "NFREF:" +_cChv  + CRLF	
					If SUBSTR(_cChv,21,2) $ "55"       //NFE=MODELO 55
						
						If _cTipo $ "N/D" 
							if VldChS(_cChv)
								AADD(_aRefCh,_cChv)
							else
								_cMsg:="Chave refenciada nao localizada na base."+_cChv
								U_QEXPEVENTO(_cDoc, _cSer, _CNPJ, pTipoDoc, _cMsg, pTpEvERRO, pAlteraY, pSitua4, AllTrim(SM0->M0_CODFIL), _cChave)
								cTexto += _cMsg + CRLF								
								_lImporta:=.F.
								EXIT	
							EndIf

						endif
						
						
					Endif 
				Next _nI
			EndIf
			
			
			If _lImporta

					aadd(aCabec,{"F1_TIPO"   ,_cTipo, Nil})
					aadd(aCabec,{"F1_FORMUL" ,"N", Nil})
					aadd(aCabec,{"F1_DOC"    ,_cDoc, Nil})
					aadd(aCabec,{"F1_SERIE"  ,_cSer, Nil})
					aadd(aCabec,{"F1_EMISSAO",_dData, Nil})
					aadd(aCabec,{"F1_DESPESA" , 0, Nil})
					aadd(aCabec,{"F1_FORNECE",_cForn, Nil})
					aadd(aCabec,{"F1_LOJA"   ,_cLoja, Nil})
					aadd(aCabec,{"F1_EST"	 ,_cUF, Nil})
					aadd(aCabec,{"F1_ESPECIE",_cSpecie, Nil})  

					// CondPag               
					aAdd(aCabec,{"F1_TES",'',NIL})
					
					aadd(aCabec,{"F1_DESCONT" , U_GetVlObj(oxml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT,"_VDESC","N") , Nil})

					if !_lFreSeg
						aadd(aCabec,{"F1_SEGURO" , 0 , Nil})
						aadd(aCabec,{"F1_FRETE" , 0 , Nil})
					else
						aadd(aCabec,{"F1_SEGURO" , U_GetVlObj(oxml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT,"_VSEG","N"), Nil})
						aadd(aCabec,{"F1_FRETE" , U_GetVlObj(oxml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT,"_VFRETE","N") , Nil})
					endif
					
					aadd(aCabec,{"F1_VALMERC" , Val(oxml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VPROD:TEXT) , Nil})
					aadd(aCabec,{"F1_VALBRUT" , Val(oxml:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_vNF:TEXT) , Nil}) 
					aadd(aCabec,{"F1_MOEDA" , 1 , Nil}) 
					aadd(aCabec,{"F1_TXMOEDA" , 0 , Nil}) 
					aadd(aCabec,{"F1_STATUS" , IIF(_lClassifica,"A","") , Nil})					
					aadd(aCabec,{"F1_CHVNFE" ,_cChave, Nil})
					
					//
					//Dados dos itens
					//
					If !ValType(oxml:_NFEPROC:_NFE:_INFNFE:_DET) == "A"
						XmlNode2Arr( oxml:_NFEPROC:_NFE:_INFNFE:_DET, "_DET" )
					EndIf
					
					For _nI := 1 TO LEN(oxml:_NFEPROC:_NFE:_INFNFE:_DET)
						
						aLinha 		:= {}
						nQtdTrad	:= 0
						nQtdP3		:= 0
						nValorTot	:= 0
						_cProd 		:= ""
						_cCCus		:= ""
						_cConta		:= ""
						_cLocal		:= ""
						_cTes		:= ""

						//Busca produtos
						If XmlChildEx(oxml:_NFEPROC:_NFE:_INFNFE:_DET[_nI]:_PROD:_INFTRAD,"_XCODPRODUTO") != nil                  
							_cProd := UPPER(ALLTRIM(oxml:_NFEPROC:_NFE:_INFNFE:_DET[_nI]:_PROD:_INFTRAD:_XCODPRODUTO:TEXT))
						Else
							U_QEXPEVENTO(_cDoc, _cSer, _CNPJ, pTipoDoc, "Codigo do produto nao preenchido no XML", pTpEvERRO, pAlteraY, pSitua4, AllTrim(SM0->M0_CODFIL), _cChave)
							cTexto += "Codigo do produto nao preenchido no XML" + CRLF
							_lImporta:=.F.	
							EXIT 
						EndIf     

						dbSelectArea("SB1")
						IF !SB1->(dbSeek(xFilial("SB1")+_cProd))
							U_QEXPEVENTO(_cDoc, _cSer, _CNPJ, pTipoDoc, "Codigo do produto invalido.", pTpEvERRO, pAlteraY, pSitua4, AllTrim(SM0->M0_CODFIL), _cChave)
							cTexto += "Codigo do produto invalido: " + _cProd + CRLF								
							_lImporta:=.F.
							EXIT							
						EndIf				

						aadd(aLinha,{"D1_FILIAL" 	, cFilAnt				,Nil})        
						aAdd(aLinha,{"D1_ITEM"    	, StrZero(_nI,TAMSX3("D1_ITEM")[1]) ,NIL})  
						aadd(aLinha,{"D1_COD"  	 	, padr(_cprod,TAMSX3("D1_COD")[1])	,Nil}) 
						aadd(aLinha,{"D1_FORNECE"	,_cForn					,NIL})
						aadd(aLinha,{"D1_LOJA"    	,_cLoja					,NIL})

						//NCM
						If XmlChildEx(oxml:_NFEPROC:_NFE:_INFNFE:_DET[_nI]:_PROD,"_NCM") != NIL
							If _lNcmX
								aadd(aLinha,{"D1_TEC",	oxml:_NFEPROC:_NFE:_INFNFE:_DET[_nI]:_PROD:_NCM:TEXT,Nil})
								If FieldPos("D1_YPOSIPI") > 0 //minera? caraiba
									aadd(aLinha,{"D1_YPOSIPI",	oxml:_NFEPROC:_NFE:_INFNFE:_DET[_nI]:_PROD:_NCM:TEXT,Nil})  
								EndIf
							Endif
						EndIf 


						
						If(_lClassifica)  .or. !_cCpTes=="D1_TES" //TES DE ENTRADA
							If XmlChildEx(oxml:_NFEPROC:_NFE:_INFNFE:_DET[_nI]:_PROD:_INFTRAD,"_XCFOPENTRADA") != nil
								_cTes:= oxml:_NFEPROC:_NFE:_INFNFE:_DET[_nI]:_PROD:_INFTRAD:_XCFOPENTRADA:TEXT
								dbSelectArea("SF4")
								dbSetOrder(1) 
								dbGoTop()
								If LEN(_cTes)==3 .and. SF4->(dbSeek(xFilial("SF4")+_cTes))
									if _lClassifica
										aadd(aLinha,{"D1_TES",_cTes,Nil})//"D1_TES"
									endif 

									if !_cCpTes=="D1_TES"
										_cItem:=aLinha[2,2]
										aadd(_aTesAcl, {_cTes,_cItem})
									endif

								Else
									U_QEXPEVENTO(_cDoc, _cSer, _CNPJ, pTipoDoc, "Codigo TES invalido.", pTpEvERRO, pAlteraY, pSitua4, AllTrim(SM0->M0_CODFIL), _cChave)
									cTexto += "Codigo TES invalido. TES: " + _cTes + CRLF								
									_lImporta:=.F.
									_cTes:=""							  									
								EndIf
							else
								U_QEXPEVENTO(_cDoc, _cSer, _CNPJ, pTipoDoc, "Codigo TES nao informado.", pTpEvERRO, pAlteraY, pSitua4, AllTrim(SM0->M0_CODFIL), _cChave)
								cTexto += "Codigo TES nao informado. TES: " + _cTes + CRLF								
								_lImporta:=.F.	
							endif
						endIf	

						//CC - Centro de Custos 
						//Regra - caso venha centro de custos do QUIRIUS usa, caso contrario pega do pedido de compras.
						If XmlChildEx(oxml:_NFEPROC:_NFE:_INFNFE:_DET[_nI]:_PROD,"_XCENTROCUSTO") != NIL
							_cCCus:=oxml:_NFEPROC:_NFE:_INFNFE:_DET[_nI]:_PROD:_XCENTROCUSTO:TEXT
						EndIf

						//Conta Contabil
						//Regra - caso venha centro de custos do QUIRIUS usa, caso contrario pega do pedido de compras.
						If XmlChildEx(oxml:_NFEPROC:_NFE:_INFNFE:_DET[_nI]:_PROD,"_XCONTCONTAB") != NIL
							_cConta:=oxml:_NFEPROC:_NFE:_INFNFE:_DET[_nI]:_PROD:_XCONTCONTAB:TEXT
						EndIf
									
						//Pedido de compra
						If XmlChildEx(oxml:_NFEPROC:_NFE:_INFNFE:_DET[_nI]:_PROD,"_XPED") != NIL
							cPedido:=StrZero(Val(oxml:_NFEPROC:_NFE:_INFNFE:_DET[_nI]:_PROD:_xPed:TEXT),TAMSX3("D1_PEDIDO")[1])
							cItemPC:=""
							If XmlChildEx(oxml:_NFEPROC:_NFE:_INFNFE:_DET[_nI]:_PROD,"_NITEMPED") != NIL
								cItemPC:=StrZero(Val(oxml:_NFEPROC:_NFE:_INFNFE:_DET[_nI]:_PROD:_nItemPed:TEXT),TAMSX3("D1_ITEMPC")[1])
							else
								U_QEXPEVENTO(_cDoc, _cSer, _CNPJ, pTipoDoc, "Item do Pedido de Compra nao informado!Pedido:" + cPedido, pTpEvERRO, pAlteraY, pSitua4, AllTrim(SM0->M0_CODFIL), _cChave)	
								cTexto += "Item do Pedido de Compra nao informado! Pedido:" + cPedido + CRLF
								_lImporta := .F.
							endif
							
							if !Empty(cItemPC)
								dbSelectArea("SC7")
								SC7->(dbSetOrder(4))
								SC7->(dbGoTop())
								If SC7->(dbSeek(xFilial("SC7")+_cProd+REPLICATE(" ",TAMSX3("C7_PRODUTO")[1] - Len(_cProd)) + cPedido +cItemPC))
									If SC7->C7_CONAPRO == "L" 
										If nQtdTrad > (SC7->C7_QUANT - (SC7->C7_QUJE + C7_QTDACLA))
											U_QEXPEVENTO(_cDoc, _cSer, _CNPJ, pTipoDoc, "Quantidade da Nota maior que o disponivel no Pedido de Compra!Pedido:"+cPedido+" Item:"+ cItemPC, pTpEvERRO, pAlteraY, pSitua4, AllTrim(SM0->M0_CODFIL), _cChave)	
											cTexto += "Quantidade da Nota maior que o disponivel no Pedido de Compra! Pedido:"+cPedido+" Item:"+ cItemPC + CRLF
											_lImporta := .F.
										Else 
											aadd(aLinha,{"D1_PEDIDO",SC7->C7_NUM	,Nil})
											aadd(aLinha,{"D1_ITEMPC",SC7->C7_ITEM	,Nil})
											if Empty(_cCCus)//Caso n?tenha vindo do QUIRIUS pega do pedido de compras
												_cCCus:=SC7->C7_CC
											endif
											if Empty(_cConta)//Caso n?tenha vindo do QUIRIUS pega do pedido de compras
												_cConta:=SC7->C7_CONTA
											endif
											if Empty(_cCondP) .and. _cTipo == "N" .and. !Empty(SC7->C7_COND)
												 _cCondP:=SC7->C7_COND
											endif
										EndIf 
									ELSE 
										U_QEXPEVENTO(_cDoc, _cSer, _CNPJ, pTipoDoc, "Pedido de Compra aguardando aprovacao!Pedido:"+cPedido+" Item:"+ cItemPC, pTpEvERRO, pAlteraY, pSitua4, AllTrim(SM0->M0_CODFIL), _cChave)	
										cTexto += "Pedido de Compra aguardando aprovacao! Pedido:"+cPedido+" Item:"+ cItemPC + CRLF
										_lImporta := .F.										
									Endif
								Else
									//log pedido nao encontrado
									U_QEXPEVENTO(_cDoc, _cSer, _CNPJ, pTipoDoc, "Pedido ou Item de Compra nao encontrado!Pedido:"+cPedido+" Item:"+ cItemPC, pTpEvERRO, pAlteraY, pSitua4, AllTrim(SM0->M0_CODFIL), _cChave)
									cTexto += "Pedido ou Item de Compra nao encontrado! Pedido:"+cPedido+" Item:"+ cItemPC + CRLF
									_lImporta := .F.
								EndIf
							endif
						EndIf

						/* -- Alterado momento do ponto de entrada para o final do preenchimento dos itens
						If (ExistBlock("QPENFECP"))
							//For _nI := 1 TO LEN(oxml:_NFEPROC:_NFE:_INFNFE:_DET)
							aQPENFECP := ExecBlock("QPENFECP",.F.,.F.,{oxml:_NFEPROC:_NFE:_INFNFE:_DET,_nI,aClone(aLinha)})

							If ValType(aQPENFECP) == "A"
								aLinha:=aClone(aQPENFECP)
							EndIf
						EndIf*/

						//Condicao de Pagamento
						If _cTipo == "N"          
							//Cobran?                                                          
							If XmlChildEx(oxml:_NFEPROC:_NFE:_INFNFE,"_COBR") != NIL
								//Condi?o de pagamento
								If XmlChildEx(oxml:_NFEPROC:_NFE:_INFNFE:_COBR,"_XCONDPAGTO") != NIL
									aadd(aCabec,{"F1_COND" ,oxml:_NFEPROC:_NFE:_INFNFE:_COBR:_xCondPagto:TEXT,Nil})
								Elseif !Empty(_cCondP)
									aadd(aCabec,{"F1_COND" ,_cCondP,Nil})
								else
									aAdd(aCabec,{"F1_COND" ,_cCodPg,NIL})
								EndIf                 
							Endif
						EndIf


						//Centro de Custos
						if !Empty(_cCCus)
							aadd(aLinha,{"D1_CC"  , _cCCus 		,Nil})
						endif
						//Conta Contabil
						if !Empty(_cConta)
							aadd(aLinha,{"D1_CONTA"  , _cConta 		,Nil})
						endif
						

						If XmlChildEx(oxml:_NFEPROC:_NFE:_INFNFE:_DET[_nI]:_PROD:_INFTRAD,"_NDEPOSITO") != NIL//<nDeposito>90</nDeposito>
							_cLocal:=oxml:_NFEPROC:_NFE:_INFNFE:_DET[_nI]:_PROD:_INFTRAD:_NDEPOSITO:TEXT
							if !Empty(_cLocal)
								_cLocal:=StrZero(Val(_cLocal),2)
								DbSelectArea("NNR")
								DbSetOrder(1)
								if DbSeek(xFilial("NNR")+_cLocal)
									aadd(aLinha,{"D1_LOCAL"  , _cLocal 		,Nil})
								else
									//log armazem n?encontrado
									U_QEXPEVENTO(_cDoc, _cSer, _CNPJ, pTipoDoc, "Almoxarifado nao encontrado!"+_cLocal+" Item:"+ cItemPC, pTpEvERRO, pAlteraY, pSitua4, AllTrim(SM0->M0_CODFIL), _cChave)
									cTexto += "Almoxarifado nao encontrado!"+_cLocal+" Item:"+ cItemPC + CRLF
									
									_lImporta := .F.
								endif
							endif
						EndIf

						if _lFciIt .and. XmlChildEx(oxml:_NFEPROC:_NFE:_INFNFE:_DET[_nI]:_PROD,"_NFCI") != NIL
							aadd(aLinha,{"D1_FCICOD", Alltrim(oxml:_NFEPROC:_NFE:_INFNFE:_DET[_nI]:_PROD:_NFCI:TEXT),Nil})
						endif
						

						nQtdTrad 	:= VAL(StrTran(oxml:_NFEPROC:_NFE:_INFNFE:_DET[_nI]:_PROD:_INFTRAD:_VQTDECONV:TEXT,",",".")) //,TamSX3("D1_QUANT")[2]) 
						nValorTot 	:= VAL(StrTran(oxml:_NFEPROC:_NFE:_INFNFE:_DET[_nI]:_PROD:_VPROD:TEXT,",","."))	//,TamSX3("D1_TOTAL")[2])	
						_nVlItem:=ROUND(nValorTot/nQtdTrad,TamSX3("D1_VUNIT")[2])
						_nVlIteX	:= VAL(StrTran(oxml:_NFEPROC:_NFE:_INFNFE:_DET[_nI]:_PROD:_vUNCOM:TEXT,",","."))

						if _cTipo$"D/N" .and. !oxml:_NFEPROC:_NFE:_INFNFE:_DET[_nI]:_PROD:_CFOP:TEXT$_cCfoSrv .and.;
							(XmlChildEx(oxml:_NFEPROC:_NFE:_INFNFE:_DET[_nI]:_PROD:_INFTRAD,"_NFREFITEM") != NIL .or. (Len(_aRefCh)>0 ))
							//_nVlItem:=ROUND(nValorTot/nQtdTrad,TamSX3("D1_VUNIT")[2])//ROUND(VAL(StrTran(oxml:_NFEPROC:_NFE:_INFNFE:_DET[_nI]:_PROD:_VUNTRIB:TEXT,",",".")),TamSX3("D1_VUNIT")[2])
							aNewItem := aClone(aLinha) //SALVO OS CAMPOS JA PREENCHIDOS
							_nQtdF:= nQtdTrad

							//NF de referencia - POR ITEM                                             				
							If XmlChildEx(oxml:_NFEPROC:_NFE:_INFNFE:_DET[_nI]:_PROD:_INFTRAD,"_NFREFITEM") != NIL
								If _cTipo == "N" //1=Normal
									_lEntBen:=.T.
								ENDIF
								If(_lTamPad) .AND. cEmpAnt != "99"//verificar tamanho do campo/usa zero a esq
									_NfRef := STRZERO(Val(oxml:_NFEPROC:_NFE:_INFNFE:_DET[_nI]:_PROD:_INFTRAD:_NFrefItem:_refNF:_nnf:TEXT),TAMSX3("D1_NFORI")[1])    
								Else
									_NfRef := PADR(oxml:_NFEPROC:_NFE:_INFNFE:_DET[_nI]:_PROD:_INFTRAD:_NFrefItem:_refNF:_nnf:TEXT	,TAMSX3("D1_NFORI")[1])       
								Endif
								_SerRef:= PADR(oxml:_NFEPROC:_NFE:_INFNFE:_DET[_nI]:_PROD:_INFTRAD:_NFrefItem:_refNF:_serie:TEXT,TAMSX3("D1_SERIORI")[1])      
											
								

								
								dbSelectArea("SD2")      
								SD2->(dbSetOrder(3))
								SD2->(dbGoTop())							
								
								_aRet:=RefNf(_NfRef,_SerRef,_cForn,_cLoja,padr(_cprod,TAMSX3("D2_COD")[1]),nQtdTrad,@aItens,_cTipo,@_IDENTB6,"",_nVlItem)
								_nQtdF:=_aRet[1]
								_aRecD2:=_aRet[2]
								_lRefer:=_aRet[3]

								if nQtdTrad==_nQtdF .and. !_nVlIteX==_nVlItem//se n?localizar usando o valor do item produto da divis?do valor total pela quantidade faz pelo valor comercial unit?o do XML
									_aRet:=RefNf(_NfRef,_SerRef,_cForn,_cLoja,padr(_cprod,TAMSX3("D2_COD")[1]),nQtdTrad,@aItens,_cTipo,@_IDENTB6,"",_nVlIteX)
									_nQtdF:=_aRet[1]
									_aRecD2:=_aRet[2]
									_lRefer:=_aRet[3]

								endif

								If !_lRefer 
									/*cTexto += "NF de referencia nao encontrada! produto: " + _cprod + CRLF		
									cTexto += "Chave de busca: " + xFilial("SD2")+_NfRef+_SerRef+_cForn+_cLoja+padr(_cprod,TAMSX3("D2_COD")[1])	 + CRLF	
									_lImporta := .F.*/
									_cTmpTxt:="NF de referencia nao encontrada! produto: " + _cprod + CRLF
									_cTmpTxt += "Chave de busca: " + xFilial("SD2")+_NfRef+_SerRef+_cForn+_cLoja+padr(_cprod,TAMSX3("D2_COD")[1])	
									cTexto += "Erro:"+_cTmpTxt + CRLF	
									U_QEXPEVENTO("", "", "", pTipoDoc, _cTmpTxt, pTpEvERRO, pAlteraY, pSitua4, AllTrim(SM0->M0_CODFIL), "")	
									_lImporta := .F.
								Endif
							Endif

							if Len(_aRefCh)>0 .and. _nQtdF>0
								for _ich:=1 to len(_aRefCh)
									if _nQtdF<=0 
										_ich:=Len(_aRefCh)
										exit
									endif

									_cTChv:=_aRefCh[_ich]
									_nQtdFold:= _nQtdF
									_aRet:=RefNf(,,,,padr(_cprod,TAMSX3("D2_COD")[1]),_nQtdF,@aItens,_cTipo,@_IDENTB6,_cTChv,_nVlItem)
									_nQtdF:=_aRet[1]
									_aRecD2:=_aRet[2]
									_lRefer:=_aRet[3]

									if _nQtdFold==_nQtdF .and. !_nVlIteX==_nVlItem //se n?localizar usando o valor do item produto da divis?do valor total pela quantidade faz pelo valor comercial unit?o do XML
										_aRet:=RefNf(,,,,padr(_cprod,TAMSX3("D2_COD")[1]),_nQtdF,@aItens,_cTipo,@_IDENTB6,_cTChv,_nVlIteX)
										_nQtdF:=_aRet[1]
										_aRecD2:=_aRet[2]
										_lRefer:=_aRet[3]									
									endif
									
								next _ich
							endif

							if _nQtdF>0
								/*cTexto += "NF de referencia sem saldo total para o item! produto: "+_cprod+" Valor unit?o: "+Alltrim(Str(_nVlItem))+ CRLF		
								if Len(_aRefCh)==0 
									cTexto += "Chave de busca: " + xFilial("SD2")+_NfRef+_SerRef+_cForn+_cLoja+padr(_cprod,TAMSX3("D2_COD")[1])	 + CRLF
								endif
								_lImporta := .F.	*/
								_cTmpTxt:="NF de referencia sem saldo total para o item! produto: "+_cprod+" Valor unit?o: "+Alltrim(Str(_nVlItem))+ CRLF	
								if Len(_aRefCh)==0 
									_cTmpTxt += "Chave de busca: " + xFilial("SD2")+_NfRef+_SerRef+_cForn+_cLoja+padr(_cprod,TAMSX3("D2_COD")[1])
								endif
								cTexto += "Erro:"+_cTmpTxt + CRLF	
								U_QEXPEVENTO("", "", "", pTipoDoc, _cTmpTxt, pTpEvERRO, pAlteraY, pSitua4, AllTrim(SM0->M0_CODFIL), "")	
								_lImporta := .F.
							endif


				
						ELSE //TRATAMENTO NORMAL SEM REFERENCIA					
							aadd(aLinha,{"D1_QUANT"  	, nQtdTrad				,Nil})
							aadd(aLinha,{"D1_VUNIT"     , ROUND(nValorTot/nQtdTrad,TamSX3("D1_VUNIT")[2])	,Nil})//ROUND(VAL(StrTran(oxml:_NFEPROC:_NFE:_INFNFE:_DET[_nI]:_PROD:_VUNTRIB:TEXT,",",".")),TamSX3("D1_VUNIT")[2]) 	,Nil})
							aadd(aLinha,{"D1_TOTAL"   	, nValorTot 			,Nil})		
							
							If XmlChildEx(oxml:_NFEPROC:_NFE:_INFNFE:_DET[_nI]:_PROD,"_VDESC") != NIL
								aadd(aLinha,{"D1_VALDESC" , VAL(StrTran(oxml:_NFEPROC:_NFE:_INFNFE:_DET[_nI]:_PROD:_VDESC:TEXT,",",".")) , Nil})
							Else
								aadd(aLinha,{"D1_VALDESC" , 0 , Nil})
							EndIf

							_cItem:=aLinha[2,2]
							aadd(_IDENTB6, {"",_cItem}) //PARA NAO QUEBRAR A LOGICA QUANDO A NF DE RETORNO TROUXER A MAO DE OBRA
							
							aadd(aItens,aLinha)

						EndIF

						If (ExistBlock("QPENFECP"))
							//For _nI := 1 TO LEN(oxml:_NFEPROC:_NFE:_INFNFE:_DET)
							aQPENFECP := ExecBlock("QPENFECP",.F.,.F.,{oxml:_NFEPROC:_NFE:_INFNFE:_DET,_nI,aClone(aLinha),aCabec})

							If ValType(aQPENFECP) == "A"
								aItens[Len(aItens)]:=aClone(aQPENFECP)//aLinha:=aClone(aQPENFECP)
							EndIf
						EndIf


					Next _nI

					If Len(aItens) > 0 .and. _lImporta
						lMsErroAuto := .F.
						if _lClassifica
							MSExecAuto({|x,y,z,a,b| MATA103(x,y,z,a,b)}, aCabec, aItens, 3,,)
						else
							MSExecAuto({|x,y,z,a,b| MATA140(x,y,z,a,b)}, aCabec, aItens, 3,,)
						endif

						If lMsErroAuto							
							cErro := AllTrim(MemoRead(NomeAutoLog()))    
							
							cTexto += 'Status: Nao importado. Verificar inconsistencias.' + CRLF   
							cTexto += 'Erro: ' + CRLF + cErro
							
							U_QEXPEVENTO(_cDoc, _cSer, _CNPJ, pTipoDoc, "Verificar Inconsistencia: " + StrTran(NoAcento(AnsiToOem(cErro)),"<",""), pTpEvERRO, pAlteraY, pSitua4, AllTrim(SM0->M0_CODFIL), _cChave)
							_lImporta := .F.	
							lMsErroAuto := .F.
						Else
							if !_lClassifica		   
								If Len(_IDENTB6) > 0
									dbSelectArea("SD1")
									DbSetOrder(1) 
									dbGoTop()
									dbSeek(Alltrim(SM0->M0_CODFIL)+_cDoc+_cSer+_cForn+_cLoja)  
									While !SD1->(Eof()) .and. Alltrim(SM0->M0_CODFIL)+_cDoc+_cSer+_cForn+_cLoja==SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)
										_nTPos:= aScan(_IDENTB6,{|x| AllTrim(x[2])==SD1->D1_ITEM})
										if _nTPos>0
											if !Empty(_IDENTB6[_nTPos,1])
												RecLock("SD1", .F.)		
												SD1->D1_IDENTB6 := _IDENTB6[_nTPos,1]
												MsUnLock()
											endif
										endif
										SD1->(dbskip())
									enddo
								EndIf 


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
							endif
							
							
							//log e arquivo de eventos
							_cDescr:= IIF(_lClassifica,'Nota Fiscal Integrada', 'Pre Nota Integrada - Classificar')
							_cSitu:= IIF(_lClassifica,pSitua5,pSitua3)
			   				U_QEXPEVENTO(_cDoc, _cSer, _CNPJ, pTipoDoc, _cDescr, pTpEvInfo, pAlteraN, _cSitu, AllTrim(SM0->M0_CODFIL), _cChave)					
							cTexto += 'Status: ' + _cDescr + CRLF + CRLF
						EndIf
					else
						cTexto += 'Status: Nenhum item adicionado. Verificar inconsistencias.' + CRLF   							
						if _lImporta
							U_QEXPEVENTO(_cDoc, _cSer, _CNPJ, pTipoDoc, "Nenhum item adicionado. Verificar Inconsistencia: " + StrTran(NoAcento(AnsiToOem(cErro)),"<",""), pTpEvERRO, pAlteraY, pSitua4, AllTrim(SM0->M0_CODFIL), _cChave)						
						endif
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
	/*Recover
		_cTmpTxt:= "Inconsistencia na estrutura do arquivo!"
		U_QEXPEVENTO("", "", "", pTipoDoc, _cTmpTxt, pTpEvERRO, pAlteraY, pSitua4, AllTrim(SM0->M0_CODFIL), "")		
		cTexto += "Erro:"+_cTmpTxt + CRLF					
		_lImporta := .F.
		
		cTo := SuperGetMv("QUIRENVL",.F.,"")//Ativa envio de log para 
    	if !Empty(cTo)
			ErrorBlock(bError)
			cSubject := "Erro ao importar XML"
			cCC := ""
			cAttach := cDirNFE+aFiles[_nX][1]
			cMsg:= cError
			StaticCall(GRUPPEFN, GREnvM,, cTo, cCC, cSubject, cMsg, cAttach)//Evnia email
		endif
	END SEQUENCE
	*/
	 
	If _lVldFil .and. !_lRemove
		//tratamento para n?remover arquivos de filiais diferentes
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
		cTexto := "Nao ha arquivos para integracao."
	Endif
	cTexto += "Versao: 05.10.2021" + CRLF + CRLF
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

/*/{Protheus.doc} nomeStaticFunction
	(long_description)
	@type  Static Function
	@author user
	@since 17/02/2020
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/
Static Function funSaldoB6(xEmp,	xFil, cIdentB6)
Local xTab   := "SB6" + xEmp + "0"
Local nRet 	:= 0
Local cQry := "SELECT B6_SALDO FROM "+xTab+ " WHERE B6_FILIAL = '"+xFil+"' AND B6_PODER3='R' AND B6_IDENT='"+cIdentB6+"' AND D_E_L_E_T_ <> '*'"

DBUseArea(.T., "TOPCONN", TCGenQry(NIL,NIL,cQry), ("TBL1") , .F., .T. )

If !TBL1->(Eof())
	nRet := TBL1->B6_SALDO 
endif

TBL1->(dbCloseArea())

Return nRet

/*/{Protheus.doc} nomeStaticFunction
	(long_description)
	@type  Static Function
	@author user
	@since 17/02/2020
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/
Static Function NFCadastrada( xCHVNFE)
Local xQuery := ""
Local lRet   := .F.

If AllTrim(xCHVNFE) != ""    
	xQuery += "SELECT R_E_C_N_O_ "
	xQuery += "FROM "+RetSqlName("SF1")+" F1 "
	//xQuery += "WHERE  F1_FILIAL = '"+xFilial("SF1")+"' "
	xQuery += "WHERE F1_CHVNFE = '"+xCHVNFE+"' "
	xQuery += "AND F1.D_E_L_E_T_ = ' '"
	
	If Select("TRBSF1") > 0
		TRBSF1->(dbCloseArea())
	Endif
	
	xQuery := ChangeQuery(xQuery)
	TCQuery xQuery NEW ALIAS "TRBSF1"
	
	TRBSF1->(dbGotop())
	If !TRBSF1->(Eof())
		SF1->(dbGoto(TRBSF1->R_E_C_N_O_))
		lRet := .T.
	EndIf
	
	If Select("TRBSF1") > 0
		TRBSF1->(dbCloseArea())
	Endif
EndIf
Return(lRet)

/*/{Protheus.doc} RefNf
	(long_description)
	@type  Static Function
	@author user
	@since 17/02/2020
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/
Static Function RefNf(_cNfRef,_cSerRef,_cForn,_cLoja,_cProd,_nQtd,_aItens,_cTipo,_IDENTB6,_cTChv,_nVlItem)
Local _ix:=0
Local _cQuery:=""
Local _cAlias:=""
Local _aRecD2:={}
Local _izx	 :=0
DEFAULT _cNfRef:=""
DEFAULT _cSerRef:=""
DEFAULT _cForn:=""
DEFAULT _cLoja:=""
DEFAULT _cTChv:=""
	
	_cQuery:=" "
	_cQuery+=" Select * from "+RetSqlName("SD2")+" D2 "
	if !Empty(_cTChv)
		_cQuery+=" inner join "+RetSqlName("SF2")+" F2 on (F2_FILIAL=D2_FILIAL and F2_DOC=D2_DOC and F2_SERIE=D2_SERIE "
		_cQuery+=" 	and F2_TIPO=D2_TIPO and F2_CLIENTE=D2_CLIENTE and F2_LOJA=D2_LOJA and F2.D_E_L_E_T_<>'*' ) "
	endif
	_cQuery+=" Where D2_FILIAL='"+xFilial("SD2")+"' "
	_cQuery+=" 		AND D2_COD='"+_cProd+"' "
	_cQuery+=" 		AND D2_PRCVEN= "+Alltrim(STR(_nVlItem))+" "//Valida valor do item para relacionar
	if Empty(_cTChv)
		_cQuery+=" 		AND D2_DOC='"+_cNfRef+"' "
		_cQuery+=" 		AND D2_SERIE='"+_cSerRef+"' "
		_cQuery+=" 		AND D2_CLIENTE='"+_cForn+"' "
		_cQuery+=" 		AND D2_LOJA='"+_cLoja+"' "
		if _cTipo=="D"
			_cQuery+=" 		AND D2_TIPO='N' "
		elseif _cTipo=="N"
			_cQuery+=" 		AND D2_TIPO='B' "
		endif
	else
		_cQuery+=" 		AND F2_CHVNFE='"+_cTChv+"' "
	endif
	
	_cQuery+=" 		and D2.D_E_L_E_T_<>'*' "
	//_cQuery+="      and D2_QUANT-D2_QTDEDEV>0
	//_cQuery+=" Order by D2_QUANT-D2_QTDEDEV DESC

	_cAlias:="TMPNFR"
	//Fecha Alias
	If select(_cAlias) > 0
		dbSelectArea(_cAlias)
		dbCloseArea()
	EndIf

	TcQuery _cQuery New Alias (_cAlias)

	DbSelectArea(_cAlias)
	DbGoTop()
	_aRecs:={}
	_aRecD2:={}
	_lInte:=.T.
	//_nCont:=0
	_nPNfO:=0
	_nPSrO:=0
	_nPItO:=0
	_nPQtd:=0
	_nSaldo:=0
	_nSalB6:=0
	_lRefer:=.F.
	While (!(_cAlias)->(Eof()))
		_lRefer:=.T.
		_nSaldo:=((_cAlias)->D2_QUANT-(_cAlias)->D2_QTDEDEV)

		if _nSaldo<=0 
			(_cAlias)->(DbSkip())
			loop
		endif

		if _lEntBen//Entrada de Beneficiamento (COBRAN?)
			_nSalB6:= funSaldoB6(cEmpAnt, xFilial("SD2"), (_cAlias)->D2_IDENTB6)
			if _nSalB6<=0 
				(_cAlias)->(DbSkip())
				loop
			endif
		endif

		if Len(_aItens)>0//Se j?xistem itens preenchidos
			For _ix:=1 to len(_aItens)
				_nPNfO:=aScan(_aItens[_ix],{|x| Upper(Alltrim(x[1])) == "D1_NFORI"})
				_nPSrO:=aScan(_aItens[_ix],{|x| Upper(Alltrim(x[1])) == "D1_SERIORI"})
				_nPItO:=aScan(_aItens[_ix],{|x| Upper(Alltrim(x[1])) == "D1_ITEMORI"})
				_nPQtd:=aScan(_aItens[_ix],{|x| Upper(Alltrim(x[1])) == "D1_QUANT"})
				if _nPNfO>0 //Item de cobran?de beneficiamento n?passa
					if (_cAlias)->D2_DOC==_aItens[_ix,_nPNfO,2] .and. (_cAlias)->D2_SERIE==_aItens[_ix,_nPSrO,2]
						if (_cAlias)->D2_ITEM==_aItens[_ix,_nPItO,2]
							_nSaldo-=_aItens[_ix,_nPQtd,2]//Diminui quantidade j?nformada em outros itens deste documento
							if _lEntBen//_cTipo=="B"
								_nSalB6-=_aItens[_ix,_nPQtd,2]
							endif
						endif
					endif
				endif
			next _ix
		endif
		
		if _lEntBen
			_nSaldo:= MIN(_nSalB6,_nSaldo)
		endif
		if _nSaldo>0 //.and. _nSalB6>0
			AADD(_aRecs,{_nSaldo,(_cAlias)->R_E_C_N_O_})
		endif		
		(_cAlias)->(DbSkip())
	EndDo

	//Fecha Alias
	If select(_cAlias) > 0
		dbSelectArea(_cAlias)
		dbCloseArea()
	EndIf

	aSort( _aRecs,,, { |x,y| x[1] > y[1] } )
	_lInte:=.T.
	_nQtdF:=_nQtd
	For _ix:=1 to len(_aRecs)
		if _aRecs[_ix,1]>=_nQtd //Caso for maior ou igual atualizo o array com a menor quantidade possivel.
			_aRecD2:={{_aRecs[_ix,2],_nQtd}}
			_nQtdF:=0
		else // Caso o saldo nao de pra compor sozinho quebro em mais itens
			if Len(_aRecD2)==1 .and. _lInte
				_ix:=len(_aRecs)
				Exit
			endif
			if Len(_aRecD2)==0 .and. _lInte
				_lInte:=.F.
			endif
			if !_lInte
				AADD(_aRecD2,{_aRecs[_ix,2],MIN(_aRecs[_ix,1],_nQtdF)})
				_nQtdF-=MIN(_aRecs[_ix,1],_nQtdF)
			endif
		endif
	next _ix



	//ADD nos Itens
	if len(_aRecD2)>0 //Conseguiu encontrar relacionamento para toda a qtd e retornou relacionamentos 
										
		for _izx:=1 to Len(_aRecD2)
			aLinha:=aClone(aNewItem)
			aLinha[2][2] := StrZero(LEN(_aItens)+1,TAMSX3("D1_ITEM")[1])  //ajusta o numero do item

			_nRecTmp:=_aRecD2[_izx,1]
			DbSelectArea("SD2")
			DbGoTo(_nRecTmp)

			_nQtdTmp:= _aRecD2[_izx,2]
	
			aadd(aLinha,{"D1_NFORI"  ,SD2->D2_DOC		,NIL})
			aadd(aLinha,{"D1_SERIORI",SD2->D2_SERIE		,NIL})
			aadd(aLinha,{"D1_ITEMORI",SD2->D2_ITEM 		,NIL})
			if _lEntBen
				aadd(aLinha,{"D1_IDENTB6",SD2->D2_IDENTB6	,NIL})
			endif

			aadd(aLinha,{"D1_QUANT"  , _nQtdTmp	,Nil})
			aadd(aLinha,{"D1_VUNIT"  , _nVlItem	,Nil})
			aadd(aLinha,{"D1_TOTAL"  , _nQtdTmp * _nVlItem  	,Nil})	

			//LOTE deve pegar da Venda ou Remessa
			if !Empty(SD2->D2_LOTECTL)
				aadd(aLinha,{"D1_LOTECTL"  , SD2->D2_LOTECTL 		,Nil})
			endif

			//Controle de SB6 paleativo para atualizar SD1 com esse valor
			_cItem:=aLinha[2,2]
			if _lEntBen
				aadd(_IDENTB6, {SD2->D2_IDENTB6,_cItem})
			else
				aadd(_IDENTB6, {"",_cItem})
			endif
			
			aadd(_aItens,aLinha)			

		next _izx
	endif

Return {_nQtdF,_aRecD2,_lRefer}


/*/{Protheus.doc} nomeStaticFunction
	(long_description)
	@type  Static Function
	@author user
	@since 17/02/2020
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/
Static Function VldChS( xCHVNFE)
Local xQuery := ""
Local lRet   := .F.

If AllTrim(xCHVNFE) != ""    
	xQuery += "SELECT R_E_C_N_O_ "
	xQuery += "FROM "+RetSqlName("SF2")+" F2 "
	xQuery += "WHERE F2_CHVNFE = '"+xCHVNFE+"' "
	xQuery += "AND F2.D_E_L_E_T_ = ' '"
	
	If Select("TRBSF1") > 0
		TRBSF1->(dbCloseArea())
	Endif
	
	xQuery := ChangeQuery(xQuery)
	TCQuery xQuery NEW ALIAS "TRBSF1"
	
	TRBSF1->(dbGotop())
	If !TRBSF1->(Eof())
		DbSelectArea("SF2")
		SF2->(dbGoto(TRBSF1->R_E_C_N_O_))
		lRet := .T.
	EndIf
	
	If Select("TRBSF1") > 0
		TRBSF1->(dbCloseArea())
	Endif
EndIf
Return(lRet)

//################################
//################################
//################################
//Constantes
#Define STR_PULA    Chr(13)+Chr(10)

Static Function MyError( oError )
Local nCont:= 0
	_cError:= Alltrim(oError:Description)

	While !Empty(ProcName(nCont))
        //Escrevendo o número do procname e a descrição
        _cError+= 'ProcName > '+StrZero(nCont, 6)+' - '+ProcName(nCont) + " linha "+cValToChar(ProcLine(nCont))+STR_PULA
        nCont++
    EndDo

	BREAK
Return( _cError )

