#include "topconn.ch"
#include "protheus.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GQREENTR  ºAutor  ³ Daniel Braga     º Data ³  07/09/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada executado apos gravacao de todos os regis-º±±
±±º          ³ tros de uma nota fiscal de entrada.                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Protheus 10.                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºZapponi   ³Criação da rotina de gravação da tabela CD5                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function GQREENTR()         
            
	If SF1->F1_EST == "EX"
	    DbSelectArea("CD5")
	
		CD5->(dbsetorder(1))
		CD5->(dbseek( xFilial("CD5") + SF1->( F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA ) , .f. ))
		
		do while CD5->(!Eof()) .and. CD5->(CD5_FILIAL+CD5_DOC+CD5_SERIE+CD5_FORNEC+CD5_LOJA) == xFilial("CD5") + SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)
			RecLock("CD5",.f.,.t.)
				CD5->(dbdelete())
			MsUnlock("CD5")
			CD5->(dbskip())
		enddo              
	
		If 	RecLock( "CD5" , .t. )
			CD5->CD5_FILIAL := xFilial("CD5")
			CD5->CD5_DOC    := SF1->F1_DOC
			CD5->CD5_SERIE  := SF1->F1_SERIE
			CD5->CD5_DOCIMP := SF1->F1_WREGDI
			CD5->CD5_TPIMP  := "0"  
			CD5->CD5_ESPEC  := SF1->F1_ESPECIE
			CD5->CD5_BSPIS  := SF1->F1_BASIMP6
			CD5->CD5_ALPIS  := 1.65
			CD5->CD5_VLPIS  := SF1->F1_VALIMP6
			CD5->CD5_BSCOF  := SF1->F1_BASIMP5
			CD5->CD5_ALCOF  := 7.6
			CD5->CD5_VLCOF  := SF1->F1_VALIMP5
			CD5->CD5_FORNEC := SF1->F1_FORNECE
			CD5->CD5_LOJA   := SF1->F1_LOJA  
			CD5->CD5_DTPPIS := SF1->F1_DTDI
			CD5->CD5_DTPCOF := SF1->F1_DTDI        
			CD5->CD5_DTDI   := SF1->F1_DTDI
			CD5->CD5_NDI    := SF1->F1_WREGDI   
			CD5->CD5_UFDES  := SF1->F1_UFDI
			CD5->CD5_LOCDES := SF1->F1_LOCDESE
			CD5->CD5_CODFAB := SF1->F1_FORNECE   
			CD5->CD5_LOCAL  := "0" 
			CD5->(MsUnlock())
		EndIf
	endIf	
		

	// Este tratamento foi feito para atender as notas que retornan do rpocesso de beneciamento
	// Dia 22/04/2020 - Analista Alexandre j. Conselvan - Totvs IP Campinas 
	If SF1->F1_TIPO = 'B' .AND. SF1->F1_FORNECE = '000067'
		U_AdiCtrlRec("1","Aguardando Classificão Fiscal")
		U_AdiCtrlRec("2","Aguardando Lib. C.Q")
		U_AdiCtrlRec("3","Aguardando Fracionamento")
		U_AdiCtrlRec("4","Aguardando Conferencia Etiquetas")
		U_AdiCtrlRec("5","Finalizado - OK p/Endereçar")
	else
		//Adiciona Status para Controle de Recebimento
		U_AdiCtrlRec("2","Aguardando Lib. C.Q")
	Endif

return		
