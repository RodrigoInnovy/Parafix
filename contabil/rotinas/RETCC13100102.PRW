#Include "Protheus.ch"
//retorna o centro de custo 13100102 quando a conta contabil de debito for = 33011801

User Function RETCC13100102()

Local cRet := ""

cRet := IF(IIF(SUBSTR(SD2->D2_CF,2,3)$"911,910,949","33011801",IIF(SUBSTR(SD2->D2_CF,2,3)=="910","33011801",IIF(SUBSTR(SD2->D2_CF,2,3)$"101/122/124/105/118","3101020106","3101010106")))=="33011801","13100102","")

Return(cRet)
