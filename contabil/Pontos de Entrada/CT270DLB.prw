# include "protheus.ch"            

/**
* Função        : CT270DLB
* Autor         : Tuning Sistemas - Clember Gaino Pinheiro 
* Data          : 02/07/2015
* Descrição     : O ponto de entrada CT270DLB é adicionado para permitir a customização dos botões do Rateio Off-Line.
*                
* Parametros    : NA
*
* Retorno       : NA
*
* Observações:
*
*/

User Function CT270DLB ()

Local aBtn := {}

aBtn :={{"FERRAM" ,{|| U_CTBA0001()} ,"Calc. %" }}

Return aBtn