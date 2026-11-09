#include "rwmake.ch"
//  PROGRAMA GRAVAR AS INFORMACOES COMPLEMENTARES
//  CNAB BRADESCO A PAGAR (PAGFOR) - POSICOES (374-413)
User Function PagDoc()
   _Mod    := SEA->EA_MODELO
   _Doc    := space(40)
   _CodBar := SE2->E2_CODBAR
   _Banco  := left(_CodBar,3)
   _Moeda  := substr(_CodBar,4,1)  
   _Livre  := ""
   if empty(_Mod)
      _Mod := iif( _Banco == "237","30","31")
   endif
   do case
      case _Mod == "31"
           if len(trim(_CodBar)) > 44 .or. len(trim(_CodBar)) < 44
               // dados complementares da linha digitável
              _Livre  := substr(_CodBar,05,05) + substr(_CodBar,11,10) + substr(_CodBar,22,10)
              _Digito := substr(_CodBar,33,1)
              _Doc    := _Livre  + _Digito  + _Moeda + space(13)
           elseif len(trim(_CodBar)) == 44 
              // dados complementares do codigo de barras
              _Livre  := substr(_CodBar,20,25)
              _Digito := substr(_CodBar,05,1)
              _Doc    :=  _Livre  + _Digito + _Moeda + space(13)
           endif       
      case _Mod == "30"
			_Doc := PADR(" ",40)		     
   endcase
   _Mod := ""
Return(_Doc)
