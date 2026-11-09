#Include 'Protheus.ch'
// _________________________________________________________________________________________________
//|Quando se referir aos complementos para geracao dos registros C110, C111, C112, C113, C114 e C115|
//|  a tabela CDT também deve ser alimentada, pois ela que efetua o relacionamentos com as outras   |
//|  conforme registro. C110 = Tab. CDT, C111 = Tab. CDG, , C112 = Tab. CDC, C113 = Tab. CDD,       |
//|  C114 = Tab. CDE e C115 = Tab. CDF                                                              |
//|_________________________________________________________________________________________________|*/

User Function MATUCOMP()

	Local cEntSai  := ParamIXB[1]
	Local cSerie   := ParamIXB[2]
	Local cDoc     := ParamIXB[3]
	Local cClieFor := ParamIXB[4]
	Local cLoja    := ParamIXB[5]
	Local cIfComp  := ""

	// Posiciona CDT
	If CDT->(dbSeek(xFilial("CDT") + cEntSai + cDoc + cSerie + cClieFor + cLoja))

		cIfComp := CDT->CDT_IFCOMP

		// Posiciona primeiro registro CDD
		If CDD->(dbSeek(xFilial("CDD") + cEntSai + cDoc + cSerie + cClieFor + cLoja))

			While !CDD->(Eof()) .And. ;
			      CDD->CDD_FILIAL == xFilial("CDD") .And. ;
			      CDD->CDD_TPMOV  == cEntSai .And. ;
			      CDD->CDD_DOC    == cDoc .And. ;
			      CDD->CDD_SERIE  == cSerie .And. ;
			      CDD->CDD_CLIFOR == cClieFor .And. ;
			      CDD->CDD_LOJA   == cLoja

				If Empty(CDD->CDD_IFCOMP)

					RecLock("CDD", .F.)
						CDD->CDD_IFCOMP := cIfComp
					MsUnlock()

				EndIf

				CDD->(DbSkip())

			EndDo

		EndIf

	EndIf

Return
