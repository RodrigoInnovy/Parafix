//LP 530-304 Contabiliza quando o Titulo for em Dolar e a Baixa for o Banco 013
#INCLUDE 'Protheus.ch'

User FUNCTION LP530304()

	Local aArea        := GetArea()
	Local nValorReais  :=  0
	Local dDataSE5 	   := DTOS(SE5->E5_DATA)
	nValorSE5          := SE5->E5_VALOR

//Verifica se o banco da Baixa é 013 e se o movimento bancário está na moeda Dolar
	If SE5->E5_PREFIXO=='EEC' .AND. SUBSTR(SE1->E1_HIST,1,8)<>"Emb.:BTB" .AND. SE5->E5_MOEDA == "02" .AND. SE5->E5_BANCO == "013"
		nTaxaDolarVenda := Posicione("SYE",1,xFilial("SYE")+dDataSE5+"US$","YE_VLCON_C")
		nValorReais = (nValorSE5*nTaxaDolarVenda)
	EndIf

//Verifca se o banco da baixa Não é 013 e se o movimento bancario está com a moeda Real
	If SE5->E5_PREFIXO=='EEC' .AND. SUBSTR(SE1->E1_HIST,1,8)<>"Emb.:BTB" .AND. SE5->E5_MOEDA = "01" .AND. SE5->E5_BANCO <> "013"
		nTaxaDolarVenda := Posicione("SYE",1,xFilial("SYE")+dDataSE5+"US$","YE_VLCON_C")
		nValorReais = SE5->E5_VALOR
	EndIf

	RestArea(aArea)
RETURN (nValorReais)

