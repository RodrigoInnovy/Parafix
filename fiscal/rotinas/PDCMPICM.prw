#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "Topconn.ch"    

//*****************************************************************************************  
//* Função : PDCMPICM
//* Objetivo : Busco os itens em poder de terceiro e gero pedido com complemento de ICMS
//* Autor    : Patrick Araujo - 28/11/2018
//*****************************************************************************************
                                                                                 
User Function PDCMPICM()
 
Local lOk    := .T.
Local cFornece := ""
Local cLoja := ""
local nStart

 
PRIVATE lMsErroAuto := .F.
//****************************************************************
//* Abertura do ambiente
//****************************************************************

If lOk

    If Pergunte("PEDIP3",.T.)

        IF MSGYESNO( "Deseja gerar pedido de venda de Complemento de ICMS de poder de terceiros ?", "Pedido de Venda ICMS P3" )

            cFornece := Alltrim(MV_PAR01)
            cLoja := Alltrim(MV_PAR02)

            Processa( {|| GERCMPIC(cFornece,cLoja) }, "Aguarde...", "Gerando o pedido de venda...",.F.)

        Endif             
    Endif    
EndIf

Return(.T.)


Static Function GERCMPIC(cFornece,cLoja)

Local aCabec := {}
Local aItens := {}
Local aLinha := {}
Local nX     := 0
Local cDoc   := ""
Local aItem := {}
Local cC6item := "00"
Local cQuery := ""
Local cAliasSB6 := ""
local nStart


    dbSelectArea("SB6")
    dbSetOrder(1)

    cQuery	:= " SELECT SB6.*, SF4.F4_PODER3 "
    cQuery	+= " FROM " + RetSqlName("SB6") + " SB6"
    cQuery	+= " JOIN " + RetSqlName("SF4") + " SF4"
    cQuery	+= " ON SF4.F4_FILIAL = '"   + xFilial("SF4") + "' "
    cQuery	+= " AND SF4.F4_CODIGO = SB6.B6_TES AND SF4.F4_PODER3 = 'R' "
    cQuery  += " AND SF4.D_E_L_E_T_ = ' ' "
    cQuery  += " WHERE SB6.B6_FILIAL = '"   + xFilial("SB6") + "' "

    If cFilant == "01" // Verifico se é filial 01 buscar os dados do cliente, caso contrario busco do fornecedor. 

        cQuery  += " AND SB6.B6_TPCF = 'C' AND B6_CLIFOR = '" + MV_PAR01 + "' AND B6_LOJA = '" + MV_PAR02 + "' "
    Else

        cQuery  += " AND SB6.B6_TPCF = 'F' AND B6_CLIFOR = '" + MV_PAR01 + "' AND B6_LOJA = '" + MV_PAR02 + "' "
    Endif  
          
    cQuery  += " AND SB6.B6_PRODUTO >= '" + MV_PAR03 + "' "
    cQuery  += " AND SB6.B6_PRODUTO <= '" + MV_PAR04 + "' "
    cQuery  += " AND SB6.B6_DTDIGIT >= '"+ DTOS(MV_PAR05) +"' AND SB6.B6_DTDIGIT <= '" + DTOS(MV_PAR06) + "' "
    cQuery  += " AND SB6.B6_QUANT > 0 AND SB6.D_E_L_E_T_ = ' ' "
    cQuery  += " ORDER BY B6_FILIAL, B6_PRODUTO, B6_DTDIGIT "

    TCQuery cQuery new Alias (cAliasSB6:=GetNextAlias())   
    dbSelectArea(cAliasSB6)
    (cAliasSB6)->(DbGoTop())

    If (cAliasSB6)->(!EOF())

        DbSelectArea("SD2")
        DbSetOrder(18)
            
        While (cAliasSB6)->(!EOF())

            If SD2->(DbSeek(xFilial("SD2")+(cAliasSB6)->(B6_DOC+B6_SERIE+B6_CLIFOR+B6_LOJA+B6_PRODUTO+B6_IDENT)))
                    
                    aadd(aItem,{SD2->D2_COD           	    		                           ,; //[1] PRODUTO
                        0                    	    		                                   ,; //[2] QUANTIDADE
                        ROUND((SD2->D2_TOTAL*18)/100,2)         		                       ,; //[3] PRECO DE VENDA
                        ROUND((SD2->D2_TOTAL*18)/100,2)                                        ,; //[4] PRECO UNITARIO
                        ROUND((SD2->D2_TOTAL*18)/100,2)               	                       ,; //[5] TOTAL
                        "5XF"                                                             	   ,; //[6] TES
                        SD2->D2_DOC                                                            ,; //[7] NF ORIGINAL
                        SD2->D2_ITEM                                                           ,; //[8] ITEM ORIGINAL
                        SD2->D2_SERIE                                                          }) //[9] SERIE ORIGINAL
                
            Endif

            (cAliasSB6)->(dbSkip())   
        EndDo

        For nX := 1 To Len(aItem)
            aLinha := {}
            cC6item := Soma1(cC6item)
            aadd(aLinha,{"C6_ITEM",cC6item,Nil})
            aadd(aLinha,{"C6_PRODUTO",aItem[nX][1],Nil})
            aadd(aLinha,{"C6_QTDVEN",aItem[nX][2],Nil})
            aadd(aLinha,{"C6_PRCVEN",aItem[nX][3],Nil})
            aadd(aLinha,{"C6_PRUNIT",aItem[nX][4],Nil})
            aadd(aLinha,{"C6_VALOR",aItem[nX][5],Nil})
            aadd(aLinha,{"C6_TES",aItem[nX][6],Nil})
            aadd(aLinha,{"C6_NFORI",aItem[nX][7],Nil})
            aadd(aLinha,{"C6_ITEMORI",aItem[nX][8],Nil})
            aadd(aLinha,{"C6_SERIORI",aItem[nX][9],Nil})
            aadd(aItens,aLinha)
        Next nX


        DbselectArea("SA1")
        Dbsetorder(1)
        
        If SA1->(Dbseek(xFilial("SA1") + cFornece + cLoja ))
                FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","Inicio: "+Time(), 0, (nStart - Seconds()), {})
                cDoc := GetSxeNum("SC5","C5_NUM")
                RollBAckSx8()
                aCabec := {}
                aadd(aCabec,{"C5_NUM"   ,cDoc,Nil})
                aadd(aCabec,{"C5_TIPO" ,"I",Nil})
                aadd(aCabec,{"C5_CLIENTE",SA1->A1_COD,Nil})
                aadd(aCabec,{"C5_LOJACLI",SA1->A1_LOJA,Nil})
                aadd(aCabec,{"C5_LOJAENT",SA1->A1_LOJA,Nil})
                aadd(aCabec,{"C5_CONDPAG","099",Nil})

                //****************************************************************
                //* Inclusão via execauto             
                //****************************************************************
                MsExecAuto({|x, y, z| MATA410(x, y, z)}, aCabec, aItens, 3) 
                If !lMsErroAuto
                    MsgAlert("Pedido de venda N. "+Alltrim(SC5->C5_NUM)+" gerado com sucesso!")
                Else
                    MostraErro()
                EndIf

        Endif
    Else
        MsgInfo("Não existem dados nesse periodo !!!")
    Endif 

Return()   
