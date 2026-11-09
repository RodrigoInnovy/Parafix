#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE 'TOPCONN.CH'

/*/{Protheus.doc} PRACOM01
Consulta de Status e Fracionamento de Lotes
@author Evandro Simenes
@since 04/10/2017 
@version 1.0
/*/
User Function PRACOM01()
	Local oBrowse
	
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias('ZA1')
	//oBrowse:SetFilterDefault( "ZA1_STATUS=='3'" )
	oBrowse:SetDescription( 'Controle de Recebimento' )
	oBrowse:AddLegend( "ZA1_STATUS=='1' .and. !U_stImport(ZA1_FILIAL, ZA1_NF, ZA1_SERIE, ZA1_CODFOR, ZA1_LOJA)", "VIOLET"	, "Aguardando Classificação Fiscal" )
	oBrowse:AddLegend( "ZA1_STATUS=='1' .and. U_stImport(ZA1_FILIAL, ZA1_NF, ZA1_SERIE, ZA1_CODFOR, ZA1_LOJA)", "BROWN" 	, "Aguardando Material Importado em Trânsito" )
	oBrowse:AddLegend( "ZA1_STATUS=='2'", "PINK" 	, "Aguardando Lib. C.Q" )
	oBrowse:AddLegend( "ZA1_STATUS=='3'", "ORANGE" 	, "Aguardando Fracionamento" )
	oBrowse:AddLegend( "ZA1_STATUS=='4'", "BLUE" 	, "Aguardando Conferencia Etiquetas" )
	oBrowse:AddLegend( "ZA1_STATUS=='5'", "GREEN" 	, "Finalizado - Ok p/ Endereçar" )
	oBrowse:Activate()

Return NIL

/*/{Protheus.doc} MenuDef
Definiï¿½ï¿½o Menu padrï¿½o
@author Evandro Simenes
@since 04/10/2017 
@version 1.0
/*/
Static Function MenuDef()
	Local aRotina := {}
	
	ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.PRACOM01' OPERATION 2 ACCESS 0
	//ADD OPTION aRotina TITLE 'Incluir' ACTION 'VIEWDEF.CADZA1' OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE 'Fracionar' ACTION 'VIEWDEF.PRACOM01' OPERATION 9 ACCESS 0
	ADD OPTION aRotina TITLE 'Reimprimir' ACTION 'U_ZA1REIMPR()' OPERATION 4 ACCESS 0
	//ADD OPTION aRotina TITLE 'Excluir' ACTION 'VIEWDEF.CADZA1' OPERATION 5 ACCESS 0
	//ADD OPTION aRotina TITLE 'Imprimir' ACTION 'VIEWDEF.CADZA1' OPERATION 8 ACCESS 0
	//ADD OPTION aRotina TITLE 'Copiar' ACTION 'VIEWDEF.CADZA1' OPERATION 9 ACCESS 0
	//ADD OPTION aRotina TITLE 'Reimprimir' ACTION 'U_REIMPRIMIR' OPERATION 2 ACCESS 0
	//ADD OPTION aRotina TITLE 'Fracionar' ACTION 'U_FRACIONAR' OPERATION 4 ACCESS 0

Return aRotina

/*/{Protheus.doc} ModelDef
Definiï¿½ï¿½o Modelo padrï¿½o
@author Evandro Simenes
@since 04/10/2017 
@version 1.0
/*/
Static Function ModelDef()

	// Cria a estrutura a ser acrescentada no Modelo de Dados
	Local oStruZA1 := FWFormStruct( 1, 'ZA1')
	Local oStruZA1D := FWFormStruct( 1, 'ZA1')
	// Inicia um novo Model 
	Local oModel := MPFormModel():New('ZA1MODEL', ,{ |oModel| VLDDADOS( oModel ) }  , { |oModel| UPDDATFIM( oModel ) },,  )
	
	//Desabilita campos que nao devem ser editados
	oStruZA1 := DisabFldC(oStruZA1)
	oStruZA1D:= DisabFldD(oStruZA1D)
	
	//Adiciona campos de saldo
	oStruZA1 := AdcModFldC(oStruZA1)
	
 	//Remove campos 
 	oStruZA1 := RemFldCM(oStruZA1)
 	oStruZA1D := RemFldDM(oStruZA1D)
 	
 	oModel:SetVldActivate({ |oModel| VERIFREG( oModel ) })
	// Adiciona a nova FORMFIELD
	oModel:AddFields( 'ZA1MASTER', /**/, oStruZA1 )
	
	oModel:AddGrid('ZA1DETAIL','ZA1MASTER',oStruZA1D)
	
	oModel:GetModel('ZA1DETAIL'):SetFldNoCopy({"ZA1_LOTE"})
	
	//oModel:GetModel('ZA1DETAIL'):SetLPost({ |oModelGrid| CalcQtd2(oModelGrid) })
	//oModel:GetModel('ZA1DETAIL'):SetLPre({ |oModelGrid, nLine, cAction, cField| CalcQtd2(oModelGrid, nLine, cAction, cField) })
	
	// Faz relacionamento entre os compomentes do model
	oModel:SetRelation( 'ZA1DETAIL', { 	{ 'ZA1_FILIAL'	, 'xFilial( "ZA1" )' 	},;
										{ 'ZA1_NF'		, 'ZA1_NF' 				},;
										{ 'ZA1_SERIE'	, 'ZA1_SERIE' 			},;
										{ 'ZA1_CODFOR'	, 'ZA1_CODFOR' 			},;
										{ 'ZA1_LOJA'	, 'ZA1_LOJA' 			},;
										{ 'ZA1_LOTE'	, 'ZA1->ZA1_LOTE' 		},;
										{ 'ZA1_CODPRO'	, 'ZA1_CODPRO'			},;
										{ 'ZA1_STATUS'	, 'ZA1->ZA1_STATUS' 	},;
										{ 'ZA1_ITEMNF'	, 'ZA1_ITEMNF'			};
										}, ZA1->( IndexKey( 6 ) ) )
	
	//Define a chave primaria utilizada pelo modelo
	oModel:SetPrimaryKey({})
	// Adiciona a descricao do novo componente
	oModel:GetModel( 'ZA1MASTER' ):SetDescription( 'Cabeï¿½alho' )
	oModel:GetModel( 'ZA1DETAIL' ):SetDescription( 'Detalhes' )
	
Return oModel

/*/{Protheus.doc} ViewDef
Definiï¿½ï¿½o da View padrï¿½o
@author Evandro Simenes
@since 04/10/2017 
@version 1.0
/*/
Static Function ViewDef()

	// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
	Local oModel := ModelDef()
	
	// Cria a estrutura a ser acrescentada na View
	Local oStruZA1 := FWFormStruct( 2, 'ZA1' )
	
	Local oStruZA1D := FWFormStruct( 2, 'ZA1' )
	
	// Inicia a View com uma View ja existente
	Local oView := FWFormView():New()
	
	// Altera o Modelo de dados quer serï¿½ utilizado
	oView:SetModel( oModel )
	
	//Adiciona campos de saldo
	oStruZA1 := AdicVwFldC(oStruZA1)
	
	//Desabilita campos na view
	oStruZA1 := DisabFldV(oStruZA1)
	oStruZA1D := DisabFldDV(oStruZA1D)
	
	//Remove campos 
 	oStruZA1 := RemFldCV(oStruZA1)
 	oStruZA1D := RemFldDV(oStruZA1D)
 	
 	//Altera Titulos
 	//oStruZA1:SetProperty( 'ZA1_QTD1UM' , MVC_VIEW_TITULO,'Qtd.Total 1 UM (M2)')
 	//oStruZA1:SetProperty( 'ZA1_QTD2UM' , MVC_VIEW_TITULO,'Qtd.Total 2 UM (KG)')
 	
 	oStruZA1D:SetProperty( 'ZA1_LOTE' , MVC_VIEW_TITULO,'ID/LOTE')
 	
 	// Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
	oView:AddField( 'VIEW_ZA1', oStruZA1, 'ZA1MASTER' )
	oView:AddGrid( 'VIEW_ZA1D',oStruZA1D, 'ZA1DETAIL' )
	
	// Define campos que terao Auto Incremento
 	oView:addIncrementField( 'VIEW_ZA1D', 'ZA1_ITEM' )
	
	// ï¿½ preciso criar sempre um box vertical dentro de um horizontal e vice-versa
	// como na VIEWZA1_MVC o box ï¿½ horizontal, cria-se um vertical primeiro
	// Box existente na interface original
	oView:CreateVerticalBox( 'PAI', 100)
	
	// Novos Boxes
	oView:CreateHorizontalBox( 'SUPERIOR' , 40, 'PAI' )
	oView:CreateHorizontalBox( 'INFERIOR' , 60, 'PAI' )
	
	// Relaciona o identificador (ID) da View com o "box" para exibicao
	oView:SetOwnerView( 'VIEW_ZA1', 'SUPERIOR' )
	oView:SetOwnerView( 'VIEW_ZA1D', 'INFERIOR' )
	
	//Forï¿½a o fechamento da janela na confirmaï¿½ï¿½o
	oView:SetCloseOnOk({||.T.})
	
	
	
Return oView

/*/{Protheus.doc} RemFldCV
Removedor dos campos que nï¿½o deverï¿½o constar no cabeï¿½alho da view
@author Evandro Simenes
@since 05/10/2017 
@version 1.0
/*/
static function RemFldCV(oStruct)
 	oStruct:RemoveField('ZA1_DTMOV')
 	oStruct:RemoveField('ZA1_HRMOV')
 	oStruct:RemoveField('ZA1_DTFIM')
 	oStruct:RemoveField('ZA1_HRFIM')
 	oStruct:RemoveField('ZA1_STATUS')
 	oStruct:RemoveField('ZA1_DESCST')
 	oStruct:RemoveField('ZA1_UM')
 	oStruct:RemoveField('ZA1_2UM')
 	oStruct:RemoveField('ZA1_QTD1UM')
 	oStruct:RemoveField('ZA1_QTD2UM')
 	oStruct:RemoveField('ZA1_LOTE')
 	oStruct:RemoveField('ZA1_ITEM')
return oStruct

/*/{Protheus.doc} RemFldCM
Removedor dos campos que nï¿½o deverï¿½o constar no cabeï¿½alho do model
@author Evandro Simenes
@since 05/10/2017 
@version 1.0
/*/
static function RemFldCM(oStruct)
 	oStruct:RemoveField('ZA1_QTD1UM')
 	oStruct:RemoveField('ZA1_QTD2UM')
 	oStruct:RemoveField('ZA1_LOTE')
 	oStruct:RemoveField('ZA1_ITEM')
return oStruct

/*/{Protheus.doc} RemFldDM
Removedor dos campos que nï¿½o deverï¿½o constar no detalhe do model
@author Evandro Simenes
@since 05/10/2017 
@version 1.0
/*/
static function RemFldDM(oStruct)
 	oStruct:RemoveField('ZA1_LOJA')
 	oStruct:RemoveField('ZA1_NF')
 	oStruct:RemoveField('ZA1_SERIE')
 	oStruct:RemoveField('ZA1_CODFOR')
 	oStruct:RemoveField('ZA1_NOMFOR')
 	oStruct:RemoveField('ZA1_DTMOV')
 	oStruct:RemoveField('ZA1_HRMOV')
 	oStruct:RemoveField('ZA1_DTFIM')
 	oStruct:RemoveField('ZA1_HRFIM')
 	oStruct:RemoveField('ZA1_STATUS')
 	oStruct:RemoveField('ZA1_DESCST')
 	oStruct:RemoveField('ZA1_DESCPR')
 	//oStruct:RemoveField('ZA1_ITEMNF')
return oStruct

/*/{Protheus.doc} RemFldDV
Removedor dos campos que nï¿½o deverï¿½o constar no detalhe da view
@author Evandro Simenes
@since 05/10/2017 
@version 1.0
/*/
static function RemFldDV(oStruct)
 	oStruct:RemoveField('ZA1_LOJA')
 	oStruct:RemoveField('ZA1_NF')
 	oStruct:RemoveField('ZA1_SERIE')
 	oStruct:RemoveField('ZA1_CODFOR')
 	oStruct:RemoveField('ZA1_NOMFOR')
 	oStruct:RemoveField('ZA1_DTMOV')
 	oStruct:RemoveField('ZA1_HRMOV')
 	oStruct:RemoveField('ZA1_DTFIM')
 	oStruct:RemoveField('ZA1_HRFIM')
 	oStruct:RemoveField('ZA1_STATUS')
 	oStruct:RemoveField('ZA1_DESCST')
 	oStruct:RemoveField('ZA1_DESCPR')
 	
return oStruct

/*/{Protheus.doc} DisabFldC
Desabilita campos do cabeï¿½alho que nï¿½o poderï¿½o ser alterados
@author Evandro Simenes
@since 09/10/2017 
@version 1.0
/*/
static function DisabFldC(oStruct)
    oStruct:SetProperty('ZA1_LOTE' , MODEL_FIELD_WHEN,{|| .F. })
 	oStruct:SetProperty("ZA1_NF"  , MODEL_FIELD_WHEN,{|| .F. })
 	oStruct:SetProperty("ZA1_LOJA"  , MODEL_FIELD_WHEN,{|| .F. })
 	oStruct:SetProperty("ZA1_SERIE"  , MODEL_FIELD_WHEN,{|| .F. })
 	oStruct:SetProperty("ZA1_CODFOR"  , MODEL_FIELD_WHEN,{|| .F. })
 	oStruct:SetProperty("ZA1_NOMFOR"  , MODEL_FIELD_WHEN,{|| .F. })
 	oStruct:SetProperty("ZA1_CODPRO"  , MODEL_FIELD_WHEN,{|| .F. })
 	oStruct:SetProperty("ZA1_DESCPR"  , MODEL_FIELD_WHEN,{|| .F. })
 	oStruct:SetProperty("ZA1_QTD1UM"  , MODEL_FIELD_WHEN,{|| .F. })
 	oStruct:SetProperty("ZA1_QTD2UM"  , MODEL_FIELD_WHEN,{|| .F. })
 	oStruct:SetProperty("ZA1_UM"  , MODEL_FIELD_WHEN,{|| .F. })
 	oStruct:SetProperty("ZA1_2UM"  , MODEL_FIELD_WHEN,{|| .F. })
 	
return oStruct

/*/{Protheus.doc} DisabFldD
Desabilita campos do detalhe que nï¿½o poderï¿½o ser alterados no model
@author Evandro Simenes
@since 09/10/2017 
@version 1.0
/*/
static function DisabFldD(oStruct)
	oStruct:SetProperty('ZA1_CODPRO' , MODEL_FIELD_WHEN,{|| .F. })
    oStruct:SetProperty("ZA1_UM"  , MODEL_FIELD_WHEN,{|| .F. })
 	oStruct:SetProperty("ZA1_2UM"  , MODEL_FIELD_WHEN,{|| .F. })
 	oStruct:SetProperty("ZA1_LOTE"  , MODEL_FIELD_WHEN,{|| .F. })
return oStruct

/*/{Protheus.doc} DisabFldDV
Desabilita campos do detalhe que nï¿½o poderï¿½o ser alterados na view
@author Evandro Simenes
@since 16/10/2017 
@version 1.0
/*/
static function DisabFldDV(oStruct)
	//oStruct:SetProperty('ZA1_QTD2UM' , MVC_VIEW_CANCHANGE,.F.)
return oStruct

/*/{Protheus.doc} DisabFldV
Desabilita campos do cabeï¿½alho que nï¿½o poderï¿½o ser alterados na view
@author Evandro Simenes
@since 16/10/2017 
@version 1.0
/*/
static function DisabFldV(oStruct)
	oStruct:SetProperty('ZA1_SALT1' , MVC_VIEW_CANCHANGE,.F.)
	oStruct:SetProperty('ZA1_SALT2' , MVC_VIEW_CANCHANGE,.F.)
return oStruct



/*/{Protheus.doc} AdcModFldC
Adiciona campos adicionais para visualizaï¿½ï¿½o de informaï¿½ï¿½es no cabeï¿½alho do model
@author Evandro Simenes
@since 09/10/2017 
@version 1.0
/*/
static function AdcModFldC(oStruct)
	
	//Lote Original
	oStruct:AddField(	"Lote" 								,;   //<Titulo > 
		 				"Lote" 									,;	 //<cTooltip > 
		 				"ZA1_LOTEC" 					 								,;	 //<cIdField > 
		 				"C" 							 							   ,;	 //<cTipo > 
		 				 TamSX3("D3_LOTECTL")[1]								 								,;	 //<nTamanho > 
		 				 0								 								,;	 //[nDecimal ] 
		 				 nil							 								,;	 //[bValid ] 
		 				 {|| .T. }		 								,;	 //[bWhen ] 
		 				 nil						 								,;	 //[aValues ] 
		 				 nil							 								,;	 //[lObrigat ] 
		 				 FwBuildFeature( STRUCT_FEATURE_INIPAD, "0"),; //Posicione("ZA1",4,cChave, "ZA1_LOTE") ) ,;	 //[bInit ] 
		 				 nil															,;  //<lKey > 
		 				 nil															,;  //[lNoUpd ] 
		 				 .t.															,;  //[lVirtual] 
		 				 nil															,;  //[cValid ]
	 				   )
	//Qtd1 Original
 	oStruct:AddField(	"Qtd 1 UM ("+Alltrim(ZA1->ZA1_QTD1UM)+")" 								,;   //<Titulo > 
		 				"Qtd 1 UM ("+Alltrim(ZA1->ZA1_QTD1UM)+")" 									,;	 //<cTooltip > 
		 				"ZA1_QTDT1" 					 								,;	 //<cIdField > 
		 				"N" 							 							   ,;	 //<cTipo > 
		 				 TamSX3("D1_QUANT")[1]								 								,;	 //<nTamanho > 
		 				 TamSX3("D1_QUANT")[2]								 								,;	 //[nDecimal ] 
		 				 nil							 								,;	 //[bValid ] 
		 				 {|| .T. }		 								,;	 //[bWhen ] 
		 				 nil						 								,;	 //[aValues ] 
		 				 nil							 								,;	 //[lObrigat ] 
		 				 FwBuildFeature( STRUCT_FEATURE_INIPAD, "0"),; //str(Posicione("ZA1",4,cChave, "ZA1_QTD1UM")) ) ,;	 //[bInit ] 
		 				 nil															,;  //<lKey > 
		 				 nil															,;  //[lNoUpd ] 
		 				 .t.															,;  //[lVirtual] 
		 				 nil															,;  //[cValid ]
	 				   )
	//Qtd2 Original
 	oStruct:AddField(	"Qtd 2 UM ("+Alltrim(ZA1->ZA1_QTD2UM)+")" 								,;   //<Titulo > 
		 				"Qtd 2 UM ("+Alltrim(ZA1->ZA1_QTD2UM)+")" 									,;	 //<cTooltip > 
		 				"ZA1_QTDT2" 					 								,;	 //<cIdField > 
		 				"N" 							 							   ,;	 //<cTipo > 
		 				 TamSX3("D1_QUANT")[1]								 								,;	 //<nTamanho > 
		 				 TamSX3("D1_QUANT")[2]								 								,;	 //[nDecimal ] 
		 				 nil							 								,;	 //[bValid ] 
		 				 {|| .T. }		 								,;	 //[bWhen ] 
		 				 nil						 								,;	 //[aValues ] 
		 				 nil							 								,;	 //[lObrigat ] 
		 				 FwBuildFeature( STRUCT_FEATURE_INIPAD, "0"),; //str(Posicione("ZA1",4,cChave, "ZA1_QTD2UM")) ) ,;	 //[bInit ] 
		 				 nil															,;  //<lKey > 
		 				 nil															,;  //[lNoUpd ] 
		 				 .t.															,;  //[lVirtual] 
		 				 nil															,;  //[cValid ]
	 				   )
	 //Saldo 1 Restante da manutenï¿½ï¿½o
 	oStruct:AddField(	"Saldo 1 UM ("+Alltrim(ZA1->ZA1_UM)+")" 								,;   //<Titulo > 
		 				"Saldo 1 UM ("+Alltrim(ZA1->ZA1_UM)+")" 									,;	 //<cTooltip > 
		 				"ZA1_SALT1" 					 								,;	 //<cIdField > 
		 				"N" 							 							   ,;	 //<cTipo > 
		 				 TamSX3("D1_QUANT")[1]								 								,;	 //<nTamanho > 
		 				 TamSX3("D1_QUANT")[2]								 								,;	 //[nDecimal ] 
		 				 nil							 								,;	 //[bValid ] 
		 				 {|| .T. }		 								,;	 //[bWhen ] 
		 				 nil						 								,;	 //[aValues ] 
		 				 nil							 								,;	 //[lObrigat ] 
		 				 FwBuildFeature( STRUCT_FEATURE_INIPAD, "0" ) ,;	 //[bInit ] 
		 				 nil															,;  //<lKey > 
		 				 nil															,;  //[lNoUpd ] 
		 				 .t.															,;  //[lVirtual] 
		 				 nil															,;  //[cValid ]
	 				   )
	 //Saldo 2 restante da manutenï¿½ï¿½o
 	oStruct:AddField(	"Saldo 2 UM ("+Alltrim(ZA1->ZA1_2UM)+")" 								,;   //<Titulo > 
		 				"Saldo 2 UM ("+Alltrim(ZA1->ZA1_2UM)+")" 									,;	 //<cTooltip > 
		 				"ZA1_SALT2" 					 								,;	 //<cIdField > 
		 				"N" 							 							   ,;	 //<cTipo > 
		 				 TamSX3("D1_QUANT")[1]								 								,;	 //<nTamanho > 
		 				 TamSX3("D1_QUANT")[2]								 								,;	 //[nDecimal ] 
		 				 nil							 								,;	 //[bValid ] 
		 				 {|| .T. }		 								,;	 //[bWhen ] 
		 				 nil						 								,;	 //[aValues ] 
		 				 nil							 								,;	 //[lObrigat ] 
		 				 FwBuildFeature( STRUCT_FEATURE_INIPAD, "0" ) ,;	 //[bInit ] 
		 				 nil															,;  //<lKey > 
		 				 nil															,;  //[lNoUpd ] 
		 				 .t.															,;  //[lVirtual] 
		 				 nil															,;  //[cValid ]
	 				   )	
	 	 				   	 				   
Return oStruct

/*/{Protheus.doc} AdicVwFldC
Adiciona campos adicionais para visualizaï¿½ï¿½o de informaï¿½ï¿½es no cabeï¿½alho da view
@author Evandro Simenes
@since 09/10/2017 
@version 1.0
/*/
static function AdicVwFldC(oStruct)
	//Lote Original
	oStruct:AddField("ZA1_LOTEC"					,;//<cIdField > 
	  					"902"									,;//<cOrdem >
	  					"Lote"				,;//<cTitulo > 
	  					"Lote"				,;//<cDescric > 
	  					nil									,;//<aHelp > 
	  					"C"									,;//<cType > 
	  					nil								,;//<cPicture > 
	  					nil									,;//<bPictVar > 
	  					nil									,;//<cLookUp > 
	  					nil									,;//<lCanChange > 
	  					nil							,;//<cFolder > 
	  					nil							,;//<cGroup > 
	  					nil							,;//[ aComboValues ] 
	  					nil									,;//[ nMaxLenCombo ] 
	  					nil									,;//<cIniBrow > 
	  					.T.									,;//<lVirtual > 
	  					nil									,;//<cPictVar > 
	  					nil									,;//[ lInsertLine ] 
	  					nil									,;//[ nWidth ]
	  				)
	  //Qtd 1 Original
	oStruct:AddField("ZA1_QTDT1"					,;//<cIdField > 
	  					"903"									,;//<cOrdem >
	  					"Qtd 1 UM ("+Alltrim(ZA1->ZA1_UM)+")"				,;//<cTitulo > 
	  					"Qtd 1 UM ("+Alltrim(ZA1->ZA1_UM)+")"				,;//<cDescric > 
	  					nil									,;//<aHelp > 
	  					"N"									,;//<cType > 
	  					pesqpict("SD1","D1_QUANT")								,;//<cPicture > 
	  					nil									,;//<bPictVar > 
	  					nil									,;//<cLookUp > 
	  					nil									,;//<lCanChange > 
	  					nil							,;//<cFolder > 
	  					nil							,;//<cGroup > 
	  					nil							,;//[ aComboValues ] 
	  					nil									,;//[ nMaxLenCombo ] 
	  					nil									,;//<cIniBrow > 
	  					.T.									,;//<lVirtual > 
	  					nil									,;//<cPictVar > 
	  					nil									,;//[ lInsertLine ] 
	  					nil									,;//[ nWidth ]
	  				)
	  //Qtd 2 Original
	oStruct:AddField("ZA1_QTDT2"					,;//<cIdField > 
	  					"904"									,;//<cOrdem >
	  					"Qtd 2 UM ("+Alltrim(ZA1->ZA1_2UM)+")"				,;//<cTitulo > 
	  					"Qtd 2 UM ("+Alltrim(ZA1->ZA1_2UM)+")"				,;//<cDescric > 
	  					nil									,;//<aHelp > 
	  					"N"									,;//<cType > 
	  					pesqpict("SD1","D1_QUANT")								,;//<cPicture > 
	  					nil									,;//<bPictVar > 
	  					nil									,;//<cLookUp > 
	  					nil									,;//<lCanChange > 
	  					nil							,;//<cFolder > 
	  					nil							,;//<cGroup > 
	  					nil							,;//[ aComboValues ] 
	  					nil									,;//[ nMaxLenCombo ] 
	  					nil									,;//<cIniBrow > 
	  					.T.									,;//<lVirtual > 
	  					nil									,;//<cPictVar > 
	  					nil									,;//[ lInsertLine ] 
	  					nil									,;//[ nWidth ]
	  				)
	  //Qtd saldo 1 
	oStruct:AddField("ZA1_SALT1"					,;//<cIdField > 
	  					"905"									,;//<cOrdem >
	  					"Saldo 1 UM ("+Alltrim(ZA1->ZA1_UM)+")"				,;//<cTitulo > 
	  					"Saldo 1 UM ("+Alltrim(ZA1->ZA1_UM)+")"				,;//<cDescric > 
	  					nil									,;//<aHelp > 
	  					"N"									,;//<cType > 
	  					pesqpict("SD1","D1_QUANT")								,;//<cPicture > 
	  					nil									,;//<bPictVar > 
	  					nil									,;//<cLookUp > 
	  					nil									,;//<lCanChange > 
	  					nil							,;//<cFolder > 
	  					nil							,;//<cGroup > 
	  					nil							,;//[ aComboValues ] 
	  					nil									,;//[ nMaxLenCombo ] 
	  					nil									,;//<cIniBrow > 
	  					.T.									,;//<lVirtual > 
	  					nil									,;//<cPictVar > 
	  					nil									,;//[ lInsertLine ] 
	  					nil									,;//[ nWidth ]
	  				)
	  //Qtd saldo 2
	oStruct:AddField("ZA1_SALT2"					,;//<cIdField > 
	  					"906"									,;//<cOrdem >
	  					"Saldo 2 UM ("+Alltrim(ZA1->ZA1_2UM)+")"				,;//<cTitulo > 
	  					"Saldo 2 UM ("+Alltrim(ZA1->ZA1_2UM)+")"				,;//<cDescric > 
	  					nil									,;//<aHelp > 
	  					"N"									,;//<cType > 
	  					pesqpict("SD1","D1_QUANT")								,;//<cPicture > 
	  					nil									,;//<bPictVar > 
	  					nil									,;//<cLookUp > 
	  					nil									,;//<lCanChange > 
	  					nil							,;//<cFolder > 
	  					nil							,;//<cGroup > 
	  					nil							,;//[ aComboValues ] 
	  					nil									,;//[ nMaxLenCombo ] 
	  					nil									,;//<cIniBrow > 
	  					.T.									,;//<lVirtual > 
	  					nil									,;//<cPictVar > 
	  					nil									,;//[ lInsertLine ] 
	  					nil									,;//[ nWidth ]
	  				)
	
return oStruct

/*/{Protheus.doc} VLDDADOS
Validaï¿½ï¿½o dos dados ao confirmar fracionamento
@author Evandro Simenes
@since 11/10/2017 
@version 1.0
/*/
static function VLDDADOS( oModel )
	Local oCtrlRec := ControleDeRecebimento():newControleDeRecebimento()
	Local aItens := {}
	Local oModel := FWModelActive()
	Local oModelGrid := oModel:GetModel( 'ZA1DETAIL' )
	Local nI := 0
	Local aSaveLines := FWSaveRows()
	Local nTotal := round(oModel:GetValue("ZA1MASTER","ZA1_QTDT1"),TamSX3("D1_QUANT")[2])
	Local nTotal2 := round(oModel:GetValue("ZA1MASTER","ZA1_QTDT2"),TamSX3("D1_QUANT")[2])
	Local nTotGrid := 0.00
	Local nTotGrid2 := 0.00
	Local cHrmov := Substr(Time(),1,5)
	Local dHoje := Date()
	Local nPctTol := SuperGetMv("MV_ZZPCTT",.F.,0)
	Local nValTol := round((oModel:GetValue("ZA1MASTER","ZA1_QTDT1") * nPctTol) / 100,TamSX3("D1_QUANT")[2])
	Local nValTol2 := round((oModel:GetValue("ZA1MASTER","ZA1_QTDT2") * nPctTol) / 100,TamSX3("D1_QUANT")[2])
	Local cLocaliO := SuperGetMv("MV_ZZLOCFR",.F.,"FRACIONAMENTO")
	Local cLocOrig := getLocal(cLocaliO)
	Local dValidO := getValid(oModel)
	Local dValidD := getValid2(oModel:GetValue("ZA1MASTER","ZA1_NF"),oModel:GetValue("ZA1MASTER","ZA1_SERIE"),oModel:GetValue("ZA1MASTER","ZA1_CODFOR"),oModel:GetValue("ZA1MASTER","ZA1_CODPRO"))
	
	//Soma as quantidades digitadas
	For nI := 1 To oModelGrid:Length()
		oModelGrid:GoLine( nI )
		if oModelGrid:IsDeleted( nI ) == .F.
			nTotGrid := round(round(nTotGrid,TamSX3("D1_QUANT")[2]) + round(oModelGrid:GetValue("ZA1_QTD1UM"),TamSX3("D1_QUANT")[2]),TamSX3("D1_QUANT")[2])
			nTotGrid2 := round(round(nTotGrid2,TamSX3("D1_QUANT")[2]) + round(oModelGrid:GetValue("ZA1_QTD2UM"),TamSX3("D1_QUANT")[2]),TamSX3("D1_QUANT")[2])
			
			Aadd(aItens, {oModel:GetValue("ZA1MASTER","ZA1_CODPRO"), ;
			              oModel:GetValue("ZA1MASTER","ZA1_DESCPR"), ;
			              oModel:GetValue("ZA1MASTER","ZA1_UM"), ;
			              cLocOrig, ;
			              cLocaliO, ;
			              oModel:GetValue("ZA1MASTER","ZA1_CODPRO"), ;
			              oModel:GetValue("ZA1MASTER","ZA1_DESCPR"), ;
			              oModel:GetValue("ZA1MASTER","ZA1_UM"), ;
			              cLocOrig, ;
			              cLocaliO, ;
			              oModel:GetValue("ZA1MASTER","ZA1_LOTEC"), ;
			              dValidO, ;
			              oModelGrid:GetValue("ZA1_QTD1UM"), ;
			              oModelGrid:GetValue("ZA1_QTD2UM"), ;
			              oModelGrid:GetValue("ZA1_LOTE"), ;
			              dValidD, ;
			              } )
		endif
	Next
	
	FWRestRows( aSaveLines )
	
	//Verifica se a quantidade total digitada1 ï¿½ maior a quantidade do lote original
	if nTotGrid > (nTotal)
		Help( ,, 'Help',, "Valor total1 digitado ("+Alltrim(str(nTotGrid))+") é maior que o valor total1 do Item + tolerancia ("+Alltrim(str((nTotal)))+")", 1, 0 )
		return .F.
	endif
	
	//Verifica se a quantidade total digitada1 ï¿½ menor a quantidade do lote original
	if nTotGrid < (nTotal - nValTol)
		Help( ,, 'Help',, "Valor total1 digitado ("+Alltrim(str(nTotGrid))+") é menor que o valor total1 do Item - tolerancia ("+Alltrim(str((nTotal - nValTol)))+")", 1, 0 )
		return .F.
	endif
	
	//Verifica se a quantidade total digitada2 ï¿½ maior a quantidade do lote original
	if nTotGrid2 > (nTotal2)
		Help( ,, 'Help',, "Valor total2 digitado ("+Alltrim(str(nTotGrid2))+") é maior que o valor total2 do Item + tolerancia ("+Alltrim(str((nTotal2)))+")", 1, 0 )
		return .F.
	endif
	
	//Verifica se a quantidade total digitada2 ï¿½ menor a quantidade do lote original
	if nTotGrid2 < (nTotal2 - nValTol2)
		Help( ,, 'Help',, "Valor total2 digitado ("+Alltrim(str(nTotGrid2))+") é menor que o valor total2 do Item - tolerancia ("+Alltrim(str((nTotal2 - nValTol2)))+")", 1, 0 )
		return .F.
	endif
	
	If Len(aItens) > 0
		If !oCtrlRec:incTransferencia(aItens)
			Help( ,, 'Help',, "Não foi possível efetuar a transferência do lote original para os lotes fracionados.", 1, 0 )
			return .F.
		EndIf
	EndIf
	
	oModel:SetValue("ZA1MASTER","ZA1_DTMOV",dHoje)
	oModel:SetValue("ZA1MASTER","ZA1_HRMOV",cHrmov)
	oModel:SetValue("ZA1MASTER","ZA1_STATUS","4")
	oModel:SetValue("ZA1MASTER","ZA1_DESCST","Aguardando Conferencia Etiquetas")
	
return .T.

/*/{Protheus.doc} UPDDATFIM
Atualizaï¿½ï¿½o da data fim do status do lote original no commit do fracionamento
@author Evandro Simenes
@since 11/10/2017 
@version 1.0
/*/
Static Function UPDDATFIM(oModel)
	Local oCtrlRec := ControleDeRecebimento():newControleDeRecebimento()
	Local oModelGrid := oModel:GetModel( 'ZA1DETAIL' )
	Local nI := 0
	
	FWFormCommit( oModel )
	
	oCtrlRec:setlPorItem(.T.)
	oCtrlRec:setcCodPro(oModel:GetValue("ZA1MASTER","ZA1_CODPRO"))
	oCtrlRec:setcNF(oModel:GetValue("ZA1MASTER","ZA1_NF"))
	oCtrlRec:setcSerie(oModel:GetValue("ZA1MASTER","ZA1_SERIE"))
	oCtrlRec:setcCodFor(oModel:GetValue("ZA1MASTER","ZA1_CODFOR"))
	oCtrlRec:setcLoja(oModel:GetValue("ZA1MASTER","ZA1_LOJA"))
	oCtrlRec:setcItemNF(oModel:GetValue("ZA1MASTER","ZA1_ITEMNF"))
	oCtrlRec:setcStatus("3")
	oCtrlRec:setdDtFim(Date())
	oCtrlRec:setcHrFim(Substr(Time(),1,5))
	oCtrlRec:setlPorLote(.T.)
	oCtrlRec:setcLote(oModel:GetValue("ZA1MASTER","ZA1_LOTEC"))
	oCtrlRec:AtualizaDataFim() 
	
	For nI := 1 To oModelGrid:Length()
		oModelGrid:GoLine( nI )
		if oModelGrid:IsDeleted( nI ) == .F.
			ZA1IMPR(oModelGrid:GetValue("ZA1_LOTE"), oModelGrid:GetValue("ZA1_QTD1UM"), oModelGrid:GetValue("ZA1_QTD2UM"), oModelGrid:GetValue("ZA1_ITEM"))
		endif
	Next
	
Return .T.

/*/{Protheus.doc} VERIFREG
Atualizaï¿½ï¿½o da data fim do status do lote original no commit do fracionamento
@author Evandro Simenes
@since 19/10/2017 
@version 1.0
/*/
Static Function VERIFREG(oModel)
	if ZA1->ZA1_STATUS <> '3'
		Help( ,, 'Help',, "Não é possível fracionar um lote que não está aguardando fracionamento", 1, 0 )
		return .F.
	else
		if !Empty(ZA1->ZA1_DTFIM)
			Help( ,, 'Help',, "Este lote já foi fracionado", 1, 0 )
			return .F.
		endif
	endif
Return .T.

Static Function ZA1IMPR(cLote, nQtd1, nQtd2, cItem)
	Local aArea := GetArea()
	Local oModel := FWModelActive()
	Local cDataHora := ""
	Local dDataVal := getValid2(oModel:GetValue("ZA1MASTER","ZA1_NF"),oModel:GetValue("ZA1MASTER","ZA1_SERIE"),oModel:GetValue("ZA1MASTER","ZA1_CODFOR"),oModel:GetValue("ZA1MASTER","ZA1_CODPRO"))
	Local cDataVal := DTOC(dDataVal)
	Local cCodBar := ""
	local cPrefixo1 := "%001" // Prï¿½-requisito PC-Factory
	local cPrefixo2 := "%010" // Prï¿½-requisito PC-Factory
	local cPrefixo3 := "%030" // Prï¿½-requisito PC-Factory
	Local cNFSerie := Alltrim(oModel:GetValue("ZA1MASTER","ZA1_NF")) + "/" + Alltrim(oModel:GetValue("ZA1MASTER","ZA1_SERIE"))
	Local cForLoja := Alltrim(oModel:GetValue("ZA1MASTER","ZA1_CODFOR")) + "/" + Alltrim(oModel:GetValue("ZA1MASTER","ZA1_LOJA"))
	
	cDataHora := dToC(ZA1->ZA1_DTMOV)+" "+ZA1->ZA1_HRMOV
	cCodBar		:= cPrefixo1+allTrim(ZA1->ZA1_CODPRO)+cPrefixo2+allTrim(cLote)+cPrefixo3+Alltrim(str(Round(nQtd1,6)))
	
	U_etqMPPI("MP",; 				//Tipo produto
	          ZA1->ZA1_CODPRO,; 	//Codigo Produto
	          ZA1->ZA1_DESCPR,; 	// Descricao Produto
	          cLote,; 		//Lote
	          cDataHora,; 			//Data Hora Mov
	          cDataVal,; 			// Data Validade
	          Transform(nQtd1,"@E 9,999,999.99"),;//Qtd 1 
	          ZA1->ZA1_UM,; 		//U.M. 1
	          Transform(nQtd2,"@E 9,999,999.99"),;// Qtd 2
	          ZA1->ZA1_2UM,; 		//U.M. 2
	          cCodBar,; 			// Codigo de Barras
	          1,;                      //Quantidade de Etiquetas
	          cNFSerie,;                 //NF/SERIE
	          cForLoja,;                 //CODFOR/LOJA
	          cItem) 					// ZA1_ITEM
	
	RestArea(aArea)
Return

Static Function getLocal(cLocaliz)
	Local cLocal := ""
	Local aArea := GetArea()
	Local cQry := ""
	
	cQry := "SELECT BE_LOCAL "
	cQry += "  FROM "+RetSqlName("SBE")
	cQry += " WHERE D_E_L_E_T_ <> '*'"
	cQry += "   AND BE_FILIAL = '"+xFilial("SBE")+"'"
	cQry += "   AND BE_LOCALIZ = '"+cLocaliz+"'"
	
	TcQuery cQry Alias TSBE New
	
	If TSBE->(!EOF())
		cLocal := TSBE->BE_LOCAL
	Else
		Help( ,, 'Help',, "Local Inexistente (SBE - MV_ZZLOCFR).", 1, 0 )
	Endif
	TSBE->(DbCloseArea())
	
	RestArea(aArea)
Return cLocal

Static Function getValid(oModel)
	Local dDataVal := ""
	Local aArea := GetArea()
	Local cQry := ""
	
	cQry := "SELECT D1_DTVALID "
	cQry += "  FROM "+RetSqlName("SD1")
	cQry += " WHERE D_E_L_E_T_ <> '*'"
	cQry += "   AND D1_FILIAL 	= '"+xFilial("SD1")+"'"
	cQry += "   AND D1_DOC 		= '"+oModel:GetValue("ZA1MASTER","ZA1_NF")+"'"
	cQry += "   AND D1_SERIE 	= '"+oModel:GetValue("ZA1MASTER","ZA1_SERIE")+"'"
	cQry += "   AND D1_FORNECE 	= '"+oModel:GetValue("ZA1MASTER","ZA1_CODFOR")+"'"
	cQry += "   AND D1_LOTECTL 	= '"+oModel:GetValue("ZA1MASTER","ZA1_LOTEC")+"'"
	cQry += "   AND D1_COD 		= '"+oModel:GetValue("ZA1MASTER","ZA1_CODPRO")+"'"
	
	TcQuery cQry Alias TSD1 New
	
	If TSD1->(!EOF())
		dDataVal := STOD(TSD1->D1_DTVALID)
	Else
		Help( ,, 'Help',, "Local Inexistente (SBE - MV_ZZLOCFR).", 1, 0 )
	Endif
	
	TSD1->(DbCloseArea())
	
	RestArea(aArea)
Return dDataVal

Static Function getValid2(cNF, cSerie, cCodFor, cCodPro)
	Local dDataVal := Date()
	Local dDataEmi := Date()
	Local aArea := GetArea()
	Local cQry := ""
	Local nPrValid
	
	cQry := "SELECT B1_PRVALID "
	cQry += "  FROM "+RetSqlName("SB1")
	cQry += " WHERE D_E_L_E_T_ <> '*'"
	cQry += "   AND B1_FILIAL 	= '"+xFilial("SB1")+"'"
	cQry += "   AND B1_COD = '"+cCodPro+"'"
	
	TcQuery cQry Alias TSB1 New
	
	If TSB1->(!EOF())
		nPrValid := TSB1->B1_PRVALID
	Else
		nPrValid := 0
	Endif
	
	TSB1->(DbCloseArea())
	
	cQry := "SELECT F1_RECBMTO "
	cQry += "  FROM "+RetSqlName("SF1")
	cQry += " WHERE D_E_L_E_T_ <> '*'"
	cQry += "   AND F1_FILIAL 	= '"+xFilial("SF1")+"'"
	cQry += "   AND F1_DOC 		= '"+cNF+"'"
	cQry += "   AND F1_SERIE 	= '"+cSerie+"'"
	cQry += "   AND F1_FORNECE 	= '"+cCodFor+"'"
	
	TcQuery cQry Alias TSF1 New
	
	If TSF1->(!EOF())
		dDataEmi := STOD(TSF1->F1_RECBMTO)
	Else
		Help( ,, 'Help',, "Data de Recebimento da NF não foi encontrada.", 1, 0 )
	Endif
	
	TSF1->(DbCloseArea())
	
	dDataVal := dDataEmi + nPrValid
	
	RestArea(aArea)
Return dDataVal

/*/{Protheus.doc} ViewDef
Definiï¿½ï¿½o da View padrï¿½o
@author Evandro Simenes
@since 03/11/2017
@version 1.0
/*/
user function stImport(cFilAtual, cNF, cSerie, cForn, cLoja)
	
return Posicione("SF1",1,alltrim(cFilAtual)+alltrim(cNF)+cSerie+cForn+cLoja,"F1_STATUS") == "C"
