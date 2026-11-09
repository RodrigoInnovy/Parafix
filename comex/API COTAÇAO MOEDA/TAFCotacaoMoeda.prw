#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*/{Protheus.doc} TAFCotacaoMoeda
@author Tiago Rossini Coradini
@since 20/01/2020
@version 1.0
@description Classe para tratamento de Cotacoes de Moedas Automaticamente
@type class
/*/

Class TAFCotacaoMoeda From LongClassName
	
	Data nDolarc
	Data nDolarv
	Data nEuroc
	Data nEurov
	Data dData
	Data oBcb
	
	Method New() Constructor
	Method Insert()
	Method AddSM2()
	Method AddCTP()
	Method AddSYE()
	Method GetUSD()
	Method GetEUR()
	
EndClass


Method New() Class TAFCotacaoMoeda

	::nDolarc := 0
	::nDolarv := 0
	::nEuroc := 0
	::nEurov := 0
	::dData := DataValida(DaySub(dDatabase, 1), .F.)
	::oBcb := TAFMoedaBancoCentral():New()

Return()


Method Insert() Class TAFCotacaoMoeda

	::GetUSD()

	::GetEUR()
	
	If (::nDolarc > 0 .And. ::nEuroc > 0) .And. (::nDolarv > 0 .And. ::nEurov > 0)
	
		Begin Transaction
		
			::AddSM2()
			
			::AddCTP()
			
			::AddSYE()
		
		End Transaction
	EndIf 
	
Return()


Method AddSM2() Class TAFCotacaoMoeda
Local lInsert := .T.
	
	DbSelectArea("SM2")
	SM2->(DbSetOrder(1))
	
	lInsert := !SM2->(DbSeek(dToS(dDatabase)))
	
	RecLock("SM2", lInsert)

		SM2->M2_DATA := dDatabase
		SM2->M2_MOEDA2 := ::nDolarc
		SM2->M2_MOEDA3 := ::nEuroc
	
	SM2->(MsUnLock())

Return()


Method AddCTP() Class TAFCotacaoMoeda
Local lInsert := .T.

	DbSelectArea("CTP")
	CTP->(DbSetOrder(1))

	lInsert := !CTP->(DbSeek(xFilial("CTP") + dToS(dDataBase) + "02"))
			
	RecLock("CTP", lInsert)

		CTP->CTP_FILIAL := xFilial("CTP")
		CTP->CTP_DATA := dDataBase
		CTP->CTP_MOEDA := "02" 
		CTP->CTP_TAXA := ::nDolarc
		CTP->CTP_BLOQ := "2"
	
	CTP->(MsUnLock())
	
	lInsert := !CTP->(DbSeek(xFilial("CTP") + dToS(dDataBase) + "03"))
			
	RecLock("CTP", lInsert)

		CTP->CTP_FILIAL := xFilial("CTP")
		CTP->CTP_DATA := dDataBase
		CTP->CTP_MOEDA := "03" 
		CTP->CTP_TAXA := ::nEuroc
		CTP->CTP_BLOQ := "2"
	
	CTP->(MsUnLock())	
			
Return()


Method AddSYE() Class TAFCotacaoMoeda
Local lInsert := .T.

	DbSelectArea("SYE")
	SYE->(DbSetOrder(1))

	lInsert := !SYE->(DbSeek(xFilial("SYE") + dToS(dDataBase) + "US$"))
			
	RecLock("SYE", lInsert)

		SYE->YE_FILIAL := xFilial("SYE")
		SYE->YE_DATA := dDataBase
		SYE->YE_MOEDA := "US$"
		SYE->YE_MOE_FIN := "2"
		SYE->YE_VLCON_C := ::nDolarv
		SYE->YE_VLFISCA := ::nDolarv
		SYE->YE_TX_COMP := ::nDolarc
	
	SYE->(MsUnLock())
	
	lInsert := !SYE->(DbSeek(xFilial("SYE") + dToS(dDataBase) + "EUR"))
			
	RecLock("SYE", lInsert)

		SYE->YE_FILIAL := xFilial("SYE")
		SYE->YE_DATA := dDataBase
		SYE->YE_MOEDA := "EUR"
		SYE->YE_MOE_FIN := "3"
		SYE->YE_VLCON_C := ::nEurov
		SYE->YE_VLFISCA := ::nEurov
		SYE->YE_TX_COMP := ::nEuroc
	
	SYE->(MsUnLock())	

Return()


Method GetUSD() Class TAFCotacaoMoeda

	::oBcb:cMoeda := "USD"
	::oBcb:cData := Month2Str(::dData) + "-" + Day2Str(::dData) + "-" + Year2Str(::dData)
	
	If ::oBcb:Request()
	
		::nDolarc := ::oBcb:nValorc 
		::nDolarv := ::oBcb:nValorv 
	
	EndIf

Return()


Method GetEUR() Class TAFCotacaoMoeda
	
	::oBcb:cMoeda := "EUR"
	::oBcb:cData := Month2Str(::dData) + "-" + Day2Str(::dData) + "-" + Year2Str(::dData)
	
	If ::oBcb:Request()
	
		::nEuroc := ::oBcb:nValorc
		::nEurov := ::oBcb:nValorv  
	
	EndIf
	
Return()
