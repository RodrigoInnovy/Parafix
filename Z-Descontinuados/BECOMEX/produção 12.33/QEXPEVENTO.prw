#INCLUDE "PROTHEUS.CH"     
#INCLUDE "xmlxfun.CH"
#INCLUDE "TOPCONN.CH"
         
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³QEXPEVENTO ?Autor ?Mailson Silva	    ?Data ?6/01/2014 ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±?         ³Exporta eventos da NFE para a rotina de integração  		   ³±?
±±?         ³DFe-Receiver x Protheus		   							   ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
/*/

User Function QEXPEVENTO( pNF, pSerie, pCNPJ, pTipoDoc, pMsg, pTpEvento, pAltera, pSituacao, pFilial, pChave, _cEspec)
Local cError   := ""
Local cWarning := "" 
Local cMensagem := ""
Local cModelo := ''
Local cXml := ''  
Local oXml := NIL
Local lRet := .T.
Local _nErr:=0
Local _lWs:=.F.
Local _lWsAt:= (SuperGetMv("MV_QUSAWS",.F., .F.) .and. (!SuperGetMv("MV_QUIFER",.F.,.F.) .or. SuperGetMv("MV_QFORCE",.F.,.T.) ))//Parametro especifico Fertipar, é necessário criar o parametro como .T.
Local _nNivel:=0
Local _cAleat:=""
Local _cDirAt:=IIF(SuperGetMv("MV_QUIFER",.F.,.F.),"Aguardando\","")
Default _cEspec:=""
Default pTipoDoc:= U_RetTpDoc(_cEspec)

If Empty(pChave) .and. pTipoDoc!="3" .or. IsInCallStack('U_MT116TOK')//quando não há chave o Quirius não consegue fazer a importação, só permite NFSE
    return .F.
Endif

cFolderEve := SuperGetMv("MV_QFOLEVE" ,.F.,"\receiver\Integracao\eventos\")     
cFolderEve+=_cDirAt  
If Substr(cFolderEve,len(cFolderEve),1) <> "\"
	cFolderEve+="\"
endif

cModelo +=  '<?xml version="1.0" encoding="UTF-8"?>' 
cModelo +=  '<RecEvento xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="RecDfe_Evento_v1.00.xsd">'
cModelo += 	'<ide>'
cModelo += 	'<serie>'	+ IIF(ALLTRIM(pSerie)<>'',Alltrim(EncodeUTF8( _NoTags(STR(VAL(pSerie))))),'')	+'</serie>'
cModelo += 	'<nNF>'		+ Alltrim(EncodeUTF8( _NoTags(STR(VAL(pNF)))))		+'</nNF>'
cModelo += 	'<CNPJ>'	+ Alltrim(EncodeUTF8( _NoTags(pCNPJ)))	+'</CNPJ>'
cModelo += 	'<tpDocto>' + Alltrim(EncodeUTF8( _NoTags(pTipoDoc))) +'</tpDocto>'     
cModelo += 	'<chaveDoc>'+ ALLTRIM(EncodeUTF8( _NoTags(pChave)))	+'</chaveDoc>'
cModelo += 	'<codEstIntegracao>'+EncodeUTF8( _NoTags(pFilial))	+'</codEstIntegracao>'
cModelo += 	'</ide>'
cModelo += 	'<Evento>'
cModelo += 	'<data>'	+ ALLTRIM(Str(Year(Date()))+"-"+StrZero(Month(Date()),2)+"-"+StrZero(Day(Date()),2)) +'</data>'
cModelo += 	'<hora>'	+ Time() 			+'</hora>'
cModelo += 	'<msg>'		+ Alltrim(EncodeUTF8( _NoTags(pMsg)))		+'</msg>'
cModelo += 	'<tpEvento>'+ Alltrim(pTpEvento)+'</tpEvento>'
cModelo += 	'<permiteAlteracao>'+Alltrim(pAltera)+'</permiteAlteracao>'     
cModelo += 	'<situacaoRecebimento>'+Alltrim(pSituacao)+'</situacaoRecebimento>'   
cModelo += 	'<notaPropria>no</notaPropria>'   
cModelo += 	'</Evento>'
cModelo += 	'</RecEvento>'

If _lWsAt
    _lWs:= enviar(cModelo,@cError,@_nNivel)
    if !_lWs
      U_GrpFMsgH(cError)
      lRet := .F.
    else
      lRet := .T.
    endif

EndIf

if !_lWs .or. !_lWsAt
  //Gera o Objeto XML
  oXml := XmlParser( cModelo, "_", @cError, @cWarning )
      
  If oXml <> Nil
      Save oXml XMLSTRING cXml
  Else
      cMensagem := "XML Error: "+cError+Chr(13)+Chr(10)+"XML Warning: "+cWarning
      U_GrpFMsgH(cMensagem)
  Endif

  cFile := cFolderEve

if !_lWs .and. _nNivel==2
  cFile += "erros\"

  if !existdir(cFile)
      if MakeDir(cFile)
        _cErro:="Não foi possivel criar o diretório "+cFile+" ERRO!"
        U_GrpFMsgH(_cErro)
      endif
  endif
Endif

_cAleat:= Randomize(1,999999)
_cAleat:= StrZero(_cAleat,6)
cFile+= CEmpAnt+pFilial+"."+DtoS(Date())+StrTran(Time(),":","")+"."+_cAleat+"."+Alltrim(pNf)+"."+Alltrim(pSerie)+".xml"

  nHandle := fCreate(cFile)
  _nErr:=fError()
  If _nErr <> 0
      lRet := .F.
      U_GrpFMsgH("Erro na gravacao do XML, Erro "+Alltrim(Str(_nErr))+" Arquivo:"+cFile)
  Else
      fWrite(nHandle, cXml)
      fClose(nHandle)
      lRet := .T.
  Endif

endif

if _lWsAt
  cError:=""
  if !U_QEXPEVEW(@cError) //Envia ao quirius por webservice os arquivos de log que estão no diretorio.
  endif
endif

Return lRet

/*/{Protheus.doc} enviar
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
Static Function enviar(cModelo,cError,_nNivel)
Local _lRet:=.F.
Local _nVer:=2

Private _cUrl   := SuperGetMv("MV_QWSURL",.F.,"https://wshomfertiparsfe.becomex.com.br/GovernancaWebservice.svc?wsdl")

if _nVer==1
  _lRet:= U_wsdl3(cModelo,@cError)
else
  _lRet:= U_Ws20(cModelo,@cError,@_nNivel)
endif
  
Return _lRet

User Function wsdl3(pXml,cError)
  local owsclient
  owsclient := WSGovernancaWebservice():New()

  owsclient:oWSrequest:cSenha :=  SuperGetMv("MV_QWSPIN" ,.F.,"admin")   
  owsclient:oWSrequest:cUsuario := SuperGetMv("MV_QWSUSER" ,.F.,"admin")

  If oWSClient:CriarToken() 

    owsclient:oWSEventrequest:cToken := oWSClient:oWSCriarTokenResult:cToken
    owsclient:oWSEventrequest:cRecXML := pXml
    
    If oWSClient:ReceiveDocEvento()
      return .T.
    Else
      cError:= getwscerror(3)
      conout(getwscerror(3))
    Endif
  Else
    // houve algum erro na chamada
    // ou no processamento do webservice 
    cError:= getwscerror(3)
    conout(getwscerror(3))
  Endif
Return .F.

/*/{Protheus.doc} User Function QEXPEVEW
  (Envia ao quirius por webservice os arquivos de log que estão no diretorio.)
  @type  Function
  @author user
  @since 22/03/2021
  @version version
  @param param_name, param_type, param_descr
  @return return_var, return_type, return_description
  @example
  (examples)
  @see (links_or_references)
  /*/
User Function QEXPEVEW(_cErro,_cEmp, _cFil,_nArqI,_nArqF,_nSleep)
  Local _cDirLog:= ""
  Local aFiles:={}
  Local _ix
  Local cLine
  Local nLines
  Local _lRet:=.F.
  Local cError:=""
  Local _cDirAt:=""
  Local _lExc := SuperGetMV("MV_QUIEXC",.F.,.F.)
  Default _cErro:=""
  Default _cEmp:= ""
  Default _cFil:=""
  Default _nSleep:=0

if !Empty(_cEmp)
  RPCSetType(3)
	RPCSetEnv(_cEmp,_cFil)
endif

  _cDirAt:= IIF(SuperGetMv("MV_QUIFER",.F.,.F.),"Aguardando\","")

  _cDirLog:= SuperGetMv("MV_QFOLEVE" ,.F.,"\receiver\Integracao\eventos\")     
  
  If Substr(_cDirLog,len(_cDirLog),1) <> "\"
    _cDirLog+="\"
  endif

  Begin Sequence
		//If !LockByName("QEXPEVEW", .T., .T.)
		//	ConOut("[U_QEXPEVEW] Ja encontra-se em execucao.")
		//	Break
		//EndIf

		// Informa mensagem no monitor.
    //PtInternal(1, "Integrador de eventos quirius")

    if !existdir(_cDirLog+"XMLProcessados")
      if MakeDir(_cDirLog+"XMLProcessados\")
        _cErro:="Não foi possivel criar o diretório "+_cDirLog+"XMLProcessados\ ERRO"+Alltrim(Str(_nErr))
        Break
      endif
    endif

    if !existdir(_cDirLog+_cDirAt)
      if MakeDir(_cDirLog+_cDirAt)
        _cErro:="Não foi possivel criar o diretório "+_cDirLog+_cDirAt+" ERRO"+Alltrim(Str(_nErr))
        Break
      endif
    endif

    aFiles := Directory(_cDirLog+_cDirAt+"*.xml",,,,2)

    Default _nArqI:=1
    Default _nArqF:=len(aFiles)

    if _nSleep>0
      Sleep(_nSleep*1000)
    endif

		For _ix:=_nArqI to _nArqF
      if aFiles[_ix,5]=="A" .and. file( _cDirLog+_cDirAt+aFiles[_ix,1])
        cLine := MemoRead( _cDirLog+_cDirAt+aFiles[_ix,1] )
 
        // Verifica o número de linhas no texto
        nLines := MLCount( cLine )
        if nLines>0
          _nNivel:=0
          if enviar(cLine,@cError,@_nNivel)//U_Ws20(cLine,@_cErro)
            _lRet:=.T.
            if _lExc
              //Apaga arquivo da pasta \XMLTraduzidos\
              FErase(_cDirLog+_cDirAt+aFiles[_ix,1])
            else
              if __CopyFile(_cDirLog+_cDirAt+aFiles[_ix,1],_cDirLog+"XMLProcessados\"+aFiles[_ix,1])
                //Apaga arquivo da pasta \XMLTraduzidos\
                FErase(_cDirLog+_cDirAt+aFiles[_ix,1])
              else
                _cErro:="Não foi possivel copiar o arquivo "+_cDirLog+_cDirAt+aFiles[_ix,1]
                U_GrpFMsgH(_cErro)
                Break
              endif
            endif
          else
            cFile := _cDirLog
            if _nNivel==2
              cFile += "erros\"

              if !existdir(cFile)
                  if MakeDir(cFile)
                    _cErro:="Não foi possivel criar o diretório "+cFile+" ERRO!"
                    _cErro+= CRLF
                    _cErro+=cError
                    U_GrpFMsgH(_cErro)
                    Break
                  endif
              else
                if __CopyFile(_cDirLog+_cDirAt+aFiles[_ix,1],cFile+aFiles[_ix,1])
                  //Apaga arquivo da pasta \XMLTraduzidos\
                  FErase(_cDirLog+_cDirAt+aFiles[_ix,1])
                  _cErro:="Não foi possivel enviar o arquivo "+_cDirLog+_cDirAt+aFiles[_ix,1]+", o mesmo foi movido para o diretorio de erros!"
                  _cErro+= CRLF
                  _cErro+=cError
                  U_GrpFMsgH(_cErro)
                else
                  _cErro:="Não foi possivel copiar o arquivo "+_cDirLog+_cDirAt+aFiles[_ix,1]
                  U_GrpFMsgH(_cErro)
                  Break
                endif
              endif

            else
              _cErro:="Não foi possivel enviar o arquivo "+_cDirLog+_cDirAt+aFiles[_ix,1]+" não se preocupe, o mesmo será enviado em breve!"
              _cErro+= CRLF
              _cErro+=cError
              U_GrpFMsgH(_cErro)
              Break
            Endif
          endif
        endif
      endif

    Next _ix

		// Libera semáforo.
	  //UnLockByName("QEXPEVEW", .T., .T.)
  
  Recover
    // Libera semáforo.
	  //UnLockByName("QEXPEVEW", .T., .T.)
    U_GrpFMsgH(_cErro)

	End Sequence
Return _lRet


/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³QEXPEV ?Autor ?Heitor dos Santos      	    ?Data ?6/01/2014 ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±?         ³Exporta eventos da NFE para a rotina de integração  		   ³±?
±±?         ³DFe-Receiver x Protheus		   							   ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
/*/

User Function QEXPEV( pMsg, pTpEvento, pAltera, pSituacao, _nRecSF1 )
Local _cCgc:= ""
Local _aAreaF1:= {}
Local _aAreaA1:= {}
Local _aAreaA2:= {}
Local _lRet:= .F.
Local _aSM0:={}
Default _nRecSF1:= 0

  if _nRecSF1>0 
      _aAreaF1:= SF1->(GetArea())
      DbSelectArea("SF1")
      DbGoTo(_nRecSF1)
     
  endif

  if SF1->F1_TIPO$"DB"
    _aAreaA1:= SA1->(GetArea())
    DbSelectArea("SA1")
    DbSetOrder(1)
    DbSeek(xFilial("SA1")+SF1->(F1_FORNECE+F1_LOJA))
  else
    _aAreaA2:= SA2->(GetArea())
    DbSelectArea("SA2")
    DbSetOrder(1)
    DbSeek(xFilial("SA2")+SF1->(F1_FORNECE+F1_LOJA))
  endif

 _cCgc:= IIf(SF1->F1_TIPO$"DB",SA1->A1_CGC,SA2->A2_CGC)

 if SF1->F1_EST='EX'
  _aSM0		 := FWArrFilAtu(cEmpAnt,SF1->F1_FILIAL)
  _cCgc    := _aSM0[18]
 endif

  _lRet:=U_QEXPEVENTO(SF1->F1_DOC, SF1->F1_SERIE, _cCgc, , pMsg, pTpEvento, pAltera, pSituacao, SF1->F1_FILIAL, SF1->F1_CHVNFE,SF1->F1_ESPECIE)

  if SuperGetMv("MV_QUIFER",.F.,.F.)//Especifico Fertipar
    if _lRet
        if RecLock("SF1", .F.)
          SF1->F1_XQINTEG:= 'S'
          MsUnlock()
        endif
    else
        _cIntegr:= SF1->F1_XQINTEG
        if Empty(_cIntegr)
            _cIntegr:= "1"
        elseif _cIntegr>="3"
            _cIntegr:= 'E'
        else
            _cIntegr:= SF1->F1_XQINTEG
            _cIntegr:= SOMA1(_cIntegr)
        endif
        if RecLock("SF1", .F.)
          SF1->F1_XQINTEG:= _cIntegr
          MsUnlock()
        endif
    endif
  endif

  if Len(_aAreaF1) > 0
      RestArea(_aAreaF1)
      if Len(_aAreaA1)>0
        RestArea(_aAreaA1)
      endif

      if Len(_aAreaA2)>0
        RestArea(_aAreaA2)
      endif

  endif

Return _lRet

/*/{Protheus.doc} User Function QEXPEVM
  (long_description)
  @type  Function
  @author user
  @since 30/06/2021
  @version version
  @param param_name, param_type, param_descr
  @return return_var, return_type, return_description
  @example
  (examples)
  @see (links_or_references)
  /*/
User Function QEXPEVM()
Local _lClassifica:= !Empty(SF1->F1_STATUS)
Local _cSitu:= IIF(_lClassifica,"5","3")

U_QEXPEV('Documento Atualizado no Recebimento', '1', '2', _cSitu)

Return
