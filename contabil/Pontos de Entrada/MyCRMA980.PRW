
#INCLUDE "rwmake.ch"
#INCLUDE "Totvs.ch"

//-------------------------------------------------------------------
//Ponto entrada Rotina Cadastro de Cliente
//
//-------------------------------------------------------------------
User Function CRMA980()
 
Local aParam    := PARAMIXB[2]
Local lRet      := .T.

If aParam = "MODELCOMMITTTS" .AND. INCLUI //chama após inclusão de cadastros novo
	U_CTBINCFC("1") //Função que cria a conta contabil quando cadastra um cliente novo
EndIf
Return lRet
