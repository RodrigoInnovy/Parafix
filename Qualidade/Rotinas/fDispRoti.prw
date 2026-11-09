#include 'totvs.ch'
#include 'topconn.ch'
#include 'fileio.ch'
#include 'msobject.ch'

User Function fDispRoti()

	Local aRet 			:= {}
	Local aParamBox 	:= {}

	AADD(aParamBox,{1,"Nome da rotina", Space(50), "@!", "", "", "", 100, .T.})

	While ParamBox (aParamBox, "Executar rotina", @aRet,,,,,,, "fDispRoti", .T., .T.)
		EXECBLOCK(MV_PAR01)
    EndDo

Return
