#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"
 
//-------------------------------------------------------------------
/*/{Protheus.doc} ZLP
Cadastro de LINHA DE PRODUTO
A tabela criada SÃO ZLP.
 
@Parafix
@since 01/02/2023
@version P12.1.33
/*/
//-------------------------------------------------------------------
User Function LINPRD()
 
    Local oBrowse
    
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("ZLP")
    oBrowse:SetDescription("Linha de Produto")
    oBrowse:Activate()
 
Return NIL
 
Static Function MenuDef()
Return FWMVCMenu("LINPRD")
 
Static Function ModelDef()
 
    Local oStruZZZ := FWFormStruct(1,"ZLP")
    Local oModel
    
    oModel := MPFormModel():New("CAD_ZLP")
    oModel:AddFields("ZLPMASTER", , oStruZZZ)
    oModel:SetPrimaryKey({"ZLP_FILIAL","ZZP_TIPO","ZLP_MODO","ZLP_COD"})
    oModel:SetDescription("Linha de Produto")
    oModel:GetModel("ZLPMASTER"):SetDescription("Linha de Produto")
 
Return (oModel)
           
Static Function ViewDef()
 
    Local oModel := FWLoadModel("LINPRD")
    Local oStruZZZ := FWFormStruct(2,"ZLP")
    Local oView
    
    oView := FWFormView():New()
    oView:SetModel(oModel)
    oView:AddField("VIEW_ZLP",oStruZZZ,"ZLPMASTER")
    oView:CreateHorizontalBox("TELA",100)
    oView:SetOwnerView("VIEW_ZLP","TELA")
 
Return oView

