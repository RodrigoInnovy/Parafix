#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"
 
//-------------------------------------------------------------------
/*/{Protheus.doc} ZA4SC5
Cadastro de MOTIVOS OTIF PARA O PEDIDO DE VENDA
A tabela criada é a ZA5.
 
@Parafix
@since 16/08/2024
@version P12.1.2310
/*/
//-------------------------------------------------------------------
User Function ZA5OTIF()
 
    Local oBrowse
    
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("ZA5")
    oBrowse:SetDescription("MOTIVO OTIF")
    oBrowse:Activate()
 
Return NIL
 
Static Function MenuDef()
Return FWMVCMenu("ZA5OTIF")
 
Static Function ModelDef()
 
    Local oStruZZZ := FWFormStruct(1,"ZA5")
    Local oModel
    
    oModel := MPFormModel():New("CAD_ZA5")
    oModel:AddFields("ZA5MASTER", , oStruZZZ)
    oModel:SetPrimaryKey({"ZA5_FILIAL","ZA5_CODIGO","ZA5_MOTIVO"})
    oModel:SetDescription("Customer Service")
    oModel:GetModel("ZA5MASTER"):SetDescription("Customer Service")
 
Return (oModel)
           
Static Function ViewDef()
 
    Local oModel := FWLoadModel("ZA5MASTER")
    Local oStruZZZ := FWFormStruct(2,"ZA5")
    Local oView
    
    oView := FWFormView():New()
    oView:SetModel(oModel)
    oView:AddField("VIEW_ZA5",oStruZZZ,"ZA5MASTER")
    oView:CreateHorizontalBox("TELA",100)
    oView:SetOwnerView("VIEW_ZA5","TELA")
 
Return oView

