#Include "Protheus.ch"
#Include "Ap5Mail.ch"

/*/{Protheus.doc} PRCOME01
Envio de e-mail com Status e Pendências do Produto
@type function
@author Parafix
@since 14/04/2022
/*/

User Function PRCOME01()
	Local aArea      := GetArea()
	Local aAreaSB1   := SB1->(GetArea())
	Local cProduto   := AllTrim(SB1->B1_COD) + " - " + AllTrim(SB1->B1_DESC)
	Local cTipo      := AllTrim(SB1->B1_TIPO)
	Local cUser      := AllTrim(SB1->B1_ZUSER)
	Local cCadastro  := SB1->B1_DATREF //dDataBase
	Local lStatus    := (SB1->B1_MSBLQL == "1")
	Local lDesenv    := (SB1->B1_ZDEV == "2")
	Local lCompras   := (SB1->B1_ZCOM == "2")
	Local lFiscal    := (SB1->B1_ZFIS == "2")
	Local lVendas    := (SB1->B1_ZVEN == "2")
	Local lQualidade := (SB1->B1_ZQUA == "2")
	Local lComex     := (SB1->B1_ZCMX == "2")
	Local lProcessos := (SB1->B1_ZPRO == "2")
	Local lPCP       := (SB1->B1_ZPCP == "2")
	Local cPara      := GetNewPar("MV_ZMANCAD", "")
	Local cAssunto   := "Cadastro de Produto Pendente: " + AllTrim(SB1->B1_COD)
	Local cHTML      := ""
	Local cDe        := GetMv("MV_RELFROM")
	Local cServer    := GetMv("MV_RELSERV")
	Local cAccount   := GetMv("MV_RELACNT")
	Local cPassword  := GetMv("MV_RELPSW")
	Local lAuth      := GetMv("MV_RELAUTH")
	Local lOk        := .F.
	Local lEnvia     := (lDesenv .Or. lCompras .Or. lFiscal .Or. lVendas .Or. lQualidade .Or. lComex .Or. lProcessos .Or. lPCP)

	If (lEnvia)
		cHTML := '<!doctype html>' + CRLF
		cHTML += '<html>' + CRLF
		cHTML += '' + CRLF
		cHTML += '<body>' + CRLF
		cHTML += '<p> O Produto abaixo encontra-se com o seguinte Status e Pendência:</p>' + CRLF
		cHTML += '<p>&nbsp;</p>' + CRLF
		cHTML += '<table width="100%" border="1">' + CRLF
		cHTML += '  <tbody>' + CRLF
		cHTML += '    <tr>' + CRLF
		cHTML += '      <th width="30%" scope="row">&nbsp;Produto</th>' + CRLF
		cHTML += '      <td width="70%">&nbsp;' + cProduto + '</td>' + CRLF
		cHTML += '    </tr>' + CRLF
		cHTML += '    <tr>' + CRLF
		cHTML += '      <th scope="row">&nbsp;Tipo do Produto</th>' + CRLF
		cHTML += '      <td>&nbsp;' + cTipo + '</td>' + CRLF
		cHTML += '    </tr>' + CRLF
		cHTML += '    <tr>' + CRLF
		cHTML += '      <th scope="row">&nbsp;Usuário Responsável</th>' + CRLF
		cHTML += '      <td>&nbsp;' + cUser + '</td>' + CRLF
		cHTML += '    </tr>' + CRLF
		cHTML += '    <tr>' + CRLF
		cHTML += '      <th scope="row">&nbsp;Data de Cadastro</th>' + CRLF
		cHTML += '      <td>&nbsp;' + DTOC(cCadastro) + '</td>' + CRLF
		cHTML += '    </tr>' + CRLF
		cHTML += '    <tr>' + CRLF
		cHTML += '      <th scope="row">&nbsp;Status</th>' + CRLF
		cHTML += '      <td>&nbsp;' + Iif(lStatus, "Bloqueado", "Aprovado") + '</td>' + CRLF
		cHTML += '    </tr>' + CRLF
		cHTML += '  </tbody>' + CRLF
		cHTML += '</table>' + CRLF
		cHTML += '<p><b><br>&nbsp;Departamento - Status<br><br></b></p>' + CRLF
		cHTML += '<p>&nbsp;Desenvolvimento - <font color="' + Iif(lDesenv, "red", "green") + '">' + Iif(lDesenv, "Pendente", "Aprovado") + '</font></p>' + CRLF
		cHTML += '<p>&nbsp;Compras - <font color="' + Iif(lCompras, "red", "green") + '">' + Iif(lCompras, "Pendente", "Aprovado") + '</font></p>' + CRLF
		cHTML += '<p>&nbsp;Fiscal - <font color="' + Iif(lFiscal, "red", "green") + '">' + Iif(lFiscal, "Pendente", "Aprovado") + '</font></p>' + CRLF
		cHTML += '<p>&nbsp;Vendas - <font color="' + Iif(lVendas, "red", "green") + '">' + Iif(lVendas, "Pendente", "Aprovado") + '</font></p>' + CRLF
		cHTML += '<p>&nbsp;Qualidade - <font color="' + Iif(lQualidade, "red", "green") + '">' + Iif(lQualidade, "Pendente", "Aprovado") + '</font></p>' + CRLF
		cHTML += '<p>&nbsp;Processos - <font color="' + Iif(lProcessos, "red", "green") + '">' + Iif(lProcessos, "Pendente", "Aprovado") + '</font></p>' + CRLF
		cHTML += '<p>&nbsp;PCP - <font color="' + Iif(lPCP, "red", "green") + '">' + Iif(lPCP, "Pendente", "Aprovado") + '</font></p>' + CRLF
		cHTML += '<p>&nbsp;Comex - <font color="' + Iif(lComex, "red", "green") + '">' + Iif(lComex, "Pendente", "Aprovado") + '</font></p>' + CRLF
		cHTML += '' + CRLF
		cHTML += '</body>' + CRLF
		cHTML += '</html>' + CRLF

		Connect Smtp Server cServer Account cAccount Password cPassword Result lOk

		If (lOk)
			If (lAuth)
				MailAuth(cAccount, cPassword)
			Endif

			Send Mail From cDe To cPara Subject cAssunto Body cHTML Format Text Result lOk
		Endif

		Disconnect Smtp Server
	Endif

	RestArea(aAreaSB1)
	RestArea(aArea)
Return()
