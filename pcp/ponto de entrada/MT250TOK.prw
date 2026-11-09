#include "Protheus.ch"    

///.==============================================================.
//|                   Tuning Sistemas                            |
//|--------------------------------------------------------------|
//| Programa : SAjustaEmp       | Autor: Clember G. Pinheiro     |
//|--------------------------------------------------------------|
//| Descricao: Ponto de Entrada para Ajustar Empenho quando      |
//|            houver Produção a Maior                           |
//|                                                              |
//|--------------------------------------------------------------|
//| Data criacao  : 20/04/2016  | Ultima alteracao:              |
//|--------------------------------------------------------------|
//|                                                              |
//.==============================================================.

User Function MT250TOK()
	Local lRet := .T.
	Local aAreaAtu		:= GetArea()
	Local aAreaSD4      := SD4->(GetArea())
	Local aAreaSB2      := SB2->(GetArea())
	Local aAreaSB1      := SB1->(GetArea())
	Local cOP			:= M->D3_OP
	Local cProduto		:= M->D3_COD
	Local nDifOP		:= 0
	Local nApont		:= M->D3_QUANT
	Local nQtdSld		:= 0
	Local nQtdSld2		:= 0
	Local nQtdOri		:= 0
	Local nFatConv		:= ""
	Local cTipConv		:= ""
	Local nSldDif       := 0
	Local nQtdDif       := 0
	Local nQtdDif2      := 0
	Local nFator        := 0
	Local nSldNeg       := 0
	Local nSldDisp      := 0
	
	If Empty(M->D3_ZZRECUR)
	    Alert("Preencha o campo Recurso")
		Return(.F.)
	EndIf
	
	
	If  M->D3_QUANT > (SC2->C2_QUANT - SC2->C2_QUJE)
		
		If !MsgYesNo("Quantidade Informada excede o Saldo da OP, Confirma Produção a Maior?","Processamento","ATENCAO")
			Return(.T.)
		EndIf
		
		// Verifica se existe saldo suficiente no SB2
		dbSelectArea("SD4")
		SD4->(dbSetOrder(2))
		SD4->(dbSeek(xfilial("SD4")+cOP))
		if SD4->(dbSeek(xfilial("SD4")+cOP))
			While SD4->(!eof()) .and. SD4->D4_FILIAL+SD4->D4_OP == xFilial("SD4")+cOP
				
				If SD4->D4_ZZQORIG = 0
					recLock("SD4",.F.)
					SD4->D4_ZZQORIG := SD4->D4_QTDEORI
					SD4->(msUnlock())
				EndIf

				dbSelectArea("SB1")
				SB1->(dbSetOrder(1))
				SB1->(dbSeek(xFilial("SB1")+SD4->D4_COD))
				
				If SB1->B1_TIPO <> "MO"
				
					nFator  := SD4->D4_ZZQORIG / SC2->C2_QUANT     // Calcula o fator de consumo atraves do empenho
					nQtdOri := (SC2->C2_QUJE + nApont) * nFator    // Quantidade original do empenho a ser calculado
					nQtdSld := nApont * nFator                     // Quantidade do saldo do empenho a ser calculado para requisicao
					
					dbSelectArea("SB2")
					SB2->(dbSetOrder(1))
					SB2->(dbSeek(xFilial("SB2")+SD4->D4_COD+SD4->D4_LOCAL))
					
					nSldDisp  := SaldoSb2(.f.,.f.)
					
					If nQtdSld > nSldDisp
						Alert("O Saldo é Insuficiente para o Produto/Armazém: "+Alltrim(SD4->D4_COD)+" / "+SD4->D4_LOCAL)
						Return(.F.)
					EndIf

				EndIf
				
				SD4->(dbSetOrder(2))
				SD4->(dbSkip())
				
			EndDo
		EndIf
		//--------------------------------------------------------------------------------------------------------------------------------------//
		// Realiza ajuste do empenho caso a quantidade a ser apontada seja maior que o saldo da OP - Tratamento realizado conforme solicitacao  //
		// do Sr. Antonio - Gerente PCP Parafix (21/03/12)                                                                                      //
		//--------------------------------------------------------------------------------------------------------------------------------------//
		dbSelectArea("SD4")
		SD4->(dbSetOrder(2))
		SD4->(dbSeek(xfilial("SD4")+cOP))
		if SD4->(dbSeek(xfilial("SD4")+cOP))
			While SD4->(!eof()) .and. SD4->D4_FILIAL+SD4->D4_OP == xFilial("SD4")+cOP
				
				nFator  := SD4->D4_ZZQORIG / SC2->C2_QUANT     // Calcula o fator de consumo atraves do empenho
				nQtdOri := (SC2->C2_QUJE + nApont) * nFator    // Quantidade original do empenho a ser calculado
				nQtdSld := nApont * nFator                     // Quantidade do saldo do empenho a ser calculado para requisicao
				
				dbSelectArea("SB2")
				SB2->(dbSetOrder(1))
				
				if SB2->(dbSeek(xFilial("SB2")+SD4->D4_COD+SD4->D4_LOCAL))  // Atualiza saldo do empenho na tabela SB2
					recLock("SB2",.F.)
					nSldDif       := nQtdSld - SD4->D4_QUANT
					SB2->B2_QEMP  := SB2->B2_QEMP + nSldDif
					SB2->B2_QEMP2 := SB2->B2_QEMP + ConvUm(SD4->D4_COD,nSldDif,0,2)
					SB2->(msUnlock())
				endif
				
				// Atualiza saldo do empenho na tabela SD4 para requisicao
				recLock("SD4",.F.)
				SD4->D4_QTDEORI := nQtdOri
				SD4->D4_QUANT   := nQtdSld
				SD4->D4_QTSEGUM := ConvUm(SD4->D4_COD,nQtdSld,0,2)
				SD4->(msUnlock())
				
				SD4->(dbSetOrder(2))
				SD4->(dbSkip())
				
			EndDo
		Endif
	Endif
	
	RestArea(aAreaAtu)
	RestArea(aAreaSD4)
	RestArea(aAreaSB2)
	RestArea(aAreaSB1)
	
Return(lRet)
