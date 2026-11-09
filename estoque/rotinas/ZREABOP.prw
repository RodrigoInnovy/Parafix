#Include "Protheus.ch"
#Include "TopConn.ch"

/*/{Protheus.doc} ZREABOP
Reabre uma Ordem de Producao encerrada (limpa C2_DATRF),
valida o fechamento de estoque (MV_ULMES) e envia log por e-mail
ao usuario logado e aos destinatarios do parametro MV_ZREAOP.
/*/
User Function ZREABOP()
    Local aArea     := GetArea()
    Local aAreaSC2  := SC2->(GetArea())
    Local cOP       := Space(TamSX3("C2_NUM")[1] + TamSX3("C2_ITEM")[1] + TamSX3("C2_SEQUEN")[1])
    Local cMotivo   := Space(100)
    Local oDlg
    Local lConfirma := .F.

    DEFINE MSDIALOG oDlg TITLE "Reabrir Ordem de Producao" FROM 000,000 TO 200,420 PIXEL

    @ 010,010 SAY "Ordem de Producao (Num+Item+Seq):" SIZE 150,010 OF oDlg PIXEL
    @ 022,010 MSGET cOP F3 "SC2" SIZE 100,010 OF oDlg PIXEL

    @ 040,010 SAY "Motivo da reabertura:" SIZE 150,010 OF oDlg PIXEL
    @ 052,010 MSGET cMotivo SIZE 190,010 OF oDlg PIXEL

    @ 080,050 BUTTON "Reabrir"  SIZE 050,014 OF oDlg PIXEL ACTION (lConfirma := .T., oDlg:End())
    @ 080,115 BUTTON "Cancelar" SIZE 050,014 OF oDlg PIXEL ACTION oDlg:End()

    ACTIVATE MSDIALOG oDlg CENTERED

    If lConfirma
        If Empty(cOP)
            MsgAlert("Informe a Ordem de Producao.", "Atencao")
        ElseIf Empty(cMotivo)
            MsgAlert("Informe o motivo da reabertura.", "Atencao")
        Else
            Processa({|| ZReabreOP(AllTrim(cOP), AllTrim(cMotivo)) }, "Reabrindo OP...")
        EndIf
    EndIf

    RestArea(aAreaSC2)
    RestArea(aArea)
Return

Static Function ZReabreOP(cOP, cMotivo)
    Local cChave   := xFilial("SC2") + cOP
    Local dUlMes   := SuperGetMV("MV_ULMES", .F., CToD("  /  /  "))
    Local dDatrfAn := CToD("  /  /  ")
    Local cStatAn  := ""
    Local cStatNov := ""
    Local lOk      := .F.

    DbSelectArea("SC2")
    SC2->(DbSetOrder(1)) // C2_FILIAL + C2_NUM + C2_ITEM + C2_SEQUEN + C2_ITEMGRD

    If !SC2->(DbSeek(cChave))
        MsgStop("OP " + cOP + " nao encontrada.", "Erro")
        Return
    EndIf

    If Empty(SC2->C2_DATRF)
        MsgInfo("A OP " + cOP + " nao esta encerrada.", "Informacao")
        Return
    EndIf

    // Valida fechamento de estoque: data da OP deve ser posterior ao MV_ULMES
    If SC2->C2_DATRF <= dUlMes
        MsgStop("Nao e possivel reabrir a OP " + cOP + "." + CRLF + CRLF + ;
                "Data de encerramento da OP: " + DToC(SC2->C2_DATRF) + CRLF + ;
                "Ultimo fechamento de estoque (MV_ULMES): " + DToC(dUlMes) + CRLF + CRLF + ;
                "O periodo ja esta fechado.", "Mes fechado")
        Return
    EndIf

    // Guarda valores anteriores para o log
    dDatrfAn := SC2->C2_DATRF
    cStatAn  := SC2->C2_STATUS

    Begin Transaction
        RecLock("SC2", .F.)
            SC2->C2_DATRF := CToD("  /  /  ")

            If SC2->C2_QUJE < SC2->C2_QUANT
                SC2->C2_STATUS := IIf(SC2->C2_QUJE > 0, "U", "N")
            EndIf
        SC2->(MsUnlock())

        cStatNov := SC2->C2_STATUS
        lOk := .T.
    End Transaction

    If lOk
        ZEnvLogOP(cOP, cMotivo, DToC(dDatrfAn), cStatAn, cStatNov, DToC(dUlMes))
        MsgInfo("OP " + cOP + " reaberta com sucesso.", "Sucesso")
    EndIf
Return

/*/{Protheus.doc} ZEnvLogOP
Monta e envia o log da reabertura ao usuario logado e ao MV_ZREAOP.
/*/
Static Function ZEnvLogOP(cOP, cMotivo, cDatrfAn, cStatAn, cStatNov, cUlMes)
    Local cPara    := ZMontaDest()
    Local cAssunto := "Log - Reabertura de OP " + cOP
    Local cHtml    := ""
    Local cErro    := ""

    If Empty(cPara)
        MsgAlert("Nenhum destinatario encontrado (e-mail do usuario e MV_ZREAOP vazios). O log nao foi enviado.", "Atencao")
        Return .F.
    EndIf

    cHtml := '<html><body style="font-family:Arial,sans-serif;font-size:13px;color:#333;">'
    cHtml += '<h3 style="color:#1F4E79;">Reabertura de Ordem de Producao</h3>'
    cHtml += '<table border="1" cellpadding="6" cellspacing="0" style="border-collapse:collapse;">'
    cHtml += '<tr><td><b>OP</b></td><td>' + cOP + '</td></tr>'
    cHtml += '<tr><td><b>Empresa / Filial</b></td><td>' + cEmpAnt + ' / ' + cFilAnt + '</td></tr>'
    cHtml += '<tr><td><b>Usuario</b></td><td>' + AllTrim(cUserName) + '</td></tr>'
    cHtml += '<tr><td><b>Data/Hora</b></td><td>' + DToC(Date()) + ' ' + Time() + '</td></tr>'
    cHtml += '<tr><td><b>Motivo</b></td><td>' + cMotivo + '</td></tr>'
    cHtml += '<tr><td><b>C2_DATRF anterior</b></td><td>' + cDatrfAn + '</td></tr>'
    cHtml += '<tr><td><b>Ultimo fechamento (MV_ULMES)</b></td><td>' + cUlMes + '</td></tr>'
    cHtml += '<tr><td><b>C2_STATUS anterior</b></td><td>' + AllTrim(cStatAn) + '</td></tr>'
    cHtml += '<tr><td><b>C2_STATUS atual</b></td><td>' + AllTrim(cStatNov) + '</td></tr>'
    cHtml += '</table>'
    cHtml += '<p style="font-size:11px;color:#888;">Mensagem automatica gerada pela rotina ZREABOP.</p>'
    cHtml += '</body></html>'

    If !ZSendMail(cPara, cAssunto, cHtml, @cErro)
        MsgAlert("Falha ao enviar e-mail de log: " + cErro, "Atencao")
        Return .F.
    EndIf
Return .T.

/*/{Protheus.doc} ZMontaDest
Junta o e-mail do usuario logado com os destinatarios do MV_ZREAOP,
sem duplicar enderecos.
/*/
Static Function ZMontaDest()
    Local cEmailUsr := ZEmailUsr()
    Local cParam    := AllTrim(SuperGetMV("MV_ZREAOP", .F., ""))
    Local cPara     := cEmailUsr
    Local aParam    := {}
    Local nI        := 0
    Local cEnd      := ""

    If !Empty(cParam)
        aParam := StrTokArr(StrTran(cParam, ",", ";"), ";")
        For nI := 1 To Len(aParam)
            cEnd := AllTrim(aParam[nI])
            If !Empty(cEnd) .And. !(Upper(cEnd) $ Upper(cPara))
                cPara += IIf(Empty(cPara), "", ";") + cEnd
            EndIf
        Next nI
    EndIf
Return cPara

/*/{Protheus.doc} ZEmailUsr
Retorna o e-mail cadastrado para o usuario logado.
/*/
Static Function ZEmailUsr()
    Local cEmail := ""
    Local aInfo  := {}

    PswOrder(1) // Busca por ID
    If PswSeek(__cUserID, .T.)
        aInfo  := PswRet(1)
        cEmail := AllTrim(aInfo[1][14]) // posicao 14 = e-mail do usuario
    EndIf
Return cEmail

/*/{Protheus.doc} ZSendMail
Envio de e-mail usando as configuracoes de conta do Protheus (MV_REL*).
/*/
Static Function ZSendMail(cPara, cAssunto, cCorpo, cErro)
    Local oServer   := Nil
    Local oMessage  := Nil
    Local cServer   := AllTrim(GetMV("MV_RELSERV"))
    Local cConta    := AllTrim(GetMV("MV_RELACNT"))
    Local cSenha    := AllTrim(GetMV("MV_RELPSW"))
    Local cFrom     := AllTrim(GetMV("MV_RELFROM"))
    Local nPorta    := 587
    Local nRet      := 0
    Local nPos      := 0

    // Separa porta se vier no formato servidor:porta
    nPos := At(":", cServer)
    If nPos > 0
        nPorta  := Val(SubStr(cServer, nPos + 1))
        cServer := SubStr(cServer, 1, nPos - 1)
    EndIf

    If Empty(cFrom)
        cFrom := cConta
    EndIf

    oServer := TMailManager():New()
    oServer:SetUseTLS(.T.) // ajuste para SSL/TLS conforme seu provedor
    oServer:Init("", cServer, cConta, cSenha, 0, nPorta)

    nRet := oServer:SMTPConnect()
    If nRet <> 0
        cErro := oServer:GetErrorString(nRet)
        Return .F.
    EndIf

    nRet := oServer:SMTPAuth(cConta, cSenha)
    If nRet <> 0
        cErro := oServer:GetErrorString(nRet)
        oServer:SMTPDisconnect()
        Return .F.
    EndIf

    oMessage := TMailMessage():New()
    oMessage:Clear()
    oMessage:cFrom    := cFrom
    oMessage:cTo      := cPara
    oMessage:cSubject := cAssunto
    oMessage:cBody    := cCorpo
    oMessage:MsgBodyType("text/html")

    nRet := oMessage:Send(oServer)
    If nRet <> 0
        cErro := oServer:GetErrorString(nRet)
        oServer:SMTPDisconnect()
        Return .F.
    EndIf

    oServer:SMTPDisconnect()
Return .T.
