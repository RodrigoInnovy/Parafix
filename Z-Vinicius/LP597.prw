//LP 597 contabilizar a conta de crédito buscando a Natureza do PA.
#INCLUDE 'Protheus.ch'
#INCLUDE "TOPCONN.CH"
  
User FUNCTION LP597()
 
Local aArea           := GetArea()  
Local cContaCredito   := ''
Local cDocumenSE5 	  := SUBSTR(SE5->E5_DOCUMEN,4,9)
Local cNaturezaSE5    := ''
Local cQuery        := "select E5_NATUREZ From SE5010 where E5_TIPO ='PA' And E5_NUMERO = '"+cDocumenSE5+"' and E5_TIPODOC ='PA' and D_E_L_E_T_ =''"
TcQuery cQuery New Alias "QRY"

dbSelectArea("QRY")
cNaturezaSE5 := ALLTRIM(QRY->E5_NATUREZ)
QRY->(dbCloseArea()) //Fecha a Area de trabalho

cContaCredito := ALLTRIM(posicione("SED",1,xfilial("SED")+cNaturezaSE5,"ED_CONTA"))

RestArea(aArea)

RETURN (cContaCredito)
