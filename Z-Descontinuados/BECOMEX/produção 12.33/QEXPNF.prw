#INCLUDE "Protheus.ch"
#INCLUDE "Topconn.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "fileio.ch"
#INCLUDE "Rwmake.ch"

User Function QEXPNF(pDias)
    Local   aSay     := {'Exportar NF Dfe'}
    Local   aButton  := {}
    Local   aMarcadas:= {}
    Local   cTitulo  := 'Exportar NF Dfe'
    Local   lOk      := .F.
    Local dDataIni := STOD("")
    Local dDataFim := STOD("")
    Private oMainWnd  := NIL
    Private oProcess  := NIL

    #IFDEF TOP
        TCInternal( 5, '*OFF' ) // Desliga Refresh no Lock do Top
    #ENDIF

    __cInterNet := NIL
    __lPYME     := .F.

    Set Dele On

    If pDias != NIL
        Define MSDialog  oDlg Title '' From 0, 0 To 270, 396 Pixel
        oDlg:cTitle := 'Selecione o periodo para geração:'

        @ 10,10 Say  oSay Prompt 'Data Inicial' Size  40, 08 Of oDlg Pixel

        @ 20,10 MSGET oData VAR dDataIni ;
            PICTURE "@D" SIZE 20, 10 OF oDlg PIXEL HASBUTTON

        @ 35,10 Say  oSay Prompt 'Data Final' Size  40, 08 Of oDlg Pixel

        @ 45,10 MSGET oData VAR dDataFim ;
            PICTURE "@D" SIZE 20, 10 OF oDlg PIXEL HASBUTTON

        Define SButton From 111, 125 Type 1 Action ( lOk := .T., oDlg:End() )  Enable Of oDlg
        Define SButton From 111, 158 Type 2 Action ( lOk := .F., oDlg:End() ) OnStop 'Abandona a Seleção' Enable Of oDlg

        ACTIVATE DIALOG oDlg CENTERED
    else
        dDataIni := DTOS(DaySub(DATE(),PDias))
        dDataFim := DTOS(DATE())
    endif

    If lOk

        RpcSetType( 3 )
        RpcSetEnv( "99", "01" )
        InitPublic()
        SetsDefault()
        SetModulo( "SIGACOM" , "COM" )

        oProcess := MsNewProcess():New( { | lEnd | lOk := FSTProc(dDataIni, dDataFim ) }, 'Atualizando', 'Aguarde, atualizando ...', .F. )
        oProcess:Activate()

        ApMsgNoYes( 'Finalizado' )

        RpcClearEnv()
    EndIf

Return NIL

Static Function FSTProc(dDataIni, dDataFim)

    Local cTipo := ''
    Local cCgc  := ''

    dbSelectArea("SF1")
    dbGoTop()
    oProcess:SetRegua1(SF1->(RECCOUNT()))

    While !Eof()
        oProcess:IncRegua1()

        IF SF1->F1_DTDIGIT < dDataFim .AND. SF1->F1_DTDIGIT > dDataIni
            If ALLTRIM(SF1->F1_ESPECIE) == 'NFS'
                cTipo := '3'
            elseIf ALLTRIM(SF1->F1_ESPECIE) == 'CTE'
                cTipo := '2'
            ELSE
                cTipo := '1'
            Endif

            If SF1->F1_TIPO $ "DB"
                cCgc := POSICIONE('SA1', 1, xFilial('SA1') + SF1->F1_FORNECE+SF1->F1_LOJA, 'A1_CGC')
            else
                cCgc := POSICIONE('SA2', 1, xFilial('SA2') + SF1->F1_FORNECE+SF1->F1_LOJA, 'A2_CGC')
            endif

            U_QEXPEVENTO(SF1->F1_DOC, SF1->F1_SERIE, cCgc, cTipo, 'Geração retroativa de eventos.', '1', '2', '5',SF1->F1_FILIAL, SF1->F1_CHVNFE)
        ENDIF

        DbSelectArea("SF1")
        dbSkip()
    EndDo

Return .T.