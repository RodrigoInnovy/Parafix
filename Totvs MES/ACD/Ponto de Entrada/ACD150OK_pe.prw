#Include "Totvs.ch"
#Include "prtopdef.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} ACD150OK
Ponto de entrada para bloquear o lote no endereço quando sair da 
produção de produtos acabados.
Parafix

@type	User Function
@author 	João Gustavo Orsi
@since 	06/12/2017
@version P12
/*/
//-------------------------------------------------------------------
User Function ACD150OK()

	Local aArea 		:= GetArea()	
	Local aVetor 		:= {}
	Local _cEndOrig	:= GetMv("ZZ_LOCBLQ")
	Local _cDoc		:= GETSXENUM("SDD","DD_DOC")
	Local nX			:= 0
	Local _cProduto	:= PadR(AllTrim(SB1->B1_COD),tamSX3("DD_PRODUTO")[1]," ")
	Local _cLoteCtl	:= PadR(AllTrim(cLoteDes),tamSX3("DD_LOTECTL")[1]," ")
	Local _nQuant		:= aLista[1,2]
	Local _nQt2UM		:= ConvUM(_cProduto,_nQuant,0,2)
	Local _cArmDes	:= cArmDes
	Local _cEndDes	:= PadR(AllTrim(cEndDes),tamSX3("DD_LOCALIZ")[1]," ")
	Private lMsHelpAuto := .T.
 	Private lMsErroAuto := .F.
 	Private lAutoErrNoFile := .T.
	Private nStart
	
	ConfirmSx8()
	If SB1->B1_TIPO == "PA" .And. cArmOri == "11" .And. AllTrim(cEndOri) == AllTrim(_cEndOrig)
		aVetor := {;
		{"DD_DOC"	, _cDoc, NIL},;
		{"DD_PRODUTO", _cProduto, NIL},;
		{"DD_LOCAL", _cArmDes, NIL},;    
		{"DD_LOTECTL", _cLoteCtl, NIL},;   
		{"DD_QUANT", _nQuant, NIL},;
		{"DD_QTSEGUM", _nQt2UM, NIL},;
		{"DD_LOCALIZ", _cEndDes, NIL},;
		{"DD_MOTIVO", "IN", NIL},;
		{"DD_OBSERVA", "BLOQUEADO PARA INSPECAO CQ", NIL}}                                         	
		MSExecAuto({|x, y| MATA275(x, y)},aVetor, 3)
		aLog := GetAutoGRLog()
		For nX := 1 TO Len(aLog)
  			FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","RETORNO ERRO MATA275: " + aLog[nX], 0, (nStart - Seconds()), {})
  		NEXT nX
 	EndIf
	RestArea(aArea)

Return
