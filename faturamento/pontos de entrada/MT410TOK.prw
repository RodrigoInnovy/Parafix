#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO13    บ Autor ณ AP6 IDE            บ Data ณ  12/12/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Codigo gerado pelo AP6 IDE.                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
#Include "rwmake.ch"
#Include "protheus.ch"
#Include "topconn.ch"
#INCLUDE "TOTVS.ch"
#include "Ap5Mail.ch"

/*-------------------------------------------------------------------------------.\
/|                            TOTVS INTERIOR PAULISTA                            |\
/|-------------------------------------------------------------------------------|\
/| Programa : MT410TOK.PRW               | Autor : FELIPE CAMPOS                 |\
/|-------------------------------------------------------------------------------|\
/| Data     : 13/12/2011                 | Alteracao:                            |\
/|-------------------------------------------------------------------------------|\
/| Descricao: Ponto de Entrada chamado antes da grava็ใo do pedido de venda      |\
/|-------------------------------------------------------------------------------|\
/| Uso especifico - Parafix                                                      |\
/.-------------------------------------------------------------------------------.*/

User Function MT410TOK()

Local lRet := .T.
Local _nOpc := PARAMIXB[1] // 1 - Excluir, 3 - Incluir, 4 - Alterar
Local cQry1 := " "
Local cQry2 := " "
Local nItemNew := 0

//Variavel com a posicao dos campos do aCols
private nPosCod     := Ascan(aHeader,{|x| "C6_PRODUTO" $ x[2]})
private nPosItem    := Ascan(aHeader,{|x| "C6_ITEM"    $ x[2]})
private nPosZZNFFRT := Ascan(aHeader,{|x| "C6_ZZNFFRT" $ x[2]})

//-----------------------------------------------------------------------------------------------//
// Tratamento realizado para informar ao usuario quando o item do pedido esta em Desenvolvimento //
//-----------------------------------------------------------------------------------------------//
/*
*************************************
**** Fernando Pereira - 12/12/18
*************************************
If PARAMIXB[1] == 3 .and. Alltrim(FUNNAME()) <> 'EECAP100'

	for i2:=1 to len(acols)   
	   If !acols[i2,len(aheader)+1]
	   nItemNew += 1         
	    aCols[i2,nPosItem] := StrZero(nItemNew,2)
	    //alert(alltrim(aCols[i2,nPosItem])) 
	   Endif
	Next i2            

Endif
*************************************
*/
for i:=1 to len(acols)
	if !acols[i,len(aheader)+1]
		If PARAMIXB[1] <> 1
			if Posicione("SB1",1,xFilial("SB1")+aCols[i,nPosCod],"B1_ZZSTATU") == "2"
				APMSGALERT("ATENCAO: Item: "+alltrim(aCols[i,nPosItem])+" - Produto : "+alltrim(aCols[i,nPosCod])+" em Desenvolvimento, favor consultar com o departamento responsavel")
			endif

		elseif PARAMIXB[1] == 1 .and. M->C5_ZZTRANS == "1"
		    If !Empty(aCols[i,nPosZZNFFRT])
				SD1->(dbSetOrder(1))
				If SD1->(dbSeek(xFilial("SD1")+aCols[i,nPosZZNFFRT]))
					RecLock("SD1",.f.)
					SD1->D1_ZZTRF := " "
					MsUnlock()
				EndIf
			EndIf
			
			cQry1 := "UPDATE " + RetSqlName("SD3") + " SET D3_ZZTRF = ' ' "
			cQry1 += "FROM " + RetSqlName("SD3") + " "
			cQry1 += "WHERE D_E_L_E_T_ = ' ' and "
			cQry1 += "D3_FILIAL = '"+xFilial("SD3")+"' and "
			cQry1 += "D3_ZZTRF = '"+M->C5_NUM+"' and "
			cQry1 += "D3_COD = '"+aCols[i,nPosCod]+"' "
			TCSqlExec( cQry1 )
			
			cQry2 := "UPDATE " + RetSqlName("SD7") + " SET D7_ZZTRF = ' ' "
			cQry2 += "FROM " + RetSqlName("SD7") + " "
			cQry2 += "WHERE D_E_L_E_T_ = ' ' and "
			cQry2 += "D7_FILIAL = '"+xFilial("SD7")+"' and "
			cQry2 += "D7_ZZTRF = '"+M->C5_NUM+"' and "
			cQry2 += "D7_COD = '"+aCols[i,nPosCod]+"' "
			TCSqlExec( cQry2 )
			
		endif
	endif
Next

Return lRet
