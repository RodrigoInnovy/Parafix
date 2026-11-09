#Include "Protheus.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SF2520E  º Autor ³Daniel Bragaº Data ³  19/04/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescrição ³ Ponto de Entrada executado na exclusão da Nota Fiscal.     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MATA520                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/



User Function MS520VLD() 

Local lRet     := .T.
Local cCNPJOri := SM0->M0_CGC
Local cFilTrf  := ""

If SF2->F2_TIPO == "N"
    // Busca Filial de Destino
	cFilTrf     := Posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_FILTRF")
    
    // Dados p/ Nota de Entrada no Destino
	DbselectArea("SA2")
	DbSetOrder(3)
	Dbseek(xFilial("SA2")+cCNPJOri)
	
	cFornece := SA2->A2_COD
	cLojaFor := SA2->A2_LOJA
	cEstCli	 := SA2->A2_EST

Else 
    // Busca Filial de Destino
	cFilTrf     := Posicione("SA2",1,xFilial("SA2")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A2_FILTRF")
	
    // Dados p/ Nota de Entrada no Destino
	DbselectArea("SA1")
	DbSetOrder(3)
	Dbseek(xFilial("SA1")+cCNPJOri)
	cFornece 	:= SA1->A1_COD
	cLojaFor   	:= SA1->A1_LOJA
	cEstCli		:= SA1->A1_EST
	
EndIf

DbSelectarea("SF1")
DbSetorder(1)
If DbSeek(cFilTrf+SF2->F2_DOC+SF2->F2_SERIE+cFornece+cLojaFor+SF2->F2_TIPO)
	Alert("Nota Fiscal de Transferencia entre Filiais, exclua primeiro a NF de Entrada na Unidade de Destino!")
	lRet := .F.
EndIf


Return(lRet)