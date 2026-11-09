#INCLUDE 'Protheus.ch'
#INCLUDE 'TBIConn.ch'
#INCLUDE 'TopConn.ch'
//+-----------+-----------+------+------------+-----+--------------+
//| PROGRAMA  | ETQ_ESTOQ | DATA | 26-08-2021 | POR | George Eivazian   |
//+-----------+-----------+------+------------+-----+--------------+
//| DESCRICAO | Impressao de etiquetas do Estoque                  |
//+-----------+------+------------+-----+--------------------------+
//| ALTERACAO | DATA | 26-08-2021 | POR | George Eivazian               |
//+-----------+------+------------+-----+--------------------------+
//| DESCRICAO | Ajuste para retirar codigos ZPL de configuracao    |
//+-----------+----------------------------------------------------+
User Function ETQ_ESTOQ()

Local aArea		:= GetArea()
Local cModelo	:= 'ZEBRA'
Local cPorta	:= 'LPT1'
Local nX		:= 0

Private MV_PAR01 := {'Selecione um modelo...','ZEBRA','ARGOX','EPSON','ELGIN'}
Private MV_PAR02 := Space(15)
Private MV_PAR03 := Space(15)
Private MV_PAR04 := Space(15)
Private MV_PAR05 := Space(15)
Private MV_PAR06 := 1

If fParambox()

	If Alltrim(MV_PAR01) $ 'ZEBRA/ARGOX'
        
		// AtenÁ„o caso queira acrescentar a serie da NF no WHERE

        cQuery := "SELECT B1_COD,B1_DESC,B1_TIPO,B1_UM,B1_GRUPO,B1_UCOM, B1_IDHIST,D2_LOTECTL,F2_VEND1, A3_NOME, D2_EMISSAO, D2_QUANT "
        cQuery += "FROM " + RetSqlName("SF2") + " SF2 "
        cQuery += "INNER JOIN " + RetSqlName("SD2") + " SD2 ON F2_FILIAL = D2_FILIAL AND F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE AND F2_CLIENTE = D2_CLIENTE AND F2_LOJA = D2_LOJA AND SD2.D_E_L_E_T_ = ' ' "
        cQuery += "INNER JOIN " + RetSqlName("SA3") + " SA3 ON F2_VEND1 = A3_COD AND SA3.D_E_L_E_T_ = ' '"
        //cQuery += "INNER JOIN " + RetSqlName("SB1") + " SB1 ON D2_FILIAL = B1_FILIAL AND D2_COD = B1_COD AND SB1.D_E_L_E_T_ = ' '"
		cQuery += "INNER JOIN " + RetSqlName("SB1") + " SB1 ON D2_COD = B1_COD AND SB1.D_E_L_E_T_ = ' '"
        cQuery += "WHERE F2_DOC BETWEEN '" + MV_PAR02 + "' AND '" + MV_PAR03 + "' "

	Endif
	
	cQuery := ChangeQuery(cQuery)

	If Select('TMP') <> 0
		TMP->(dbCloseArea())
	Endif

	dbUseArea(.T., 'TOPCONN', TcGenQry(,,cQuery), 'TMP', .T., .F.)
	TMP->(dbGoTop())

	If TMP->(!Eof())
		MSCBPRINTER(cModelo, cPorta,,, .F.)
		MSCBCHKSTATUS(.F.)

		While TMP->(!Eof())

			//For nX := 1 To MV_PAR06
				ImpEtq(MV_PAR01)
			//Next

			TMP->(dbSkip())
		End

		MSCBCLOSEPRINTER()
	Else
		MsgAlert('N„o h· dados serem impressos!', 'Etiquetas')
	Endif

Endif

RestArea(aArea)

Return


//+-------------------------+
//| Impressao das Etiquetas |
//+-------------------------+
Static Function ImpEtq(cLayOut)

If cLayOut == 'ZEBRA'	//Versao Zebra

	MSCBBEGIN(1,6)
	MSCBWRITE('^XA')
//	MSCBWRITE('^FT46,005^A0N,23,23^FH\^CI28^FDTipo:^FS^CI27')
//	MSCBWRITE('^FT672,005^A0N,23,23^FH\^CI28^FDUM:^FS^CI27')

//    MSCBWRITE('^FPH,2^FT101,005^A@N,45,45,TT0003M_^FH\^CI28^FD' + TMP->B1_COD + '^FS^CI27')

//	MSCBWRITE('^FT46,333^A0N,23,23^FH\^CI28^FDGrupo:^FS^CI27')
//	MSCBWRITE('^FT46,371^A0N,23,23^FH\^CI28^FDFamilia:^FS^CI27')
//	MSCBWRITE('^FPH,2^FT101,006^A@N,20,20,TT0003M_^FH\^CI28^FD' + TMP->B1_TIPO + '^FS^CI27')
//	MSCBWRITE('^FT720,006^A@N,20,20,TT0003M_^FH\^CI28^FD' + TMP->B1_UM + '^FS^CI27')
//	MSCBWRITE('^BY2,3,142^FT202,181^BCN,,Y,N')
//	MSCBWRITE('^FH\^FD>:' + TMP->B1_COD+LEFT(TMP->D2_LOTECTL,14) + '^FS')

	If Len(Alltrim(TMP->B1_DESC)) <= 44
	    
        // Codigo Produto
        MSCBWRITE('^FT55,400^A@N,95,77,TT0003M_^FB691,1,13,C^FH\^CI28^FD' + Alltrim(TMP->B1_COD) + '^FS^CI27')

        // DESCRI√á√ÉO
		MSCBWRITE('^FT55,460^A@N,40,37,TT0003M_^FB691,1,13,C^FH\^CI28^FD' + Alltrim(TMP->B1_DESC) + '^FS^CI27') 
        
        //SSCC
        MSCBWRITE('^FT46,495^A0N,28,28^FH\^CI28^FDSSCC:^FS^CI27')
        MSCBWRITE('^FT30,510^A@N,40,37,TT0003M_^FB691,1,13,C^FH\^CI28^FD' + Alltrim(TMP->B1_IDHIST) + '^FS^CI27')
        
        //VENDEDOR/NOME
        MSCBWRITE('^FT55,540^A0N,28,28^FH\^CI28^FDVENDOR/NOME:^FS^CI27')
        MSCBWRITE('^FT30,560^A@N,40,37,TT0003M_^FB691,1,13,C^FH\^CI28^FD' + Alltrim(TMP->F2_VEND1)+"/"+Alltrim(TMP->A3_NOME) + '^FS^CI27')

        //BATCH/LOTE
        MSCBWRITE('^FT55,590^A0N,28,28^FH\^CI28^FDBATCH/LOT:^FS^CI27')
        MSCBWRITE('^FT40,610^A@N,40,37,TT0003M_^FB691,1,13,C^FH\^CI28^FD' + Alltrim(TMP->D2_LOTECTL) + '^FS^CI27')

        //PACK DATE
        MSCBWRITE('^FT485,590^A0N,28,28^FH\^CI28^FDPACK DATE:^FS^CI27')
        MSCBWRITE('^FT455,610^A@N,40,37,TT0003M_^FB691,1,13,C^FH\^CI28^FD' + Alltrim(TMP->D2_EMISSAO) + '^FS^CI27')
      
        // PRODUTO + LOTE
	    MSCBWRITE('^BY2,3,142^FT202,800^BCN,,Y,N')
	    MSCBWRITE('^FH\^FD>:' + TMP->B1_COD + LEFT(TMP->D2_LOTECTL,14) + '^FS')

        // DATA+QUANT COD BARRA
        MSCBWRITE('^BY2,3,142^FT202,1000^BCN,,Y,N')
        MSCBWRITE('^FH\^FD>:' + Alltrim(TMP->D2_EMISSAO) + " " + Alltrim(TMP->D2_QUANT) + '^FS')

        // COD BARRA SSCC
        MSCBWRITE('^BY2,3,142^FT202,1200^BCN,,Y,N')
        MSCBWRITE('^FH\^FD>:' + Alltrim(TMP->B1_IDHIST) + '^FS')

	Else
//		MSCBWRITE('^FT55,255^A@N,25,27,TT0003M_^FB691,1,13,C^FH\^CI28^FD' + Substr(TMP->B1_DESC,01,44) + '^FS^CI27')
//		MSCBWRITE('^FT55,293^A@N,25,27,TT0003M_^FB691,1,13,C^FH\^CI28^FD' + Substr(TMP->B1_DESC,45,36) + '^FS^CI27')
	Endif

	MSCBWRITE('^PQ1')
	MSCBWRITE('^XZ')
	MSCBEND()


Endif

Return


//+------------------------+
//| Parametros da Etiqueta |
//+------------------------+
Static Function fParamBox()
Local lRet
Local aRet		:= {}
Local aPergs	:= {}

AADD(aPergs, {2, 'Modelo'   , 1, MV_PAR01, 70, '', .F.})
AADD(aPergs, {1, 'Nota De'     , MV_PAR02,   '@!',  '', 'SF2', '', 70, .F.})
AADD(aPergs, {1, 'Nota AtÈ'    , MV_PAR03,   '@!',  '', 'SF2', '', 70, .F.})
AADD(aPergs, {1, 'Quantidade'  , MV_PAR06,  '999',  '',    '', '', 20, .F.})

//AADD(aPergs, {2, 'Modelo'   , 1, MV_PAR01, 70, '', .F.})
//AADD(aPergs, {1, 'Nota De'  , MV_PAR02,   '@!',  '', 'SF2', '', 70, .F.})
//AADD(aPergs, {1, 'Nota At√©' , MV_PAR03,   '@!',  '', 'SF2', '', 70, .F.})
//AADD(aPergs, {1, 'Endere√ßo De' , MV_PAR04,   '@!',  '', 'SBE', '', 70, .F.})
//AADD(aPergs, {1, 'Endere√ßo At√©', MV_PAR05,   '@!',  '', 'SBE', '', 70, .F.})
//AADD(aPergs, {1, 'Quantidade'  , MV_PAR06,  '999',  '',    '', '', 20, .F.})


lRet := ParamBox(aPergs ,'Impress„o de Etiquetas', @aRet)	

Return(lRet)
