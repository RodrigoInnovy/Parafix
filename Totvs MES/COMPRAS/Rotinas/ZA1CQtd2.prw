#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

/*/{Protheus.doc} ZA1CQtd2
Função de calculo da QTD2 da grid e do Saldo1 para ser utilizada via gatilho
@author Evandro Simenes
@since 16/10/2017 
@version 1.0
/*/
User Function ZA1CQtd2()
	Local oModel := FWModelActive()
	Local oModelGrid := oModel:GetModel( 'ZA1DETAIL' )
	Local aArea := GetArea()
	Local nVal1 := oModelGrid:GetValue("ZA1_QTD1UM")
	Local nVal2 := 0.00
	Local aSaveLines := FWSaveRows()
	Local nTotGrid := 0.00
	
	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))
	if (SB1->(DbSeek(xFilial("SB1")+oModelGrid:GetValue("ZA1_CODPRO"))))
		/*if SB1->B1_TIPCONV == "M"
			nVal2 := nVal1 * SB1->B1_CONV
		else
			nVal2 := nVal1 / SB1->B1_CONV
		endif*/
		
		nVal2 := ConvUm(SB1-> B1_COD, nVal1, 0, 2)
	
	else
		Help( ,, 'Help',, "Item não cadastrado", 1, 0 )
		Return 0
	endif
	
	For nI := 1 To oModelGrid:Length()
		oModelGrid:GoLine( nI )
		if oModelGrid:IsDeleted( nI ) == .F.
			nTotGrid := round(nTotGrid,TamSX3("D1_QUANT")[2]) + round(oModelGrid:GetValue("ZA1_QTD1UM"),TamSX3("D1_QUANT")[2])
		endif
	Next
	
	oModel:SetValue("ZA1MASTER","ZA1_SALT1",(round(oModel:GetValue("ZA1MASTER","ZA1_QTDT1"),TamSX3("D1_QUANT")[2]) - round(nTotGrid,TamSX3("D1_QUANT")[2])))
	
	FWRestRows( aSaveLines )
	RestArea(aArea)
Return nVal2
