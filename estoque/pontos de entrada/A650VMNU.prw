#INCLUDE "Protheus.ch"
//#Include "SIGACUSA.CH" -- INCLUDE AO LADO PARA FONTE DE APOIO(_SELEOPC())


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A650VMNU  ºAutor  ³Guilherme Giuliano  º Data ³  28/12/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada para criação de Botao na rotina de ordem de  º±±
±±º          ³ Producao, VENDAS.                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ParafiX                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


*************************************************************************
User Function A650VMNU
*************************************************************************
	aadd(aRotina,{"Definir Opc.","U_AEST01()"	, 2 , 2 })   //4, 0,NIL})		//"Status do pedido"
return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AEST01  ºAutor  ³Guilherme Giuliano  º Data ³  28/12/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para escolher os opcionais de cada item de pedido   º±±
±±º          ³ que será gerado Ordem de Produção                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ParafiX                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

*************************************************************************
User Function AEST01
*************************************************************************
Local cAux := SeleOpc(4, "A650", SC6->C6_PRODUTO, .T.,,SC6->C6_OPC)

IF len(cAux) > 0
	RecLock("SC6",.F.)
		SC6->C6_OPC := cAux
	MsUnlock()
ENDIF	
Return            
/*
/*
/* FONTE ABAIXO Só PARA APOIO
/*
/*
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ SeleOpc  ³ Autor ³Rodrigo de A. Sartorio ³ Data ³ 12/09/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna a selecao de opcionais de acordo com os parametros ³±±
±±³          ³ recebidos.                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ SeleOpc(ExpN1)                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 = Expressao numerica usada para indicar o tipo de    ³±±
±±³          ³ entrada de dados (1) Enchoice (2) GetDados (3) GetDB       ³±±
±±³          ³ (4) Get Fixo                                               ³±±
±±³          ³ ExpC2 = Nome do Programa                                   ³±±
±±³          ³ ExpC3 = Codigo do Produto                                  ³±±
±±³          ³ ExpL4 = Verifica se Produto e uma referencia               ³±±
±±³          ³ ExpC5 = Retorno com a string de opcionais                  ³±±
±±³          ³ ExpC6 = Opcionais marcados                                 ³±±
±±³          ³ ExpC7 = Campo com o nome do produto pai                    ³±±
±±³          ³ ExpL8 = Visualiza janela de selecao de opcionais           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
/*
User Function SeleOpc(nTipo,cProg,cProd,lReferencia,cRet,cOpcMarc,cCampo,lVisual)
Local nz		:=0
Local nPosOpc	:=0
Local cProduto	:=""
Local cVar		:=""
Local nEnd		:=""
Local aTam		:={}
Local aBack		:={}
Local cOldAlias	:=Alias()
Local lSeleOpc  :=.T.
Local lRet 		:=.T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Parametro utilizado para indicar se permite repetir o mesmo grupo de    | 
//| opcionais em varios niveis ou nao.                                      |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local lOpcPadrao:= GetNewPar("MV_REPGOPC","N") == "N"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Ponto de entrada utilizado para inibir a tela de selecao de opcionais.  |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local lMTSeleOp := ExistBlock("MTSELEOP")

Default cRet	:=""
Default cOpcMarc:=""
Default lVisual :=.F.
Default cCampo  :=ReadVar()

cProg := If(cProg == NIL, "", cProg)
lReferencia := If(lReferencia == NIL, .F., lReferencia)
cProduto := If(nTipo==4 .Or. lVisual,cProd,&(ReadVar()))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Caso nao exista cria array que registra todos os niveis da estrutura    | 
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Type("aRetorOpc") <> "A"
	aRetorOpc:={}
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se Utilizar Grade no Mata650, o foco  estara posicionado no ³
//³ M->C2_QUANT                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cProg$"A650" .And. lReferencia
	cCampo   := "M->C2_PRODUTO"
	cProduto :=  cProd
EndIf	
If cProg$"A750" .And. lReferencia
	cCampo   := "M->HC_PRODUTO"
	cProduto :=  cProd
EndIf	
If cProg$"A700" .And. lReferencia
	cCampo   := "M->C4_PRODUTO"
	cProduto :=  cProd
EndIf	
If cProg=="MATA010" 
	lRet     := .F.
	cCampo   := "M->B1_COD"
	cProduto :=  cProd
EndIf
If cProg=="MATA410A" 
	cCampo   := "M->C6_PRODUTO"
	cProduto :=  cProd
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica atraves de parametro se deve ou nao verificar      ³
//³ cadastramento de opcionais                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !(GetMV("MV_SELEOPC",.T.)) .Or. (GetMV("MV_SELEOPC",.T.) .And. GetMV("MV_SELEOPC") == "S")
	If	lMTSeleOp
		lSeleOpc:= ExecBlock("MTSELEOP",.F.,.F.,{cRet,cProd})
	EndIf
	If lSeleOpc
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Define qual campo deve ser atualizado                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If cMODULO = "EEC"
			If lOpcPadrao
				cVAR := Substr(cCAMPO,4,AT("_",cCAMPO)-3)+"OPC"
			Else
				cVAR := Substr(cCAMPO,4,AT("_",cCAMPO)-3)+"MOP"
			EndIf
		Else
			If lOpcPadrao
				cVar:=Substr(cCampo,4,3)+"OPC"
			Else
				cVar:=Substr(cCampo,4,3)+"MOPC"	
			EndIf
		EndIf
		aTam:=TAMSX3(cVar)
		cVar:=cVar+Space(10-Len(cVar))
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se os campos estao em uso                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		// Selecao em Enchoice
		If nTipo == 1
			nEnd := Ascan(aGets,{ |x| Substr(x,9,10) == cVar } )
			If nEnd > 0
				// Funcao recursiva para selecao de opcionais
				lRet:=_MarkOpc(cProduto,@cRet,aRetorOpc,"",cProduto,cProg,cOpcMarc,lVisual,1)
			EndIf
			// Selecao em GetDados ou Selecao em GetDb
		ElseIf nTipo == 2 .Or. nTipo == 3
			// Obtem posicao dos opcionais em caso de GetDados
			nPosOpc := Ascan(aHeader,{ |x| x[2] == cVar })
			If nPosOpc > 0
				// Funcao recursiva para selecao de opcionais
				lRet:=_MarkOpc(cProduto,@cRet,aRetorOpc,"",cProduto,cProg,cOpcMarc,lVisual,1)
			EndIf
			// Selecao em Get Fixo
		ElseIf nTipo == 4
			// Funcao recursiva para selecao de opcionais
			lRet :=_MarkOpc(cProduto,@cRet,aRetorOpc,"",cProduto,cProg,cOpcMarc,lVisual,1)
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava no array somente a arvore dos itens que tem opcional  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Len(aRetorOpc) > 0 .And. !lOpcPadrao
			aBack:=ACLONE(aRetorOpc)
			aRetorOpc:={}
			For nz:=1 to Len(aBack)
				If !Empty(aBack[nz,2])
					AADD(aRetorOpc,aBack[nz])
				EndIf
			Next nz
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Preenche o conteudo dos campos com os opcionais selecionados³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !lVisual
			If ((!Empty(cRet) .And. lOpcPadrao) .Or. (Len(aRetorOpc) > 0 .And. !lOpcPadrao)  .Or. (nTipo == 2 .And. Empty(cRet)) )
				// Selecao em Enchoice
				If nTipo == 1
					If cMODULO = "EEC"
						If lOpcPadrao
							&(Substr(cCampo,1,7)+"OPC"):=PADR(cRet,aTam[1])
						Else
							&(Substr(cCampo,1,7)+"MOP"):=Array2STR(aRetorOpc,.F.)
						EndIf
					Else
						If lOpcPadrao
							&(Substr(cCampo,1,6)+"OPC"):=PADR(cRet,aTam[1])
						Else
							&(Substr(cCampo,1,6)+"MOPC"):=Array2STR(aRetorOpc,.F.)
						EndIf
					EndIf
					aTela[Val(Subs(aGets[nEnd],1,2))][Val(Subs(aGets[nEnd],3,1))*2] := If(lOpcPadrao,cRET+Space(Len(aTela[Val(Subs(aGets[nEnd],1,2))][Val(Subs(aGets[nEnd],3,1))*2])-Len(cRet)),Array2STR(aRetorOpc,.F.))
					// Selecao em GetDados
				ElseIf nTipo == 2
					aCols[n,nPosOpc]:=If(lOpcPadrao,PADR(cRet,aTam[1]),Array2STR(aRetorOpc,.F.))
					// Selecao em GetDb
				ElseIf nTipo == 3
					&("TMP1->"+cVar):=If(lOpcPadrao,PADR(cRet,aTam[1]),Array2STR(aRetorOpc,.F.))
				EndIf
			EndIf
		EndIf
		dbSelectArea(cOldAlias)
	EndIf
EndIf
lRefresh:=.T.
Return If(nTipo==4,cRet,lRet)

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ MarkOpc  ³ Autor ³Rodrigo de A. Sartorio ³ Data ³ 17/12/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao recursiva que permite a selecao de Opcionais .      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MarkOpc(ExpC1,ExpC2,ExpA1,ExpC3,ExpC4)                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 = Produto a ter os opcionais escolhidos.             ³±±
±±³          ³ ExpC2 = Retorno da string com os opcionais selecionados.   ³±±
±±³          ³ ExpA1 = Array com retorno de toda estrutura utilizada      ³±±
±±³          ³ ExpC3 = Produto pai da Estrutura                           ³±±
±±³          ³ ExpC4 = String com os produtos da estrutura                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
/*
Static Function _MarkOpc(cProduto,cRet,aRetorOpc,cProdPai,cProdAnt,cProg,cOpcMarc,lVisual,nNivel)

Static oOk,oNo,oBr

Local cAlias	:=Alias()
Local nRecno	:=Recno()
Local nOrder	:=IndexOrd()
Local cCadastro	:=STR0014+cProduto //"Opcionais Disponiveis - "
Local nAcho		:=0
Local nString	:=0
Local i			:=0
Local nOpca		:=1
Local aGrupos	:={}
Local aRegs		:={}
Local cOpcionais:="" // Variavel utilizada para retorno da string
Local nTamDif	:=(Len(SGA->GA_OPC)+Len(SGA->GA_DESCOPC)+13)-(Len(SGA->GA_GROPC)+Len(SGA->GA_DESCGRP)+3)
Local lOpcPadrao:= GetNewPar("MV_REPGOPC","N") == "N"
Local aOpcionais:={}
Local aSize     :={}
Local aPosObj   :={}
Local aInfo     :={}
Local aObjects  :={}
Local nDifSize  :=0
Local lRet      :=.T.
Local lSELEOPC  :=ExistBlock("SELEOPC")
Local lAddOpc   :=ExistBlock("ADDOPC")
Local lGeraOPI  := SuperGetMV("MV_GERAOPI")
Local aCopyRegs :={}
Local oDlg,oOpc,cOpc
Local lGerOPI	:=ExistBlock("MTGEROPI"),lRetOPI:=.T.

Default cProg 	:=""
Default cOpcMarc:= ""
Default lVisual := .F.

cProduto := PadR(cProduto,Len(SB1->B1_COD))
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Caso nao exista cria array que registra todos os niveis da estrutura    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Type("aRetorOpc") <> "A"
	aRetorOpc:={}
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta titulo da janela com o codigo do produto+descricao    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SB1->(dbSetOrder(1))
If SB1->(dbSeek(xFilial("SB1")+cProduto))
	cCadastro:=STR0014+cProdPai+If(!Empty(cProdPai)," - > ","")+Rtrim( cProduto )+" / " + Left(SB1->B1_DESC,25) //"Opcionais Disponiveis - "
	If Empty(cOpcMarc)
		cOpcMarc := SB1->B1_OPC
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Estrutura do array dos opcionais                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// 1 Marcado (.T. ou .F.)
// 2 Titulo("0") ou Item("1")
// 3 Item Opcional+Descricao Opcional
// 4 Grupo de Opcionais
// 5 Registro no SG1
// 6 Nivel no SG1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Varre a estrutura do produto                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SG1")
dbSetOrder(1)
dbSeek(xFilial()+cProduto)
Do While !Eof() .And. SG1->G1_FILIAL+SG1->G1_COD == xFilial()+cProduto
	If !Empty(SG1->G1_GROPC) .And. !Empty(SG1->G1_OPC)
		// Caso ja tenha opcionais preenchidos, pesquisa se nao ‚ o grupo
		// atual
		If !Empty(cRet)
			// Verifica se ‚ a primeira posicao
			If Substr(cRet,1,Len(SGA->GA_GROPC)) == SG1->G1_GROPC
				nString:=1
			Else
				// Procura grupo no campo de opcionais default
				nString:=AT("/"+SG1->G1_GROPC,cRet)
			EndIf
			If nString > 0 .And. lOpcPadrao
				dbSkip()
				Loop
			EndIf
		EndIf
		If SGA->(dbSeek(xFilial("SGA")+SG1->G1_GROPC+SG1->G1_OPC))
			//-- Ponto de Entrada para validar os Opcionais	
			If	lSELEOPC 
				lRet := ExecBlock('SELEOPC',.F.,.F.)
				If ValType(lRet) <> 'L'
					lRet := .T.
				EndIf
				If !lRet //-- Se o Opcional nao for valido
					SG1->(dbSkip())
					Loop
				EndIf
			EndIf
			// Verifica se o grupo ja foi incluido
			nAcho:=ASCAN(aGrupos,SG1->G1_GROPC)
			If nAcho == 0
				AADD(aGrupos,SG1->G1_GROPC)
				// Adiciona titulo ao array
				AADD(aOpcionais,{.F.,"0",SGA->GA_GROPC+" - "+SGA->GA_DESCGRP+Space(nTamDif),SGA->GA_GROPC,SGA->(Recno()),SG1->G1_NIV+SG1->G1_COMP,SG1->(Recno()),.T.,SG1->G1_COMP})
			EndIf
			// Verifica se o grupo ja foi digitado neste nivel
			nAcho:=ASCAN(aOpcionais,{ |x| x[2] == "1" .And. x[4] == SGA->GA_GROPC .And. x[5] == SGA->(Recno())})
			If nAcho == 0
				// Adiciona item ao array
				If !lVisual
					AADD(aOpcionais,{SGA->GA_GROPC+SGA->GA_OPC $ cOpcMarc,"1",SGA->GA_OPC+" - "+SGA->GA_DESCOPC,SGA->GA_GROPC,SGA->(Recno()),SG1->G1_NIV+SG1->G1_COMP,SG1->(Recno()),SG1->G1_INI<=dDataBase.And.SG1->G1_FIM>=dDataBase,SG1->G1_COMP})
				Else
					If (SGA->GA_GROPC+SGA->GA_OPC $ cOpcMarc)
						AADD(aOpcionais,{SGA->GA_GROPC+SGA->GA_OPC $ cOpcMarc,"1",SGA->GA_OPC+" - "+SGA->GA_DESCOPC,SGA->GA_GROPC,SGA->(Recno()),SG1->G1_NIV+SG1->G1_COMP,SG1->(Recno()),SG1->G1_INI<=dDataBase.And.SG1->G1_FIM>=dDataBase,SG1->G1_COMP})
					EndIf
				EndIf
			EndIf
		EndIf
	Else
		// Caso nao tenha opcionais neste nivel, guarda o registro para
		// pesquisar em niveis inferiores
		AADD(aRegs,{SG1->(Recno()),SG1->G1_NIV+SG1->G1_COMP,SG1->G1_COMP})
	EndIf
	dbSkip()
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Caso tenha opcionais neste nivel, monta a tela de sele‡ao   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(aOpcionais) > 0
	// Valor padrao para DIALOG
	nOpca:=0
	// Sorteia array com grupos
	ASORT(aGrupos)
	// Sorteia array com opcionais
	ASORT(aOpcionais,,,{|x,y| x[4]+x[2]+x[3] < y[4]+y[2]+y[3] })

	If !IsBlind()
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Le na resource os bitmaps utilizados no Listbox p/ sele‡ao  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If oOk == NIL
			oOk := LoadBitmap( GetResources(), "LBOK")
		EndIf
		If oNo == NIL
			oNo := LoadBitmap( GetResources(), "LBNO")
		EndIf
		If oBr == NIL
			oBr := LoadBitmap( GetResources(), "NADA")
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Calcula automaticamente as dimensoes dos objetos            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aSize := MsAdvSize(.F.)
		aObjects := {}
		AAdd( aObjects, { 100,  20, .T., .F. } )
		AAdd( aObjects, { 100, 100, .T., .T., .T. } )
		AAdd( aObjects, { 100,  15, .T., .F. } )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Diminui o tamanho retornado e garante que a largura da Dialog nao ultrapasse 600 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nDifSize := 0
		If ( aSize[ 5 ] - 80 ) > 600
			nDifSize := aSize[ 5 ] - 80 - 600
		EndIf

		aSize[ 3 ] -= 40 + nDifSize / 2	
		aSize[ 4 ] -= 40

		aSize[ 5 ] -= 80 + nDifSize
		aSize[ 6 ] -= 80

		aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 2 }
		aPosObj := MsObjSize( aInfo, aObjects )

		Do While .T.

			DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 To aSize[6],aSize[5] OF oMainWnd PIXEL

			@ 05, 03 SAY cCadastro OF oDlg PIXEL

			@ 15, 00 TO 17, 2000 PIXEL 	

			@ aPosObj[2,1],aPosObj[2,2] LISTBOX oOpc VAR cOpc Fields HEADER "",STR0015,STR0038  SIZE aPosObj[2,3],aPosObj[2,4] ON DBLCLICK If(!lVisual,(aOpcionais:=_OpcTroca(oOpc:nAt,aOpcionais),oOpc:Refresh()),) NOSCROLL OF oDlg PIXEL  //"Grupos/Itens Opcionais"###"Validade Componente"
			oOpc:SetArray(aOpcionais)
			oOpc:bLine := { || {If(aOpcionais[oOpc:nAt,2]=="0",oBr,IF(aOpcionais[oOpc:nAt,1],oOk,oNo)),aOpcionais[oOpc:nAt,3],If(aOpcionais[oOpc:nAt,2]=="0","",If(aOpcionais[oOpc:nAt,8]," Ok",STR0039))}} //" Vencido"
			DEFINE SBUTTON FROM aPosObj[3,1]+2,aPosObj[3,4] - 57 TYPE 1 ACTION (IF(If(!lVisual,_OpcTudOk(cProduto,aOpcionais,aGrupos,@aRegs,@cOpcionais,cProg),.T.),(nOpca:=1,oDlg:End()),)) ENABLE OF oDlg PIXEL
			DEFINE SBUTTON FROM aPosObj[3,1]+2,aPosObj[3,4] - 27 TYPE 2 ACTION (nOpca:=0,oDlg:End()) ENABLE OF oDlg PIXEL
			ACTIVATE MSDIALOG oDlg CENTERED
			If nOpcA == 1 .Or. lVisual
				Exit
			ElseIf nOpca == 0
				Exit
			EndIf
		EndDo
	Else
		_OpcTudOk(cProduto,aOpcionais,aGrupos,@aRegs,@cOpcionais)
		If !Empty(cOpcionais)
			nOpcA := 1
		EndIf
	EndIf
	cRet+=cOpcionais
	// Adiciona no array que registra todos os niveis da estrutura
	If !lOpcPadrao .And. nNivel > 1
		aRetorOpc[Len(aRetoropc),2]:=cOpcionais
	EndIf
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de Entrada para adicionar mais opcionais ao array aRegs.	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lAddOpc
	aCopyRegs := aClone(aRegs)
	aRegs     := ExecBlock('ADDOPC',.F.,.F.,{aRegs,cProdAnt,cOpcionais})
	If ValType(aRegs) <> 'A'
		aRegs := aClone(aCopyRegs)
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de entrada para a utilizado para verificar a 		    ³
//³ necessidade de gerar ou nao OPs intermediarias				³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lGerOPI
	lRetOPI:=ExecBlock("MTGEROPI",.F.,.F.)
	If ValType(lRetOPI) # "L"
		lRetOPI:=.T.
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Na inclusao manual de OPs, nao deve analisar opcionais de           ³
//³outros niveis da estrutura, quando o parametro MV_GERAOPI for Falso ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRetOPI .And. (  lGeraOPI .Or. !( "C2_PRODUTO" $ ReadVar() ) )
	ASORT(aRegs,,,{|x,y| x[2] < y[2]})
	// Varre o array para que sejam selecionados os itens restantes
	For i:=1 to Len(aRegs)
		If SG1->(dbSeek(xFilial("SG1")+aRegs[i,3]))
			SG1->(dbGoto(aRegs[i,1]))
			// Adiciona no array que registra todos os niveis da estrutura
			AADD(aRetorOpc,{cProdAnt+SG1->G1_COMP+SG1->G1_TRT,""})
			nNivel+=1
			_MarkOpc(SG1->G1_COMP,@cRet,aRetorOpc,SG1->G1_COD,cProdAnt+SG1->G1_COMP+SG1->G1_TRT,cProg,cOpcMarc,lVisual,nNivel)	
			nNivel-=1
		Else
			SG1->(dbGoto(aRegs[i,1]))
			If !lOpcPadrao .And. nNivel == 1
				// Adiciona no array que registra todos os niveis da estrutura
				AADD(aRetorOpc,{cProdAnt+SG1->G1_COMP+SG1->G1_TRT,cOpcionais})
			EndIf
		EndIf
	Next I
EndIf
dbSelectArea(cAlias)
dbGoto(nRecno)
dbSetOrder(nOrder)
Return nOpcA == 1

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³ OpcTroca                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Autor     ³ Rodrigo de Almeida Sartorio              ³ Data ³ 12/09/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³ Troca marcador entre x e branco                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe    ³ Versao Windows-> OpcTroca(ExpN1,ExpA1)                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros ³ (Somente versao WINDOWS)                                   ³±±
±±³           ³ ExpN1 = Linha em que esta sendo efetuado o Double-Click    ³±±
±±³           ³ ExpA1 = Array utilizado na marcacao                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  Uso      ³ Selecao de Opcionais                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
/*
Static Function _OpcTroca(nIt,aArray)
LOCAL nAcho:=0
// Muda caso seja ITEM
If aArray[nIt,2] == "1"
	// Varre o array para verificar se marcou apenas um item por grupo
	nAcho:=ASCAN(aArray,{|x| x[4] == aArray[nIt,4] .And. x[1]})
	If nAcho > 0 .And. nAcho # nIt
		// Desmarca Item
		aArray[nAcho,1]:= .F.
	EndIf
	aArray[nIt,1]  := !aArray[nIt,1]
EndIf
Return aArray

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Fun‡…o    ³ OpcTudOk                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Autor     ³ Rodrigo de Almeida Sartorio              ³ Data ³ 12/09/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descri‡…o ³ Verifica se esta tudo Ok na selecao dos opcionais          ³±±
±±³           ³ e monta string com os opcionais selecionados               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe    ³ OpcTudOk(ExpC1,ExpA1,ExpA2,ExpA3,ExpC2)                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros ³ ExpC1 = Codigo do produto                                  ³±±
±±³           ³ ExpA1 = Array utilizado na marcacao                        ³±±
±±³           ³ ExpA2 = Array com os grupo de Opcionais                    ³±±
±±³           ³ ExpA3 = Registros selecionados                             ³±±
±±³           ³ ExpC2 = String com os Opcionais selecionados               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  Uso      ³ Selecao de Opcionais                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
/*
Static Function _OpcTudOk(cProduto,aArray,aGrupos,aRegs,cOpcionais,cProg)
LOCAL nAcho:=0,nString:=0,i
LOCAL lRet:=.T.
LOCAL aTam:=TAMSX3("GA_OPC")
LOCAL cDefault:=""
LOCAL cBackOpc:=cOpcionais

If cProg # "MATA010"
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Valida se todos grupos tiveram um item selecionado ou possuem³
	//³opcional default cadastrado no SB1                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For i:=1 to Len(aGrupos)
		// Pesquisa no array se grupo nao teve item marcado
		nAcho:=ASCAN(aArray,{|x| x[4] == aGrupos[i] .And. x[1]})
		// Caso nao achou item marcado procura opcional default
		If nAcho == 0
			dbSelectArea("SB1")
			dbSetOrder(1)
			If dbSeek(xFilial()+cProduto)
				If !Empty(B1_OPC)
					// Verifica se o grupo esta na primeira posicao
					If Substr(B1_OPC,1,Len(SGA->GA_GROPC)) == aGrupos[i]
						nString:=1
					Else
						// Procura grupo nas posicoes seguintes
						nString:=AT("/"+aGrupos[i],B1_OPC)
					EndIf
					If nString > 0
						nString:=IF(nString=1,1,nString+1)
						cDefault:=Substr(B1_OPC,nString,Len(SGA->GA_GROPC+SGA->GA_OPC))
						nAcho:=0
						nAcho:=ASCAN(aArray,{|x| Substr(x[3],1,Len(SGA->GA_OPC)) == Substr(cDefault,Len(SGA->GA_GROPC)+1) })
						If nAcho > 0
							cOpcionais+=cDefault+"/"
						EndIf
					EndIf
				EndIf
				// Caso nao achou o grupo no campo de opcionais default
				If nString <=0 .Or. nAcho <= 0
					Help ("",1,"MARCAGRUPO",,aGrupos[i],1,22)
					lRet:=.F.
					// Restaura os opcionais digitados anteriormente
					cOpcionais:=cBackOpc
					Exit
				EndIf
			EndIf
		EndIf
	Next i
EndIf
// Monta a string de retorno
If lRet
	For i:=1 to Len(aArray)
		If aArray[i,1]
			cOpcionais+=aArray[i,4]+Substr(aArray[i,3],1,aTam[1])+"/"
			AADD(aRegs,{aArray[i,7],aArray[i,6],aArray[i,9]})
		EndIf
	Next i
EndIf
Return lRet
