#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE 'TOPCONN.CH'

/*/{Protheus.doc} PRAFAT01
Consulta de Status Expedição
@author Evandro Simenes
@since 03/11/2017 
@version 1.0
/*/
User Function PRAFAT01()
	Local oBrowse
	
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('ZA2')
	//oBrowse:SetFilterDefault( "ZA2_STATUS=='3'" )
	oBrowse:SetDescription( 'Gestão de Expedição' )
	oBrowse:AddLegend( "ZA2_STATUS=='1'", "VIOLET"	, "Aguardando Separação" )
	oBrowse:AddLegend( "ZA2_STATUS=='2' .and. U_sldEmbZer(ZA2_FILIAL, ZA2_ORDSEP)", "BROWN" 	, "Aguardando Embalagem" )
	oBrowse:AddLegend( "ZA2_STATUS=='2' .and. !U_sldEmbZer(ZA2_FILIAL, ZA2_ORDSEP)", "PINK" 	, "Aguardando Nota Fiscal" )
	oBrowse:AddLegend( "ZA2_STATUS=='3'", "ORANGE" 	, "Aguardando Etiq. Volumes" )
	oBrowse:AddLegend( "ZA2_STATUS=='4'", "BLUE" 	, "Aguardando Embarque" )
	oBrowse:AddLegend( "ZA2_STATUS=='5'", "GREEN" 	, "Finalizado - Ok Embarcado" )
	oBrowse:Activate()

Return NIL

/*/{Protheus.doc} MenuDef
Definição Menu padrão
@author Evandro Simenes
@since 03/11/2017
@version 1.0
/*/
Static Function MenuDef()
	Local aRotina := {}
	
	ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.PRAFAT01' OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE "Alterar" ACTION "VIEWDEF.PRAFAT01" OPERATION 4 ACCESS 0 //vinicius
	
Return aRotina

/*/{Protheus.doc} ModelDef
Definição Modelo padrão
@author Evandro Simenes
@since 03/11/2017
@version 1.0
/*/
Static Function ModelDef()
	Local oStruZA2D := FWFormStruct( 1, 'ZA2')
	Local oModel := MPFormModel():New('ZA2MODEL', , , , ,  )
	
	oModel:AddFields( 'ZA2MASTER', /**/, oStruZA2D )
	oModel:setPrimaryKey({})
	
Return oModel

/*/{Protheus.doc} ViewDef
Definição da View padrão
@author Evandro Simenes
@since 03/11/2017
@version 1.0
/*/
Static Function ViewDef()

	Local oModel := ModelDef()
	Local oStruZA2 := FWFormStruct( 2, 'ZA2' )
	Local oView := FWFormView():New()
	
	oView:SetModel( oModel )
	oView:AddField( 'VIEW_ZA2',oStruZA2, 'ZA2MASTER' )
	oView:CreateVerticalBox( 'PAI', 100)
	oView:CreateHorizontalBox( 'INFERIOR' , 100, 'PAI' )
	oView:SetOwnerView( 'VIEW_ZA2', 'INFERIOR' )
	oView:SetCloseOnOk({||.T.})
	
Return oView

user function sldEmbZer(cFilAtual, cOrdem)
	
return Posicione("CB7",1,alltrim(cFilAtual)+alltrim(cOrdem),"CB7_STATUS") < "4"
