#INCLUDE "rwmake.ch"

/*
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºPrograma  ³XSOMACOFMJºAutor  ³ Fernando Pereira   º Data ³  21-11-18   º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDesc.     ³ Funcao para somar o valor da majoracao do cofins do SD1    º±±
	±±º          ³ para utilizacao no LP 660/001 de entrada de nf             º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ AP                                                        º±±
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*******************************
User Function xSomaCOFMj()  
     
Local aArea		:= GetArea()
Local nValor	:= 0
Local cChaveNF	:= SF1->(F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)

DbSelectArea("SD1")
DbSetOrder(1)
If DbSeek(xFilial("SD1")+cChaveNF)
	While !EOF() .And. D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA == xFilial("SD1")+cChaveNF
		nValor += D1_VALCMAJ
		DbSkip()
	EndDo
EndIf

RestArea(aArea)

Return(nValor)