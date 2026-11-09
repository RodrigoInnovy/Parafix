#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'
#Include "topconn.ch"
#Include "RwMake.CH"
#include "tbiconn.ch"

/*/{Protheus.doc} AdiCtrlRec
Adiciona status para Controle de Recimento
@author Evandro Simenes
@since 17/10/2017 
@version 1.0
/*/

User Function AdiCtrlRec(cStatus,cDescSt, cFil)
	Local aArea := GetArea()
	Local cQuery := ""
	Local nQtde := 0.00
	Local cNumSeq := ""
	Local nQtSegum := 0.00
	local cAliasSD7	:= GetNextAlias()
	Local cFilUniSt := SuperGetMv("MV_ZZFILUS",.F.,.F.) //Indica se a filial utiliza somente status 5
	
	Default cFil := cFilAnt
	
	oCtrlRec := ControleDeRecebimento():newControleDeRecebimento()
	
	If cFilUniSt
		IF cStatus <> "5" 
			Return
		EndIf 
	EndIf
	
	DO CASE
		CASE cStatus == "1"
			 // Incluido o tratamento para a condição de Beneficiamento , conforme a nova regra definida pelo 
			 // Cliente em 24/04/2020 - Tratativa feita pelo analista Alexandre J. Conselvan - Totvs IP Campinas 
			 IF SF1->F1_TIPO == "N"   .or.  SF1->F1_TIPO == "B" //IF SF1->F1_TIPO == "N" Ajustado por Patrick Araujo - 12/06/2019
				oCtrlRec:setcNF(SF1->F1_DOC)
				oCtrlRec:setcSerie(SF1->F1_SERIE)
				oCtrlRec:setcCodFor(SF1->F1_FORNECE)
				oCtrlRec:setcLoja(SF1->F1_LOJA)
			ENDIF
		CASE cStatus == "2"
			 // Incluido o tratamento para a condição de Beneficiamento , conforme a nova regra definida pelo 
			 // Cliente em 24/04/2020 - Tratativa feita pelo analista Alexandre J. Conselvan - Totvs IP Campinas 		
			IF SF1->F1_TIPO == "N"  .or.  SF1->F1_TIPO == "B"//IF SF1->F1_TIPO == "N" Ajustado por Patrick Araujo - 12/06/2019
				oCtrlRec:setcNF(SF1->F1_DOC)
				oCtrlRec:setcSerie(SF1->F1_SERIE)
				oCtrlRec:setcCodFor(SF1->F1_FORNECE)
				oCtrlRec:setcLoja(SF1->F1_LOJA)
			ENDIF
		CASE cStatus == "4"
			 // Incluido o tratamento para a condição de Beneficiamento , conforme a nova regra definida pelo 
			 // Cliente em 24/04/2020 - Tratativa feita pelo analista Alexandre J. Conselvan - Totvs IP Campinas 
			 // Atenção -- Esta opção no processo normal é feita pelo Coletor de dados ( ACD ), porem para o processo de 
			 // Beneficiamento 
			IF  SF1->F1_TIPO == "B"//IF SF1->F1_TIPO == "N" Ajustado por Patrick Araujo - 12/06/2019
				oCtrlRec:setcNF(SF1->F1_DOC)
				oCtrlRec:setcSerie(SF1->F1_SERIE)
				oCtrlRec:setcCodFor(SF1->F1_FORNECE)
				oCtrlRec:setcLoja(SF1->F1_LOJA)
			ENDIF

		CASE cStatus == "5"
			oCtrlRec:setcFil(cFil)
			 // Incluido o tratamento para a condição de Beneficiamento , conforme a nova regra definida pelo 
			 // Cliente em 24/04/2020 - Tratativa feita pelo analista Alexandre J. Conselvan - Totvs IP Campinas 
			 // ATenção -- Este processo setamos como falso no item e lote para que seja feito a ntoa como um todo e não 
			 // Somente um item ou lote.			
			IF SF1->F1_TIPO = 'B'
				oCtrlRec:setlPorItem(.F.)
				oCtrlRec:setlPorLote(.F.)
			Else
				oCtrlRec:setlPorItem(.T.)
				oCtrlRec:setlPorLote(.T.)
			Endif
			oCtrlRec:setnQtd1Um(ZA1->ZA1_QTD1UM)
			oCtrlRec:setnQtd2Um(ZA1->ZA1_QTD2UM)
			oCtrlRec:setcCodPro(ZA1->ZA1_CODPRO)
			oCtrlRec:setcLote(ZA1->ZA1_LOTE) 
			oCtrlRec:setcNF(ZA1->ZA1_NF)
			oCtrlRec:setcSerie(ZA1->ZA1_SERIE)
			oCtrlRec:setcCodFor(ZA1->ZA1_CODFOR)
			oCtrlRec:setcLoja(ZA1->ZA1_LOJA)
			oCtrlRec:setcItem(ZA1->ZA1_ITEM)

		
		CASE cStatus == "3"
			cQuery += "SELECT D7_LOTECTL, D7_NUMSEQ, D7_NUMERO, SUM(D7_QTDE) D7_QTDE, SUM(D7_QTSEGUM) D7_QTSEGUM "
			cQuery += "  FROM "+RetSqlName("SD7")
			cQuery += " WHERE D7_FILIAL = '"+xFilial("SD7")+"'"
			cQuery += "   AND D_E_L_E_T_ <> '*'"
			cQuery += "   AND D7_PRODUTO = '"+SD7->D7_PRODUTO+"'"
			cQuery += "   AND D7_TIPO = 1"
			cQuery += "   AND D7_NUMERO = '"+SD7->D7_NUMERO+"'"
			cQuery += "   AND D7_ESTORNO <> 'S'"
			cQuery += "   AND D7_LOTECTL = '"+SD7->D7_LOTECTL+"'"
			cQuery += " GROUP BY D7_LOTECTL, D7_NUMSEQ, D7_NUMERO"
			
			TcQuery cQuery New Alias &cAliasSD7
	
			if (cAliasSD7)->(!EOF())
				if EnderItem((cAliasSD7)->D7_NUMSEQ,(cAliasSD7)->D7_QTDE)
					nQtde := (cAliasSD7)->D7_QTDE
					nQtSegum := (cAliasSD7)->D7_QTSEGUM
				endif
			endIf
			
			(cAliasSD7)->(DbCloseArea())
			
			if nQtde == 0 //Se não possui quantidade liberada, não faz nada
				return
			endif

			 // Incluido o tratamento para a condição de Beneficiamento , conforme a nova regra definida pelo 
			 // Cliente em 24/04/2020 - Tratativa feita pelo analista Alexandre J. Conselvan - Totvs IP Campinas 
			 // ATenção -- Este processo setamos como falso no item e lote para que seja feito a ntoa como um todo e não 
			 // Somente um item ou lote.			
			IF SF1->F1_TIPO = 'B'
				oCtrlRec:setlPorItem(.F.)
				oCtrlRec:setlPorLote(.F.)
			Else
				oCtrlRec:setlPorItem(.T.)
				oCtrlRec:setlPorLote(.T.)
			Endif
			oCtrlRec:setcLote(SD7->D7_LOTECTL)
			oCtrlRec:setnQtd1Um(nQtde)
			oCtrlRec:setnQtd2Um(nQtSegum)
			oCtrlRec:setcCodPro(SD7->D7_PRODUTO)
			oCtrlRec:setcNF(SD7->D7_DOC)
			oCtrlRec:setcSerie(SD7->D7_SERIE)
			oCtrlRec:setcCodFor(SD7->D7_FORNECE)
			oCtrlRec:setcLoja(SD7->D7_LOJA)
			oCtrlRec:setcNumCQ(SD7->D7_NUMERO)
	end 
	
	oCtrlRec:setcStatus(cStatus)
	oCtrlRec:setcDescSt(cDescSt)
	oCtrlRec:AdicStatus()
	
	RestArea(aArea)
Return


Static Function EnderItem(nSeq, nQtde)
	Local aCabSDA    := {} 
	Local aItSDB     := {} 
	Local aItensSDB := {} 
	Private	lMsErroAuto := .F.
	
	Aadd( aCabSDA, { 'DA_PRODUTO'	, SD7->D7_PRODUTO		, Nil } )
	Aadd( aCabSDA, { 'DA_NUMSEQ'  	, nSeq		, Nil } )
	
	//Dados do item que será endereçado
	aItSDB := {{"DB_ITEM"	  ,"0001"	  ,Nil},;                   
	           {"DB_ESTORNO"  ," "	      ,Nil},;                   
	           {"DB_LOCALIZ"  ,SuperGetMv("MV_ZZLOCFR",.F.,"FRACIONAMENTO") ,Nil},;                   
	           {"DB_DATA"	  ,dDataBase  ,Nil},;                   
	           {"DB_QUANT"  ,nQtde        ,Nil}}       
	
	aadd(aItensSDB,aItSDB)
	
	//Executa o endereçamento do item
	MATA265( aCabSDA, aItensSDB, 3)
	If lMsErroAuto    
		MostraErro()
		Return .F.
	Endif
Return .T.