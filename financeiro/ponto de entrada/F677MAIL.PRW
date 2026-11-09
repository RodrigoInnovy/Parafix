// Ponto entrada Envio Email Prestação de Contas
#Include 'Protheus.ch'
#INCLUDE "TOPCONN.CH"

User Function F677MAIL()
Local nOpcao      := PARAMIXB[1]
Local cAssunto    := PARAMIXB[2]
Local cMensagem   := PARAMIXB[3]
Local aRet        := {'',''}
Local cquery      := ""
Local cValor      := ""

//OpÃ§Ãµes de envio (nOpcao)
// 1 - Aviso ao Gestor sobre prestaÃ§Ã£o pendente de aprovaÃ§Ã£o
// 2 - Aviso ao participante sobre prestaÃ§Ã£o reprovada pelo gestor
// 3 - Aviso ao participante sobre prestaÃ§Ã£o reprovada pelo Depto Viagens
// 4 - Aviso ao participante sobre pagamento liberado
// 5 - Aviso ao participante sobre prestaÃ§Ã£o finalizada pelo Depto Viagens

If nOpcao == 1

cquery := "select FLE_PRESTA, FLE_PARTIC,FLE_ITEM, FLE_DESPES, FLE_TOTAL from FLE010 where FLE_PRESTA='"+FLE->FLE_PRESTA+"' and (FLE_DESPES ='000001' or FLE_DESPES='000002') and FLE_TOTAL>'150'"
TcQuery cQuery New Alias "QRY_AUX"
dbSelectArea("QRY_AUX")
cValor := QRY_AUX->FLE_TOTAL
QRY_AUX->(dbCloseArea())

    If cValor > 1   
     aRet[2] := "ATENÇÃO: O VALOR DA DESPESA ULTRAPASSA A POLÍTICA DE DESPESAS DA PARAFIX. Prestação pendente de sua aprovação."
    Endif
Else
    aRet[2] := ""
EndIf

Return aRet
