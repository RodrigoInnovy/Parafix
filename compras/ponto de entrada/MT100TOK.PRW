#include "PROTHEUS.CH"
#include "TOTVS.CH"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    MT100TOK ³ Autor ³ Lucas Silva	        ³ Data ³10/01/2023 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Ponto de entrada para validação dos itens do documento       ³±±			  
±±³          ³de Entrada                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
/*/

//Ponto de entrada que informa se está sem centro de custo para grupo de contas (32 / 33) na hora de gravar o documento de entrada
/*
Contas contábeis que comecem com “33xxxx” devem ter o centro de custo que comece com “12xxxx” ou “13xxxx”;

Contas contábeis que comecem com “32xxxx” devem ter o centro de custo que comece com “11xxxx”.


Inicialmente as contas abaixo não devem ter o centro de custos como obrigatório .

Conta                   Descrição
32010104            custo dos insumos adquiridos a prazo no mercado interno
32010105            custo dos insumos adquiridos a prazo no mercado externo
32019801            custo dos bens produzidos - m.o.d.
32019802            custo dos bens produzidos
32019901            custo dos produtos vendidos
32020102            compra de mercadorias a vista no mercado interno
32020103            compra de mercadorias a vista no mercado externo
32020104            compra de mercadorias a prazo no mercado interno
32020105            compra de mercadorias a prazo no mercado externo
32020204            revenda de insumos adquiridos a prazo no mercado interno
32020205            revenda de insumos adquiridos a prazo no mercado externo


*/

User function MT100TOK()

	local cReturn := .T.
	Local _nCC  // centro de custo da primeira linha.
	Local cconta
	local nrateio
	local nItemc
	Local nJ
	Local cCont := 0

	if IsInCallStack('SPEDNFE')
		cReturn := .T.
	else

		For nJ:= 1 To Len(aCols)

			_nCC    := acols[nJ][42]
			cconta  := substr(acols[nJ][39],1,2)
			nrateio := acols[nJ][71]
			nItemc	:= acols[nJ][41]





// Lucas Silva - Alterado operadores IF para Do CASE 10/02/2023
			if nrateio = "2"
				DO CASE



				CASE Empty(_nCC) .AND. cconta $ "32,33"
					MsgAlert('Informar o Centro de Custo para a classificação do Item: '+ acols[nJ][1] +' ou valide o Item contabil', 'Atenção')
					cReturn := .F.
					//cCont++

				CASE cconta $ "33" .AND. !SUBSTR(_nCC,1,2) $ "12,13,19" .AND. Empty(nItemc)

					MsgAlert('Contas contábeis que comece com 33xxxx devem conter o centro de custo que comece com 12xxxx ou 13xxxx ou 19xxxx e Item contabil informado, Item: '+ acols[nJ][1] +'' , 'Atenção')
					cReturn := .F.
					//cCont++

				CASE cconta $ "32" .AND. !SUBSTR(_nCC,1,2) $ "11,19" .AND. Empty(nItemc)

					MsgAlert('Contas contábeis que comece com 32xxxx devem conter o centro de custo que comece com 11xxxx ou 19xxxx e Item contabil informado, , Item: '+ acols[nJ][1] +'', 'Atenção')
					cReturn := .F.
					//cCont++

				CASE cconta $ "11" .AND. !EMPTY( _nCC )

					MsgAlert('Contas contábeis que comece com 11xxxx devem conter o centro de custo vazio, , Item: '+ acols[nJ][1] +'', 'Atenção')
					cReturn := .F.
					//cCont++



					//OTHERWISE

					//cReturn := .T.
				ENDCASE

				//Valida se a variavel cCont foi incrementada para tratar o retorno
				/*
				IF cCont <> 0

					cReturn := .F.

				ELSE

					cReturn := .T.

				ENDIF
				*/

			endif
		next
	endif


Return cReturn

