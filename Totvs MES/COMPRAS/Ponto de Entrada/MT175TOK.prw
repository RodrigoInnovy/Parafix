#Include "Protheus.ch"

/*/{Protheus.doc} MT175OK

@author Augusto Krejci Bem-Haja
@since 17/10/2017 
@version 1.0
/*/
user function MT175TOK()
	local lRet 		:= .T.
	local nUltLin  	:= len(aCols)
	local nSaldo 	:= aCols[nUltLin,gdFieldPos("D7_SALDO")]
	
	if nSaldo != 0
		MsgAlert ("Atenção! A liberação deve ser do valor total do item. Corrija o valor e tente novamente.")
		lRet := .F.
	endif
return (lRet) 