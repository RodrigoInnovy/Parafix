#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณM020INC  บ Autor ณ J.DONIZETE R.SILVA บ Data ณ  29/01/04    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Ponto de Entrada p/ para cria็ใo automatica da Conta Conta-บฑฑ
ฑฑบ          ณ bil do Fornecedor conforme inclusao do mesmo.              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Cadastro de Fornecedores                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบData      ณ Altera็๕es                                                 บฑฑ
ฑฑบ23/12/2006ณ - Adaptado do modelo desenvolvido pelo Vitor L.Fattori     บฑฑ
ฑฑบ          ณ                                                             ฑฑ
ฑฑบ12/02/2008ณ - Alterado por Donizete                                    บฑฑ
ฑฑบ          ณ Incorporado tratamento para compartilhamento de arquivos.   ฑฑ
ฑฑบ          ณajustado nome de variแveis e igualado ao programa de carga   ฑฑ
ฑฑบ          ณde clientes/fornecedores, corre็ใo de pequenos erros.        ฑฑ
ฑฑบ          ณ                                                             ฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
User Function M020INC()

// Chama rotina comum ao SA1/SA2 para cria็ใo de contas.
	If INCLUI
		U_CTBINCFC("2")
	EndIf

	Return
