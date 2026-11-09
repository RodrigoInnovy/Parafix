#include 'protheus.ch'
#include 'parmtype.ch'
#include 'topconn.ch'

/*/{Protheus.doc} AtuCB6

Atualiza dados da tabela CB6 para faturamento fora do coletor

@author Cassiano
@since 23/11/2017
@version 1.0
/*/
user function AtuCB6()
	
	local aAreaCB6		:= CB6->(GetArea())
	local cAlias		:= GetNextAlias()
	
	local cQuery		:= ""
	local cPedido		:= ""
	local cOrdSep		:= ""
	local cNota			:= ""
	local cSerie		:= ""
	
	pegaDados(@cPedido, @cOrdSep, @cNota, @cSerie)
	
	cQuery := "SELECT CB9.CB9_ORDSEP, CB9.CB9_VOLUME, CB9.CB9_PEDIDO,"			+ CRLF
	cQuery += "       CB6.CB6_NOTA, CB6.R_E_C_N_O_ AS REGCB6 "					+ CRLF
	cQuery += "FROM " + RetSQLName("CB9")+ " CB9 "								+ CRLF
	cQuery += "INNER JOIN "+RetSqlName('CB6')+" CB6 "							+ CRLF
	cQuery += "	      ON CB6.CB6_FILIAL	= '"+xFilial('CB6')+"'	AND "			+ CRLF
	cQuery += "	         CB6.CB6_VOLUME = CB9.CB9_VOLUME		AND "			+ CRLF
	cQuery += "	      CB6.D_E_L_E_T_	= ' ' "									+ CRLF
	cQuery += "WHERE "															+ CRLF
	cQuery += "    CB9.CB9_FILIAL 	= '" + xFilial("CB9") + "'	AND "			+ CRLF
	cQuery += "    CB9.CB9_PEDIDO	= '" + cPedido + "'			AND "			+ CRLF
	cQuery += "    CB9.CB9_ORDSEP	= '" + cOrdSep + "'			AND "			+ CRLF
	cQuery += "CB9.D_E_L_E_T_ = ' ' "											+ CRLF
	
	TcQuery cQuery New Alias &cAlias
	
	(cAlias)->(dbGotop())
	
	do While !(cAlias)->(Eof())
			
			dbSelectArea("CB6")
			CB6->(dbGoTo( (cAlias)->REGCB6 ))
			RecLock("CB6",.F.)
				CB6->CB6_NOTA 	:= cNota
				CB6->CB6_SERIE 	:= cSerie
				CB6->CB6_PEDIDO := cPedido
			CB6->(MsUnLock())
			
		(cAlias)->(dbSkip())
	endDo
	
	(cAlias)->(dbCloseArea())
	
return

static function pegaDados(cPedido, cOrdSep, cNota, cSerie)
	
	local cQuery := ""
	local cAlias := GetNextAlias()
	
	cQuery := "SELECT C9_ORDSEP, D2_PEDIDO, D2_DOC, D2_SERIE "					+ CRLF
	cQuery += "FROM " + RetSQLName("SD2")+ " D2 "								+ CRLF
	cQuery += "INNER JOIN "+RetSqlName('SC9')+" C9 "							+ CRLF
	cQuery += "	      ON C9.C9_FILIAL	= '"+xFilial('SC9')+"'	AND "			+ CRLF
	cQuery += "	         C9.C9_PEDIDO = D2_PEDIDO				AND "			+ CRLF
	cQuery += "	         C9.C9_ITEM = D2_ITEMPV					AND "			+ CRLF
	cQuery += "	         C9.C9_NFISCAL = D2_DOC					AND "			+ CRLF
	cQuery += "	      C9.D_E_L_E_T_	= ' ' "										+ CRLF
	cQuery += "WHERE "															+ CRLF
	cQuery += "    D2_FILIAL 	= '" + xFilial("SD2") 	+ "'		AND "		+ CRLF
	cQuery += "    D2_DOC		= '" + SF2->F2_DOC 		+ "'		AND "		+ CRLF
	cQuery += "    D2_SERIE		= '" + SF2->F2_SERIE 	+ "'		AND "		+ CRLF
	cQuery += "    D2_CLIENTE	= '" + SF2->F2_CLIENTE 	+ "'		AND "		+ CRLF
	cQuery += "    D2_LOJA		= '" + SF2->F2_LOJA 	+ "'		AND "		+ CRLF
	cQuery += "D2.D_E_L_E_T_ = ' ' "											+ CRLF
	
	TcQuery cQuery New Alias &cAlias
	
	(cAlias)->(dbGotop())
	
	if !(cAlias)->(Eof())
		
		cPedido := (cAlias)->D2_PEDIDO
		cOrdSep := (cAlias)->C9_ORDSEP
		cNota   := (cAlias)->D2_DOC
		cSerie  := (cAlias)->D2_SERIE
		
	endIf
	
	(cAlias)->(dbCloseArea())
	
return