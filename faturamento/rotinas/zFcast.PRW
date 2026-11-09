// Fonte do Cadastro do Forecast, rotina zFcat
//Bibliotecas
#Include "Totvs.ch"
#Include "FWMVCDef.ch"

//Variveis Estaticas
Static cTitulo    := "Cadastro de FORECAST"
Static cCamposChv := "ZFS_ANO   ;ZFS_CLIE  ;ZFS_LOJA  ;ZFS_NOME  ;ZFS_PRODUT;ZFS_DESCRI;ZFS_UM    ;ZFS_MOEDA ;"
Static cTabPai    := "ZFS"

/*/{Protheus.doc} User Function zFcast
Forecast Parafix
@author Vinicius Santo
@since 11/10/2023
@version 1.0
@type function
@obs Codigo gerado automaticamente pelo Autumn Code Maker
@see http://autumncodemaker.com
/*/

User Function zFcast()
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
Menu de opcoes na funcao zFcast
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
	ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.zFcast" OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE "Incluir" ACTION "VIEWDEF.zFcast" OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE "Alterar" ACTION "VIEWDEF.zFcast" OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE "Excluir" ACTION "VIEWDEF.zFcast" OPERATION 5 ACCESS 0
	ADD OPTION aRotina TITLE "Copiar" ACTION "VIEWDEF.zFcast" OPERATION 9 ACCESS 0

Return aRotina

/*/{Protheus.doc} ModelDef
Modelo de dados na funcao zFcast
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
	oModel := MPFormModel():New("zFcastM", bPre, bPos, /*bCommit*/, bCancel)
	oModel:AddFields("ZFSMASTER", /*cOwner*/, oStruPai)
	oModel:AddGrid("ZFSDETAIL","ZFSMASTER",oStruFilho,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)
	oModel:SetDescription(cTitulo)
	oModel:GetModel("ZFSMASTER"):SetDescription( "Dados de - " + cTitulo)
	oModel:GetModel("ZFSDETAIL"):SetDescription( "Grid de - " + cTitulo)
	oModel:SetPrimaryKey({})

	//Fazendo o relacionamento
	aAdd(aRelation, {"ZFS_FILIAL", "FWxFilial('ZFS')"} )
	aAdd(aRelation, {"ZFS_ANO", "ZFS_ANO"})
	aAdd(aRelation, {"ZFS_CLIE", "ZFS_CLIE"})
	aAdd(aRelation, {"ZFS_LOJA", "ZFS_LOJA"})
	aAdd(aRelation, {"ZFS_NOME", "ZFS_NOME"})
	aAdd(aRelation, {"ZFS_PRODUT", "ZFS_PRODUT"})
	aAdd(aRelation, {"ZFS_DESCRI", "ZFS_DESCRI"})
	aAdd(aRelation, {"ZFS_UM", "ZFS_UM"})
	aAdd(aRelation, {"ZFS_MOEDA", "ZFS_MOEDA"})
	oModel:SetRelation("ZFSDETAIL", aRelation, ZFS->(IndexKey(1)))
	
	//Definindo campos unicos da linha
	oModel:GetModel("ZFSDETAIL")//:SetUniqueLine({'ZFS_DATA'})

Return oModel

/*/{Protheus.doc} ViewDef
Visualizacao de dados na funcao zFcast
@author Vinicius Santo
@since 11/10/2023
@version 1.0
@type function
@obs Codigo gerado automaticamente pelo Autumn Code Maker
@see http://autumncodemaker.com
/*/

Static Function ViewDef()
	Local oModel     := FWLoadModel("zFcast")
	Local oStruPai   := FWFormStruct(2, cTabPai, {|cCampo| Alltrim(cCampo) $ cCamposChv})
	Local oStruFilho := FWFormStruct(2, cTabPai, {|cCampo| ! Alltrim(cCampo) $ cCamposChv})
	Local oView

	//Cria a visualizacao do cadastro
	oView := FWFormView():New()
	oView:SetModel(oModel)
	oView:AddField("VIEW_ZFS", oStruPai, "ZFSMASTER")
	oView:AddGrid("GRID_ZFS",  oStruFilho,  "ZFSDETAIL")

	//Partes da tela
	oView:CreateHorizontalBox("CABEC", 30)
	oView:CreateHorizontalBox("GRID", 70)
	oView:SetOwnerView("VIEW_ZFS", "CABEC")
	oView:SetOwnerView("GRID_ZFS", "GRID")

	//Titulos
	oView:EnableTitleView("VIEW_ZFS", "Cabecalho")
	oView:EnableTitleView("GRID_ZFS", "Itens")

Return oView
