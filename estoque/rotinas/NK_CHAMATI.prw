
#INCLUDE "protheus.ch" 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±                   
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³  Chamados de LOGISTICA                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±             
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Programa   ³ ChamaTI³ Autor ³ GABRIEL ARAUJO    ³ Data ³ 02/08/2012       ³±±
±±    ALTERADO POR       Autor ³ MARCOS PERON       ³ Data ³ 18/05/2017       ³±±  
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o  ³ Tela de Chamados de Logistica                                ³±±
±±³            ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Parametros ³                                                              ³±±
±±³            ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Obs        ³                                                              ³±±
±±³            ³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Retorno    ³                                                              ³±±
±±³            ³                                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function ChamaTI

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Declaracao de Variaveis                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
Private cCadastro := "Chamados de Logistica"
Private aRotina   := {	{"Pesquisar" , "AxPesqui"   	 , 0, 1},;
						{"Visualizar", "AxVisual"   	 , 0, 2},;
						{"Incluir"   , "AxInclui"   	 , 0, 3},;   
						{"Alterar"   , "U_TIAltera" 	 , 0, 4},;  
						{"Excluir"   , "AxDeleta"        , 0, 5},;  				                                         
						{"Operação"   , "U_Liberar"      , 0, 6},;   
						{"Cancelar"  , "U_TICancela"     , 0, 7},;
						{"Enc. Expedicao"  , "U_Coletar" , 0, 8},; 								
						{"Enc. Recebimento"  , "U_Receb" , 0, 9},;
						{"Liberaração"  , "U_Finaliza"	, 0, 10},;
						{"Produtos"  , "U_Produ"      	, 0, 11},;		
						{"Legenda"   , "U_TILegenda"	, 0, 12} }

Private cDelFunc := ".T."	// Validacao para a exclusao. Pode-se utilizar ExecBlock
Private cAlias   := "SZ4"


aCores := {{"SZ4->Z4_STATUS == '1'", "BR_VERDE"}, {"SZ4->Z4_STATUS == '2'", "BR_AMARELO"}, {"SZ4->Z4_STATUS == '3'", "BR_VIOLETA"}, {"SZ4->Z4_STATUS == '4'", "BR_PRETO"}, {"SZ4->Z4_STATUS == '5'", "BR_VERMELHO"}}

SZ4->(dbSetOrder(1))

mBrowse(6, 1, 22, 105, cAlias, , , , , 2, aCores)

Return     



/// ============================================================   FUNÇÃO ALTERA ======================================================================//   

User Function TIAltera(cAlias, nReg, nOpc)

Local _MEMO    := " "
Local aArea    := GetArea()
Local aAreaSZ4 := SZ4->(GetArea())

If SZ4->Z4_STATUS = "5"
	MsgStop("O chamado está Encerrado!", "Operação Não Permitida")
	Return
EndIf

If SZ4->Z4_STATUS != "1"
	MsgStop("O chamado não está pendente, portanto não é possível alterá-lo!", "Operação Não Permitida")
	Return
EndIf

nOpca := 0
nOpca := AxAltera(cAlias, nReg, nOpc, , , , , ".T.")

RestArea(aAreaSZ4)
RestArea(aArea)

Return

// ============================================================   FIM FUNÇÃO ALTERA =====================================================================// 
     

// ============================================================   FUNÇÃO OPERAÇÃO ======================================================================//   

User Function Liberar() 

Local _MEMO    := " "
Local aArea    := GetArea()
Local aAreaSZ4 := SZ4->(GetArea())    

If SZ4->Z4_STATUS = "5"
	MsgStop("O chamado está Encerrado!", "Operação Não Permitida")
	Return
EndIf

If SZ4->Z4_STATUS = "2"
	Alert("O chamado já está liberado!")
	Return
EndIf


lResp := MsgYesNo("Confirma Inicio da Operação?")

If SZ4->Z4_STATUS = "3"
		Alert("Operação já está Encerrada !")
		else
			If lResp
   				RecLock("SZ4", .F.)
	   				SZ4->Z4_HOPR  := SubStr(Time(), 1, 5)                                                                                                              
	   				SZ4->Z4_STATUS := "2"	// Em Operação
   				MsUnlock()
		EndIf
EndIf  

RestArea(aAreaSZ4)
RestArea(aArea)

Return



// ============================================================   FUNÇÃO FIM FUNÇÃO OPERAÇÃO ==========================================================//  

//=================================================================   FUNÇÃO LIBERAÇÃO ================================================================//
                                                                            
User Function Finaliza() 

Local lResp    := .F.
Local _MEMO    := " "
Local aArea    := GetArea()
Local aAreaSZ4 := SZ4->(GetArea()) 
Local cUsr, cTurn  
Local nQuant1:=nQuant2:=nQuant3:=nQuant4:=nQuant5:=nQuant6:=nQuant7:=nQuant8:=nQuant9:=nQuant10:=0

Local cNF1    := SZ4->Z4_NF1
Local cNF2    := SZ4->Z4_NF2
Local cNF3    := SZ4->Z4_NF3
Local cNF4    := SZ4->Z4_NF4
Local cNF5    := SZ4->Z4_NF5
Local cNF6    := SZ4->Z4_NF6
Local cNF7    := SZ4->Z4_NF7
Local cNF8    := SZ4->Z4_NF8
Local cNF9    := SZ4->Z4_NF9
Local cNF10   := SZ4->Z4_NF10
Local cPED1   := SZ4->Z4_PED1
Local cPED2   := SZ4->Z4_PED2
Local cPED3   := SZ4->Z4_PED3
Local cPED4   := SZ4->Z4_PED4
Local cPED5   := SZ4->Z4_PED5
Local cPED6   := SZ4->Z4_PED6
Local cPED7   := SZ4->Z4_PED7
Local cPED8   := SZ4->Z4_PED8
Local cPED9   := SZ4->Z4_PED9
Local cPED10  := SZ4->Z4_PED10
Local cProd1  := SZ4->Z4_PROD1
Local cProd2  := SZ4->Z4_PROD2
Local cProd3  := SZ4->Z4_PROD3
Local cProd4  := SZ4->Z4_PROD4
Local cProd5  := SZ4->Z4_PROD5
Local cProd6  := SZ4->Z4_PROD6
Local cProd7  := SZ4->Z4_PROD7
Local cProd8  := SZ4->Z4_PROD8
Local cProd9  := SZ4->Z4_PROD9
Local cProd10 := SZ4->Z4_PROD10
Local nQuant1 := ROUND(SZ4->Z4_QTD1,6)
Local nQuant2 := ROUND(SZ4->Z4_QTD2,6)
Local nQuant3 := ROUND(SZ4->Z4_QTD3,6)
Local nQuant4 := ROUND(SZ4->Z4_QTD4,6)
Local nQuant5 := ROUND(SZ4->Z4_QTD5,6)
Local nQuant6 := ROUND(SZ4->Z4_QTD6,6)
Local nQuant7 := ROUND(SZ4->Z4_QTD7,6)
Local nQuant8 := ROUND(SZ4->Z4_QTD8,6)
Local nQuant9 := ROUND(SZ4->Z4_QTD9,6)
Local nQuant10:= ROUND(SZ4->Z4_QTD10,6)
Local cUM1    := SZ4->Z4_UM1
Local cUM2    := SZ4->Z4_UM2
Local cUM3    := SZ4->Z4_UM3
Local cUM4    := SZ4->Z4_UM4
Local cUM5    := SZ4->Z4_UM5
Local cUM6    := SZ4->Z4_UM6
Local cUM7    := SZ4->Z4_UM7
Local cUM8    := SZ4->Z4_UM8
Local cUM9    := SZ4->Z4_UM9
Local cUM10   := SZ4->Z4_UM10

If SZ4->Z4_STATUS = "5"
	MsgStop("O chamado está Encerrado!", "Operação Não Permitida") //Alert("STATUS JÁ LIBERADO!")
	Return
Else
	If SZ4->Z4_STATUS != "3"    //Status 3 = LIBERAÇÃO
		Alert(" NÃO É POSSIVEL REALIZAR LIBERAÇÃO! ")
		Return
	EndIf
	
	lResp := MsgYesNo("Confirma Liberação do Material?")

EndIf
			
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlg1","oGrp1","oSay1","oSay2","oCBox1","oCBox2","oGrp2","oSay8","oSay9","oSay10","oSay11","oSay12","oSay13","oSay14")
SetPrvt("oSay15","oSay16","oSay17","oSay18","oSay19","oSay20","oSay21","oSay22","oSay23","oSay24","oSay25","oSay26")
SetPrvt("oSay27","oSay28","oSay29","oSay30","oSay31","oSay32","oSay33","oSay34","oSay35","oSay36","oSay37")
SetPrvt("oSay38","oSay39","oSay40","oSay41","oSay42","oSay43","oSay44","oSay45","oSay46","oSay47","oSay48")
SetPrvt("oSay49","oSay50","oSay51","oSay52","oSay53","oSay54","oSay55","oSay56","oSay57")
SetPrvt("oGet6","oGet7","oGet8","oGet9","oGet10","oGet11","oGet12","oGet13","oGet14","oGet15","oGet16")
SetPrvt("oGet18","oGet19","oGet20","oGet21","oGet22","oGet23","oGet24","oGet25","oGet26","oGet27","oGet28")
SetPrvt("oGet29","oGet30","oGet31","oGet32","oGet33","oGet34","oGet35","oGet36","oGet37","oGet38","oGet39")
SetPrvt("oGet40","oGet41","oGet42","oGet43","oGet44","oGet45","oGet46","oGet47","oGet48","oGet49","oGet50","oGet51","oGet52","oGet53","oGet54")
SetPrvt("oBtn1","oBtn2")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlg1      := MSDialog():New( 134,280,648,1029,"Libebração de Materiais - Parafix - Rev 2.1",,,.F.,,,,,,.T.,,,.T. )
oGrp1      := TGroup():New( 005,005,052,368,"Selecione o Operador",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay1      := TSay():New( 028,013,{||"Operador :"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay2      := TSay():New( 028,274,{||"Turno :"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oCBox1     := TComboBox():New( 027,042,{|u| If(PCount() > 0, cUsr := u, cUsr)},{"MARIA CRUZ","JOSIE","LUCIANA","SILVANA","SELMA","REJANE","ELIDIANA","FABIA","LUCIENE"},072,010,oGrp1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
oCBox2     := TComboBox():New( 027,297,{|u| If(PCount() > 0, cTurn := u, cTurn)},{"1° TURNO","2° TURNO","3° TURNO"},054,010,oGrp1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
oGrp2      := TGroup():New( 052,004,220,368," Itens ",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay8      := TSay():New( 075,013,{||"NF:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay9      := TSay():New( 075,086,{||"PED.:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay10     := TSay():New( 075,165,{||"PROD.:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay11     := TSay():New( 075,249,{||"QTDE:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay12     := TSay():New( 075,332,{||"UM:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay13     := TSay():New( 090,013,{||"NF:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay14     := TSay():New( 090,086,{||"PED.:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay15     := TSay():New( 090,165,{||"PROD.:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay16     := TSay():New( 090,249,{||"QTDE:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay17     := TSay():New( 090,332,{||"UM:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay18     := TSay():New( 105,013,{||"NF:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay19     := TSay():New( 105,086,{||"PED.:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay20     := TSay():New( 105,165,{||"PROD.:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay21     := TSay():New( 105,249,{||"QTDE:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay22     := TSay():New( 105,332,{||"UM:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay23     := TSay():New( 120,013,{||"NF:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay24     := TSay():New( 120,086,{||"PED.:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay25     := TSay():New( 120,165,{||"PROD.:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay26     := TSay():New( 120,249,{||"QTDE:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay27     := TSay():New( 120,332,{||"UM:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay28     := TSay():New( 135,013,{||"NF:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay29     := TSay():New( 135,086,{||"PED.:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay30     := TSay():New( 135,165,{||"PROD.:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay31     := TSay():New( 135,249,{||"QTDE:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay32     := TSay():New( 135,332,{||"UM:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay33     := TSay():New( 150,013,{||"NF:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay34     := TSay():New( 150,086,{||"PED.:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay35     := TSay():New( 150,165,{||"PROD.:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay36     := TSay():New( 150,249,{||"QTDE:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay37     := TSay():New( 150,332,{||"UM:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay38     := TSay():New( 165,013,{||"NF:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay39     := TSay():New( 165,086,{||"PED.:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay40     := TSay():New( 165,165,{||"PROD.:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay41     := TSay():New( 165,249,{||"QTDE:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay42     := TSay():New( 165,332,{||"UM:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay43     := TSay():New( 180,013,{||"NF:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay44     := TSay():New( 180,086,{||"PED.:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay45     := TSay():New( 180,165,{||"PROD.:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay46     := TSay():New( 180,249,{||"QTDE:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay47     := TSay():New( 180,332,{||"UM:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay48     := TSay():New( 195,013,{||"NF:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay49     := TSay():New( 195,086,{||"PED.:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay50     := TSay():New( 195,165,{||"PROD.:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay51     := TSay():New( 195,249,{||"QTDE:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay52     := TSay():New( 195,332,{||"UM:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay53     := TSay():New( 210,013,{||"NF:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay54     := TSay():New( 210,086,{||"PED.:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay55     := TSay():New( 210,165,{||"PROD.:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay56     := TSay():New( 210,249,{||"QTDE:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay57     := TSay():New( 210,332,{||"UM:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGet5      := TGet():New( 075,022,{|u| cNF1},    oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet6      := TGet():New( 075,100,{|u| cPed1},  oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet7      := TGet():New( 075,184,{|u| cProd1},  oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet8      := TGet():New( 075,266,{|u| nQuant1}, oGrp2,060,008,"@E 9,999,999.999999",,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet9      := TGet():New( 075,343,{|u| cUM1}, oGrp2,020,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet10     := TGet():New( 090,022,{|u| cNF2},    oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet11     := TGet():New( 090,100,{|u| cPed2},  oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet12     := TGet():New( 090,184,{|u| cProd2},  oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet13     := TGet():New( 090,266,{|u| nQuant2}, oGrp2,060,008,"@E 9,999,999.999999",,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet14     := TGet():New( 090,343,{|u| cUM2}, oGrp2,020,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet15     := TGet():New( 105,022,{|u| cNF3},    oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet16     := TGet():New( 105,100,{|u| cPed3},  oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet17     := TGet():New( 105,184,{|u| cProd3},  oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet18     := TGet():New( 105,266,{|u| nQuant3}, oGrp2,060,008,"@E 9,999,999.999999",,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet19     := TGet():New( 105,343,{|u| cUM3}, oGrp2,020,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet20     := TGet():New( 120,022,{|u| cNF4},    oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet21     := TGet():New( 120,100,{|u| cPed4},  oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet22     := TGet():New( 120,184,{|u| cProd4},  oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet23     := TGet():New( 120,266,{|u| nQuant4}, oGrp2,060,008,"@E 9,999,999.999999",,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet24     := TGet():New( 120,343,{|u| cUM4}, oGrp2,020,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet25     := TGet():New( 135,022,{|u| cNF5},    oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet26     := TGet():New( 135,100,{|u| cPed5},  oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet27     := TGet():New( 135,184,{|u| cProd5},  oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet28     := TGet():New( 135,266,{|u| nQuant5}, oGrp2,060,008,"@E 9,999,999.999999",,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet29     := TGet():New( 135,343,{|u| cUM5}, oGrp2,020,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet30     := TGet():New( 150,022,{|u| cNF6},    oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet31     := TGet():New( 150,100,{|u| cPed6},  oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet32     := TGet():New( 150,184,{|u| cProd6},  oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet33     := TGet():New( 150,266,{|u| nQuant6}, oGrp2,060,008,"@E 9,999,999.999999",,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet34     := TGet():New( 150,343,{|u| cUM6}, oGrp2,020,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet35     := TGet():New( 165,022,{|u| cNF7},    oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet36     := TGet():New( 165,100,{|u| cPed7},  oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet37     := TGet():New( 165,184,{|u| cProd7},  oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet38     := TGet():New( 165,266,{|u| nQuant7}, oGrp2,060,008,"@E 9,999,999.999999",,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet39     := TGet():New( 165,343,{|u| cUM7}, oGrp2,020,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet40     := TGet():New( 180,022,{|u| cNF8},    oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet41     := TGet():New( 180,100,{|u| cPed8},  oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet42     := TGet():New( 180,184,{|u| cProd8},  oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet43     := TGet():New( 180,266,{|u| nQuant8}, oGrp2,060,008,"@E 9,999,999.999999",,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet44     := TGet():New( 180,343,{|u| cUM8}, oGrp2,020,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet45     := TGet():New( 195,022,{|u| cNF9},    oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet46     := TGet():New( 195,100,{|u| cPed9},  oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet47     := TGet():New( 195,184,{|u| cProd9},  oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet48     := TGet():New( 195,266,{|u| nQuant9}, oGrp2,060,008,"@E 9,999,999.999999",,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet49     := TGet():New( 195,343,{|u| cUM9}, oGrp2,020,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet50     := TGet():New( 210,022,{|u| cNF10},    oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet51     := TGet():New( 210,100,{|u| cPed10},  oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet52     := TGet():New( 210,184,{|u| cProd10},  oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet53     := TGet():New( 210,266,{|u| nQuant10}, oGrp2,060,008,"@E 9,999,999.999999",,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet54     := TGet():New( 210,343,{|u| cUM10}, oGrp2,020,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oBtn1      := TButton():New( 228,104,"OK",oDlg1,{|| lResp := .T., oDlg1:End()},044,016,,,,.T.,,"",,,,.F. )
oBtn2      := TButton():New( 228,224,"Cancelar",oDlg1,{|| lResp := .F., oDlg1:End()},044,016,,,,.T.,,"",,,,.F. )

oDlg1:Activate(,,,.T.)

			  
			/*
			SetPrvt("oDlg1","oGrp1","oSay1","oSay2","oBtn1","oBtn2","oCBox1","oCBox2")

			oDlg1      := MSDialog():New( 308,304,509,853,"oDlg1",,,.F.,,,,,,.T.,,,.T. )
			oGrp1      := TGroup():New( 008,016,084,256,"Selecione o Operador",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
			oSay1      := TSay():New( 030,023,{||"Operador :"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
			oSay2      := TSay():New( 030,150,{||"Turno :"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
			oBtn1      := TButton():New( 064,065,"OK",oGrp1,{|| lResp := .T., oDlg1:End()},037,012,,,,.T.,,"",,,,.F. )
			oBtn2      := TButton():New( 064,174,"Cancelar",oGrp1,{|| lResp := .F., oDlg1:End()},037,012,,,,.T.,,"",,,,.F. )
			oCBox1     := TComboBox():New( 029,053,{|u| If(PCount() > 0, cUsr := u, cUsr)},{"CAROLINA","JOSIE","LUCIANA","CRISTINA","SELMA","REJANE","},072,010,oGrp1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )
			oCBox2     := TComboBox():New( 029,172,{|u| If(PCount() > 0, cTurn := u, cTurn)},{"1° TURNO","2° TURNO","3° TURNO"},054,010,oGrp1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, )

			oDlg1:Activate(,,,.T.)	 		
			*/			
			If lResp == .T.                    
			RecLock("SZ4", .F.)  
   			SZ4->Z4_DQENC  := dDataBase  //data de encerramento da qualidade
	   		SZ4->Z4_HQENC  := SubStr(Time(), 1, 5) //hora de encerramento da qualidade                                                                                                             
	   		SZ4->Z4_STATUS := "5"	// Encerrado
	   		SZ4->Z4_TURN   := cTurn
	   		SZ4->Z4_QUSR   := cUsr             
   			MsUnlock()
   			EndIf
   			
RestArea(aAreaSZ4)
RestArea(aArea)

Return

//=================================================================  FIM FUNÇÃO LIBERAÇÃO ================================================================//


// ============================================================   FUNÇÃO CANCELA ======================================================================//   


User Function TICancela()

Local lResp

If SZ4->Z4_STATUS != "1"
	Alert("O chamado não está pendente!")
	Return
EndIf

lResp := MsgYesNo("Confirma Cancelamento do Chamado?")

If lResp
	RecLock("SZ4", .F.)
		SZ4->Z4_DTENC  := dDataBase
		SZ4->Z4_HRENC  := SubStr(Time(), 1, 5)                                                                                                              
		SZ4->Z4_STATUS := "4"	// Cancelado
	MsUnlock()
EndIf

Return 

//============================================================   FIM FUNÇÃO CANCELA ======================================================================//   
                                                                           

// ============================================================   FUNÇÃO EXPEDIÇÃO ======================================================================//   
User Function Coletar()

Local cOpera
Local dEncTI  := dDataBase
Local cHoraTI := SubStr(Time(), 1, 5)
Local lResp   := .F. 

Local oDlgEnc, oDlgEnc2, oSay1, oSay2, oGetData, oSay3, oGetHora, oGrp5, oSBtn7, oSBtn8, oSBtn9, oBtnCancel, oGetOpera, cGetOpera, cGetOpera1 := Space (11), oGetNota, cNota := Space (40), cPallet, oGetVolume, cVolume := Space (11), cObs, cTipo, cObsc := Space (40), cObsr, oGetObs

if SZ4->Z4_TIPO != "1"
	Alert("ESTA OPERAÇÃO NAO SE APLICA A EXPEDICÃO!")
	Return
EndIf 

If SZ4->Z4_STATUS != "2"
	Alert("OPERAÇÃO NAO ESTÁ PENDENTE!")
	Return
EndIf 



oDlgEnc           := MsDialog():Create() //funcao que cria a janela
oDlgEnc:cName     := "oDlgEnc"
oDlgEnc:cCaption  := "Encerramento"                                        
oDlgEnc:nLeft     := 0
oDlgEnc:nTop      := 0
oDlgEnc:nWidth    := 500// LARGURA DA JANELA
oDlgEnc:nHeight   := 300// ALTURA DA JANELA
oDlgEnc:lShowHint := .F.
oDlgEnc:lCentered := .T.        


oSay1                 := TSay():Create(oDlgEnc)// escreve "operador:" na tela
oSay1:cName           := "oSay1"
oSay1:cCaption        := "Operador:"
oSay1:nLeft           := 200 // posicao do texto
oSay1:nTop            := 35
oSay1:nWidth          := 45 // ESPAÇAMENTO DA CAIXA DE TEXTO
oSay1:nHeight         := 17
oSay1:lShowHint       := .F.
oSay1:lReadOnly       := .F.
oSay1:Align           := 0
oSay1:lVisibleControl := .T.
oSay1:lWordWrap       := .F.
oSay1:lTransparent    := .F.     

//======================================================================= Cria o Combo box ====================================================================//
Static oDlg
Static oComboBox1, oComboBox2
Static nComboBox1 := 1, nComboBox2 := 1

    @ 016, 0130 MSCOMBOBOX oComboBox1 VAR nComboBox1 ITEMS {"MURILO","OZEAS","CARLOS","IVAN","EVERTON","DOUGLAS","ALESSANDRO","MARCOS FAVERO","LEONARDO","MARCELO","FELIPE MASSA","OUTROS"} SIZE 057, 010 OF oDlg COLORS 0, 16777215 PIXEL 
    oComboBox1:bSetGet         := {|u| If(PCount() > 0, cOpera := u, cOpera)} 
    
    
    @ 044, 0163 MSCOMBOBOX oComboBox2 VAR nComboBox2 ITEMS {"0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59","60","61","62","63","64","65","66","67","68","69","70"} SIZE 023, 010 OF oDlg COLORS 0, 16777215 PIXEL 
    oComboBox2:bSetGet         := {|u| If(PCount() > 0, cPallet := u, cPallet)} 
     
     

//======================================================================= INICIA OS OBJETOS ===================================================================//     

Static oComboBox3
Static nComboBox3 := 1
Static oSay1
Static oSay2

 	@ 046, 0100 SAY oSay1 PROMPT "Qtde. de Pallets:" SIZE 042, 007 OF oDlg COLORS 0, 16777215 PIXEL 	 
 	@ 048, 013 SAY oSay1 PROMPT "Volumes:" SIZE 024, 010 OF oDlg COLORS 0, 16777215 PIXEL 
 	
    @ 060, 035 MSCOMBOBOX oComboBox3 VAR nComboBox3 ITEMS {"CX","ML","M2","KG","PC","LT","RL"} SIZE 026, 010 OF oDlg COLORS 0, 16777215 PIXEL  
    oComboBox3:bSetGet         := {|u| If(PCount() > 0, cTipo := u, cTipo)}

oGetVolume                 := TGet():New() // cria o mensage box e escreve na tabela
oGetVolume:cName           := "oGetVolume"                                            
oGetVolume:nLeft           := 70 //distancia 
oGetVolume:nTop            := 94
oGetVolume:nWidth          := 80
oGetVolume:nHeight         := 21
oGetVolume:lShowHint       := .F.
oGetVolume:lReadOnly       := .F.
oGetVolume:Align           := 0
oGetVolume:cVariable       := "SZ4->Z4_VOL"  
oGetVolume:bSetGet         := {|u| If(PCount() > 0, cVolume := u, cVolume)}
oGetVolume:lVisibleControl := .T.                                                                  
oGetVolume:lPassword       := .F.      
oGetVolume:Picture         := "@C"
oGetVolume:lHasButton      := .T.

oGetNota                 := TGet():New() // cria o mensage box e escreve na tabela
oGetNota:cName           := "oGetNota"
oGetNota:nLeft           := 235 //distancia 
oGetNota:nTop            := 62
oGetNota:nWidth          := 245
oGetNota:nHeight         := 21
oGetNota:lShowHint       := .F.
oGetNota:lReadOnly       := .F.
oGetNota:Align           := 0
oGetNota:cVariable       := "SZ4->Z4_NF"  
oGetNota:bSetGet         := {|u| If(PCount() > 0, cNota := u, cNota)}
oGetNota:lVisibleControl := .T.                                                                  
oGetNota:lPassword       := .F.      
oGetNota:Picture         := "@C"
oGetNota:lHasButton      := .T.

oSay1                 := TSay():Create(oDlgEnc)
oSay1:cName           := "oSay1"
oSay1:cCaption        := "Nota:"
oSay1:nLeft           := 200
oSay1:nTop            := 65
oSay1:nWidth          := 30
oSay1:nHeight         := 17
oSay1:lShowHint       := .F.                                                           
oSay1:lReadOnly       := .F.
oSay1:Align           := 0
oSay1:lVisibleControl := .T.
oSay1:lWordWrap       := .F.
oSay1:lTransparent    := .F. 

oGetObs                  := TGet():New() // cria o mensage box e escreve na tabela
oGetObs:cName            := "oGetObs"
oGetObs:nLeft            := 70 //distancia 
oGetObs:nTop             := 150
oGetObs:nWidth           := 210
oGetObs:nHeight          := 24
oGetObs:lShowHint        := .F.
oGetObs:lReadOnly        := .F.
oGetObs:Align            := 0
oGetObs:cVariable        := "SZ4->Z4_OBSC"  
oGetObs:bSetGet          := {|u| If(PCount() > 0, cObsc := u, cObsc)}
oGetObs:lVisibleControl  := .T.                                                                  
oGetObs:lPassword        := .F.      
oGetObs:Picture          := "@C"
oGetObs:lHasButton       := .T.

oSay1                 := TSay():Create(oDlgEnc)
oSay1:cName           := "oSay1"
oSay1:cCaption        := "OBS:"
oSay1:nLeft           := 26
oSay1:nTop            := 155
oSay1:nWidth          := 30
oSay1:nHeight         := 17
oSay1:lShowHint       := .F.                                                           
oSay1:lReadOnly       := .F.
oSay1:Align           := 0
oSay1:lVisibleControl := .T.
oSay1:lWordWrap       := .F.
oSay1:lTransparent    := .F.  
                                 
oSay1                 := TSay():Create(oDlgEnc)
oSay1:cName           := "oSay1"
oSay1:cCaption        := "Data:"
oSay1:nLeft           := 26
oSay1:nTop            := 35
oSay1:nWidth          := 37
oSay1:nHeight         := 17
oSay1:lShowHint       := .F.
oSay1:lReadOnly       := .F.
oSay1:Align           := 0
oSay1:lVisibleControl := .T.
oSay1:lWordWrap       := .F.
oSay1:lTransparent    := .F.

oGetData                 := TGet():Create(oDlgEnc)
oGetData:cName           := "oGetData"
oGetData:nLeft           := 69
oGetData:nTop            := 32
oGetData:nWidth          := 80
oGetData:nHeight         := 21
oGetData:lShowHint       := .F.
oGetData:lReadOnly       := .F.
oGetData:Align           := 0
oGetData:cVariable       := "dEncTI"
oGetData:bSetGet         := {|u| If(PCount() > 0, dEncTI := u, dEncTI)}
oGetData:lVisibleControl := .T.
oGetData:lPassword       := .F.
oGetData:Picture         := "@D"
oGetData:lHasButton      := .T.

oSay3                 := TSay():Create(oDlgEnc)
oSay3:cName           := "oSay3"
oSay3:cCaption        := "Hora:"
oSay3:nLeft           := 26
oSay3:nTop            := 65
oSay3:nWidth          := 37
oSay3:nHeight         := 17
oSay3:lShowHint       := .F.
oSay3:lReadOnly       := .F.
oSay3:Align           := 0
oSay3:lVisibleControl := .T.
oSay3:lWordWrap       := .F.
oSay3:lTransparent    := .F.

oGetHora                 := TGet():Create(oDlgEnc)
oGetHora:cName           := "oGetHora"
oGetHora:nLeft           := 69
oGetHora:nTop            := 62
oGetHora:nWidth          := 80
oGetHora:nHeight         := 21
oGetHora:lShowHint       := .F.
oGetHora:lReadOnly       := .F.
oGetHora:Align           := 0
oGetHora:cVariable       := "cHoraTI"
oGetHora:bSetGet         := {|u| If(PCount() > 0, cHoraTI := u, cHoraTI)}
oGetHora:lVisibleControl := .T.
oGetHora:lPassword       := .F.
oGetHora:Picture         := "99:99"
oGetHora:lHasButton      := .F.

oGrp5                 := TGroup():Create(oDlgEnc)  //Funçao que cria o quadrado de animaçao
oGrp5:cName           := "oGrp5"
oGrp5:nLeft           := 14
oGrp5:nTop            := 21
oGrp5:nWidth          := oDlgEnc:nWidth -30 //linha da borda da janela
oGrp5:nHeight         := 232//74
oGrp5:lShowHint       := .F.
oGrp5:lReadOnly       := .F.
oGrp5:Align           := 0
oGrp5:lVisibleControl := .T.

oSBtn7                 := SButton():Create(oDlgEnc)
oSBtn7:cName           := "oSBtn7"
oSBtn7:cCaption        := "OK"
oSBtn7:nLeft           := 39
oSBtn7:nTop            := 220
oSBtn7:nWidth          := 55
oSBtn7:nHeight         := 22
oSBtn7:lShowHint       := .F.
oSBtn7:lReadOnly       := .F.
oSBtn7:Align           := 0
oSBtn7:lVisibleControl := .T.
oSBtn7:nType           := 1
oSBtn7:bLClicked       := {|| lResp := .T., oDlgEnc:End()}

oBtnCancel                 := SButton():Create(oDlgEnc)
oBtnCancel:cName           := "oBtnCancel"
oBtnCancel:cCaption        := "Cancelar"
oBtnCancel:nLeft           := 110
oBtnCancel:nTop            := 220
oBtnCancel:nWidth          := 55
oBtnCancel:nHeight         := 22
oBtnCancel:lShowHint       := .F.
oBtnCancel:lReadOnly       := .F.
oBtnCancel:Align           := 0
oBtnCancel:lVisibleControl := .T.
oBtnCancel:nType           := 2
oBtnCancel:bLClicked       := {|| oDlgEnc:End()}  

oDlgEnc:Activate()     

If lResp
	RecLock("SZ4", .F.)
		SZ4->Z4_DTENC  := dEncTI
		SZ4->Z4_HRENC  := cHoraTI                                                                                                        
		SZ4->Z4_STATUS := "5"	// Encerrado        
	    SZ4->Z4_OPERA  := cOpera  // Trava a tabela para escrever no campo 
	    SZ4->Z4_NF     := cNota 
	    SZ4->Z4_PALLET := cPallet 
        SZ4->Z4_VOL    := cVolume 
        SZ4->Z4_OBS    := cObs
        SZ4->Z4_UNVOL  := cTipo 
        SZ4->Z4_OBSC   := cObsc
	MsUnlock()
EndIf

Return          
// ============================================================   FUNÇÃO RECEBIMENTO ======================================================================// 

  
User Function Receb() 

Local cOpera
Local dEncTI  := dDataBase                    
Local cHoraTI := SubStr(Time(), 1, 5)
Local lResp   := .F.  

Local cPedido := Space (11)  
Local cOpera
Local cNota
Local cPallet
Local cVolume := Space (6)
Local cObs
Local cTipo		
Local cFrac	                                                                                                     
Local cObsr  

Local cNF1   := Space (10),cNF2   := Space (10),cNF3   := Space (10),cNF4   := Space (10),cNF5   := Space (10),cNF6   := Space (10),cNF7   := Space (10),cNF8   := Space (10),cNF9   := Space (10),cNF10   := Space (10)
Local cPED1   := Space (8),cPED2   := Space (8),cPED3   := Space (8),cPED4   := Space (8),cPED5   := Space (8),cPED6   := Space (8),cPED7   := Space (8),cPED8   := Space (8),cPED9   := Space (8),cPED10   := Space (8)
Local cProd1 := Space (10),cProd2 := Space (10),cProd3 := Space (10),cProd4 := Space (10),cProd5 := Space (10),cProd6 := Space (10),cProd7 := Space (10),cProd8 := Space (10),cProd9 := Space (10),cProd10 := Space (10)
Local nQuant1:= Space (14),nQuant2:= Space (14),nQuant3:= Space (14),nQuant4:= Space (14),nQuant5:= Space (14),nQuant6:= Space (14),nQuant7:= Space (14),nQuant8:= Space (14),nQuant9:= Space (14),nQuant10:= Space (14)
Local cUM1   := Space (4),cUM2   := Space (4),cUM3   := Space (4),cUM4   := Space (4),cUM5   := Space (4),cUM6   := Space (4),cUM7   := Space (4),cUM8   := Space (4),cUM9   := Space (4),cUM10   := Space (4)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/  

SetPrvt("oDlg1","oGrp1","oSay1","oSay2","oSay3","oSay4","oSay5","oSay6","oSay7","oGet1","oGet2","oGet3")
SetPrvt("oCBox2","oCBox3","oCBox4","oGet4","oGrp2","oSay8","oSay9","oSay10","oSay11","oSay12","oSay13","oSay14")
SetPrvt("oSay15","oSay16","oSay17","oSay18","oSay19","oSay20","oSay21","oSay22","oSay23","oSay24","oSay25","oSay26")
SetPrvt("oSay27","oSay28","oSay29","oSay30","oSay31","oSay32","oSay33","oSay34","oSay35","oSay36","oSay37")
SetPrvt("oSay38","oSay39","oSay40","oSay41","oSay42","oSay43","oSay44","oSay45","oSay46","oSay47","oSay48")
SetPrvt("oSay49","oSay50","oSay51","oSay52","oSay53","oSay54","oSay55","oSay56","oSay57")
SetPrvt("oGet6","oGet7","oGet8","oGet9","oGet10","oGet11","oGet12","oGet13","oGet14","oGet15","oGet16")
SetPrvt("oGet18","oGet19","oGet20","oGet21","oGet22","oGet23","oGet24","oGet25","oGet26","oGet27","oGet28")
SetPrvt("oGet29","oGet30","oGet31","oGet32","oGet33","oGet34","oGet35","oGet36","oGet37","oGet38","oGet39")
SetPrvt("oGet40","oGet41","oGet42","oGet43","oGet44","oGet45","oGet46","oGet47","oGet48","oGet49","oGet50","oGet51","oGet52","oGet53","oGet54")
SetPrvt("oBtn1","oBtn2") 

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/   

If SZ4->Z4_STATUS = "5"
	MsgStop("O chamado está Encerrado!", "Operação Não Permitida")
	Return
EndIf

oDlg1      := MSDialog():New( 141,286,655,1053,"Encerramento de Recebimento",,,.F.,,,,,,.T.,,,.T. )
oGrp1      := TGroup():New( 003,003,059,384," Encerrar Recebimento ",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay1      := TSay():New( 017,013,{||"Data :"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,020,008)    
oSay2      := TSay():New( 039,013,{||"Hora :"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,020,008)
oSay3      := TSay():New( 017,317,{||"Volumes :"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay4      := TSay():New( 017,103,{||"Operador: "},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay5      := TSay():New( 039,103,{||"Qtde Palets :"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay6      := TSay():New( 039,220,{||"Fracionado :"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)           
oSay7      := TSay():New( 017,220,{||"Pedido :"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGet1      := TGet():New( 016,035,{|u| If(PCount() > 0, dEncTI := u, dEncTI)},oGrp1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","",,,,,,,)//data
oGet2      := TGet():New( 036,035,{|u| If(PCount() > 0, cHoraTI := u, cHoraTI)},oGrp1,060,009,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","",,,,,,,,)//hora
oGet3      := TGet():New( 016,343,{|u| If(PCount() > 0, cVolume := u, cVolume)},oGrp1,029,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)//volume
oCBox1     := TComboBox():New( 038,343,{|u| If(PCount() > 0, cTipo := u, cTipo)},{"CX","ML","M2","KG","PC","LT","RL"},028,010,oGrp1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, ) //tipo de volume
oCBox2     := TComboBox():New( 016,138,{|u| If(PCount() > 0, cOpera := u, cOpera)},{"MURILO","OZEAS","CARLOS","IVAN","EVERTON","DOUGLAS","ALESSANDRO","MARCOS FAVERO","LEONARDO","MARCELO","FELIPE MASSA","OUTROS"},072,010,oGrp1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, ) //operador
oCBox3     := TComboBox():New( 036,138,{|u| If(PCount() > 0, cPallet := u, cPallet)},{"0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59","60","61","62","63","64","65","66","67","68","69","70"},072,010,oGrp1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, ) //qtd palets
oCBox4     := TComboBox():New( 038,251,{|u| If(PCount() > 0, cFrac := u, cFrac)},{"SIM","NAO"},061,010,oGrp1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,, ) //fracionado
oGet4      := TGet():New( 016,251,{|u| If(PCount() > 0, cPedido := u, cPedido)},oGrp1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)  //pedido
oGrp2      := TGroup():New( 060,003,228,384," Itens ",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay8      := TSay():New( 075,013,{||"NF:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay9      := TSay():New( 075,086,{||"PED.:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay10     := TSay():New( 075,165,{||"PROD.:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay11     := TSay():New( 075,249,{||"QTDE:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay12     := TSay():New( 075,332,{||"UM:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay13     := TSay():New( 090,013,{||"NF:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay14     := TSay():New( 090,086,{||"PED.:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay15     := TSay():New( 090,165,{||"PROD.:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay16     := TSay():New( 090,249,{||"QTDE:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay17     := TSay():New( 090,332,{||"UM:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay18     := TSay():New( 105,013,{||"NF:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay19     := TSay():New( 105,086,{||"PED.:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay20     := TSay():New( 105,165,{||"PROD.:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay21     := TSay():New( 105,249,{||"QTDE:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay22     := TSay():New( 105,332,{||"UM:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay23     := TSay():New( 120,013,{||"NF:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay24     := TSay():New( 120,086,{||"PED.:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay25     := TSay():New( 120,165,{||"PROD.:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay26     := TSay():New( 120,249,{||"QTDE:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay27     := TSay():New( 120,332,{||"UM:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay28     := TSay():New( 135,013,{||"NF:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay29     := TSay():New( 135,086,{||"PED.:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay30     := TSay():New( 135,165,{||"PROD.:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay31     := TSay():New( 135,249,{||"QTDE:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay32     := TSay():New( 135,332,{||"UM:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay33     := TSay():New( 150,013,{||"NF:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay34     := TSay():New( 150,086,{||"PED.:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay35     := TSay():New( 150,165,{||"PROD.:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay36     := TSay():New( 150,249,{||"QTDE:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay37     := TSay():New( 150,332,{||"UM:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay38     := TSay():New( 165,013,{||"NF:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay39     := TSay():New( 165,086,{||"PED.:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay40     := TSay():New( 165,165,{||"PROD.:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay41     := TSay():New( 165,249,{||"QTDE:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay42     := TSay():New( 165,332,{||"UM:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay43     := TSay():New( 180,013,{||"NF:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay44     := TSay():New( 180,086,{||"PED.:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay45     := TSay():New( 180,165,{||"PROD.:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay46     := TSay():New( 180,249,{||"QTDE:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay47     := TSay():New( 180,332,{||"UM:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay48     := TSay():New( 195,013,{||"NF:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay49     := TSay():New( 195,086,{||"PED.:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay50     := TSay():New( 195,165,{||"PROD.:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay51     := TSay():New( 195,249,{||"QTDE:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay52     := TSay():New( 195,332,{||"UM:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay53     := TSay():New( 210,013,{||"NF:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay54     := TSay():New( 210,086,{||"PED.:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay55     := TSay():New( 210,165,{||"PROD.:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay56     := TSay():New( 210,249,{||"QTDE:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay57     := TSay():New( 210,332,{||"UM:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGet5      := TGet():New( 075,022,{|u| If(PCount() > 0, cNF1    := u, cNF1)},    oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet6      := TGet():New( 075,100,{|u| If(PCount() > 0, cPed1  := u, cPed1)},  oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet7      := TGet():New( 075,184,{|u| If(PCount() > 0, cProd1  := u, cProd1)},  oGrp2,060,008,'',{|| U_VldProd(cProd1)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet8      := TGet():New( 075,266,{|u| If(PCount() > 0, nQuant1 := u, nQuant1)}, oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet9      := TGet():New( 075,343,{|u| If(PCount() > 0, cUM1 := u, cUM1)}, oGrp2,020,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet10     := TGet():New( 090,022,{|u| If(PCount() > 0, cNF2    := u, cNF2)},    oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet11     := TGet():New( 090,100,{|u| If(PCount() > 0, cPed2  := u, cPed2)},  oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet12     := TGet():New( 090,184,{|u| If(PCount() > 0, cProd2  := u, cProd2)},  oGrp2,060,008,'',{|| U_VldProd(cProd2)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet13     := TGet():New( 090,266,{|u| If(PCount() > 0, nQuant2 := u, nQuant2)}, oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet14     := TGet():New( 090,343,{|u| If(PCount() > 0, cUM2 := u, cUM2)}, oGrp2,020,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet15     := TGet():New( 105,022,{|u| If(PCount() > 0, cNF3    := u, cNF3)},    oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet16     := TGet():New( 105,100,{|u| If(PCount() > 0, cPed3  := u, cPed3)},  oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet17     := TGet():New( 105,184,{|u| If(PCount() > 0, cProd3  := u, cProd3)},  oGrp2,060,008,'',{|| U_VldProd(cProd3)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet18     := TGet():New( 105,266,{|u| If(PCount() > 0, nQuant3 := u, nQuant3)}, oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet19     := TGet():New( 105,343,{|u| If(PCount() > 0, cUM3 := u, cUM3)}, oGrp2,020,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet20     := TGet():New( 120,022,{|u| If(PCount() > 0, cNF4    := u, cNF4)},    oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet21     := TGet():New( 120,100,{|u| If(PCount() > 0, cPed4  := u, cPed4)},  oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet22     := TGet():New( 120,184,{|u| If(PCount() > 0, cProd4  := u, cProd4)},  oGrp2,060,008,'',{|| U_VldProd(cProd4)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet23     := TGet():New( 120,266,{|u| If(PCount() > 0, nQuant4 := u, nQuant4)}, oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet24     := TGet():New( 120,343,{|u| If(PCount() > 0, cUM4 := u, cUM4)}, oGrp2,020,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet25     := TGet():New( 135,022,{|u| If(PCount() > 0, cNF5    := u, cNF5)},    oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet26     := TGet():New( 135,100,{|u| If(PCount() > 0, cPed5  := u, cPed5)},  oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet27     := TGet():New( 135,184,{|u| If(PCount() > 0, cProd5  := u, cProd5)},  oGrp2,060,008,'',{|| U_VldProd(cProd5)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet28     := TGet():New( 135,266,{|u| If(PCount() > 0, nQuant5 := u, nQuant5)}, oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet29     := TGet():New( 135,343,{|u| If(PCount() > 0, cUM5 := u, cUM5)}, oGrp2,020,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet30     := TGet():New( 150,022,{|u| If(PCount() > 0, cNF6    := u, cNF6)},    oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet31     := TGet():New( 150,100,{|u| If(PCount() > 0, cPed6  := u, cPed6)},  oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet32     := TGet():New( 150,184,{|u| If(PCount() > 0, cProd6  := u, cProd6)},  oGrp2,060,008,'',{|| U_VldProd(cProd6)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet33     := TGet():New( 150,266,{|u| If(PCount() > 0, nQuant6 := u, nQuant6)}, oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet34     := TGet():New( 150,343,{|u| If(PCount() > 0, cUM6 := u, cUM6)}, oGrp2,020,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet35     := TGet():New( 165,022,{|u| If(PCount() > 0, cNF7    := u, cNF7)},    oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet36     := TGet():New( 165,100,{|u| If(PCount() > 0, cPed7  := u, cPed7)},  oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet37     := TGet():New( 165,184,{|u| If(PCount() > 0, cProd7  := u, cProd7)},  oGrp2,060,008,'',{|| U_VldProd(cProd7)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet38     := TGet():New( 165,266,{|u| If(PCount() > 0, nQuant7 := u, nQuant7)}, oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet39     := TGet():New( 165,343,{|u| If(PCount() > 0, cUM7 := u, cUM7)}, oGrp2,020,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet40     := TGet():New( 180,022,{|u| If(PCount() > 0, cNF8    := u, cNF8)},    oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet41     := TGet():New( 180,100,{|u| If(PCount() > 0, cPed8  := u, cPed8)},  oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet42     := TGet():New( 180,184,{|u| If(PCount() > 0, cProd8  := u, cProd8)},  oGrp2,060,008,'',{|| U_VldProd(cProd8)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet43     := TGet():New( 180,266,{|u| If(PCount() > 0, nQuant8 := u, nQuant8)}, oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet44     := TGet():New( 180,343,{|u| If(PCount() > 0, cUM8 := u, cUM8)}, oGrp2,020,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet45     := TGet():New( 195,022,{|u| If(PCount() > 0, cNF9    := u, cNF9)},    oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet46     := TGet():New( 195,100,{|u| If(PCount() > 0, cPed9  := u, cPed9)},  oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet47     := TGet():New( 195,184,{|u| If(PCount() > 0, cProd9  := u, cProd9)},  oGrp2,060,008,'',{|| U_VldProd(cProd9)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet48     := TGet():New( 195,266,{|u| If(PCount() > 0, nQuant9 := u, nQuant9)}, oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet49     := TGet():New( 195,343,{|u| If(PCount() > 0, cUM9 := u, cUM9)}, oGrp2,020,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet50     := TGet():New( 210,022,{|u| If(PCount() > 0, cNF10   := u, cNF10)},    oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet51     := TGet():New( 210,100,{|u| If(PCount() > 0, cPed10 := u, cPed10)},  oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet52     := TGet():New( 210,184,{|u| If(PCount() > 0, cProd10 := u, cProd10)},  oGrp2,060,008,'',{|| U_VldProd(cProd10)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet53     := TGet():New( 210,266,{|u| If(PCount() > 0, nQuant10:= u, nQuant10)}, oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet54     := TGet():New( 210,343,{|u| If(PCount() > 0, cUM10:= u, cUM10)}, oGrp2,020,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oBtn1      := TButton():New( 233,114,"OK",oDlg1,{|| lResp := .T., oDlg1:End()},044,016,,,,.T.,,"",,,,.F. )
oBtn2      := TButton():New( 233,229,"Cancelar",oDlg1,{|| lResp := .F., oDlg1:End()},044,016,,,,.T.,,"",,,,.F. )

oDlg1:Activate(,,,.T.)


If lResp
	RecLock("SZ4", .F.)
		SZ4->Z4_DTENC   := dEncTI
		SZ4->Z4_HRENC   := cHoraTI                                                                                                        
		SZ4->Z4_STATUS  := "3"	// Encerrado
	    SZ4->Z4_OPERA   := cOpera  // Trava a tabela para escrever no campo 	    
	    SZ4->Z4_PALLET  := cPallet 
        SZ4->Z4_VOL     := cVolume 
        SZ4->Z4_OBS     := cObs
        SZ4->Z4_UNVOL   := cTipo
	    SZ4->Z4_FRAC    := cFrac          
	    SZ4->Z4_PEDIDO  := cPedido
	    SZ4->Z4_OBSR    := cObsr 
	    SZ4->Z4_NF1     := cNF1
	    SZ4->Z4_NF2     := cNF2
	    SZ4->Z4_NF3     := cNF3
	    SZ4->Z4_NF4     := cNF4
	    SZ4->Z4_NF5     := cNF5
	    SZ4->Z4_NF6     := cNF6
	    SZ4->Z4_NF7     := cNF7
	    SZ4->Z4_NF8     := cNF8
	    SZ4->Z4_NF9     := cNF9
	    SZ4->Z4_NF10    := cNF10
	    SZ4->Z4_PED1    := cPED1
	    SZ4->Z4_PED2    := cPED2
	    SZ4->Z4_PED3    := cPED3
	    SZ4->Z4_PED4    := cPED4
	    SZ4->Z4_PED5    := cPED5
	    SZ4->Z4_PED6    := cPED6
	    SZ4->Z4_PED7    := cPED7
	    SZ4->Z4_PED8    := cPED8
	    SZ4->Z4_PED9    := cPED9
	    SZ4->Z4_PED10   := cPED10	    
	    SZ4->Z4_PROD1   := cProd1
	    SZ4->Z4_PROD2   := cProd2
	    SZ4->Z4_PROD3   := cProd3
	    SZ4->Z4_PROD4   := cProd4
	    SZ4->Z4_PROD5   := cProd5
	    SZ4->Z4_PROD6   := cProd6
	    SZ4->Z4_PROD7   := cProd7
	    SZ4->Z4_PROD8   := cProd8
	    SZ4->Z4_PROD9   := cProd9
	    SZ4->Z4_PROD10  := cProd10
	    SZ4->Z4_QTD1    := VAL(nQuant1) //VAL(<variavel>) converte texto em numero
	    SZ4->Z4_QTD2    := VAL(nQuant2)
	    SZ4->Z4_QTD3    := VAL(nQuant3)
	    SZ4->Z4_QTD4    := VAL(nQuant4)
	    SZ4->Z4_QTD5    := VAL(nQuant5)
	    SZ4->Z4_QTD6    := VAL(nQuant6)
	    SZ4->Z4_QTD7    := VAL(nQuant7)
	    SZ4->Z4_QTD8    := VAL(nQuant8)
	    SZ4->Z4_QTD9    := VAL(nQuant9)
	    SZ4->Z4_QTD10   := VAL(nQuant10)
	    SZ4->Z4_UM1     := cUM1
	    SZ4->Z4_UM2     := cUM2
	    SZ4->Z4_UM3     := cUM3
	    SZ4->Z4_UM4     := cUM4
	    SZ4->Z4_UM5     := cUM5
	    SZ4->Z4_UM6     := cUM6
	    SZ4->Z4_UM7     := cUM7
	    SZ4->Z4_UM8     := cUM8
	    SZ4->Z4_UM9     := cUM9
	    SZ4->Z4_UM10    := cUM10	    
	MsUnlock()
EndIf

Return  

//============================================================ FIM FUNÇÃO RECEBIEMNTO =====================================================================//

//=============================================================  Função Produtos ===========================================================================

User Function Produ


Local lResp    := .F.
Local _MEMO    := " "
Local aArea    := GetArea()
Local aAreaSZ4 := SZ4->(GetArea()) 


Local cNF1    := SZ4->Z4_NF1
Local cNF2    := SZ4->Z4_NF2
Local cNF3    := SZ4->Z4_NF3
Local cNF4    := SZ4->Z4_NF4
Local cNF5    := SZ4->Z4_NF5
Local cNF6    := SZ4->Z4_NF6
Local cNF7    := SZ4->Z4_NF7
Local cNF8    := SZ4->Z4_NF8
Local cNF9    := SZ4->Z4_NF9
Local cNF10   := SZ4->Z4_NF10
Local cPED1   := SZ4->Z4_PED1
Local cPED2   := SZ4->Z4_PED2
Local cPED3   := SZ4->Z4_PED3
Local cPED4   := SZ4->Z4_PED4
Local cPED5   := SZ4->Z4_PED5
Local cPED6   := SZ4->Z4_PED6
Local cPED7   := SZ4->Z4_PED7
Local cPED8   := SZ4->Z4_PED8
Local cPED9   := SZ4->Z4_PED9
Local cPED10   := SZ4->Z4_PED10
Local cProd1  := SZ4->Z4_PROD1
Local cProd2  := SZ4->Z4_PROD2
Local cProd3  := SZ4->Z4_PROD3
Local cProd4  := SZ4->Z4_PROD4
Local cProd5  := SZ4->Z4_PROD5
Local cProd6  := SZ4->Z4_PROD6
Local cProd7  := SZ4->Z4_PROD7
Local cProd8  := SZ4->Z4_PROD8
Local cProd9  := SZ4->Z4_PROD9
Local cProd10 := SZ4->Z4_PROD10
Local nQuant1 := ROUND(SZ4->Z4_QTD1,6)
Local nQuant2 := ROUND(SZ4->Z4_QTD2,6)
Local nQuant3 := ROUND(SZ4->Z4_QTD3,6)
Local nQuant4 := ROUND(SZ4->Z4_QTD4,6)
Local nQuant5 := ROUND(SZ4->Z4_QTD5,6)
Local nQuant6 := ROUND(SZ4->Z4_QTD6,6)
Local nQuant7 := ROUND(SZ4->Z4_QTD7,6)
Local nQuant8 := ROUND(SZ4->Z4_QTD8,6)
Local nQuant9 := ROUND(SZ4->Z4_QTD9,6)
Local nQuant10:= ROUND(SZ4->Z4_QTD10,6)
Local cUM1    := SZ4->Z4_UM1
Local cUM2    := SZ4->Z4_UM2
Local cUM3    := SZ4->Z4_UM3
Local cUM4    := SZ4->Z4_UM4
Local cUM5    := SZ4->Z4_UM5
Local cUM6    := SZ4->Z4_UM6
Local cUM7    := SZ4->Z4_UM7
Local cUM8    := SZ4->Z4_UM8
Local cUM9    := SZ4->Z4_UM9
Local cUM10   := SZ4->Z4_UM10
			
/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlg1","oGrp1","oSay1","oSay2","oCBox1","oCBox2","oGrp2","oSay8","oSay9","oSay10","oSay11","oSay12","oSay13","oSay14")
SetPrvt("oSay15","oSay16","oSay17","oSay18","oSay19","oSay20","oSay21","oSay22","oSay23","oSay24","oSay25")
SetPrvt("oSay27","oSay28","oSay29","oSay30","oSay31","oSay32","oSay33","oSay34","oSay35","oSay36","oSay37")
SetPrvt("oSay38","oSay39","oSay40","oSay41","oSay42","oSay43","oSay44","oSay45","oSay46","oSay47","oSay48")
SetPrvt("oSay49","oSay50","oSay51","oSay52","oSay53","oSay54","oSay55","oSay56","oSay57")
SetPrvt("oGet5","oGet6","oGet7","oGet8","oGet9","oGet10","oGet11","oGet12","oGet13","oGet14","oGet15","oGet16")
SetPrvt("oGet18","oGet19","oGet20","oGet21","oGet22","oGet23","oGet24","oGet25","oGet26","oGet27","oGet28")
SetPrvt("oGet29","oGet30","oGet31","oGet32","oGet33","oGet34","oGet35","oGet36","oGet37","oGet38","oGet39")
SetPrvt("oGet40","oGet41","oGet42","oGet43","oGet44","oGet45","oGet46","oGet47","oGet48","oGet49","oGet50","oGet51","oGet52","oGet53","oGet54")
SetPrvt("oBtn1","oBtn2")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlg1      := MSDialog():New( 141,286,546,1068,"Encerramento de Recebimento",,,.F.,,,,,,.T.,,,.T. )
oGrp2      := TGroup():New( 004,003,172,384," Itens ",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay8      := TSay():New( 012,013,{||"NF:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay9      := TSay():New( 012,086,{||"PED.:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay10     := TSay():New( 012,165,{||"PROD.:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay11     := TSay():New( 012,249,{||"QTDE:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay12     := TSay():New( 012,332,{||"UM:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay13     := TSay():New( 027,013,{||"NF:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay14     := TSay():New( 027,086,{||"PED.:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay15     := TSay():New( 027,165,{||"PROD.:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay16     := TSay():New( 027,249,{||"QTDE:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay17     := TSay():New( 027,332,{||"UM:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay18     := TSay():New( 042,013,{||"NF:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay19     := TSay():New( 042,086,{||"PED.:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay20     := TSay():New( 042,165,{||"PROD.:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay21     := TSay():New( 042,249,{||"QTDE:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay22     := TSay():New( 042,332,{||"UM:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay23     := TSay():New( 057,013,{||"NF:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay24     := TSay():New( 057,086,{||"PED.:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay25     := TSay():New( 057,165,{||"PROD.:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay26     := TSay():New( 057,249,{||"QTDE:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay27     := TSay():New( 057,332,{||"UM:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay28     := TSay():New( 072,013,{||"NF:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay29     := TSay():New( 072,086,{||"PED.:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay30     := TSay():New( 072,165,{||"PROD.:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay31     := TSay():New( 072,249,{||"QTDE:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay32     := TSay():New( 072,332,{||"UM:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay33     := TSay():New( 087,013,{||"NF:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay34     := TSay():New( 087,086,{||"PED.:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay35     := TSay():New( 087,165,{||"PROD.:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay36     := TSay():New( 087,249,{||"QTDE:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay37     := TSay():New( 087,332,{||"UM:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay38     := TSay():New( 102,013,{||"NF:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay39     := TSay():New( 102,086,{||"PED.:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay40     := TSay():New( 102,165,{||"PROD.:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay41     := TSay():New( 102,249,{||"QTDE:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay42     := TSay():New( 102,332,{||"UM:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay43     := TSay():New( 117,013,{||"NF:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay44     := TSay():New( 117,086,{||"PED.:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay45     := TSay():New( 117,165,{||"PROD.:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay46     := TSay():New( 117,249,{||"QTDE:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay47     := TSay():New( 117,332,{||"UM:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay48     := TSay():New( 132,013,{||"NF:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay49     := TSay():New( 132,086,{||"PED.:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay50     := TSay():New( 132,165,{||"PROD.:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay51     := TSay():New( 132,249,{||"QTDE:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay52     := TSay():New( 132,332,{||"UM:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay53     := TSay():New( 147,013,{||"NF:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay54     := TSay():New( 147,086,{||"PED.:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay55     := TSay():New( 147,165,{||"PROD.:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay56     := TSay():New( 147,249,{||"QTDE:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay57     := TSay():New( 147,332,{||"UM:"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oGet5      := TGet():New( 012,022,{|u| cNF1},    oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet6      := TGet():New( 012,100,{|u| cPed1},  oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet7      := TGet():New( 012,184,{|u| cProd1},  oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet8      := TGet():New( 012,266,{|u| nQuant1}, oGrp2,060,008,"@E 9,999,999.999999",,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet9      := TGet():New( 012,343,{|u| cUM1}, oGrp2,020,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet10     := TGet():New( 027,022,{|u| cNF2},    oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet11     := TGet():New( 027,100,{|u| cPed2},  oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet12     := TGet():New( 027,184,{|u| cProd2},  oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet13     := TGet():New( 027,266,{|u| nQuant2}, oGrp2,060,008,"@E 9,999,999.999999",,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet14     := TGet():New( 027,343,{|u| cUM2}, oGrp2,020,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet15     := TGet():New( 042,022,{|u| cNF3},    oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet16     := TGet():New( 042,100,{|u| cPed3},  oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet17     := TGet():New( 042,184,{|u| cProd3},  oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet18     := TGet():New( 042,266,{|u| nQuant3}, oGrp2,060,008,"@E 9,999,999.999999",,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet19     := TGet():New( 042,343,{|u| cUM3}, oGrp2,020,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet20     := TGet():New( 057,022,{|u| cNF4},    oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet21     := TGet():New( 057,100,{|u| cPed4},  oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet22     := TGet():New( 057,184,{|u| cProd4},  oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet23     := TGet():New( 057,266,{|u| nQuant4}, oGrp2,060,008,"@E 9,999,999.999999",,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet24     := TGet():New( 057,343,{|u| cUM4}, oGrp2,020,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet25     := TGet():New( 072,022,{|u| cNF5},    oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet26     := TGet():New( 072,100,{|u| cPed5},  oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet27     := TGet():New( 072,184,{|u| cProd5},  oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet28     := TGet():New( 072,266,{|u| nQuant5}, oGrp2,060,008,"@E 9,999,999.999999",,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet29     := TGet():New( 072,343,{|u| cUM5}, oGrp2,020,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet30     := TGet():New( 087,022,{|u| cNF6},    oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet31     := TGet():New( 087,100,{|u| cPed6},  oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet32     := TGet():New( 087,184,{|u| cProd6},  oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet33     := TGet():New( 087,266,{|u| nQuant6}, oGrp2,060,008,"@E 9,999,999.999999",,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet34     := TGet():New( 087,343,{|u| cUM6}, oGrp2,020,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet35     := TGet():New( 102,022,{|u| cNF7},    oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet36     := TGet():New( 102,100,{|u| cPed7},  oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet37     := TGet():New( 102,184,{|u| cProd7},  oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet38     := TGet():New( 102,266,{|u| nQuant7}, oGrp2,060,008,"@E 9,999,999.999999",,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet39     := TGet():New( 102,343,{|u| cUM7}, oGrp2,020,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet40     := TGet():New( 117,022,{|u| cNF8},    oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet41     := TGet():New( 117,100,{|u| cPed8},  oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet42     := TGet():New( 117,184,{|u| cProd8},  oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet43     := TGet():New( 117,266,{|u| nQuant8}, oGrp2,060,008,"@E 9,999,999.999999",,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet44     := TGet():New( 117,343,{|u| cUM8}, oGrp2,020,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet45     := TGet():New( 132,022,{|u| cNF9},    oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet46     := TGet():New( 132,100,{|u| cPed9},  oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet47     := TGet():New( 132,184,{|u| cProd9},  oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet48     := TGet():New( 132,266,{|u| nQuant9}, oGrp2,060,008,"@E 9,999,999.999999",,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet49     := TGet():New( 132,343,{|u| cUM9}, oGrp2,020,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet50     := TGet():New( 147,022,{|u| cNF10},    oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet51     := TGet():New( 147,100,{|u| cPed10},  oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet52     := TGet():New( 147,184,{|u| cProd10},  oGrp2,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet53     := TGet():New( 147,266,{|u| nQuant10}, oGrp2,060,008,"@E 9,999,999.999999",,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oGet54     := TGet():New( 147,343,{|u| cUM10}, oGrp2,020,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oBtn1      := TButton():New( 180,180,"Fechar",oDlg1,{|| lResp := .T., oDlg1:End()},044,016,,,,.T.,,"",,,,.F. )

oDlg1:Activate(,,,.T.)
			
RestArea(aAreaSZ4)
RestArea(aArea)

Return

//============================================================  Fim Função Produtos =======================================================================


User Function TILegenda()

BrwLegenda(cCadastro, "Legenda", {	{"BR_VERDE"    , "AGUARDANDO A ENTRADA" },;
									{"BR_VIOLETA"  , "AGUARDANDO LIBERAÇÃO DA QUALIDADE"},;       
									{"BR_AMARELO"  , "EM OPERAÇÃO"},;
									{"BR_VERMELHO" , "OPERAÇÃO FINALIZADA"},;
									{"BR_PRETO"    , "CANCELADO"}  })

Return
/// Valida produto
User Function VldProd(cProd)

Local lRet := .T.

DbselectArea("SB1")
DbSetOrder(1)
If !DbSeek(xFilial("SB1")+PADR(cProd,TamSX3("B1_COD")[1]))
   	Alert("Produto não Cadastrado, corrija o codigo digitado!")
   	LRet := .F.
ElseIf SB1->B1_ZZSTATU == "2"
	MsgInfo("Produto em Desenvolvimento.", "Atenção")
EndIf

Return LRet