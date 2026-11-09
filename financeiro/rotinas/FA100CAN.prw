#Include "Protheus.ch"
#Include "TopConn.ch"

/**                                                                               
* Rotina		:	FA100CAN - PARAFIX
* Autor	    	:	Leandro Camaçari - FSW TOTVS IP CAMPINAS
* Data			:	13/12/2013
* Descricao 	:	Ponto de Entrada após confirmar o "Cancelamento" da movimentação Bancária à Receber/Pagar.  
* Modulo		:	SIGAFIN
* Observações	:	Ponto de Entrada da rotina FINA100.
*/  

User Function FA100CAN()

Local aArea        := GetArea()  
Local nValor       := 0
Local nTxMoedaSM2  := 0
Local nValTotGrava := 0

nValor := SE5->E5_VALOR

If SE5->E5_MOEDA == "M2" .AND. SE5->E5_SITUACA == "E"

	DbSelectArea("SM2")
	SM2->(dbSetOrder(1))                                                                         	
	If DbSeek(SE5->E5_DATA)
		nTxMoedaSM2 := M2_MOEDA2
	EndIf

	nValTotGrava := nValor * nTxMoedaSM2  

	RecLock("SE5",.F.)   
		SE5->E5_ZZVLMD1 := nValTotGrava
		SE5->E5_TXMOEDA := nTxMoedaSM2  
	SE5->(MsUnLock())	

	SM2->(DbCloseArea())

EndIf

RestArea( aArea )
      

Return