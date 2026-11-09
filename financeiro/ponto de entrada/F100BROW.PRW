// Permite alterar Valor do movimento bancário.

#INCLUDE "RWMAKE.CH"
#DEFINE ENTER Chr(13)+Chr(10)

User Function F100BROW()


aadd(aRotina, {OemToAnsi("Altera Valor e Tx."), "U_ZSE5", 0 , 2} )
Return

//*******************************************************************************
//*
//*******************************************************************************
User Function ZSE5()
Private cPerg := PADR('ZSE5',10)

CriaSx1()
//+
//| Disponibiliza para usuario digitar os parametros
//+
IF !Pergunte(cPerg,.T.)
RETURN
ENDIF
cMsg := "TITULO: "+SE5->E5_NUMERO+ENTER
cMsg += "DE VALOR: "+cValToChar(SE5->E5_VALOR)+ENTER
cMsg += "PARA VALOR: "+cValToChar(MV_PAR01)+ENTER
cMsg += "DE TAXA: "+cValToChar(SE5->E5_TXMOEDA)+ENTER
cMsg += "PARA TAXA: "+cValToChar(MV_PAR02)+ENTER
cMsg += "ATENCAO: ESSA MODIFICACAO NAO TEM COMO RETORNAR!!!"
IF (SE5->E5_LA <>'S')
    IF(Aviso("ATENCAO",cMsg,{"Sim","Nao"},3,"De/Para") == 1)
        RECLOCK("SE5",.F.)
        E5_VALOR   := MV_PAR01
        E5_VLMOED2 := MV_PAR01
        E5_TXMOEDA := MV_PAR02
    MSUNLOCK()
    ApMsgInfo("Alteracao efetuada com sucesso! Faça o recalculo do saldo bancario")
    EndIf
ELSE
    ApMsgInfo("Movimento ja foi contabilizado, Nao pode alterar!")
EndIf


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

aAdd(aReg,{cPerg,"01","Valor Dolar? ","mv_ch1","N",9,2})
aAdd(aReg,{cPerg,"02","Taxa Dolar? ","mv_ch2","N",6,4})
aAdd(aReg,{"X1_GRUPO","X1_ORDEM","X1_PERGUNT","X1_VARIAVL","X1_TIPO","X1_TAMANHO","X1_DECIMAL"})

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
