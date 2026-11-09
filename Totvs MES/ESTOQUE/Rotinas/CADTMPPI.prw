#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} CADTMPPI
Cadastro de/para de TMs Totvs Mes x Protheus.
A tabela criada é a ZA3.

@author João Gustavo Orsi
@since 13/02/2018
@version P12
/*/
//-------------------------------------------------------------------
User Function CADTMPPI()

	Local oBrowse
	
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("ZA3")
	oBrowse:SetDescription("Cadastro De/Para TMs")
	oBrowse:Activate()

Return NIL

Static Function MenuDef()
Return FWMVCMenu("CADTMPPI")

Static Function ModelDef()

	Local oStruZZZ := FWFormStruct(1,"ZA3")
	Local oModel
	
	oModel := MPFormModel():New("CAD_DEPARA")
	oModel:AddFields("ZA3MASTER", , oStruZZZ)
	oModel:SetPrimaryKey({"ZA3_FILIAL","ZA3_TMPPI"})
	oModel:SetDescription("Cadastro De/Para TMs")
	oModel:GetModel("ZA3MASTER"):SetDescription("Cadastro De/Para TMs")

Return oModel
           
Static Function ViewDef()

	Local oModel := FWLoadModel("CADTMPPI")
	Local oStruZZZ := FWFormStruct(2,"ZA3")
	Local oView
	
	oView := FWFormView():New()
	oView:SetModel(oModel)
	oView:AddField("VIEW_ZA3",oStruZZZ,"ZA3MASTER")
	oView:CreateHorizontalBox("TELA",100)
	oView:SetOwnerView("VIEW_ZA3","TELA")

Return oView