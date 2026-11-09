#INCLUDE "Protheus.ch"

User Function GatPreco2(cCampo)
local nRet 		:= 0
local nPosQtd 	:= 0 
local nPosQtd2 	:= 0 
local nPosPrc 	:= 0 
local nPosPrc2 	:= 0 
local nPosTot 	:= 0 
IF FUNNAME() == "MATA410" .and. cCampo == "C6_PRC2UN"
	nPosQtd 	:= GDFIELDPOS("C6_QTDVEN")
	nPosQtd2 	:= GDFIELDPOS("C6_UNSVEN")
	nPosPrc 	:= GDFIELDPOS("C6_PRCVEN") 
	nPosPrc2 	:= GDFIELDPOS("C6_PRC2UN")
	nPosTot 	:= GDFIELDPOS("C6_TOTAL")
	
	nRet := acols[n][nPosTot]/acols[n][nPosQtd]	
	nRet := nRet 
	
ENDIF
Return