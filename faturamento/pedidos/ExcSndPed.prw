#include "rwmake.ch"
#include "topconn.ch"
#include "Protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPROGRAMA  ³ExcSndPed º AUTOR ³FELIPE BRAGA        º DATA ³  05/04/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDESCRICAO ³ENVIA E-MAIL INFORMANDO ALTERAÇÃO DO PEDIDO NO SISTEMA  	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUSO       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function ExcSndPed()

Local dDtBase	:= dDataBase
Local _aArea 	:= GetArea()
Local cQuery 	:= "" 
Local cNome  	:= Alltrim(SA1->A1_NREDUZ)
Local cObser 	:= ""
Local nTpag  	:= ''
//Local cEmp		:= ""
Local cVend	 	:= Alltrim((Posicione("SA3",1,xFilial("SA3") + SC5->C5_VEND1,"A3_NREDUZ")))  
Local nContador	:= 0  


cCondPag 	:= ALLTRIM(Posicione("SE4",1,xFilial("SE4")+SC5->C5_CONDPAG,"E4_DESCRI"))
cEmailOp	:= Alltrim(GetMv("MV_MAILPV"))
     	//cEmp := "Parafix" 

If SC5->C5_TIPO == "N" .AND. SC5->C5_FILIAL == "01" .AND. SC5->C5_CLIENTE != "000067"

cBody := "<html><body>"
cBody += "<table width=902 border=1 bordercolor=#E3E3E3 bgcolor=#E3E3E3>"
cBody += "<tr>"
cBody += "<th width=159 height=40 bgcolor=#B9B3B3><font face='tahoma' size=2 color=#273A75><img src='\\10.100.10.6\totvs12\Microsiga\protheus_data\workflow\htm\logo\lgrl01.jpg'> "
cBody += "<th width=766 ><font face='tahoma' size=2 color=#273A75> Exclusão de Pedido </th>" 
cBody += "</tr>"
cBody += "</table>"
cBody += "<hr align=left width=900>"
cBody += "<table width=902 border=2>"
cBody += "<tr>"
cBody += "<th height=23><font face='tahoma' size=2 color=#000><b>Cliente:</b></th>"
cBody += "<th><div align=left><font face='tahoma' size=2 color=#000><b>"+" "+alltrim(SC5->C5_CLIENT)+"/"+alltrim(SC5->C5_LOJACLI)+" - "+CapitalAce(alltrim(cNome))+"</b></div></th>"
cBody += "</tr>"
cBody += "<tr>"
cBody += "<th width=142 height=23><font face='tahoma' size=2 color=#000><b>Vendedor:</b></th>"
cBody += "<th width=742><div align=left><font face='tahoma' size=2 color=#000><b>"+" "+CapitalAce(alltrim(cVend))+"</b></div></th>"
cBody += "</tr>"
cBody += "</table>"


cBody += "<table width=902 border=0 bordercolor=#999999>"
cBody += "<tr>"
cBody += "<th height=21>&nbsp;</th>"
cBody += "</tr>"
cBody += "<tr>"
cBody += "<th height=49><table width=896 border=1 align=center bordercolor=#999999>"
cBody += "<tr>"
cBody += "<th width=252 height=16><font face='tahoma' size=2 color=#000><b>Pedido</b></th>"
cBody += "<th width=306><font face='tahoma' size=2 color=#000><b>Emissão</b></th>"
cBody += "<th width=238><font face='tahoma' size=2 color=#000><b>&Uacute;ltima Atualiza&ccedil;&atilde;o</b></th>"
cBody += "</tr>"


cBody += "<tr>" 
cBody += "<td height=16><div align=center><font face='tahoma' size=1 color=#000>"+alltrim(SC5->C5_NUM)+"</div></td>"
cBody += "<td><div align=center><font face='tahoma' size=1 color=#000>"+ DTOC(SC5->C5_EMISSAO) +"</div></td>"
cBody += "<td class=style8><div align=center><font face='tahoma' size=1 color=#000>"+ DTOC(DATE()) +" | " + TIME() +"</div></td>"
cBody += "</tr>"
cBody += "</table></th>"
cBody += "</tr>"

cObsFin := "Este pedido foi excluído do sistema."

cBody += "<br><br>"
cBody += "<table border=0 cellpadding=0 width=901>"
cBody += "<tr>"
cBody += "</tr>"
cBody += "<tr>"
cBody += "<td width=885><p><b><font face='tahoma' size=2 color=#666><b>Observa&ccedil;&otilde;es</b></p></td>
cBody += "</tr>"
cBody += "<tr>"
cBody += "<td><p><font face='tahoma' size=2 color=#666>"+cObsFin+"</p></td>"
cBody += "</tr>"
cBody += "<tr>"
cBody += "<td><p><font face='tahoma' size=2 color=#666>Em caso de dúvida, entre em contato com o seu vendedor.</p></td>" //" + CapitalAce(cVend)+ "
cBody += "</tr>"
cBody += "</table>"
cBody += "</body>"
cBody += "</html>"



cPara 		:=  cEmailOp
cCc			:= ""
/*cEmailCli 	+= ";" + ALLTRIM(Posicione("SA1",1,xFilial("SA1")+TQry->E1_CLIENTE+E1_LOJA,"A1_EMAIL"))
cEmailVend 	:= Lower(Alltrim((Posicione("SA3",1,xFilial("SA3")+SC5->C5_VEND1,"A3_EMAIL"))))
cPara		:= "felipe.braga@industriastosi.com.br"
cCc			:= ""

cPara 		:= cEmailVend + ";felipe.braga@industriastosi.com.br"
cCc			:= Iif(Alltrim(UsrRetMail(RetCodUsr())) <> cEmailVend, Alltrim(UsrRetMail(RetCodUsr())) + "; " +  cEmailOp, cEmailOp)


/*If SC5->C5_XADIANT == '1'
	cCc +=  + "; " + Alltrim(GetMv("MV_MAILFIN"))
EndIf	
*/

memowrit("\system\vend\cliente_"+AllTrim(SC5->C5_CLIENTE+"-"+CapitalAce(cNome))+".htm", cBody)
u_gEnviaEmail( , "Exclusão do Pedido: "+alltrim(SC5->C5_NUM)+" - "+ALLTRIM(cNome), cBody, cPara, cCc, " ", "\workflow\HTM\Logo\Logo1.jpg", " ", " ")
RestArea(_aArea)  
	
Endif
	
Return
