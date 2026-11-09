#include "rwmake.ch"
#include "topconn.ch"
#include "Protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPROGRAMA  ³ALTSNDPED º AUTOR ³FELIPE BRAGA        º DATA ³  05/04/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDESCRICAO ³ENVIA E-MAIL INFORMANDO ALTERAÇÃO DO PEDIDO NO SISTEMA  	  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUSO       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function AltSndPed()

Local dDtBase	:= dDataBase
Local _aArea 	:= GetArea()
Local cQuery 	:= "" 
Local cNome  	:= Alltrim(SA1->A1_NREDUZ)
Local cObser 	:= ""
Local nTpag  	:= ''
Local cEmp		:= ""
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
//cBody += "<p align=center>"+ cEmp +"</p></th>"
cBody += "<th width=766 ><font face='tahoma' size=2 color=#273A75> Alteração de Pedido </th>" 
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

cBody += "<tr>"
cBody += "<th width=896 height=61 scope=col>"   
cBody += "<table width=896 border=1 bordercolor=#999999>"
cBody += "<tr>"
cBody += "<th width=46><font face='tahoma' size=2 color=#000><b>Item</b></th>"
cBody += "<th width=239><font face='tahoma' size=2 color=#000><b>Produto</b></th>"
cBody += "<th width=239><font face='tahoma' size=2 color=#000><b>Descri&ccedil;&atilde;o</b></th>"
cBody += "<th width=47><font face='tahoma' size=2 color=#000><b>Qtde.</b></th>"
cBody += "<th width=82><font face='tahoma' size=2 color=#000><b>Valor Unit.</b></th>"
cBody += "<th width=92><font face='tahoma' size=2 color=#000><b>Valor Tot.</b></div></th>"
cBody += "</tr>"

//ClosesFile("Tped")
//BUSCA OS ITENS DO PEDIDO
cQuery 	:= " SELECT C6_NUM,C6_ITEM,C6_PRODUTO,C6_DESCRI,C6_QTDVEN,C6_PRCVEN,C6_VALOR,(C6_QTDVEN*C6_PRCVEN) AS TOT "
cQuery  += " FROM "+RetSqlName("SC6")+" C6
cQuery  += " WHERE C6.D_E_L_E_T_ <> '*'"
cQuery  += " AND C6_FILIAL = '01' "
cQuery 	+= " AND C6_NUM = '"+SC5->C5_NUM+"'"
cQuery 	+= " AND C6_CLI = '"+SC5->C5_CLIENTE+"'"
cQuery 	+= " AND C6_LOJA = '"+SC5->C5_LOJACLI+"'"
cQuery 	+= " ORDER BY C6_ITEM"            


cQuery := ChangeQuery( cQuery )
dbUseArea( .T., "TOPCONN", TcGenQry( , , cQuery ), "Tped", .T., .T. )

dbSelectArea("Tped")
ProcRegua(Tped->(LastRec()))
Tped->(DBGoTop())  


While (!Eof())

	cBody += "<tr bgcolor=white>"
	cBody += "<td height=16><div align=center><font face='tahoma' size=1 color=#000>"+Tped->C6_ITEM+"</div></td>"
	cBody += "<td align=center><div align=center><font face='tahoma' size=1 color=#000>"+AllTrim(Tped->C6_PRODUTO)+"</div></td>"
	cBody += "<td align=center><div align=center><font face='tahoma' size=1 color=#000>"+Substring(Tped->C6_DESCRI,1,35)+"</div></td>"
	cBody += "<td align=center><div align=center><font face='tahoma' size=1 color=#000>"+str(Tped->C6_QTDVEN)+"</div></td>"
	cBody += "<td align=center><div align=center><font face='tahoma' size=1 color=#000>"+Transform(Tped->C6_PRCVEN, "@E 999,999,999.99")+"</div></td>"   
	cBody += "<td align=center><div align=center><font face='tahoma' size=1 color=#000>"+Transform(Tped->TOT, "@E 999,999,999.99")+"</div></td>"
	cBody += "</tr>"   
        
	nContador++
		
	dbSelectArea("Tped")
	Tped->(dbSkip()) 

End 
Tped->(DbCloseArea())
cBody += "</table></th>"
cBody += "</tr>"
cBody += "</table>"

cObsFin := "Este pedido sofreu alterações."

cBody += "<br><br>"
cBody += "<table border=0 cellpadding=0 width=901>"
cBody += "<tr>"
cBody += "</tr>"
cBody += "<tr>"
cBody += "<td width=885><p><b><font face='tahoma' size=2 color=#666><b>Observa&ccedil;&otilde;es</b></p></td>"
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

/*                 
cEmailVend 	:= "" //Lower(Alltrim((Posicione("SA3",1,xFilial("SA3")+SC5->C5_VEND1,"A3_EMAIL"))))
cPara		:= ""
cCc			:= ""
bCc			:= ""
*/

cPara 		:=  cEmailOp //cEmailVend 
cCc			:= "" //Iif(Alltrim(UsrRetMail(RetCodUsr())) <> cEmailVend, Alltrim(UsrRetMail(RetCodUsr())) + "; " +  cEmailOp, cEmailOp)
bCc			:= ""		

/*
//cEmailCli 	+= ";" + ALLTRIM(Posicione("SA1",1,xFilial("SA1")+TQry->E1_CLIENTE+E1_LOJA,"A1_EMAIL"))
cEmailVend 	:=	Lower(Alltrim((Posicione("SA3",1,xFilial("SA3")+SC5->C5_VEND1,"A3_EMAIL"))))
cPara 		:=	cEmailVend  
cCc			:=	Iif(Alltrim(UsrRetMail(RetCodUsr())) <> cEmailVend, Alltrim(UsrRetMail(RetCodUsr())) + "; " +  cEmailOp, cEmailOp)  


If SC5->C5_XADIANT == '1'
	cCc +=  + "; " + Alltrim(GetMv("MV_MAILFIN"))
EndIf	
*/
	
memowrit("\system\vend\cliente_"+AllTrim(SC5->C5_CLIENTE+"-"+CapitalAce(cNome))+".htm", cBody)
  
				//User Function gEnviaEmail(cFrom,cAssunto, cMsg, cPara, aCc, aBcc, cFiles , cPas, cAcount)
u_gEnviaEmail( , "Alteração do Pedido: "+alltrim(SC5->C5_NUM)+" - "+ALLTRIM(cNome), cBody, cPara, cCc, bCc, "\workflow\HTM\Logo\lgrl01.jpg", " ", " ")
RestArea(_aArea)

Endif  
	
Return
