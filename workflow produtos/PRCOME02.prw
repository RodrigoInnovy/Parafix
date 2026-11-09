#Include "Protheus.ch"
#Include "Ap5Mail.ch"

/*/{Protheus.doc} PRCOME02
Valida liberação do campo B1_MSBLQL
@type function
@author Parafix
@since 14/04/2022
/*/

User Function PRCOME02()
	Local aArea      := GetArea()
	Local aAreaSB1   := SB1->(GetArea())
	Local lDesenv    := (M->B1_ZDEV == "1")
	Local lCompras   := (M->B1_ZCOM == "1")
	Local lFiscal    := (M->B1_ZFIS == "1")
	Local lVendas    := (M->B1_ZVEN == "1")
	Local lQualidade := (M->B1_ZQUA == "1")
	Local lComex     := (M->B1_ZPCP == "1")
	Local lProcessos := (M->B1_ZPRO == "1")
	Local lPCP     := (M->B1_ZCMX == "1")
    Local lRet       := .T.

    If (M->B1_MSBLQL == "2")
        lRet := (lDesenv .And. lCompras .And. lFiscal .And. lVendas .And. lQualidade .And. lComex .And. lProcessos .And. lPCP)
    Endif

	RestArea(aAreaSB1)
	RestArea(aArea)
Return(lRet)
