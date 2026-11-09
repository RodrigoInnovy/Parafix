#Include "Protheus.ch"
#DEFINE USADO CHR(0)+CHR(0)+CHR(1)    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³PE para inclusão do campo OP no aCOls³
//³                                     ³
//³Autor: Rodrigo Bighetti              ³
//³Data: 13/12/2011                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ      
// Alteracoes realizadas
// Felipe Campos - 30/03/11 -  Inclusao das informacoes de RNC conforme solicitacao do Sr. Adriano Lopes

User Function MA261CPO()
	Local aArea := GetArea()
	Local aTam  := {} 
	
	dbSelectArea("SX3")
	dbSetOrder(2)
	dbSeek("D3_ZZOP")
	
	aTam := TamSX3("D3_ZZOP")
//	aAdd(aHeader, {SX3->X3_TITULO, SX3->X3_CAMPO, PesqPict("SD3", "D3_ZZOP"), aTam[1], aTam[1], aTam[2], "", SX3->X3_USADO, SX3->X3_TIPO, "SD3",""})
	aAdd(aHeader, {getSX3Cache("D3_ZZOP", "X3_TITULO"), getSX3Cache("D3_ZZOP", "X3_CAMPO"), PesqPict("SD3", "D3_ZZOP", aTam[1]), aTam[1], aTam[2], "", getSX3Cache("D3_ZZOP", "X3_USADO"), getSX3Cache("D3_ZZOP", "X3_TIPO"), "SD3",""})
	
	dbSeek("D3_SEGUM")
	aTam2 := TamSX3("D3_SEGUM")
//	aAdd(aHeader, {SX3->X3_TITULO, SX3->X3_CAMPO, PesqPict("SD3", "D3_SEGUM"), aTam2[1], aTam2[1], aTam2[2], "", SX3->X3_USADO, SX3->X3_TIPO, "SD3",""}) 
	aAdd(aHeader, {getSX3Cache("D3_SEGUM", "X3_TITULO"), getSX3Cache("D3_SEGUM", "X3_CAMPO"), PesqPict("SD3", "D3_SEGUM", aTam2[1]), aTam2[1], aTam2[2], "", getSX3Cache("D3_SEGUM", "X3_USADO"),getSX3Cache("D3_SEGUM", "X3_TIPO"), "SD3",""})  
	                                                                                                                                          
	dbSeek("D3_ZZRNC")
	aTam3 := TamSX3("D3_ZZRNC")
	aAdd(aHeader, {getSX3Cache("D3_ZZRNC", "X3_TITULO"), getSX3Cache("D3_ZZRNC", "X3_CAMPO"), PesqPict("SD3", "D3_ZZRNC", aTam3[1]), aTam3[1], aTam3[2], "", getSX3Cache("D3_ZZRNC", "X3_USADO"), getSX3Cache("D3_ZZRNC", "X3_TIPO"), "SD3",""})      

	dbSeek("D3_ZZRNCOB")
	aTam4 := TamSX3("D3_ZZRNCOB")
	aAdd(aHeader, {getSX3Cache("D3_ZZRNCOB", "X3_TITULO"), getSX3Cache("D3_ZZRNCOB", "X3_CAMPO"), PesqPict("SD3", "D3_ZZRNCOB", aTam4[1]), aTam4[1], aTam4[2], "", getSX3Cache("D3_ZZRNCOB", "X3_USADO"),getSX3Cache("D3_ZZRNCOB", "X3_TIPO"), "SD3",""})      

	dbSeek("D3_ZZRNCVA")
    aTam5 := TamSX3("D3_ZZRNCVA")
    aAdd(aHeader, {getSX3Cache("D3_ZZRNCVA", "X3_TITULO"), getSX3Cache("D3_ZZRNCVA", "X3_CAMPO"), PesqPict("SD3", "D3_ZZRNCVA", aTam5[1]), aTam5[1], aTam5[2], "", getSX3Cache("D3_ZZRNCVA", "X3_USADO"),getSX3Cache("D3_ZZRNCVA", "X3_TIPO"), "SD3",""})  
    
    dbSeek("D3_ZZRASTR")// Criado Por Gabriel Araujo
    aTam6 := TamSX3("D3_ZZRASTR")
    aAdd(aHeader, {getSX3Cache("D3_ZZRASTR", "X3_TITULO"), getSX3Cache("D3_ZZRASTR", "X3_TIPO"), PesqPict("SD3", "D3_ZZRASTR", aTam6[1]), aTam6[1], aTam6[2], "", getSX3Cache("D3_ZZRASTR", "X3_USADO"), getSX3Cache("D3_ZZRASTR", "X3_TIPO"), "SD3",""})      
	
	RestArea(aArea)

Return nil