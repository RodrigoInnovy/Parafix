#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "fileio.ch"
#INCLUDE "Rwmake.ch"
               
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³QIMPCTE ?Autor ?Mailson Silva	        ?Data ?6/01/2014 ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±?         ³Rotina de integração de CTe DFe-Receiver x Protheus		   ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
/*/

User Function QIMPCTE()
Local oIMPCTE

PRIVATE lMsErroAuto := .F.      

IF ( IsBlind() ) //abre empresa 01
	RpcSetType( 3 )
	PREPARE ENVIRONMENT EMPRESA( "01" ) FILIAL ( "01" ) MODULO ( "SIGACOM" )
	InitPublic()
	SetsDefault()
	SetModulo( "SIGACOM" , "COM" )  
	
	GeraQCTE("01","01")
Else
	@ 200,001 TO 450,500 DIALOG oIMPCTE TITLE "Importacao de CTE"
	@ 020,015 SAY "Este Programa executa a Importacao de XMLs"
	@ 030,015 SAY "para a empresa corrente."
	@ 040,015 SAY ""
	@ 050,015 SAY ""
	@ 070,015 SAY ""
	@ 080,015 SAY ""
	@ 010,010 TO 103,241
   //	@ 105,146 BMPBUTTON TYPE 05  ACTION Pergunte("EXFCAO",.T.) 
	@ 105,176 BMPBUTTON TYPE 01  ACTION (Processa({||GeraQCTE(cEmpAnt,cFilAnt)}),oIMPCTE:End()) 
	@ 105,206 BMPBUTTON TYPE 02  ACTION Close(oIMPCTE)
	ACTIVATE DIALOG oIMPCTE CENTERED
EndIF

Return .T.

/*/{Protheus.doc} nomeStaticFunction
	(long_description)
	@type  Static Function
	@author user
	@since 12/02/2020
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/
Static Function GeraQCTE(_Emp, _Fil)
Local aSM0 := {}
Local aLinha := {}
Local oXML := nil
Local cAviso := ""
Local cErro := ""
Local cFile     := ''
Local cFileLog  := ''
Local cMask     := 'Arquivos Texto (*.TXT)|*.txt|'
Local _lImporta	:= .T.
Local _nX,_nI 	:= 0
Local _CNPJEmit	:= ""
Local _ChaveRef := ""          
Local pTipoDoc := "2"
Local _cCCus    := ""
Local _cConta   := ""

Local pTpEvInfo:= "1"
//Local pTpEvAvis:= "2"
Local pTpEvERRO:= "3"

Local pAlteraY := "1"
Local pAlteraN := "2"

Local pSitua3 := "3"
Local pSitua4 := "4"
Local pSitua5 := "5"
//Local pSitua6 := "6"

Local nTamFilial       := 0
Local _lClassifica 	:=  SuperGetMV('MV_QCLASC',.F.,.F.,PADR(' ',TAMSX3("D1_FILIAL")[1])) 
Local _cCpTes 		:=  Alltrim(UPPER(SuperGetMV('MV_QCPTES',.F.,"D1_TES",PADR(' ',TAMSX3("D1_FILIAL")[1]))))
Local _lZerSer		:=  SuperGetMV('MV_QZSERZ',.F.,.T.,PADR(' ',TAMSX3("D1_FILIAL")[1]))
Local cEstab := ''
Local _cTipo := ''
Local _cTes  := ''
//Local cMark		:= ThisMark()
//Local aArea	:= GetArea()

Local aCabec := {}
Local  aItens := {}

Local _aRtIcm:={}

//declaracao Tratamento de erros
Local _cEnvLog		:= 	SuperGetMv("QUIRENVL",.F.,"") //Ativa envio de log para 
Local bError 
Local oError
Private _cError:= ""
bError := ErrorBlock( { |oError| MyError( oError ) } )
//Fim declaracao de tratamento de erros

Private cTexto    := ""
Private lMsErroAuto := .F.
Private aFiles := {}
Private cDirNFE:=""
Private cDirProc:=""
Private cDirErr:=""
Private _cIcms:=  SuperGetMV('MV_CTEIMC',.F.,"00/20/51/60/80/90",PADR(' ',TAMSX3("D1_FILIAL")[1])) 



Default _Emp := ""
Default _Fil := ""
 
cDirNFE	:= SuperGetMv('MV_QIMPCTE',.F.,'\Receiver\CTE\XMLTraduzidos\')
cDirErr := SuperGetMv('MV_QDERCTE',.F.,'\Receiver\CTE\XMLErroIntegracao\')
cDirProc:= SuperGetMv('MV_QDPRCTE',.F.,'\Receiver\CTE\XMLProcessados\')

If Substr(cDirNFE,len(cDirNFE),1) <> "\"
	cDirNFE+="\"
endif

If Substr(cDirErr,len(cDirErr),1) <> "\"
	cDirErr+="\"
endif

If Substr(cDirProc,len(cDirProc),1) <> "\"
	cDirProc+="\"
endif

aFiles := Directory(cDirNFE+"*.XML")

If Len(aFiles) == 0
	If !IsBlind(); 	MsgAlert("Não ha arquivos para integração."); endif
	Return
EndIf

aSM0 := FWLoadSM0()  

ProcRegua(Len(aFiles))

For _nX:= 1 to Len(aFiles)
	
	IncProc() 	
	
	aCabec := {}
	aItens := {}
	cErro  := ""
	_EmpXML:= ""
	_FilXML:= ""
	lMsErroAuto := .F.
	_lImporta	:= .T.  
	_lRemove := .T.	
	_cTipo := ""
	_cTpCte:= ""
	_cTpFre:= "C"//CIF/FOB
	_cModal:= "01"
	_cTes:=""
	_cSer:=""
	_cDoc:=""

	BEGIN SEQUENCE

	_cNomArq:=cDirNFE+aFiles[_nX][1]

	oXML := XmlParserFile(_cNomArq,"_",@cAviso,@cErro)  
	
	//If  ValType(oXML) <> "U"
	If XmlChildEx(oXML,"_CTEPROC")== nil //ValType(oXML:_NFEPROC) == "U" //
		_cTmpTxt:= "Inconsistencia na estrutura do arquivo!,Não foi possivel ler o XML!"+_cNomArq
		U_QEXPEVENTO("", "", "", pTipoDoc, _cTmpTxt, pTpEvERRO, pAlteraY, pSitua4, AllTrim(SM0->M0_CODFIL), "")		
		cTexto += "Erro:"+_cTmpTxt + CRLF					
		_lImporta := .F.
	else
		
		//TIPO DO CTE
		If XmlChildEx(oXML:_CTEPROC:_CTE:_INFCTE,"_INFCTENORM") <> nil
			_cTpCte:= "N"
		elseif XmlChildEx(oXML:_CTEPROC:_CTE:_INFCTE,"_INFCTECOMP") <> nil
			_cTpCte:= "C"
		endif

		//Modalidade do frete //Rodoviario/Ferroviario etc
		If XmlChildEx(oXML:_CTEPROC:_CTE:_INFCTE:_IDE,"_MODAL") <> nil
			_cModal:=StrZero(Val(oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_MODAL:TEXT),2)
		endif

		//Verificar empresa 
		If XmlChildEx(oXML:_CTEPROC:_CTE:_INFCTE:_IDE,"_TOMA03") <> nil    
			If oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_TOMA03:_TOMA:TEXT == '0'              // Remetente
				cEstab := RetFilial( oXML:_CTEPROC:_CTE:_INFCTE:_REM:_CNPJ:TEXT )   
				 
				If Empty(cEstab)
					U_QEXPEVENTO(_cDoc, _cSer, _CNPJEmit, pTipoDoc, "Verificar Inconsistencia: Cod Filial nao esta no XML!", pTpEvERRO, pAlteraY, pSitua4, AllTrim(SM0->M0_CODFIL), _cChave)	
					cTexto += "Erro: Verificar Inconsistencia: Cod Filial nao esta no XML!" + CRLF			
					_lImporta := .F.
				Else
					_FilXML := cEstab      
					_cTipo := "S" 
				EndIf
	
			ElseIf oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_TOMA03:_TOMA:TEXT == '1'          // Expedidor
		
				cEstab := RetFilial( oXML:_CTEPROC:_CTE:_INFCTE:_EXPED:_CNPJ:TEXT )  
				
				If Empty(cEstab)
					U_QEXPEVENTO(_cDoc, _cSer, _CNPJEmit, pTipoDoc, "Verificar Inconsistencia: Cod Filial nao esta no XML!", pTpEvERRO, pAlteraY, pSitua4, AllTrim(SM0->M0_CODFIL), _cChave)	
					cTexto += "Erro: Verificar Inconsistencia: Cod Filial nao esta no XML!" + CRLF			
					_lImporta := .F.
				Else
					_FilXML := cEstab 
					_cTipo := "E" 
				EndIf
	
			ElseIf oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_TOMA03:_TOMA:TEXT == '2'          // Recebedor
		
				cEstab := RetFilial( oXML:_CTEPROC:_CTE:_INFCTE:_RECEB:_CNPJ:TEXT )  
		
				If Empty(cEstab)
					U_QEXPEVENTO(_cDoc, _cSer, _CNPJEmit, pTipoDoc, "Verificar Inconsistencia: Cod Filial nao esta no XML!", pTpEvERRO, pAlteraY, pSitua4, AllTrim(SM0->M0_CODFIL), _cChave)	
					cTexto += "Erro: Verificar Inconsistencia: Cod Filial nao esta no XML!" + CRLF			
					_lImporta := .F.
				Else
					_FilXML := cEstab
					_cTipo := "E" 
				EndIf
	
			ElseIf oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_TOMA03:_TOMA:TEXT == '3' 			// Destinatario
				_cTpFre:="F"

				cEstab := RetFilial( oXML:_CTEPROC:_CTE:_INFCTE:_DEST:_CNPJ:TEXT )   
		
				If Empty(cEstab)
					U_QEXPEVENTO(_cDoc, _cSer, _CNPJEmit, pTipoDoc, "Verificar Inconsistencia: Cod Filial nao esta no XML!", pTpEvERRO, pAlteraY, pSitua4, AllTrim(SM0->M0_CODFIL), _cChave)	
					cTexto += "Erro: Verificar Inconsistencia: Cod Filial nao esta no XML!" + CRLF			
					_lImporta := .F.
				Else
					_FilXML := cEstab  
					_cTipo := "E"
				EndIf
				//alteração para considerar como saida quando tomador=destinatario (MCSA)
				if !XmlChildEx(oXML:_CTEPROC:_CTE:_INFCTE,"_INFCTECOMP") <> nil .AND. !XmlChildEx(oXML:_CTEPROC:_CTE:_INFCTE:_REM,"_INFNF") <> nil 
					If XmlChildEx(oXML:_CTEPROC:_CTE:_INFCTE,"_INFCTENORM") <> nil
						if !XmlChildEx(oXML:_CTEPROC:_CTE:_INFCTE:_INFCTENORM,"_INFDOC") <> nil //Não tem essa Tag
							_cTipo := "S"
						else
							If !ValType(oXML:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE) == "A"
								XmlNode2Arr(oXML:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE, "_INFNFE" )
							EndIf 
							if LEN(oXML:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE)>0	
								_ChaveRef := AllTrim(oXML:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE[1]:_CHAVE:TEXT)
								If NFReferencia(1, _ChaveRef, nil)  
									if SF1->F1_TIPO=="D"
										_cTipo := "S"
									endif
								EndIf
							endif
						EndIf
					else
						_cTipo := "S"
					endif
				endif
			ElseIf oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_TOMA03:_TOMA:TEXT == '4' 			// Destinatario
		
				cEstab := oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_TOMA03:_INFTRAD:_XCODTOMADOR:TEXT    
		
				If Empty(cEstab)
					U_QEXPEVENTO(_cDoc, _cSer, _CNPJEmit, pTipoDoc, "Verificar Inconsistencia: Cod Filial nao esta no XML!", pTpEvERRO, pAlteraY, pSitua4, AllTrim(SM0->M0_CODFIL), _cChave)	
					cTexto += "Erro: Verificar Inconsistencia: Cod Filial nao esta no XML!" + CRLF			
					_lImporta := .F.
				Else
					_FilXML := cEstab  
					_cTipo := "E"
				EndIf				
			ENDIF
		Else  //Outros
			If XmlChildEx(oXML:_CTEPROC:_CTE:_INFCTE:_IDE,"_TOMA4") <> nil   
				cEstab := RetFilial(  oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_TOMA4:_CNPJ:TEXT )  
		
				If Empty(cEstab)
					U_QEXPEVENTO(_cDoc, _cSer, _CNPJEmit, pTipoDoc, "Verificar Inconsistencia: Cod Filial nao esta no XML!", pTpEvERRO, pAlteraY, pSitua4, AllTrim(SM0->M0_CODFIL), _cChave)	
					cTexto += "Erro: Verificar Inconsistencia: Cod Filial nao esta no XML!" + CRLF			
					_lImporta := .F.
				Else
					_FilXML := cEstab 
					_cTipo := "S"
				EndIf              
			else
				U_QEXPEVENTO(_cDoc, _cSer, _CNPJEmit, pTipoDoc, "Verificar Inconsistencia: Tomador nao informado!", pTpEvERRO, pAlteraY, pSitua4, AllTrim(SM0->M0_CODFIL), _cChave)	
				cTexto += "Erro: Verificar Inconsistencia: Tomador nao informado!" + CRLF			
				_lImporta := .F.
			EndIF		
		EndIf	
		
		If _lImporta 	                  
			If(SuperGetMV('MV_QNFEPAD',.F.,.T.,PADR(' ',TAMSX3("D1_FILIAL")[1]))==.T.) //verificar tamanho do campo/usa zero a esq		
				_cDoc 		:= STRZERO(Val(oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_NCT:TEXT),tamsx3("F1_DOC")[1],0) 			
				_cSer:=Alltrim(oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_SERIE:TEXT)
				If VAL(_cSer) > 0 .or. (_lZerSer .and. (_cSer=="0" .or. _cSer=="00" .or. _cSer=="000"))
					_cSer 	:= STRZERO(Val(_cSer),tamsx3("F1_SERIE")[1],0) 
				endif	                                                  
			Else                                                                                                                                        
				_cDoc 	:= oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_NCT:TEXT			
				_cSer 	:= oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_SERIE:TEXT                                          		
			Endif                                                           			
			_cChave 	:= AllTrim(SUBSTR(oXML:_CTEPROC:_CTE:_INFCTE:_ID:TEXT,4,LEN(oXML:_CTEPROC:_CTE:_INFCTE:_ID:TEXT)))
			_CNPJEmit 	:= AllTrim(oXML:_CTEPROC:_CTE:_INFCTE:_EMIT:_CNPJ:TEXT)
			_cUF 		:= oXML:_CTEPROC:_CTE:_INFCTE:_EMIT:_ENDEREMIT:_UF:TEXT
			cUFOri		:= Alltrim(oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_UFINI:TEXT)	

			If(_lClassifica) .or. !_cCpTes=="D1_TES" //TES DE ENTRADA
				If XmlChildEx(oXML:_CTEPROC:_CTE:_INFCTE:_IDE,"_CFOP") <> nil
					_cTes:= oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_CFOP:TEXT
					dbSelectArea("SF4")
					dbSetOrder(1) 
					dbGoTop()
					If LEN(_cTes)==3 .and. SF4->(dbSeek(xFilial("SF4")+_cTes))
						_cTes:=_cTes
					Else
						U_QEXPEVENTO(_cDoc, _cSer, _CNPJEmit, pTipoDoc, "Codigo TES invalido.", pTpEvERRO, pAlteraY, pSitua4, AllTrim(SM0->M0_CODFIL), _cChave)
						cTexto += "Codigo TES invalido. TES: " + _cTes + CRLF								
						_lImporta:=.F.
						_cTes:=""							  									
					EndIf
				else
					U_QEXPEVENTO(_cDoc, _cSer, _CNPJEmit, pTipoDoc, "Codigo TES nao informado.", pTpEvERRO, pAlteraY, pSitua4, AllTrim(SM0->M0_CODFIL), _cChave)
					cTexto += "Codigo TES nao informado. TES: " + _cTes + CRLF								
					_lImporta:=.F.	
				endif
			endIf

			If XmlChildEx(oXML:_CTEPROC:_CTE:_INFCTE:_IDE,"_DEMI") <> nil  
				_dData:= StoD(Substr(oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_DEMI:TEXT,1,4) + Substr(oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_DEMI:TEXT,6,2) + Substr(oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_DEMI:TEXT,9,2))
			elseif XmlChildEx(oXML:_CTEPROC:_CTE:_INFCTE:_IDE,"_DHEMI") <> nil  
				_dData:= StoD(Substr(oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_DHEMI:TEXT,1,4) + Substr(oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_DHEMI:TEXT,6,2) + Substr(oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_DHEMI:TEXT,9,2))
			ELSE
				U_QEXPEVENTO(_cDoc, _cSer, _CNPJ, pTipoDoc, "Data de emissao nao informada", pTpEvERRO, pAlteraY, pSitua4,AllTrim(SM0->M0_CODFIL), _cChave)
				cTexto += 'Data de emissao nao informada' + CRLF 
				_lImporta := .F.
			endif			

			cTexto += Replicate( '-', 128 ) + CRLF
			cTexto += 'Empresa : ' + SM0->M0_CODIGO + '/' + SM0->M0_NOME + CRLF + CRLF			
			cTexto += 'CTE/Serie: ' + _cDoc + "/" + _cSer + CRLF			
			cTexto += 'Data de Emissão: ' +DtoC(_dData) + CRLF
			cTexto += 'Data de Digitação: ' + DtoC(Date()) + CRLF
			                                        
		 	dbSelectArea("SA2")
			SA2->(dbSetOrder(3))
			dbGoTop()
			If SA2->(dbSeek(xFilial("SA2")+_CNPJEmit))
				_cForn := SA2->A2_COD
				_cLoja := SA2->A2_LOJA
				_cNaturez := SA2->A2_NATUREZ

				cTexto += 'Fornecedor: ' + SA2->A2_COD + '/' + SA2->A2_LOJA + ALLTRIM(SA2->A2_NOME) + CRLF
								                   
				if(_cTipo == "E") .AND. ALLTRIM(_cNaturez)==""  
					U_QEXPEVENTO(_cDoc, _cSer, _CNPJEmit, pTipoDoc, 'Fornecedor sem Natureza informada. CNPJ: ' + TransForm(_CNPJEmit,"@R 99.999.999/9999-99"), pTpEvERRO, pAlteraY, pSitua4, AllTrim(SM0->M0_CODFIL), _cChave)
					cTexto += 'Fornecedor sem Natureza informada. CNPJ: ' + TransForm(_CNPJEmit,"@R 99.999.999/9999-99") + CRLF
					_lImporta := .F.				
				EndIf
			Else
				U_QEXPEVENTO(_cDoc, _cSer, _CNPJEmit, pTipoDoc, 'Fornecedor nao encontrado. CNPJ: ' + TransForm(_CNPJEmit,"@R 99.999.999/9999-99"), pTpEvERRO, pAlteraY, pSitua4, AllTrim(SM0->M0_CODFIL), _cChave)
				cTexto += 'Fornecedor não encontrado. CNPJ: ' + TransForm(_CNPJEmit,"@R 99.999.999/9999-99") + CRLF
				_lImporta := .F.
			Endif     
			 
   			If NFCadastrada(AllTrim(_cChave))
				U_QEXPEVENTO(_cDoc, _cSer, _CNPJEmit, pTipoDoc, "Status: Nao importado. CTE ja existente no Protheus", pTpEvERRO, pAlteraY, pSitua4, AllTrim(SM0->M0_CODFIL), _cChave)					
				cTexto += 'Status: Não importado. CTE ja existente no Protheus.' + CRLF + CRLF
				_lImporta := .F.
			EndIf											       
			 
			//verifica se deve importar apenas para a filial logada       
			If SuperGetMV('MV_QFILIAL',.F.,.T.,PADR(' ',TAMSX3("D1_FILIAL")[1])) 
				If _FilXML <> cFilAnt  			
					_lImporta := .F.					
					_lRemove := .F.
					cTexto += "Aviso: Arquivo nao importado, Filial do XML difere da filial logada!" + CRLF
				Endif
			Else				
				cFilAnt := _FilXML
			Endif	              	
			
			If _lImporta				     
				
				If _cTipo<>"S" //CTE de entrada + CTR (quando tomador for diferente da filial da nf de referencia) //If _cTipo=="E" //CTE de entrada 
					if XmlChildEx(oXML:_CTEPROC:_CTE:_INFCTE,"_INFCTECOMP") <> nil //CTE COMPLEMENTAR 21-05-2019
						_ChaveRef := AllTrim(oXML:_CTEPROC:_CTE:_INFCTE:_INFCTECOMP:_CHCTE:TEXT)
						If NFReferencia(1, _ChaveRef, nil)  
							nTamFilial  := Len(xFilial("SF1"))       
							aadd(aItens,{{"PRIMARYKEY",AllTrim(SubStr(&(IndexKey()),nTamFilial + 1))}}) //Tratamento para Gestao Empresas
						else
							U_QEXPEVENTO(_cDoc, _cSer, _CNPJEmit, pTipoDoc, "Status: Nao importado. CTE de Referencia n?o encontrado.", pTpEvERRO, pAlteraY, pSitua4, AllTrim(SM0->M0_CODFIL), _cChave)					
							cTexto += 'Status: Nao importado.  CTE de Referencia n?o encontrado.' + CRLF + CRLF
							_lImporta := .F.							
						endif										   		    
					elseif XmlChildEx(oXML:_CTEPROC:_CTE:_INFCTE:_REM,"_INFNF") <> nil  	
						If !ValType(oXML:_CTEPROC:_CTE:_INFCTE:_REM:_INFNF) == "A"
							XmlNode2Arr(oXML:_CTEPROC:_CTE:_INFCTE:_REM:_INFNF, "_INFNF" )
						EndIf 
						For _nI := 1 TO LEN(oXML:_CTEPROC:_CTE:_INFCTE:_REM:_INFNF)						
							//If XmlChildEx(oXML:_CTEPROC:_CTE:_INFCTE:_REM:_INFNF[_nI],"_NDOC") <> nil   
								_nDocRef := STRZERO(Val(oXML:_CTEPROC:_CTE:_INFCTE:_REM:_INFNF[_nI]:_NDOC:TEXT)  ,tamsx3("F1_DOC")[1],0) 
								_nSerRef := STRZERO(Val(oXML:_CTEPROC:_CTE:_INFCTE:_REM:_INFNF[_nI]:_SERIE:TEXT ),tamsx3("F1_SERIE")[1],0)  								

								If NFReferencia(2, _nDocRef, _nSerRef)         
									nTamFilial  := Len(xFilial("SF1"))       
									aadd(aItens,{{"PRIMARYKEY",AllTrim(SubStr(&(IndexKey()),nTamFilial + 1))}}) //Tratamento para Gestao Empresas
								else
									U_QEXPEVENTO(_cDoc, _cSer, _CNPJEmit, pTipoDoc, "Status: Nao importado. CTE de Referencia nao encontrado.", pTpEvERRO, pAlteraY, pSitua4, AllTrim(SM0->M0_CODFIL), _cChave)					
									cTexto += 'Status: Nao importado.  NF de Referencia nao encontrada: ' + _nDocRef + "-" + _nSerRef + CRLF + CRLF
									_lImporta := .F.								
								EndIf							 
							//Endif
						Next _nI
					elseif XmlChildEx(oXML:_CTEPROC:_CTE:_INFCTE,"_INFCTENORM") <> nil
						if XmlChildEx(oXML:_CTEPROC:_CTE:_INFCTE:_INFCTENORM,"_INFDOC") <> nil
							If !ValType(oXML:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE) == "A"
								XmlNode2Arr(oXML:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE, "_INFNFE" )
							EndIf    
							_nRefRecno:=0
							For _nI := 1 TO LEN(oXML:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE)	
								_ChaveRef := AllTrim(oXML:_CTEPROC:_CTE:_INFCTE:_INFCTENORM:_INFDOC:_INFNFE[_nI]:_CHAVE:TEXT)

								If NFReferencia(1, _ChaveRef, nil)  
									nTamFilial  := Len(xFilial("SF1"))       
									aadd(aItens,{{"PRIMARYKEY",AllTrim(SubStr(&(IndexKey()),nTamFilial + 1))}}) //Tratamento para Gestao Empresas
								EndIf
							Next _nI
						endif					
					Endif
					If _lImporta
						aadd(aCabec,{"",dDataBase-360                                                    }) //1 data de
						aadd(aCabec,{"",dDataBase                                                       }) //2 data ate
						aadd(aCabec,{"",2                                                               }) //3 Rotina (1=Exclusao,2=Inclusao)
						aadd(aCabec,{"",SF1->F1_FORNECE                           						}) //4 Fornecedor Origem
						aadd(aCabec,{"",SF1->F1_LOJA  													}) //5 Loja Origem
						aadd(aCabec,{"",IIF(SF1->F1_TIPO=="D",2,1)                                		}) //6 Tipo Origem - Usa Fornecedor (1) ou Cliente (2)
						aadd(aCabec,{"",2                                                               }) //7 Aglutina produtos (1=Sim,2=Nao)
						aadd(aCabec,{"F1_EST",cUFOri													}) //8 Uf de Origem								
						aadd(aCabec,{"",VAL(oXML:_CTEPROC:_CTE:_INFCTE:_VPREST:_VTPREST:TEXT)           }) //9 Valor
						aadd(aCabec,{"F1_FORMUL",1                                                      }) //10 Formulario 1=Proprio,2=Nao
						aadd(aCabec,{"F1_DOC",_cDoc                   									}) //11Numero do Conecimento
						aadd(aCabec,{"F1_SERIE",_cSer          											}) //12Serie do Conhecimento
						aadd(aCabec,{"F1_FORNECE",SA2->A2_COD                                    		}) //13Fornecedor
						aadd(aCabec,{"F1_LOJA",SA2->A2_LOJA                                        		}) //14Loja 


						If(_lClassifica) //TES DE ENTRADA
							aadd(aCabec,{"",_cTes}) //15Tes 
						else
							aadd(aCabec,{"","001"}) //15Tes  
						endIf

						_aRtIcm:={}
						_aRtIcm:=VldIcms(oXML)
						aadd(aCabec,{"F1_BASEICM",_aRtIcm[1] })
						aadd(aCabec,{"F1_VALICM" ,_aRtIcm[2] })
						               
						/*
						If XmlChildEx(oXML:_CTEPROC:_CTE:_INFCTE:_IMP,"_ICMS") <> nil 
							If XmlChildEx(oXML:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS,"_ICMS00") <> nil 
								aadd(aCabec,{"F1_BASERET",VAL(oXML:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_VBC:TEXT)})             //16
								aadd(aCabec,{"F1_ICMRET" ,VAL(oXML:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_VICMS:TEXT)})           //17
							elseif XmlChildEx(oXML:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS,"_ICMS20") <> nil 
								aadd(aCabec,{"F1_BASERET",VAL(oXML:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMS20:_VBC:TEXT)})
								aadd(aCabec,{"F1_ICMRET" ,VAL(oXML:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMS20:_VICMS:TEXT)})
							elseif XmlChildEx(oXML:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS,"_ICMS51") <> nil 
								aadd(aCabec,{"F1_BASERET",VAL(oXML:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMS51:_VBC:TEXT)})
								aadd(aCabec,{"F1_ICMRET" ,VAL(oXML:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMS51:_VICMS:TEXT)})							
							elseIf XmlChildEx(oXML:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS,"_ICMS60") <> nil ; 
								.and. XmlChildEx(oXML:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMS60,"_VBCSTRRET") <> nil ;
							 	.and. XmlChildEx(oXML:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMS60,"_VICMSSTRET") <> nil 
								aadd(aCabec,{"F1_BASERET",VAL(oXML:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMS60:_VBCSTRRET:TEXT) })
								aadd(aCabec,{"F1_ICMRET" ,VAL(oXML:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMS60:_VICMSSTRET:TEXT)})
							elseIf XmlChildEx(oXML:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS,"_ICMS80") <> nil 
								aadd(aCabec,{"F1_BASERET",VAL(oXML:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMS80:_VBC:TEXT) })
								aadd(aCabec,{"F1_ICMRET" ,VAL(oXML:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMS80:_VICMS:TEXT)})							
							elseIf XmlChildEx(oXML:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS,"_ICMS90") <> nil 
								aadd(aCabec,{"F1_BASERET",VAL(oXML:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMS90:_VBC:TEXT)  })
								aadd(aCabec,{"F1_ICMRET" ,VAL(oXML:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMS90:_VICMS:TEXT)})
							else                                                                                                
								aadd(aCabec,{"F1_BASERET",0 })
								aadd(aCabec,{"F1_ICMRET" ,0 })
							EndIF
						else                                                                                                
							aadd(aCabec,{"F1_BASERET",0 })
							aadd(aCabec,{"F1_ICMRET" ,0 })
						EndIf
						*/	

							If XmlChildEx(oXML:_CTEPROC:_CTE:_INFCTE,"_COBR") <> nil
								_cCndPag := AllTrim(oXML:_CTEPROC:_CTE:_INFCTE:_COBR:_XCONDPAGTO:TEXT)
								If !Empty(_cCndPag)
									aadd(aCabec,{"F1_COND",_cCndPag				}) 
								ElseIf Empty(_cCndPag) .And. !Empty(_cCndPar)
									aadd(aCabec,{"F1_COND",_cCndPar				}) 
								ElseIf 	Empty(_cCndPag) .And. Empty(_cCndPar)
									aadd(aCabec,{"F1_COND",Posicione("SA2",1,xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,"A2_COND") 		}) 
								EndIf
							EndIf
						//aadd(aCabec,{"F1_COND",SuperGetMv("MQ_CPCTE" ,.F.,"001")						}) //18 Condicao de Pgto
						aadd(aCabec,{"F1_EMISSAO",_dData                                      			}) //19 Emissao
						aadd(aCabec,{"F1_ESPECIE","CTE"                                                	}) //20 Especie 
						aadd(aCabec,{"F1_TIPO","C"                                                		}) //Tipo

						aadd(aCabec,{"F1_NATUREZ",_cNaturez                                             }) //Natureza                                   				    
						If SuperGetMv('MV_QCHVCTE',.F.,.T.,PADR(' ',TAMSX3("D1_FILIAL")[1]))
							aadd(aCabec,{"F1_CHVNFE" ,_cChave												})
						endif
						aadd(acabec,{"F1_DESPESA",0														})         
						aadd(acabec,{"F1_DESCONT",0														})                                                                                                       
						//aadd(aCabec,{"F1_TIPO","C"                                                		}) //Tipo 
						aadd(aCabec,{"F1_TPFRETE",_cTpFre												})            
						aadd(aCabec,{"F1_TPCOMPL","3"                                                	}) //Tipo													        
						aadd(aCabec,{"F1_TPCTE" ,_cTpCte												})
						aadd(aCabec,{"F1_STATUS" , IIF(_lClassifica,"A","")								})	
						aadd(aCabec,{"F1_MODAL" , _cModal												})	  
						//UF&MUN ORIGEM
						dbSelectArea("CC2")
						dbSetOrder(3)
						dbGoTop()
						If dbSeek(xFilial("CC2")+SUBSTR(oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_CMUNINI:TEXT,3,5))    
							_cUfOri := oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_UFINI:TEXT
							_cMunOri:= CC2->CC2_CODMUN
							
							aadd(aCabec,{"F1_UFORITR", oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_UFINI:TEXT  	}) 	
							aadd(aCabec,{"F1_MUORITR", CC2->CC2_CODMUN 									}) 									        
						Endif 
						//UF&MUN DESTINO
						dbSelectArea("CC2")
						dbSetOrder(3)    
						dbGoTop()
						If dbSeek(xFilial("CC2")+SUBSTR(oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_CMUNFIM:TEXT,3,5))   
							_cUfDes := oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_UFFIM:TEXT 
							_cMunDes:= CC2->CC2_CODMUN
						
							aadd(aCabec,{"F1_UFDESTR", oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_UFFIM:TEXT 		}) 	
							aadd(aCabec,{"F1_MUDESTR", CC2->CC2_CODMUN 									}) 									        
						Endif	                                   
						If Len(aItens)>0 															
							lMsErroAuto := .F.

							//l103Class:=.F.								
							//Documento de entrada										
							_lret:= MATA116(aCabec,aItens,,!_lClassifica) //MATA116(xAutoCab,xAutoItens,lAutoGFE,lPreNota,aRatcc)//MATA116(aCabec,aItens)
									
							If lMsErroAuto .or. !_lret						
								cErro := IIF(lMsErroAuto,AllTrim(MemoRead(NomeAutoLog())),"")
								cTexto += 'Status: Não importado. Verificar inconsistências.' + CRLF
								cTexto += 'Erro: ' + CRLF + cErro

								U_QEXPEVENTO(_cDoc, _cSer, _CNPJEmit, pTipoDoc, "Verificar Inconsistencia: " + StrTran(NoAcento(AnsiToOem(cErro)),"<",""), pTpEvERRO, pAlteraY, pSitua4, AllTrim(SM0->M0_CODFIL), _cChave)
								_lImporta := .F.
								
							Else    
								dbSelectArea("SF1")
								dbSetOrder(1) 
								dbGoTop()
								If dbSeek(ALLTRIM(_FilXML)+_cDoc+_cSer+_cForn+_cLoja)  							  	
									RecLock("SF1", .F.)		
									If SuperGetMv('MV_QCHVCTE',.F.,.T.,PADR(' ',TAMSX3("D1_FILIAL")[1]))
										SF1->F1_CHVNFE := _cChave	
									endif
									SF1->F1_MODAL  := _cModal//"01"         
									SF1->F1_TPCTE  := _cTpCte//"N"
									SF1->F1_TPFRETE:= _cTpFre
									SF1->F1_UFORITR := _cUfOri 
									SF1->F1_MUORITR := _cMunOri
									SF1->F1_UFDESTR := _cUfDes
									SF1->F1_MUDESTR := _cMunDes
						
									MsUnLock()     
								EndIf

								If !_cCpTes=="D1_TES" .and. !Empty(_cTes)
									dbSelectArea("SD1")
									DbSetOrder(1) 
									dbGoTop()
									dbSeek(Alltrim(SM0->M0_CODFIL)+_cDoc+_cSer+_cForn+_cLoja)  
									While !SD1->(Eof()) .and. Alltrim(SM0->M0_CODFIL)+_cDoc+_cSer+_cForn+_cLoja==SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)
										RecLock("SD1", .F.)		
										_cTmp:="SD1->"+_cCpTes+":= _cTes"
										&(_cTmp)
										MsUnLock()
										SD1->(dbskip())
									enddo
								EndIf  

								
								U_QEXPEVENTO(_cDoc, _cSer, _CNPJEmit, pTipoDoc, 'CTE incluido com sucesso.', pTpEvInfo, pAlteraN, pSitua3, AllTrim(SM0->M0_CODFIL), _cChave)
								cTexto += 'CTE incluido com sucesso.' + CRLF + CRLF									
								//cTexto += 'chave: '+_FilXML+_cDoc+_cSer+_cForn+_cLoja+ CRLF + CRLF									
							EndIf
						Else
							U_QEXPEVENTO(_cDoc, _cSer, _CNPJEmit, pTipoDoc, "Sem NF de amarracao para os Itens!" , pTpEvERRO, pAlteraY, pSitua4, AllTrim(SM0->M0_CODFIL), _cChave)
							cTexto += "Sem NF de amarracao para os Itens!"+ CRLF
							_lImporta := .F.
						EndIf
					EndIf
				Else //SAIDA 
					If XmlChildEx(oxml:_CTEPROC:_CTE:_INFCTE,"_INFITEM") == nil 		
						U_QEXPEVENTO(_cDoc, _cSer,  AllTrim(oXML:_CTEPROC:_CTE:_INFCTE:_EMIT:_CNPJ:TEXT), pTipoDoc, "Verificar Inconsistencia: Tag <INFITEM> nao consta no XML!", pTpEvERRO, pAlteraY, pSitua4, AllTrim(SM0->M0_CODFIL), "")		
						
						cTexto += "Erro: Verificar Inconsistencia: Tag <INFITEM> nao consta no XML:" + CRLF			
						cTexto += '    CTE/Serie: ' + _cDoc + "/" + _cSer + CRLF
						
						_lImporta := .F.		
					Else							
						DbSelectArea("SF1")
						SF1->(DBSetOrder(1))
						If !SF1->(dbSeek(_FilXML+_cDoc+_cSer+_cForn+_cLoja))				     
							aadd(aCabec,{"F1_TIPO"   , "N", Nil})
							aadd(aCabec,{"F1_FORMUL" , "N", Nil})
							aadd(aCabec,{"F1_DOC"    , _cDoc, Nil})
							aadd(aCabec,{"F1_SERIE"  , _cSer, Nil})
							aadd(aCabec,{"F1_EMISSAO", _dData, Nil})
							aadd(aCabec,{"F1_DESPESA", 0, Nil})
							aadd(aCabec,{"F1_FORNECE", _cForn, Nil})
							aadd(aCabec,{"F1_LOJA"   , _cLoja, Nil})
							//aadd(aCabec,{"F1_EST"	 ,_cUF, Nil})
							aadd(aCabec,{"F1_ESPECIE", "CTE", Nil})  
							aAdd(aCabec,{"F1_TES"	 , '', NIL}) 
							aadd(aCabec,{"F1_BASERET",0 })
							aadd(aCabec,{"F1_ICMRET" ,0 })   
							
							_aRtIcm:={}
							_aRtIcm:=VldIcms(oXML)
							aadd(aCabec,{"F1_BASEICM",_aRtIcm[1] })
							aadd(aCabec,{"F1_VALICM" ,_aRtIcm[2] })
							/*
							If XmlChildEx(oXML:_CTEPROC:_CTE:_INFCTE:_IMP,"_ICMS") <> nil 
								If XmlChildEx(oXML:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS,"_ICMS00") <> nil 
									aadd(aCabec,{"F1_BASEICM",VAL(oXML:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_VBC:TEXT)})
									aadd(aCabec,{"F1_VALICM" ,VAL(oXML:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMS00:_VICMS:TEXT)})
								elseif XmlChildEx(oXML:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS,"_ICMS20") <> nil 
									aadd(aCabec,{"F1_BASEICM",VAL(oXML:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMS20:_VBC:TEXT)})
									aadd(aCabec,{"F1_VALICM" ,VAL(oXML:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMS20:_VICMS:TEXT)})
								elseif XmlChildEx(oXML:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS,"_ICMS51") <> nil 
									aadd(aCabec,{"F1_BASEICM",VAL(oXML:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMS51:_VBC:TEXT)})
									aadd(aCabec,{"F1_VALICM" ,VAL(oXML:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMS51:_VICMS:TEXT)})							
								elseIf XmlChildEx(oXML:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS,"_ICMS60") <> nil //Levar para case e receber o objeto do ICMS corrente para fazer um só trecho com o IF abaixo validano as tags _VBC, _VICMS
									if XmlChildEx(oXML:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMS60,"_VBC") <> nil .and.  XmlChildEx(oXML:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMS60,"_VICMS") <> nil
										aadd(aCabec,{"F1_BASEICM",VAL(oXML:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMS60:_VBC:TEXT) })
										aadd(aCabec,{"F1_VALICM" ,VAL(oXML:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMS60:_VICMS:TEXT)})
									endif
								elseIf XmlChildEx(oXML:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS,"_ICMS80") <> nil 
									aadd(aCabec,{"F1_BASEICM",VAL(oXML:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMS80:_VBC:TEXT) })
									aadd(aCabec,{"F1_VALICM" ,VAL(oXML:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMS80:_VICMS:TEXT)})							
								elseIf XmlChildEx(oXML:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS,"_ICMS90") <> nil 
									aadd(aCabec,{"F1_BASEICM",VAL(oXML:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMS90:_VBC:TEXT)  })
									aadd(aCabec,{"F1_VALICM" ,VAL(oXML:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS:_ICMS90:_VICMS:TEXT)})
								else                                                                                                
									aadd(aCabec,{"F1_BASERET",0 })
									aadd(aCabec,{"F1_ICMRET" ,0 })
								EndIF
							EndIf	
							*/						
							aadd(aCabec,{"F1_DESCONT", 0 , Nil})
							aadd(aCabec,{"F1_SEGURO" , 0 , Nil})
							aadd(aCabec,{"F1_FRETE"  , 0 , Nil})
							aadd(aCabec,{"F1_VALMERC", VAL(oXML:_CTEPROC:_CTE:_INFCTE:_VPREST:_VTPREST:TEXT), Nil})
							aadd(aCabec,{"F1_VALBRUT", VAL(oXML:_CTEPROC:_CTE:_INFCTE:_VPREST:_VTPREST:TEXT) , Nil}) 
							aadd(aCabec,{"F1_MOEDA"  , 1 , Nil}) 
							aadd(aCabec,{"F1_TXMOEDA", 0 , Nil}) 
							If XmlChildEx(oXML:_CTEPROC:_CTE:_INFCTE,"_COBR") <> nil
								_cCndPag := AllTrim(oXML:_CTEPROC:_CTE:_INFCTE:_COBR:_XCONDPAGTO:TEXT)
								If !Empty(_cCndPag)
									aadd(aCabec,{"F1_COND",_cCndPag				}) 
								ElseIf Empty(_cCndPag) .And. !Empty(_cCndPar)
									aadd(aCabec,{"F1_COND",_cCndPar				}) 
								ElseIf 	Empty(_cCndPag) .And. Empty(_cCndPar)
									aadd(aCabec,{"F1_COND",Posicione("SA2",1,xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,"A2_COND") 		}) 
								EndIf
							EndIf
							//aadd(aCabec,{"F1_COND",SuperGetMv("MQ_CPCTE" ,.F.,"001",PADR(' ',TAMSX3("D1_FILIAL")[1])) ,Nil}) //Condicao de Pgto		 
							
							aadd(aCabec,{"F1_STATUS" , IIF(_lClassifica,"A","") , Nil})	

							If SuperGetMv('MV_QCHVCTE',.F.,.T.,PADR(' ',TAMSX3("D1_FILIAL")[1]))
								aadd(aCabec,{"F1_CHVNFE" ,_cChave			,Nil})
							EndIf
							aadd(aCabec,{"F1_TPFRETE",_cTpFre				,Nil})
							aadd(aCabec,{"F1_TPCTE" ,_cTpCte				,Nil})
							aadd(aCabec,{"F1_MODAL" ,_cModal				,Nil})										
							//UF&MUN ORIGEM
							dbSelectArea("CC2")
							dbSetOrder(3)
							dbGoTop()
							If dbSeek(xFilial("CC2")+SUBSTR(oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_CMUNINI:TEXT,3,5))    
								_cUfOri := oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_UFINI:TEXT
								_cMunOri:= CC2->CC2_CODMUN
								
								aadd(aCabec,{"F1_UFORITR", oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_UFINI:TEXT , Nil}) 	
								aadd(aCabec,{"F1_MUORITR", CC2->CC2_CODMUN , Nil}) 									        
							Endif 
							//UF&MUN DESTINO
							dbSelectArea("CC2")
							dbSetOrder(3)    
							dbGoTop()
							If dbSeek(xFilial("CC2")+SUBSTR(oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_CMUNFIM:TEXT,3,5))   
								_cUfDes := oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_UFFIM:TEXT 
								_cMunDes:= CC2->CC2_CODMUN
							
								aadd(aCabec,{"F1_UFDESTR", oXML:_CTEPROC:_CTE:_INFCTE:_IDE:_UFFIM:TEXT , Nil}) 	
								aadd(aCabec,{"F1_MUDESTR", CC2->CC2_CODMUN , Nil}) 									        
							Endif												
							//						//Dados dos itens						//
							If !ValType(oxml:_CTEPROC:_CTE:_INFCTE:_INFITEM:_INFTRADITEM) == "A"
								XmlNode2Arr( oxml:_CTEPROC:_CTE:_INFCTE:_INFITEM:_INFTRADITEM, "_INFTRADITEM" )
							EndIf

							For _nI := 1 TO LEN(oxml:_CTEPROC:_CTE:_INFCTE:_INFITEM:_INFTRADITEM)
								
								aLinha 		:= {}
								nQtdTrad	:= 0
								nValorUnit  := 0
								nValorTot	:= 0
								_cProd 		:= ""
								_cCCus		:= ""
								_cConta		:= ""

								//Busca produtos
								If XmlChildEx(oxml:_CTEPROC:_CTE:_INFCTE:_INFITEM:_INFTRADITEM[_nI],"_XCODPRODUTO") <> nil                  
									_cProd := UPPER(ALLTRIM(oxml:_CTEPROC:_CTE:_INFCTE:_INFITEM:_INFTRADITEM[_nI]:_XCODPRODUTO:TEXT))     
											
									dbSelectArea("SB1")
									dbSetOrder(1)
									SB1->(DBSEEK(xFilial("SB1")+_cProd))                                                                                                                                                                                                             						
									
									//array
									aadd(aLinha,{"D1_FILIAL" 	, cFilAnt				,Nil})        
									aAdd(aLinha,{"D1_ITEM"    	, StrZero(_nI,TAMSX3("D1_ITEM")[1]) ,NIL})  								
									aadd(aLinha,{"D1_COD"  	 	, _cProd				,Nil})   
									aadd(aLinha,{"D1_FORNECE"	,_cForn					,NIL})
									aadd(aLinha,{"D1_LOJA"    	,_cLoja					,NIL})
									aadd(aLinha,{"D1_SEGURO" , 0 , Nil})
									aadd(aLinha,{"D1_VALFRE" , 0 , Nil})
									aadd(aLinha,{"D1_DESPESA", 0 , Nil})

									If(_lClassifica) .or. _cCpTes<>"D1_TES" //TES DE ENTRADA
										dbSelectArea("SF4")
										dbSetOrder(1) 
										dbGoTop()
										If SF4->(dbSeek(xFilial("SF4")+_cTes))
											if _lClassifica
												aadd(aLinha,{"D1_TES", _cTes,Nil}) //D1_TES 									
												aadd(aLinha,{"D1_CF", SF4->F4_CF,Nil})
											endif  
										Else
											U_QEXPEVENTO(_cDoc, _cSer, _CNPJEmit, pTipoDoc, "Codigo TES invalido.", pTpEvERRO, pAlteraY, pSitua4, AllTrim(SM0->M0_CODFIL), _cChave)
											cTexto += "Codigo TES invalido. TES: " + _cTes + CRLF								
											_lImporta:=.F.							  									
										EndIf
									EndIf

									//CC - Centro de Custos 
									//Regra - caso venha centro de custos do QUIRIUS usa, caso contrario pega do pedido de compras.
									If XmlChildEx(oxml:_CTEPROC:_CTE:_INFCTE:_INFITEM:_INFTRADITEM[_nI],"_XNROCENTROCUSTO") != NIL
										_cCCus:=oxml:_CTEPROC:_CTE:_INFCTE:_INFITEM:_INFTRADITEM[_nI]:_xNroCentroCusto:TEXT
									EndIf

									//Conta Contabil
									//Regra - caso venha centro de custos do QUIRIUS usa, caso contrario pega do pedido de compras.
									If XmlChildEx(oxml:_CTEPROC:_CTE:_INFCTE:_INFITEM:_INFTRADITEM[_nI],"_XNROCONTACONTABIL") != NIL
										_cConta:= oxml:_CTEPROC:_CTE:_INFCTE:_INFITEM:_INFTRADITEM[_nI]:_xNroContaContabil:TEXT
									EndIf	
													
									//Pedido de compra
									If XmlChildEx(oxml:_CTEPROC:_CTE:_INFCTE:_INFITEM:_INFTRADITEM[_nI],"_CPEDIDO") != NIL
										cPedido:=StrZero(Val(oxml:_CTEPROC:_CTE:_INFCTE:_INFITEM:_INFTRADITEM[_nI]:_CPEDIDO:TEXT),TAMSX3("D1_PEDIDO")[1])
										cItemPC:=StrZero(Val(oxml:_CTEPROC:_CTE:_INFCTE:_INFITEM:_INFTRADITEM[_nI]:_NITEMPED:TEXT),TAMSX3("D1_ITEMPC")[1])
										
										dbSelectArea("SC7")
										SC7->(dbSetOrder(4))
										SC7->(dbGoTop())
										If SC7->(dbSeek(xFilial("SC7")+_cProd+REPLICATE(" ",TAMSX3("C7_PRODUTO")[1] - Len(_cProd)) + cPedido +cItemPC))									
											If SC7->C7_CONAPRO == "L" 
												If nQtdTrad > (SC7->C7_QUANT - (SC7->C7_QUJE + C7_QTDACLA))
													U_QEXPEVENTO(_cDoc, _cSer, _CNPJEmit, pTipoDoc, "Quantidade da Nota maior que o disponivel no Pedido de Compra!Pedido: "+cPedido+" Item:"+ cItemPC, pTpEvERRO, pAlteraY, pSitua4, AllTrim(SM0->M0_CODFIL), _cChave)	
													cTexto += "Quantidade da Nota maior que o disponivel no Pedido de Compra! Pedido: "+cPedido+" Item:"+ cItemPC+ CRLF
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
												U_QEXPEVENTO(_cDoc, _cSer, _CNPJEmit, pTipoDoc, "Pedido de Compra aguardando aprovacao!Pedido: "+cPedido+" Item:"+ cItemPC, pTpEvERRO, pAlteraY, pSitua4, AllTrim(SM0->M0_CODFIL), _cChave)	
												cTexto += "Pedido de Compra aguardando aprovação!Pedido: "+cPedido+" Item:"+ cItemPC+ CRLF
												_lImporta := .F.										
											Endif	
										Else
											U_QEXPEVENTO(_cDoc, _cSer, _CNPJEmit, pTipoDoc, "Pedido ou Item de Compra nao encontrado!Pedido: "+cPedido+" Item:"+ cItemPC, pTpEvERRO, pAlteraY, pSitua4, AllTrim(SM0->M0_CODFIL), _cChave)
											cTexto += "Pedido ou Item de Compra nao encontrado!Pedido: "+cPedido+" Item:"+ cItemPC+ CRLF
											_lImporta := .F.
										EndIf
									EndIf  
									nValorUnit	:= ROUND(VAL(oxml:_CTEPROC:_CTE:_INFCTE:_INFITEM:_INFTRADITEM[_nI]:_VVALOR:TEXT),TamSX3("D1_VUNIT")[2])
									nValorTot 	:= ROUND(VAL(oxml:_CTEPROC:_CTE:_INFCTE:_VPREST:_VTPREST:TEXT),TamSX3("D1_TOTAL")[2])	
									nQtdTrad 	:= ROUND(nValorTot/nValorUnit,TamSX3("D1_QUANT")[2])
									
									aadd(aLinha,{"D1_QUANT"  	, nQtdTrad		,Nil})
									aadd(aLinha,{"D1_VUNIT"   	, nValorUnit 	,Nil})
									aadd(aLinha,{"D1_TOTAL"   	, nValorTot 	,Nil})
								Else
									U_QEXPEVENTO(_cDoc, _cSer, _CNPJEmit, pTipoDoc, "Codigo do produto nao preenchido no XML", pTpEvERRO, pAlteraY, pSitua4, AllTrim(SM0->M0_CODFIL), _cChave)
									cTexto += "Codigo do produto nao preenchido no XML" + CRLF
									_lImporta := .F.
								EndIf 

								//Centro de Custos
								if Empty(_cCCus)
									_cCCus:= SB1->B1_CC
								endif
								if !Empty(_cCCus)
									aadd(aLinha,{"D1_CC"  , _cCCus 		,Nil})
								endif
								//Conta Contabil
								if !Empty(_cConta)
									_cConta:=SB1->B1_CONTA
								endif
								if !Empty(_cConta)
									aadd(aLinha,{"D1_CONTA"  , _cConta 		,Nil})
								endif
										
								If _lClassifica 
									aadd(aLinha,{"AUTDELETA" , "N" , Nil}) // Incluir sempre no ?timo elemento do array de cada item
								Endif
								
								aadd(aItens,aLinha)													
							Next _nI
							
							If _lImporta   
								lMsErroAuto := .F.						
								//Documento de entrada										
								If _lClassifica //Documento de entrada					
									MsExecAuto({|x,y,z,w|Mata103(x,y,z,w)},aCabec, aItens,3,.F.)
								Else //Pr?nota
									MSExecAuto({|x,y,z,a,b| MATA140(x,y,z,a,b)}, aCabec, aItens, 3,,)
								EndIf
								
								If lMsErroAuto							
									cErro := AllTrim(MemoRead(NomeAutoLog()))    

									cTexto += 'Status: NÃO importado. Verificar inconsistências.' + CRLF   
									cTexto += 'Erro: ' + CRLF + cErro
																				
									U_QEXPEVENTO(_cDoc, _cSer, _CNPJEmit, pTipoDoc, "Verificar Inconsistencia: " + StrTran(NoAcento(AnsiToOem(cErro)),"<",""), pTpEvERRO, pAlteraY, pSitua4, AllTrim(SM0->M0_CODFIL), _cChave)
									_lImporta := .F.
								Else							
									
									If !_cCpTes=="D1_TES" .and. !Empty(_cTes)
										dbSelectArea("SD1")
										DbSetOrder(1) 
										dbGoTop()
										dbSeek(Alltrim(SM0->M0_CODFIL)+_cDoc+_cSer+_cForn+_cLoja)  
										While !SD1->(Eof()) .and. Alltrim(SM0->M0_CODFIL)+_cDoc+_cSer+_cForn+_cLoja==SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)
											RecLock("SD1", .F.)		
											_cTmp:="SD1->"+_cCpTes+":= _cTes"
											&(_cTmp)
											MsUnLock()
											SD1->(dbskip())
										enddo
									EndIf  

									_cDescr:=  IIF(_lClassifica,'CTE - Nota Fiscal Integrada', 'CTE - Pre Nota Integrada - Classificar')
									_cSitu:= IIF(_lClassifica,pSitua5,pSitua3)
									U_QEXPEVENTO(_cDoc, _cSer, _CNPJEmit, pTipoDoc, _cDescr, pTpEvInfo, pAlteraN, _cSitu, AllTrim(SM0->M0_CODFIL), _cChave)					
									cTexto += _cDescr + CRLF + CRLF
								EndIf
							EndIf 
						Else
							U_QEXPEVENTO(_cDoc, _cSer, _CNPJEmit, pTipoDoc, 'Nao importado. Nota fiscal ja existente no Protheus', pTpEvERRO, pAlteraY, pSitua4, AllTrim(SM0->M0_CODFIL), _cChave)					
							cTexto += 'Status: Nao importado. Nota fiscal ja existente no Protheus.' + CRLF + CRLF
							_lImporta := .F.
						EndIf				
					EndIf
				EndIf
			EndIf
		endif
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
		If _lImporta
			__CopyFile(cDirNFE+aFiles[_nX,1],cDirProc+aFiles[_nX,1])
		Else
			__CopyFile(cDirNFE+aFiles[_nX,1],cDirErr+aFiles[_nX,1])
		EndIf
		FErase(cDirNFE+aFiles[_nX,1])  
	Endif
Next _nX

If !IsBlind()     

	If alltrim(cTexto) == ''
		cTexto := "Nao ha arquivos para integracao."
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

Return(.T.)

/*/{Protheus.doc} nomeStaticFunction
	(long_description)
	@type  Static Function
	@author user
	@since 12/02/2020
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

If AllTrim(xCHVNFE) <> ""    
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

/*/{Protheus.doc} nomeStaticFunction
	(long_description)
	@type  Static Function
	@author user
	@since 12/02/2020
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/
Static Function RetFilial(cCGC)
	Local cCodFilial := "  "
	Local aArea      := GetArea()
	Local aAreaSM0   := SM0->( GetArea() )

	DbSelectArea("SM0")
	DbGoTop()

	While !Eof()

	    If AllTrim(cCGC) == AllTrim(SM0->M0_CGC)
	    	cCodFilial := SM0->M0_CODFIL
	    	RestArea( aAreaSM0 )
			RestArea( aArea )
	    	Return cCodFilial
	    EndIf

		SM0->( DbSkip() )
	EndDo

	RestArea( aAreaSM0 )
	RestArea( aArea )

	If Empty(cCodFilial)
		cCodFilial := xFilial("SD1")
	EndIf
Return ALLTRIM(cCodFilial)

/*/{Protheus.doc} nomeStaticFunction
	(long_description)
	@type  Static Function
	@author user
	@since 12/02/2020
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/
Static Function NFReferencia(pTipo, pParam1, pParam2)
Local xQuery := ""
Local lRet   := .F.

	xQuery += "SELECT R_E_C_N_O_ "
	xQuery += "FROM "+RetSqlName("SF1")+" F1 "
	xQuery += "WHERE  F1.D_E_L_E_T_ = ' '"
	xQuery += " AND F1_FILIAL='"+xFilial("SF1")+"' "
	If pTipo ==1
		xQuery += "AND F1_CHVNFE = '"+pParam1+"' "
	Else	
		xQuery += "AND F1_DOC = '"+pParam1+"' "
		xQuery += "AND F1_SERIE = '"+pParam2+"' "		
	Endif
	
	If Select("TRBSF1") > 0
		TRBSF1->(dbCloseArea())
	Endif
	
	xQuery := ChangeQuery(xQuery)
	TCQuery xQuery NEW ALIAS "TRBSF1"
	
	TRBSF1->(dbGotop())
	If !TRBSF1->(Eof())
		dbSelectAreA("SF1")
		SF1->(dbGoto(TRBSF1->R_E_C_N_O_))
		lRet := .T.
	EndIf
	
	If Select("TRBSF1") > 0
		TRBSF1->(dbCloseArea())
	Endif

Return(lRet)

/*/{Protheus.doc} VldIcms
	(Retorna base e valor do icms)
	@type  Static Function
	@author user
	@since 26/02/2021
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/
Static Function VldIcms(oXML)
Local _aImcs:= StrToKarr(_cIcms,"/")
Local _nX:=0
Local _nL:=Len(_aImcs)
Local _aRet:={0,0}
Local _cNomIcm:=""
Local _oObjF:= nil
Local _oObjFor:=nil
Local _oObjVbc:= _oObjVIcm := nil

_oObjF:= XmlChildEx(oXML:_CTEPROC:_CTE:_INFCTE:_IMP,"_ICMS")
If _oObjF <> nil 
	For _nX:=1 to _nL
		_cNomIcm:= "_ICMS"+_aImcs[_nX]
		_oObjFor:= XmlChildEx(_oObjF,_cNomIcm)//oXML:_CTEPROC:_CTE:_INFCTE:_IMP:_ICMS
		if _oObjFor <> nil 
			_oObjVbc := XmlChildEx(_oObjFor,"_VBC")
			_oObjVIcm:= XmlChildEx(_oObjFor,"_VICMS")
			if _oObjVbc <> nil .and.  _oObjVIcm <> nil
				_aRet[1]:= VAL(_oObjVbc:TEXT)
				_aRet[2]:= VAL(_oObjVIcm:TEXT)
			endif
		endif
	next _nX
endif		
	
Return _aRet

//################################
//################################
//################################
Static Function MyError( oError )
	_cError:= oError:Description
	BREAK
Return( NIL )
