#Include "Protheus.ch"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "FWMBROWSE.CH"


User Function MA010BUT()

Local aButtons := {} // botões a adicionar

AAdd(aButtons,{ 'OPc Parafix',{| |  U_TSSeleOpc() }, 'Seleciona OPc Parafix','SelOPc' } )

//AAdd(aButtons,{ 'Operações',{| | opera() }, 'Operações','Operações' } )

Return (aButtons)


// Seleciona Opcionais
User Function TSSeleOpc()

Local cAnt:=M->B1_OPC
Local cRet:=""
Local lOpcPadrao:= GetNewPar("MV_REPGOPC","N") == "N"
Private aRetorOpc:={}

If ! SeleOpc(1,"MATA010",SB1->B1_COD,Nil,@cRet)
	If lOpcPadrao	.Or. SB1->(FieldPos("B1_MOPC")) == 0
		M->B1_ZZOPC:=cAnt
	Else
		M->B1_MOPC:=cAnt
	EndIf
Else
	If lOpcPadrao .Or. SB1->(FieldPos("B1_MOPC"))	== 0 
		M->B1_ZZOPC:=cRet
	Else
		M->B1_MOPC:=cRet
	EndIf
EndIf
TSLimpOpc()
Return Nil

// Limpa Opcionais no Padrão
Static Function TSLimpOpc()

Local lLocCamp := SB1->(FieldPos("B1_MOPC")) > 0
Local lOpcPadrao:= GetNewPar("MV_REPGOPC","N") == "N"

If lOpcPadrao	
	M->B1_OPC:= " "
ElseIF !lOpcPadrao .And. lLocCamp
    	M->B1_MOPC:=" "
Else
		M->B1_OPC:= " "
EndIF

//Aviso(STR0032,STR0111,{STR0031},2)

Return Nil

/*
static Function opera()

Local lRet := {} 

lRet := FWExecView("Incluir", "MATA632",OP_INCLUIR , oDlg, bOk , nPercReducao, aEnableButtons, bCancel , cOperatId, cToolBar, ) 
Return lRet
*/
