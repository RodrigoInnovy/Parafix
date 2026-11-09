#Include "Protheus.ch"
#Include "Topconn.ch"
#include "Fileio.ch"

/*----------------------------------------------------------------------------------------------------------------------------------------------
Tuning Sistemas: Programa Forecast Materiais
Elaborado por: Alex Kubo em 20/04/16
Finalidade: Parte da rotina Budget Parafix. Calcula o valor da necessidade de matéria prima em função do forecast.
Informações e histórico:
Primeira validação e compilação na base de produção do cliente:
----------------------------------------------------------------------------------------------------------------------------------------------*/

user function TS_FOR_MAT()

//browse
local cAlias 		:= "SZ5"
local cFiltra 		:= "Z5_FILIAL == '"+xFilial('SZ5')+"' .And. Z5_TIPO == 'F' .And. Z5_FIRMADO == 'S'
private cCadastro 	:= "Necessidade de Materiais"
private aRotina 	:= {}
private aIndexSZ5 	:= {}
private bFiltraBrw	:= {|| FilBrowse(cAlias,@aIndexSZ5,@cFiltra)}
//calculo de estrutura
private aForecast 	:= {}, aEstrut := {}, aCalculo := {}, aNecessidade := {}, aSaldos := {}, cCalc := ""
//saida excel
private oExcel, nStyleCabec := Nil, nStyleItens := Nil, nEstru := 0, cNome := "" 

AADD(aRotina,{"Pesquisar", 	   			"PesqBrw" 		,0,1})
AADD(aRotina,{"Visualizar",	   			"AxVisual" 		,0,2})
AADD(aRotina,{"Gerar Planilha", 		"U_CALC_EST"	,0,6})
AADD(aRotina,{"Consultar produto", 		"U_CONS_PR"		,0,7})

dbSelectArea(cAlias)
dbSetOrder(1)
Eval(bFiltraBrw)
dbGoTop()
mBrowse(6,1,22,75,cAlias,,,,,,)
EndFilBrw(cAlias,aIndexSZ5) 

return

user function CALC_EST()

local cOpcional := ""
local nStandard := 0, nOpcional := 0, nArq, cConteudo
local cGrpOpc	:= ""
local cMRP	:= ""
private nQry := 0, aLinha := array(15), nPos_saldo := 0

aForecast := {}
aCalculo := {}
aNecessidade := {}
aSaldos := {}
ZERLIN()
GERQRY()
if nQry > 0
	//imprime na planilha o forecast
	cNome := DToS(dDataBase) + "_" + StrTran(SubStr(Time(), 1, 5), ":", "_") + "_Forecast_" + alltrim(SZ5->Z5_DOC)
	GEREXC()
	oExcel:NewWorkSheet("Forecast " + alltrim(SZ5->Z5_DOC))
	oExcel:NewRow(Nil)
	oExcel:NewCol("Produto", 0, 0, nStyleCabec, Nil) 
	oExcel:NewCol("Descr", 0, 0, nStyleCabec, Nil)
	oExcel:NewCol("Tipo", 0, 0, nStyleCabec, Nil)   
	oExcel:NewCol("Saldo", 0, 0, nStyleCabec, Nil)
	oExcel:NewCol("Pedidos", 0, 0, nStyleCabec, Nil)
	GERCAB()
	for i:=1 to len(aForecast)
		oExcel:NewRow(Nil)
		oExcel:NewCol(aForecast[i][1], 0, 0, nStyleItens, Nil)
		oExcel:NewCol(posicione("SB1", 1, xFilial("SB1") + aForecast[i][1], "B1_DESC"), 0, 0, nStyleItens, Nil)
		oExcel:NewCol(posicione("SB1", 1, xFilial("SB1") + aForecast[i][1], "B1_TIPO"), 0, 0, nStyleItens, Nil)
		oExcel:NewCol(aForecast[i][2], 0, 0, nStyleItens, Nil)
		oExcel:NewCol(aForecast[i][3], 0, 0, nStyleItens, Nil)
		for j:=4 to 15
			oExcel:NewCol(aForecast[i][j], 0, 0, nStyleItens, Nil)
		next
	next
	//varre estrutura
	for i:=1 to len(aForecast)

		dbSelectArea("SG1")
		dbSetOrder(1)
		cProduto := PadR( aForecast[i][1], Len( SG1->G1_COD ) )
		aStruA := TSEstrut( cProduto,1,.F., .F. )
		
		For nLoop := 1 to Len( aStruA )
			if aStruA[nLoop,8] > dDataBase .and. aStruA[nLoop,4] > 0
			
				    aLinha[1] := aStruA[nLoop,2]
					aLinha[2] := aStruA[nLoop,3]
					aLinha[3] := iif(empty(aStruA[nLoop,7]), "STD", "OPC")
					for j:=4 to 15
						alinha[j] := aStruA[nLoop,4] * aForecast[i][j]
					next
					AADD(aCalculo, aclone(aLinha))				
			
		   endif 

		Next nLoop
		
	next i
	
	oExcel:NewWorkSheet("Estrutura de Produto")
	oExcel:NewRow(Nil)
	oExcel:NewCol("Produto", 0, 0, nStyleCabec, Nil)
	oExcel:NewCol("Componente", 0, 0, nStyleCabec, Nil) 
	oExcel:NewCol("Descr Comp", 0, 0, nStyleCabec, Nil)
	oExcel:NewCol("Tipo", 0, 0, nStyleCabec, Nil)  
	oExcel:NewCol("OPC/STD", 0, 0, nStyleCabec, Nil)
	GERCAB()
	for i:=1 to len(aCalculo)
		oExcel:NewRow(Nil)
		oExcel:NewCol(aCalculo[i][1], 0, 0, nStyleItens, Nil)		
		oExcel:NewCol(aCalculo[i][2], 0, 0, nStyleItens, Nil) 
		oExcel:NewCol(posicione("SB1", 1, xFilial("SB1") + aCalculo[i][2], "B1_DESC"), 0, 0, nStyleItens, Nil)
		oExcel:NewCol(posicione("SB1", 1, xFilial("SB1") + aCalculo[i][2], "B1_TIPO"), 0, 0, nStyleItens, Nil)
		oExcel:NewCol(aCalculo[i][3], 0, 0, nStyleItens, Nil)  	
		for j:=4 to 15
			oExcel:NewCol(aCalculo[i][j], 0, 0, nStyleItens, Nil)
		next
	next
	
	oExcel:NewWorkSheet("Estrutura Standard")
	oExcel:NewRow(Nil)
	oExcel:NewCol("Componente", 0, 0, nStyleCabec, Nil)
	oExcel:NewCol("Descr", 0, 0, nStyleCabec, Nil)
	oExcel:NewCol("Tipo", 0, 0, nStyleCabec, Nil)  
	GERCAB()
	for i:=1 to len(aCalculo)
		if aCalculo[i][3] = "STD"
			oExcel:NewRow(Nil)
			oExcel:NewCol(aCalculo[i][2], 0, 0, nStyleItens, Nil)
			oExcel:NewCol(posicione("SB1", 1, xFilial("SB1") + aCalculo[i][2], "B1_DESC"), 0, 0, nStyleItens, Nil)
	   		oExcel:NewCol(posicione("SB1", 1, xFilial("SB1") + aCalculo[i][2], "B1_TIPO"), 0, 0, nStyleItens, Nil)
			for j:=4 to 15
				oExcel:NewCol(aCalculo[i][j], 0, 0, nStyleItens, Nil)
			next
		endif
	next
	oExcel:NewWorkSheet("Estrutura Opcional")
	oExcel:NewRow(Nil)
	oExcel:NewCol("Comp Opcional", 0, 0, nStyleCabec, Nil) 
	oExcel:NewCol("Descr", 0, 0, nStyleCabec, Nil)
	oExcel:NewCol("Tipo", 0, 0, nStyleCabec, Nil)  
	GERCAB()
	for i:=1 to len(aCalculo)
		if aCalculo[i][3] = "OPC"
			oExcel:NewRow(Nil)
			oExcel:NewCol(aCalculo[i][2], 0, 0, nStyleItens, Nil) 
			oExcel:NewCol(posicione("SB1", 1, xFilial("SB1") + aCalculo[i][2], "B1_DESC"), 0, 0, nStyleItens, Nil)
	   		oExcel:NewCol(posicione("SB1", 1, xFilial("SB1") + aCalculo[i][2], "B1_TIPO"), 0, 0, nStyleItens, Nil)
			for j:=4 to 15
				oExcel:NewCol(aCalculo[i][j], 0, 0, nStyleItens, Nil)
			next
		endif
	next
	
	for y:=1 to 3
		do case
			case y=1
				oExcel:NewWorkSheet("Necessidade Total")
				cCalc := "ALL"
			case y=2
				oExcel:NewWorkSheet("Necessidade STD")
				cCalc := "OPC"
			case y=3
				oExcel:NewWorkSheet("Necessidade OPC")
				cCalc := "STD"
		endcase
		oExcel:NewRow(Nil)
		oExcel:NewCol("Componente", 0, 0, nStyleCabec, Nil)
		oExcel:NewCol("Descr", 0, 0, nStyleCabec, Nil)
		oExcel:NewCol("Tipo", 0, 0, nStyleCabec, Nil)  
		oExcel:NewCol("Saldo", 0, 0, nStyleCabec, Nil)
		oExcel:NewCol("Pedidos", 0, 0, nStyleCabec, Nil)
		GERCAB()
		RECEST()
		for i:=1 to len(aNecessidade)
			oExcel:NewRow(Nil)
			oExcel:NewCol(aNecessidade[i][2], 0, 0, nStyleItens, Nil)
			oExcel:NewCol(posicione("SB1", 1, xFilial("SB1") + aNecessidade[i][2], "B1_DESC"), 0, 0, nStyleItens, Nil)
	   		oExcel:NewCol(posicione("SB1", 1, xFilial("SB1") + aNecessidade[i][2], "B1_TIPO"), 0, 0, nStyleItens, Nil)  
			nPos_saldo := aScan(aSaldos, {|x| x[1] == aNecessidade[i][2]})
			iif(nPos_saldo > 0, oExcel:NewCol(aSaldos[nPos_saldo][2], 0, 0, nStyleItens, Nil),)   
			iif(nPos_saldo > 0, oExcel:NewCol(aSaldos[nPos_saldo][3], 0, 0, nStyleItens, Nil),)   
			for j:=4 to 15
				oExcel:NewCol(aNecessidade[i][j], 0, 0, nStyleItens, Nil)
			next
		next
	next
	oExcel:GeraXml()
	oExcel:OpenXml()
else
	msginfo("Não há itens a analisar.")
endif
dbclosearea()

return

//-----------------------------------------------------------------------------------------------------------------------------------------
//gera query e array com o forecast
static Function GERQRY()

cQuery := "SELECT Z6_PRODUTO, SALDO, PEDIDO, [01] AS M1, [02]AS M2, [03]AS M3, [04]AS M4, [05]AS M5, [06]AS M6,"
cQuery += " [07]AS M7, [08]AS M8, [09]AS M9, [10]AS M10, [11]AS M11, [12]AS M12 "
cQuery += " FROM (SELECT Z6_PRODUTO, Z6_PERIODO, Z6_QUANT FROM " + RETSQLNAME("SZ6") + " SZ6"
cQuery += " WHERE Z6_FILIAL = '" + xFilial("SZ6") + "' AND Z6_DOC = '" + alltrim(SZ5->Z5_DOC) + "' AND D_E_L_E_T_ = '') AS TMP1 "
cQuery += " PIVOT (SUM(Z6_QUANT) FOR Z6_PERIODO IN ([01],[02],[03],[04],[05],[06],[07],[08],[09],[10],[11],[12])) AS TMP2" 
cQuery += " LEFT OUTER JOIN (SELECT B2_COD, SUM(B2_QATU) AS SALDO, SUM(B2_SALPEDI) AS PEDIDO FROM " + RETSQLNAME("SB2") + " SB2 WHERE D_E_L_E_T_ = '' GROUP BY B2_COD) AS TMP3 ON Z6_PRODUTO = B2_COD ORDER BY 1"
cQuery := ChangeQuery(cQuery)
TCQUERY cQuery Alias QRY New
count to nQry
dbselectarea("QRY")
dbgotop()
while !eof()
	AADD(aForecast,{QRY->Z6_PRODUTO, QRY->SALDO, QRY->PEDIDO, iif(empty(QRY->M1),0,QRY->M1), iif(empty(QRY->M2),0,QRY->M2),	iif(empty(QRY->M3),0,QRY->M3), iif(empty(QRY->M4),0,QRY->M4), iif(empty(QRY->M5),0,QRY->M5), iif(empty(QRY->M6),0,QRY->M6),	iif(empty(QRY->M7),0,QRY->M7), iif(empty(QRY->M8),0,QRY->M8), iif(empty(QRY->M9),0,QRY->M9), iif(empty(QRY->M10),0,QRY->M10), iif(empty(QRY->M11),0,QRY->M11), iif(empty(QRY->M12),0,QRY->M12)})
	dbskip()
enddo
dbclosearea()     
SLDQRY()

return

static function SLDQRY()

cQuery := "SELECT B2_COD, SUM(B2_QATU) AS SALDO, SUM(B2_SALPEDI)AS PEDIDO FROM " + RETSQLNAME("SB2") + " SB2 WHERE D_E_L_E_T_ = '' GROUP BY B2_COD ORDER BY 1"
cQuery := ChangeQuery(cQuery)
TCQUERY cQuery Alias QRY New
dbselectarea("QRY")
dbgotop()
while !eof()
	AADD(aSaldos,{QRY->B2_COD, QRY->SALDO, QRY->PEDIDO})
	dbskip()
enddo
dbclosearea() 

return

//-----------------------------------------------------------------------------------------------------------------------------------------
//recalcula estrutura somando os produtos
static function RECEST()

aNecessidade := {}
for i:=1 to len(aCalculo)
	ZERLIN()
	if aScan(aNecessidade, {|x| x[2] == aCalculo[i][2]}) = 0
		for j:=1 to len(aCalculo)
			if aCalculo[i][2] = aCalculo[j][2] .AND. aCalculo[j][3] <> cCalc
				aLinha[2] := aCalculo[i][2]
				for k:=4 to 15
					alinha[k] := aLinha[k] + aCalculo[j][k]
				next				
			endif
		next
		iif(!empty(aLinha[2]),AADD(aNecessidade, aclone(aLinha)),)
	endif
next

return

//-----------------------------------------------------------------------------------------------------------------------------------------
//configura arquivo xml
static function GEREXC()

local cPlanilha := ""
local nColor := RGB(217,217,217)

//setar planilha
cPlanilha := GetPlanilha(cNome)
oExcel := TExcelXml():New(cPlanilha)
//NewStyle(nAligHoriz,nAligVert,nBorder,cFont,nSize,lBold,lItalic,lUnderline,nColor,nBkColor,cWrapText,cFormat)
nStyleCabec := oExcel:NewStyle(2, 2, 1, Nil, Nil, .T., Nil, Nil, Nil, nColor, Nil, Nil)
nStyleItens := oExcel:NewStyle(3, 2, 1, Nil, Nil, .F., Nil, Nil, Nil, Nil, Nil, Nil)
oExcel:SetProgressBar(.F.)

return

//-----------------------------------------------------------------------------------------------------------------------------------------
//gera cabeçalho das planilhas
static function GERCAB()

oExcel:NewCol("Jan", 0, 0, nStyleCabec, Nil)
oExcel:NewCol("Fev", 0, 0, nStyleCabec, Nil)
oExcel:NewCol("Mar", 0, 0, nStyleCabec, Nil)
oExcel:NewCol("Abr", 0, 0, nStyleCabec, Nil)
oExcel:NewCol("Mai", 0, 0, nStyleCabec, Nil)
oExcel:NewCol("Jun", 0, 0, nStyleCabec, Nil)
oExcel:NewCol("Jul", 0, 0, nStyleCabec, Nil)
oExcel:NewCol("Ago", 0, 0, nStyleCabec, Nil)
oExcel:NewCol("Set", 0, 0, nStyleCabec, Nil)
oExcel:NewCol("Out", 0, 0, nStyleCabec, Nil)
oExcel:NewCol("Nov", 0, 0, nStyleCabec, Nil)
oExcel:NewCol("Dez", 0, 0, nStyleCabec, Nil)

Return

//-----------------------------------------------------------------------------------------------------------------------------------------
//define a planilha
static function GetPlanilha(cNome)

local cPlanilha := FileNoExt(AllTrim(cNome)) + ".xls"
local cDir		:= AllTrim(GetTempPath(.T.))

if (Right(cDir, 1) <> "\")
	cDir += "\"
endif

if !(lIsDir(cDir))
	HS_MsgInf(OemToAnsi("Diretorio [" + AllTrim(cDir) + "] não existe, informe um diretorio valido"), "Atenção", "Destino")
	cDir       := ""
	cPlanlinha := ""
endif

return(cDir + cPlanilha)

static function FSRetChr(cString, cStrRet)

local cStrNew := ""
local nForStr := 0
local aStrRet := {{"<", "&lt;"}, {">", "&gt;"}}
local cStrPor := ""
local nPosStr := 0

cStrNew := cString
for nForStr := 1 to len(cStrRet)
	if (nPosStr := aScan(aStrRet, {| aVet | aVet[1] == subStr(cStrRet, nForStr, 1)})) > 0
		cStrPor := aStrRet[nPosStr][2]
	else
		cStrPor := ""
	endIf
	cStrNew := StrTran(cStrNew, subStr(cStrRet, nForStr, 1), cStrPor)
next

return(cStrNew)

//-----------------------------------------------------------------------------------------------------------------------------------------
//zera aLinha
static function ZERLIN()

aLinha[1] := ""
aLinha[2] := ""
//for r:=3 to 14
for r:=4 to 15
	aLinha[r] := 0
next

return   

//-----------------------------------------------------------------------------------------------------------------------------------------
//consulta por produto
user function CONS_PR()
      
local oDlg     
 
local bCancel	:= {|| oDlg:End()}         
local bOk		:= {|| EXICON()}
private nQuant_cons := 0 , cProd_cons := CriaVar("B1_COD", .T.)

cProd_cons := space(TAMSX3("Z6_PRODUTO")[1]) 
nQuant_cons := space(TAMSX3("Z6_QUANT")[1])
Define MsDialog oDlg From 0,0 to 250,500 Title "Consulta por produto" Pixel
@ 10,10 	Say "Produto" of oDlg Pixel  
@ 10,40		MsGet cProd_cons of oDlg F3 "SB1" Pixel Size 60,7
@ 30,10 	Say "Quantidade" of oDlg Pixel
@ 30,40 	MsGet nQuant_cons of oDlg Pixel Size 60,7
Activate MsDialog oDlg Centered on Init EnchoiceBar(oDlg,bOK,bCancel)

return


//-----------------------------------------------------------------------------------------------------------------------------------------
//gera consulta por produto no excel
static function EXICON()

	local cOPC, nSaldo_cons := 0, nPedido_cons := 0, nProdut := 0
	
	cNome := DToS(dDataBase) + "_" +"Consulta_Estrutura_" + alltrim(cProd_cons)	
	GEREXC()    	
	oExcel:NewWorkSheet("Estrutura " + alltrim(cProd_cons))      
	oExcel:NewRow(Nil)
	oExcel:NewCol("Componente", 0, 0, nStyleCabec, Nil) 
	oExcel:NewCol("Descr", 0, 0, nStyleCabec, Nil)
	oExcel:NewCol("Tipo", 0, 0, nStyleCabec, Nil)   
	oExcel:NewCol("STD/OPC", 0, 0, nStyleCabec, Nil)   
	oExcel:NewCol("Quantidade", 0, 0, nStyleCabec, Nil)
	oExcel:NewCol("Saldo", 0, 0, nStyleCabec, Nil)
	oExcel:NewCol("Pedidos", 0, 0, nStyleCabec, Nil)
	SLDQRY() 
	nProdut := aScan(aSaldos, {|t| t[1] == cProd_cons})   
	
	iif(nProdut > 0, nSaldo_cons := aSaldos[nProdut][2],)
	iif(nProdut > 0, nPedido_cons := aSaldos[nProdut][3],)
	
	nProdut := aScan(aSaldos, {|t| t[1] == cProd_cons})   
	iif(nProdut > 0, nSaldo_cons := aSaldos[nProdut][2],)
	iif(nProdut > 0, nPedido_cons := aSaldos[nProdut][3],)

	dbSelectArea("SG1")
	dbSetOrder(1)

	aStruA := TSEstrut( cProd_cons, val(nQuant_cons),.F., .F. )
		
	For nLoop := 1 to Len( aStruA )
		
		if aStruA[nLoop,8] > dDataBase .and. aStruA[nLoop,4] > 0

			nSaldo_cons := 0  
			nPedido_cons := 0		
			
			nProdut := aScan(aSaldos, {|t| t[1] == aStruA[nLoop,3]})   
			
			iif(nProdut > 0, nSaldo_cons := aSaldos[nProdut][2],)
			iif(nProdut > 0, nPedido_cons := aSaldos[nProdut][3],)
			
			cOPC := iif(empty(aStruA[nLoop,7]), "STD", "OPC")
			
			oExcel:NewRow(Nil)
			oExcel:NewCol(aStruA[nLoop,3], 0, 0, nStyleItens, Nil) 	
			oExcel:NewCol(posicione("SB1", 1, xFilial("SB1") + aStruA[nLoop,3], "B1_DESC"), 0, 0, nStyleItens, Nil)
			oExcel:NewCol(posicione("SB1", 1, xFilial("SB1") + aStruA[nLoop,3], "B1_TIPO"), 0, 0, nStyleItens, Nil) 		
			oExcel:NewCol(cOPC, 0, 0, nStyleItens, Nil) 	
			oExcel:NewCol(aStruA[nLoop,4], 0, 0, nStyleItens, Nil) 	
			oExcel:NewCol(nSaldo_cons, 0, 0, nStyleItens, Nil) 	
			oExcel:NewCol(nPedido_cons, 0, 0, nStyleItens, Nil)
						
	   endif 
	Next nLoop
			
    oExcel:GeraXml()
	oExcel:OpenXml()  
    
return

Static Function TSEstrut(cProduto,nQuant,lPreEstru)
LOCAL nRegi
LOCAL nQuantItem:=0
LOCAL cCodigo,cComponente,cTrt,cGrOpc,cOpc

nQuant:=IF(nQuant == NIL,1,nQuant)
nEstru++
If nEstru == 1 .or. Type("aEstrutura") <> "A"
	aEstrutura:={}
EndIf
dbSelectArea("SG1")
dbSetOrder(1)
dbSeek(xFilial()+cProduto)
While !Eof() .And. (SG1->G1_FILIAL+SG1->G1_COD) == xFilial()+cProduto

	nRegi	   :=Recno()
	
	cCodigo     := SG1->G1_COD
	cComponente := SG1->G1_COMP
	cTrt        := SG1->G1_TRT
	cGrOpc      := SG1->G1_GROPC
	cOpc        := SG1->G1_OPC
	dDtFim      := SG1->G1_FIM

	If cCodigo != cComponente
	
		nQuantItem:= TSExplEstr(nQuant,nil,nil,nil,nil,lPreEstru)
		AADD(aEstrutura,{nEstru,cCodigo,cComponente,nQuantItem,cTrt,cGrOpc,cOpc,dDtFim,Recno()})

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se existe sub-estrutura                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea('SG1')
		dbSeek(xFilial()+cComponente)
		IF Found()
			cCodigo:= SG1->G1_COD
			TSEstrut(cCodigo,nQuantItem,nil,.f.)
			nEstru --
		Endif
	EndIf
	dbGoto(nRegi)
	dbSkip()
Enddo
Return(aEstrutura)


//Explode Estrutura
Static Function TSExplEstr(nQuant,dDataStru,cOpcionais,cRevisao,nMotivo,lPreEstr,lTipoDec)

LOCAL nQuantItem:=0,cUnidMod,nG1Quant:=0,nQBase:=0,nDecimal:=0,nBack:=0
LOCAL aTamSX3:={}
LOCAL cAlias:=Alias(),nRecno:=Recno(),nOrder:=IndexOrd()
LOCAL lOk:=.T.
LOCAL nDecOrig:=Set(3,8)
LOCAL cCodigo
LOCAL cComponente
LOCAL cOpcArq
LOCAL dDataIni
LOCAL dDataFim
LOCAL nQtdCampo
LOCAL nQtdPerda
LOCAL cFixVar
LOCAL cTRT
LOCAL aVldEstr := {.T.,.T.,.T.} //na ordem, indica se valida datas, grupo de opc. e revisoes na estrutura
LOCAL aUsrVlEstr := {}
LOCAL nI := 0
LOCAL nAltPer := 0

DEFAULT nMotivo:=0
DEFAULT lPreEstr:=.F.
DEFAULT lTipoDec:=.T.

cCodigo    :=If(lPreEstr,SGG->GG_COD,SG1->G1_COD)
cComponente:=If(lPreEstr,SGG->GG_COMP,SG1->G1_COMP)
cOpcArq    :=If(lPreEstr,SGG->GG_GROPC+SGG->GG_OPC,SG1->G1_GROPC+SG1->G1_OPC)
dDataIni   :=If(lPreEstr,SGG->GG_INI,SG1->G1_INI)
dDataFim   :=If(lPreEstr,SGG->GG_FIM,SG1->G1_FIM)
nG1Quant   :=If(lPreEstr,SGG->GG_QUANT,SG1->G1_QUANT)
nQtdCampo  :=If(lPreEstr,SGG->GG_QUANT,SG1->G1_QUANT)
nQtdPerda  :=If(lPreEstr,SGG->GG_PERDA,SG1->G1_PERDA)
cFixVar    :=If(lPreEstr,SGG->GG_FIXVAR,SG1->G1_FIXVAR)
cTRT       :=If(lPreEstr,SGG->GG_TRT,SG1->G1_TRT)

If lPreEstr
	aTamSX3:=TamSX3("GG_QUANT")
Else
	aTamSX3:=TamSX3("G1_QUANT")
EndIf
nDecimal:=aTamSX3[2]

// Verifica os opcionais cadastrados na Estrutura
cOpcionais:= If((cOpcionais == NIL),"",cOpcionais)

// Verifica a Revisao Atual do Componente
cRevisao:= If((cRevisao == NIL),"",cRevisao)

// Verifica a data de validade
dDataStru := If((dDataStru == NIL),dDataBase,dDataStru)

If ExistBlock("USRVLESTR")
	aUsrVlEstr := ExecBlock("USRVLESTR",.F.,.F.,{cCodigo,cComponente,cTRT})
	For nI := 1 To 3
		If ValType(aUsrVlEstr[nI]) == "L"
			aVldEstr[nI] := aUsrVlEstr[nI]
		EndIf
	Next nI
EndIf

dbSelectArea("SB1")
dbSetOrder(1)
If dbSeek(xFilial("SB1")+cCodigo)
	If Empty(cOpcionais) .And. !Empty(SB1->B1_ZZOPC)
		cOpcionais := SB1->B1_ZZOPC
	EndIf
	If Empty(cRevisao) .And. !Empty(B1_REVATU)
		cRevisao:=B1_REVATU
	EndIf
	If aVldEstr[1] .And. !(dDataStru >= dDataIni .And. dDataStru <= dDataFim)
		nMotivo:=1 // Componente fora das datas inicio / fim
		lOk:=.F.
	EndIf
	If aVldEstr[2] .And. lOk .And. !Empty(cOpcionais) .And. !Empty(cOpcArq) .And. !(cOpcArq $ cOpcionais)
		nMotivo:=2  // Componente fora dos grupos de opcionais
		lOk:=.F.
	EndIf
	If aVldEstr[3] .And. lOk .And. !lPreEstr .And. !Empty(cRevisao) .And. (SG1->G1_REVINI > cRevisao .Or. SG1->G1_REVFIM < cRevisao)
		nMotivo:=3	// Componente fora das revisoes
		lOk:=.F.
	EndIf
EndIf

dbSelectArea(cAlias)
dbSetOrder(nOrder)
dbGoto(nRecno)

If lOk
	cUnidMod := GetMv("MV_UNIDMOD")
	SB1->(dbSeek(xFilial("SB1")+cCodigo))
	nQBase:=RetFldProd(SB1->B1_COD,If(lPreEstr.And.SB1->(FieldPos("B1_QBP"))>0,"B1_QBP","B1_QB"))

	SB1->(dbSeek(xFilial("SB1")+cComponente))
	If IsProdMod(cComponente)
		cTpHr := GetMv("MV_TPHR")
		If cTpHr == "N"
			nG1Quant := Int(nG1Quant)
			nG1Quant += ((nQtdCampo-nG1Quant)/60)*100
		EndIf
	EndIf
	
	If cFixVar $ " V"
		If IsProdMod(cComponente) .And. cUnidMOD != "H"
			nQuantItem := ((nQuant / nG1Quant) / (100 - nQtdPerda)) * 100
		Else
			nQuantItem := ((nQuant * nG1Quant) / (100 - nQtdPerda)) * 100
		EndIf
		nQuantItem := nQuantItem / Iif(nQBase <= 0,1,nQBase)
	Else
		If IsProdMod(cComponente) .And. cUnidMOD != "H"
			nQuantItem := (nG1Quant / (100 - nQtdPerda)) * 100
		Else
			nQuantItem := (nG1Quant / (100 - nQtdPerda)) * 100
		EndIf
	Endif
	nQuantItem:=Round(nQuantitem,nDecimal)
EndIf

Do Case
	Case (SB1->B1_TIPODEC == "A" .And. lTipoDec)
		nBack := Round( nQuantItem,0 )
	Case (SB1->B1_TIPODEC == "I" .And. lTipoDec)
		nBack := Int(nQuantItem)+If(((nQuantItem-Int(nQuantItem)) > 0),1,0)
	Case (SB1->B1_TIPODEC == "T" .And. lTipoDec)
		nBack := Int( nQuantItem )
	OtherWise
		nBack := nQuantItem
EndCase

Set(3,nDecOrig)

Return( nBack )