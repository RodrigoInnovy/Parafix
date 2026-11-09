#INCLUDE "RWMAKE.CH"

/*
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada para validar se o centro de custo pode fi-º±±
±±º          ³car em branco, somente se o campo da OP estiver em branco.  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAEST - MATA241 (Internos Mod. II)                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER FUNCTION MT241TOK()
  Local aArea    := GetArea()  
  Local aAreaSD3 := SD3->(GetArea())
  Local lRet     := .T.
  Local nI		   := 0	
  
  
  for nI:= 1 to len(aCols)
  If !(CTM $ "487,987")

	  If Empty(aCols[nI,gdFieldPos("D3_OP")]) .AND. EMPTY(CCC) .and. aCols[nI,len(aHeader)+1] == .f.
	    Alert("Atenção!!! Preenchimento do Centro de Custo/Ordem de produção é obrigatório.")

	    lRet := .F.  

	  Endif

  ENDIF
  
  next nI

  RestArea(aAreaSD3)
  RestArea(aArea)
RETURN lRet

