#Include "Average.ch"

/*
	//	Programa......: EECAF200_rdm.prw
	//	Objetivo......: Gerar Invoice de Exportação por data diferente do EMBARQUE
	//	Autor.........: Fernando Pereira
	//	Data/Hora.....: 12/03/2019 - 11:40
*/

*********************************
User Function EECAF200()
*********************************
Local cParam       := If(Type("PARAMIXB") == "A", ParamIxb[1],ParamIxb)
Local lRet   	   := .t.   
Local dDtRefFin    := CTOD("  /  /  ")
Local cSeekSE1 	   := ""
Local cSeekSE2120  := ""
Local cSeekSE2121  := ""
Local cSeekSE2129  := ""

Private cNREec     :=  EEC->EEC_PREEMB  
Private xdDatInv   :=  Posicione("EXP",1,xFilial("EXP")+cNREec,"EXP_DTINVO")   
//Private xdDatInvBTB:=  Posicione("EXK",1,xFilial("EXK")+cNREec,"EXK_DTEMBA")   
//Private cSIMBMoe   :=  EEC->EEC_MOEDA

********************************
Begin Sequence
*********************************
        
**** conforme solicitado, este ponto de entrada para correção da data de geração de invoices de exportacao
**** para o contas a receber da sequinte maneira:
**** O campo EEC_XGRFIN será base para esta geração. = 1-Dada da Invoice e 2-Data do Embarque 

If !Empty(M->EEC_XGRFIN)

	If M->EEC_XGRFIN  == "1"  
		dDtRefFin := xdDatInv
	Endif   

	If M->EEC_XGRFIN  == "2"
	  If Empty(M->EEC_DTEMBA)         
	    dDtRefFin := xdDatInv // Provisionando Financeiro
	  Else
		dDtRefFin := M->EEC_DTEMBA
	  Endif
	Endif     

	If !empty(dDtRefFin)
	
	Do Case     
	
		Case cParam == "AF200GPARC_ALTDTEMBA" //.or.  cParam == "AF200DPARC_PARCELA_CAMBIO"
				dDTEMBA	   := dDtRefFin    
				cNREec     :=  EEC->EEC_PREEMB  
		
		Case cParam == "PE_GERPARC" .OR. cParam == "AF200STATUS_ALTSTATUS" // "AF200DPARC_PARCELA_CAMBIO" //.OR. cParam == "PE_GERPARC" .OR. cParam == "PE_ALT_PARC"
		                   
		  nTxMoeEEQ := 1
		  
		  cAliasEEQ := GetArea()   
		  
		  DbSelectArea("EEQ")
		  DbSetOrder(1) 
		    If DbSeek(xFilial("EEQ")+cNREec+"01"+"E")
			    While EEQ->EEQ_PREEMB == cNREec
				   EEQ->(RecLock("EEQ",.F.))
				      EEQ->EEQ_EMISSA := dDtRefFin
				       cNRSE1   := EEQ->EEQ_FINNUM
				       If EEQ->EEQ_EVENT == "101"
				          cSeekSE1 := "EEC"+cNRSE1+EEQ->EEQ_PARFIN+"NF "  //EEQ->EEQ_IMPORT+EEQ->EEQ_IMLOJA
				       EnDif         
				       If EEQ->EEQ_EVENT == "120"
				          cSeekSE2120 := "EEC"+cNRSE1+EEQ->EEQ_PARFIN+"NF "  //EEQ->EEQ_IMPORT+EEQ->EEQ_IMLOJA
				       EnDif   
				       If EEQ->EEQ_EVENT == "121"
				          cSeekSE2121 := "EEC"+cNRSE1+EEQ->EEQ_PARFIN+"NF "  //EEQ->EEQ_IMPORT+EEQ->EEQ_IMLOJA
				       EnDif   
				       If EEQ->EEQ_EVENT == "129"
				          cSeekSE2129 := "EEC"+cNRSE1+EEQ->EEQ_PARFIN+"NF "  //EEQ->EEQ_IMPORT+EEQ->EEQ_IMLOJA
				       EnDif   
				   EEQ->(MsUnlock("EEQ"))
				   EEQ->(DbSkip())
				EndDo    
		    Endif              
		
		    RestArea(cAliasEEQ)
		  
			DbSelectArea("SE1")
			DbSetOrder(1)
			If DbSeek(xFilial("SE1")+cSeekSE1)
				SE1->(RecLock("SE1",.F.))
					SE1->E1_EMISSAO := dDtRefFin  
					SE1->E1_FLUXO   := "N" 
			       		  nTxMoeEEQ := RecMoeda(dDtRefFin,SE1->E1_MOEDA) //BuscaTaxa(EEQ->EEQ_MOEDA,dDtRefFin) 
					SE1->E1_TXMOEDA := nTxMoeEEQ    
					SE1->E1_VLCRUZ  := Round(NoRound(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,1,dDtRefFin,3,nTxMoeEEQ),3),2)
					SE1->E1_BASCOM1 := Round(NoRound(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,1,dDtRefFin,3,nTxMoeEEQ),3),2)
					SE1->E1_ORIGEM  := "FINA040" // Por causa da baixa OFF-SHORE 
				SE1->(MsUnlock("SE1"))
		    //nTxEIC := BuscaTaxa(cSIMBMoe,dDtRefFin) 
			Endif                                                          
		             
			*** COMISSAO AGENTE PROV COMISSAO REMET.
			*****************************************
			DbSelectArea("SE2")
			DbSetOrder(1)
			If DbSeek(xFilial("SE2")+cSeekSE2120)
				SE2->(RecLock("SE2",.F.))
					SE2->E2_EMISSAO := dDtRefFin   
					SE2->E2_FLUXO   := "S"
			       		  nTxMoeEEQ := RecMoeda(dDtRefFin,SE2->E2_MOEDA) //BuscaTaxa(EEQ->EEQ_MOEDA,dDtRefFin) 
					SE2->E2_TXMOEDA := nTxMoeEEQ 
					SE2->E2_VLCRUZ  := Round(NoRound(xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,1,dDtRefFin,3,nTxMoeEEQ),3),2)
				SE2->(MsUnlock("SE2"))
		    //nTxEIC := BuscaTaxa(cSIMBMoe,dDtRefFin) 
			Endif                                                          
			***************************
		
			*** COMISSAO AGENTE PROV COMISSAO C GRAF
			*********************************************
			If DbSeek(xFilial("SE2")+cSeekSE2121)
				SE2->(RecLock("SE2",.F.))
					SE2->E2_EMISSAO := dDtRefFin
					SE2->E2_FLUXO   := "S"			   
			       		  nTxMoeEEQ := RecMoeda(dDtRefFin,SE2->E2_MOEDA) //BuscaTaxa(EEQ->EEQ_MOEDA,dDtRefFin) 
					SE2->E2_TXMOEDA := nTxMoeEEQ 
					SE2->E2_VLCRUZ  := Round(NoRound(xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,1,dDtRefFin,3,nTxMoeEEQ),3),2)
				SE2->(MsUnlock("SE2"))
		    //nTxEIC := BuscaTaxa(cSIMBMoe,dDtRefFin) 
			Endif                                                          
		
			*** PAGAMENTO BACK TO BACK fornecedor internacional
			*******************************************************
			If DbSeek(xFilial("SE2")+cSeekSE2129)
				SE2->(RecLock("SE2",.F.))
					SE2->E2_EMISSAO := dDtRefFin
					SE2->E2_FLUXO   := "N"			   
			       		  nTxMoeEEQ := RecMoeda(dDtRefFin,SE2->E2_MOEDA) //BuscaTaxa(EEQ->EEQ_MOEDA,dDtRefFin) 
					SE2->E2_TXMOEDA := nTxMoeEEQ 
					SE2->E2_VLCRUZ  := Round(NoRound(xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,1,dDtRefFin,3,nTxMoeEEQ),3),2)
				SE2->(MsUnlock("SE2"))
		    //nTxEIC := BuscaTaxa(cSIMBMoe,dDtRefFin) 
			Endif
			*******************************************************
		
			If cParam == "PE_GERPARC"
				If Empty(cSeekSE1) .and. M->EEC_CONDPA <> '00011'
					MsgStop("Não Existe Invoice Digitada ! Favor Informar ! "+chr(13)+chr(10)+"Não Serão Gravadas Invoices e Comissões no Financeiro","Aviso !")
				Endif
				If M->EEC_CONDPA == '00011'
					MsgStop("Invoice Sem Cobertura Cambial  ! "+chr(13)+chr(10)+"Não Serão Gravadas Invoices e Comissões no Financeiro","Aviso !")
				Endif
			Endif
		
		  RestArea(cAliasEEQ)
		  
		End Case
	
	Endif

Endif

*********************************
End Sequence
*********************************
	
Return lRet