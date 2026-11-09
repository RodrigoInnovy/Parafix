#Include "Totvs.ch"

/**
* Rotina		:	Tk271End - PARAFIX
* Autor			:	Leandro Camaçari - FSW TOTVS IP CAMPINAS.
* Data			:   18/07/2013
* Descricao		:	Ponto de Entrada executado no final da gravação, ao dar um OK na tela de atendimento e 
* 				:	após a gravação da campanha (caso exista uma).
* Modulo		:	TMK
*/
User Function Tk271End()     

Local cOper := ""
Local cBack := ""

cOper := SUA->UA_OPER
//cBack := SUA->UA_ZZB2B

If Alltrim(cOper) == "3" //.AND. Alltrim(cBack) == "2"  //cBack 2 = Não    
    && Impressão do Orçamento 
    U_fImpOrc()

    && Gera Pedido de Compra
   	U_fGeraPC()
EndIf  
                      
If Alltrim(cOper) == "2"  //Amostra
    && Gera Pedido de Venda 
    U_fGeraPV()   
EndIf 
	                     
If Alltrim(cOper) == "3" .AND. Alltrim(cBack) == "1"   //cBack 1 = Sim   
    && Gera Pedido de Compra
   	U_fGeraPC()
EndIf
     
If Alltrim(cOper) == "1"  //Pedido de Venda Padrão    
    && Atualiza Pedido de Venda Padrão
    U_AtuPVPad()     
EndIf    
     

Return  
