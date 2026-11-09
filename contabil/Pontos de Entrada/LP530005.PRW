//LP 530-005 BAIXAS-CONTAS A PAGAR - DESCONTOS  
#INCLUDE 'Protheus.ch'
  
User FUNCTION LP530005()
 
Local aArea             := GetArea()  
Local dDataSE5 	        := DTOS(SE5->E5_DATA)
Local nTaxaCotacao      := SE5->E5_TXMOEDA
Local nValorContabil    := 0

IF SE5->E5_MOEDA = '02' .AND. SE5->E5_TXMOEDA <= 1
nTaxaCotacao := Posicione("SYE",1,xFilial("SYE")+dDataSE5+"US$","YE_VLCON_C")
ENDIF

IF SE5->E5_MOEDA = '03' .AND. SE5->E5_TXMOEDA <= 1
nTaxaCotacao  := Posicione("SYE",1,xFilial("SYE")+dDataSE5+"EUR","YE_VLCON_C")
ENDIF

//Contabiliza o Desconto na moeda LP 530-005                                                                                                                                                                                                          
nValorContabil := IIF((SE5->E5_FORNECE <> "000284".AND. SE5->E5_MOEDA ='02' .OR. SE5->E5_MOEDA ='03'), SE5->E5_VLDESCO*nTaxaCotacao, SE5->E5_VLDESCO)                                                                                                                                                                                                                                                     


RestArea(aArea)
RETURN (nValorContabil)
                                                                                                                                   