#INCLUDE "FWMVCDEF.CH"
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"
#IFNDEF CRLF
	#DEFINE CRLF ( chr(13)+chr(10) )
#ENDIF

User Function MT010BRW()
Local aButtons := {}


// ----------- Elementos contidos por dimensao ------------    
// 1. Nome a aparecer no cabecalho                             
// 2. Nome da Rotina associada                                 
// 3. Usado pela rotina                                        
// 4. Tipo de Transacao a ser efetuada                         
//    1 - Pesquisa e Posiciona em um Banco de Dados            
//    2 - Simplesmente Mostra os Campos                        
//    3 - Inclui registros no Bancos de Dados                  
//    4 - Altera o registro corrente                           
//    5 - Remove o registro corrente do Banco de Dados         
//    6 - Altera determinados campos sem incluir novos Regs     

Aadd(aButtons, { "Saldo",  "U_RetSaldo()" , 0 ,0,0, NIL })//"Saldo SB2

//AAdd(aButtons,{ 'Operações',{| | opera() }, 'Operações','Operações' } )

//Adiciona o botão Operações no cadastro de produto.

//Aadd(aButtons, { "Operações",  "u_opera()" , 0 ,0,0, NIL })//Operações



Return (aButtons)


User Function RetSaldo()
Local aArea    := GetArea()
Local aAreaSB2 := SB2->(GetArea())
Local cQry := ""
Local _cFilial := ""
Local cSaldo := "Produto: "+Alltrim(SB1->B1_COD)+"-"+Alltrim(SB1->B1_DESC) + CRLF

MsgInfo("Pressionar F4 posicionado no produto desejado para a consulta de saldos", "ATENÇÃO: ROTINA DESCONTINUADA")
/*

cQry := "SELECT B2.B2_COD AS Produto, B2.B2_LOCAL as Arm, B2.B2_FILIAL AS Filial, B2.B2_QATU AS Saldo"
cQry += "FROM "+ RetSqlName("SB2") + " B2 "
cQry += "WHERE B2.D_E_L_E_T_ = ' ' "
cQry += "AND B2.B2_COD = '"+SB1->B1_COD+"' "
cQry += "ORDER BY B2.B2_COD, B2.B2_FILIAL, B2.B2_LOCAL"

TcQuery ChangeQuery(cQry) New Alias "QryB2"

QryB2->(DbSelectArea("QryB2"))
QryB2->(DbGoTop())

While QryB2->(!Eof())
	
	IF Empty(_cFilial) .OR. _cFilial <> QryB2->FILIAL
		_cFilial := QryB2->FILIAL
	    cSaldo += "Filial: " + Alltrim(QryB2->FILIAL) + " Armazem: "  + Alltrim(QryB2->ARM) + " Saldo: " + CRLF
    Else
		cSaldo += Space(31) + Alltrim(QryB2->ARM) + " Saldo: " + PadL(Alltrim(TransForm(QryB2->SALDO,PesqPict("SB2","B2_QATU"))),16) + CRLF	
    EndIf
	
	QRYB2->(dbSkip())

Enddo

QRYB2->(dbCloseArea())

AVISO("Saldo do Produto", “cSaldo”, {"Fechar"}, 3)

RestArea(aAreaSB2)
RestArea(aArea)
*/

Return ()



//Adicionar Operações no cadastro de produto

//User Function opera()

//Local lRet := {} 

//lRet := FWExecView("Incluir", "MATA632",OP_INCLUIR , /*oDlg*/, {|| .T. }, /*bOk*/ , /*nPercReducao*/, /*aEnableButtons*/, /*bCancel*/ , /*cOperatId*/, /*cToolBar*/, ) 

//Return lRet
