#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

//.==============================================================.
//|               Microsiga Protheus - Totvs                     |
//|--------------------------------------------------------------|
//| Programa : A010TOK.PRW      | Autor: Felipe Campos           |
//|--------------------------------------------------------------|
//| Descricao: Ponto de Entrada para validação para inclusão ou  |
//|            alteração do Produto. No início das validações    |
//|            após a confirmação da inclusão ou alteração,      |
//|            antes da gravação do Produto; deve ser utilizado  |
//|            para validações adicionais para a INCLUSÃO ou     |
//|            ALTERAÇÃO do Produto.                             |
//|--------------------------------------------------------------|
//| Data criacao  : 19/04/2010  | Ultima alteracao:              |
//|--------------------------------------------------------------|
//|                                                              |
//.==============================================================.

User Function A010TOK()
	Local lRet := .T.
	Local cDesc := AllTrim(M->B1_DESC)
    Local aArea      := GetArea()
	Local aAreaB1   := SB1->(GetArea())
	Local cProduto  := M->B1_COD
	Local cQuery     := "Select B1_COD, B1_DESC from SB1010 where D_E_L_E_T_ = '' and B1_DESC = '"+cDesc+"' and B1_MSBLQL = '2' and B1_COD <> '"+cProduto+"'" 
	TcQuery cQuery New Alias "QRY"
	dbSelectArea("QRY")

	//------------------------------------------------------------------------------------//
	// Valida se já existe produto com a mesma descrição cadastrada - Vinicius //
	//------------------------------------------------------------------------------------//
 
	If !Empty(QRY->B1_COD)
		MsgAlert("O Produto "+QRY->B1_COD+"possui a mesma Descrição","Descrição Duplicada!")
	lRet := .F.
	EndIF

	QRY->(dbCloseArea()) //Fecha a área de trabalho

	RestArea(aAreaB1)
	RestArea(aArea)

	//------------------------------------------------------------------------------------//
	// Valida os campos peso bruto e peso liquido quando o tipo do produto for igual a PA //
	// Tratamento realizado conforme solicitacao do Sr. Adriano Lopes - Parafix 21/06/12  //
	//------------------------------------------------------------------------------------//
	if M->B1_TIPO == "PA" .and. M->B1_ZZSTATU == "1"
		if M->B1_PESO = 0 .or. M->B1_PESBRU = 0
			alert("Favor informar o Peso Bruto e Peso Liquido quando o produto for do tipo PA")
			lRet := .F.
			if M->B1_IMPORT == ""
				alert("Informar se o produto é importado Sim/Não")
				lRet := .F.
			endif
		endif
	endif
	
	//------------------------------------------------------------------------------------//
	// Valida aprovação de todos departamentos para Desbloquear o Produto //
	//------------------------------------------------------------------------------------//
	If (lRet)
		If (ExistBlock("PRCOME02"))
			lRet := ExecBlock("PRCOME02", .F., .F.)

			If !(lRet)
				Help("", 1, "B1_MSBLQL", , "Necessária aprovação de todos os departamentos.", 1, 0)
			Endif
		Endif
	Endif
Return(lRet)

