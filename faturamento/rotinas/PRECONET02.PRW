#INCLUDE "PROTHEUS.CH"
#INCLUDE "PRTOPDEF.CH"
#INCLUDE "TOPCONN.CH"

User Function PRECONET02()
	Local aArea      := GetArea()
	local cItem
	local cProduto
	local nQuant
	local cTes
	local cCFOP
	local nPreco
	local cC6num
	local cC6filial
	local cC5num
	local cCliente
	local nC6Clasfis
	local cloja
	local cTipoCli
	local cTipo
	local cQuery := ""



	cQuery 	:= "SELECT dbo.SC5010.C5_FILIAL, dbo.SC5010.C5_NUM, dbo.SC5010.C5_CLIENTE, dbo.SC5010.C5_LOJACLI, dbo.SC5010.C5_TIPO, dbo.SC5010.C5_TIPOCLI, dbo.SC6010.C6_NUM, dbo.SC6010.C6_ITEM, dbo.SC6010.C6_PRODUTO,"
	cQuery 	+= " dbo.SC6010.C6_TES, dbo.SC6010.C6_QTDVEN, dbo.SC6010.C6_PRCVEN, dbo.SC6010.C6_ZPRCNET,dbo.SC6010.C6_ITEM, dbo.SC6010.C6_CLASFIS,dbo.SC6010.C6_CF"
	cQuery 	+= " FROM dbo.SC5010 INNER JOIN"
	cQuery 	+= " dbo.SC6010 ON dbo.SC5010.C5_FILIAL = dbo.SC6010.C6_FILIAL AND dbo.SC5010.C5_NUM = dbo.SC6010.C6_NUM"
	cQuery 	+= " WHERE (C6_DTENTRG >= convert(date, getdate()-15, 112)) AND (dbo.SC5010.D_E_L_E_T_ = '' AND dbo.SC6010.D_E_L_E_T_ = '')"
	cQuery := ChangeQuery( cQuery )
	dbUseArea( .T., "TOPCONN", TcGenQry( , , cQuery ), "QRY", .T., .T. )

	dbSelectArea("QRY")
	ProcRegua(QRY->(LastRec()))
	QRY->(DBGoTop())

	cProduto  := QRY->C6_PRODUTO

	While (!Eof()) .AND. !Empty(cProduto)
		cItem     := QRY->C6_ITEM
		cProduto  := QRY->C6_PRODUTO
		nQuant    := QRY->C6_QTDVEN
		cTes      := QRY->C6_TES
		cCFOP     := QRY->C6_CF
		nPreco    := QRY->C6_PRCVEN
		cC6num    := QRY->C6_NUM
		nC6Clasfis:= QRY->C6_CLASFIS
		cC6filial := "01"
		cC5num    := QRY->C5_NUM
		cCliente  := QRY->C5_CLIENTE
		cloja     := QRY->C5_LOJACLI
		cTipoCli  := QRY->C5_TIPOCLI
		cTipo     := QRY->C5_TIPO
		nPrecoImp := str(round(QRY->C6_PRCVEN,4),14,4)

		If cTipoCli <> 'X'

			MaFisIni(cCliente,; // 1-Codigo Cliente/Fornecedor
			cloja,; // 2-Loja do Cliente/Fornecedor
			"C",; // 3-C:Cliente , F:Fornecedor
			cTipo,; // 4-Tipo da NF
			cTipoCli,; // 5-Tipo do Cliente/Fornecedor
			MaFisRelImp("MTR700",{"SC5","SC6"}),; // 6-Relacao de Impostos que suportados no arquivo
			,; // 7-Tipo de complemento
			,; // 8-Permite Incluir Impostos no Rodape .T./.F.
			"SB1",; // 9-Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
			"MTR700") // 10-Nome da rotina que esta utilizando a funcao
			nItem := 0
			nValIcmSt := 0
			nDesconto := 0
			nNrItem:=0
			nPrecoSemICMS :=0.00
			nPrecoNet := 0.00
			nTotDesc := 0.00
			nICM := 0.00
			nPIS := 0.00
			nCOFINS := 0.00
			nTotDesp := 0.00
			nTotFrete := 0.00
			nTotSeguro := 0.00
			nRedICM := 0.00

			SC6->(!Eof()) .And. xFilial("SC6")==cC6filial .And. cC6num  == cC5num
			nItem ++
			MaFisAdd(cProduto,; // 1-Codigo do Produto ( Obrigatorio )
			cTes,; // 2-Codigo do TES ( Opcional )
			nQuant,; // 3-Quantidade ( Obrigatorio )
			nPreco,; // 4-Preco Unitario ( Obrigatorio )
			nDesconto,; // 5-Valor do Desconto ( Opcional )
			nil,; // 6-Numero da NF Original ( Devolucao/Benef )
			nil,; // 7-Serie da NF Original ( Devolucao/Benef )
			nil,; // 8-RecNo da NF Original no arq SD1/SD2
			0,; // 9-Valor do Frete do Item ( Opcional )
			0,; // 10-Valor da Despesa do item ( Opcional )
			0,; // 11-Valor do Seguro do item ( Opcional )
			0,; // 12-Valor do Frete Autonomo ( Opcional )
			0,; // 13-Valor da Mercadoria ( Obrigatorio )
			0,; // 14-Valor da Embalagem ( Opcional )
			0,; // 15-RecNo do SB1
			0) // 16-RecNo do SF4
			nICM := IF(SUBSTR(cCFOP,1,1)<>'5'.AND.SUBSTR(nC6Clasfis,1,1)$'3,8',4,MaFisRet(nItem,"IT_ALIQICM"))
			nRedICM := MaFisRet(nItem,"IT_ICMS")[16]
			nPIS := IF(SF4->F4_PISCOF =='4',0,MaFisRet(nItem,"IT_ALIQPIS"))
			nCOFINS := IF(SF4->F4_PISCOF =='4',0,MaFisRet(nItem,"IT_ALIQCOF"))
			nTotDesp := MaFisRet(,'NF_DESPESA')
			nTotFrete := MaFisRet(,'NF_FRETE')
			nTotSeguro := MaFisRet(,'NF_SEGURO')
			nTotIcmSol := MaFisRet(nItem,'NF_VALSOL')
			nAliqICM := nICM*(MaFisRet(nItem,"IT_ICMS")[16]/100)
			nPrecoSemICMS := iif(nAliqICM = 0,nPreco-(nPreco*(nICM/100)), nPreco-(nPreco*(nAliqICM/100)))
			nPrecoNet := str(round(nPrecoSemICMS-(nPrecoSemICMS*((nPis+nCOFINS)/100)),8),14,4)

			MaFisRet(nItem,"IT_ALIQCOF")

			//C6_ZPRCNET := nPrecoNet

			Begin Transaction
				cQryUpd := "UPDATE SC6010 SET C6_ZPRCNET = '"+ nPrecoNet +"' FROM SC6010 WHERE C6_FILIAL = '01'AND C6_NUM = '"+cC6num+"' AND C6_ITEM = '"+cItem+"' AND C6_PRODUTO = '"+cProduto+"'"
				//Tenta executar o update
				nErro := TcSqlExec(cQryUpd)
				//Se houve erro, mostra a mensagem e cancela a transação
				If nErro != 0
					MsgStop("Erro na execução: "+TcSqlError(), "Atenção")
					DisarmTransaction()
				EndIf
			End Transaction
			MaFisEnd()//Termino

		Else
			Begin Transaction
				cQryUpd := "UPDATE SC6010 SET C6_ZPRCNET = '"+ nPrecoImp +"' FROM SC6010 WHERE C6_FILIAL = '01'AND C6_NUM = '"+cC6num+"' AND C6_ITEM = '"+cItem+"' AND C6_PRODUTO = '"+cProduto+"'"
				//Tenta executar o update
				nErro := TcSqlExec(cQryUpd)
				//Se houve erro, mostra a mensagem e cancela a transação
				If nErro != 0
					MsgStop("Erro na execução: "+TcSqlError(), "Atenção")
					DisarmTransaction()
				EndIf
			End Transaction
		Endif
		QRY->(dbskip())
	Enddo
	RestArea(aArea)
	MsgInfo("Preço Net Processado Com Sucesso!", "Fim do Processo")
Return
