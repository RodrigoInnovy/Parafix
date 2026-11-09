// Fonte customizado para aletara o Fornecedor no Pedido de Compras.

#INCLUDE "RWMAKE.CH"
#DEFINE ENTER Chr(13)+Chr(10)
/*
//*******************************************************************************
Rotina: MATA120
ExecBlock: MT120BRW
Ponto: Antes da chamada da função de Browse.
Observações: Utilizado para o tratamento de dados a serem apresentados. no Browse.
Retorno Esperado: Nenhum.
//*******************************************************************************
*/
User Function MT120BRW
//aadd(aRotina, {OemToAnsi("Manut. Dt. Entrega"), "U_MNTDTCP", 0 , 2} ) //inbilitado-  Vinicius
aadd(aRotina, {OemToAnsi("Altera Fornecedor"), "U_XALTFOR", 0 , 2} )
Return

//*******************************************************************************
//*
//*******************************************************************************
User Function XALTFOR()
Local nQUJE := 0
Private cPerg := PADR('XALTFOR',10)

//IF !(__cUserID $ "000000;000207") // códigos dos UserId permitidos na rotina
//APMSGALERT( "Você não tem permissão para usar essa rotina !!!","ATENÇÃO")
//RETURN
//ENDIF

CriaSx1()
//+
//| Disponibiliza para usuario digitar os parametros
//+
IF !Pergunte(cPerg,.T.)
RETURN
ENDIF
cMsg := "PEDIDO: "+SC7->C7_NUM+ENTER
cMsg += "**DE:"+ENTER+SC7->C7_FORNECE+"/"+SC7->C7_LOJA+" - "+Posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_NOME")+ENTER
cMsg += "**PARA:"+ENTER+MV_PAR01+"/"+MV_PAR02+" - "+Posicione("SA2",1,xFilial("SA2")+MV_PAR01+MV_PAR02,"A2_NOME")+ENTER
cMsg += ENTER+"ATENCAO: ESSA MODIFICACAO NAO TEM COMO RETORNAR !!!"
IF (Aviso("ATENCAO",cMsg,{"Sim","Nao"},3,"De/Para")) == 1

cQuery := "SELECT SUM(C7_QUJE) QTDE FROM "+RetSqlname("SC7")+ENTER
cQuery += " WHERE C7_FILIAL='"+xFilial("SC7")+"' AND "
cQuery += " C7_NUM = "+VALTOSQL(SC7->C7_NUM)+" AND C7_FORNECE = "+VALTOSQL(SC7->C7_FORNECE)+" AND C7_LOJA = "+VALTOSQL(SC7->C7_LOJA)+ENTER
cQuery += " AND D_E_L_E_T_=' ' "+ENTER
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.T.,.T.)
nQUJE := TRB->QTDE
TRB->(dbCloseArea())

IF nQUJE == 0
cQuery := "UPDATE "+RetSqlname("SC7")+ENTER
cQuery += " SET "+ENTER
cQuery += " C7_FORNECE = "+VALTOSQL(MV_PAR01)+ENTER
cQuery += " ,C7_LOJA = "+VALTOSQL(MV_PAR02)+ENTER
cQuery += " FROM "+RetSqlname("SC7")+ENTER
cQuery += " WHERE C7_FILIAL='"+xFilial("SC7")+"' AND "
cQuery += " C7_NUM = "+VALTOSQL(SC7->C7_NUM)+" AND C7_FORNECE = "+VALTOSQL(SC7->C7_FORNECE)+" AND C7_LOJA = "+VALTOSQL(SC7->C7_LOJA)
cQuery += " AND D_E_L_E_T_=' ' "
//Memowrite("c:\siga\XALTFOR.sql",cQuery)
TcSqlExec(cQuery)
ApMsgInfo("Alteracao efetuada com sucesso !!!")
ELSE
ALERT("ROTINA CANCELADA !!! Ja teve entrega para esse pedido !!!")
ENDIF
ENDIF
Return

//*******************************************************************************
//*
//*******************************************************************************
User Function MNTDTCP

//IF !(__cUserID $ "000000;000207") // Admin, Anderson
//APMSGALERT( "Você não tem permissão para usar essa rotina !!!","ATENÇÃO")
//RETURN
//ENDIF

_dData :=SC7->C7_DATPRF

@ 090,20 TO 300,470 DIALOG oDlg1 TITLE "Alteração da Data de Entrega"
@ 013,002 SAY "PEDIDO: "+SC7->C7_NUM+" - ITEM: "+SC7->C7_ITEM
@ 025,002 SAY "FORNECEDOR: "+Posicione("SA2",1,xFilial("SA2")+SC7->(C7_FORNECE+C7_LOJA),"A2_NOME")
@ 037,002 SAY "PRODUTO: "+ALLTRIM(SC7->C7_PRODUTO)+" - "+ALLTRIM(SC7->C7_DESCRI)
@ 049,002 SAY "DATA ENTREGA ATUAL: "+DTOC(SC7->C7_DATPRF)
@ 061,002 SAY "NOVA DATA ENTREGA :"
@ 061,075 GET _dData PICTURE "99/99/99"

@ 090,140 BMPBUTTON TYPE 1 ACTION Grava()
@ 090,170 BMPBUTTON TYPE 2 ACTION Close(oDlg1)
ACTIVATE DIALOG oDlg1 CENTERED

Return

//*******************************************************************************
//*
//*******************************************************************************
STATIC Function GRAVA()

Close(oDlg1)
RECLOCK("SC7",.F.)
SC7->C7_DATPRF := _dData
MSUNLOCK()

ApMsgInfo("Alteracao efetuada com sucesso !!!")
RETURN


///////////////////////////////////////////////////////////////////////////////////
//+
//
//| PROGRAMA | Relatorio_SQL.prw | AUTOR | | DATA | 18/01/2004 |//
//+
//
//| DESCRICAO | Funcao - CriaSX1() |//
//| | Fonte utilizado no curso oficina de programacao. |//
//| | Funcao que cria o grupo de perguntas se caso nao existir |//
//+
//
///////////////////////////////////////////////////////////////////////////////////
Static Function CriaSx1()
Local j := 0
Local nY := 0
Local aAreaAnt := GetArea()
Local aAreaSX1 := SX1->(GetArea())
Local aReg := {}

aAdd(aReg,{cPerg,"01","Fornecedor ? ","mv_ch1","C",6,0,0,"G","","mv_par01","","","","","","","","","","","","","","","SA2"})
aAdd(aReg,{cPerg,"02","Loja ? ","mv_ch2","C",2,0,0,"G","","","","","","","","","","","","","","","","",""})
aAdd(aReg,{"X1_GRUPO","X1_ORDEM","X1_PERGUNT","X1_VARIAVL","X1_TIPO","X1_TAMANHO","X1_DECIMAL","X1_PRESEL","X1_GSC","X1_VALID","X1_VAR01","X1_DEF01","X1_CNT01","X1_VAR02","X1_DEF02","X1_CNT02","X1_VAR03","X1_DEF03","X1_CNT03","X1_VAR04","X1_DEF04","X1_CNT04","X1_VAR05","X1_DEF05","X1_CNT05","X1_F3"})

dbSelectArea("SX1")
dbSetOrder(1)

For ny:=1 to Len(aReg)-1
If !dbSeek(aReg[ny,1]+aReg[ny,2])
RecLock("SX1",.T.)
For j:=1 to Len(aReg[ny])
FieldPut(FieldPos(aReg[Len(aReg)][j]),aReg[ny,j])
Next j
MsUnlock()
EndIf
Next ny 

RestArea(aAreaSX1)
RestArea(aAreaAnt)

Return Nil
