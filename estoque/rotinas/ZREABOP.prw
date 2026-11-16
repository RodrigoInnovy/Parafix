#Include "totvs.ch"

#Define POS_MARCA   1
#Define POS_OP      2
#Define POS_PROD    3
#Define POS_DESC    4
#Define POS_QUANT   5
#Define POS_QUJE    6
#Define POS_EMIS    7
#Define POS_DATPRF  8
#Define POS_DATRF   9
#Define POS_STATUS  10
#Define POS_VALIDA  11
#Define POS_MSG     12

/*/{Protheus.doc} ZREABOP
Reabre Ordens de Producao encerradas (limpa C2_DATRF), validando o
fechamento de estoque (MV_ULMES) e enviando log por e-mail ao usuario
logado e aos destinatarios do parametro MV_ZREAOP.
Modos: individual (uma OP) ou em lote (importacao de arquivo texto,
coluna 1 = numero da OP).
Acesso controlado pelo parametro MV_ZREAUSR (codigos ou logins de
usuario separados por ";").
@type User Function
/*/
User Function ZREABOP()
    Local aArea    := GetArea()
    Local aAreaSC2 := SC2->(GetArea())
    Local nOpcao   := 0

    If !ZTemAcesso()
        RestArea(aAreaSC2)
        RestArea(aArea)
        Return
    EndIf

    nOpcao := Aviso("Reabertura de OP", "Selecione o modo de reabertura:", ;
                    {"Uma OP", "Importar arquivo", "Cancelar"}, 1)

    If nOpcao == 1
        ZTelaUnica()
    ElseIf nOpcao == 2
        ZTelaLote()
    EndIf

    RestArea(aAreaSC2)
    RestArea(aArea)
Return

/*/{Protheus.doc} ZTemAcesso
Verifica se o usuario logado consta no parametro MV_ZREAUSR
(aceita codigo do usuario ou login, separados por ";" ou ",").
/*/
Static Function ZTemAcesso()
    Local lAcesso := ZUsrNoPar("MV_ZREAUSR") .Or. ZUsrNoPar("MV_ZREAMST")

    If !lAcesso
        MsgStop("Usuario " + AllTrim(cUserName) + " sem permissao para reabrir OP." + CRLF + ;
                "Solicite inclusao no parametro MV_ZREAUSR.", "Acesso negado")
    EndIf
Return lAcesso

/*/{Protheus.doc} ZUsrNoPar
Verifica se o usuario logado (codigo ou login) consta no parametro
informado (lista separada por ";" ou ",").
/*/
Static Function ZUsrNoPar(cNomePar)
    Local cParam  := AllTrim(SuperGetMV(cNomePar, .F., ""))
    Local aUsers  := {}
    Local nI      := 0
    Local lAchou  := .F.
    Local cItem   := ""

    If !Empty(cParam)
        aUsers := StrTokArr(StrTran(cParam, ",", ";"), ";")
        For nI := 1 To Len(aUsers)
            cItem := Upper(AllTrim(aUsers[nI]))
            If cItem == Upper(AllTrim(__cUserID)) .Or. cItem == Upper(AllTrim(cUserName))
                lAchou := .T.
                Exit
            EndIf
        Next nI
    EndIf
Return lAchou

/*/{Protheus.doc} ZDataFech
Retorna a data de fechamento a ser validada. Usuario master
(parametro MV_ZREAMST) nao valida MV_ULMES: retorna data vazia.
/*/
Static Function ZDataFech()
    Local dUlMes := CToD("  /  /  ")

    If !ZUsrNoPar("MV_ZREAMST")
        dUlMes := SuperGetMV("MV_ULMES", .F., CToD("  /  /  "))
    EndIf
Return dUlMes

/*/{Protheus.doc} ZTxtFech
Texto do fechamento para o log de e-mail.
/*/
Static Function ZTxtFech()
    Local cTxt := DToC(SuperGetMV("MV_ULMES", .F., CToD("  /  /  ")))

    If ZUsrNoPar("MV_ZREAMST")
        cTxt += " (NAO validado - usuario master)"
    EndIf
Return cTxt

/*/{Protheus.doc} ZTelaUnica
Tela de reabertura de uma unica OP.
/*/
Static Function ZTelaUnica()
    Local cOP       := Space(TamSX3("C2_NUM")[1] + TamSX3("C2_ITEM")[1] + TamSX3("C2_SEQUEN")[1])
    Local cMotivo   := Space(100)
    Local oDlg      := Nil
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
            Processa({|| ZReabreUma(AllTrim(cOP), AllTrim(cMotivo)) }, "Reabrindo OP...")
        EndIf
    EndIf
Return

/*/{Protheus.doc} ZReabreUma
Reabre uma unica OP e envia o log.
/*/
Static Function ZReabreUma(cOP, cMotivo)
    Local dUlMes := ZDataFech()
    Local cMsg   := ""
    Local aLog   := {}

    If !ZValidaOP(cOP, dUlMes, @cMsg)
        MsgStop(cMsg, "Atencao")
        Return
    EndIf

    aAdd(aLog, ZGravaOP())
    ZEnvLogOP(aLog, cMotivo, ZTxtFech())
    MsgInfo("OP " + cOP + " reaberta com sucesso.", "Sucesso")
Return

/*/{Protheus.doc} ZValidaOP
Posiciona a SC2 na OP e valida se pode ser reaberta.
@return logical .T. se valida (SC2 posicionada)
/*/
Static Function ZValidaOP(cOP, dUlMes, cMsg)
    SC2->(DbSetOrder(1)) // C2_FILIAL + C2_NUM + C2_ITEM + C2_SEQUEN + C2_ITEMGRD

    If !SC2->(DbSeek(xFilial("SC2") + cOP))
        cMsg := "OP nao encontrada."
        Return .F.
    EndIf

    If Empty(SC2->C2_DATRF)
        cMsg := "OP nao esta encerrada."
        Return .F.
    EndIf

    If SC2->C2_DATRF <= dUlMes
        cMsg := "Periodo fechado: encerrada em " + DToC(SC2->C2_DATRF) + ;
                " / MV_ULMES " + DToC(dUlMes) + "."
        Return .F.
    EndIf

    cMsg := "OK"
Return .T.

/*/{Protheus.doc} ZGravaOP
Reabre a OP posicionada na SC2.
@return array {OP, Produto, DATRF anterior, Status anterior, Status novo}
/*/
Static Function ZGravaOP()
    Local cOP      := SC2->(C2_NUM + C2_ITEM + C2_SEQUEN)
    Local cDatrfAn := DToC(SC2->C2_DATRF)
    Local cStatAn  := SC2->C2_STATUS
    Local cStatNov := ""

    Begin Transaction
        RecLock("SC2", .F.)
            SC2->C2_DATRF := CToD("  /  /  ")
            If SC2->C2_QUJE < SC2->C2_QUANT
                If SC2->C2_QUJE > 0
                    SC2->C2_STATUS := "U"
                Else
                    SC2->C2_STATUS := "N"
                EndIf
            EndIf
        SC2->(MsUnlock())
        cStatNov := SC2->C2_STATUS
    End Transaction
Return {cOP, AllTrim(SC2->C2_PRODUTO), cDatrfAn, cStatAn, cStatNov}

/*/{Protheus.doc} ZTelaLote
Importa arquivo texto (coluna 1 = OP), exibe para conferencia e reabre em lote.
/*/
Static Function ZTelaLote()
    Local cArquivo  := ""
    Local aDados    := {}
    Local cMotivo   := Space(100)
    Local oDlg      := Nil
    Local oBrw      := Nil
    Local oSayTot   := Nil
    Local lConfirma := .F.
    Local oOk       := LoadBitmap(GetResources(), "LBOK")
    Local oNo       := LoadBitmap(GetResources(), "LBNO")
    Local aHeader   := {" ", "OP", "Produto", "Descricao", "Qtd.Prevista", "Qtd.Produzida", ;
                        "Emissao", "Prev.Termino", "Encerramento", "Status", "Situacao"}
    Local aSizes    := {15, 55, 60, 110, 50, 50, 40, 40, 40, 30, 150}

    cArquivo := cGetFile("Arquivo texto|*.txt;*.csv", "Selecione o arquivo de OPs", 0, "C:\", .T., GETF_LOCALHARD + GETF_NETWORKDRIVE, .F.)
    If Empty(cArquivo)
        Return
    EndIf

    Processa({|| aDados := ZLeArquivo(cArquivo) }, "Lendo arquivo...")

    If Empty(aDados)
        MsgAlert("Nenhuma OP encontrada no arquivo.", "Atencao")
        Return
    EndIf

    DEFINE MSDIALOG oDlg TITLE "Reabertura de OP em lote - Conferencia" FROM 000,000 TO 520,1000 PIXEL

    oBrw := TWBrowse():New(005, 005, 490, 195,, aHeader, aSizes, oDlg,,,,,,,,,,,, .F.,, .T.,, .F.,,,)
    oBrw:SetArray(aDados)
    oBrw:bLine := {|| ZLinhaBrw(aDados, oBrw:nAt, oOk, oNo) }
    oBrw:bLDblClick := {|| ZMarca(aDados, oBrw:nAt, oSayTot), oBrw:Refresh() }

    @ 205,005 SAY oSayTot VAR ZTotais(aDados) SIZE 490,010 OF oDlg PIXEL COLOR CLR_BLUE

    @ 220,005 SAY "Motivo da reabertura:" SIZE 080,010 OF oDlg PIXEL
    @ 218,075 MSGET cMotivo SIZE 250,010 OF oDlg PIXEL

    @ 240,005 BUTTON "Marcar/Desmarcar todos" SIZE 080,014 OF oDlg PIXEL ;
        ACTION (ZMarcaTodos(aDados, oSayTot), oBrw:Refresh())
    @ 240,350 BUTTON "Reabrir marcadas" SIZE 070,014 OF oDlg PIXEL ;
        ACTION (lConfirma := ZConfLote(aDados, cMotivo), ZFechaDlg(lConfirma, oDlg))
    @ 240,425 BUTTON "Cancelar" SIZE 070,014 OF oDlg PIXEL ACTION oDlg:End()

    ACTIVATE MSDIALOG oDlg CENTERED

    If lConfirma
        Processa({|| ZReabreLote(aDados, AllTrim(cMotivo)) }, "Reabrindo OPs...")
    EndIf
Return

/*/{Protheus.doc} ZLeArquivo
Le o arquivo texto e monta o array de conferencia.
Separadores aceitos na linha: ";", "," ou TAB. Linhas duplicadas sao ignoradas.
/*/
Static Function ZLeArquivo(cArquivo)
    Local oFile   := FWFileReader():New(cArquivo)
    Local aDados  := {}
    Local aLidas  := {}
    Local cLinha  := ""
    Local cOP     := ""
    Local cMsg    := ""
    Local lValida := .F.
    Local dUlMes  := ZDataFech()
    Local nTamOP  := TamSX3("C2_NUM")[1] + TamSX3("C2_ITEM")[1] + TamSX3("C2_SEQUEN")[1]

    If !oFile:Open()
        MsgStop("Nao foi possivel abrir o arquivo " + cArquivo, "Erro")
        Return aDados
    EndIf

    While oFile:HasLine()
        IncProc()
        cLinha := StrTran(StrTran(oFile:GetLine(), Chr(9), ";"), ",", ";")
        cOP    := AllTrim(StrTokArr(cLinha + ";", ";")[1])
        cOP    := PadR(StrTran(cOP, '"', ""), nTamOP)

        If Empty(cOP) .Or. aScan(aLidas, cOP) > 0
            Loop
        EndIf
        aAdd(aLidas, cOP)

        lValida := ZValidaOP(AllTrim(cOP), dUlMes, @cMsg)
        If SC2->(Found())
            aAdd(aDados, {lValida, cOP, SC2->C2_PRODUTO, ;
                Posicione("SB1", 1, xFilial("SB1") + SC2->C2_PRODUTO, "B1_DESC"), ;
                SC2->C2_QUANT, SC2->C2_QUJE, SC2->C2_EMISSAO, SC2->C2_DATPRF, ;
                SC2->C2_DATRF, SC2->C2_STATUS, lValida, cMsg})
        Else
            aAdd(aDados, {.F., cOP, "", "", 0, 0, CToD(""), CToD(""), CToD(""), "", .F., cMsg})
        EndIf
    EndDo

    oFile:Close()
Return aDados

/*/{Protheus.doc} ZLinhaBrw
Monta a linha exibida no browse.
/*/
Static Function ZLinhaBrw(aDados, nAt, oOk, oNo)
    Local oImg := oNo

    If aDados[nAt, POS_MARCA]
        oImg := oOk
    EndIf
Return {oImg, aDados[nAt, POS_OP], aDados[nAt, POS_PROD], aDados[nAt, POS_DESC], ;
        Transform(aDados[nAt, POS_QUANT], PesqPict("SC2", "C2_QUANT")), ;
        Transform(aDados[nAt, POS_QUJE], PesqPict("SC2", "C2_QUJE")), ;
        DToC(aDados[nAt, POS_EMIS]), DToC(aDados[nAt, POS_DATPRF]), ;
        DToC(aDados[nAt, POS_DATRF]), aDados[nAt, POS_STATUS], aDados[nAt, POS_MSG]}

/*/{Protheus.doc} ZMarca
Marca/desmarca uma linha (somente OPs validas).
/*/
Static Function ZMarca(aDados, nAt, oSayTot)
    If aDados[nAt, POS_VALIDA]
        aDados[nAt, POS_MARCA] := !aDados[nAt, POS_MARCA]
    Else
        MsgAlert("OP nao pode ser reaberta: " + aDados[nAt, POS_MSG], "Atencao")
    EndIf
    oSayTot:SetText(ZTotais(aDados))
Return

/*/{Protheus.doc} ZMarcaTodos
Inverte a marcacao de todas as OPs validas.
/*/
Static Function ZMarcaTodos(aDados, oSayTot)
    Local nI := 0

    For nI := 1 To Len(aDados)
        If aDados[nI, POS_VALIDA]
            aDados[nI, POS_MARCA] := !aDados[nI, POS_MARCA]
        EndIf
    Next nI
    oSayTot:SetText(ZTotais(aDados))
Return

/*/{Protheus.doc} ZTotais
Texto do totalizador de linhas.
/*/
Static Function ZTotais(aDados)
    Local nI      := 0
    Local nValida := 0
    Local nMarca  := 0

    For nI := 1 To Len(aDados)
        If aDados[nI, POS_VALIDA]
            nValida++
        EndIf
        If aDados[nI, POS_MARCA]
            nMarca++
        EndIf
    Next nI
Return "Total de linhas: " + cValToChar(Len(aDados)) + ;
       "   |   Validas: " + cValToChar(nValida) + ;
       "   |   Com erro: " + cValToChar(Len(aDados) - nValida) + ;
       "   |   Marcadas p/ reabrir: " + cValToChar(nMarca)

/*/{Protheus.doc} ZConfLote
Valida motivo e marcacao antes de reabrir o lote.
/*/
Static Function ZConfLote(aDados, cMotivo)
    Local nMarca := 0

    aEval(aDados, {|x| nMarca += ZConta(x[POS_MARCA]) })

    If nMarca == 0
        MsgAlert("Nenhuma OP marcada.", "Atencao")
        Return .F.
    EndIf
    If Empty(cMotivo)
        MsgAlert("Informe o motivo da reabertura.", "Atencao")
        Return .F.
    EndIf
Return MsgYesNo("Confirma a reabertura de " + cValToChar(nMarca) + " OP(s)?", "Confirmacao")

Static Function ZConta(lMarca)
    Local nRet := 0

    If lMarca
        nRet := 1
    EndIf
Return nRet

Static Function ZFechaDlg(lConfirma, oDlg)
    If lConfirma
        oDlg:End()
    EndIf
Return

/*/{Protheus.doc} ZReabreLote
Reabre as OPs marcadas (revalidando cada uma) e envia um unico e-mail.
/*/
Static Function ZReabreLote(aDados, cMotivo)
    Local dUlMes := ZDataFech()
    Local aLog   := {}
    Local cErros := ""
    Local cMsg   := ""
    Local nI     := 0

    ProcRegua(Len(aDados))
    For nI := 1 To Len(aDados)
        IncProc("OP " + AllTrim(aDados[nI, POS_OP]))
        If aDados[nI, POS_MARCA]
            If ZValidaOP(AllTrim(aDados[nI, POS_OP]), dUlMes, @cMsg)
                aAdd(aLog, ZGravaOP())
            Else
                cErros += AllTrim(aDados[nI, POS_OP]) + ": " + cMsg + CRLF
            EndIf
        EndIf
    Next nI

    If !Empty(aLog)
        ZEnvLogOP(aLog, cMotivo, ZTxtFech())
    EndIf

    If Empty(cErros)
        MsgInfo(cValToChar(Len(aLog)) + " OP(s) reaberta(s) com sucesso.", "Sucesso")
    Else
        MsgAlert(cValToChar(Len(aLog)) + " OP(s) reaberta(s)." + CRLF + CRLF + ;
                 "Nao reabertas:" + CRLF + cErros, "Atencao")
    EndIf
Return

/*/{Protheus.doc} ZEnvLogOP
Monta e envia o log da reabertura (uma ou varias OPs) ao usuario
logado e ao MV_ZREAOP.
@param aLog array de {OP, Produto, DATRF anterior, Status anterior, Status novo}
/*/
Static Function ZEnvLogOP(aLog, cMotivo, cUlMes)
    Local cPara    := ZMontaDest()
    Local cAssunto := ""
    Local cHtml    := ""
    Local cErro    := ""
    Local nI       := 0

    If Empty(cPara)
        MsgAlert("Nenhum destinatario encontrado (e-mail do usuario e MV_ZREAOP vazios). O log nao foi enviado.", "Atencao")
        Return .F.
    EndIf

    If Len(aLog) == 1
        cAssunto := "Log - Reabertura de OP " + aLog[1, 1]
    Else
        cAssunto := "Log - Reabertura de OPs em lote (" + cValToChar(Len(aLog)) + " OPs)"
    EndIf

    cHtml := '<html><body style="font-family:Arial,sans-serif;font-size:13px;color:#333;">'
    cHtml += '<h3 style="color:#1F4E79;">Reabertura de Ordem de Producao</h3>'
    cHtml += '<table border="1" cellpadding="6" cellspacing="0" style="border-collapse:collapse;">'
    cHtml += '<tr><td><b>Empresa / Filial</b></td><td>' + cEmpAnt + ' / ' + cFilAnt + '</td></tr>'
    cHtml += '<tr><td><b>Usuario</b></td><td>' + AllTrim(cUserName) + '</td></tr>'
    cHtml += '<tr><td><b>Data/Hora</b></td><td>' + DToC(Date()) + ' ' + Time() + '</td></tr>'
    cHtml += '<tr><td><b>Motivo</b></td><td>' + cMotivo + '</td></tr>'
    cHtml += '<tr><td><b>Ultimo fechamento (MV_ULMES)</b></td><td>' + cUlMes + '</td></tr>'
    cHtml += '</table><br>'
    cHtml += '<table border="1" cellpadding="6" cellspacing="0" style="border-collapse:collapse;">'
    cHtml += '<tr style="background:#D9E1F2;"><th>OP</th><th>Produto</th><th>C2_DATRF anterior</th>'
    cHtml += '<th>C2_STATUS anterior</th><th>C2_STATUS atual</th></tr>'
    For nI := 1 To Len(aLog)
        cHtml += '<tr><td>' + aLog[nI, 1] + '</td><td>' + aLog[nI, 2] + '</td><td>' + aLog[nI, 3] + ;
                 '</td><td>' + AllTrim(aLog[nI, 4]) + '</td><td>' + AllTrim(aLog[nI, 5]) + '</td></tr>'
    Next nI
    cHtml += '<tr><td colspan="5"><b>Total de OPs reabertas: ' + cValToChar(Len(aLog)) + '</b></td></tr>'
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
    Local cPara     := ""
    Local aParam    := {}
    Local aDest     := {}
    Local nI        := 0
    Local cEnd      := ""

    // Primeiro os destinatarios do parametro (sem repetir)
    If !Empty(cParam)
        aParam := StrTokArr(StrTran(cParam, ",", ";"), ";")
        For nI := 1 To Len(aParam)
            cEnd := Lower(AllTrim(aParam[nI]))
            If !Empty(cEnd) .And. aScan(aDest, cEnd) == 0
                aAdd(aDest, cEnd)
            EndIf
        Next nI
    EndIf

    // Usuario logado so entra se NAO estiver no parametro
    cEnd := Lower(AllTrim(cEmailUsr))
    If !Empty(cEnd) .And. aScan(aDest, cEnd) == 0
        aAdd(aDest, cEnd)
    EndIf

    For nI := 1 To Len(aDest)
        If nI > 1
            cPara += ";"
        EndIf
        cPara += aDest[nI]
    Next nI
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
