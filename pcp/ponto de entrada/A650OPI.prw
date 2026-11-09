//********************************************************************************************
// Fonte onde sistema não abre a OP dos PI´s automaticamente conforme o parametro MV_GERAOPI
// 28/03/2022
//********************************************************************************************

#INCLUDE 'TOTVS.CH'
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'
#INCLUDE "RWMAKE.CH"
 
USER FUNCTION A650OPI()
Local aItem := aCols[PARAMIXB] //Linha da grid que está sendo processada no momento.
Local lRet  := .F.
     
Return lRet
