//Envia email para Manutencao quando uma Ordem de Servico for Aberta, Att - Vinicius 05/10/2023

#Include "Protheus.ch"
#Include "Ap5Mail.ch"
#INCLUDE "TOPCONN.CH"


User Function MNTA420P()
	Local lRet       := .T.
	Local aArea      := GetArea()
	Local aAreaSTJ   := STJ->(GetArea())
	Local cMaquina   := alltrim(Posicione("ST9",1,xFilial("ST9")+STJ->TJ_CODBEM,"T9_NOME"))
	Local cServico   := alltrim(Posicione("ST4",1,xFilial("ST4")+STJ->TJ_SERVICO,"T4_NOME"))
	Local cNumero    := alltrim(M->TJ_ORDEM)
	Local cPara      := "manutencao@parafix.com.br"
	Local cAssunto   := "Nova Ordem De Serviço Corretiva - NUMERO: " + AllTrim(cNumero) + " do Operador: " +STJ->TJ_USUARIO
	Local cHTML      := ""
	Local cDe        := GetMv("MV_RELFROM")
	Local cServer    := GetMv("MV_RELSERV")
	Local cAccount   := GetMv("MV_RELACNT")
	Local cPassword  := GetMv("MV_RELPSW")
	Local lAuth      := GetMv("MV_RELAUTH")
	Local lOk        := .T.
	Local lEnvia     := .T.
    Local nOPCX      := ParamIxb[1] // InclusÃ£o, Alteração ou Exclusão

 
    If nOPCX == 3 .AND. TJ_TIPO == 'C01'
			If (lEnvia)
				cHTML := '<!doctype html>' + CRLF
				cHTML += '<html>' + CRLF
				cHTML += '' + CRLF
				cHTML += '<body>' + CRLF
				cHTML += '<p> Foi Aberta Uma Nova Ordem De Servico Corretiva # '+cNumero+' da Maquina: '+cMaquina+' do Modulo: '+cServico+' do Operador: '+STJ->TJ_USUARIO+' </p>' + CRLF
				cHTML += '' + CRLF
				cHTML += '</body>' + CRLF
				cHTML += '</html>' + CRLF

				Connect Smtp Server cServer Account cAccount Password cPassword Result lOk

				If (lOk)
					If (lAuth)
						MailAuth(cAccount, cPassword)
					Endif

					Send Mail From cDe To cPara Subject cAssunto Body cHTML Format Text Result lOk
				Endif

				Disconnect Smtp Server

			Endif
	EndIf
	RestArea(aAreaSTJ)
	RestArea(aArea)
Return(lRet)
