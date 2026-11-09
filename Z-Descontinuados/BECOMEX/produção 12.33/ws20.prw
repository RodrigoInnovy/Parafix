#Include "Totvs.ch"
 
/*/{Protheus.doc} User Function Ws20
	(WebService Client para conexão protheus X quirius)
	@type  Function
	@author Heitor dos Santos (Gruppe Tecnologia)
	@since 22/03/2021
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/
User Function Ws20(_cXml,_cErro,_nNivel)
Local _cToken:= Alltrim(SuperGetMv("MV_QTOK ",.F.,""))
Local _lRet:= .F.
Local _cErr:= ""
Local oWsdl:= nil
Local _ix
Local _lRein:= .F.
Default _cXml:=""
Default _nNivel:= 0

if Empty(_cXml)
	Return .F.
endif

Private _cUrl   := SuperGetMv("MV_QWSURL",.F.,"https://wshomfertiparsfe.becomex.com.br/GovernancaWebservice.svc?wsdl")
Private _cUser := SuperGetMv("MV_QWSUSER" ,.F.,"wsfertipar") 
Private _cSenha  := SuperGetMv("MV_QWSPIN" ,.F.,"fertipar123")
Private _cDtTok := Alltrim(SuperGetMv("MV_QDTTOK ",.F.,""))

For _ix:= 1 to 2

	if Type("oWsdlBecom")=="O" .and. !Empty(_cDtTok) .and. _cDtTok==DTOS(Date())
		oWsdl:=oWsdlBecom
	endif
	oWsdlTmp:=oWsdl
	if Type("oWsdlTmp")!="O"
		_lRet:= CriarToken(@oWsdl,_cUrl,_cUser,_cSenha,"CriarToken",_cXml,@_cToken,@_cErr) 
		Public oWsdlBecom:= oWsdl
	else
		_lRet:=.T.
	endif

	_nNivel:=1
	If _lRet
		_nNivel:=2
		_lRet:= RecDocEve(@oWsdl,_cToken,_cXml,@_cErr,@_lRein)
		If !_lRet
			if _lRein//Reinicia
				_lRein:= .F.
				FreeObj(oWsdlBecom)
				FreeObj(oWsdl)
				loop
			endif
			_cErro:=_cErr
			conout(_cErr)
			
		Endif
		exit 
	Else
		// houve algum erro na chamada
		// ou no processamento do webservice 
		_cErro:=_cErr
		conout(_cErr)
		exit
	Endif
next _ix

Return _lRet

/*/{Protheus.doc} CriarToken() 
	(Cria token para troca de mensagens)
	@type  Static Function
	@author user
	@since 18/03/2021
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/
Static Function CriarToken(oWsdl,_cUrl,_cUser,_cSenha,_cOper,_cXml,_cToken,_cErr)
Local _lRet:=.F.
Local oXmlRet:= nil
oWsdl := TWsdlManager():New()

oWsdl:lSSLInsecure := .T.
oWsdl:nTimeout := 120

	If !oWsdl:ParseUrl(_cUrl)
		_cErr:="Erro na conexao "+_cUrl
	Else
		If oWsdl:SetOperation( _cOper)
		
			
			_cSoap := '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/" xmlns:gov="http://schemas.datacontract.org/2004/07/Governanca.Webservice.Models">'
			_cSoap += '<soapenv:Header/>'
			_cSoap += '<soapenv:Body>'
			_cSoap += '	<tem:CriarToken>'
			_cSoap += '		<tem:request>'
			_cSoap += '			<gov:Senha>'+DecodeUTF8(_cSenha)+'</gov:Senha>'
			_cSoap += '			<gov:Usuario>'+DecodeUTF8(_cUser)+'</gov:Usuario>'
			_cSoap += '		</tem:request>'
			_cSoap += '	</tem:CriarToken>'
			_cSoap += '</soapenv:Body>'
			_cSoap += '</soapenv:Envelope>'
						
			If oWsdl:SendSoapMsg( _cSoap )
				oXmlRet:=oWsdl:GetSoapResponse()
				cError:=""
				cWarning:=""
				oXmlRet:= XmlParser(oXmlRet, "_", @cError, @cWarning)
				_cToken:= oXmlRet:_S_ENVELOPE:_S_BODY:_CRIARTOKENRESPONSE:_CRIARTOKENRESULT:_A_TOKEN:TEXT
				_lRet:=.T.
				PUTMV("MV_QDTTOK",DTOS(Date()))
				PUTMV("MV_QTOK",_cToken)
			Else
				_cErr:="Erro ao enviar evento " +oWsdl:cError 
			Endif 
			
		else
			_cErr:="Operação não encontrada no webservice ("+_cOper+")"
		EndIf
	EndIf
	
Return _lRet

/*/{Protheus.doc} RecDocEve() 
	(Envia evento ao Quirius)
	@type  Static Function
	@author user
	@since 18/03/2021
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/
Static Function RecDocEve(oWsdl,_cToken,_cXml,_cErr,_lRein)
Local _lRet:=.F.
Local _cSuces:=""
Local cXmlRet:=""


	_cOper:= 'ReceiveDocEvento'
	If oWsdl:SetOperation( _cOper)
		
		
		_cSoap := '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tem="http://tempuri.org/" xmlns:gov="http://schemas.datacontract.org/2004/07/Governanca.Webservice.Models">'
		_cSoap += '<soapenv:Header/>'
		_cSoap += '<soapenv:Body>'
		_cSoap += '	<tem:ReceiveDocEvento>'
		_cSoap += '		<tem:request>'
		_cSoap += '			<gov:Token>'+_cToken+'</gov:Token>'
		_cSoap += '			<gov:RecXML>'+_NoTags(_cXml)+'</gov:RecXML>' //Sempre que for enviar um XML dentro de um SOAP usar _NoTags, deve trocar as tags XML por caracteres nao reconheciveis como &amp
		_cSoap += '		</tem:request>'
		_cSoap += '	</tem:ReceiveDocEvento>'
		_cSoap += '</soapenv:Body>'
		_cSoap += '</soapenv:Envelope>'
		

		If oWsdl:SendSoapMsg( _cSoap )
			cXmlRet:=oWsdl:GetSoapResponse()
			cError:=""
			cWarning:=""
			oXmlRet:= XmlParser(cXmlRet, "_", @cError, @cWarning)
			_cSuces:= oXmlRet:_S_ENVELOPE:_S_BODY:_ReceiveDocEventoRESPONSE:_ReceiveDocEventoRESULT:_A_SUCESSO:TEXT
			if _cSuces=="false"
				_nPIni:= RAt( "<a:WsError>", cXmlRet ) 
				_nPFim:= At( "</a:WsError>", cXmlRet ) 
				_cErr:= Subs(cXmlRet,_nPIni,_nPFim-_nPIni)
				
				_nPIni:= RAt( "<a:Msg>", _cErr ) 
				_nPFim:= At( "</a:Msg>", _cErr ) 
				_nPIni+=7
				_cErr:= Subs(_cErr,_nPIni,_nPFim-_nPIni)
			else
				_lRet:=.T.
			endif
		Else
			_cErr:="Erro ao enviar evento " +oWsdl:cError 
		Endif 
		
	else
		_cErr:="Operação não encontrada no webservice ("+_cOper+")"
		_lRein:=.T.
	EndIf
	_cErr:= DecodeUTF8(_cErr)

Return _lRet
