#INCLUDE "TBICONN.CH"
#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ PARA001  ³ Autor ³                     ³ Data ³25/11/2016  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Rotina que tem como objetivo a atualização da Chave nas    ³±±
±±³          ³ nf´s de transferencia, baseado nas NF de Saida de Origem.  e±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SigaFat                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function PARA001
Local _cAliasSF2 := ""
Local _cFilTrf   := space(02)
Local _cRotina   := "PARA001"
Local cDoc     := PesqPict('SF2','F2_DOC')
Local cSerie   := PesqPict('SF2','F2_SERIE')
Local cFornece := PesqPict('SF2','F2_CLIENTE')
Local cLojaFor := PesqPict('SF2','F2_LOJA')
Local cEmissao := PesqPict('SF2','F2_EMISSAO')
Local _cCHVNFE := PesqPict('SF2','F2_CHVNFE')
Local cCliente := PesqPict('SF2','F2_CLIENTE')
Local cLojaCli := PesqPict('SF2','F2_LOJA')
Local cCNPJOri := SM0->M0_CGC
Local _cTipo   := " "
Private cEmpOri	 := cEmpAnt
Private cFilOri	 := cFilAnt

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Realiza ajuste no dicionario de dados                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//AjustaSX1()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                               ³
//³ mv_par01        // NF Entrada								       ³
//³ mv_par02        // Serie NF 									   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte("PAR001",.T.)

dbSelectArea("SF2")
// Montagem da query
_cAliasSF2 := GetNextAlias()
_cQuery    := "SELECT SF2.* FROM "+RetSqlName("SF2")+" SF2 "
_cQuery    += " WHERE SF2.F2_FILIAL='"+xFilial("SF2")+"' "
_cQuery    += " AND SF2.F2_EMISSAO >= '"+Dtos(mv_par01)+"' "
_cQuery    += " AND SF2.F2_EMISSAO <= '"+Dtos(mv_par02)+"' "
_cQuery    += " AND SF2.F2_ZZORIGE <> '' "
_cQuery    += " AND SF2.F2_CHVNFE <> '' "
//_cQuery    += " AND SF2.F2_TIPO = 'B' "
_cQuery    += " AND SF2.D_E_L_E_T_= ' ' "

_cQuery    += " ORDER BY "+SqlOrder(SF2->(IndexKey()))
_cQuery    := ChangeQuery(_cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),_cAliasSF2,.T.,.T.)
aEval(SF2->(dbStruct()), {|x| If(x[2] <> "C", TcSetField(_cAliasSF2,x[1],x[2],x[3],x[4]),Nil)})

dbSelectArea(_cAliasSF2)
dbGotop()
If !Eof()
	While !Eof()
		//Salvar e Trocar Filial
		//Chama função AtualizaNFS c\ parametros
		//        SF1, SF3, E SFT
		cDoc     := (_cAliasSF2)->F2_DOC
		cSerie   := (_cAliasSF2)->F2_SERIE
		cCliente := (_cAliasSF2)->F2_CLIENTE
		cLojaCli := (_cAliasSF2)->F2_LOJA
		cEmissao := Dtos((_cAliasSF2)->F2_EMISSAO)
		_cCHVNFE := (_cAliasSF2)->F2_CHVNFE
		
		
		//_cFilTrf := Posicione("SA2",1,xFilial("SA2")+cCliente+cLojaCli,"A2_FILTRF")

		If (_cAliasSF2)->F2_TIPO == "N"
			_cFilTrf     := Posicione("SA1",1,xFilial("SA1")+cCliente+cLojaCli,"A1_FILTRF")
		Else 
			_cFilTrf     := Posicione("SA2",1,xFilial("SA2")+cCliente+cLojaCli,"A2_FILTRF")
		EndIf
		
		If (_cAliasSF2)->F2_TIPO == "N"
			DbselectArea("SA2")
			DbSetOrder(3)
			Dbseek(xFilial("SA2")+cCNPJOri)
			
			cFornece 	:= SA2->A2_COD
			cLojaFor   	:= SA2->A2_LOJA
			_cTipo 		:= "N"
			//cEstCli		:= SA2->A2_EST
		
		Else                          
			DbselectArea("SA1")
			DbSetOrder(3)
			Dbseek(xFilial("SA1")+cCNPJOri)
			
			cFornece 	:= SA1->A1_COD
			cLojaFor   	:= SA1->A1_LOJA
			_cTipo 		:= "B"			
			//cEstCli		:= SA1->A1_EST
		
		EndIf

		/*
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Monta filtro e indice temporario na SA2 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cArqIdx := CriaTrab(,.F.)
		IndRegua("SA1", cArqIdx, "A1_FILIAL+A1_FILTRF",,,"Selecionando Registros ...")
		nIndex := RetIndex("SA1")
		dbSetOrder(nIndex+1) // A2_FILIAL+A2_FILTRF
		
		If !dbSeek(xFilial("SA1")+_cFilTrf)
			// Nao existem dados da filial origem cadastrados como fornecedor na filial destino. A transferencia nao sera realizada
			Alert("Nao existem dados da filial origem cadastrados como fornecedor na filial destino. A transferencia nao sera realizada")
			Return(.F.)
		EndIf
		
		cFornece 	:= SA1->A1_COD
		cLojaFor   	:= SA1->A1_LOJA
		//cFilFor     := SA1->A1_FILTRF
		
		// Apagar o indice temporario
		dbSelectArea("SA1")
		RetIndex("SA1")
		Ferase( cArqIdx + OrdBagExt() )
		dbSelectArea(_cAliasSF2)
		*/
		
		cEmpAtu  := cEmpAnt
		cFilAtu  := _cFilTrf   ///Filial do Cliente (Beneficiatario)
		cFilAnt	:= cFilAtu

		
		//Atuliza NFs e Fiscal c\ dados do Sefaz
		u_AtuNFsTrans(cEmpAtu,cFilAtu,cDoc,cSerie,cFornece,cLojaFor,cEmissao,_cRotina,_cCHVNFE,cCliente,cLojaCli,_cTipo)
		
		//Voltar Filial
		cFilAnt	:= cFilOri

		dbSelectArea(_cAliasSF2)
		(_cAliasSF2)->(dbSkip())
	EndDo
Else
	Aviso("PARA001","Não foram encontrados registros para atualizar, verifique os parametros!",{"Ok"})
EndIf
//Fecha arquvio trabalho
(_cAliasSF2)->(dbCloseArea())

Return()

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AjustaSX1  ³ Autor ³Microsiga S/A        ³ Data ³ 06/01/09 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Realiza ajustes no dicionario SX1                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Sintaxe  ³ AjustaSX1()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ A410CONS                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
/*Static Function AjustaSX1()
Local _aAreaAnt := GetArea()
Local _nTamSX1  := Len(SX1->X1_GRUPO)

// --- Emissao de
PutSX1("PAR001","01","Emissao De?","Emissao De?","Emissao De?","MV_CH1","D",8,0,0,"G","!Vazio()",;
"  ","","","mv_par01","","","","","","","","","","","","","","","","",{"Data inicial da emissao da "," Nota Fiscal de Saida"})

// --- Emissao Ate
PutSX1("PAR001","02","Emissao Ate?","Emissao Ate?","Emissao Ate?","MV_CH2","D",8,0,0,"G","!Vazio()",;
"  ","","","mv_par02","","","","","","","","","","","","","","","","",{"Data final da emissao da "," Nota Fiscal de Saida"})


RestArea(_aAreaAnt)

Return
*/