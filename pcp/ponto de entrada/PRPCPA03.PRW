#include "Protheus.ch"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Rotina responsavel em realizar os apontamentos de perda e transferencias³
//³entre armazens, via ExecAuto.                                           ³
//³                                                                        ³
//³Autor: Rodrigo Bighetti                                                 ³
//³Data: 15/12/2011                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

User Function PRPCPA03()

Local oPanel1, oPanel2, oDlg, oBtnOK, oBtnCancel, oBtnEncerra
Local cProduto := Space(50)
Local oGrid
Local lVal := .T.
Private cOP := Space(11)

**********************
&& Fontes Utilizados&&
**********************

Private oFnt14a := TFont():New("Arial",,14,,.F.,,,,.F.,.F.)
Private oFnt14b := TFont():New("Arial",,14,,.T.,,,,.F.,.F.)

Private bOk  	:= {|| SalvaApto(), oDlg:End()}     // SALVA E GRAVA
Private bCancel := {|| nOpc := 2, oDlg:End()}  		// SAI
Private aBotoes := {}
Private aHeader	:= {}
Private aCols	:= {}

//--------------------------------------------------------------//
// Montando o aHeader conforme campos selecionados pelo usuario //
//--------------------------------------------------------------//
dbSelectArea("SX3")
dbSetOrder(2)

dbSeek("D4_COD")
aAdd(aHeader, {Trim(getSX3Cache("D4_COD", "X3_TITULO")),;
                    getSX3Cache("D4_COD", "X3_CAMPO"),;
                    getSX3Cache("D4_COD", "X3_PICTURE"),;
                    getSX3Cache("D4_COD", "X3_TAMANHO"),;
                    getSX3Cache("D4_COD", "X3_DECIMAL"),;
                    getSX3Cache("D4_COD", "X3_VALID"), ;
                    getSX3Cache("D4_COD", "X3_USADO"),;
                    getSX3Cache("D4_COD", "X3_TIPO"),;
                    getSX3Cache("D4_COD", "X3_ARQUIVO"),;
                    getSX3Cache("D4_COD", "X3_CONTEXT")})

dbSeek("B1_DESC")
aAdd(aHeader, {Trim(getSX3Cache("B1_DESC", "X3_TITULO")),;
                    getSX3Cache("B1_DESC", "X3_CAMPO"),;
                    getSX3Cache("B1_DESC", "X3_PICTURE"),;
                    getSX3Cache("B1_DESC", "X3_TAMANHO"),;
                    getSX3Cache("B1_DESC", "X3_DECIMAL"),;
                    getSX3Cache("B1_DESC", "X3_VALID"),;
                    getSX3Cache("B1_DESC", "X3_USADO"),;
                    getSX3Cache("B1_DESC", "X3_TIPO"),;
                    getSX3Cache("B1_DESC", "X3_ARQUIVO"),;
                    getSX3Cache("B1_DESC", "X3_CONTEXT")})

dbSeek("B1_UM")
aAdd(aHeader, {Trim(getSX3Cache("B1_UM", "X3_TITULO")),;
                    getSX3Cache("B1_UM", "X3_CAMPO"),;
                    getSX3Cache("B1_UM", "X3_PICTURE"),;
                    getSX3Cache("B1_UM", "X3_TAMANHO"),;
                    getSX3Cache("B1_UM", "X3_DECIMAL"),;
                    getSX3Cache("B1_UM", "X3_VALID"),;
                    getSX3Cache("B1_UM", "X3_USADO"),;
                    getSX3Cache("B1_UM", "X3_TIPO"),;
                    getSX3Cache("B1_UM", "X3_ARQUIVO"),;
                    getSX3Cache("B1_UM", "X3_CONTEXT")})
dbSeek("D4_QUANT")
aAdd(aHeader, {Trim(getSX3Cache("D4_QUANT", "X3_TITULO")),;
                    getSX3Cache("D4_QUANT", "X3_CAMPO"),;
                    getSX3Cache("D4_QUANT", "X3_PICTURE"),;
                    getSX3Cache("D4_QUANT", "X3_TAMANHO"),;
                    getSX3Cache("D4_QUANT", "X3_DECIMAL"),;
                    getSX3Cache("D4_QUANT", "X3_VALID"),;
                    getSX3Cache("D4_QUANT", "X3_USADO"),;
                    getSX3Cache("D4_QUANT", "X3_TIPO"),;
                    getSX3Cache("D4_QUANT", "X3_ARQUIVO"),;
                    getSX3Cache("D4_QUANT", "X3_CONTEXT")})
dbSeek("B1_SEGUM")
aAdd(aHeader, {Trim(getSX3Cache("B1_SEGUM", "X3_TITULO")),;
                    getSX3Cache("B1_SEGUM", "X3_CAMPO"),;
                    getSX3Cache("B1_SEGUM", "X3_PICTURE"),;
                    getSX3Cache("B1_SEGUM", "X3_TAMANHO"),;
                    getSX3Cache("B1_SEGUM", "X3_DECIMAL"),;
                    getSX3Cache("B1_SEGUM", "X3_VALID"),;
                    getSX3Cache("B1_SEGUM", "X3_USADO"),;
                    getSX3Cache("B1_SEGUM", "X3_TIPO"),;
                    getSX3Cache("B1_SEGUM", "X3_ARQUIVO"),;
                    getSX3Cache("B1_SEGUM", "X3_CONTEXT")})
dbSeek("D4_QTSEGUM")
aAdd(aHeader, {Trim(getSX3Cache("D4_QTSEGUM", "X3_TITULO")),;
                    getSX3Cache("D4_QTSEGUM", "X3_CAMPO"),;
                    getSX3Cache("D4_QTSEGUM", "X3_PICTURE"),;
                    getSX3Cache("D4_QTSEGUM", "X3_TAMANHO"),;
                    getSX3Cache("D4_QTSEGUM", "X3_DECIMAL"),;
                    getSX3Cache("D4_QTSEGUM", "X3_VALID"),;
                    getSX3Cache("D4_QTSEGUM", "X3_USADO"),;
                    getSX3Cache("D4_QTSEGUM", "X3_TIPO"),;
                    getSX3Cache("D4_QTSEGUM", "X3_ARQUIVO"),;
                    getSX3Cache("D4_QTSEGUM", "X3_CONTEXT")})
//-------------------//
// Montagem do aCols //
//-------------------//
Aadd(aCols,Array(len(aHeader)+1))

aCols[1][1] := Space(20)
aCols[1][2] := Space(20)
aCols[1][3] := Space(2)
aCols[1][4] := 0.00
aCols[1][5] := Space(2)
aCols[1][6] := 0.00

aCols[len(aCols), len(aHeader)+1] := .F.

DEFINE MSDIALOG oDlg TITLE "Apontamento Transferencias" FROM 000, 000  TO 400, 780 COLORS 0, 16777215 PIXEL

@ 000, 000 MSPANEL oPanel1 SIZE 250, 026 OF oDlg COLORS 0, 16777215 CENTERED RAISED

@ 002, 002 SAY "Ordem de Produção" SIZE 100, 007 OF oPanel1 Font oFnt14b COLORS 0, 16777215 PIXEL
@ 011, 002 MSGET oGet1 VAR cOP SIZE 060, 010 F3 "SC2" OF oPanel1 Font oFnt14b COLORS 0, 16777215 PIXEL Valid(CargaProd(cOP, @cProduto, @oDlg, @oGrid))

@ 002, 071 SAY "Produto" SIZE 100, 007 OF oPanel1 Font oFnt14b COLORS 0, 16777215 PIXEL

@ 011, 071 MSGET oGet2 VAR cProduto SIZE 230, 010 OF oPanel1 Font oFnt14b COLORS 0, 16777215 PIXEL When .F.

oGrid := MsGetDados():New(30,5,182,390,3,"ALLWAYSTRUE","","",.T.,{"D4_QUANT","D4_QTSEGUM"},,.F.,100,,,,,oDlg)

@ 184, 000 MSPANEL oPanel2 SIZE 250, 016 OF oDlg COLORS 0, 16053492 RAISED
@ 002, 002 BUTTON oBtnOK PROMPT "&Confirmar" SIZE 037, 012 OF oPanel2 PIXEL Action Processa({|| SalvaDados(cOP, @oDlg)}, "Aguarde ... Salvando dados...")
@ 002, 353 BUTTON oBtnCancel PROMPT "&Cancelar" SIZE 037, 012 OF oPanel2 PIXEL Action (oDlg:End())

// Don't change the Align Order
oPanel1:Align := CONTROL_ALIGN_TOP
oPanel2:Align := CONTROL_ALIGN_BOTTOM

ACTIVATE MSDIALOG oDlg CENTERED

Return

//|--------------------------------------------------------------|
//| Funcao: SalvaDados          | Autor: Rodrigo Bighetti        |
//|--------------------------------------------------------------|
//| Descricao: Executa os ExecAutos para gravação das            |
//|            informações                                       |
//|--------------------------------------------------------------|
//| Data criacao  : 20/12/2012  | Ultima alteracao:              |
//|--------------------------------------------------------------|
//|                                                              |
//.==============================================================.

Static Function SalvaDados(cOP, oDlg)

Local aMATA685  := {}	   //Campos do apontamento de perdas
Local aMATA685B := {}	   //Campos de Cabeçalho
Local aMATA240  := {}	   //Campos das movimentações internas
Local aLinha    := {}

Local cParReq := Alltrim(GetMv("MV_ZZREQ")) // TM de Requisicao
Local cParDev := Alltrim(GetMv("MV_ZZDEV")) // TM de Devolucao

Local nResto := 0
Local nDevol := 0
Local lResto := .T.
Local lRet   := .T.

Local cOrigem  := Alltrim(GetMv("MV_ZZORIG"))		//Parametro para armazem de devolução
Local cDestino := ALltrim(GetMv("MV_ZZLOCPR"))		//Parametro para armazem de requisição

Private lMsErroAuto := .F.
Private lMsHelpAuto := .T.

lRet := SaldoDev() // Verifica se a qtde a ser devolvida é maior que a qtde transferida - a qtde requisitada.

if lRet
	
	For nOP:=1 to Len(aCols)
		
		if !aCols[nOP,len(aCols[nOP])]  // Linha deletada nao valida
			
			aLinha    := {}
			aMATA685  := {}
			aMATA685B := {}
			
			//------------------------------------------------------//
			// Calcula o total transferido para a Ordem de Producao //
			//------------------------------------------------------//
			IF SELECT("TRB") <> 0
				TRB->(DBCLOSEAREA())
			ENDIF
			
			BEGINSQL ALIAS "TRB"
				SELECT SUM(D3_QUANT) AS TOTTRANSF
				FROM %TABLE:SD3% SD3
				WHERE
				SD3.%NOTDEL%
				AND SD3.D3_FILIAL = %XFILIAL:SD3%
				AND SD3.D3_ZZOP = %Exp:cOP%
				AND SD3.D3_COD = %exp:aCols[nOP][1]%
				AND SD3.D3_ESTORNO = ' '
				AND SD3.D3_CF = 'DE4'
				AND SD3.D3_TM = '499'
			ENDSQL
			
			//--------------------------------------------------//
			// Calcula o total requisitado para a Ordem Producao//
			//--------------------------------------------------//
			IF SELECT("TRB2") <> 0
				TRB->(DBCLOSEAREA())
			ENDIF
			
			BEGINSQL ALIAS "TRB2"
				SELECT SUM(D3_QUANT) AS TOTREQUI
				FROM %TABLE:SD3% SD3
				WHERE
				SD3.%NOTDEL%
				AND SD3.D3_FILIAL = %XFILIAL:SD3%
				AND SD3.D3_OP = %Exp:cOP%
				AND SD3.D3_COD = %exp:aCols[nOP][1]%
				AND SD3.D3_ESTORNO = ' '
				AND SD3.D3_CF = 'RE1'
				AND SD3.D3_TM = '999'
			ENDSQL
			
			dbSelectArea("TRB")
			dbSelectArea("TRB2")
			
			nDevol := TRB->TOTTRANSF - TRB2->TOTREQUI
			nResto := TRB->TOTTRANSF - TRB2->TOTREQUI - aCols[nOp][4]
			
			TRB->(dbCLoseArea())
			TRB2->(dbCloseArea())
			
			if nResto > 0
				
				aAdd(aMATA685B,{"BC_OP",		cOP,   			Nil})
				//aAdd(aMATA685B,{"BC_RECURSO",	 "",	      	Nil})
				//aAdd(aMATA685B,{"BC_OPERAC",     "",	      	Nil})
				aAdd(aMATA685,{"BC_OP",		    cOP,			Nil})
				aAdd(aMATA685,{"BC_LOCORIG",    cDestino,		Nil})
				aAdd(aMATA685,{"BC_PRODUTO",	aCols[nOP][1],	Nil})
				aAdd(aMATA685,{"BC_TIPO",		"S",			Nil})
				aAdd(aMATA685,{"BC_MOTIVO",	    "001",			Nil})
				aAdd(aMATA685,{"BC_DESCRI",	    FunName(),		Nil})
				aAdd(aMATA685,{"BC_QUANT",	    nResto,	    	Nil})
				
				//if aCols[nOP][6] <> 0
				dbSelectArea("SB1")
				dbSetOrder(1)
				dbSeek(xFilial("SB1")+aCols[nOP][1])
				
				nSegun := 0
				
				if SB1->B1_TIPCONV == "M"
					nSegun := nResto * SB1->B1_CONV
				else
					nSegun := nResto / SB1->B1_CONV
				EndIf
				
				aAdd(aMATA685,	{"BC_QTSEGUM",	nSegun,	Nil})
				
				//	else
				//		aAdd(aMATA685,	{"BC_QTSEGUM",	aCols[nOP][6],	Nil})
				//	endif
				
				//-------------------------------------------------------//
				// Executa a rotina automatica para apontamento de perda //
				//-------------------------------------------------------//
				lMsErroAuto := .F.
				
				aAdd(aLinha,aMATA685)
				
				MsExecAuto({|x,y,z|MATA685(x,y,z)}, aMATA685B, aLinha, 3)
				if lMsErroAuto
					MostraErro()
					DisarmTransaction()
					Return
				Endif
			Endif
			
			if nDevol > 0 .and. aCols[nOp][4] <> 0
				
				//---------------------------------------------------------------------//
				// Executa a rotina automatica para requisicoes do armazem da producao //
				//---------------------------------------------------------------------//
				
				aMATA240 := {}
				
				//Adiciona os itens para o array do ExecAuto
				aAdd(aMATA240, {"D3_TM",	  cParReq,		  Nil})
				aAdd(aMATA240, {"D3_COD",	  aCols[nOP][1],  Nil})
				aAdd(aMATA240, {"D3_DESCRI",  aCols[nOP][2],  Nil})
				aAdd(aMATA240, {"D3_UM",	  aCols[nOP][3],  Nil})
				aAdd(aMATA240, {"D3_QUANT",	  aCols[nOP][4],  Nil})
				aAdd(aMATA240, {"D3_CF",	  "RE0",		  Nil})
				aAdd(aMATA240, {"D3_ZZOP",	  cOP,			  Nil})
				aAdd(aMATA240, {"D3_LOCAL",	  cDestino,		  Nil})
				aAdd(aMATA240, {"D3_SEGUM",	  aCols[nOP][5],  Nil})
				aAdd(aMATA240, {"D3_QTSEGUM", aCols[nOP][6],  Nil})
				
				lMsErroAuto := .F.
				MsExecAuto({|x,y|MATA240(x,y)}, aMATA240,3)
				if lMsErroAuto
					MostraErro()
					DisarmTransaction()
					Return
				endif
				
				//--------------------------------------------------------------------//
				// Executa a rotina automatica para Devolucoes do armazem da producao //
				//--------------------------------------------------------------------//
				
				aMATA240 := {}
				
				//Adiciona os itens para o array do ExecAuto
				aAdd(aMATA240, {"D3_TM",	   cParDev,		  	Nil})
				aAdd(aMATA240, {"D3_COD",	   aCols[nOP][1],	Nil})
				aAdd(aMATA240, {"D3_DESCRI",   aCols[nOP][2],	Nil})
				aAdd(aMATA240, {"D3_UM",	   aCols[nOP][3],	Nil})
				aAdd(aMATA240, {"D3_QUANT",	   aCols[nOP][4],	Nil})
				aAdd(aMATA240, {"D3_CF",	   "DE0",			Nil})
				aAdd(aMATA240, {"D3_ZZOP",	   cOP,				Nil})
				aAdd(aMATA240, {"D3_LOCAL",	   cOrigem,			Nil})
				aAdd(aMATA240, {"D3_SEGUM",	   aCols[nOP][5],   Nil})
				aAdd(aMATA240, {"D3_QTSEGUM",  aCols[nOP][6], 	Nil})
				
				lMsErroAuto := .F.
				MsExecAuto({|x,y|MATA240(x,y)}, aMATA240,3)
				if lMsErroAuto
					MostraErro()
					DisarmTransaction()
					Return
				endif
				
			Endif
			
		Endif
		
	Next
	
	//----------------------------------------------------------------------------------------//
	// Encerra a Ordem de Producao apos realizadas as transferencias e apontamentos de perdas //
	//----------------------------------------------------------------------------------------//
	If MsgYesNo( "Confirma o encerramento da Ordem de Producao" , "Atenção")
		dbSelectArea("SC2")
		dbSetOrder(1)
		if dbSeek(xFilial("SC2")+cOP)
			recLock("SC2",.F.)
			SC2->C2_DATRF := dDataBase
			SC2->(msUnlock())
		Endif
	Endif
	
else
	alert("Processo cancelado, favor verificar os itens com problemas!")
Endif

oDlg:End()
Return


//|--------------------------------------------------------------|
//| Funcao: CargaProd           | Autor: Rodrigo Bighetti        |
//|--------------------------------------------------------------|
//| Descricao: Carrega o campo Produto                           |
//|--------------------------------------------------------------|
//| Data criacao  : 20/12/2012  | Ultima alteracao:              |
//|--------------------------------------------------------------|
//|                                                              |
//.==============================================================.

Static Function CargaProd(cOP, cProduto, oDlg, oGrid)
Local lRet := .F.
if !Empty(cOP)
	if ExistCPO("SC2",cOP)
		lRet := .T.
		
		dbSelectArea("SC2")
		dbSetOrder(1)
		dbSeek(xFilial("SC2")+cOP)
		
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial("SB1")+SC2->C2_PRODUTO)
		
		cProduto := Alltrim(SC2->C2_PRODUTO)+" - "+SB1->B1_DESC
		CargaEmpenhos(cOP)
		oGrid:Refresh()
		oDlg:Refresh()
	endif
EndIf
Return lRet

//|--------------------------------------------------------------|
//| Funcao: CargaEmpenhos       | Autor: Rodrigo Bighetti        |
//|--------------------------------------------------------------|
//| Descricao: Carrega o aCols com os empenhos da OP             |
//|--------------------------------------------------------------|
//| Data criacao  : 20/12/2012  | Ultima alteracao:              |
//|--------------------------------------------------------------|
//|                                                              |
//.==============================================================.

Static Function CargaEmpenhos(cOP)
Local nI := 0

if select("TSD4") <> 0
	TSD4->(dbCloseArea())
endif

BEGINSQL ALIAS "TSD4"
	SELECT SD4.D4_COD, SB1.B1_DESC, SB1.B1_UM, SB1.B1_SEGUM
	FROM %TABLE:SD4% SD4
	INNER JOIN %TABLE:SB1% SB1 ON (SB1.B1_COD = SD4.D4_COD)
	WHERE
	SD4.%NOTDEL%
	AND SB1.%NOTDEL%
	AND SD4.D4_FILIAL = %XFILIAL:SD4%
	AND SB1.B1_FILIAL = %XFILIAL:SB1%
	AND SD4.D4_OP = %Exp:cOP%
	AND (SB1.B1_TIPO = 'MP' OR SB1.B1_TIPO = 'PI')
	ORDER BY SD4.D4_COD
ENDSQL

dbSelectArea("TSD4")
dbGoTop()

aCols := {}
While TSD4->(!Eof())
	Aadd(aCols,Array(len(aHeader)+1))
	
	nI++
	aCols[nI][1] := TSD4->D4_COD
	aCols[nI][2] := TSD4->B1_DESC
	aCols[nI][3] := TSD4->B1_UM
	aCols[nI][4] := 0.00
	aCols[nI][5] := TSD4->B1_SEGUM
	aCols[nI][6] := 0.00
	aCols[nI][7] := .F.
	
	TSD4->(dbSkip())
EndDo

TSD4->(dbCloseArea())
Return

//|--------------------------------------------------------------|
//| Funcao: SaldoDev            | Autor: Felipe Campos           |
//|--------------------------------------------------------------|
//| Descricao: Verifica o saldo dos empenhos                     |
//|--------------------------------------------------------------|
//| Data criacao  : 20/12/2012  | Ultima alteracao:              |
//|--------------------------------------------------------------|
//|                                                              |
//.==============================================================.

Static Function SaldoDev()

Local lRet   := .T.
Local nResto := 0
Local nDevol := 0

For nOP:=1 to Len(aCols)
	
	if !aCols[nOP,len(aCols[nOP])]  // Linha deletada nao valida
		
		//-----------------------------------------------------//
		//Calcula o total transferido para a Ordem de Producao //
		//-----------------------------------------------------//
		IF SELECT("TRB") <> 0
			TRB->(DBCLOSEAREA())
		ENDIF
		
		BEGINSQL ALIAS "TRB"
			SELECT SUM(D3_QUANT) AS TOTTRANSF
			FROM %TABLE:SD3% SD3
			WHERE
			SD3.%NOTDEL%
			AND SD3.D3_FILIAL = %XFILIAL:SD3%
			AND SD3.D3_ZZOP = %Exp:cOP%
			AND SD3.D3_COD = %exp:aCols[nOP][1]%
			AND SD3.D3_ESTORNO = ' '
			AND SD3.D3_CF = 'DE4'
			AND SD3.D3_TM = '499'
		ENDSQL
		
		//----------------------------------------------------//
		//Calcula o total requisitado para a Ordem de Producao//
		//----------------------------------------------------//
		IF SELECT("TRB2") <> 0
			TRB->(DBCLOSEAREA())
		ENDIF
		
		BEGINSQL ALIAS "TRB2"
			SELECT SUM(D3_QUANT) AS TOTREQUI
			FROM %TABLE:SD3% SD3
			WHERE
			SD3.%NOTDEL%
			AND SD3.D3_FILIAL = %XFILIAL:SD3%
			AND SD3.D3_OP = %Exp:cOP%
			AND SD3.D3_COD = %exp:aCols[nOP][1]%
			AND SD3.D3_ESTORNO = ' '
			AND SD3.D3_CF = 'RE1'
			AND SD3.D3_TM = '999'
		ENDSQL
		
		dbSelectArea("TRB")
		dbSelectArea("TRB2")
		
		nDevol := TRB->TOTTRANSF - TRB2->TOTREQUI
		nResto := TRB->TOTTRANSF - TRB2->TOTREQUI - aCols[nOp][4]
		
		TRB->(dbCLoseArea())
		TRB2->(dbCloseArea())
		
		if nDevol > 0 .and. aCols[nOp][4] == 0
			if !MsgYesNo( "A quantidade digitada para o item "+alltrim(aCols[nOp][1])+"foi zero, deseja continuar?" , "Atenção")
				lRet := .F.
				Return(lRet)
			Endif
		Endif
		
		if nResto < 0
			alert("O produto "+alltrim(aCols[nOp][1])+" nao possui saldo para devolucao, favor verificar!")
			lRet := .F.
		endif
		
	endif
	
Next

Return (lRet)













