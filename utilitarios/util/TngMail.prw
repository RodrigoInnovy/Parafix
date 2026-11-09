#include "AP5MAIL.CH"
#include "TOTVS.CH"
#include "PROTHEUS.CH"
#include "RWMAKE.CH"
*************************************************************************************************
// TNGMail 
// Autor: Alessandro Freire
// Descrição: Envia e-mail
//
// Parâmetros
// cAssunto    : Assunto do e-mail
// cMensagem   : Corpo do e-mail
// cMailServer : Servidor de e-mail
// cMailContX  : conta de e-mail
// cMailSenha  : senha da conta 
// cMailDest   : e-mail do destinatário
*************************************************************************************************
User Function TngMail( cAssunto, cMensagem, cMailServer, cMailContX, cMailSenha, cMailDest )

Local lConnect    := .f.
Local lEnv        := .f.
Local lFim        := .f.
Local cMsg        := ""
           
DEFAULT cAssunto    := ""
DEFAULT cMailServer := GETMV("MV_RELSERV")
DEFAULT cMailContX  := cMailContX //Alltrim(GETMV("ZZ_MAILAPR"))
DEFAULT cMailSenha  := cMailSenha //Alltrim(GETMV("ZZ_PSWMAPR"))

CONNECT SMTP SERVER cMailServer ACCOUNT cMailContX PASSWORD cMailSenha RESULT lConnect

IF GetMv("MV_RELAUTH")
	MailAuth( cMailContX, cMailSenha )
EndIF

If (lConnect)  // testa se a conexão foi feita com sucesso
	SEND MAIL FROM cMailContX TO cMailDest SUBJECT cAssunto BODY cMensagem RESULT lEnv
Else
	cMsg := "Não foi possível se conectar a" + CRLF
	cMsg += "Servidor: " + cMailServer + CRLF
	cMsg += "Conta: " + cMailContX + CRLF + CRLF
	cMsg += "O e-mail destinado a " + cMailDest + " não será enviado." + CRLF+CRLF

	MsgInfo(cMsg)
	Return( .f. )
Endif

If ! lEnv
	GET MAIL ERROR cErro
	cMsg := "Não foi possível enviar e-mail para: " + cMailDest + CRLF + CRLF
	cMsg += "Mensagem do servidor" + CRLF
	cMsg += "====================================" + CRLF                    
	cMsg += cErro + CRLF + CRLF

	cMsg += "Configuração do e-mail"	+ CRLF
	cMsg += "====================================" + CRLF
	cMsg += "Mail Server : " + cMailServer + CRLF
	cMsg += "Account : " + cMailContX + CRLF
	cMsg += "MV_RELAUTH : " + IF( GetMv("MV_RELAUTH"), ".T.", ".F." ) + CRLF
	cMsg += "Destino : " + cMailDest
	
	MsgInfo(cMsg)
	cMsg := ""
	Return( .f. )
EndIf

DISCONNECT SMTP SERVER RESULT lFim

Return( .t. )
