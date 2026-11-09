//Bibliotecas
#Include "Totvs.ch"
#Include "FWMVCDef.ch"

//Variveis Estaticas
Static cTitulo    := "OTIF"
Static cCamposChv := "C6_FILIAL   ;C6_NUM  ;"
Static cTabPai    := "SC6"

/*/{Protheus.doc} User Function OTIF
OTIF
@author Vinicius Santo
@since 11/10/2023
@version 1.0
@type function
@obs Codigo gerado automaticamente pelo Autumn Code Maker
@see http://autumncodemaker.com
/*/

User Function OTIF()
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
Menu de opcoes na funcao OTIF
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
	ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.OTIF" OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE "Incluir" ACTION "VIEWDEF.OTIF" OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE "Alterar" ACTION "VIEWDEF.OTIF" OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE "Excluir" ACTION "VIEWDEF.OTIF" OPERATION 5 ACCESS 0
	ADD OPTION aRotina TITLE "Copiar" ACTION "VIEWDEF.OTIF" OPERATION 9 ACCESS 0

Return aRotina

/*/{Protheus.doc} ModelDef
Modelo de dados na funcao OTIF
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
	oModel := MPFormModel():New("OTIFM", bPre, bPos, /*bCommit*/, bCancel)
	oModel:AddFields("SC6MASTER", /*cOwner*/, oStruPai)
	oModel:AddGrid("SC6DETAIL","SC6MASTER",oStruFilho,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)
	oModel:SetDescription("Modelo de dados - " + cTitulo)
	oModel:GetModel("SC6MASTER"):SetDescription( "Dados de - " + cTitulo)
	oModel:GetModel("SC6DETAIL"):SetDescription( "Grid de - " + cTitulo)
	oModel:SetPrimaryKey({})

	//Fazendo o relacionamento
	aAdd(aRelation, {"C6_FILIAL", "FWxFilial('SC6')"} )
	aAdd(aRelation, {"C6_NUM", "C6_NUM"})
	oModel:SetRelation("SC6DETAIL", aRelation, SC6->(IndexKey(1)))
	
	//Definindo campos unicos da linha
	oModel:GetModel("SC6DETAIL"):SetUniqueLine({'C6_ITEM'})

Return oModel

/*/{Protheus.doc} ViewDef
Visualizacao de dados na funcao OTIF
@author Vinicius Santo
@since 11/10/2023
@version 1.0
@type function
@obs Codigo gerado automaticamente pelo Autumn Code Maker
@see http://autumncodemaker.com
/*/

Static Function ViewDef()
	Local oModel     := FWLoadModel("OTIF")
	Local oStruPai   := FWFormStruct(2, cTabPai, {|cCampo| Alltrim(cCampo) $ cCamposChv})
	Local oStruFilho := FWFormStruct(2, cTabPai, {|cCampo| ! Alltrim(cCampo) $ cCamposChv})
	Local oView

	//Cria a visualizacao do cadastro
	oView := FWFormView():New()
	oView:SetModel(oModel)
	oView:AddField("VIEW_SC6", oStruPai, "SC6MASTER")
	oView:AddGrid("GRID_SC6",  oStruFilho,  "SC6DETAIL")

	//Partes da tela
	oView:CreateHorizontalBox("CABEC", 30)
	oView:CreateHorizontalBox("GRID", 70)
	oView:SetOwnerView("VIEW_SC6", "CABEC")
	oView:SetOwnerView("GRID_SC6", "GRID")

	//Titulos
	oView:EnableTitleView("VIEW_SC6", "Cabecalho - SC6")
	oView:EnableTitleView("GRID_SC6", "Grid - SC6")

Return oView
