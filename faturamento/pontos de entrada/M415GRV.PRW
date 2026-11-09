// Ponto de entrada que faz o envio de email quando cria / altera uma amostra (sample) 
#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"

User Function M415GRV()

Local aArea       := GetArea()//Armazena o ambiente ativo para restaurar ao fim do processo
Local lRet		  := .T.
Local nOpc		  := ParamIxb[1]  //Número da Opção (1 - Inclusão / 2 - Alteração / 3 - Exclusão)
Local cNum        := SCJ->CJ_NUM
Local cStatus     := SCJ->CJ_ZSTATUS
Local cTipo       := SCJ->CJ_ZTIPO
Local cRep        := alltrim(SCJ->CJ_ZREPRES)
Local cEmailRep   := alltrim(SCJ->CJ_ZEMAIL)
Local cCliente    := alltrim(Posicione("SA1",1,xFilial("SA1")+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA,"A1_NREDUZ"))  
Local cEmailApro  := Alltrim(GETMV("MV_AMOSTRA"))
Local cEmailCust  := Alltrim(GETMV("MV_AMOSTR1"))
Local lEmail	  := If ((nOpc == 1 .or. nOpc == 2) .and. cTipo == "A" .or. cTipo =="B",.T.,.F.)
Local cSubject	  := ""
Local cBody		  := "" 
Local cDest		  := ""
Local nTanLin	  := 60
Local cMailContX  := Alltrim(GETMV("ZZ_MAILAPR"))
Local cMailSenha  := Alltrim(GETMV("ZZ_PSWMAPR"))


If lEmail	
	    IF cStatus =="P"
            cDest := cEmailApro
			cSubject := "Aprovação de Amostra"
			cBody := "Amostra Está Pendente de Aprovação." + CRLF
			cBody += REPLICATE("_",nTanLin) + CRLF
			cBody += "Amostra Num.: " + cNum + CRLF
            cBody += "Cliente: " + cCliente + CRLF
            cBody += "Representante: " + cRep
			u_TngMail(cSubject,cBody,,cMailContX,cMailSenha,cDest)
        EndIf

        IF cStatus =="A"
            cDest := cEmailRep+";"+cEmailCust
		    cSubject := "Amostra Aprovada!"
		    cBody := "A Amostra foi Aprovada!" + CRLF
            cBody += "Caro Vendedor(a) / Customer Service, Favor gerar o PDF e Encaminhar para as áreas darem sequência." + CRLF
		    cBody += REPLICATE("_",nTanLin) + CRLF
            cBody += "Amostra Num.: " + cNum + CRLF
            cBody += "Cliente: " + cCliente + CRLF
            cBody += "Representante: " + cRep
		    u_TngMail(cSubject,cBody,,cMailContX,cMailSenha,cDest)
        EndIf
Endif

RestArea(aArea)

Return (lRet)
