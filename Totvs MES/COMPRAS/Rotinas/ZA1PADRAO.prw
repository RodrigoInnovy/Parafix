#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

/*/{Protheus.doc} ZA1PADRAO
Inicializador padrão
@author Evandro Simenes
@since 09/10/2017 
@version 1.0
/*/
User Function ZA1PADRAO(cCampo)
	Local oModel := FWModelActive()
	Local oView := FWViewActive()
	Local oStructV := oView:GetViewStruct("ZA1MASTER")
	Local oStructM := oModel:GetModelStruct("ZA1MASTER")
	Local oModelGrid := oModel:GetModel("ZA1DETAIL")
	Local nLinha := oModelGrid:GetLine()
	Local aArea := GetArea()
	
	oModel:SetValue("ZA1MASTER","ZA1_QTDT1",(ZA1->ZA1_QTD1UM))
	oModel:SetValue("ZA1MASTER","ZA1_QTDT2",(ZA1->ZA1_QTD2UM))
	oModel:SetValue("ZA1MASTER","ZA1_LOTEC",Alltrim(ZA1->ZA1_LOTE))
	
	oStructV:SetProperty('ZA1_LOTEC' , MVC_VIEW_CANCHANGE,.F.)
	oStructV:SetProperty('ZA1_QTDT1' , MVC_VIEW_CANCHANGE,.F.)
	oStructV:SetProperty('ZA1_QTDT2' , MVC_VIEW_CANCHANGE,.F.)
	
	DO CASE
		CASE cCampo == "CODPRO"
			Return oModel:GetValue("ZA1MASTER","ZA1_CODPRO")
		CASE cCampo == "IDLOTE"
			nSeq	:= GetMv("MV_ZZNXTID")
			PutMv("MV_ZZNXTID",(nSeq+1))
			Return Alltrim(strzero(nSeq,TamSX3("D3_LOTECTL")[1]))
			//Return "0"
		CASE cCampo == "UM"
			Return ZA1->ZA1_UM
		CASE cCampo == "2UM"
			Return ZA1->ZA1_2UM
	END CASE
	
	RestArea( aArea )
	
Return
