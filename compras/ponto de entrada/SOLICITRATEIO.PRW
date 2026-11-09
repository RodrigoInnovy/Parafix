#INCLUDE "PROTHEUS.CH"

USER FUNCTION SOLICITRATEIO()

Local cRateioCC    := ''
Local cRateioConta := ''
Local lRet         := .T.

cRateioCC    		:= ALLTRIM(ACOLS[N][3])
cRateioConta 		:= ALLTRIM(CX_CONTA)


    	DO CASE
        	CASE SUBSTR(cRateioConta,1,2) $ "33" .AND. !SUBSTR(cRateioCC,1,2) $ "12,13,19"

		    	MsgAlert('Contas contábeis que comece com 33xxxx devem conter o centro de custo que comece com 12xxxx ou 13xxxx ou 19xxxx ' , 'Atenção')
				lRet         := .F.

        	CASE cRateioConta $ "32" .AND. !SUBSTR(cRateioCC,1,2) $ "11,19"

		    	MsgAlert('Contas contábeis que comece com 32xxxx devem conter o centro de custo que comece com 11xxxx ou 19xxxx', 'Atenção')
				lRet         := .F.

	   		CASE cRateioConta $ "11" .AND. !EMPTY( cRateioCC )

		    	MsgAlert('Contas contábeis que comece com 11xxxx devem conter o centro de custo vazio', 'Atenção')
				lRet         := .F.

         	OTHERWISE
		 		lRet         := .T.

    	ENDCASE

Return (lRet)
