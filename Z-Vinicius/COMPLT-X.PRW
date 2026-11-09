//Fonte do Cadastro do Budget, rotina COMPLAINT
//Bibliotecas
#Include "Totvs.ch"
#Include "FWMVCDef.ch"

//Variveis Estaticas
Static cTitulo    := "Cadastro de COMPLAINT"
Static cCamposChv :=  "ZCM_RNC;ZCM_DATA;ZCM_STATUS;ZCM_DESC;ZCM_USER;ZCM_ARESP;ZCM_CODCLI;ZCM_LOJACL;ZCM_NOMECL;ZCM_SEGMEN;ZCM_RNCCLI;ZCM_PRZRET;ZCM_DATRET;ZCM_LEADTI;ZCM_DISPOS;ZCM_DATDEV;ZCM_PROCED;ZCM_MOTDEV;ZCM_CREDIT;ZCM_MATDEV;ZCM_DESCRE;ZCM_COMENT;ZCM_ACAO;"
Static cTabPai    := "ZCM"

/*/{Protheus.doc} User Function COMPLTAINT
Budget e Forecast Parafix
@author Vinicius Santo
@since 11/10/2023
@version 1.0
@type function
@obs Codigo gerado automaticamente pelo Autumn Code Maker
@see http://autumncodemaker.com
/*/

User Function COMPLT()
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
Menu de opcoes na funcao COMPLAINT
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
	ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.COMPLT" OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE "Incluir" ACTION "VIEWDEF.COMPLT" OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE "Alterar" ACTION "VIEWDEF.COMPLT" OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE "Excluir" ACTION "VIEWDEF.COMPLT" OPERATION 5 ACCESS 0
	ADD OPTION aRotina TITLE "Copiar" ACTION "VIEWDEF.COMPLT" OPERATION 9 ACCESS 0

Return aRotina

/*/{Protheus.doc} ModelDef
Modelo de dados na funcao COMPLAINT
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
	oModel := MPFormModel():New("COMPLTM", bPre, bPos, /*bCommit*/, bCancel)
	oModel:AddFields("ZCMMASTER", /*cOwner*/, oStruPai)
	oModel:AddGrid("ZCMDETAIL","ZCMMASTER",oStruFilho,/*bLinePre*/, /*bLinePost*/,/*bPre - Grid Inteiro*/,/*bPos - Grid Inteiro*/,/*bLoad - Carga do modelo manualmente*/)
	oModel:SetDescription(cTitulo)
	oModel:GetModel("ZCMMASTER"):SetDescription( "Dados de - " + cTitulo)
	oModel:GetModel("ZCMDETAIL"):SetDescription( "Grid de - " + cTitulo)
	oModel:SetPrimaryKey({})

	//Fazendo o relacionamento
	aAdd(aRelation, {"ZCM_FILIAL","FWxFilial('ZCM')"})
    aAdd(aRelation, {"ZCM_RNC","ZCM_RNC"})
    //aAdd(aRelation, {"ZCM_DATA","ZCM_DATA"})
    //aAdd(aRelation, {"ZCM_STATUS","ZCM_STATUS"})
    //aAdd(aRelation, {"ZCM_DESC","ZCM_DESC"})
    //aAdd(aRelation, {"ZCM_USER","ZCM_USER"})
    //aAdd(aRelation, {"ZCM_ARESP ","ZCM_ARESP "})
    //aAdd(aRelation, {"ZCM_CODCLI","ZCM_CODCLI"})
    //aAdd(aRelation, {"ZCM_LOJACL","ZCM_LOJACL"})
    //aAdd(aRelation, {"ZCM_NOMECL","ZCM_NOMECL"})
    //aAdd(aRelation, {"ZCM_SEGMEN","ZCM_SEGMEN"})
    //aAdd(aRelation, {"ZCM_RNCCLI","ZCM_RNCCLI"})
    //aAdd(aRelation, {"ZCM_PRZRET","ZCM_PRZRET"})
    //aAdd(aRelation, {"ZCM_DATRET","ZCM_DATRET"})
    //aAdd(aRelation, {"ZCM_LEADTI","ZCM_LEADTI"})
    //aAdd(aRelation, {"ZCM_DISPOS","ZCM_DISPOS"})
    //aAdd(aRelation, {"ZCM_DATDEV","ZCM_DATDEV"})
    //aAdd(aRelation, {"ZCM_PROCED","ZCM_PROCED"})
    //aAdd(aRelation, {"ZCM_MOTDEV","ZCM_MOTDEV"})
    //aAdd(aRelation, {"ZCM_CREDIT","ZCM_CREDIT"})
    //aAdd(aRelation, {"ZCM_MATDEV","ZCM_MATDEV"})
    //aAdd(aRelation, {"ZCM_DESCRE","ZCM_DESCRE"})
    //aAdd(aRelation, {"ZCM_COMENT","ZCM_COMENT"})
    //aAdd(aRelation, {"ZCM_ACAO","ZCM_ACAO"})
	oModel:SetRelation("ZCMDETAIL", aRelation, ZCM->(IndexKey(1)))
	
	//Definindo campos unicos da linha
	oModel:GetModel("ZCMDETAIL"):SetUniqueLine({'ZCM_LOTE'})

Return oModel

/*/{Protheus.doc} ViewDef
Visualizacao de dados na funcao COMPLTAINT
@author Vinicius Santo
@since 11/10/2023
@version 1.0
@type function
@obs Codigo gerado automaticamente pelo Autumn Code Maker
@see http://autumncodemaker.com
/*/

Static Function ViewDef()
	Local oModel     := FWLoadModel("COMPLT")
	Local oStruPai   := FWFormStruct(2, cTabPai, {|cCampo| Alltrim(cCampo) $ cCamposChv})
	Local oStruFilho := FWFormStruct(2, cTabPai, {|cCampo| ! Alltrim(cCampo) $ cCamposChv})
	Local oView

	//Cria a visualizacao do cadastro
	oView := FWFormView():New()
	oView:SetModel(oModel)
	oView:AddField("VIEW_ZCM", oStruPai, "ZCMMASTER")
	oView:AddGrid("GRID_ZCM",  oStruFilho,  "ZCMDETAIL")

	//Partes da tela
	oView:CreateHorizontalBox("CABEC", 75)
	oView:CreateHorizontalBox("GRID", 25)
	oView:SetOwnerView("VIEW_ZCM", "CABEC")
	oView:SetOwnerView("GRID_ZCM", "GRID")

	//Titulos
	oView:EnableTitleView("VIEW_ZCM", "Cabecalho")
	oView:EnableTitleView("GRID_ZCM", "Itens")

Return oView
