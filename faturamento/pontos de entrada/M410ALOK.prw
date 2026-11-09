//********************************************************************************************
// Fonte onde sistema bloqueia se o Pedido de Venda possui Ordem de separação em aberto
//********************************************************************************************

#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

User Function M410ALOK()

Local aArea      := GetArea()
Local aAreaCB7   := CB7->(GetArea())
Local lRet       := .T.
Local cQuery     := "select CB7_STATUS, CB7_PEDIDO, CB7_ORDSEP from CB7010 where D_E_L_E_T_ = '' and CB7_FILIAL = '"+SC5->C5_FILIAL+"' and CB7_PEDIDO = '"+SC5->C5_NUM+"' and CB7_STATUS < '6'" 
TcQuery cQuery New Alias "QRY"

dbSelectArea("QRY")

If QRY->CB7_STATUS >= "0"
MsgStop("Este pedido possui a Ordem de Separação "+QRY->CB7_ORDSEP+" em andamento.","PROIBIDO ALTERAR")
//lRet := .F.
EndIF

QRY->(dbCloseArea()) //Fecha a área de trabalho

RestArea(aAreaCB7)
RestArea(aArea)

Return lRet
