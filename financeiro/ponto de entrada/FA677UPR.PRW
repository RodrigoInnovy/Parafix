//Ponto de  entrada que permite alterar uma prestação de contas.
#include 'Protheus.ch'
  
User Function FA677UPR()
    Local lRet := .T.
 
    //If RD0->RD0_USER == "000784" //Verifica se usuário pode alterar a prestação de contas
    //    lRet := .F.
    //    MsgInfo("Usuário "+USRRETNAME(RD0->RD0_USER)+" sem acesso")
    //EndIf
 
Return lRet