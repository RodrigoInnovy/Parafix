#Include 'Totvs.ch'
#Include 'TopConn.ch'
#Include "prtopdef.ch"

/*/{Protheus.doc} TelaEtiq
		 Tela para a Impressão da Etiqueta PA (Separação / Desmembramento) 
		 @type  	Function
		 @author  	Augusto Krejci Bem-Haja / Cassandra J. Silva
		 @since   	20/12/2017
/*/
****************************************************************************************************************************************************
User Function TelaEtiq()
****************************************************************************************************************************************************
	Local aPergs 		:= {}
	Local nDiferenca	:= 0
	Local cPesoLiq		:= ""
	Local cPesoBru		:= ""
	Local cCodBar		:= ""
	Local cCodQR		:= ""
	Local cPrefixo1 	:= "%001" // Pré-requisito PC-Factory
	Local cPrefixo2 	:= "%010" // Pré-requisito PC-Factory
	Local cPrefixo3 	:= "%030" // Pré-requisito PC-Factory
	Private aRet 		:= {}
	Private cProdOrig	:= ""
	Private cLoteOrig	:= ""
	Private cEndOrig	:= ""
	Private nQtdeOrig	:= 0
	Private bValidaOS	:= { || fValidaOS(MV_PAR01) }
	Private bValidaEtiq	:= { || fValidaEtiq(MV_PAR02) }
	Private bValidaLoca	:= { || fValidaLoca(MV_PAR09) }
	Private bCalc2A := { || calc2Qtd(MV_PAR01,MV_PAR02,MV_PAR05,2) }
	Private bCalc2B := { || calc2Qtd(MV_PAR01,MV_PAR02,MV_PAR07,1) }
	
	
	
	
	aAdd( aPergs ,{1,"Ordem de Separação:"	, Space(06), "", "Eval(bValidaOS)"		,"CB7"	,"",70,.T.})
	aAdd( aPergs ,{1,"Etiqueta:"			, Space(80), "", "Eval(bValidaEtiq)"	,""		,"",70,.T.})
	aAdd( aPergs ,{1,"Produto:"				, Space(70), "", ""						,""		,".F.",70,.F.})
	aAdd( aPergs ,{1,"Lote:"				, Space(11), "", ""						,""		,".F.",70,.F.})
	aAdd( aPergs ,{1,"Qtd 1a UM:"			, 0, PesqPict('SB2','B2_QATU'),"Eval(bCalc2A)","","",70,.T.})
	//aAdd( aPergs ,{1,"Qtd 1a UM:"			, 0, PesqPict('SB2','B2_QATU'),"u_calc2Qtd(MV_PAR01,MV_PAR02,MV_PAR05,2)","","",70,.T.})
	aAdd( aPergs ,{1,"1a UM:"				, Space(TamSX3("B1_UM")[1]),"","","",".F.",70,.F.})
	aAdd( aPergs ,{1,"Qtd 2 UM:"			, 0,PesqPict('SB2','B2_QATU'),"Eval(bCalc2B)","","",70,.T.})
	//aAdd( aPergs ,{1,"Qtd 2 UM:"			, 0,PesqPict('SB2','B2_QATU'),"u_calc2Qtd(MV_PAR01,MV_PAR02,MV_PAR07,1)","","",70,.T.})
	aAdd( aPergs ,{1,"2a UM:"				, Space(TamSX3("B1_SEGUM")[1]),"","","",".F.",70,.F.})
	aAdd( aPergs ,{1,"Endereço Separação:"	, Space(15), "", "Eval(bValidaLoca)","SBE","",70,.T.})
	
	If ParamBox(aPergs ,"Desmembramento", @aRet,,,.T.,,,,,.F.,.F.)
	
		SB1->(dbSetOrder(1))
		SB1->(dbSeek( xFilial("SB1") + cProdOrig ))

		cValor 		:= Alltrim(Transform(aRet[5],"@E 9,999,999.99"))
		cValor		:= StrTran(cValor,".","")
		cValor		:= StrTran(cValor,",",".")

		nDiferenca  := nQtdeOrig - aRet[5]
		cPesoLiq	:= AllTrim(Transform(Posicione('SB1',1,xFilial('SB1')+SB1->B1_COD,"B1_PESO") 	* aRet[5], "@E 999,999.99"))
		cPesoBru	:= AllTrim(Transform(Posicione('SB1',1,xFilial('SB1')+SB1->B1_COD,"B1_PESBRU") 	* aRet[5], "@E 999,999.99"))
		cCodBar		:= cPrefixo1 + Alltrim(SB1->B1_COD) + cPrefixo2 + Alltrim(cLoteOrig) + cPrefixo3 + cValor
		
		If Substr(SB1->B1_COD,1,1) <> "3"
		
			U_etqPAdesmb(	1,;
						"PA - Produto Acabado",;
						SB1->B1_COD,;
						SB1->B1_DESC,;
						upper(cLoteOrig),;
						DTOC(dDataBase)+" - "+ Time(),;
						DTOC(dDataBase),;
						Alltrim(Transform(aRet[5],"@E 9,999,999.99")),;
						aRet[6],;
						Alltrim(Transform(aRet[7],"@E 9,999,999.99")),;
						aRet[8],;
						upper(cCodBar),;
						SB1->B1_ZZCLI,;
						SB1->B1_ZZDIM,;
						SB1->B1_ZZSTA,;
						SB1->B1_ZZECN,;
						cPesoLiq,;
						cPesoBru,;
						1,;
						aRet)
						
			If nDiferenca > 0

				cValor 		:= Alltrim(Transform(nDiferenca,"@E 9,999,999.99"))
				cValor		:= StrTran(cValor,".","")
				cValor		:= StrTran(cValor,",",".")

				cPesoLiq	:= AllTrim(Transform(Posicione('SB1',1,xFilial('SB1')+SB1->B1_COD,"B1_PESO") 	* nDiferenca, "@E 999,999.99"))
				cPesoBru	:= AllTrim(Transform(Posicione('SB1',1,xFilial('SB1')+SB1->B1_COD,"B1_PESBRU") 	* nDiferenca, "@E 999,999.99"))
				cCodBar		:= cPrefixo1 + Alltrim(SB1->B1_COD) + cPrefixo2 + Alltrim(cLoteOrig) + cPrefixo3 + cValor
			
				U_etqPAdesmb(	2,;
							"PA - Produto Acabado",;
							SB1->B1_COD,;
							SB1->B1_DESC,;
							upper(cLoteOrig),;
							DTOC(dDataBase)+" - "+ Time(),;
							DTOC(dDataBase),;
							Alltrim(Transform(nDiferenca,"@E 9,999,999.99")),;
							aRet[6],;
							Alltrim(Transform(ConvUm(SB1->B1_COD, nDiferenca, 0, 2),"@E 9,999,999.99")),;
							aRet[8],;
							upper(cCodBar),;
							SB1->B1_ZZCLI,;
							SB1->B1_ZZDIM,;
							SB1->B1_ZZSTA,;
							SB1->B1_ZZECN,;
							cPesoLiq,;
							cPesoBru,;
							1,;
							aRet)
			Endif
		Else
			cCodQR		:= SB1->B1_COD+Alltrim(Transform(aRet[5],"@E 9,999,999.99"))+cLoteOrig+DTOC(dDataBase)
			
			U_etqPAAU(	"PA - Automotivo",;
				SB1->B1_COD,;
				SB1->B1_DESC,;
				upper(cLoteOrig),;
				DTOC(dDataBase)+" - "+ Time(),;
				DTOC(dDataBase),;
				Alltrim(Transform(aRet[5],"@E 9,999,999.99")),;
				aRet[6],;
				Alltrim(Transform(aRet[7],"@E 9,999,999.99")),;
				aRet[8],;
				upper(cCodBar),;
				SB1->B1_ZZCLI,;
				SB1->B1_ZZDIM,;
				SB1->B1_ZZSTA,;
				SB1->B1_ZZECN,;
				cPesoLiq,;
				cPesoBru,;
				1,;
				upper(cCodQR),;
				aRet)
						
			If nDiferenca > 0
				cValor 		:= Alltrim(Transform(nDiferenca,"@E 9,999,999.99"))
				cValor		:= StrTran(cValor,".","")
				cValor		:= StrTran(cValor,",",".")

				cPesoLiq	:= AllTrim(Transform(Posicione('SB1',1,xFilial('SB1')+SB1->B1_COD,"B1_PESO") 	* nDiferenca, "@E 999,999.99"))
				cPesoBru	:= AllTrim(Transform(Posicione('SB1',1,xFilial('SB1')+SB1->B1_COD,"B1_PESBRU") 	* nDiferenca, "@E 999,999.99"))
				cCodBar		:= cPrefixo1 + Alltrim(SB1->B1_COD) + cPrefixo2 + Alltrim(cLoteOrig) + cPrefixo3 + cValor
			
				U_etqPAAU(	"PA - Produto Acabado",;
					SB1->B1_COD,;
					SB1->B1_DESC,;
					upper(cLoteOrig),;
					DTOC(dDataBase)+" - "+ Time(),;
					DTOC(dDataBase),;
					Alltrim(Transform(nDiferenca,"@E 9,999,999.99")),;
					aRet[6],;
					Alltrim(Transform(ConvUm(SB1->B1_COD, nDiferenca, 0, 2),"@E 9,999,999.99")),;
					aRet[8],;
					upper(cCodBar),;
					SB1->B1_ZZCLI,;
					SB1->B1_ZZDIM,;
					SB1->B1_ZZSTA,;
					SB1->B1_ZZECN,;
					cPesoLiq,;
					cPesoBru,;
					1,;
					upper(cCodQR))
			Endif
		Endif
	
		If MV_PAR09 <> cEndOrig .and. nDiferenca > 0
			fTransfere(nDiferenca, MV_PAR09)
		Endif
	Endif
	
Return Nil


****************************************************************************************************************************************************
Static function fValidaOS(cCodOS)
****************************************************************************************************************************************************	
	Local lRetorno := .T.
	
	CB7->(dbSetOrder(1))
	If !CB7->(dbSeek( xFilial("CB7") + cCodOS ))
		Alert("Número OS '"+ Alltrim(cCodOS) +"' não encontrada. Verifique!")
		lRetorno := .F.
	Endif

Return lRetorno


****************************************************************************************************************************************************
Static function fValidaEtiq(cCodEtiq)
****************************************************************************************************************************************************	
	Local lRetorno 	:= .T.
	Local cProduto	:= ""
	Local cLote     := ""
	Local cQuant	:= ""
	Local cQuery 	:= ""
	
	MV_PAR02 := Alltrim(MV_PAR02)
	cCodEtiq := Alltrim(cCodEtiq)
	
	If !("%001" $ cCodEtiq)
		Alert("Código inválido. Não está no conceito PC-Factory (TOTVS MES - %001). Verifique!")
		MV_PAR02 := Space(80)
		Return .F.
	Endif

	If !("%010" $ cCodEtiq)
		Alert("Código inválido. Não está no conceito PC-Factory (TOTVS MES - %010). Verifique!")
		MV_PAR02 := Space(80)
		Return .F.
	Endif
	
	If !("%030" $ cCodEtiq)
		Alert("Código inválido. Não está no conceito PC-Factory (TOTVS MES - %030). Verifique!")
		MV_PAR02 := Space(80)
		Return .F.
	Endif

	cProduto := Substr(cCodEtiq,1,At("%010",cCodEtiq))
	cProduto := StrTran(cProduto,"%001","")
	cProduto := StrTran(cProduto,"%010","")
	cProduto := StrTran(cProduto,"%","")
	cProduto := PADR(cProduto,Len(SB1->B1_COD))
	cProdOrig := cProduto

	SB1->(dbSetOrder(1))
	If !SB1->(dbSeek( xFilial("SB1") + cProduto ))
		Alert("Código do produto '"+ Alltrim(cProduto) +"' na etiqueta é inválido. Verifique!")
		MV_PAR02 := Space(80)
		Return .F.
	Endif

	cLote 	:= Substr(cCodEtiq,At("%010",cCodEtiq),At("%030",cCodEtiq))
	cLote 	:= Substr(cLote,1,At("%030",cLote))
	cLote 	:= StrTran(cLote,"%010","")
	cLote 	:= StrTran(cLote,"%030","")
	cLote 	:= StrTran(cLote,"%","")
	cLote 	:= PADR(cLote,Len(SBF->BF_LOCALIZ))
	cLoteOrig := cLote
	
	SB8->(dbSetOrder(5))
	If !SB8->(dbSeek( xFilial("SB8") + cProduto + cLote ))
		Alert("Código do produto '"+ Alltrim(cProduto) +"' com o lote '"+ Alltrim(cLote) +"' na etiqueta é inválido. Verifique!")
		MV_PAR02 := Space(80)
		Return .F.
	Endif

	cQuant 	:= Substr(cCodEtiq,At("%030",cCodEtiq),Len(cCodEtiq))
	cQuant 	:= StrTran(cQuant,"%030","")
	cQuant 	:= StrTran(cQuant,"%","")
	nQtdeOrig := Val(cQuant)
	
	cQuery := " SELECT CB8_LCALIZ"
	cQuery += " FROM "+RetSqlName("CB8")
	cQuery += " WHERE"
	cQuery +=		" CB8_FILIAL = '"+ xFilial("CB8") +"' AND"
	cQuery +=		" CB8_ORDSEP = '"+ MV_PAR01 +"' AND"
	cQuery +=		" CB8_PROD = '"+ SB1->B1_COD +"' AND"
	cQuery +=		" CB8_LOTECT = '"+ SB8->B8_LOTECTL +"' AND"
	cQuery +=		" D_E_L_E_T_ = ' '"
	
	If Select("QRY") <> 0
		QRY->(dbCloseArea())
	Endif
	
	TcQuery cQuery Alias "QRY" New
	
	QRY->(dbGoTop())
	If QRY->(!Eof())
		MV_PAR03 := SB1->B1_COD +" - "+ SB1->B1_DESC
		MV_PAR04 := SB8->B8_LOTECTL
		MV_PAR05 := Val(cQuant)
		MV_PAR06 := SB1->B1_UM
		MV_PAR07 := ConvUm(SB1->B1_COD, Val(cQuant), 0, 2)
		MV_PAR08 := SB1->B1_SEGUM
		MV_PAR09 := QRY->CB8_LCALIZ
		cEndOrig := QRY->CB8_LCALIZ
	Else
		Alert("Produto e Lote não encontrados na ordem de separação no. "+ Alltrim(MV_PAR01) +". Verifique!")
		MV_PAR02 := Space(80)
		Return .F.
	Endif
	QRY->(dbCloseArea())

Return lRetorno


****************************************************************************************************************************************************
Static Function fValidaLoca(cEndereco)
****************************************************************************************************************************************************
	Local lRetorno 	:= .T.
	
	SBE->(dbsetOrder(1))	//--- BE_FILIAL+BE_LOCAL+BE_LOCALIZ+BE_ESTFIS
	If !SBE->(dbSeek( xFilial("SBE") + PADR("21",Len(SBE->BE_LOCAL)) + PADR(cEndereco,Len(BE_LOCALIZ)) ))
		Alert("Não existe endereço '"+ Alltrim(cEndereco) +"' no almoxarifado 21. Verifique!")
		MV_PAR09 := Space(15)
		Return .F.
	Endif
	
Return lRetorno


****************************************************************************************************************************************************
//User Function calc2Qtd(cCodOS, cCodEtiq, nQuant, nOpc)
Static Function calc2Qtd(cCodOS, cCodEtiq, nQuant, nOpc)
****************************************************************************************************************************************************
	Local lRetorno := .T.

	SB1->(dbSetOrder(1))
	If SB1->(dbSeek( xFilial("SB1") + Substr(MV_PAR03,1,Len(SB1->B1_COD)) ))
	
		If nOpc = 2
			MV_PAR07 := ConvUm(SB1->B1_COD, nQuant, 0, nOpc)
			
		Else
			MV_PAR05 := ConvUm(SB1->B1_COD, 0, nQuant, nOpc)
			
		Endif
	Endif

Return lRetorno


****************************************************************************************************************************************************
Static Function fTransfere(nQtde, cEndDestino)
****************************************************************************************************************************************************
	Local aTransf := {}
	Local nModBkp := 0

	aAdd(aTransf, 	{"",dDataBase} )
	aAdd(aTransf,	{	SB1->B1_COD,;  				&& 01- Produto Origem
						SB1->B1_DESC,; 		    	&& 02- Descricao Produto Origem
						SB1->B1_UM,;           		&& 03- Unidade Medida Prod. Origem
						"21",;   					&& 04- Armazem Original
						cEndOrig,;					&& 05- Endereco Original
						SB1->B1_COD,;   			&& 06- Produto Destino
						SB1->B1_DESC,;     			&& 07- Descricao Produto Destino
						SB1->B1_UM,;     			&& 08- Unidade Medida Prod. Destino
						"21",;   					&& 09- Armazem Destino
						cEndDestino,;   			&& 10- Endereco Destino
						cLoteOrig,;  				&& 11- Numero de Serie
						Space(10),;              	&& 12- Lote
						Space(06),;               	&& 13- Sublote
						Ctod(""),;       			&& 14- Data validade
						0,;  						&& 15- Potencia
						nQtde,;   	        		&& 16- Quantidade
						0,;	        				&& 17- Quantidade 2um.
						Space(01),;  				&& 18- Estorno
						Space(06),;  				&& 19- Sequencia
						Space(10),;   				&& 20- Lote Destino
						Ctod(""),;					&& 21- Validade Lote Destino
						"",;						&& 22- Item Grade
						"",;						&& 23- D3_CODLAN
						"",;						&& 24- D3_CODLAN
						"",;						&& 25- Id
						"DESMEMBRAMENTO DE PALLET",; && 26- Observação Padrão
						"",;						&& 27- D3_ZZOP
						"",;						&& 28- D3_SEGUM
						"",;						&& 29- D3_ZZRNC
						"",;						&& 30- D3_ZZRNCOB
						0,;							&& 31- D3_ZZRNCVA
						""})						&& 32- D3_ZZRASTR					
					
	If Len(aTransf) > 0
		nModBkp := nModulo
		nModulo := 4
				
		Begin Transaction
			aTransf[1,1]:= NextNumero("SD3",4,"D3_DOC",.T.)
			lMsErroAuto := .F.
				
			MsExecAuto({|x,y| Mata261(x,y)},aTransf,3)
				
			If lMsErroAuto
				MostraErro()
				DisarmTransaction()
			Else
				Aviso("TRANSFERÊNCIA","Transferência concluída com sucesso.",{"Ok"})
			Endif
		End Transaction
		
		nModulo := nModBkp
	Endif

Return Nil
