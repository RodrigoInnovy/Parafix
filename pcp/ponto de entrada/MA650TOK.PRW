//Envia email para desenvolvimento@parafix quando abrir uma OP com codigo de produto inicado com 8.

#Include "Protheus.ch"
#Include "Ap5Mail.ch"
#INCLUDE "TOPCONN.CH"


User Function MA650TOK
	Local lRet       := .T.
	Local aArea      := GetArea()
	Local aAreaSC2   := SC2->(GetArea())
	Local cProduto   := alltrim(M->C2_PRODUTO)
	Local cProdDesc  := alltrim(Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_DESC"))
	Local cSC2Num    := alltrim(M->C2_NUM)
	Local cPara      := GetNewPar("MV_ZOPMAIL", "")
	Local cAssunto   := "Ordem de Produção com o Produto: " + AllTrim(cProduto) +" - " +Alltrim(CProdDesc)
	Local cHTML      := ""
	Local cDe        := GetMv("MV_RELFROM")
	Local cServer    := GetMv("MV_RELSERV")
	Local cAccount   := GetMv("MV_RELACNT")
	Local cPassword  := GetMv("MV_RELPSW")
	Local lAuth      := GetMv("MV_RELAUTH")
	Local lOk        := .T.
	Local lEnvia     := .T.
	local cRevi 	 := ""
	local cquery     := ""
	local cPossuiQP7 := ""
	local cPossuiQP8 := ""

	If FUNNAME() == 'MATA650' 	
 		cquery := "select MAX(QP6_REVI) as REVI from  QP6010 Where QP6_PRODUT = '"+cProduto+"' and D_E_L_E_T_ = '' "
		TcQuery cQuery New Alias "QRY_AUX"
		dbSelectArea("QRY_AUX")
		cRevi := QRY_AUX->REVI
		QRY_AUX->(dbCloseArea())


		DbSelectArea("QP7")
		DbSetOrder(06) 
			If !DbSeek(xfilial("QP7")+M->C2_PRODUTO+cRevi+M->C2_ROTEIRO)
				cPossuiQP7 := "nao" 
			Else
			Endif

	
		DbSelectArea("QP8") 
		DbSetOrder(01) 
			if!DbSeek(xFilial("QP8")+M->C2_PRODUTO+cRevi+M->C2_ROTEIRO)
			cPossuiQP8 :="nao"
			else
			Endif



			if cPossuiQP7 =="nao" .AND. cPossuiQP8 =='nao'
			MsgAlert("O Produto não possui Roteiro cadastrado dentro da Especificação Qualidade. ", "Atenção")
			lRet := .F.
			else
			Endif 


			DbSelectArea("QQK")
			DbSetOrder(10)
			If !DbSeek(xFilial("QQK")+M->C2_PRODUTO+M->C2_RECURSO)
			MsgAlert("O Produto não possui especificação de qualidade para o recurso informado", "Atenção")
			lRet := .F.
			else
			Endif


		IF (SUBSTR(CProduto,1,1)=="8") 
			If (lEnvia)
				cHTML := '<!doctype html>' + CRLF
				cHTML += '<html>' + CRLF
				cHTML += '' + CRLF
				cHTML += '<body>' + CRLF
				cHTML += '<p> Foi Aberta ou Alterada a Ordem de Produção '+cSC2Num+' com o Produto '+cProduto+' - '+cProdDesc+'</p>' + CRLF
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
	
		Endif
	Endif

	RestArea(aAreaSC2)
	RestArea(aArea)
Return(lRet)



