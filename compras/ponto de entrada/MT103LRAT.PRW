//Ponto de entrada valida Centro de Custo e Conta contábil no Rateio do Documento de Entrada

USER FUNCTION MT103LRAT
Local lRet         := .T.   
//Local aISDe        := PARAMIXB[2]
Local nJ           := ''
Local cRateioCC    := ''
Local cRateioConta := ''


For nJ:= 1 To Len(PARAMIXB[2][1][2])

			cRateioCC     := PARAMIXB[2][1][2][nJ][3]
			cRateioConta  := substr(PARAMIXB[2][1][2][nJ][4],1,2)
		


    DO CASE
        CASE cRateioConta $ "33" .AND. !SUBSTR(cRateioCC,1,2) $ "12,13,19"

		    MsgAlert('Contas contábeis que comece com 33xxxx devem conter o centro de custo que comece com 12xxxx ou 13xxxx ou 19xxxx ' , 'Atenção')
			    lRet := .F.


        CASE cRateioConta $ "32" .AND. !SUBSTR(cRateioCC,1,2) $ "11,19"

		    MsgAlert('Contas contábeis que comece com 32xxxx devem conter o centro de custo que comece com 11xxxx ou 19xxxx', 'Atenção')
			    lRet := .F.

	    CASE cRateioConta $ "11" .AND. !EMPTY( cRateioCC )

		    MsgAlert('Contas contábeis que comece com 11xxxx devem conter o centro de custo vazio', 'Atenção')
			    lRet := .F.



         OTHERWISE

			    lRet := .T.

    ENDCASE

next

RETURN lRet
