#Include "Protheus.ch"

/*/{Protheus.doc} SG1MAIL
Compara a estrutura gravada (SG1) com a estrutura em tela (aCols)
e envia e-mail com as alterações.
Chamar na confirmação da estrutura (antes da gravação).
@param cProd, Caractere, Código do produto pai (G1_COD)
@return lRet, Lógico, .T. sempre (não bloqueia a gravação)
/*/
User Function SG1MAIL(cProd)
    Local aArea     := GetArea()
    Local aAreaSG1  := SG1->(GetArea())
    Local aCandid   := {"G1_QUANT","G1_PERDA","G1_INI","G1_FIM","G1_FIXVAR","G1_OBSERV"}
    Local aCampos   := {}
    Local aOld      := {}
    Local aNewKeys  := {}
    Local aIncl     := {}
    Local aExcl     := {}
    Local aAlt      := {}
    Local nI        := 0
    Local nJ        := 0
    Local nPos      := 0
    Local cComp     := ""
    Local cTrt      := ""
    Local cKey      := ""
    Local aVals     := {}
    Local xOld      := Nil
    Local xNew      := Nil
    Local cDest     := ""
    Local cHtml     := ""
    Local cAssunto  := ""

    Default cProd := ""

    // Só funciona com a GetDados da estrutura carregada em memória
    If Type("aHeader") <> "A" .Or. Type("aCols") <> "A" .Or. Empty(cProd)
        RestArea(aAreaSG1)
        RestArea(aArea)
        Return .T.
    EndIf

    cProd := PadR(cProd, TamSX3("G1_COD")[1])
    cDest := AllTrim(SuperGetMV("MV_XSG1MAI", .F., ""))

    If Empty(cDest)
        ConOut("[SG1MAIL] Parametro MV_XSG1MAI vazio. E-mail nao enviado.")
        RestArea(aAreaSG1)
        RestArea(aArea)
        Return .T.
    EndIf

    // Campos comparáveis (existem na tela e na SG1)
    For nI := 1 To Len(aCandid)
        If GdFieldPos(aCandid[nI], aHeader) > 0 .And. SG1->(FieldPos(aCandid[nI])) > 0
            aAdd(aCampos, aCandid[nI])
        EndIf
    Next nI

    // 1) Estado anterior (gravado na SG1)
    DbSelectArea("SG1")
    SG1->(DbSetOrder(1)) // G1_FILIAL+G1_COD+G1_COMP+G1_TRT
    If SG1->(DbSeek(xFilial("SG1") + cProd))
        While SG1->(!Eof()) .And. SG1->G1_FILIAL == xFilial("SG1") .And. SG1->G1_COD == cProd
            aVals := {}
            For nJ := 1 To Len(aCampos)
                aAdd(aVals, SG1->(FieldGet(FieldPos(aCampos[nJ]))))
            Next nJ
            aAdd(aOld, { AllTrim(SG1->G1_COMP) + "|" + AllTrim(SG1->G1_TRT), aVals, AllTrim(SG1->G1_COMP) })
            SG1->(DbSkip())
        EndDo
    EndIf

    // 2) Estado novo (tela) x anterior
    For nI := 1 To Len(aCols)
        If GdDeleted(nI, aHeader, aCols)
            Loop
        EndIf

        cComp := AllTrim(GdFieldGet("G1_COMP", nI, .F., aHeader, aCols))
        cTrt  := ""
        If GdFieldPos("G1_TRT", aHeader) > 0
            cTrt := AllTrim(GdFieldGet("G1_TRT", nI, .F., aHeader, aCols))
        EndIf
        If Empty(cComp)
            Loop
        EndIf

        cKey := cComp + "|" + cTrt
        aAdd(aNewKeys, cKey)

        nPos := aScan(aOld, {|x| x[1] == cKey})
        If nPos == 0
            aAdd(aIncl, { cComp, SG1Desc(cComp), ;
                          GdFieldGet("G1_QUANT", nI, .F., aHeader, aCols) })
        Else
            For nJ := 1 To Len(aCampos)
                xOld := aOld[nPos][2][nJ]
                xNew := GdFieldGet(aCampos[nJ], nI, .F., aHeader, aCols)
                If !SG1Igual(xOld, xNew)
                    aAdd(aAlt, { cComp, SG1Desc(cComp), ;
                                 GetSx3Cache(aCampos[nJ], "X3_TITULO"), xOld, xNew })
                EndIf
            Next nJ
        EndIf
    Next nI

    // 3) Itens excluídos (existiam e não estão mais na tela)
    For nI := 1 To Len(aOld)
        If aScan(aNewKeys, {|x| x == aOld[nI][1]}) == 0
            aAdd(aExcl, { aOld[nI][3], SG1Desc(aOld[nI][3]), aOld[nI][2][1] })
        EndIf
    Next nI

    // 4) Envia somente se houve alteração
    If Len(aIncl) + Len(aExcl) + Len(aAlt) > 0
        cAssunto := "Alteracao na Estrutura de Produto: " + AllTrim(cProd) + ;
                    " - Filial " + cFilAnt
        cHtml    := SG1Html(cProd, aIncl, aExcl, aAlt)
        SG1Send(cDest, cAssunto, cHtml)
    EndIf

    RestArea(aAreaSG1)
    RestArea(aArea)
Return .T.

//--------------------------------------------------------------
// Auxiliares
//--------------------------------------------------------------
Static Function SG1Desc(cCod)
Return AllTrim(Posicione("SB1", 1, xFilial("SB1") + PadR(cCod, TamSX3("B1_COD")[1]), "B1_DESC"))

Static Function SG1Igual(xA, xB)
    If ValType(xA) <> ValType(xB)
        Return .F.
    EndIf
    If ValType(xA) == "C"
        Return AllTrim(xA) == AllTrim(xB)
    EndIf
Return xA == xB

Static Function SG1Fmt(xVal)
    Local cRet := ""
    Do Case
        Case ValType(xVal) == "D"
            cRet := IIf(Empty(xVal), "-", DToC(xVal))
        Case ValType(xVal) == "N"
            cRet := AllTrim(Transform(xVal, "@E 999,999,999.999999"))
        Case ValType(xVal) == "C"
            cRet := IIf(Empty(xVal), "-", AllTrim(xVal))
        OtherWise
            cRet := AllTrim(cValToChar(xVal))
    EndCase
Return cRet

Static Function SG1Html(cProd, aIncl, aExcl, aAlt)
    Local cH   := ""
    Local cTh  := "style='background:#1F4E79;color:#fff;padding:6px;border:1px solid #ccc;text-align:left;'"
    Local cTd  := "style='padding:6px;border:1px solid #ccc;'"
    Local cAss := SuperGetMV("MV_XSG1ASS", .F., "")
    Local nI   := 0

    cH += "<html><body style='font-family:Arial,sans-serif;font-size:13px;'>"
    cH += "<h3>Estrutura de Produto alterada</h3>"
    cH += "<p><b>Produto:</b> " + AllTrim(cProd) + " - " + SG1Desc(cProd) + "<br>"
    cH += "<b>Filial:</b> " + cFilAnt + "<br>"
    cH += "<b>Usuario:</b> " + AllTrim(cUserName) + "<br>"
    cH += "<b>Data/Hora:</b> " + DToC(Date()) + " " + Time() + "</p>"

    If Len(aIncl) > 0
        cH += "<h4>Componentes incluidos</h4><table style='border-collapse:collapse;'>"
        cH += "<tr><th " + cTh + ">Componente</th><th " + cTh + ">Descricao</th><th " + cTh + ">Quantidade</th></tr>"
        For nI := 1 To Len(aIncl)
            cH += "<tr><td " + cTd + ">" + aIncl[nI][1] + "</td><td " + cTd + ">" + aIncl[nI][2] + ;
                  "</td><td " + cTd + ">" + SG1Fmt(aIncl[nI][3]) + "</td></tr>"
        Next nI
        cH += "</table>"
    EndIf

    If Len(aExcl) > 0
        cH += "<h4>Componentes excluidos</h4><table style='border-collapse:collapse;'>"
        cH += "<tr><th " + cTh + ">Componente</th><th " + cTh + ">Descricao</th><th " + cTh + ">Quantidade anterior</th></tr>"
        For nI := 1 To Len(aExcl)
            cH += "<tr><td " + cTd + ">" + aExcl[nI][1] + "</td><td " + cTd + ">" + aExcl[nI][2] + ;
                  "</td><td " + cTd + ">" + SG1Fmt(aExcl[nI][3]) + "</td></tr>"
        Next nI
        cH += "</table>"
    EndIf

    If Len(aAlt) > 0
        cH += "<h4>Componentes alterados</h4><table style='border-collapse:collapse;'>"
        cH += "<tr><th " + cTh + ">Componente</th><th " + cTh + ">Descricao</th><th " + cTh + ">Campo</th>"
        cH += "<th " + cTh + ">De</th><th " + cTh + ">Para</th></tr>"
        For nI := 1 To Len(aAlt)
            cH += "<tr><td " + cTd + ">" + aAlt[nI][1] + "</td><td " + cTd + ">" + aAlt[nI][2] + ;
                  "</td><td " + cTd + ">" + AllTrim(aAlt[nI][3]) + "</td><td " + cTd + ">" + SG1Fmt(aAlt[nI][4]) + ;
                  "</td><td " + cTd + ">" + SG1Fmt(aAlt[nI][5]) + "</td></tr>"
        Next nI
        cH += "</table>"
    EndIf

    cH += "<br><hr>" + cAss
    cH += "</body></html>"
Return cH

Static Function SG1Send(cTo, cSubject, cBody)
    Local oServer  := TMailManager():New()
    Local oMsg     := TMailMessage():New()
    Local cServer  := AllTrim(SuperGetMV("MV_RELSERV", .F., ""))
    Local cUser    := AllTrim(SuperGetMV("MV_RELACNT", .F., ""))
    Local cPass    := AllTrim(SuperGetMV("MV_RELPSW" , .F., ""))
    Local cFrom    := AllTrim(SuperGetMV("MV_RELFROM", .F., cUser))
    Local lAuth    := SuperGetMV("MV_RELAUTH", .F., .T.)
    Local lTLS     := SuperGetMV("MV_RELTLS" , .F., .F.)
    Local lSSL     := SuperGetMV("MV_RELSSL" , .F., .F.)
    Local nPort    := 587
    Local nAt      := At(":", cServer)
    Local nErr     := 0
    Local lOk      := .F.

    If nAt > 0
        nPort   := Val(SubStr(cServer, nAt + 1))
        cServer := SubStr(cServer, 1, nAt - 1)
    EndIf

    oServer:SetUseSSL(lSSL)
    oServer:SetUseTLS(lTLS)

    nErr := oServer:Init("", cServer, cUser, cPass, 0, nPort)
    If nErr <> 0
        ConOut("[SG1MAIL] Init: " + oServer:GetErrorString(nErr))
        Return .F.
    EndIf

    oServer:SetSmtpTimeOut(60)

    nErr := oServer:SmtpConnect()
    If nErr <> 0
        ConOut("[SG1MAIL] SmtpConnect: " + oServer:GetErrorString(nErr))
        Return .F.
    EndIf

    If lAuth
        nErr := oServer:SmtpAuth(cUser, cPass)
        If nErr <> 0
            ConOut("[SG1MAIL] SmtpAuth: " + oServer:GetErrorString(nErr))
            oServer:SmtpDisconnect()
            Return .F.
        EndIf
    EndIf

    oMsg:Clear()
    oMsg:cFrom    := cFrom
    oMsg:cTo      := cTo
    oMsg:cSubject := cSubject
    oMsg:cBody    := cBody   // HTML

    nErr := oMsg:Send(oServer)
    If nErr <> 0
        ConOut("[SG1MAIL] Send: " + oServer:GetErrorString(nErr))
    Else
        lOk := .T.
    EndIf

    oServer:SmtpDisconnect()
Return lOk
