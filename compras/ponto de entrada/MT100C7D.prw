#include "Protheus.ch"

/*
 Desc	: ADICIONA ITENS NA CONSULTA F4 (PED COM). Ponto Entrada MT100C7D e MT100C7C para manipulacao da consulta <F6> no MATA100/MATA103 
 		para consulta de Pedidos de Compra em aberto.
 Data	: 24/04/2013
 Autor	: Thiago Teotonio
*/

User Function MT100C7D
aDet := ParamIxb
Aadd(aDet, SC7->C7_DATPRF)
Aadd(aDet, SC7->C7_PRECO)

Return(aDet)
                                         	
                                                           	
User Function MT100C7C
aDet := ParamIxb
Aadd(aDet, RetTitle("C7_DATPRF"))
Aadd(aDet, RetTitle("C7_PRECO"))

Return(aDet)
