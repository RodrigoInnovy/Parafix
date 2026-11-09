#INCLUDE "Protheus.ch"    
#INCLUDE "rwmake.ch"


User Function AcIE
	private cAux := ""
	private nContA1 := 0
	private nContA2 := 0
	private nContA4 := 0
	Processa({|| U_AcIE1()}, "Atualizando Clientes.......")
	Processa({|| U_AcIE2()}, "Atualizando Fornecedores...")
	Processa({|| U_AcIE3()}, "Atualizando Transportadora...")
return





User Function AcIE1()
//Retira pontos, barra e hifem da Inscrição estadual dos Clientes
dbselectarea("SA1")
SA1->(dbgotop())
While !SA1->(EOF())
	if !Empty(SA1->A1_INSCR)
		cAux := SA1->A1_INSCR
		cAux := strtran(cAux,".","")
		cAux := strtran(cAux,"-","")
		cAux := strtran(cAux,"/","")
		cAux := strtran(cAux,",","")
		if Reclock("SA1",.F.)
			SA1->A1_INSCR := cAux
			nContA1++
		MsUnlock()
		else
			msgAlert("Nao foi possivel travar o registro do cliente "+SA1->A1_NREDUZ)
		endif
	endif
	SA1->(dbskip())
	loop
enddo
SA1->(dbcloseArea())
return

User Function AcIE2()
//Retira pontos, barra e hifem da Inscrição estadual dos fornecedores
dbselectarea("SA2")
SA2->(dbgotop())
While !SA2->(EOF())
	if !Empty(SA2->A2_INSCR)
		cAux := SA2->A2_INSCR
		cAux := strtran(cAux,".","")
		cAux := strtran(cAux,"-","")
		cAux := strtran(cAux,"/","")
		cAux := strtran(cAux,",","")
		if Reclock("SA2",.F.)
			SA2->A2_INSCR := cAux
			nContA2++
		MsUnlock()
		else
			msgAlert("Nao foi possivel travar o registro do Fornecedor "+SA2->A2_NREDUZ)
		endif
	endif
	SA2->(dbskip())
	loop
enddo
SA2->(dbcloseArea())
return

User Function AcIE3()
//Retira pontos, barra e hifem da Inscrição estadual das transportadoras
dbselectarea("SA4")
SA4->(dbgotop())
While !SA4->(EOF())
	if !Empty(SA4->A4_INSEST)
		cAux := SA4->A4_INSEST
		cAux := strtran(cAux,".","")
		cAux := strtran(cAux,"-","")
		cAux := strtran(cAux,"/","")
		cAux := strtran(cAux,",","")
		if Reclock("SA4",.F.)
			SA4->A4_INSEST := cAux
			nContA4++
		MsUnlock()
		else
			msgAlert("Nao foi possivel travar o registro da Transportadora "+SA4->A4_NREDUZ)
		endif
	endif
	SA4->(dbskip())
	loop
enddo
SA4->(dbcloseArea())
msgAlert(alltrim(str(nContA1))+" Registros de Clientes Alterados")
msgAlert(alltrim(str(nContA2))+" Registros de Fornecedores Alterados")
msgAlert(alltrim(str(nContA4))+" Registros de Transportadoras Alterados")
return
