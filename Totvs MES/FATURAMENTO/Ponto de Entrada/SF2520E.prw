#Include "Protheus.ch"
#Include "TopConn.ch"

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



User Function SF2520E() 

Local lRet   := .T.
Local cQry	:= ""
Local cQry2	:= ""
Local cQry3	:= ""
Local aNrCtrl := {}
Private nStart

FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG SF2520E: ENTROU", 0, (nStart - Seconds()), {})   
/*

//Validação para identificar se possui ordem de separação gerada para a Nota Fiscal.


DbSelectArea("CB7")	
CB7->(DbSetOrder(1)) 
CB7->(dbSeek(SF2->F2_FILIAL+SF2->F2_DOC+SF2->F2_SERIE)) 

validsf2 := SF2->F2_FILIAL+SF2->F2_DOC+SF2->F2_SERIE
validcb7 := POSICIONE("CB7",4,XFILIAL("CB7")+SF2->F2_DOC+SF2->F2_SERIE,"CB7_FILIAL+CB7_NOTA+CB7_SERIE")

if validcb7 == validsf2

ALERT("O Produto possui Ordem de Separação, Exclua a ordem de separação antes de excluir a NF")
lRet   := .F.

Endif
*/


/* CDL->(dbSetOrder(1)) 
 if CDL->(dbSeek(xFilial("CDL")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA ))
 	RecLock("CDL",.f.,.t.)
		CDL->(dbdelete())
	MsUnlock("CDL") 
 endIf

 If SF2->F2_TIPO = "B"
	cQry2 := "SELECT DISTINCT Z8_NRCTRL "
	cQry2 += "FROM " + RetSqlName("SZ8") + " "
	cQry2 += "WHERE D_E_L_E_T_ = ' ' "
	cQry2 += "AND Z8_FILIAL = '"+xFilial("SZ8")+"' "
	cQry2 += "AND Z8_FILORI = '"+SF2->F2_FILIAL+"' "
	cQry2 += "AND Z8_DOC = '"+SF2->F2_DOC+"' "
	cQry2 += "AND Z8_SERIE = '"+SF2->F2_SERIE+"' "
	cQry2 += "AND Z8_CLIFOR = '"+SF2->F2_CLIENTE+"' "
	cQry2 += "AND Z8_LOJA = '"+SF2->F2_LOJA+"' "
	cQry2 += "AND Z8_EMISSAO = '"+DTOS(SF2->F2_EMISSAO)+"' "
	
	cQry2 := ChangeQuery(cQry2)
	
	TCQuery cQry2 New Alias "TSZ8"
			
	DBSelectArea("TSZ8")
	DBGoTop()
	While !Eof()
		aAdd(aNrCtrl,TSZ8->Z8_NRCTRL)
		TSZ8->(dbskip())
	End
	TSZ8->(DBCloseArea())	
	 
 EndIf

 cQry := "UPDATE " + RetSqlName("SZ8") + " SET D_E_L_E_T_ = '*' "
 cQry += "FROM " + RetSqlName("SZ8") + " "
 cQry += "WHERE D_E_L_E_T_ = ' ' "
 cQry += "AND Z8_FILIAL = '"+xFilial("SZ8")+"' "
 cQry += "AND Z8_FILORI = '"+SF2->F2_FILIAL+"' "
 cQry += "AND Z8_DOC = '"+SF2->F2_DOC+"' "
 cQry += "AND Z8_SERIE = '"+SF2->F2_SERIE+"' "
 cQry += "AND Z8_CLIFOR = '"+SF2->F2_CLIENTE+"' "
 cQry += "AND Z8_LOJA = '"+SF2->F2_LOJA+"' "
 cQry += "AND Z8_EMISSAO = '"+DTOS(SF2->F2_EMISSAO)+"' "
 
 TCSqlExec( cQry )	
 
 If len(aNrCtrl) > 0
	 for x := 1 to len(aNrCtrl)
	 	 cQry3 := "UPDATE " + RetSqlName("SZ8") + " SET Z8_SALDO = Z8.Z8_QUANT - IsNull(SZ8.Z8_QUANT,0) "
		 cQry3 += "FROM " + RetSqlName("SZ8") + " Z8 "
		 cQry3 += "LEFT JOIN (SELECT Z.Z8_NRCTRL, SUM(Z.Z8_QUANT) AS Z8_QUANT FROM " + RetSqlName("SZ8") + " Z "
		 cQry3 += "            WHERE Z.D_E_L_E_T_ = ' ' AND Z.Z8_FILIAL = '"+xFilial("SZ8")+"' AND  Z.Z8_TIPO = 'D' "
		 cQry3 += "			  GROUP BY Z.Z8_NRCTRL) SZ8 ON SZ8.Z8_NRCTRL = Z8.Z8_NRCTRL "
		 cQry3 += "WHERE Z8.D_E_L_E_T_ = ' ' "
		 cQry3 += "AND Z8.Z8_FILIAL = '"+xFilial("SZ8")+"' "
		 cQry3 += "AND Z8.Z8_NRCTRL = '"+aNrCtrl[x]+"' "
		 cQry3 += "AND Z8.Z8_TIPO = 'R' " 
		 
		 TCSqlExec( cQry3 )	
		 
	 next x
 EndIf*/


 
 U_DelCtrlExp('3') 

 
Return(lRet)
