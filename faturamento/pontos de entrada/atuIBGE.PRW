#include "rwmake.ch"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ atuibge ³ Autor ³ Rui Munerato      ³ Data ³ 11/03/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Atualizações do codigo de municipio para o SPED            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFAT                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/ 

user function atuibge()

SetPrvt("nQuant1,nQuant2,nQuant3")

nQuant1 := 0
nQuant2 := 0
nQuant3 := 0

Processa({|| RunProc1()}, "Atualizando Clientes.......")
Processa({|| RunProc2()}, "Atualizando Fornecedores...")
Processa({|| RunProc3()}, "Atualizando Transportadora...")


Apmsginfo(" Fornecedores atualizados: " + str(nQuant1,6)  + " Clientes atualizados: " + str(nQuant2,6)  + " Transportadoras atualizadas: " + str(nQuant3,6))
Apmsginfo("Processamento Encerrado")

Return

//***********************************************************************************************************//

Static Function RunProc1()

dbselectarea("SA1")
dbgotop()
ProcRegua(RecCount())

while !eof()
	IncProc("Cliente: " + SA1->A1_COD)

	dbselectarea("CC2")
	dbsetorder(2)
	dbseek(xFilial("CC2")+SA1->A1_MUN)
	while !eof() .and. CC2->CC2_FILIAL == xFilial("CC2") .and. alltrim(CC2->CC2_MUN) == alltrim(SA1->A1_MUN)
		if(SA1->A1_EST == CC2->CC2_EST)
			if(reclock("SA1"))
				SA1->A1_COD_MUN := CC2->CC2_CODMUN
				msunlock()
				++nQuant1
				exit
			endif
		else
			dbskip()
		endif
	enddo
	
	dbselectarea("SA1")
	dbskip()
enddo

Return


//*******************************************************************************************//

Static Function RunProc2()

dbselectarea("SA2")
dbgotop()
ProcRegua(RecCount())

while !eof()
	IncProc("Fornecedor: " + SA2->A2_COD)
	
	dbselectarea("CC2")
	dbsetorder(2)
	dbseek(xFilial("CC2")+SA2->A2_MUN)
	while !eof() .and. CC2->CC2_FILIAL == xFilial("CC2") .and. alltrim(CC2->CC2_MUN) == alltrim(SA2->A2_MUN)
		if(SA2->A2_EST == CC2->CC2_EST)
			if(reclock("SA2"))
				SA2->A2_COD_MUN := CC2->CC2_CODMUN
				msunlock()
				++nQuant2
            exit
			endif
		else
		   dbskip()
		endif
	enddo
	
	dbselectarea("SA2")
	dbskip()
enddo

Return


//*****************************************************************************************//

Static Function RunProc3()

dbselectarea("SA4")
dbgotop()
ProcRegua(RecCount())

while !eof()
	IncProc("Transportadoras: " + SA4->A4_COD)

	dbselectarea("CC2")
	dbsetorder(2)
	dbseek(xFilial("CC2")+SA4->A4_MUN)
	while !eof() .and. CC2->CC2_FILIAL == xFilial("CC2") .and. alltrim(CC2->CC2_MUN) == alltrim(SA4->A4_MUN)
		if(SA4->A4_EST == CC2->CC2_EST)
			if(reclock("SA4"))
				SA4->A4_COD_MUN := CC2->CC2_CODMUN
				msunlock()
				++nQuant3
				exit
			endif
		else
			dbskip()
		endif
	enddo
	
	dbselectarea("SA4")
	dbskip()
enddo

Return


//*****************************************************************************************//