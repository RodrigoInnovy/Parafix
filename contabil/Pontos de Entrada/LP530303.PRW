//LP 530-303 Variação Cambial PASSIVO de Baixa de Titulos a Pagar do EIC e EEC.
#INCLUDE 'Protheus.ch'
  
User FUNCTION LP530303()
 
Local aArea             := GetArea()  
Local dDataSE5 	        := DTOS(SE5->E5_DATA)
Local nTaxaCotacao      := SE5->E5_TXMOEDA
Local nValorContabil    := 0
Local nValorMovBank     := 0

IF SE5->E5_MOEDA = '01'
nTaxaCotacao  := 1
ENDIF

IF SE5->E5_MOEDA = '02' .AND. SE5->E5_TXMOEDA <= 1
nTaxaCotacao := Posicione("SYE",1,xFilial("SYE")+dDataSE5+"US$","YE_VLCON_C")
ENDIF

IF SE5->E5_MOEDA = '03' .AND. SE5->E5_TXMOEDA <= 1
nTaxaCotacao  := Posicione("SYE",1,xFilial("SYE")+dDataSE5+"EUR","YE_VLCON_C")
ENDIF

nValorMovBank := round(SE5->E5_VALOR*nTaxaCotacao,2) 

//Variação Passivo de Baixas a Pagar LP 530-303
nValorContabil := round(IF(SE2->E2_MOEDA>1.AND.SA2->A2_EST=="EX".AND.SA6->A6_MOEDA>0.AND.SE2->E2_VLCRUZ<nValorMovBank,IF(SA6->A6_MOEDA>1,((SE5->E5_VALOR+SE5->E5_VLDESCO)*nTaxaCotacao)-SE2->E2_VLCRUZ,((SE5->E5_VALOR+SE5->E5_VLDESCO)-SE2->E2_VLCRUZ)),0),2)     
//nValorContabil := round(IF(SE2->E2_MOEDA>1.AND.SA2->A2_EST=="EX".AND.SA6->A6_MOEDA>0.AND.(SE2->E2_VALOR*SE2->E2_TXMDCOR)<nValorMovBank,IF(SA6->A6_MOEDA>1,((SE5->E5_VALOR+SE5->E5_VLDESCO)*nTaxaCotacao)-(SE2->E2_VALOR*SE2->E2_TXMDCOR),((SE5->E5_VALOR+SE5->E5_VLDESCO)-(SE2->E2_VALOR*SE2->E2_TXMDCOR))),0),2)


RestArea(aArea)                                                                                                                                                                                                        
RETURN (abs(nValorContabil))

