#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ MOD11Base7 บ Autor ณSilverto T. Hayakawaบ Data ณago/14/2008บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Calculo do digito de controle modulo 11 para o Bradesco    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Mod11Base7(_cData,_nSize)
   _Base  := 7
   _cRet  := ""
   _nTam  := len(_cData)
   _nCalc := _nDig := 0
   _nPeso := 1
   for _nI:=_nTam to 1 step -1
      _nPeso++
      _nCalc += val(substr(_cData,_nI,1)) * _nPeso
      if _nPeso == _Base
         _nPeso := 1
      endif
   next
   _nDig := _nCalc%11
   if _nDig < 2
      _nDig := 0 // ou "P"
   else
      _nDig := 11 - _nDig
   endif
   _cRet := Padl(_cData + str(_nDig,1),_nSize,"0")
Return(_cRet)

/*
User Function Mod11Base9(_cData,_nSize)
   _Base  := 9
   _cRet  := ""
   _nTam  := len(_cData)
   _nDig  := 0
   _nPeso := 1
   for _nI:=_nTam to 1 step -1
      _nPeso++
      _nDig += val(substr(_cData,_nI,1)) * _nPeso
      if _nPeso == _Base
         _nPeso := 1
      endif
   next
   if (_nDig<>0) .and. (_nDig<>9) .and. (_nDig>9)
      _nDig := 11 - (mod(_nDig,11))
   else
      _nDig := 1
   endif
   _cRet := Padl(_cData + str(_nDig,1),_nSize,"0")
Return(_cRet)
*/