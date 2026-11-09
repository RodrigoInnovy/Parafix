#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#INCLUDE "apvt100.ch"
#DEFINE cEOL CHR(13) + CHR(10)

/*	
	Programa	:	PRAACD01
	Autor		:	Evandro Simenes
	Data		:	24/10/2017
	Descricao	:	Rotina para leitura de etiquetas / conferencia de lotes do recebimento
*/

User Function PRAACD01()
	Local cAuxEti 	:= Space(60)	&& Etiqueta
	Local aAuxTela	:= {}			&& Array tela
	Local nStart 	:= 0            && Start Substring
	Local nQtdChar 	:= 0            && Qtd Char
	Local cLocaliz  := padr(SuperGetMv("MV_ZZLOCFR",.F.,"FRACIONAMENTO"),15," ") && Parametro Endereco
	Local cLocal    := getLocal(cLocaliz)           && LocalEstoque
	Local cLocaliD  := padr(SuperGetMv("MV_ZZLOCAR",.F.,"AGUARDANDO"),15," ") && Parametro Endereco
	Local cLocD     := getLocal(cLocaliD)           && LocalEstoque
	Local cQry      := ""           && Query
	Local aItens    := {}           && Array Transferencia
	Local oCtrlRec  := ControleDeRecebimento():newControleDeRecebimento()
	Local dDataVal := Date()
	Local cLote		:= ""			&& Lote
	Local nQtde		:= ""			&& Quantidade
	Local cCodPro 	:= ""           && Codigo Produto
	
	&& Salvar tela
	VTSave Screen To aAuxTela

	&& Exibir tela para ler etiqueta
	VtClear()
		@00,00 VtSay "Conferencia Lote"
		@01,00 VtSay "    Etiqueta    "
		@02,00 VtGet cAuxEti Pict "@!"
	VtRead
	
	If 	VtLastkey() == 27
		Return .F.
	Else	
		nStart := At("%001",cAuxEti) + 4
		nQtdChar := At("%010",cAuxEti) - nStart
		cCodPro 	:= padr(SubStr(cAuxEti,nStart,nQtdChar),15," ") //Seta Codigo do Produto
		
		nStart := At("%010",cAuxEti) + 4
		nQtdChar := At("%030",cAuxEti) - nStart
		cLote		:= padl(SubStr(cAuxEti,nStart,nQtdChar),11,"0") //Seta Lote do Produto
		
		nStart := At("%030",cAuxEti) + 4
		nQtdChar := (Len(cAuxEti)+1) - nStart
		nQtde    := Val(AllTrim(SubStr(cAuxEti,nStart,nQtdChar)))//Seta Quantidade do Produto
	EndIf
	
	&& Salvar tela
	VTSave Screen To aAuxTela
	
	cQry :=	" SELECT ZA1_DESCPR, ZA1_UM, ZA1_QTD1UM, ZA1_QTD2UM, ZA1_NF, ZA1_SERIE, ZA1_CODFOR, ZA1_LOJA, R_E_C_N_O_"
	cQry += "   FROM "+RetSqlName("ZA1")
	cQry += "  WHERE D_E_L_E_T_ <> '*'"
	cQry += "    AND ZA1_FILIAL = '"+xFilial("ZA1")+"'"
	cQry += "    AND ZA1_LOTE = '"+cLote+"'"
	cQry += "    AND ZA1_CODPRO = '"+cCodPro+"'"
	cQry += "    AND ZA1_STATUS = '4'"
	cQry += "    AND ZA1_DTFIM = ''"
	
	TcQuery cQry Alias TZA1 New
	
	&& Caso tenha encontrado
	If TZA1->(!EOF())
		&& Caso a quantidade seja igual da ZA1
		If nQtde == TZA1->ZA1_QTD1UM
			cQry := " SELECT BF_QUANT "
			cQry += "   FROM "+RetSqlName("SBF")
			cQry += "  WHERE D_E_L_E_T_ <> '*'"
			cQry += "    AND BF_FILIAL = '"+xFilial("SBF")+"'"
			cQry += "    AND BF_PRODUTO = '"+cCodPro+"'"
			cQry += "    AND BF_LOTECTL = '"+cLote+"'"
			cQry += "    AND BF_LOCAL = '"+cLocal+"'"
			cQry += "    AND BF_LOCALIZ = '"+cLocaliz+"'"
			
			TcQuery cQry Alias TSBF New
			&& Caso tenha saldo
			If TSBF->(!EOF())
				&& Caso tenha saldo suficiente
				If TSBF->BF_QUANT >= nQtde
					&& Efetua a transferencia 
					
					dDataVal := getValid(TZA1->ZA1_NF, TZA1->ZA1_SERIE, TZA1->ZA1_CODFOR, cCodPro)
					
					Aadd(aItens, {cCodPro            ,;              
					              TZA1->ZA1_DESCPR   ,;              
					              TZA1->ZA1_UM       ,;              
					              cLocal             ,;              
					              cLocaliz           ,;              
					              cCodPro            ,;              
					              TZA1->ZA1_DESCPR   ,;              
					              TZA1->ZA1_UM       ,;              
					              cLocD              ,;              
					              cLocaliD           ,;              
					              cLote              ,;              
					              dDataVal           ,;              
					              TZA1->ZA1_QTD1UM   ,;              
					              TZA1->ZA1_QTD2UM   ,;              
					              cLote              ,;              
					              dDataVal           ,;              
					              })                                 
					
					If !oCtrlRec:incTransferencia(aItens)
						VtAlert("Nao foi possivel efetuar a transferencia do lote original para os lotes fracionados.","Aviso",.T.,2000)
					else
						//Adiciona Status para Controle de Recebimento
						DbSelectArea("ZA1")
						ZA1->(DbGoTo(TZA1->R_E_C_N_O_))
						U_AdiCtrlRec("5","Finalizado - Ok p/ Endereçar")
						VtAlert("Transferencia efetuada com sucesso.","Aviso",.T.,2000)
					EndIf
				Else
					VtAlert("Saldo Insuficiente.","Aviso",.T.,2000)
				Endif
			Else
				VtAlert("Lote sem saldo.","Aviso",.T.,2000)
			Endif
			
			TSBF->(DbCloseArea())
		Else
			VtAlert("Qtde nao Bate.","Aviso",.T.,2000)
		EndIf
	Else
		VtAlert("Lote nao encontrado.","Aviso",.T.,2000)
	EndIf
	
	TZA1->(DbCloseArea())

	&& Restaurar tela
	VTRestore Screen From aAuxTela   
	
	&& Chamada recursiva
	U_PRAACD01()
Return


Static function getLocal(cLocaliz)
	Local cLocal := ""
	
	cQry := "SELECT BE_LOCAL "
	cQry += "  FROM "+RetSqlName("SBE")
	cQry += " WHERE D_E_L_E_T_ <> '*'"
	cQry += "   AND BE_FILIAL = '"+xFilial("SBE")+"'"
	cQry += "   AND BE_LOCALIZ = '"+cLocaliz+"'"
	
	TcQuery cQry Alias TSBE New
	
	&& Caso tenha encontrado
	If TSBE->(!EOF())
		cLocal := TSBE->BE_LOCAL
	Else
		VtAlert("Local Inexistente (SBE - MV_ZZLOCFR).","Aviso",.T.,2000)
	Endif
	TSBE->(DbCloseArea())
	
Return cLocal

Static Function getValid(cNF, cSerie, cCodFor, cCodPro)
	Local dDataVal := Date()
	Local dDataEmi := Date()
	Local aArea := GetArea()
	Local cQry := ""
	Local nPrValid
	
	cQry := "SELECT B1_PRVALID "
	cQry += "  FROM "+RetSqlName("SB1")
	cQry += " WHERE D_E_L_E_T_ <> '*'"
	cQry += "   AND B1_FILIAL 	= '"+xFilial("SB1")+"'"
	cQry += "   AND B1_COD = '"+cCodPro+"'"
	
	TcQuery cQry Alias TSB1 New
	
	If TSB1->(!EOF())
		nPrValid := TSB1->B1_PRVALID
	Else
		nPrValid := 0
	Endif
	
	TSB1->(DbCloseArea())
	
	cQry := "SELECT F1_RECBMTO "
	cQry += "  FROM "+RetSqlName("SF1")
	cQry += " WHERE D_E_L_E_T_ <> '*'"
	cQry += "   AND F1_FILIAL 	= '"+xFilial("SF1")+"'"
	cQry += "   AND F1_DOC 		= '"+cNF+"'"
	cQry += "   AND F1_SERIE 	= '"+cSerie+"'"
	cQry += "   AND F1_FORNECE 	= '"+cCodFor+"'"
	
	TcQuery cQry Alias TSF1 New
	
	If TSF1->(!EOF())
		dDataEmi := STOD(TSF1->F1_RECBMTO)
	Else
		VtAlert("Data de Recebimento da NF nao foi encontrada.","Aviso",.T.,2000)
	Endif
	
	TSF1->(DbCloseArea())
	
	dDataVal := dDataEmi + nPrValid
	
	RestArea(aArea)
Return dDataVal
