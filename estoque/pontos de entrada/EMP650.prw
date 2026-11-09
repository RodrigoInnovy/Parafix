#Include "Protheus.ch"
#Include "Protheus.ch"

/*/                         
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍËÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ºEMP650    º Autor º Felipe Campos      º Data º  21/11/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÎÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ºPonto de Entrada na tela de empenhos para alterar o local   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÎÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       º Parafix                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function EMP650()

Local cTipo  := ""
Local cLocde := GetMV("MV_ZZLOCDE")
Local cLOCPR := GetMV("MV_ZZLOCPR")	
	For i := 1 To Len(aCols)
		cTipo  :=Posicione("SB1",1,xFilial("SB1")+Acols[i,1],"B1_TIPO")
		if SC2->C2_LOCAL <> alltrim(cLocde)                                                    
			if cTipo <> "MO"
				aCols[i,3] := alltrim(cLOCPR)    
			endif
		elseIF SC2->C2_LOCAL == alltrim(cLocde) .AND.  cTipo <> "MO"
				aCols[i,3] := alltrim(cLocde)                   
		endif	
	Next

Return
                                                                                        