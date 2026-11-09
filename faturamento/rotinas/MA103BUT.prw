#include "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Programa ³ MA103BUT ³ Autor ³ Guilherme Giuliano ³ Data ³ 25/02/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri+.o ³ Ponto de Entrada Inclusao de Botao na digitação de NF Entr.³±±
±±³ ³ 																	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso ³ CIS ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
*****************************************************************************
User Function MA103BUT()                                                     
*****************************************************************************

aBotao := {}
Aadd(aBotao , {"NOTE",{||INFOPRO()},"Informacoes adicionais Danfe"})
//SET KEY 5 TO INFOPRO()
Return(aBotao)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma ³INFOPRO ºAutor ³Microsiga º Data ³ 07/19/05 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc. ³ º±±
±±º ³ º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso ³ AP º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*****************************************************************************
Static FUNCTION INFOPRO()                                                    
*****************************************************************************
	
	static _cmMarca 	:= space(15)
	static _cmNumer 	:= space(15)
	static _cmDi 		:= space(10)
	static _cmDtDi 	:= ctod("  /  /  ")
	static _cmLocal 	:= space(40)
	static _cmUFDi 	:= space(2)
	static _cmDTDesem := ctod("  /  /  ")
	static _cmExport 	:= space(40)
//	static _cmPesol 	:= 0
//	static _cmPesob 	:= 0
	
	@ 000,000 TO 320,400 DIALOG oDlg TITLE "Informações Adicionais Importação"
//	@ 002,002 TO 300,300
	@ 003,008 say "Marca do Veiculo: "
	@ 003,075 get _cmMarca picture "@!" size 40,13
	@ 016,008 say "Numeração do Veiculo: "
	@ 016,075 get _cmNumer picture "@!" size 40,13
	@ 029,008 say "Numero da DI: "
	@ 029,075 get _cmDi picture "@R 99/9999999-9" size 40,13
	@ 042,008 say "Data da DI: "
	@ 042,075 get _cmDTDi size 40,13
	@ 055,008 say "Local do Desembaraço: "
	@ 055,075 get _cmLocal picture "@!" size 80,13
	@ 068,008 say "Estado Desembaraço: "
	@ 068,075 get _cmUFDi picture "@!" F3 "12" size 12,13
	@ 081,008 say "Data do Desembaraço: "
	@ 081,075 get _cmDTDesem size 40,13
	@ 094,008 say "Exportador: "
	@ 094,075 get _cmExport picture "@!" size 70,13
	@ 109,080 BMPBUTTON TYPE 1 ACTION close(oDlg)
	ACTIVATE DIALOG oDlg CENTERED
    

return   

*****************************************************************************
User Function SF1100I                                                        
*****************************************************************************
	IF !Empty(_cmMarca)
		RecLock("SF1",.F.)
			SF1->F1_MARCADF := alltrim(_cmMarca)
			SF1->F1_NUMERDF := alltrim(_cmNumer)
			SF1->F1_NDI 	 := alltrim(_cmDi) 		
			SF1->F1_DTDI 	 := _cmDtDi
			SF1->F1_LOCDESE := alltrim(_cmLocal) 	
			SF1->F1_UFDI	 := alltrim(_cmUFDi) 	
			SF1->F1_DTDESEM := _cmDTDesem
			SF1->F1_EXPORT  := alltrim(_cmExport) 	
		//	SF1->F1_PESOL 	:= _cmPesol
		//	SF1->F1_MPESOB 	:= _cmPesob
		MsUnlock()
		_cmMarca := nil  
		_cmNumer:= nil
		//_cmPesol := nil	 	             
		//_cmPesob := nil
    ENDIF

/* comentado Vinicius 29/09/2023
   // Para contabilizar atraves da natureza - Silverto - 04/03/11
   if SE2->E2_Naturez # SED->ED_Codigo
      SED->(dbSeek(xFilial("SED")+SE2->E2_Naturez))
   endif
   _cKey := SF1->F1_Doc + SF1->F1_Serie + SF1->F1_Fornece + SF1->F1_Loja
  
  dbSelectArea("SD1")
     dbSeek(xFilial()+_cKey)
     while !eof() .and. _cKey == SD1->D1_Doc + SD1->D1_Serie + SD1->D1_Fornece + SD1->D1_Loja
      if substr(SD1->D1_TES,2,1) == "S"
         reclock("SD1",.f.)
         SD1->D1_Conta := SED->ED_Conta
         msUnLock()
      endif
      dbSkip()
   enddo
   */

return
