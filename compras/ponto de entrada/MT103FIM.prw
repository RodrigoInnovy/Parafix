#INCLUDE "PROTHEUS.CH"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    MT103FIM ³ Autor ³ Mailson Silva	        ³ Data ³06/01/2014 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Rotina de integração de NFe DFe-Receiver x Protheus		   ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
/*/

User Function MT103FIM()            
Local nOpcao := PARAMIXB[1]   // Opçao Escolhida pelo usuario no aRotina 
Local nConfirma := PARAMIXB[2]   // Se o usuario confirmou a operaçao de gravaçao da NFE 

If nConfirma == 1 .and. nOpcao == 3 .and. !IsInCallStack('U_QIMPNFE') .and. !IsInCallStack('U_QIMPCTE') .and. !IsInCallStack('U_QIMPNFSE')       
	//Inclusoa Manual
	U_QEXPEV('Digitado manualmente no ERP', '1', '2', '5')
ElseIf nConfirma == 1 .and. nOpcao == 4 .and. !IsInCallStack('U_QIMPNFE') .and. !IsInCallStack('U_QIMPCTE') .and. !IsInCallStack('U_QIMPNFSE')      
    //Classificacao
	U_QEXPEV('Documento Atualizado no Recebimento', '1', '2', '5')
EndIf

Return
