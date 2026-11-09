User Function TSCalcTempo(dDataIni, dDataFim, cHoraIni, cHoraFim)

Local cTempo := ""
Local nTempo := 0
Local nHoraIni := Val(Alltrim(substr(cHoraIni,1,2))) + Val(Alltrim(substr(cHoraIni,4,2)))/60
Local nHoraFim := Val(Alltrim(substr(cHoraFim,1,2))) + Val(Alltrim(substr(cHoraFim,4,2)))/60
Local nDias	 := 0

If !Empty(dDataFim) .and. !Empty(nHoraFim)
	If dDataFim >= dDataIni
		nDias := dDataFim - dDataIni
		If nDias > 0
			nTempo := ((nDias * 24)-nHoraIni) + nHoraIni + nHoraFim
		Else
		    nTempo := nHoraFim - nHoraIni 
		EndIf
		cTempo := Alltrim(Strzero(INT(nTempo),3)) + ":" + Alltrim(Strzero(((nTempo - INT(nTempo)))*60,2))
	Else 
	     Alert("A data Final não pode ser menor que a data Inicial!")
	EndIf
EndIf

Return(cTempo)