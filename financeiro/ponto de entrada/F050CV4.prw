#INCLUDE "rwmake.ch"
#Include 'Protheus.ch'


// Ponto de entrada para gravar a conta Debito e conta credito para a tabela CV4
// Apos a gravação a contabilização busca os campos preenchidos

User Function F050CV4

local contadeb 
local contcredit 




contadeb := POSICIONE("CTJ",1,XFILIAL("CTJ")+CTJ->CTJ_RATEIO+SUBSTR(CV4_ITSEQ,4),"CTJ_DEBITO")
contcredit := POSICIONE("CTJ",1,XFILIAL("CTJ")+CTJ->CTJ_RATEIO+SUBSTR(CV4_ITSEQ,4),"CTJ_CREDIT")

RecLock("CV4", .F. )

CV4->CV4_DEBITO	:= contadeb 
CV4->CV4_CREDIT	:= contcredit 

MsUnlock()



Return



