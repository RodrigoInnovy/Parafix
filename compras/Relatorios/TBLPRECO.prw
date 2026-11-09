#Include 'Protheus.ch'
#Include 'TopConn.ch

/*--------------------------------------------------------------------------------|
| Relatório da tabela de preCo de fornecedor                                      |
|---------------------------------------------|-----------------------------------|                                                                                 |
|Desenvolvido para PARAFIX                    | Desenvolvedor: RENAN FREITAS      |
|---------------------------------------------|-----------------------------------*/

User Function TBLPRECO()
//Declarando objeto
	Local oReport
	Local cAlias := getNextAlias()
	Local cPerg := "TABPRECO" //chamando a pergunta da sx1
	
	Pergunte(cPerg, .t.) //.t. exibe parametros iniciais, .f. escondera os parametros 
		//oReport := RptStruc()
	 	OReport := RptStruc (cAlias) //declarando objeto na fuNCAO o RptStruc
	   oReport := RptStruc (cPerg) // DECALRANDO A PERGUNTA NA FUNCAO RPTSTRUC
	
	oReport:PrintDialog() //imprimir

Return

//imprimir query SQL
Static Function RPrint(oReport,cAlias)

	Local oSecao1 := oReport:Section(1) //variavel local declarando 1 seessao

	oSecao1:BeginQuery()

	BeginSQL Alias cAlias


	select 
        AIB_CODFOR,
		A2_NOME,
		AIB_LOJFOR,
		AIB_CODTAB,
		AIB_ITEM,
		AIB_CODPRO,
		B1_DESC,
		AIB_PRCCOM,
		AIB_ZZPRC2, 
		AIB_DATVIG
		
	FROM  %Table:AIB010% AIB010, %Table:SB1010% SB1010 , %Table:SA2010% SA2010
		
		WHERE	AIB_CODPRO = B1_COD AND 
				AIB_CODFOR = A2_COD AND
				AIB_LOJFOR = A2_LOJA AND
				AIB_CODFOR = %Exp:MV_PAR01% AND AIB_CODFOR = %Exp:MV_PAR02%
	EndSQL//fechando Query

oSecao1:EndQuery() 

oReport:SetMeter((cAlias)->(RecCount()))//(barra de contagem de dados ao imprimir dados)

oSecao1:Print() //imprimindo query

Return

//CHmando RptStruc

Static Function RptStruc(cAlias)

	Local cTitulo 	:= "TABELA DE PRECO X FORNECEDOR"
	Local cHelp 	:= "Este relatorio permite imprimir a tabela de preco de fornecedor"
	Local oReport
	Local oSection1

	//Instanciando a classe TReport:
	oReport := TReport():New('TBLPRECO',cTitulo, ,{|oReport|RPrint(oReport, cAlias)},cHelp)
	//oReport:SetLandscape(.T.)

	//tabelaAIB (TAB PREÇO)
	TRCell():New(oSection1,	"AIB_CODFOR",	cAlias,	"COD.FORNECEDOR")
	TRCell():New(oSection1,	"A2_NOME",		cAlias,	"NOME FOR.")
	TRCell():New(oSection1,	"AIB_LOJFOR",	cAlias,	"LOJA")
	TRCell():New(oSection1,	"AIB_CODTAB",	cAlias,	"TAB.PRECO")
	TRCell():New(oSection1,	"AIB_ITEM",		cAlias,	"ITEM" )
	TRCell():New(oSection1,	"AIB_CODPRO",	cAlias,	"PRODUTO")
	TRCell():New(oSection1,	"B1_DESC", 		cAlias, "DESCRI")
	TRCell():New(oSection1,	"AIB_PRCCOM",	cAlias,	"PRECO UNT.")
	TRcell():New(oSection1,	"AIB_ZZPRC2",	cAlias,	"PREC UNT.2")
	TRCell():New(oSection1,	"AIB_DATVIG",	cAlias,	"VIGENCIA")
	

//iniciando totalizador
	//oSection1:SetTotalInLine(.F.)

//totalizador
	//TRFunction():New(oSection1:Cell("AIB_PRCCOM") ," " ,"SUM",,,"@E 999,999,999.99",,.F.,.T.)
	//TRFunction():New(oSection1:Cell("AIB_ZZPRC2") ," " ,"SUM",,,"@E 999,999,999.99",,.F.,.T.)
	
Return (oReport)
