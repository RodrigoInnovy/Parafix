#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} CADTMPPI
Cadastro de/para de TMs Totvs Mes x Protheus.
A tabela criada é a CB0.

@author João Gustavo Orsi
@since 13/02/2018
@version P12
/*/
//-------------------------------------------------------------------
User Function CADCB0()

	Local oBrowse
	
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("CB0")
	oBrowse:SetDescription("Cadastro De/Para TMs")
	oBrowse:Activate()

Return NIL

Static Function MenuDef()
Return FWMVCMenu("CADCB0")

Static Function ModelDef()

	Local oStruZZZ := FWFormStruct(1,"CB0")
	Local oModel
	
	oModel := MPFormModel():New("CAD_CB0")
	oModel:AddFields("CB0MASTER", , oStruZZZ)
	oModel:SetPrimaryKey({"CB0_FILIAL","CB0_CODETI"})
	oModel:SetDescription("Cadastro Etiquetas Endereços")
	oModel:GetModel("CB0MASTER"):SetDescription("Cadastro Etiquetas Endereços")

Return oModel
           
Static Function ViewDef()

	Local oModel := FWLoadModel("CADCB0")
	Local oStruZZZ := FWFormStruct(2,"CB0")
	Local oView
	
	oView := FWFormView():New()
	oView:SetModel(oModel)
	oView:AddField("VIEW_CB0",oStruZZZ,"CB0MASTER")
	oView:CreateHorizontalBox("TELA",100)
	oView:SetOwnerView("VIEW_CB0","TELA")

Return oView