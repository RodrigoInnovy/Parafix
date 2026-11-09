//Contador automatico para tela de Desembaraço do EIC campo W6_HAWB
//Usando a Logica Prefixo = IMP + ANO + Numero Sequencial (IMP20240001)

#include "rwmake.ch"

User Function CONTW6()
Local cCodigo := ""
Local aArea := GetArea()

cQuery := " "
cQuery += " SELECT MAX(W6_HAWB) AS COD, SUBSTRING(MAX(W6_HAWB),8,4) AS CODSEQ, YEAR(GETDATE()) as YEAR, PREFIXO ='IMP' "
cQuery += " FROM SW6010 "
cQuery += " WHERE SW6010.D_E_L_E_T_ = '' AND YEAR(W6_DT_HAWB) = YEAR(GETDATE()) AND W6_HAWB like 'IMP%'"

cQuery := ChangeQuery(cQuery)

dbUseArea( .T.,"TOPCONN",TCGENQRY(,,cQuery),"TRB",.F.,.T.)

dbSelectArea("TRB")
dbGoTop()

If Empty(TRB->COD)
cCodigo := "IMP"+cValToChar(TRB->YEAR)+"0001"
Else
cIncremen := Strzero(Val(TRB->CODSEQ)+1,4)
cCodigo := "IMP" + cValToChar(TRB->YEAR) + cIncremen
EndIf

TRB->(dbCloseArea()) //Fecha a Area de trabalho

RestArea(aArea)

Return(cCodigo)
