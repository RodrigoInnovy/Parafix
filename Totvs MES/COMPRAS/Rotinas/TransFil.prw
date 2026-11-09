#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'
#Include "topconn.ch"
#Include "RwMake.CH"
#include "tbiconn.ch"

/*/{Protheus.doc} TransFil
Função de transferencia de filial via MATA103 (Documento entrada)
@author Evandro Simenes
@since 23/10/2017 
@version 1.0
/*/
User Function TransFil()
   Local aArea := GetArea()
   local aPergs 		:= {}
   Local oCtrlRec := ControleDeRecebimento():newControleDeRecebimento()
   Local aItens := {}
   Local cFilialD := ''
   Local cSolicit := '000000'
   Local cQuery := ""
   local cNxtAlias	:= GetNextAlias()
   local cAliasD1	:= GetNextAlias()
   local cAliasBF	:= GetNextAlias()
   Local aRet 	:= {}
   Local cCod := ""
   Local Entrou := .F.
   Local lOk := .F.
   Local oModel
   Local cNNTTS     := SuperGetMv("MV_ZZTSTR",.F.,"888") 			
   Local cNNTTE     := SuperGetMv("MV_ZZTETR",.F.,"111")			
   Private bValidaFil	:= {||validaFilial(MV_PAR01)}
	
	//TESTE DE EFETIVACAO
    //DbSelectArea("NNS")
	//NNS->(DbSetOrder(1))
	//if (NNS->(DbSeek(xFilial("NNS")+"0000000055")))
	////	MATA311()
	//	A311Efetiv()
	//Endif
	//Return
   
   If SF1->F1_STATUS <> "A"
  	  Help( ,, 'Help',, "Só é possível transferir documentos classificados", 1, 0 )
  	  Return
   EndIf
   
   aAdd( aPergs ,{1,"Filial Destino:",Space(2),"","Eval(bValidaFil)","","",70,.T.})
   
   /*cQuery := " SELECT DISTINCT ZA1_NF"
   cQuery += "   FROM "+RetSqlName("ZA1")
   cQuery += "  WHERE D_E_L_E_T_ <> '*'"
   cQuery += "    AND ZA1_FILIAL <> '"+xFilial("ZA1")+"'"
   cQuery += "    AND ZA1_NF 		= '"+SF1->F1_DOC+"'"
   cQuery += "    AND ZA1_SERIE 	= '"+SF1->F1_SERIE+"'"
   cQuery += "    AND ZA1_CODFOR 	= '"+SF1->F1_FORNECE+"'"
   cQuery += "    AND ZA1_LOJA 		= '"+SF1->F1_LOJA+"'"
   cQuery += "    AND ZA1_STATUS = '5'"
   
   TcQuery cQuery NEW ALIAS &cNxtAlias
   
   (cNxtAlias)->(DBGotop()) 
   If (cNxtAlias)->(!Eof())
   		Alert("NF já foi transferida.")
   		Return
   EndIf
   (cNxtAlias)->(DBCloseArea())*/
   
   if ParamBox(aPergs ,"Transferencia de Filial",aRet)
   	   cCod := GETSXENUM("NNS", "NNS_COD")
   	   ConfirmSX8()
	   	
	   cFilialD	:= allTrim(aRet[1])
	   cQuery := " SELECT DISTINCT SD1.D1_COD, SD1.D1_LOCAL, SD1.D1_TES, SD1.D1_DTVALID, SD1.D1_TES, ZA1.ZA1_LOTE, ZA1.ZA1_QTD1UM"
	   cQuery += "   FROM "+RetSqlName("SD1")+" SD1, "+RetSqlName("ZA1")+" ZA1 "
	   cQuery += "  WHERE SD1.D_E_L_E_T_ <> '*'"
	   cQuery += "    AND ZA1.D_E_L_E_T_ <> '*'"
	   cQuery += "    AND SD1.D1_FILIAL		= '"+xFilial("SD1")+"'"
	   cQuery += "    AND ZA1.ZA1_FILIAL	= '"+xFilial("ZA1")+"' "
	   cQuery += "    AND ZA1.ZA1_NF		= SD1.D1_DOC "
	   cQuery += "    AND ZA1.ZA1_SERIE		= SD1.D1_SERIE "
	   cQuery += "    AND ZA1.ZA1_CODFOR	= SD1.D1_FORNECE "
	   cQuery += "    AND ZA1.ZA1_LOJA		= SD1.D1_LOJA "
	   cQuery += "    AND ZA1.ZA1_CODPRO    = SD1.D1_COD "
	   
	   if SF1->F1_FORNECE = "000067"
	   	   cQuery += "	  AND ZA1.ZA1_LOTE 		= SD1.D1_LOTECTL "
	   endif
	   
	   cQuery += "    AND ZA1.ZA1_STATUS	= '5' "
	   cQuery += "    AND SD1.D1_DOC 		= '"+SF1->F1_DOC+"'"
	   cQuery += "    AND SD1.D1_SERIE 		= '"+SF1->F1_SERIE+"'"
	   cQuery += "    AND SD1.D1_FORNECE 	= '"+SF1->F1_FORNECE+"'"
	   cQuery += "    AND SD1.D1_LOJA 		= '"+SF1->F1_LOJA+"'"
	   
	   TCQUERY cQuery NEW ALIAS &cAliasD1
		
	   (cAliasD1)->(DBGotop()) 
	   Entrou := .F.
	   While (cAliasD1)->(!Eof())
		  Entrou := .T.
		  
		  cQuery := " SELECT DISTINCT 1 "
		  cQuery += "   FROM "+RetSqlName("ZA1")+" ZA1 "
		  cQuery += "  WHERE ZA1.D_E_L_E_T_ <> '*'"
		  cQuery += "    AND ZA1.ZA1_FILIAL = '"+xFilial("ZA1")+"'"
		  cQuery += "    AND ZA1.ZA1_STATUS = '5'"
		  cQuery += "    AND ZA1.ZA1_LOTE = '"+(cAliasD1)->ZA1_LOTE+"'"
		  cQuery += "    AND ZA1.ZA1_CODFOR = '000067' " 
		  cQuery += "    AND ZA1.ZA1_LOJA = '"+MV_PAR01+"' "
		  cQuery += "    AND EXISTS (SELECT NNT.*"
		  cQuery += "                  FROM "+RetSqlName("NNT")+" NNT"
		  cQuery += "                 WHERE NNT.D_E_L_E_T_ <> '*'"
		  cQuery += "                   AND NNT.NNT_FILIAL = '"+xFilial("NNT")+"'"
		  cQuery += "                   AND NNT.NNT_LOTECT = ZA1.ZA1_LOTE"
		  cQuery += "                   AND EXISTS (SELECT SF2.*"
		  cQuery += "                                 FROM "+RetSqlName("SF2")+" SF2"
		  cQuery += "                                WHERE SF2.D_E_L_E_T_ <> '*'"
		  cQuery += "                                  AND SF2.F2_FILIAL = '"+xFilial("SF2")+"'"
		  cQuery += "                                  AND SF2.F2_DOC = NNT.NNT_DOC"
		  cQuery += "                                  AND SF2.F2_SERIE = NNT.NNT_SERIE))"
		  
		  TcQuery cQuery NEW ALIAS &cNxtAlias
		  (cNxtAlias)->(DBGotop()) 
		  If (cNxtAlias)->(!Eof())
		   	 Alert("NF "+SF1->F1_DOC+" já foi transferida.")
		   	 Return
		  EndIf
		  (cNxtAlias)->(DBCloseArea())
		  
		  
		  cQuery := " SELECT DISTINCT 1 "
		  cQuery += "   FROM "+RetSqlName("ZA1")+" ZA1 "
		  cQuery += "  WHERE ZA1.D_E_L_E_T_ <> '*'"
		  cQuery += "    AND ZA1.ZA1_FILIAL = '"+xFilial("ZA1")+"'"
		  cQuery += "    AND ZA1.ZA1_STATUS = '5'"
		  cQuery += "    AND ZA1.ZA1_LOTE = '"+(cAliasD1)->ZA1_LOTE+"'"
		  cQuery += "    AND ZA1.ZA1_CODFOR = '000067' " 
		  cQuery += "    AND ZA1.ZA1_LOJA = '"+MV_PAR01+"' "
		  cQuery += "    AND EXISTS (SELECT NNT.*"
		  cQuery += "                  FROM "+RetSqlName("NNT")+" NNT"
		  cQuery += "                 WHERE NNT.D_E_L_E_T_ <> '*'"
		  cQuery += "                   AND NNT.NNT_FILIAL = '"+xFilial("NNT")+"'"
		  cQuery += "                   AND NNT.NNT_LOTECT = ZA1.ZA1_LOTE"
		  cQuery += "                   AND EXISTS (SELECT NNS.*"
		  cQuery += "                                 FROM "+RetSqlName("NNS")+" NNS"
		  cQuery += "                                WHERE NNS.D_E_L_E_T_ <> '*'"
		  cQuery += "                                  AND NNS.NNS_FILIAL = '"+xFilial("NNS")+"'"
		  cQuery += "                                  AND NNS.NNS_COD = NNT.NNT_COD"
		  cQuery += "                                  AND NNS.NNS_STATUS = '1'))"
		  
		  TcQuery cQuery NEW ALIAS &cNxtAlias
		  (cNxtAlias)->(DBGotop()) 
		  If (cNxtAlias)->(!Eof())
		   	 Alert("NF "+SF1->F1_DOC+" já possui uma solicitação de transferencia em aberto.")
		   	 
		     Return
		  EndIf
		  (cNxtAlias)->(DBCloseArea())
		  
		  cQuery := " SELECT BF_LOCAL, BF_LOCALIZ"
		  cQuery += "   FROM "+RetSqlName("SBF")
		  cQuery += "  WHERE D_E_L_E_T_ <> '*'"
		  cQuery += "    AND BF_FILIAL		= '"+xFilial("SBF")+"'"
		  cQuery += "    AND BF_PRODUTO		= '"+(cAliasD1)->D1_COD+"'"
		  cQuery += "    AND BF_LOTECTL		= '"+(cAliasD1)->ZA1_LOTE+"'"
		  cQuery += "    AND BF_QUANT		> '0' "
		   
		  TCQUERY cQuery NEW ALIAS &cAliasBF
		  (cAliasBF)->(DBGotop()) 
		  
		  If !(cAliasBF)->(!Eof())
		  	  Help( ,, 'Help',, "O saldo do item "+(cAliasD1)->D1_COD+" e lote "+(cAliasD1)->ZA1_LOTE+" não foi encontrado.", 1, 0 )
		  	  
	   		  Return
		  EndIf
		  
		  
	   
	      Aadd(aItens,{cCod,; 										//NNS_COD
	                   dDataBase,;                   				//NNS_DATA
	                   cSolicit,;                    				//NNS_SOLICT
	                   '2',;                         				//NNS_CLASS
	                   xFilial("NNT"),;              				//NNT_FILIAL
	                   cFilialD,;                    				//NNT_FILDES
	                   (cAliasD1)->D1_COD,;          				//NNT_PROD
	                   (cAliasD1)->D1_COD,;            				//NNT_PRODD
	                   (cAliasD1)->ZA1_QTD1UM,; 					//NNT_QUANT
	                   (cAliasBF)->BF_LOCAL,;           			//NNT_LOCAL
	                   (cAliasBF)->BF_LOCAL,; 						//NNT_LOCLD
	                    cNNTTS,; 			//NNT_TS
	                    cNNTTE,;			//NNT_TE
	                   (cAliasBF)->BF_LOCALIZ,;   					//NNT_LOCALI
	                   (cAliasBF)->BF_LOCALIZ,;						//NNT_LOCDES
	                   (cAliasD1)->ZA1_LOTE,;        				//NNT_LOTECT
	                   (cAliasD1)->ZA1_LOTE,;        				//NNT_LOTED
	                   STOD((cAliasD1)->D1_DTVALID),; 				//NNT_DTVALI
	                   STOD((cAliasD1)->D1_DTVALID),;  				//NNT_DTVALD
	                   })
	      (cAliasBF)->(DBCloseArea())
	      (cAliasD1)->(dbSkip())    
	   End
	   
	   (cAliasD1)->(DBCloseArea())
	   
	   If !Entrou
	   		Help( ,, 'Help',, "Não há itens para transferir. Certifique-se de que a conferencia dos lotes foi efetuada.", 1, 0 )
	   		
	   		Return
	   EndIf
	   
	   if !oCtrlRec:IncSolicTransf(aItens)
	   		Help( ,, 'Help',, "Erro ao gerar solicitação de transferencia", 1, 0 )
	   		Return
	   else
	   		IncluiStatus(cFilialD)
	   endif
	   
   EndIf
   
   RestArea(aArea)
Return

static function validaFilial(cFil)
	local lRetorno := .T.
	
	
return lRetorno

Static Function IncluiStatus(cFil)
	Local cQuery 	:= ""
	Local cNxtAlias	:= GetNextAlias()
	
	cQuery := "SELECT * "
	cQuery += "  FROM "+RetSqlName("ZA1")
	cQuery += " WHERE ZA1_FILIAL 	= '"+cFil+"'"
	cQuery += "   AND ZA1_NF 		= '"+SF1->F1_DOC+"'"
	cQuery += "   AND ZA1_SERIE 	= '"+SF1->F1_SERIE+"'"
	cQuery += "   AND ZA1_CODFOR 	= '"+SF1->F1_FORNECE+"'"
	cQuery += "   AND ZA1_LOJA 		= '"+SF1->F1_LOJA+"'"
	cQuery += "   AND ZA1_STATUS 	= '5'"
	
	TCQUERY cQuery NEW ALIAS &cNxtAlias
    (cNxtAlias)->(DBGotop()) 
    
    While (cNxtAlias)->(!Eof())
  	    //Deleta status 5 na filial 02
  	    DbSelectArea("ZA1")
		DbGoTo((cNxtAlias)->R_E_C_N_O_)
		RECLOCK("ZA1", .F.)
		dbdelete()
		MsUnlock()
		WriteSx2("ZA1")
  	    (cNxtAlias)->(dbSkip())    
    End
    
    (cNxtAlias)->(DBCloseArea())
	
	cQuery := "SELECT * "
	cQuery += "  FROM "+RetSqlName("ZA1")
	cQuery += " WHERE ZA1_FILIAL 	= '"+xFilial("ZA1")+"'"
	cQuery += "   AND ZA1_NF 		= '"+SF1->F1_DOC+"'"
	cQuery += "   AND ZA1_SERIE 	= '"+SF1->F1_SERIE+"'"
	cQuery += "   AND ZA1_CODFOR 	= '"+SF1->F1_FORNECE+"'"
	cQuery += "   AND ZA1_LOJA 		= '"+SF1->F1_LOJA+"'"
	cQuery += "   AND ZA1_STATUS 	= '5'"
	
	TCQUERY cQuery NEW ALIAS &cNxtAlias
    (cNxtAlias)->(DBGotop()) 
    
    While (cNxtAlias)->(!Eof())
  	    //Adiciona Status para Controle de Recebimento para filial 2
		DbSelectArea("ZA1")
		ZA1->(DbGoTo((cNxtAlias)->R_E_C_N_O_))
		U_AdiCtrlRec("5","Finalizado - Ok p/ Endereçar",cFil)
  	    (cNxtAlias)->(dbSkip())    
    End
    
    (cNxtAlias)->(DBCloseArea())
    
Return
