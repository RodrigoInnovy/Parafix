#Include "Protheus.ch"
#Include "TopConn.ch"

/**                                                                               
* Rotina		:	FA100PAG - PARAFIX
* Autor		:	Leandro Camaçari - FSW TOTVS IP CAMPINAS
* Data			:	09/12/2013
* Descricao	:	Ponto de Entrada após clicar no botão "Confirmar", fazer o cálculo da movimentação   
				:	Bancária à Pagar.
* Modulo		:	SIGAFIN
* Observações	:	Ponto de Entrada da rotina FINA100.
*/  

User Function FA100PAG()

Local aArea        := GetArea()  
Local nValor       := 0
Local nTxMoedaSM2  := 0
Local nValTotGrava := 0
Local dData 	   := DTOS(SE5->E5_DATA)

nValor := SE5->E5_VALOR


If SE5->E5_MOEDA == "M2"

		nTxMoedaSM2 := Posicione("SYE",1,xFilial("SYE")+dData+"US$","YE_VLCON_C")
	EndIf

If SE5->E5_MOEDA == "M3"

		nTxMoedaSM2 := Posicione("SYE",1,xFilial("SYE")+dData+"EUR","YE_VLCON_C")
	EndIf

	nValTotGrava := nValor * nTxMoedaSM2  

	RecLock("SE5",.F.)   
		SE5->E5_ZZVLMD1 := nValTotGrava  
		SE5->E5_TXMOEDA := nTxMoedaSM2
	SE5->(MsUnLock())	

RestArea( aArea )
Return
     
    
