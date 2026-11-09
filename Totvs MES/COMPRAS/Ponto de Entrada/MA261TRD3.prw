#Include 'Protheus.ch'

/*/{Protheus.doc} MI261TRD3
o ponto de entrada MA261TRD3 realiza atualizações adicionais nas tabelas envolvidas 
na movimentação interna de transferência modelo II - MATA261.

@type	User Function
@author 	João Gustavo Orsi
@since 	30/10/2017
@version P12
/*/

user function MA261TRD3()
 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recebe os identificadores Recno() gerados na tabela SD3      ³
//³ para que seja feito o posicionamento                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 
	local aRecSD3 := PARAMIXB[1]
	local nX := 1
	Private nStart

	if IsInCallStack("WSPCPRUN") 
 		for nX := 1 To len(aRecSD3)
    		if __cOpTMPPI == '005'		//Entrada para OP
	    		gravaSD3(aRecSD3[nX][2])// Devolucao DE4
    		elseif __cOpTMPPI == '008'	//Requisição para OP
	    		gravaSD3(aRecSD3[nX][1])// Requisicao RE4
    		endif
		next nX
	endif
return Nil

static function gravaSD3(nRecno)
	Private nStart
	SD3->(dbGoto(nRecno))
	SD3->D3_ZZOP := __cOpTrans
	SD3->D3_ZZTMPPI := __cOpTMPPI
	
    FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG MA261TRD3 OP: "+__cOpTrans, 0, (nStart - Seconds()), {})   
    FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG MA261TRD3 TMPPI: "+__cOpTMPPI, 0, (nStart - Seconds()), {})
	
	__cOpTrans := ""
	__cOpTMPPI := ""
	
	FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","DEBUG MA261TRD3 - Final - TMPPI: "+__cOpTMPPI, 0, (nStart - Seconds()), {})
return
