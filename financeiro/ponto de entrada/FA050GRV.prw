#INCLUDE "PROTHEUS.CH"
#Include "Rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA050GRV  ºAutor  ³Fernando Pereira   º Data ³  06/06/19    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Corrige datas de emissao para contabilização das invoices   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Parafix                                                    º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
***************************
User Function FA050GRV()
***************************
local aArea        := GetArea()
Local _aInvoice    := ""

IF SE2->E2_PREFIXO =='EIC' .AND. (SE2->E2_TIPO = 'INV' .OR. SE2->E2_TIPO = 'PA ') 
	
	//_aInvoice:=INVOICE(SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_FORNECE,SE2->E2_LOJA)
	_aInvoice:=(SE2->E2_NUM,SE2->E2_TIPO,SE2->E2_PARCELA,SE2->E2_FORNECE,SE2->E2_LOJA)

	//If _aInvoice[1] == 0
		//MsgStop("Nao existe Taxa Financeia Para Data: "+DtoC(SE2->E2_EMISSAO)+" ! "+chr(13)+chr(10)+"As Invoices serão Gravadas Incorretamente"+" ! "+chr(13)+chr(10)+"Corrigir taxas e Refazer a Invoice no EIC !","Aviso !")
	//Endif
	//SE2->(Reclock("SE2",.F.)) // VINICIUS 06/11/2023
	//SE2->E2_EMIS1  := SE2->E2_EMISSAO // VINICIUS 06/11/2023
	//SE2->E2_ORIGEM := "FINA050"
	/*
	If _aInvoice[1] > 0
		SE2->E2_TXMOEDA := _aInvoice[1]
		SE2->E2_VLCRUZ  := SE2->E2_VALOR * _aInvoice[1]
	Endif
	*/
	SE2->(MsUnlock("SE2"))
	
Endif


RestArea(aArea)

return()

**************************************************************
Static Function Invoice(_cNum,_cParcela,_cFornece,_cLoja)
**************************************************************
Local _aDados:={}
Local _aArea:=GetArea()

Aadd(_aDados,0  )
Aadd(_aDados,' ')
Aadd(_aDados,' ')

cSql003:= " SELECT  WB_HAWB HAWB , W9_TX_FOB TAXA , W9_INVOICE INVOICE "
cSql003+= " FROM "+ RetSqlName("SWB") + " SWB  ,"+ RetSqlName("SW9") + " SW9  "
cSql003+= " WHERE SWB.D_E_L_E_T_   = ' '  "
cSql003+= "	  AND SW9.D_E_L_E_T_   = ' '  "
cSql003+= "   AND SWB.WB_FILIAL    = '"+XFILIAL('SWB')+"' "
cSql003+= "   AND SWB.WB_FORN      = '"+_cFornece+"' "
cSql003+= "   AND SWB.WB_LOJA      = '"+_cLoja+"' "
cSql003+= "   AND SWB.WB_NUMDUP    = '"+_cNum+"' "
cSql003+= "   AND SWB.WB_PARCELA   = '"+_cParcela+"' "
cSql003+= "   AND SW9.W9_FILIAL    = SWB.WB_FILIAL "
cSql003+= "   AND SW9.W9_HAWB      = SWB.WB_HAWB "
cSql003+= "   AND SW9.W9_INVOICE   = SWB.WB_INVOICE "

cAliasCor := GetNextAlias()
dbUseArea( .T., "TOPCONN", TcGenQry( ,, cSql003 ), cAliasCor,.T.,.T.)
(cAliasCor)->(dBGotop())
IF ! EOF()
	//_aDados[1]:= RecMoeda(SE2->E2_EMISSAO,SE2->E2_MOEDA) //(cAliasCor)->TAXA
	_aDados[2]:=(cAliasCor)->HAWB
	_aDados[3]:=(cAliasCor)->INVOICE
ENDIF
DbSelectArea(cAliasCor)        // Se estiver, devera ser fechado.
DbCloseArea()
RestArea(_aArea)

Return(_aDados)
