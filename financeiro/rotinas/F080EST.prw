#Include "Protheus.ch"
#Include "TopConn.ch"

/**                                                                               
* Rotina		:	F080EST - PARAFIX
* Autor		    :	Leandro Camaçari - FSW TOTVS IP CAMPINAS
* Data			:	13/12/2013
* Descricao	    :	Ponto de Entrada será utilizado após a geração do lançamento de estorno no SE5 para gravar informações complementares 
				:	referentes ao cancelamento da baixa do Contas à Pagar.
* Modulo		:	SIGAFIN
* Observações	:	
*/                    

User Function F080EST()

Local aArea         := GetArea()  
Local cEof		    := chr(13)+chr(10)
Local nValZZVLMD1   := 0
Local nValZZVARC    := 0    
Local cPrefixo      := ""
Local cNumero       := ""
Local cParcela      := ""
Local cTipo         := ""
Local cFornece      := ""
Local cLoja         := ""
Local cSeq          := "" 

cPrefixo  := SE5->E5_PREFIXO
cNumero   := SE5->E5_NUMERO
cParcela  := SE5->E5_PARCELA
cTipo     := SE5->E5_TIPO
cFornece  := SE5->E5_CLIFOR
cLoja     := SE5->E5_LOJA
cSeq      := SE5->E5_SEQ

&& Posicionando no Título Pai
DbSelectArea("SE5")
SE5->(dbSetOrder(7))
If DbSeek(xFilial("SE5")+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA+SE5->E5_SEQ)    
    
    If SE5->E5_MOEDA == "02"  .AND. SE5->E5_RECPAG == "P" 

	    nValZZVLMD1 :=  SE5->E5_ZZVLMD1
	    nValZZVARC  :=  SE5->E5_ZZVARC
	
	EndIf
	
EndIf 
    
&& Encontrando o Título Filho
cQuery := "SELECT E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_TIPO, E5_CLIFOR, E5_LOJA, E5_SEQ, E5_DATA "+cEof
				
cQuery += "	FROM "+RetSqlTab("SE5")+" " +cEof
cQuery += "	WHERE E5_FILIAL = '"+xFilial("SE5")+"'"+cEof
cQuery += "	AND E5_NUMERO = '"+Alltrim(cNumero)+"'"+cEof
cQuery += " AND E5_PREFIXO = '"+Alltrim(cPrefixo)+"'"+cEof    
cQuery += " AND E5_PARCELA = '"+Alltrim(cParcela)+"'"+cEof    
cQuery += " AND E5_TIPO = '"+Alltrim(cTipo)+"'"+cEof    
cQuery += " AND E5_CLIFOR = '"+Alltrim(cFornece)+"'"+cEof    
cQuery += " AND E5_LOJA = '"+Alltrim(cLoja)+"'"+cEof  
cQuery += " AND E5_SEQ = '"+Alltrim(cSeq)+"'"+cEof   

cQuery += " AND E5_MOEDA = '' "+cEof   
cQuery += " AND E5_RECPAG = 'R' "+cEof   
cQuery += " AND E5_TIPODOC = 'ES' "+cEof   

cQuery += "	AND	SE5.D_E_L_E_T_ = ''"+cEof
				
MemoWrite("c:\temp\sql.txt",cQuery)
cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"qSE5",.T.,.T.)

                       
&& Posicionando no Título Filho
DbSelectArea("SE5")
SE5->(dbSetOrder(2))
If DbSeek(xFilial("SE5")+"ES"+qSE5->E5_PREFIXO+qSE5->E5_NUMERO+qSE5->E5_PARCELA+qSE5->E5_TIPO+qSE5->E5_DATA+qSE5->E5_CLIFOR+qSE5->E5_LOJA+qSE5->E5_SEQ)                                                            

    && Gravando as informações complementares na tabela SE5 para o novo título
    RecLock("SE5",.F.)   
        SE5->E5_ZZVLMD1 := nValZZVLMD1
        SE5->E5_ZZVARC  := nValZZVARC  
    SE5->(MsUnLock())

EndIf

SE5->(DbCloseArea())
qSE5->(DbCloseArea())
RestArea( aArea )

Return Nil