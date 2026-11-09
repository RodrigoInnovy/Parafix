#Include 'TOTVS.ch'
#Include 'TOPCONN.CH'

//REGISTROS NA SF9 COM TAMANHO SUPERIOR A 6 CARACTERES
//AJUSTA NUMERA플O DA SF9 COM 6 POSI합ES
// ADICIONAR A FUN플O NO X3_RELA플O DO CAMPO F9_CODIGO
// LUCAS SILVA - 07/08/2024

User Function NextSF9()
Local aArea         := GetArea()
Local cNum := GETSXENUM("SF9","F9_CODIGO")
Local cQuery := ""


IF LEN(cNum) > 6

cQuery := " SELECT (MAX(F9.F9_CODIGO)) AS CODIGO "
cQuery += " FROM SF9010 F9 "
cQuery += " WHERE F9.F9_FILIAL = '"+ XFILIAL("SF9") + "' " 
cQuery += " AND (LEN(F9.F9_CODIGO) = 6) "
cQuery += " AND F9.D_E_L_E_T_ = '' "

TcQuery cQuery New Alias "QRY"

dbSelectArea("QRY")

cNum := strzero((val(QRY->CODIGO) + 1),6)

ConfirmSX8()

ENDIF

RestArea(aArea)

Return cNum


 

 
 /*
User Function NextSA1Cod()
Local cNum := GETSXENUM("SA1","A1_COD")
 
DbSelectArea("SA1")
SA1->(DbSetOrder(1))
While (DbSeek(xFilial("SA1")+cNum))
ConfirmSX8()
 
cNum := GETSXENUM("SA1","A1_COD")
Enddo
 
DbCloseArea()
RollbackSx8()
Return cNum

*/
