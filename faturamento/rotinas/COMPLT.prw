#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'

/*/{Protheus.doc} COMPLT
Rotina de Cadastro de COMPLAINT
@type function
@author TOTVS
@since 02/05/2023
/*/

User Function COMPLT()
	Local oBrowse

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('ZCM')
	oBrowse:SetDescription("Cadastro de COMPLAINT")

	oBrowse:Activate()
Return

/*/{Protheus.doc} MenuDef
Rotina de Cadastro de COMPLAINT
@type function
@author TOTVS
@since 02/05/2023
/*/

Static Function MenuDef()
	Local aRotina	   := {}
	ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.COMPLT' OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.COMPLT' OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.COMPLT' OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.COMPLT' OPERATION 5 ACCESS 0

Return aRotina

/*/{Protheus.doc} ModelDef
Rotina de Cadastro de COMPLAINT
@type function
@author TOTVS
@since 02/05/2023
/*/

Static Function ModelDef()
	Local oStruZCMM := FWFormStruct( 1, 'ZCM', { |x| ALLTRIM(x) $ 'ZCM_RNC;ZCM_DATA;ZCM_STATUS;ZCM_DESC;ZCM_USER;ZCM_ARESP;ZCM_CODCLI;ZCM_LOJACL;ZCM_NOMECL;ZCM_SEGMEN;ZCM_RNCCLI;ZCM_PRZRET;ZCM_DATRET;ZCM_LEADTI;ZCM_DISPOS;ZCM_DATDEV;ZCM_PROCED;ZCM_MOTDEV;ZCM_CREDIT;ZCM_MATDEV;ZCM_DESCRE;ZCM_COMENT;ZCM_ACAO'} )
	Local oStruZCM :=  FWFormStruct( 1, 'ZCM', { |x| ALLTRIM(x) $ 'ZCM_PRODUT;ZCM_PRODES,ZCM_QUANT;ZCM_UM;ZCM_LOTE;ZCM_PRCUNI;ZCM_MOEDA;ZCM_VALOR;ZCM_NF;ZCM_RECURS;ZCM_NOMERE;ZCM_QTDDEV;ZCM_NFDEVO;ZCM_VLCRUZ' })
	Local oModel

	oModel := MPFormModel():New( 'COMPL1', /*bPreValidacao*/, /*{|oModel| JURC01Ok(oModel)}*/, /*bCommit*/, /*bCancel*/ )

	oModel:AddFields( 'ZCMMaster', /*cOwner*/, oStruZCMM )
	oModel:SetPrimaryKey({'ZCM_FILIAL','ZCM_RNC'})

	oModel:AddGrid( 'ZCMDetail', 'ZCMMaster', oStruZCM, /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )

	oModel:SetRelation( 'ZCMDetail', {{ 'ZCM_RNC', 'ZCM_RNC' }}, ZCM->( IndexKey( 1 ) ) )

	oModel:GetModel('ZCMDetail')//:SetUniqueLine({"ZCM_LOTE"})
Return oModel

/*/{Protheus.doc} ViewDef
Rotina de Cadastro de COMPLAINT
@type function
@author TOTVS
@since 02/05/2023
/*/

Static Function ViewDef()
	Local oStruZCMM := FWFormStruct( 2, 'ZCM', { |x| ALLTRIM(x) $ 'ZCM_RNC;ZCM_DATA;ZCM_STATUS;ZCM_DESC;ZCM_USER;ZCM_ARESP;ZCM_CODCLI;ZCM_LOJACL;ZCM_NOMECL;ZCM_SEGMEN;ZCM_RNCCLI;ZCM_PRZRET;ZCM_DATRET;ZCM_LEADTI;ZCM_DISPOS;ZCM_DATDEV;ZCM_PROCED;ZCM_MOTDEV;ZCM_CREDIT;ZCM_MATDEV;ZCM_DESCRE;ZCM_COMENT;ZCM_ACAO'} )
	Local oStruZCM  := FWFormStruct( 2, 'ZCM', { |x| ALLTRIM(x) $ 'ZCM_PRODUT;ZCM_PRODES,ZCM_QUANT;ZCM_UM;ZCM_LOTE;ZCM_PRCUNI;ZCM_MOEDA;ZCM_VALOR;ZCM_NF;ZCM_RECURS;ZCM_NOMERE;ZCM_QTDDEV;ZCM_NFDEVO;ZCM_VLCRUZ' })
	Local oModel   := FWLoadModel( 'COMPLT' )
	Local oView

	oView := FWFormView():New()

	oView:SetModel( oModel )

	oView:AddField( 'VIEW_ZCMM', oStruZCMM, 'ZCMMaster' )

	oView:AddGrid(  'VIEW_ZCM', oStruZCM, 'ZCMDetail' )

	oView:CreateHorizontalBox( 'SUPERIOR', 75 )
	oView:CreateHorizontalBox( 'INFERIOR', 25 )

	oView:SetOwnerView( 'VIEW_ZCMM', 'SUPERIOR' )
	oView:SetOwnerView( 'VIEW_ZCM', 'INFERIOR' )
Return oView

