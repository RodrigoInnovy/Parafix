#Include "Protheus.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SF1100E  º Autor ³Daniel Bragaº Data ³  19/04/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescrição ³ Ponto de Entrada executado na exclusão da Nota Fiscal.     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATA103                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function SF1100E() 

Local lRet   := .T.
				
	If SF1->F1_EST == "EX"
        DbSelectArea("CD5")

		CD5->(dbsetorder(1))
		if CD5->(dbseek( xFilial("CD5") + SF1->( F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA ) , .f. ))			
			do while CD5->(!Eof()) .and. CD5->(CD5_FILIAL+CD5_DOC+CD5_SERIE+CD5_FORNEC+CD5_LOJA) == xFilial("CD5") + SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)
				RecLock("CD5",.f.,.t.)
					CD5->(dbdelete())
				MsUnlock("CD5")
				CD5->(dbskip())
			enddo              
		endIf
	endIF	
	
	If IsInCallStack('A140EstCla')
		//Deleta controle de recebimento (status 2)
		U_DelCtrlRec("3E")
		U_DelCtrlRec("2E") //ESTORNO DE CLASSIFICACAO
	Else
		//Deleta controle de recebimento (status 2)
		U_DelCtrlRec("2") //EXCLUSAO DE DOCUMENTO DE ENTRADA
	EndIf

Return(lRet)