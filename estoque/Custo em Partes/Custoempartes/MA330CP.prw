// Ponto de entrada usado para configuração de custo em partes
// Criado por Alexander P. Silva em 12/04/2023


#include "rwmake.ch"

User Function MA330CP ()

LOCAL aRegraCP:={}

AADD(aRegraCP,"SB1->B1_TIPO $ 'MP-EM-SV-MS-MA-PM-ME'") 	// PARTE  1 - Material Direto 
AADD(aRegraCP,"SB1->B1_TIPO == 'MO'")   	// PARTE  2 - MÃO DE OBRA  

// PARTE 03 - Outros.

Return aRegraCP
