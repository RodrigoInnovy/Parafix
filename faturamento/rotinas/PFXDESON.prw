#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PFXDESON ³ Autor ³ Tuning Sistemas       ³ Data ³ 09/04/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ajusta Valor da desoneração                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PFXDESON() 

Private _cTitle := "Ajusta Desoneração"

@ 000,000 TO 200,580 DIALOG cJan01 TITLE _cTitle
@ 001,005 TO 005,030 
@ 003,011 Say "          Rotina p/ Calculo da Desoneração."
@ 004,017 Say "Confirma ?"
@ 080,120 BMPBUTTON TYPE 1 ACTION Continua()
@ 080,150 BMPBUTTON TYPE 2 ACTION Close(cJan01)

ACTIVATE DIALOG cJan01 CENTERED // Ativa a janela

Return

********************************************************************
Static Function Continua()
********************************************************************

Close(cJan01)
Processa( {|| RunDeson() },"Rotina de Ajuste de Desoneração. Aguarde...")

Return

Static Function RunDeson()

Local cSql     := ""
Local nCount   := 0
Local nPerDeso := Val(GetMV("MV_ZZPDESO"))

Private cPerg  := "PFXDESON"

AjustaSx1(cPerg)
If !Pergunte(cPerg, .T.)
	Return
EndIf

If mv_par07 = 2

cSql  := ""

cSql  := " SELECT R_E_C_N_O_ REGISTRO FROM "
cSql  += RetSqlName("SD2")
cSql  += " WHERE D_E_L_E_T_  = ' '                      AND "
cSql  += "       D2_FILIAL   = '"+xfilial("SD2")+"'     AND "
cSql  += "       D2_DOC     >= '"+mv_par01+"'     AND "
cSql  += "       D2_DOC     <= '"+mv_par02+"'     AND "
cSql  += "       D2_EMISSAO >= '"+DtoS(mv_par03)+"'     AND "
cSql  += "       D2_EMISSAO <= '"+DtoS(mv_par04)+"'     AND "
cSql  += "       D2_COD     >= '"+mv_par05+"'     AND "
cSql  += "       D2_COD     <= '"+mv_par06+"'     AND "
//cSql  += "       D2_ZDESON   = 0                        AND  "
cSql  += "       SUBSTRING(D2_CF,1,1) < '7' "

If Select("OPNW")> 0
	dBSelectArea("OPNW")
	dbCloseArea()
	dBSelectArea("SD2")
EndIf

dbUseArea(.T.,"TOPCONN",TcGenQry(,, cSql),"OPNW",.T.,.T.)
sb5->(dbsetorder(1))
dbSelectArea("OPNW")

Count to nCount
ProcRegua(nCount)

opnw->(dBGotop())         

while !opnw->(eof())

	IncProc("Atualizando registros - Notas de Venda!")
	ProcessMessages()

	dbselectarea("SD2")
	sd2->(dbgoto(opnw->registro))
	if sb5->(dbseek(xfilial("SB5") + sd2->d2_cod ))
		if sb5->b5_inspat == "1" .and. !empty(sb5->b5_codativ) .and. nPerDeso > 0
			sd2->(RecLock("SD2",.f.))
			sd2->d2_zdeson := sd2->d2_BASIMP5 * (nPerDeso/100) //0.01  //(sd2->d2_valbrut - ( sd2->d2_valicm + sd2->d2_valipi + sd2->d2_valimp5 + sd2->d2_valimp6)) * 0.01
			sd2->(MsUnlock())
		Else
			sd2->(RecLock("SD2",.f.))
			sd2->d2_zdeson := 0
			sd2->(MsUnlock())		
		endif
	endif
	dbSelectArea("OPNW")
	opnw->(dbskip())
end-while

dbCloseArea()
dbselectarea("SD2")

Else

//Ajusta notas de Devolução
cSql  := ""

cSql  := " SELECT R_E_C_N_O_ REGISTRO FROM "
cSql  += RetSqlName("SD1")
cSql  += " WHERE D_E_L_E_T_  = ' '                      AND "
cSql  += "       D1_FILIAL   = '"+xfilial("SD1")+"'     AND "
cSql  += "       D1_DOC     >= '"+mv_par01+"'     AND "
cSql  += "       D1_DOC     <= '"+mv_par02+"'     AND "
cSql  += "       D1_DTDIGIT >= '"+DtoS(mv_par03)+"'     AND "
cSql  += "       D1_DTDIGIT <= '"+DtoS(mv_par04)+"'     AND "
cSql  += "       D1_COD     >= '"+mv_par05+"'     AND "
cSql  += "       D1_COD     <= '"+mv_par06+"'     AND "
//cSql  += "       D1_ZDESON   = 0                        AND  "
cSql  += "       SUBSTRING(D1_CF,1,1) < '3' "

if select("OPNW")> 0
	dbSelectArea("OPNW")
	dbCloseArea()
	dbselectarea("SD1")
endif

dbUseArea(.T.,"TOPCONN",TcGenQry(,, cSql),"OPNW",.T.,.T.)
sb5->(dbsetorder(1))
dbSelectArea("OPNW")


Count to nCount
ProcRegua(nCount)

opnw->(dBGotop())
while !opnw->(eof())

	IncProc("Atualizando registros - Notas de Devolução!")
	ProcessMessages()

	dbselectarea("SD1")
	sd1->(dbgoto(opnw->registro))
	if sb5->(dbseek(xfilial("SB5") + sd1->d1_cod ))
		if sb5->b5_inspat == "1" .and. !empty(sb5->b5_codativ) .and. nPerDeso > 0
			sd1->(RecLock("SD1",.f.))
			sd1->d1_zdeson := sd1->d1_BASIMP5 * (nPerDeso/100) //0.01  //(sd1->d1_total - ( sd1->d1_valicm + sd1->d1_valimp5 + sd1->d1_valimp6)) * 0.01
			sd1->(MsUnlock())
		Else
			sd1->(RecLock("SD1",.f.))
			sd1->d1_zdeson := 0
			sd1->(MsUnlock())		
		endif
	endif
	dbSelectArea("OPNW")
	opnw->(dbskip())
end-while

dbCloseArea()
dbselectarea("SD1")

EndIf

return()
   
// Parametros da rotina
/*Static Function AjustaSx1(cPerg)
Local aHelpP	:= {}
Local aHelpE	:= {}
Local aHelpS	:= {}

PutSx1(cPerg, "01", "Da Nota ?",			"", "", "mv_ch1", "C", 09, 0, 0, "G", "", ""   , "", "", "MV_PAR01", "",				"",					"",					"",	"",					"",					"",					"", "", "", "", "", "", "", "", "", aHelpP,aHelpE,aHelpS)
PutSx1(cPerg, "02", "Até Nota ?",			"", "", "mv_ch2", "C", 09, 0, 0, "G", "", ""   , "", "", "MV_PAR02", "",				"",					"",					"",	"",					"",					"",					"", "", "", "", "", "", "", "", "", aHelpP,aHelpE,aHelpS)
PutSx1(cPerg, "03", "Da Data de Emissao ?",	"", "", "mv_ch3", "D", 08, 0, 0, "G", "", ""   , "", "", "MV_PAR03", "",				"",					"",					"",	"",					"",					"",					"", "", "", "", "", "", "", "", "", aHelpP,aHelpE,aHelpS)
PutSx1(cPerg, "04", "Até Data de Emissao ?","", "", "mv_ch4", "D", 08, 0, 0, "G", "", ""   , "", "", "MV_PAR04", "",				"",					"",					"",	"",					"",					"",					"", "", "", "", "", "", "", "", "", aHelpP,aHelpE,aHelpS)
PutSx1(cPerg, "05", "Do Produto ?",			"", "", "mv_ch5", "C", 15, 0, 0, "G", "", "SB1", "", "", "MV_PAR05", "",				"",					"",					"",	"",					"",					"",					"", "", "", "", "", "", "", "", "", aHelpP,aHelpE,aHelpS)
PutSx1(cPerg, "06", "Até Produto ?",		"", "", "mv_ch6", "C", 15, 0, 0, "G", "", "SB1", "", "", "MV_PAR06", "",				"",					"",					"",	"",					"",					"",					"", "", "", "", "", "", "", "", "", aHelpP,aHelpE,aHelpS)
PutSx1(cPerg, "07", "Tipo NF?",				"", "", "mv_ch7", "N", 01, 0, 1, "C", "", ""   , "", "", "MV_PAR07", "Entrada","Entrada","Entrada",		"",	"Saida","Saida","Saida",		"", "", "", "", "", "", "", "", "", aHelpP,aHelpE,aHelpS)

Return()
*/