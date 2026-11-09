// Ponto de entrada que preenche o registro 1601 com o Intermediador Financeiro - Vinicius.
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.ch"
  
User Function SPED1601()
  
    Local aReg1601  := {}
    Local dDataDe   := Iif(Len(paramixb) >= 1 , paramixb[1], ctod("  /  /  "))
    Local dDataAte  := Iif(Len(paramixb) >= 2 , paramixb[2], ctod("  /  /  "))
    Local cQuery    := ""
    Local cCOD_PART_IP := ''

  
    cQuery := " SELECT "
    cQuery += "     F2_FILIAL AS FILIAL,A1U_CODIGO AS COD_PART_IP,F2_CODA1U AS INTERMEDIADOR,"
    cQuery += "     CASE WHEN SUM(SF2.F2_VALICM) <> 0 THEN SUM(F2_VALBRUT) ELSE 0 END AS TOT_VS,"
    cQuery += "     CASE WHEN SUM(SF2.F2_VALISS) <> 0 THEN SUM(F2_VALBRUT) ELSE 0 END AS TOT_ISS,"
    cQuery += "     CASE WHEN SUM(SF2.F2_VALISS) = 0 AND SUM(SF2.F2_VALICM)= 0 THEN SUM(F2_VALBRUT) ELSE 0 END AS TOT_OUT "
    cQuery += " FROM SF2010 SF2 INNER JOIN A1U010 A1U ON A1U.A1U_CODIGO = F2_CODA1U AND A1U.D_E_L_E_T_ = '' "
    cQuery += " WHERE F2_EMISSAO BETWEEN '" + DTOS(dDataDe) + "' AND '" + DTOS(dDataAte) + "' "
    cQuery += "     AND SF2.D_E_L_E_T_ = ' ' "
    cQuery += " GROUP BY F2_FILIAL, A1U_CODIGO, F2_CODA1U "
    cQuery := ChangeQuery( cQuery )
    
    dbUseArea( .T., "TOPCONN", TcGenQry( , , cQuery ), "QRY", .T., .T. )

    dbSelectArea("QRY")
	ProcRegua(QRY->(LastRec()))
	QRY->(DBGoTop())

	While (!Eof()) .AND. !Empty(FILIAL)
       
        cCodAdm := QRY->INTERMEDIADOR
  
        aADD(aReg1601, {FILIAL,cCodAdm,cCodAdm,TOT_VS,TOT_ISS,TOT_OUT})

          
       DbSkip()
    EndDo
  
   DbCloseArea()
  
Return aReg1601

