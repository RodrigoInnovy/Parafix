#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"
 
//-------------------------------------------------------------------
/*/{Protheus.doc} ZA4SC5
Cadastro de CUSTUMER SERVICE PARA O PEDIDO DE VENDA
A tabela criada é a ZA4.
 
@Parafix
@since 22/06/2021
@version P12.1.25
/*/
//-------------------------------------------------------------------
User Function ZA4SRV()
 
    Local oBrowse
    
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("ZA4")
    oBrowse:SetDescription("Customer Service")
    oBrowse:Activate()
 
Return NIL
 
Static Function MenuDef()
Return FWMVCMenu("ZA4SRV")
 
Static Function ModelDef()
 
    Local oStruZZZ := FWFormStruct(1,"ZA4")
    Local oModel
    
    oModel := MPFormModel():New("CAD_ZA4")
    oModel:AddFields("ZA4MASTER", , oStruZZZ)
    oModel:SetPrimaryKey({"ZA4_FILIAL","ZA4_COD","ZA4_NOME"})
    oModel:SetDescription("Customer Service")
    oModel:GetModel("ZA4MASTER"):SetDescription("Customer Service")
 
Return (oModel)
           
Static Function ViewDef()
 
    Local oModel := FWLoadModel("ZA4SRV")
    Local oStruZZZ := FWFormStruct(2,"ZA4")
    Local oView
    
    oView := FWFormView():New()
    oView:SetModel(oModel)
    oView:AddField("VIEW_ZA4",oStruZZZ,"ZA4MASTER")
    oView:CreateHorizontalBox("TELA",100)
    oView:SetOwnerView("VIEW_ZA4","TELA")
 
Return oView

