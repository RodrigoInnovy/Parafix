#include "PROTHEUS.CH"
#include "Ap5Mail.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o   ³gEnviaEmail³ Autor ³     Felipe Braga      ³ Data ³ 05.10.12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o³ FUNCAO QUE FAZ ENVIO DE EMAIL                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function gEnviaEmail(cFrom,cAssunto, cMsg, cPara, aCc, aBcc, cFiles)

Private cPass    := Alltrim(GetMv("MV_RELPSW"))
Private cAccount := Alltrim(GetMv("MV_RELACNT"))
Private cServer  := Alltrim(GetMv("MV_RELSERV"))
Private nStart
Private cFrom	 := cAccount
Default cFiles	 := IIf(valtype(cFiles) == "U","",cFiles)

//CONNECT SMTP SERVER cServer ACCOUNT cAccount PASSWORD cPass Result lConectou
lResulConn := MailSmtpOn( cServer, cAccount, cPass)
If !lResulConn
	//GET MAIL ERROR cError
	cError := MailGetErr()
	MsgAlert("Falha na conexao "+cError)

	Return(.F.)
Endif

// Autenticação do e-mail
If !MailAuth( cAccount, cPass )
	FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","Falha na autenticação do Usuário!", 0, (nStart - Seconds()), {})
Else
    FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","Conectado com servidor de E-Mail - " + cServer, 0, (nStart - Seconds()), {})
	
Endif

/*substitiur por  lEnviado = MailSend(cFrom, {cTo},{aCc},{aBcc}, cAssunto, cBody, aFiles,.F.) 
SEND MAIL FROM cDe ;
TO cPara ;
SUBJECT cAssunto ;
BODY cMsg ;
RESULT lEnviado ;
ATTACHMENT cFiles*/
//			MailSend(cFrom, aTo, aCc,aBcc, cSubject, cBody, aFiles, lText)
lEnviado := MailSend( cFrom, {cPara}, {aCc}, {aBcc}, cAssunto, cMsg, {cFiles},.T.)

//DISCONNECT SMTP SERVER
MailSmtpOff()

If lEnviado
	FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","e-mail enviado para "+cPara, 0, (nStart - Seconds()), {})
Else
	cMensagem := MailGetErr()
	//GET MAIL ERROR cMensagem
	cMensagem += ". E-mail: "+cPara
	FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01",cMensagem, 0, (nStart - Seconds()), {})
Endif

Return lEnviado

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³gPopEmail ³ Autor ³ Felipe Braga          ³ Data ³ 13.09.11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ FUNCAO QUE RECEBE ANEXO EMAIL CONTA ESPECIFICA             ³±±
±±³			 ³ Param1 - Execucao por JOB				                  ³±±
±±³			 ³ Param2 - Conta de Email					                  ³±±
±±³			 ³ Param3 - Senha de Email					                  ³±±
±±³			 ³ Param4 - Diretorio que sera gravado os Anexos              ³±±
±±³			 ³ Param5 - Filtra por extensao o Anexo, OU * PARA TODOS      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function gPopEmail(_lJob, cEmail, cPass, cPath, cFilExt )

Local lResulConn := .T.
Local lResulPop := .T.
Local lResult := .T.
Local cError := ""
Local cServer := "pop.suzukimotos.com.br"//AllTrim(GetMV("MV_RELSERV"))
Local cEmail := cEmail
Local cPass := cPass
Local lRelauth := GetMv("MV_RELAUTH")
Local cDe := ""
Local cPara := ""
Local cCc := ""
Local cBcc := ""
Local cAssunto := ""
Local aAnexo := {}
Local cMsg := ""
//Local cPath := "\XmlNfe\"
Local nMsgCount:= 0
Local nNumber := 0
Default _lJob := .F. 

lResulConn := MailPopOn( cServer, cEmail, cPass,5000)

If !lResulConn
	cError := MailGetErr()
	
	If _lJob
		FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01",Padc("Falha na conexao "+cError,80), 0, (nStart - Seconds()), {})
	Else
		MsgAlert("Falha na conexao "+cError)
	Endif
	Return(.F.)
Endif

If lResulConn
	PopMsgCount(@nMsgCount)
	
	For nNumber := 1 to nMsgCount
		lResulPop := MailReceive(nNumber, @cDe, @cPara, @cCc, @cBcc,;
		@cAssunto, @cMsg, @aAnexo , cPath, .F.)
		
		If !lResulPop
			cError := MailGetErr()
			
			If _lJob
				FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01",Padc("Falha no recebimento do e-mail "+cError,80), 0, (nStart - Seconds()), {})
			Else
				MsgAlert("Falha no recebimento do e-mail " + cError)
			Endif
		/*Else //Salvar mensagem de e-mail
		   	cMessage := "DE: "+cDe+CRLF
			cMessage += "PARA: "+cPara+CRLF
			cMessage += "CC: "+cCc+CRLF
			cMessage += "BCC: "+cBcc+CRLF
			cMessage += "ASSUNTO: "+cAssunto+CRLF
			cMessage += "MENSAGEM: "+cMsg+CRLF
			MsgInfo(cMessage,"E-mail Recebido")   */
		Endif
	End-For // Next nNumber
	
	//MOVE XML ANEXOS PARA DIRETORIO RECEBIDOS...
	aEval(Directory(cPath+"*."+cFilExt), { |aFile| CpyFile(cPath,aFile[1]) })

	//APAGA ANEXOS DO DIRETORIO PRINCIPAL
	aEval(Directory(cPath+"*.*"), { |aFile| FERASE(cPath+aFile[1]) })
Else
	If _lJob
		FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01",Padc("Falha na autenticação do e-mail: "+cError,80), 0, (nStart - Seconds()), {})
	Else
		MsgAlert("Falha na autenticação do e-mail:" + cError)
	Endif
Endif

MailPopOff()

IF lResulPop
	If _lJob
		FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01",Padc("E-mails recebidos com sucesso",80), 0, (nStart - Seconds()), {})
	Else
		MsgInfo("E-mail recebidos com sucesso" + cError)
	Endif
Endif
//RETURN lResulPop
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³CpyFile   ³ Autor ³ Felipe Braga	        ³ Data ³ 14.09.11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ FUNCAO COPIAR DENTRO DE UM BLOCO DE CODIGO, EVAL           ³±±
±±³			 | A FUNCAO SEMPRE CRIA O DIRETORIO RECEBIDOS, CASO NAO EXISTA³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function CpyFile(cPath,cFile)

IIf( !ExistDir(cPath+"Recebidos\"), MakeDir(cPath+"Recebidos\"), Nil )
COPY FILE &cPath+cFile TO &cPath+"Recebidos\"+cFile

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³Modelo3	  ³ Autor ³ Wilson			    ³ Data ³ 17/03/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Enchoice e GetDados										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³lRet:=Modelo3(cTitulo,cAlias1,cAlias2,aMyEncho,cLinOk, 	  ³±±
±±³			 ³ cTudoOk,nOpcE,nOpcG,cFieldOk,lVirtual,nLinhas,aAltEnchoice)³±±
±±³			 ³lRet=Retorno .T. Confirma / .F. Abandona	 				  ³±±
±±³			 ³cTitulo=Titulo da Janela 									  ³±±
±±³			 ³cAlias1=Alias da Enchoice							 		  ³±±
±±³			 ³cAlias2=Alias da GetDados									  ³±±
±±³			 ³aMyEncho=Array com campos da Enchoice						  ³±±
±±³			 ³cLinOk=LinOk 												  ³±±
±±³			 ³cTudOk=TudOk 												  ³±±
±±³			 ³nOpcE=nOpc da Enchoice									  ³±±
±±³			 ³nOpcG=nOpc da GetDados									  ³±±
±±³			 ³cFieldOk=validacao para todos os campos da GetDados 		  ³±±
±±³			 ³lVirtual=Permite visualizar campos virtuais na enchoice	  ³±±
±±³			 ³nLinhas=Numero Maximo de linhas na getdados				  ³±±
±±³			 ³aAltEnchoice=Array com campos da Enchoice Alteraveis		  ³±±
±±³			 ³nFreeze=Congelamento das colunas.                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³RdMake 													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MeuModelo3(cTitulo,cAlias1,cAlias2,aMyEncho,cLinOk,cTudoOk,nOpcE,nOpcG,cFieldOk,lVirtual,nLinhas,aAltEnchoice,nFreeze,aButtons,aCordW,nSizeHeader)

Local lRet, nOpca := 0,cSaveMenuh,nReg:=(cAlias1)->(Recno()),oDlg
Local oEnchoice
Local nDlgHeight
Local nGDHeight
Local aSize := {}

Private Altera:=.t.,Inclui:=.t.,lRefresh:=.t.,aTELA:=Array(0,0),aGets:=Array(0),;
bCampo:={|nCPO|Field(nCPO)},nPosAnt:=9999,nColAnt:=9999
Private cSavScrVT,cSavScrVP,cSavScrHT,cSavScrHP,CurLen,nPosAtu:=0

nOpcE := If(nOpcE==Nil,3,nOpcE)
nOpcG := If(nOpcG==Nil,3,nOpcG)
lVirtual := Iif(lVirtual==Nil,.F.,lVirtual)
nLinhas:=Iif(nLinhas==Nil,99,nLinhas)

If SetMDIChild()
	oMainWnd:ReadClientCoors()
	nDlgHeight := 500
	nGDHeight  := oMainWnd:nBottom
Else
	nDlgHeight := 420
	nGDHeight  := 70
EndIf

aCordW := {135,000,nDlgHeight,632}
nSizeHeader := 110

Aadd(aSize,nSizeHeader)

DEFINE MSDIALOG oDlg TITLE cTitulo From aCordW[1],aCordW[2] to aCordW[3],aCordW[4] Pixel of oMainWnd

aPosEnch := {,,(oDlg:nClientHeight - 4)/2,}
oEnchoice := Msmget():New(cAlias1,nReg,nOpcE,,,,aMyEncho,aPosEnch,aAltEnchoice,3,,,,,,lVirtual,,,,,,,,.T.)
//oEnchoice:oBox:align := CONTROL_ALIGN_ALLCLIENT
oGetDados := MsGetDados():New(75,1,nGDHeight,315,nOpcG,cLinOk,cTudoOk,"",.T.,,nFreeze,,nLinhas,cFieldOk)

ACTIVATE MSDIALOG oDlg ON INIT (EnchoiceBar(oDlg,{||nOpca:=1,If(oGetDados:TudoOk(),If(!obrigatorio(aGets,aTela),nOpca := 0,oDlg:End()),nOpca := 0)},{||oDlg:End()},,aButtons),;
AlignObject(oDlg,{oEnchoice:oBox,oGetDados:oBrowse},1,,aSize),oGetDados:oBrowse:Refresh())
//AlignObject(oDlg,{oEnchoice:oBox,oGetDados:oBrowse},1,,aSize))


lRet:=(nOpca==1)

Return lRet

