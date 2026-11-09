// Tela customizada de cadastro de Visitas / tarefas Comercias tabela padrao AD5
#Include "TOTVS.ch"
#Include "FWMVCDEF.ch"

// FUNÇÃO PRINCIPAL
User Function VISITAS()
    Local oBrowse := FwLoadBrw("VISITAS")

    oBrowse:Activate()
Return (NIL)

// BROWSEDEF() SERÝ ÚTIL PARA FUTURAS HERANÇAS: FWLOADBRW(
Static Function BrowseDef()
    Local oBrowse := FwMBrowse():New()

    oBrowse:SetAlias("AD5")
    oBrowse:SetDescription("Cadastro de Visitas / Tarefas")

    //oBrowse:AddLegend("AD5_ZSTATU=='1'", "GREEN", "A Fazer")
    //oBrowse:AddLegend("AD5_ZSTATU=='2'", "RED" , "Finalizado")

   // DEFINE DE ONDE SERÝ RETIRADO O MENUDEF
   oBrowse:SetMenuDef("VISITAS")
Return (oBrowse)

// OPERAÇÕES DA ROTINA
Static Function MenuDef()
    // FUNÇÃO PARA CRIAR MENUDEF
    Local aRotina := FWMVCMenu("VISITAS")
Return (aRotina)

// REGRAS DE NEGÓCIO
Static Function ModelDef()
    // INSTANCIA O MODELO
    Local oModel := MPFormModel():New("COMP011M")

    // INSTANCIA O SUBMODELO
    Local oStruAD5 := FwFormStruct(1, "AD5")

    // DEFINE O SUBMODELO COMO FIELD
    oModel:AddFields("AD5MASTER", NIL, oStruAD5)

    // DESCRIÇÃO DO MODELO
    oModel:SetDescription("Visitas / Tarefas")

    // DESCRIÇÃO DO SUBMODELO
    oModel:GetModel("AD5MASTER"):SetDescription("Visitas / Tarefas")
Return (oModel)

// INTERFACE GRÝFICA
Static Function ViewDef()
    // INSTANCIA A VIEW
    Local oView := FwFormView():New()

    // INSTANCIA AS SUBVIEWS
    Local oStruAD5 := FwFormStruct(2, "AD5")

    // RECEBE O MODELO DE DADOS
    Local oModel := FwLoadModel("VISITAS")

    // INDICA O MODELO DA VIEW
    oView:SetModel(oModel)

    // CRIA ESTRUTURA VISUAL DE CAMPOS
    oView:AddField("VIEW_AD5", oStruAD5, "AD5MASTER")

    // CRIA BOX HORIZONTAL
    oView:CreateHorizontalBox("TELA" , 100)

    // RELACIONA OS BOX COM A ESTRUTURA VISUAL
    oView:SetOwnerView("VIEW_AD5", "TELA")
Return (oView)
