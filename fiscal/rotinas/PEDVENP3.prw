#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "Topconn.ch"    

//*****************************************************************************************  
//* Função : PEDVENP3
//* Objetivo : Busco os itens em poder de terceiro e gero pedido de venda para devolucao
//* Autor    : Patrick Araujo - 22/11/2018
//*****************************************************************************************
                                                                                 
User Function PEDVENP3()
 
Local lOk    := .T.
Local cFornece := ""
Local cLoja := ""
Local nGerICM

 
PRIVATE lMsErroAuto := .F.
//****************************************************************
//* Abertura do ambiente
//****************************************************************

If lOk

    If Pergunte("PEDVP3",.T.)

        IF MSGYESNO( "Deseja gerar pedido de venda com os itens para retorno de poder de terceiros ?", "Pedido de Venda P3" )

            cFornece := Alltrim(MV_PAR01)
            cLoja := Alltrim(MV_PAR02)
            nGerICM := MV_PAR06

            Processa( {|| GERPVP3(cFornece,cLoja,nGerICM) }, "Aguarde...", "Gerando o pedido de venda...",.F.)

        Endif             
    Endif    
EndIf

Return(.T.)

Static Function GERPVP3(cFornece,cLoja,nGerICM)

Local aCabec := {}
Local aItens := {}
Local aLinha := {}
Local nX     := 0
Local cDoc   := ""
Local aItem := {}
Local cC6item := "00"
Local cQuery := ""
Local cQuery2 := ""
Local cAliasSB6 := ""
Local cAliasB6T := ""
Local aTotal := {}
Local nSaldRest := 0
Local cProduto := ""
Local nSaldoP3 := ""
Local nSaldoEst := ""
Local nSaldoDevo := ""
Local nItem
local nStart


    cQuery := " SELECT B6_PRODUTO, SUM(B6_SALDO) SALDOP3, (SELECT SUM(B2_QATU) FROM "+RETSQLNAME("SB2")+"(NOLOCK) "
    cQuery += " WHERE B2_COD = B6_PRODUTO AND B2_FILIAL = '"+xFilial("SB2")+"' AND D_E_L_E_T_ = '') SALDOEST, " 
    cQuery += " SUM(B6_SALDO)-(SELECT SUM(B2_QATU) FROM "+RETSQLNAME("SB2")+"(NOLOCK) "
    cQuery += " WHERE B2_COD = B6_PRODUTO AND B2_FILIAL = '"+xFilial("SB2")+"' AND D_E_L_E_T_ = '') SALDODEVO "
    cQuery += " FROM "+RETSQLNAME("SB6")+"(NOLOCK) SB6 " 
    cQuery += " JOIN "+RETSQLNAME("SF4")+"(NOLOCK) SF4 ON SF4.F4_FILIAL = '' AND SF4.F4_CODIGO = SB6.B6_TES AND SF4.F4_PODER3 <> 'D' AND SF4.D_E_L_E_T_ = '' "
    cQuery += " WHERE SB6.B6_FILIAL = '"+xFilial("SB6")+"' "
    cQuery += " AND SB6.B6_TPCF = 'F' AND B6_CLIFOR = '"+MV_PAR01+"' AND B6_LOJA = '"+MV_PAR02+"' "
    cQuery += " AND SB6.B6_PRODUTO >= '"+MV_PAR03+"' "
    cQuery += " AND SB6.B6_PRODUTO <= '"+MV_PAR04+"' "
    cQuery += " AND SB6.B6_DTDIGIT >= '"+DTOS(MV_PAR05)+"' AND SB6.B6_DTDIGIT <= '"+DTOS(dDatabase)+"' "
    cQuery += " AND SB6.B6_TIPO = 'D' "
    cQuery += " AND SB6.B6_SALDO > 0 AND SB6.D_E_L_E_T_ = '' " 
    cQuery += " GROUP BY B6_PRODUTO "
    cQuery += " ORDER BY B6_PRODUTO "

    TCQuery cQuery new Alias (cAliasB6T:=GetNextAlias())   
    DbSelectArea(cAliasB6T)
    (cAliasB6T)->(DbGoTop())

    dbSelectArea("SB6")
    dbSetOrder(1)

    cQuery2	:= " SELECT SB6.*, SF4.F4_PODER3 "
    cQuery2	+= " FROM " + RetSqlName("SB6") + " SB6"
    cQuery2	+= " JOIN " + RetSqlName("SF4") + " SF4"
    cQuery2	+= " ON SF4.F4_FILIAL = '"   + xFilial("SF4") + "' "
    cQuery2	+= " AND SF4.F4_CODIGO = SB6.B6_TES AND SF4.F4_PODER3 <> 'D' "
    cQuery2 += " AND SF4.D_E_L_E_T_ = ' ' "
    cQuery2  += " WHERE SB6.B6_FILIAL = '"   + xFilial("SB6") + "' "
    cQuery2  += " AND SB6.B6_TPCF = 'F' AND B6_CLIFOR = '" + MV_PAR01 + "' AND B6_LOJA = '" + MV_PAR02 + "' "
    cQuery2  += " AND SB6.B6_PRODUTO >= '" + MV_PAR03 + "' "
    cQuery2  += " AND SB6.B6_PRODUTO <= '" + MV_PAR04 + "' "
    cQuery2  += " AND SB6.B6_DTDIGIT >= '"+ DTOS(MV_PAR05) +"' AND SB6.B6_DTDIGIT <= '" + DTOS(dDatabase) + "' "
    cQuery2  += " AND SB6.B6_QUANT > 0 AND SB6.D_E_L_E_T_ = ' ' "
    cQuery2  += " ORDER BY B6_FILIAL, B6_PRODUTO, B6_DTDIGIT "

    TCQuery cQuery2 new Alias (cAliasSB6:=GetNextAlias())   
    dbSelectArea(cAliasSB6)
    (cAliasSB6)->(DbGoTop())

    While (cAliasB6T)->(!EOF()) // ADICIONO TODOS OS SALDOS DE P3 EM UM ARRAY.

        AAdd(aTotal,{(cAliasB6T)->B6_PRODUTO,; // CODIGO DO PRODUTO
                    (cAliasB6T)->SALDOP3,;   // SALDO EM P3
                    (cAliasB6T)->SALDOEST,;   // SALDO DEVOLUCAO COM MOVIMENTACAO ESTOQUE
                    (cAliasB6T)->SALDODEVO }) // SALDO DEVOLUCAO SEM MOVIMENTACAO ESTOQUE

        (cAliasB6T)->(DbSkip())                 
    Enddo

    If Len(aTotal) > 0

        DbSelectArea("SD1")
        DbSetOrder(23)

        For x:= 1 to len(aTotal)

            cProduto   := aTotal[x][1] // CODIGO DO PRODUTOPA
            nSaldoP3   := aTotal[x][2] // SALDO EM P3
            nSaldoEst  := aTotal[x][3] // SALDO DEVOLUCAO COM MOVIMENTACAO ESTOQUE
            nSaldoDevo := aTotal[x][4] // SALDO DEVOLUCAO SEM MOVIMENTACAO ESTOQUE
            
            While (cAliasSB6)->(!EOF()) .AND. (cAliasSB6)->B6_PRODUTO == cProduto .AND. nSaldoP3 > 0

                nSaldRest := 0

                While nSaldoDevo > 0

                    If SD1->(DbSeek(xFilial("SD1")+(cAliasSB6)->(B6_DOC+B6_SERIE+B6_CLIFOR+B6_LOJA+B6_PRODUTO+B6_IDENT)))
                            
                        If nSaldoDevo >= SD1->D1_QUANT

                            nSaldoDevo := nSaldoDevo-SD1->D1_QUANT
                            nSaldoP3   := nSaldoP3-SD1->D1_QUANT

                            aadd(aItem,{SD1->D1_COD           	    		                           ,; //[1] PRODUTO
                                SD1->D1_QUANT         	    		                                   ,; //[2] QUANTIDADE
                                A410Arred(SD1->D1_VUNIT,"C6_PRCVEN")         	    		           ,; //[3] PRECO DE VENDA
                                A410Arred(SD1->D1_VUNIT,"C6_PRUNIT")                                   ,; //[4] PRECO UNITARIO
                                A410Arred(SD1->D1_QUANT*SD1->D1_VUNIT,"C6_VALOR")               	   ,; //[5] TOTAL
                                "5ZU"                                                             	   ,; //[6] TES
                                SD1->D1_DOC                                                            ,; //[7] NF ORIGINAL
                                SD1->D1_ITEM                                                           ,; //[8] ITEM ORIGINAL
                                SD1->D1_SERIE                                                          ,; //[9] SERIE ORIGINAL
                                SD1->D1_IDENTB6                                                        }) //[10] IDENTB6

                        Else

                            aadd(aItem,{SD1->D1_COD           	    		                           ,; //[1] PRODUTO
                                nSaldoDevo         	    		                                       ,; //[2] QUANTIDADE
                                A410Arred(SD1->D1_VUNIT,"C6_PRCVEN")         	    		           ,; //[3] PRECO DE VENDA
                                A410Arred(SD1->D1_VUNIT,"C6_PRUNIT")                                   ,; //[4] PRECO UNITARIO
                                A410Arred(nSaldoDevo*SD1->D1_VUNIT,"C6_VALOR")               	       ,; //[5] TOTAL
                                "5ZU"                                                             	   ,; //[6] TES
                                SD1->D1_DOC                                                            ,; //[7] NF ORIGINAL
                                SD1->D1_ITEM                                                           ,; //[8] ITEM ORIGINAL
                                SD1->D1_SERIE                                                          ,; //[9] SERIE ORIGINAL
                                SD1->D1_IDENTB6                                                        }) //[10] IDENTB6

                            nSaldRest := SD1->D1_QUANT-nSaldoDevo
                            nSaldoP3   := nSaldoP3-nSaldoDevo
                            nSaldoDevo := 0

                        EndIf                                 
                    Endif

                    If nSaldRest == 0 // Caso tenha sobrado saldo nos itens de uma nota nao pulo a mesma

                        (cAliasSB6)->(dbSkip())

                    Endif    


                EndDo

                While nSaldoEst > 0

                    If nSaldRest == 0
                
                        If SD1->(DbSeek(xFilial("SD1")+(cAliasSB6)->(B6_DOC+B6_SERIE+B6_CLIFOR+B6_LOJA+B6_PRODUTO+B6_IDENT)))
                            
                            If nSaldoEst >= SD1->D1_QUANT

                            aadd(aItem,{SD1->D1_COD           	    		                           ,; //[1] PRODUTO
                                SD1->D1_QUANT         	    		                                   ,; //[2] QUANTIDADE
                                A410Arred(SD1->D1_VUNIT,"C6_PRCVEN")         	    		           ,; //[3] PRECO DE VENDA
                                A410Arred(SD1->D1_VUNIT,"C6_PRUNIT")                                   ,; //[4] PRECO UNITARIO
                                A410Arred(SD1->D1_QUANT*SD1->D1_VUNIT,"C6_VALOR")               	   ,; //[5] TOTAL
                                "5YX"                                                             	   ,; //[6] TES
                                SD1->D1_DOC                                                            ,; //[7] NF ORIGINAL
                                SD1->D1_ITEM                                                           ,; //[8] ITEM ORIGINAL
                                SD1->D1_SERIE                                                          ,; //[9] SERIE ORIGINAL
                                SD1->D1_IDENTB6                                                        }) //[10] IDENTB6

                                nSaldoEst := nSaldoEst-SD1->D1_QUANT
                                nSaldoP3   := nSaldoP3-SD1->D1_QUANT

                            Else

                            aadd(aItem,{SD1->D1_COD           	    		                           ,; //[1] PRODUTO
                                nSaldoEst         	    		                                       ,; //[2] QUANTIDADE
                                A410Arred(SD1->D1_VUNIT,"C6_PRCVEN")         	    		           ,; //[3] PRECO DE VENDA
                                A410Arred(SD1->D1_VUNIT,"C6_PRUNIT")                                   ,; //[4] PRECO UNITARIO
                                A410Arred(nSaldoEst*SD1->D1_VUNIT,"C6_VALOR")               	       ,; //[5] TOTAL
                                "5YX"                                                             	   ,; //[6] TES
                                SD1->D1_DOC                                                            ,; //[7] NF ORIGINAL
                                SD1->D1_ITEM                                                           ,; //[8] ITEM ORIGINAL
                                SD1->D1_SERIE                                                          ,; //[9] SERIE ORIGINAL
                                SD1->D1_IDENTB6                                                        }) //[10] IDENTB6

                                nSaldoP3   := nSaldoP3-nSaldoDevo
                                nSaldoEst := 0

                            EndIf                                     
                        Endif

                    Elseif nSaldRest <= nSaldoEst .And. nSaldoEst > 0

                            aadd(aItem,{SD1->D1_COD           	    		                           ,; //[1] PRODUTO
                                nSaldRest         	    		                                       ,; //[2] QUANTIDADE
                                A410Arred(SD1->D1_VUNIT,"C6_PRCVEN")         	    		           ,; //[3] PRECO DE VENDA
                                A410Arred(SD1->D1_VUNIT,"C6_PRUNIT")                                   ,; //[4] PRECO UNITARIO
                                A410Arred(nSaldRest*SD1->D1_VUNIT,"C6_VALOR")               	       ,; //[5] TOTAL
                                "5YX"                                                             	   ,; //[6] TES
                                SD1->D1_DOC                                                            ,; //[7] NF ORIGINAL
                                SD1->D1_ITEM                                                           ,; //[8] ITEM ORIGINAL
                                SD1->D1_SERIE                                                          ,; //[9] SERIE ORIGINAL
                                SD1->D1_IDENTB6                                                        }) //[10] IDENTB6

                            nSaldoP3 := nSaldoP3-nSaldRest
                            nSaldoEst := nSaldoEst-nSaldRest
                            nSaldRest := 0
                    
                    Else // Saldo restante maior que o saldo estoque

                            aadd(aItem,{SD1->D1_COD           	    		                           ,; //[1] PRODUTO
                                nSaldoEst         	    		                                       ,; //[2] QUANTIDADE
                                A410Arred(SD1->D1_VUNIT,"C6_PRCVEN")         	    		           ,; //[3] PRECO DE VENDA
                                A410Arred(SD1->D1_VUNIT,"C6_PRUNIT")                                   ,; //[4] PRECO UNITARIO
                                A410Arred(nSaldoEst*SD1->D1_VUNIT,"C6_VALOR")               	       ,; //[5] TOTAL
                                "5YX"                                                             	   ,; //[6] TES
                                SD1->D1_DOC                                                            ,; //[7] NF ORIGINAL
                                SD1->D1_ITEM                                                           ,; //[8] ITEM ORIGINAL
                                SD1->D1_SERIE                                                          ,; //[9] SERIE ORIGINAL
                                SD1->D1_IDENTB6                                                        }) //[10] IDENTB6

                            nSaldoP3 := nSaldoP3-nSaldoEst
                            nSaldoEst := 0

                    Endif  

                    (cAliasSB6)->(dbSkip())

                EndDo       
            EndDo
        Next

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
            aadd(aLinha,{"C6_IDENTB6",aItem[nX][10],Nil})

            If nGerICM == 1
                aadd(aLinha,{"C6_BASICM",aItem[nX][5],Nil})
                aadd(aLinha,{"C6_ALIQICM",18,Nil})
            Endif

            aadd(aItens,aLinha)
        Next nX


        DbselectArea("SA2")
        Dbsetorder(1)
        
        If SA2->(Dbseek(xFilial("SA2") + cFornece + cLoja ))
                FwLogMsg("INFO", /*cTransactionId*/, "REST", FunName(), "", "01","Inicio: "+Time(), 0, (nStart - Seconds()), {})
                cDoc := GetSxeNum("SC5","C5_NUM")
                RollBAckSx8()
                aCabec := {}
                aadd(aCabec,{"C5_NUM"   ,cDoc,Nil})
                aadd(aCabec,{"C5_TIPO" ,"B",Nil})
                aadd(aCabec,{"C5_CLIENTE",SA2->A2_COD,Nil})
                aadd(aCabec,{"C5_LOJACLI",SA2->A2_LOJA,Nil})
                aadd(aCabec,{"C5_LOJAENT",SA2->A2_LOJA,Nil})
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
