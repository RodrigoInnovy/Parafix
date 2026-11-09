#Include "RWMAKE.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO2     บAutor  ณUbiratan da Silva   บ Data ณ  03/04/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Validacao da digitacao da linha digitavel do Boleto       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP 10.1                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function Vldcodbar(c_cod)

Local c_cod1 := subs(c_cod,1 ,9)
Local c_cod2 := subs(c_cod,11 ,10)
Local c_cod3 := subs(c_cod,22, 10)
Local c_codv
Local c_codg
Local l_dvs := .t.

If len(alltrim(subs(c_cod, 34, 14))) < 14
	c_cod := subs(c_cod, 1, 34) + repl("0", 14 - len(alltrim(subs(c_cod, 34, 14)))) + alltrim(subs(c_cod, 34, 14))
EndIf

c_codv := subs(c_cod, 34, 14)

l_dvs := subs(c_cod, 10, 1) == _digver(c_cod1)
If l_dvs
	l_dvs := subs(c_cod, 21, 1) == _digver(c_cod2)
EndIf
If l_dvs
	l_dvs := subs(c_cod, 32, 1) == _digver(c_cod3)
EndIf

c_codg := subs(c_cod, 1, 4) + c_codv + subs(c_cod, 5, 5) + subs(c_cod, 11, 10) + subs(c_cod, 22, 10)

If l_dvs
	l_dvs := subs(c_cod, 33, 1) == _digverg(c_codg)
EndIf
If ! l_dvs
	MsgBox("O Codigo de Barras estแ invแlido", "AVISO", "ALERT")
EndIf	

Return(l_dvs)  


Static Function _digver(c_codx)

Local n_vz
Local n_fat := 1                           
Local n_tot := 0
Local n_ret    
Local c_vx 
Local n_pos := Len(c_codx)

For n_vz := 1 to Len(c_codx)
	n_fat ++
	c_vx := strzero(val(subs(c_codx, n_pos, 1)) * n_fat, 2, 0)
	n_tot += val(subs(c_vx, 1, 1)) + val(subs(c_vx, 2, 1))
	n_pos := n_pos - 1
	n_fat := iif(n_fat == 2, 0, n_fat)
Next

n_ret := Iif(mod(n_tot, 10) == 10, 0, 10 - mod(n_tot, 10))

Return(str(n_ret,1,0))	
	

Static Function _digverg(c_codx)

Local n_vz
Local n_fat := 1                           
Local n_tot := 0
Local n_ret    
Local c_vx 
Local n_pos := Len(c_codx)

For n_vz := 1 to Len(c_codx)
	n_fat ++
	c_vx := val(subs(c_codx, n_pos, 1)) * n_fat
	n_tot += c_vx
	n_pos := n_pos - 1
	n_fat := iif(n_fat == 9, 1, n_fat)
Next

n_ret := Iif(str(mod(n_tot, 11),2,0) $ (" 0_ 1_10"), 1, 11 - mod(n_tot, 11))

Return(str(n_ret,1,0))

