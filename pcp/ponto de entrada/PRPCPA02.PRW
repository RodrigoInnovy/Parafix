#Include "Protheus.ch"

User Function PRPCPA02()
	Local cAlias := "SD3"
	
	Private cCadastro := "Apontamentos de Perda e Transferencias"
	Private aRotina := {	{"Pesquisar",		"AxPesqui" ,  			0,1},;
								{"Incluir",			"U_PRPCPA03()",		0,3},;
								{"Alterar",			"AxAltera",				0,4},;
								{"Excluir",			"AxExclui",				0,5}} 
								
	dbSelectArea(cAlias)
	dbGotop()
	
	mBrowse(6,1,22,105,cAlias)

Return()