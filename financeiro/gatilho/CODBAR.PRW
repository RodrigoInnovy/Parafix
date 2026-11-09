#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 13/06/01

User Function codbar()        // incluido pelo assistente de conversao do AP5 IDE em 13/06/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
//?Declaracao de variaveis utilizadas no programa atraves da funcao    ?
//?SetPrvt, que criara somente as variaveis definidas pelo usuario,    ?
//?identificando as variaveis publicas do sistema utilizadas no codigo ?
//?Incluido pelo assistente de conversao do AP5 IDE                    ?
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?

SetPrvt("_CRETORNO,")

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±?
±±?un‡…o    ?RPCODBAR ?Autor ?Patricia P. Santos    ?Data ?08/11/99 ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±?
±±?escri‡…o ?Converte Cod. Barras p/ Linha Digitavel e o contrario      ³±?
±±?         ?Desenvolvido para ROYALPLAS- Gatilho                       ³±?
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±?
±±?lteacao  ?Alterado em 20/09/00 para validar novo padrao de Codigo de ³±?
±±?         ?Barras da FEBRABAN de 01/09/00 -  Ajustado Luciano Barbosa 28/08/19        ³±?
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±?
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±?
/*/

_cRetorno := ""

// Tem linha digitavel e nao tem codigo de barras
If EMPTY(M->E2_CODBAR) .and. !EMPTY(M->E2_LINDIG)    // Preenche cod. barras
   // Cod. Barras nao tem digitos verificadores
   IF LEN(ALLTRIM(M->E2_LINDIG))==47
      _cRetorno := Substr(M->E2_LINDIG,1,4) + ;             // BANCO + MOEDA
      Substr(M->E2_LINDIG,33,1) + ;                      // DV GERAL
      Substr(M->E2_LINDIG,34,4) + ;                       // FATOR VENCIMENTO
      StrZero(Val(Alltrim(Substr(M->E2_LINDIG,38,10))),10) + ; // VALOR
      Substr(M->E2_LINDIG,5,5) + ;                              // CAMPO LIVRE
      Substr(M->E2_LINDIG,11,10) + ;
      Substr(M->E2_LINDIG,22,10)
    ELSE
      _cRetorno := Substr(M->E2_LINDIG,1,11) + ;             // 12
      Substr(M->E2_LINDIG,13,11) + ;                      // 24
      Substr(M->E2_LINDIG,25,11) + ;                // 36
      Substr(M->E2_LINDIG,37,11)                   // 48      
    ENDIF
EndIf

// Substituido pelo assistente de conversao do AP5 IDE em 13/06/01 ==> __Return(_cRetorno)
Return(_cRetorno)        // incluido pelo assistente de conversao do AP5 IDE em 13/06/01

