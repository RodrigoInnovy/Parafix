#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

/*/{Protheus.doc} ZA1SALT2
Função de calculo do Saldo2 para ser utilizada via gatilho
@author Evandro Simenes
@since 16/10/2017 
@version 1.0
/*/
User Function ZA1SALT2()
	Local oModel := FWModelActive()
	Local oModelGrid := oModel:GetModel( 'ZA1DETAIL' )
	Local aArea := GetArea()
	Local aSaveLines := FWSaveRows()
	Local nTotGrid2 := 0.00
	
	
	For nI := 1 To oModelGrid:Length()
		oModelGrid:GoLine( nI )
		if oModelGrid:IsDeleted( nI ) == .F.
			nTotGrid2 := round(nTotGrid2,TamSX3("D1_QUANT")[2]) + round(oModelGrid:GetValue("ZA1_QTD2UM"),TamSX3("D1_QUANT")[2])
		endif
	Next
	
	oModel:SetValue("ZA1MASTER","ZA1_SALT2",(round(oModel:GetValue("ZA1MASTER","ZA1_QTDT2"),TamSX3("D1_QUANT")[2]) - round(nTotGrid2,TamSX3("D1_QUANT")[2])))
	
	FWRestRows( aSaveLines )
	RestArea(aArea)
Return oModelGrid:GetValue("ZA1_QTD2UM")