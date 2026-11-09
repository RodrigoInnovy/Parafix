#include "Totvs.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} LIMPAOS
Rotina para limpar ordem de separação não faturada.
Exclusivo PARAFIX
@author João Gustavo Orsi
@since 09/03/2018
@version P12
/*/
//-------------------------------------------------------------------
user function LIMPAOS()

	Local cOs		:= ""
	Local aParambox := {}
	Local aRet     	:= {}
	
	// Criação de parambox
	aAdd(aParamBox,{1,"Ordem de Separação:",Space(6),"@!","","CB7","",60,.T.})
	
	// Executa apenas a primeira vez o parambox.
	If !ParamBox(aParamBox, "EXCLUI ORDEM DE SEPARAÇÃO", aRet)
		Return
	ElseIf !Empty(MV_PAR01)
		cOs := AllTrim(MV_PAR01)
		U_ExcOs(cOs)
	Endif
		
return

user function ExcOs(cOs)

	Local cAlias := GetNextAlias()

	BeginSql Alias cAlias
		SELECT *
		FROM %table:SD2% SD2
		WHERE D2_FILIAL = %xFilial:SD2%
			AND D2_ORDSEP = %Exp:cOs%
			AND SD2.%NotDel%
	EndSql
	(cAlias)->(dbGoTop())
	If (cAlias)->(!Eof())
		MsgAlert("Ordem de separação com nota fiscal gerada! Verifique!")
	Else
		dbSelectArea("CB9") // Itens lidos da ordem de separação
		CB9->(dbSetOrder(1))
		If CB9->(dbSeek(xFilial("CB9") + cOs))
			While CB9->CB9_ORDSEP == cOs
				cVolume := CB9->CB9_VOLUME
				dbSelectArea("CB6") // Volumes da ordem de separação
				CB6->(DbSetOrder(1))
				If CB6->(DbSeek(xFilial("CB6") + cVolume))
					RecLock("CB6",.F.)
					dbDelete()
					MsUnLock()
				EndIf
				RecLock("CB9",.F.)
				dbDelete()
				MsUnLock()
				CB9->(dbSkip())
			EndDo
		EndIf
		dbSelectArea("CB8") // Itens da ordem de separação
		CB8->(dbSetOrder(1))
		If CB8->(dbSeek(xFilial("CB8") + cOs))
			While CB8->CB8_ORDSEP == cOs
				RecLock("CB8",.F.)
				dbDelete()
				MsUnLock()
				CB8->(dbSkip())
			EndDo
		EndIf
		dbSelectArea("CB7") // Cabeçalho da ordem de separação
		CB7->(dbSetOrder(1))
		If CB7->(dbSeek(xFilial("CB7") + cOs))
			RecLock("CB7",.F.)
			dbDelete()
			MsUnLock()
		EndIf
		dbSelectArea("ZA2") // Controle expedição
		ZA2->(dbSetOrder(1))
		If ZA2->(dbSeek(xFilial("ZA2") + cOs))
			While ZA2->ZA2_ORDSEP == cOs
				RecLock("ZA2",.F.)
				dbDelete()
				MsUnLock()
				ZA2->(dbSkip())
			EndDo
		EndIf
	Aviso("OS EXCLUÍDA " + cOs,"Ordem de separação excluída com sucesso!",{"OK"})
	EndIf
	(cAlias)->(DbCloseArea())
	
return