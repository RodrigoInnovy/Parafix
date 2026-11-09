//Fonte do Cadastro do Budget, rotina zBudget
//Bibliotecas
#Include "Totvs.ch"
#Include "FWMVCDef.ch"

//Variveis Estaticas
Static cTitulo    := "Cadastro de Budget e Forcast"
Static cCamposChv := "ZVS_ANO   ;ZVS_CLIE  ;ZVS_LOJA  ;ZVS_NOME  ;ZVS_PRODUT;ZVS_DESCRI;ZVS_UM    ;ZVS_MOEDA ;"
Static cTabPai    := "ZVS"

/*/{Protheus.doc} User Function zBudget
Budget e Forecast Parafix
@author Vinicius Santo
@since 11/10/2023
@version 1.0
@type function
@obs Codigo gerado automaticamente pelo Autumn Code Maker
@see http://autumncodemaker.com
/*/

User Function zBudget()
	Local aArea   := FWGetArea()
	Local oBrowse
	Private aRotina := {}

	//Definicao do menu
	aRotina := MenuDef()

	//Instanciando o browse
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias(cTabPai)
	oBrowse:SetDescription(cTitulo)
	oBrowse:DisableDetails()

	//Ativa a Browse
	oBrowse:Activate()

	FWRestArea(aArea)
Return Nil

/*/{Protheus.doc} MenuDef
Menu de opcoes na funcao zBudget
@author Vinicius Santo
@since 11/10/2023
@version 1.0
@type function
@obs Codigo gerado automaticamente pelo Autumn Code Maker
@see http://autumncodemaker.com
/*/

Static Function MenuDef()
	Local aRotina := {}

	//Adicionando opcoes do menu
	ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.zBudget" OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE "Incluir" ACTION "VIEWDEF.zBudget" OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE "Alterar" ACTION "VIEWDEF.zBudget" OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE "Excluir" ACTION "VIEWDEF.zBudget" OPERATION 5 ACCESS 0
	ADD OPTION aRotina TITLE "Copiar" ACTION "VIEWDEF.zBudget" OPERATION 9 ACCESS 0

Return aRotina

/*/{Protheus.doc} ModelDef
Modelo de dados na funcao zBudget
@author Vinicius Santo
@since 11/10/2023
@version 1.0
@type function
@obs Codigo gerado automaticamente pelo Autumn Code Maker
@see http://autumncodemaker.com
/*/

Static Function ModelDef()
	Local oStruPai   := FWFormStruct(1, cTabPai, {|cCampo| Alltrim(cCampo) $ cCamposChv})
	Local oStruFilho := FWFormStruct(1, cTabPai)
	Local aRelation := {}
	Local oModel
	Local bPre := Nil
	Local bPos := Nil
	Local bCancel := Nil


	//Cria o modelo de dados para cadastro
	oModel := MPFormModel():New("zBudgetM", bPre, bPos, /*bCommit*/, bCancel)
	oModel:AddFields("ZVSMASTER", /*cOwner*/, oStruPai)
	oModel:AddGrid("ZVSDETAIL","ZVSMASTER",oStruFilho,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)
	oModel:SetDescription(cTitulo)
	oModel:GetModel("ZVSMASTER"):SetDescription( "Dados de - " + cTitulo)
	oModel:GetModel("ZVSDETAIL"):SetDescription( "Grid de - " + cTitulo)
	oModel:SetPrimaryKey({})

	//Fazendo o relacionamento
	aAdd(aRelation, {"ZVS_FILIAL", "FWxFilial('ZVS')"} )
	aAdd(aRelation, {"ZVS_ANO", "ZVS_ANO"})
	aAdd(aRelation, {"ZVS_CLIE", "ZVS_CLIE"})
	aAdd(aRelation, {"ZVS_LOJA", "ZVS_LOJA"})
	aAdd(aRelation, {"ZVS_NOME", "ZVS_NOME"})
	aAdd(aRelation, {"ZVS_PRODUT", "ZVS_PRODUT"})
	aAdd(aRelation, {"ZVS_DESCRI", "ZVS_DESCRI"})
	aAdd(aRelation, {"ZVS_UM", "ZVS_UM"})
	aAdd(aRelation, {"ZVS_MOEDA", "ZVS_MOEDA"})
	oModel:SetRelation("ZVSDETAIL", aRelation, ZVS->(IndexKey(1)))
	
	//Definindo campos unicos da linha
	oModel:GetModel("ZVSDETAIL"):SetUniqueLine({'ZVS_DATA'})

Return oModel

/*/{Protheus.doc} ViewDef
Visualizacao de dados na funcao zBudget
@author Vinicius Santo
@since 11/10/2023
@version 1.0
@type function
@obs Codigo gerado automaticamente pelo Autumn Code Maker
@see http://autumncodemaker.com
/*/

Static Function ViewDef()
	Local oModel     := FWLoadModel("zBudget")
	Local oStruPai   := FWFormStruct(2, cTabPai, {|cCampo| Alltrim(cCampo) $ cCamposChv})
	Local oStruFilho := FWFormStruct(2, cTabPai, {|cCampo| ! Alltrim(cCampo) $ cCamposChv})
	Local oView

	//Cria a visualizacao do cadastro
	oView := FWFormView():New()
	oView:SetModel(oModel)
	oView:AddField("VIEW_ZVS", oStruPai, "ZVSMASTER")
	oView:AddGrid("GRID_ZVS",  oStruFilho,  "ZVSDETAIL")

	//Partes da tela
	oView:CreateHorizontalBox("CABEC", 30)
	oView:CreateHorizontalBox("GRID", 70)
	oView:SetOwnerView("VIEW_ZVS", "CABEC")
	oView:SetOwnerView("GRID_ZVS", "GRID")

	//Titulos
	oView:EnableTitleView("VIEW_ZVS", "Cabecalho")
	oView:EnableTitleView("GRID_ZVS", "Itens")

Return oView
