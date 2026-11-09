#Include "PROTHEUS.CH"
#Include "AP5MAIL.CH"

/*/{Protheus.doc} Static Function GREnvM
    (Rotina que envia email)
    @type  Function
    @author user
    @since 11/12/2020
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function GREnvM(cFrom, cTo, cCC, cSubject, cMsg, cAttach,lConfirm)

	Local cServer    := GetMV("MV_RELSERV")
	Local cAccount   := GetMV("MV_RELACNT")
	Local cPassword  := GetMV("MV_RELPSW")
	Local lAutentica := GetMv("MV_RELAUTH")
	Local lEmOk, cError
	
    Default cFrom:= GETMV("MV_RELFROM")
	Default lConfirm := .F.
	
	Begin Sequence

		If !Empty(cServer) .and. !Empty(cAccount)
			CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPassword Result lEmOk
			If lEmOk
				If lAutentica
					If !MailAuth(cAccount, cPassword)
						DISCONNECT SMTP SERVER
						U_GrpFMsgH("Falha na Autenticacao do Usuario","Alerta")
						lEmOk := .F.
						Break
					EndIf
				EndIf
				If lConfirm
					ConfirmMailRead(.T.)
				Endif
				If cAttach <> Nil
					SEND MAIL FROM cFrom TO cTo CC cCC SUBJECT AllTrim(cSubject) BODY cMsg ATTACHMENT cAttach Result lEmOk
				Else
					SEND MAIL FROM cFrom TO cTo CC cCC SUBJECT AllTrim(cSubject) BODY cMsg Result lEmOk
				Endif

				If !lEmOk
					GET MAIL ERROR cError
					//ConOut("Erro no envio de Email - "+cError+" O e-mail '"+cSubject+"' nùo pùde ser enviado.")
					U_GrpFMsgH("Erro no envio de Email - "+cError+" O e-mail '"+cSubject+"' nùo pùde ser enviado.", "Alerta")
				Else
					U_GrpFMsgH("E-mail de notificaùùo enviado com sucesso.")
				EndIf
				DISCONNECT SMTP SERVER
			Else
				GET MAIL ERROR cError
				DISCONNECT SMTP SERVER
				U_GrpFMsgH("Erro na conexùo com o servidor de Email - "+cError+"O e-mail '"+cSubject+"' nùo pùde ser enviado.","Alerta")
			EndIf
		Else
			U_GrpFMsgH("Nùo foi possùvel enviar o e-mail porque o as informaùùes de servidor e conta de envio nùo estùo configuradas corretamente.", "Alerta")
		EndIf

	End Sequence

Return lEmOk

/*/{Protheus.doc} User Function GetVlObj
	(Retorna o valor de uma tag do XML caso ela exista)
	@type  Function
	@author user
	@since 01/03/2021
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/
User Function GetVlObj(_oObj,_cCampo,_cTpVl,_lExist)
Local _objTmp:=nil
Local _Retorno:=nil
Default _cTpVl:= "C"
Default _lExist:= .F.

_lExist:=.F.

_Retorno:= IIF(_cTpVl=="C","",0)

_objTmp:= XmlChildEx(_oObj,_cCampo)
If _objTmp != NIL
	_lExist:=.T.
	_Retorno:= IIF(_cTpVl=="C",_objTmp:TEXT,Val(_objTmp:TEXT))
EndIf
	
Return _Retorno


/*/{Protheus.doc} RetTpDoc
	(long_description)
	@type  Static Function
	@author user
	@since 21/04/2021
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	/*/
User Function RetTpDoc(_cEspecie)
Local _cEspCte:=SuperGetMv("MV_QESPCTE",.F.,"CTE/CT-E")+"/"
Local _cEspNFS:=SuperGetMv("MV_QESPNFS",.F.,"NFS/NFS-E")+"/"
Local _pTipo:= "1"

_cEspecie:=Alltrim(_cEspecie)+"/"

If _cEspecie$_cEspCte  
	_pTipo := '2'                   
ElseIf _cEspecie$_cEspNFS //SERVICO
	_pTipo := '3'
Else             
	_pTipo := '1' //NF NORMAL
Endif
	
Return _pTipo


/*/{Protheus.doc} MsgH
	(long_description)
	@type  Static Function
	@author user
	@since 20/08/2021
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
User Function GrpFMsgH(_cMsg,_ctpMsg)
Local _lGerL:= SuperGetMV("MV_QLOG",.F.,.F.)

if _lGerL
	conout(_cMsg)
endif
	
Return
