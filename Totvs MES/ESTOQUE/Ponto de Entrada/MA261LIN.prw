#INCLUDE "RWMAKE.CH"
#include "PROTHEUS.CH"

//Ponto de Entrada para bloquear Transferências manuais do Armazem 11
//O Ponto de Entrada não deve ser compilado no WebService na Integração com o PCFactory

User Function MA261LIN( )

	Local lRet := .T.
	Local nPoslocal := Ascan(Aheader,{|x| AllTrim(x[2]) == "D3_LOCAL" })
	Local nlocal    := acols[n][nPoslocal]
	local cTipo     := posicione("SB1",1,xFilial("SB1")+SB2->B2_COD,"B1_TIPO")


	IF !IsInCallStack("WSPCPRUN")
		If nLocal = "11" .AND. !cTipo $ "PA,PI"
			MsgAlert('Movimentações de transferência de Matéria Prima do Armazen 11 deve ser realizada pelo PCFactory', 'Atenção')
			lRet := .f.
        endif
    Endif

Return lRet


