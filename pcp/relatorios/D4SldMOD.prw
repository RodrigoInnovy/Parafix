#include "Protheus.ch"
#include "TopConn.ch"

// Programa para Calculo do Saldo da MOD, utilizado no Relatorio RPM - Rel. Programação de Maquina
// Clember - 02/08//2016

User Function D4SldMOD(cOP)

Local nQtdSaldo := 0
Local cQry 		:= ""

cQry := "SELECT D4_FILIAL, D4_OP, SUM(D4_QUANT) AS D4_QUANT FROM " + RetSqlName("SD4")
cQry += " WHERE D_E_L_E_T_ = ' ' AND D4_FILIAL = '"+xFilial("SD4")+"' " 
cQry += " AND D4_OP = '"+cOP+"' " 
cQry += " AND LEFT(D4_COD,3) = 'MOD' " 
cQry += " GROUP BY D4_FILIAL, D4_OP " 

TCQuery ChangeQuery(cQry) New Alias "TMPSD4"

DBSelectArea("TMPSD4")

nQtdSaldo := TMPSD4->D4_QUANT

TMPSD4->(DBCloseArea())

Return nQtdSaldo

