#Include 'Protheus.ch'
#Include 'TOPCONN.ch'

/*/{Protheus.doc} PE01NFESEFAZ
   Ponto de entrada para manipular as matrizes contendo os dados utilizados para criar a nota fiscal eletronica.
   
   1. Identifica se o produto sera impresso na primeira ou na segunda unidade de medida
   
   @author andre.cruz@tuningsistemas.com.br
   @since 20140212
/*/

/*
 Nï¿½o foi possivel implementar no ponto de entrada 25/03/15 12:00
==================================================
 Linha 3474
//Personalizado - Felipe
If !lEasy .And. Len(aDI)>0
    For nX:=1 To Len(aDI)
        If Len(aDI[nX])>0 .And. !Empty(aDI[nX][19][03])
            nValorII += aDI[nX][19][03]
        EndIf
    Next nX
EndIf                       
aTotal[2] += nValorII 
//***************************   

Linha 3815
// Verificar necessidade e possibilidade de alteracao do SIGAMAT.EMP
//Personalizado
If "/" $ IIF(!lEndFis,ConvType(FisGetEnd(SM0->M0_ENDCOB,SM0->M0_ESTCOB)[3]),ConvType(FisGetEnd(SM0->M0_ENDENT,SM0->M0_ESTENT)[3]))
    cString += '<nro>'+IIF(!lEndFis,ConvType(FisGetEnd(SM0->M0_ENDCOB,SM0->M0_ESTCOB)[3]),ConvType(FisGetEnd(SM0->M0_ENDENT,SM0->M0_ESTENT)[3]))+'</nro>'
Else
    cString += '<nro>'+IIF(!lEndFis,ConvType(IIF(FisGetEnd(SM0->M0_ENDCOB,SM0->M0_ESTCOB)[2]<>0,FisGetEnd(SM0->M0_ENDCOB,SM0->M0_ESTCOB)[2],"SN")),ConvType(IIF(FisGetEnd(SM0->M0_ENDENT,SM0->M0_ESTENT)[2]<>0,FisGetEnd(SM0->M0_ENDENT,SM0->M0_ESTENT)[2],"SN")))+'</nro>'
EndIf
//*****************

Linha 4101
// verificar necessidade. nï¿½o ï¿½ possivel alterar no PE
//Inicio - Personalizado por Leandro Camacari - Data: 23/11/2012 - TOTVS IP Campinas.  
//Especial para Nota Fiscal Complemento de Preï¿½o
If Alltrim(SD2->D2_TIPO) == "C" .OR. Alltrim(SD2->D2_TIPO) == "I"
    cString += '<qTrib>' + "1" + '</qTrib>'
Else    
    cString += '<qTrib>' + ConvType(aProd[12], 15, 6) + '</qTrib>'
EndIf
//Fim - Personalizado por Leandro Camacari - Data: 23/11/2012 - TOTVS IP Campinas.


Linha 4127
// verificar necessidade. nï¿½o ï¿½ possivel alterar no PE
//Inicio - Personalizado por Leandro Camacari - Data: 23/11/2012 - TOTVS IP Campinas.  
//Alterando de 6 para 9 casas decimais.
If cVerAmb== "2.00"
    cString += '<vUnTrib>'+ConvType(aProd[16],21,9)+'</vUnTrib>'        
Else
    cString += '<vUnTrib>'+ConvType(aProd[16],16,9)+'</vUnTrib>'    
Endif
//Fim - Personalizado por Leandro Camacari - Data: 23/11/2012 - TOTVS IP Campinas.


 */

User Function PE01NFESEFAZ()
// aParam := {aProd,cMensCli,cMensFis,aDest,aNota,aInfoItem,aDupl,aTransp,aEntrega,aRetirada,aVeiculo,aReboque}
Local aParam    := aClone(ParamIXB)
Local aProd     := aParam[1]
Local cMensCli  := aParam[2]
Local cMensFis  := aParam[3]
Local aDest     := aParam[4]
Local aNota     := aParam[5]
Local aInfoItem := aParam[6]
Local cCliFor   := ""
Local nLen      := Len(aProd)
Local lNfCup    := .F.
Local nDesconto := 0
// Local nPrUnit   := 0
Local i         := 0
Local cPedSD2   := ""
Local cPedSC6   := ""
Local aPed      := {}
Local cMsgSC5   := "" 
local aArea	:= Lj7GetArea({"SC5","SC6","SF2","SD2","SB5","SF1","SD1","SF4"})
Local cX5DESC   := X5DESCRI()
local aNFOriginal := {}
local nTamObs	:= ""
local nX
local nk

*** Fernando 10/10/2018
**************************
Private cXMarca   := ""
Private cXNumero  := ""
Private cXHawb    := ""
Private cxNfOri   := ""
Private cXDI      := ""
Private dDtDi     := CtoD("  /  /  ")
Private _wnPONUm  := ""
Private _wnNrProf := ""
Private cxMsgDraw := ""
Private cxContain := ""
Private _wnvlrpis := 0
Private _wnvlrcof := 0
Private _wniival  := 0
Private _wdTxSisc := 0
Private _wndoc    := ""
Private _wnICMS   := 0
Private _hawb     := ""
Private _wnserie  := ""
Private _cRecAlfa := ""
Private _wMarinha := 0
Private _hawbNFE  := ""

**************************

If aNota[4] == '1' // Saida   
    
    DbSelectArea("SC5")
	DbSetOrder(1) // C5_FILIAL + C5_NUM                         
	SC5->(DbSeek(xFilial("SC5")+aInfoItem[1][1]))

	If SC5->C5_TIPOCLI <> "X"	
	    DbSelectArea("SC5")
	    DbSetOrder(1) // C5_FILIAL + C5_NUM 
	    DbSelectArea("SC6")
	    DbSetOrder(1) // C6_FILIAL + C6_NUM + C6_ITEM + C6_PRODUTO
	    //DbSelectArea( "SF2" )
	    //DbSetOrder(1) // F2_FILIAL + F2_DOC + F2_SERIE + F2_CLIENTE + F2_LOJA
	    DbSelectArea("SD2")
	    DbSetOrder(3) // D2_FILIAL + D2_DOC + D2_SERIE + D2_CLIENTE + D2_LOJA + D2_COD + D2_ITEM 
	    DbSelectArea("SB5")
	    DbSetOrder(1) // B5_FILIAL + B5_COD
	    
	    
	    For i := 1 To nLen
		
	        // Posiciona tabelas dependentes
	        SC5->(DbSeek(xFilial("SC5")+aInfoItem[i][1]))
	        SC6->(DbSeek(xFilial("SC6")+aInfoItem[i][1]+aInfoItem[i][2]))
	        SB5->(DbSeek(xFilial("SB5")+aProd[i][02]))
	        //SD2->(DBSeek(xFilial("SD2")+aNota[2]+aNota[1]+SF2->F2_CLIENTE+SF2->F2_LOJA+aProd[i,2]+strZero(aProd[i,1],2)))
			SD2->(DBSeek(xFilial("SD2")+aNota[2]+aNota[1]+SF2->F2_CLIENTE+SF2->F2_LOJA+aProd[i,2]+AINFOITEM[i,4])) //ALTERADO POR LUCAS PARA POSICIONAR NO ITEM DA NF QUANDO POSSUI MAIS QUE 100 ITENS, CAMPO DE ITENS ALFANUMERICO 18/03/2022
	        //SD2->(DBSeek(xFilial("SD2")+SC6->C6_NUM+SC6->C6_ITEM))
			// SF2->(DbSeek(xFilial("SF2")+SD2->D2_DOC+SD2->D2_SERIE))
		
	        If aScan(aPed, {|aMat| aMat == SC5->C5_NUM}) == 0
	            If (nTamObs := MlCount(SC5->C5_OBSPED)) > 0
	                cMsgSC5 += CRLF + "Obs Ped " + SC6->C6_PEDCLI + ": "
	                For nX := 1 to nTamObs
	                    cMsgSC5 += Alltrim(MemoLine(SC5->C5_OBSPED,150,nX))
	                    cMsgSC5 += CRLF
	                Next
	            EndIf
	            AAdd(aPed, SC5->C5_NUM)
	        EndIf
		
	        If At(cPedSD2, SD2->D2_PEDIDO) == 0
	            cPedSD2 += Iif(Empty(cPedSD2), "", "/") + SD2->D2_PEDIDO
	        EndIf
	        
	        If At(cPedSC6, SC6->C6_PEDCLI) == 0
	            cPedSC6 += Iif(Empty(cPedSC6), "", "/") + SC6->C6_PEDCLI
	        EndIf
	
			aNFOriginal := PegaUMOriginal(1)
		
	        If !(Alltrim(SD2->D2_TIPO) $ "CIP") .and. SC6->C6_UNIDADE == '2'
	            lNfCup := ("CF" $ SF2->F2_ESPECIE .OR. (LjAnalisaLeg(18)[1] .AND. "ECF" $ SF2->F2_ESPECIE )) .AND. ("S" $ SF2->F2_ECF) .AND. !Empty(SF2->F2_NFCUPOM)
	            nDesconto := Iif(lNfCup .Or. SD2->D2_ORIGLAN == "VD", A410Arred((SD2->D2_QUANT*SD2->D2_PRUNIT,2)+(SD2->D2_VALACRS)-SD2->D2_TOTAL,"D2_DESCON"), SD2->D2_DESCON)             
	            nPrcVen  := A410Arred(SD2->D2_TOTAL/SD2->D2_QUANT,"D2_PRCVEN")
	            nPrcUnit := A410Arred(SD2->D2_PRUNIT*(nPrcVen/SD2->D2_PRCVEN),"D2_PRUNIT") 
	            

	            If SC5->C5_TIPOCLI = "X" .AND. SC6->C6_UNIDADE == '2'	
	            
	            aProd[i][08] := SD2->D2_SEGUM 
	            aProd[i][09] := SD2->D2_QTSEGUM
	            aProd[i][11] := IIF(!Empty(SB5->B5_UMDIPI),SB5->B5_UMDIPI,SB5->B5_UMDIPI)
	            aProd[i][12] := IIF(!Empty(SB5->B5_CONVDIP),SB5->B5_CONVDIP*SD2->D2_QTSEGUM,SB5->B5_CONVDIP*SD2->D2_QTSEGUM)
	            aProd[i][16] := RetPrvUnit(SD2->D2_TIPO, SD2->D2_QTSEGUM, nPrcUnit, nPrcVen, nDesconto, SD2->D2_DESCZFR, SD2->D2_TOTAL)
	            
	            //elseif SC5->C5_TIPOCLI <> "X"
	            
	            
	            //aProd[i][08] := SD2->D2_SEGUM 
	            //aProd[i][09] := SD2->D2_QTSEGUM
	            //aProd[i][11] := IIF(!Empty(SB5->B5_UMDIPI),SD2->D2_SEGUM,SB5->B5_UMDIPI)
	            //aProd[i][12] := IIF(!Empty(SB5->B5_CONVDIP),SD2->D2_QTSEGUM,SB5->B5_CONVDIP*SD2->D2_QTSEGUM)
	            //aProd[i][16] := RetPrvUnit(SD2->D2_TIPO, SD2->D2_QTSEGUM, nPrcUnit, nPrcVen, nDesconto, SD2->D2_DESCZFR, SD2->D2_TOTAL)
	            
	        endif     
	                   
	     	ElseIf !(Alltrim(SD2->D2_TIPO) $ "CIP") .and. SC6->C6_UNIDADE == '1'
	            lNfCup := ("CF" $ SF2->F2_ESPECIE .OR. (LjAnalisaLeg(18)[1] .AND. "ECF" $ SF2->F2_ESPECIE )) .AND. ("S" $ SF2->F2_ECF) .AND. !Empty(SF2->F2_NFCUPOM)
	            nDesconto := Iif(lNfCup .Or. SD2->D2_ORIGLAN == "VD", A410Arred((SD2->D2_QUANT*SD2->D2_PRUNIT,2)+(SD2->D2_VALACRS)-SD2->D2_TOTAL,"D2_DESCON"), SD2->D2_DESCON)             
	            nPrcVen  := A410Arred(SD2->D2_TOTAL/SD2->D2_QUANT,"D2_PRCVEN")
	            nPrcUnit := A410Arred(SD2->D2_PRUNIT*(nPrcVen/SD2->D2_PRCVEN),"D2_PRUNIT") 
	            
	            aProd[i][08] := SD2->D2_UM
	            aProd[i][09] := SD2->D2_QUANT //  SD2->D2_QUANT 
	            aProd[i][11] := SD2->D2_UM //// TESTE EXPORTAï¿½ï¿½O ADRIANO 
	            aProd[i][12] := SD2->D2_QUANT
	            aProd[i][16] := RetPrvUnit(SD2->D2_TIPO, SD2->D2_QUANT, nPrcUnit, nPrcVen, nDesconto, SD2->D2_DESCZFR, SD2->D2_TOTAL)
	          
	        ElseIf Alltrim(SD2->D2_TIPO) $ "CIP" .and. aProd[i][9] == 0
	            aProd[i][9] := 1
	           	if len(aNFOriginal)>0
				    aProd[i][08] := aNFOriginal[1,1]
				    aProd[i][11] := aNFOriginal[1,1]
			    endIF
	
	        EndIf
	
			IF SD2->D2_TIPO $ "D/B"
				// Troca unidade
				if len(aNFOriginal)>0
					aProd[i][08] := aNFOriginal[1,1]
					aProd[i][11] := aNFOriginal[1,1]
					If aNFOriginal[1,2]
						lNfCup := ("CF" $ SF2->F2_ESPECIE .OR. (LjAnalisaLeg(18)[1] .AND. "ECF" $ SF2->F2_ESPECIE )) .AND. ("S" $ SF2->F2_ECF) .AND. !Empty(SF2->F2_NFCUPOM)
			            nDesconto := Iif(lNfCup .Or. SD2->D2_ORIGLAN == "VD", A410Arred((SD2->D2_QUANT*SD2->D2_PRUNIT,2)+(SD2->D2_VALACRS)-SD2->D2_TOTAL,"D2_DESCON"), SD2->D2_DESCON)             
			            nPrcVen  := A410Arred(SD2->D2_TOTAL/SD2->D2_QUANT,"D2_PRCVEN")
			            nPrcUnit := A410Arred(SD2->D2_PRUNIT*(nPrcVen/SD2->D2_PRCVEN),"D2_PRUNIT") 
			            
			            aProd[i][09] := SD2->D2_QTSEGUM
			            aProd[i][12] := IIF(!Empty(SB5->B5_CONVDIP),SD2->D2_QTSEGUM,SB5->B5_CONVDIP*SD2->D2_QTSEGUM)
			            aProd[i][16] := RetPrvUnit(SD2->D2_TIPO, SD2->D2_QTSEGUM, nPrcUnit, nPrcVen, nDesconto, SD2->D2_DESCZFR, SD2->D2_TOTAL)

					elseIf !aNFOriginal[1,2]
						lNfCup := ("CF" $ SF2->F2_ESPECIE .OR. (LjAnalisaLeg(18)[1] .AND. "ECF" $ SF2->F2_ESPECIE )) .AND. ("S" $ SF2->F2_ECF) .AND. !Empty(SF2->F2_NFCUPOM)
			            nDesconto := Iif(lNfCup .Or. SD2->D2_ORIGLAN == "VD", A410Arred((SD2->D2_QUANT*SD2->D2_PRUNIT,2)+(SD2->D2_VALACRS)-SD2->D2_TOTAL,"D2_DESCON"), SD2->D2_DESCON)             
			            nPrcVen  := A410Arred(SD2->D2_TOTAL/SD2->D2_QUANT,"D2_PRCVEN")
			            nPrcUnit := A410Arred(SD2->D2_PRUNIT*(nPrcVen/SD2->D2_PRCVEN),"D2_PRUNIT") 
			            
			            aProd[i][09] := SD2->D2_QUANT
			            aProd[i][12] := SD2->D2_QUANT
			            aProd[i][16] := RetPrvUnit(SD2->D2_TIPO, SD2->D2_QUANT, nPrcUnit, nPrcVen, nDesconto, SD2->D2_DESCZFR, SD2->D2_TOTAL)
					endIf
				endIf
			EndIF
	    Next
	
	    If !Empty(cPedSD2)
	        cMensCli += "Ped.Interno: " + cPedSD2
	    EndIf
	    
	    If !Empty(cPedSC6)
	        cMensCli += "Ped.Cliente: " + cPedSC6
	    EndIf
	    
	    If !Empty(cMsgSC5)
	        cMensCli += cMsgSC5
	    EndIf


//***  20/10/2021
//***  ADICIONADO MENSAGENS REFERENTE A NOTA FISCAL DE EXPORTAÇÃO: MOEDA TAXA E VALOR TOTOAL


		If SC5->C5_TIPOCLI = "X" 

			nped	:= SC5->C5_NUM
			nVtot	:= Posicione("EE7",1,xFilial("EE7")+SC5->C5_PEDEXP,"EE7_TOTPED")
			cMoeda 	:= Posicione("EE7",1,xFilial("EE7")+SC5->C5_PEDEXP,"EE7_ZZMOED")
			ntxinv 	:=  (SF2->F2_VALBRUT / nVtot)
			//nTxinv 	:= SC5->C5_TXMOEDA


 			cMensCli += " Invoice: "+nped+" 
 			cMensCli += " Vr Inv "+cMoeda+": "+Alltrim(Transform(nVtot ,"@E 999,999.99")) //+CHR(13)+CHR(10)
 			cMensCli += " Tx Inv "+cMoeda+": "+Alltrim(Transform(nTxinv ,"@E 999.9999")) //+CHR(13)+CHR(10)
		
		

 		endif
	
	EndIf

Else // Entrada
   // DbSelectArea("SF1")
   // DbSetOrder(1) 
      
		*****************************************************************
		**** Fernando 10/10/18 - Para a impressão da NF de Importação
		*****************************************************************
		OldAreaDanfe := GetArea()
		_cCodRecAlfa := Posicione("SW6",1,xFilial("SW6")+SF1->F1_HAWB,"W6_REC_ALF")
		_hawbNFE     := Posicione("SW6",1,xFilial("SW6")+SF1->F1_HAWB,"W6_NF_ENT")
		_cRecAlfa    := Posicione("SJA",1,xFilial("SJA")+_cCodRecAlfa,"JA_DESCR")
		If SF1->F1_TIPO_NF == "6" .and. !Empty(SF1->F1_HAWB)
			OldF1Area := GetArea()
			cxNfOri  := Posicione("SD1",1,xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE,"D1_NFORI")
			cxNfOri  += " / " + Posicione("SD1",1,xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE,"D1_SERIORI")
			RestArea(OldF1Area)
		Endif
		If !Empty(SF1->F1_HAWB) .AND. SF1->F1_TIPO == "N"
			If !Empty(SF1->F1_HAWB) //.OR. SF1->F1_HAWB <> cXHawb
				cXDI     := Transform(Posicione("SW6",1,xFilial("SW6")+SF1->F1_HAWB,"W6_DI_NUM"),"@R 99/9999999-9")
				cDtDi    := DtoC(Posicione("SW6",1,xFilial("SW6")+SF1->F1_HAWB,"W6_DTREG_D"))
				cXHawb   := SF1->F1_HAWB
			EndIf
			cXHawb   := SF1->F1_HAWB
		Else
			cXHawb   := ""
			cXDI     := ""
			lxPassou := .F.
			
		EndIf
		
		_hawb    := SF1->F1_HAWB
		_wndoc   := SF1->F1_DOC        // Numero
		_wnserie := SF1->F1_SERIE      // Serie
		
		******************************************************
		*** Acha informacoes de Importaçoa para a Impressao
		******************************************************
		cSF1 := GetArea()
		AchaImp()
		RestArea(cSF1)
		*****************************************************************************
		***  Mensagens para Importação
		*****************************************************************************
		
		*****************************************************************************
		************ Informações do Container Fernando
		*****************************************************************************
		If !Empty(cXHawb) .and. (SF1->F1_TIPO_NF == "1" .or. SF1->F1_TIPO_NF == "6")
			cTipoCont := ""
			cTipoCont := Posicione("SJD",1,xFilial("SJD")+cXHawb,"JD_TIPO_CT") // Tipo Container
			If !Empty(cTipoCont)
				DO Case
					Case cTipoCont == "1"
						cTipo := "Container 20' No.: "
					Case cTipoCont == "2"
						cTipo := "Container 40' No.: "
					Case cTipoCont == "3"
						cTipo := "Container 40' HC No.: "
					Case cTipoCont == "4"
						cTipo := "Outros No.: "
				EndCase
				cSJD := Alltrim(Posicione("SJD",1,xFilial("SJD")+cXHawb,"JD_CONTAIN")) //SJD->(DbSeek(xFilial("SJD")+cXHawb,SDJ->JD_CONTAIN))
				While SJD->JD_HAWB == cXHawb
					If Alltrim(SJD->JD_NF) == Alltrim(SF1->F1_DOC)
						cNrCont  := Transform(SJD->JD_CONTAIN,"@R XXXX-XXXXXX/X")
						cxContain:= " "+cTipo+cNrCont
						Exit
					Endif
					SJD->(DbSkip())
				Enddo
				If SF1->F1_TIPO_NF == "1"
					cMensCli += " "+AllTrim(cxContain)
				Endif
			Endif
		Endif
		*****************  Fim Containers ***************************************
			
		*****************************************************************************
		************ Rodapé Notas Primeira ou Mãe
		*****************************************************************************
		If !Empty(cXHawb) .and. SF1->F1_TIPO_NF != "6"
			cMensCli += " Nr. Proc " +Alltrim(cXHawb)+CHR(13)+CHR(10)
			cMensCli += "Nr. DI "   +Alltrim(cXDI)+CHR(13)+CHR(10)
			cMensCli += "Data DI "  +cDtDi+CHR(13)+CHR(10)
			cMensCli += IIF(_wniival >0,"II  R$ " +Alltrim(Transform(_wniival ,"@E 999,999.99")),"")+CHR(13)+CHR(10)
			cMensCli += IIF(_wnvlrpis>0,"PIS R$ " +Alltrim(Transform(_wnvlrpis,"@E 999,999.99")),"")+CHR(13)+CHR(10)
			cMensCli += IIF(_wnvlrcof>0,"COF R$ " +Alltrim(Transform(_wnvlrcof,"@E 999,999.99")),"")+CHR(13)+CHR(10)
			If _wdTxSisc > 0
				cMensCli += IIF(_wdTxSisc>0,"Tx Siscomex R$ "   +Alltrim(Transform(_wdTxSisc,"@E 999,999.99")),"")+CHR(13)+CHR(10)
			Endif           
			If _wMarinha > 0
				cMensCli += IIF(_wMarinha>0,"AFRMM R$ "   +Alltrim(Transform(_wMarinha,"@E 999,999.99")),"")+CHR(13)+CHR(10)
			Endif
			//cMensCli += "Referência: "+Alltrim(SW6->W6_REF_DES)+" "+CHR(13)+CHR(10)
			cMensCli += IIF(!Empty(_wnNrProf),"Invoice(s): "  +Alltrim(_wnNrProf),"")+CHR(13)+CHR(10)
			***********************************************************************************************
			*** Informação somente poderá sair na nota filha. Para nota Mãe - manter valida a informação
			***********************************************************************************************
			If SF1->F1_TIPO_NF == "5"     // Nota Mae
				cComplMens := "/ SEM VALIDADE PARA O TRANSITO, A MERCADORIA SERA TRANSPORTADA/PARCELADAMENTE"
			ElseIf SF1->F1_TIPO_NF == "1" // Nota Primeira
				cComplMens := ""
			Endif
			***********************************************************************************************
			/*If _wnICMS > 0
				cMensCli += "Inf. Fisco: ICMS DIFERIDO * AUTORIZACAO SEFAZ/MS* "+ cComplMens +CHR(13)+CHR(10)
				cMensCli += "RECINTO ADUANEIRO: "+Alltrim(_cRecAlfa)+" "+CHR(13)+CHR(10)
			Endif*/
		Endif
		
		*****************************************************************************
		************ Rodape Nota Filha
		*****************************************************************************
		If !Empty(SF1->F1_HAWB) .and. SF1->F1_TIPO_NF == "6"
			_wnICMS := Posicione("SWN",3,xFilial("SWN")+cXHawb+"5","WN_VICMDIF")
			cMensCli += " Nr. Proc " +Alltrim(cXHawb)+CHR(13)+CHR(10)
			cMensCli += "Nr. DI "   +Alltrim(cXDI)+CHR(13)+CHR(10)
			cMensCli += "Data DI "  +cDtDi+CHR(13)+CHR(10)
			cMensCli += IIF(_wnICMS>0,"Inf. Fisco: ICMS DIFERIDO * AUTORIZACAO SEFAZ/MS"+CHR(13)+CHR(10),"")
			cMensCli += IIF(!Empty(_wnNrProf),"Proforma: "  +Alltrim(_wnNrProf),"")+CHR(13)+CHR(10)
			cMensCli += " "+AllTrim(cxContain)+" Nota Filha ref "
		Endif
		*****************************************************************************
		
		cXMarca   := ""
		cXNumero  := ""
		cXHawb    := ""
		cxNfOri   := ""
		cXDI      := ""
		lxPassou  := .F.
		_wnPONUm  := ""
		_wnNrProf := ""
		cxMsgDraw := ""
		cxContain := ""
		_wnvlrpis := 0
		_wnvlrcof := 0
		_wniival  := 0
		_wdTxSisc := 0
		_wnICMS   := 0
		_wndoc    := ""
		_hawb     := ""
		_wnserie  := ""
		
		RestArea(OldAreaDanfe)
		
		************ Fim Inclusao Fernando - 10/10/2018
    
    DbSelectArea("SD1")
    SD1->(DBSetOrder(1)) // D1_FILIAL + D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA + D1_COD + D1_ITEM 
    
    DbSelectArea("SF4")
    SF4->(DbSetOrder(1)) // 
        
    /*If aNota[5]$"DB"
        DbSelectArea("SA1")
        DbSetOrder(1) // A1_FILIAL + A1_CGC
        SA1->(DbSeek(xFilial("SA1")  + SF1->F1_FORNECE + SF1->F1_LOJA))
        cCliFor := SA1->A1_COD + SA1->A1_LOJA
    Else
        DbSelectArea("SA2")
        DbSetOrder(1)
        SA2->(DbSeek(xFilial("SA2") + SF1->F1_FORNECE + SF1->F1_LOJA))
        cCliFor := SA2->A2_COD + SA2->A2_LOJA
    EndIf*/
    cCliFor := SF1->F1_FORNECE + SF1->F1_LOJA

    // Identifica o tamanho da nota fiscal
    SX5->(DbSeek(xFilial("SX5")+'01'+ aNota[1]))
    
    cDoc := Iif( Len(AllTrim(cX5DESC)) == 6, SubStr(aNota[2], 4, 6), aNota[2])
	//SF1->(DbSeek(xFilial("SF1")+cDoc+aNota[1]+cCliFor+aNota[5]))

    For i := 1 To nLen
        // Posiciona no item da SD1
        SD1->(DbSeek(xFilial("SD1") + cDoc + aNota[1] + cCliFor + aInfoItem[i][5] + aInfoItem[i][4]))

		aNFOriginal := PegaUMOriginal(2)
	
        If SD1->D1_UNIDADE == '2'
            // Troca unidade
            aProd[i][08] := SD1->D1_SEGUM 
            aProd[i][09] := SD1->D1_QTSEGUM
            aProd[i][11] := IIF(!Empty(SB5->B5_UMDIPI),SD1->D1_SEGUM,SB5->B5_UMDIPI)
            aProd[i][12] := Iif(!Empty(SB5->B5_CONVDIP),SD1->D1_QTSEGUM,SB5->B5_CONVDIP*SD1->D1_QTSEGUM)
            aProd[i][16] := Iif(!SD1->D1_TIPO$"CIP",; 
                             Iif(!(SubStr(SD1->D1_CF,1,1) $ "3"),;  
                                 A410Arred(SD1->D1_TOTAL/SD1->D1_QTSEGUM, "D1_VUNIT"),; // se nï¿½o for importao considera somente o valor unitario
                                 A410Arred(SD1->D1_TOTAL/SD1->D1_QTSEGUM, "D1_VUNIT")-(SD1->D1_II/SD1->D1_QTSEGUM)),; // Seno, desconta o II
                             0) // Se for complemento de impostos o valor unitario 0
                             
        ElseIf SD1->D1_UNIDADE == '1'
            // Troca unidade
            aProd[i][08] := SD1->D1_UM 
            aProd[i][09] := SD1->D1_QUANT
            aProd[i][11] := SD1->D1_UM
            aProd[i][12] := SD1->D1_QUANT
            aProd[i][16] := Iif(!SD1->D1_TIPO$"CIP",; 
                             Iif(!(SubStr(SD1->D1_CF,1,1) $ "3"),;  
                                 A410Arred(SD1->D1_TOTAL/SD1->D1_QUANT, "D1_VUNIT"),; // se nï¿½o for importao considera somente o valor unitario
                                 A410Arred(SD1->D1_TOTAL/SD1->D1_QUANT, "D1_VUNIT")-(SD1->D1_II/SD1->D1_QUANT)),; // Seo, desconta o II
                             0) // Se for complemento de impostos o valor unitario  0                         
                             
            
        EndIf

		IF SD1->D1_TIPO $ "D/B"
			
			// Troca unidade 
			if len(aNFOriginal)>0
				aProd[i][08] := aNFOriginal[1,1]
				aProd[i][11] := IIF(!Empty(SB5->B5_UMDIPI),aNFOriginal[1,1],SB5->B5_UMDIPI)
				
				If aNFOriginal[1,2]
					aProd[i][09] := SD1->D1_QTSEGUM
					aProd[i][12] := Iif(!Empty(SB5->B5_CONVDIP),SD1->D1_QTSEGUM,SB5->B5_CONVDIP*SD1->D1_QTSEGUM)
	            	aProd[i][16] := Iif(!SD1->D1_TIPO$"CIP",; 
	                	             Iif(!(SubStr(SD1->D1_CF,1,1) $ "3"),;  
	                                 A410Arred(SD1->D1_TOTAL/SD1->D1_QTSEGUM, "D1_VUNIT"),; // se nï¿½o for importao considera somente o valor unitario
	                                 A410Arred(SD1->D1_TOTAL/SD1->D1_QTSEGUM, "D1_VUNIT")-(SD1->D1_II/SD1->D1_QTSEGUM)),; // Seno, desconta o II
	                    	         0) // Se for complemento de impostos o valor unitario 0
				elseIf !aNFOriginal[1,2]
					aProd[i][09] := SD1->D1_QUANT
					aProd[i][12] := SD1->D1_QUANT
	            	aProd[i][16] := Iif(!SD1->D1_TIPO$"CIP",; 
	                	             Iif(!(SubStr(SD1->D1_CF,1,1) $ "3"),;  
	                                 A410Arred(SD1->D1_TOTAL/SD1->D1_QUANT, "D1_VUNIT"),; // se nï¿½o for importao considera somente o valor unitario
	                                 A410Arred(SD1->D1_TOTAL/SD1->D1_QUANT, "D1_VUNIT")-(SD1->D1_II/SD1->D1_QUANT)),; // Seo, desconta o II
	                    	         0) // Se for complemento de impostos o valor unitario  0
					
				endIf
			endIf
		EndIF

        If SF1->(FieldPos("F1_STATUS"))>0 .And.SD1->(FieldPos("D1_TESACLA"))>0 .And. SF1->F1_STATUS='C' 
            SF4->(MsSeek(xFilial("SF4")+SD1->D1_TESACLA))
        Else 
            SF4->(MsSeek(xFilial("SF4")+SD1->D1_TES))
        EndIf
        
        If AllTrim(SD1->D1_CF) == "1604" .and. SD1->D1_FORMUL=="S"
        	//Tratamento para o campo F4_FORMULA,onde atraves do parametro MV_NFEMSF4 se determina se o conteudo da formula devera compor a mensagem do cliente(="C") ou do fisco(="F").
			If !Empty(SF4->F4_FORMULA) .And. Formula(SF4->F4_FORMULA) <> NIL .And. ( ( !AllTrim(Formula(SF4->F4_FORMULA)) $ cMensFis) )
	            cMensFis +=  SF4->(Formula(F4_FORMULA)) + IIF(!Empty(SD1->D1_VALICM)," - R$ " + Transform( SD1->D1_VALICM, "@E 999,999,999.99")," ")
			EndIf
        EndIf        
    Next
    
EndIf

If At("/", aDest[4]) > 0
    aDest[4] := StrTran(aDest[4], "/", "")
EndIf

aParam[1] := aProd
aParam[2] := cMensCli
aParam[3] := cMensFis
aParam[4] := aDest
      

// Aglutinação dos lotes 
If aNota[4] == '1' .and. aNota[5] = "N"// Saida 
    
	cAglutima 	:= "N"
	cEstado 	:=  " "
	
	DbSelectArea("SA1")
    DbSetOrder(1) 
    SA1->(DbSeek(xFilial("SA1")  + SF2->F2_CLIENTE + SF2->F2_LOJA))
    
    cEstado := SA1->A1_EST
    If SA1->(FieldPos("A1_ZZAGLUT")) > 0
     	cAglutima := SA1->A1_ZZAGLUT
    Endif
                                             
   
	iF cAglutima = "S"
	
		aProd 		:= aParam[1] // Paramixb[1] // -> Produtos
		aICMS 	 	:= Paramixb[21] // -> Impostos : ICMS
		aICMSST		:= Paramixb[22] // ->          : ICMSST
		aPIS		:= Paramixb[23] // ->          : PIS
		aCOFINS		:= Paramixb[24] // ->          : Cofins
		aPedCom		:= ParamIxb[25] // -> Itens Pedido Cliente
		aIPI		:= ParamIxb[26] // -> Impostos : IPI
		aIPIDevol	:= Paramixb[27] // ->          : IPIDevolução
		aPISST		:= Paramixb[28] // ->          : PIS ST
		aCofinsST	:= Paramixb[29] // ->          : Cofins ST
		aICMUFDest	:= Paramixb[30] // ->          : ICMS UF Destino
	
	    // Arrays de recebimento da aglutinação
		_aItens		:= {} 
		_aICMS		:= {}
		_aICMSST	:= {}
		_aIPI		:= {} 
		_aPIS		:= {}
		_aCOFINS	:= {}
		_aPedCom	:= {}
		_aIPIDevol	:= {}
		_aPISST		:= {}
		_aCofinsST	:= {}
		_aICMUFDest	:= {}
		
		
		For nk := 1 to Len(aProd)
			dbSelectARea("SB1")
			dbSetOrder(1)
			dbSeek(xFilial("SB1") + aProd[nk][2])
		                      
							
			_nPos := aScan(_aItens,{|x| Alltrim(x[2]) + Alltrim(x[38]) + Alltrim(x[39]) == Alltrim(aProd[nk][2]) + Alltrim(aProd[nk][38]) + Alltrim(aProd[nk][39]) })
		   
				If _nPos = 0
				// Adiciona
				AADD(_aItens 	, aProd[nk])
				AADD(_aICMS 	, aIcms[nk])
				AADD(_aICMSST 	, aIcmsST[nk])
				AADD(_aIPI 		, aIPI[nk])
				AADD(_aPIS 		, aPIS[nk])
				AADD(_aCOFINS 	, aCOFINS[nk])
				AADD(_aPedCom	, aPedCom[nK])
				AADD(_aIPIDevol	, aIPIDevol[nK])
				AADD(_aPISST	, aPISST[nK])
				AADD(_aCofinsST	, aCofinsST[nK])
				AADD(_aICMUFDest, aICMUFDest[nK])
				
			Else
				// Totaliza
				_aItens[_nPos][9]  	+= aProd[nk][9]
				_aItens[_nPos][10] 	+= aProd[nk][10]
				_aItens[_nPos][12] 	+= aProd[nk][12]
				_aItens[_nPos][13] 	+= aProd[nk][13]
				_aItens[_nPos][21] 	+= aProd[nk][21]
				_aIcms[_nPos][5]	+= aIcms[nk][5]
				_aIcms[_nPos][7]    += aIcms[nk][7]
				

				If Type("aPedCom[nk]") <> "U"
					_aPedCom[_nPos]   := aPedCom[nk]
				EndIf

				If Len(aIPI) > 0 .and. Len(aIPI[nk]) > 0
					_aIPI[_nPos][6]       += aIPI[nk][6]
					_aIPI[_nPos][8]       += aIPI[nk][8]
					_aIPI[_nPos][7]       += aIPI[nk][7]
					_aIPI[_nPos][10]      += aIPI[nk][10]
				EndIf

				If Len(aPis) > 0 .AND. Len(aPis[1]) > 0
					_aPis[_nPos][2]       += aPis[nk][2]
					_aPis[_nPos][4]       += aPis[nk][4]
					_aPis[_nPos][5]       += aPis[nk][5]
				Else
					_aPis := aClone(aPis)
				EndIf

				If Len(aCofins) > 0 .AND. Len(aCofins[1]) > 0
					_aCofins[_nPos][2]  += aCofins[nk][2]
					_aCofins[_nPos][4]  += aCofins[nk][4]
					_aCofins[_nPos][5]  += aCofins[nk][5]
				Else
					_aCofins := aClone(aCofins)
				EndIf

				If Len(aICMSST) > 0 .AND. Len(aICMSST[1]) > 0
					_aICMSST[_nPos][5]   += aICMSST[nk][5]
					_aICMSST[_nPos][7]   += aICMSST[nk][7]
					_aICMSST[_nPos][9]   += aICMSST[nk][9]
				Else
					_aICMSST := aClone(aICMSST)
				EndIf

				If Len(aIPIDevol) > 0 .AND. Len(aIPIDevol[1]) > 0
					_aIPIDevol[_nPos][2]   += aIPIDevol[nk][2]
				Else
					_aIPIDevol := aClone(aIPIDevol)
				EndIf


				If Len(aPISST) > 0 .AND. Len(aPISST[1]) > 0
					_aPISST[_nPos][4]   += aPISST[nk][4]
					_aPISST[_nPos][5]   += aPISST[nk][5]
				Else
					_aPISST := aClone(aPISST)
				EndIf

				If Len(aCofinsST) > 0 .AND. Len(aCofinsST[1]) > 0
					_aCofinsST[_nPos][4]   += aCofinsST[nk][4]
					_aCofinsST[_nPos][5]   += aCofinsST[nk][5]
				Else
					_aCofinsST := aClone(aPISST)
				EndIf

				If Len(aICMUFDest) > 0 .AND. Len(aICMUFDest[1]) > 0
					_aICMUFDest[_nPos][1]   += aICMUFDest[nk][1]
					_aICMUFDest[_nPos][6]   += aICMUFDest[nk][6]
					_aICMUFDest[_nPos][7]   += aICMUFDest[nk][7]
					_aICMUFDest[_nPos][8]   += aICMUFDest[nk][8]
				Else
					_aICMUFDest := aClone(aICMUFDest)
				EndIf


			Endif
		Next         
		
		//tratamento para não pular itens na nfe.	
		For i := 1 to Len(_aItens)
			_aItens[i][1] := i
		Next i

		aParam[01] := _aItens
		aParam[21] := _aICMS
		aParam[22] := _aICMSST
		aParam[23] := _aPIS
		aParam[24] := _aCOFINS
		aParam[25] := _aPedCom
		aParam[26] := _aIPI
		aParam[27] := _aIPIDevol
		aParam[28] := _aPISST
		aParam[29] := _aCofinsST
		aParam[30] := _aICMUFDest
		
		
	Endif
Endif


Lj7RestArea(aArea)

Return aParam

Static Function PegaUMOriginal(nOperacao)
	local lSaida 	:= (nOperacao == 1)
	Local cQuery	:= ""
	Local cAliasNFOri :=  GetNextAlias()
	Local aRetorno 	:= {}
	
	if lSaida .AND. SD2->D2_TIPO $ "D/B"
		cQuery := "SELECT D1_COD, D1_UNIDADE, D1_SEGUM, D1_UM FROM "+RetSqlName("SD1")+" D1"+ CRLF"
		cQuery += " WHERE D1_FILIAL = '" + xFilial("SD1") + "'"+ CRLF
		cQuery += " AND D1_DOC = '" + SD2->D2_NFORI + "'"+ CRLF
		cQuery += " AND D1_SERIE = '" + SD2->D2_SERIORI + "'"+ CRLF
		cQuery += " AND D1_ITEM = '" + SD2->D2_ITEMORI + "'"+ CRLF
		cQuery += " AND D1_FORNECE = '" + SD2->D2_CLIENTE + "'"+ CRLF
		cQuery += " AND D1_LOJA = '" + SD2->D2_LOJA + "'"+ CRLF
		cQuery += " AND D1.D_E_L_E_T_ = ' ' "+ CRLF
	elseIf lSaida .AND. alltrim(SD2->D2_TIPO) $ "CIP"
		cQuery := "SELECT D2_COD, C6_UNIDADE, D2_SEGUM, D2_UM FROM " + RetSqlName("SD2")+" D2" + CRLF"
		cQuery += " INNER JOIN " + RetSqlName("SC6")+" C6" + CRLF
		cQuery += " ON C6_FILIAL = '" + xFilial("SC6") + "'" + CRLF
		cQuery += " AND C6_NUM = D2_PEDIDO" + CRLF
		cQuery += " AND C6_ITEM = D2_ITEMPV" + CRLF
		cQuery += " AND C6.D_E_L_E_T_ = ' ' "+ CRLF
		cQuery += " WHERE D2_FILIAL = '" + xFilial("SD2") + "'"+ CRLF
		cQuery += " AND D2_DOC = '" + SD2->D2_NFORI + "'"+ CRLF
		cQuery += " AND D2_SERIE = '" + SD2->D2_SERIORI + "'"+ CRLF
		cQuery += " AND D2_ITEM = '" + SD2->D2_ITEMORI + "'"+ CRLF
		cQuery += " AND D2.D_E_L_E_T_ = ' ' "+ CRLF
	elseIf !lSaida .AND. SD1->D1_TIPO $ "D/B"
		cQuery := "SELECT D2_COD, C6_UNIDADE, D2_SEGUM, D2_UM FROM " + RetSqlName("SD2")+" D2" + CRLF"
		cQuery += " INNER JOIN " + RetSqlName("SC6")+" C6" + CRLF"
		cQuery += " ON C6_FILIAL = '" + xFilial("SC6") + "'" + CRLF
		cQuery += " AND C6_NUM = D2_PEDIDO" + CRLF
		cQuery += " AND C6_ITEM = D2_ITEMPV" + CRLF
		cQuery += " AND C6.D_E_L_E_T_ = ' ' "+ CRLF
		cQuery += " WHERE D2_FILIAL = '" + xFilial("SD2") + "'"+ CRLF
		cQuery += " AND D2_DOC = '" + SD1->D1_NFORI + "'"+ CRLF
		cQuery += " AND D2_SERIE = '" + SD1->D1_SERIORI + "'"+ CRLF
		cQuery += " AND D2_ITEM = '" + SD1->D1_ITEMORI + "'"+ CRLF
		cQuery += " AND D2.D_E_L_E_T_ = ' ' "+ CRLF
	elseIf !lSaida .AND. alltrim(SD1->D1_TIPO) $ "CIP"
		cQuery := "SELECT D1_COD, D1_UNIDADE, D1_SEGUM, D1_UM FROM "+RetSqlName("SD1")+" D1"+ CRLF"
		cQuery += " WHERE D1_FILIAL = '" + xFilial("SD1") + "'"+ CRLF
		cQuery += " AND D1_DOC = '" + SD1->D1_NFORI + "'"+ CRLF
		cQuery += " AND D1_SERIE = '" + SD1->D1_SERIORI + "'"+ CRLF
		cQuery += " AND D1_ITEM = '" + SD1->D1_ITEMORI + "'"+ CRLF
		cQuery += " AND D1_FORNECE = '" + SD2->D2_CLIENTE + "'"+ CRLF
		cQuery += " AND D1_LOJA = '" + SD2->D2_LOJA + "'"+ CRLF
		cQuery += " AND D1.D_E_L_E_T_ = ' ' "+ CRLF
	endIf
	if !empty(cQuery)
		TcQuery cQuery NEW Alias &cAliasNFOri
	endIf
	If Select(cAliasNFOri) <> 0
		Do While (cAliasNFOri)->(!Eof())
			If (lSaida .AND. SD2->D2_TIPO $ "D/B") .or. (!lSaida .AND. alltrim(SD1->D1_TIPO) $ "CIP")
				If (cAliasNFOri)->D1_UNIDADE == '2'
		            AADD(aRetorno, { (cAliasNFOri)->D1_SEGUM, .T. } )
		        ElseIf (cAliasNFOri)->D1_UNIDADE == '1'
		            AADD(aRetorno, { (cAliasNFOri)->D1_UM, .F. } )
		        EndIf
		   	elseIf (lSaida .AND. alltrim(SD2->D2_TIPO) $ "CIP") .or. (!lSaida .AND. SD1->D1_TIPO $ "D/B")
				If (cAliasNFOri)->C6_UNIDADE == '2'
		            AADD(aRetorno, { (cAliasNFOri)->D2_SEGUM, .T. } )
		        ElseIf (cAliasNFOri)->C6_UNIDADE == '1'
		            AADD(aRetorno, { (cAliasNFOri)->D2_UM, .F. } )
		        EndIf
	        EndIf
			
			(cAliasNFOri)->(dbSkip())
		endDo
		(cAliasNFOri)->(dbCloseArea()) 
	endIf
	
Return aRetorno

/*/{Protheus.doc} RetPrvUnit
   Calcula a o valor unitario da nfe de saida.

   @author andre.cruz@tuningsistemas.com.br
   @since 20140212
/*/
Static Function RetPrvUnit(cTipoNF, nQuant, nPrUnit, nPrcVen, nDesconto, nDescZF, nTotal)
Local nRetorno := 0

If cTipoNF $ "IP" // Se for complento de o valor unitario ï¿½ zero
    nRetorno := 0
Else 
    If nQuant < 1 // se a quantidade for menor que 1 trata a quantidade para nï¿½o aumentar o valor unitario
        if nPrUnit == nPrcVen 
            nRetorno := ( ( ( nPrUnit * nQuant ) + nDesconto + nDescZF ) / nQuant )    
        elseif nPrUnit < nPrcVen
            nRetorno := ( ( ( nPrcVen * nQuant ) + nDescZF ) / nQuant )        
        else
            nRetorno := ( ( ( nPrUnit * nQuant ) + nDescZF ) / nQuant )
        endif
    Else // se nao tratamento normal
        nRetorno := ( ( nTotal + nDesconto + nDescZF ) / nQuant )
    Endif
Endif
Return( NoRound( nRetorno, 8 ) )


****************************************************
** Acha Inf Impost Import - Fernando ** 10/10/2018
****************************************************
Static Function AchaImp()
****************************************************
Local nContProf := 0
Store 0 to _wnvlrpis,_wnvlrcof,_wniival, _wdTxSisc, _wnICMS, _wMarinha, _wMarinhaOld, nFobTot

oldarea := Alias()

DbSelectArea("SWN")
DbSetOrder(1)
if DbSeek(xFilial("SWN")+_wnDoc+_wnSerie)

//if !Empty(SWN->WN_DOC)

If !Eof()
	While SWN->WN_DOC == _wnDoc .AND. !Eof()
		_wnvlrpis    := _wnvlrpis  + SWN->WN_VLRPIS
		_wnvlrcof    := _wnvlrcof  + SWN->WN_VLRCOF
		_wniival     := _wniival   + SWN->WN_IIVAL
		_wnICMS      := _wnICMS    + SWN->WN_VICMDIF
		nFobTot      := nFobTot    + SWN->WN_FOB_R
		//_wMarinha    := _wMarinha  + SWN->WN_AFRMM
		//_wMarinhaOLD := _wMarinha  + SWN->WN_AFRMM
		//_wdTxSisc    := _wdTxSisc  + SWN->WN_DESPICM
		
		If !Alltrim(SWN->WN_HAWB) $ _wnPONum
			nContProf := nContProf + 1
			If nContProf > 1
				_wnNrProf := _wnNrProf+ " / "
			Endif      
			
			_wnPONUm  := alltrim(_wnPONUm)+alltrim(SWN->WN_HAWB) + "/"
			cProfW2   := Posicione("SW9",3,xFilial("SW9")+SWN->WN_HAWB,"W9_INVOICE")
			//nFobTot   := Posicione("SW9",3,xFilial("SW9")+SWN->WN_HAWB,"W9_FOB_TOT") 
			nTxDi     := Posicione("SW9",3,xFilial("SW9")+SWN->WN_HAWB,"W9_TX_FOB") 
			cDtInv    := " Dt Venc: "+DtoC(Posicione("SWB",1,xFilial("SWB")+SWN->WN_HAWB,"WB_DT_VEN"))
			cMoe      := Posicione("SWB",1,xFilial("SWB")+SWN->WN_HAWB,"WB_MOEDA")
		    cTxFob    := " Tx Inv "+cMoe+": "+Alltrim(Transform(nTxDi ,"@E 999.99999")) //+CHR(13)+CHR(10)

			_wnNrProf := Alltrim(_wnNrProf)+Alltrim(cProfW2)+CHR(13)+CHR(10)//+cDtInv+cVrInv+cTxFob+CHR(13)+CHR(10)
		
		Endif
		DbSkip()
	Enddo
Endif

    cVrInv    := " Vr Inv "+cMoe+": "+Alltrim(Transform((nFobTot/nTxDi),"@E 999,999.99")) //+CHR(13)+CHR(10) 
	_wnNrProf := _wnNrProf + cDtInv+cVrInv+cTxFob+CHR(13)+CHR(10)

*******************************
**** Identifica Taxa Siscomex
*******************************

DbSelectArea("SWD")
DbSetOrder(1)

IF Dbseek(xFilial("SWD")+_hawb+"405")
	If SF1->F1_TIPO == "N"
		If Len(Alltrim(_hawbNFE)) > 10
			_wMarinha := 0
		Else
			_wMarinha := SWD->WD_VALOR_R
		EndIF
	Endif
Endif

If Dbseek(xFilial("SWD")+_hawb+"415")
	If SF1->F1_TIPO == "N"
		If Len(Alltrim(_hawbNFE)) > 10
			_wdTxSisc := 0
		Else
			_wdTxSisc := SWD->WD_VALOR_R
		EndIF
	Endif
Endif
Endif  

DbSelectArea(OldArea)

Return
