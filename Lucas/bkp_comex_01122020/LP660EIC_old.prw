#INCLUDE "rwmake.ch"

/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
	±±ºPrograma  ³Execblok LP Autor ³ Fernando           º Data ³  29/06/17   º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºDescricao ³ Varredura das informações do EIC para envio ao lancamento  º±±
	±±º          ³ padrao                                                     º±±
	±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
	±±ºUso       ³ 
	±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

*****************************
User Function LP660EIC()
**** Rateio do Frete
*****************************
	Local _cHawb   := SF1->F1_HAWB
	Local _nValFre := 0.00
	Local _F1Area  := GetArea()

	If AllTrim(SF1->F1_TIPO_NF) == "1" // Fernando - 21/01/2016
		DbSelectArea("SWN")
		DbSetOrder(2)
		If DbSeek(xFilial("SWN")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
			While SWN->WN_DOC+SWN->WN_SERIE+SWN->WN_FORNECE+SWN->WN_LOJA == SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA .AND. !Eof()
				_nValFre += SWN->WN_FRETE
				DbSkip()
			EndDo
		Endif
	Endif

	RestArea(_F1Area)

	Return(_nValFre)

*****************************
User Function LP660II()
**** Rateio do Imposto Import
*****************************
	Local _cHawb   := SF1->F1_HAWB
	Local _nValII := 0.00
	Local _F1Area  := GetArea()

	DbSelectArea("SWN")
	DbSetOrder(2)

	If AllTrim(SF1->F1_TIPO_NF) == "1" // Fernando - 21/01/2016
		If DbSeek(xFilial("SWN")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
			While SWN->WN_DOC+SWN->WN_SERIE+SWN->WN_FORNECE+SWN->WN_LOJA == SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA .AND. !Eof()
				_nValII += SWN->WN_IIVAL
				DbSkip()
			EndDo
		Endif
	Endif

	RestArea(_F1Area)

	Return(_nValII)

*****************************
User Function LP660SEG()
**** Rateio do Seguro
*****************************
	Local _cHawb   := SF1->F1_HAWB
	Local _nValSEG := 0.00
	Local _F1Area  := GetArea()

	DbSelectArea("SWN")
	DbSetOrder(2)

	If AllTrim(SF1->F1_TIPO_NF) == "1" // Fernando - 21/01/2016
		If DbSeek(xFilial("SWN")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
			While SWN->WN_DOC+SWN->WN_SERIE+SWN->WN_FORNECE+SWN->WN_LOJA == SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA .AND. !Eof()
				_nValSEG += SWN->WN_SEGURO
				DbSkip()
			EndDo
		Endif
	Endif

	RestArea(_F1Area)

	Return(_nValSEG)

*****************************
User Function LP660CAP()
**** Rateio do Capatazias
*****************************
	Local _cHawb   := SF1->F1_HAWB
	Local _nValCap:= 0.00
	Local _F1Area  := GetArea()

	DbSelectArea("SWN")
	DbSetOrder(2)

	If AllTrim(SF1->F1_TIPO_NF) == "1" // Fernando - 21/01/2016
		If DbSeek(xFilial("SWN")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
			While SWN->WN_DOC+SWN->WN_SERIE+SWN->WN_FORNECE+SWN->WN_LOJA == SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA .AND. !Eof()
				_nValCap += SWN->WN_DESPADU
				DbSkip()
			EndDo
		Endif
	Endif

	RestArea(_F1Area)

	Return(_nValCap)

********************************
User Function LP660COFM()
**** Rateio do Cofins Majorado
********************************
	Local _cHawb    := SF1->F1_HAWB
	Local _nValCOFM := 0.00
	Local _F1Area   := GetArea()

	DbSelectArea("SWN")
	DbSetOrder(2)

	If AllTrim(SF1->F1_TIPO_NF) == "1" // Fernando - 21/01/2016
			If DbSeek(xFilial("SWN")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
			While SWN->WN_DOC+SWN->WN_SERIE+SWN->WN_FORNECE+SWN->WN_LOJA == SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA .AND. !Eof()
				_nValCOFM  += SWN->WN_VLCOFM
				DbSkip()
			EndDo
		Endif
	Endif

	RestArea(_F1Area)

	Return(_nValCOFM)

*****************************
User Function LP660TXC()
**** Rateio do Taxa Siscomex
*****************************
	Local _cHawb   := SF1->F1_HAWB
	Local _nValTXC:= 0.00
	Local _F1Area  := GetArea()

	If AllTrim(SF1->F1_TIPO_NF) == "1" // Fernando - 21/01/2016
		_nValTXC := Posicione("SWD",1, xFilial("SWD")+SF1->F1_HAWB+"415","WD_VALOR_R") //SF1->F1_DESPESA
	Endif

	RestArea(_F1Area)

	Return(_nValTXC)

*****************************
User Function LP660MAR()
**** Rateio do Marinha
*****************************
	Local _cHawb   := SF1->F1_HAWB
	Local _nValMAR:= 0.00
	Local _F1Area  := GetArea()

	If AllTrim(SF1->F1_TIPO_NF) == "1" // Fernando - 21/01/2016
		_nValMAR := Posicione("SWD",1, xFilial("SWD")+SF1->F1_HAWB+"405","WD_VALOR_R")
	Endif

	RestArea(_F1Area)

Return(_nValMAR)

*********************************
User Function LP660CONT(cTipoCT)
**** Auxilia Contas Contabeis
*********************************
Local _cHawb   := SF1->F1_HAWB
Local cNRConta:= ""
Local _F1Area  := GetArea()

cAliasdesp := GetArea()
Private cCodDesp   := Posicione("SW6",1,xFilial("SW6")+SF1->F1_HAWB,"W6_DESP")
Private	cForDesp   := Posicione("SY5",1,xFilial("SY5")+cCodDesp,"Y5_FORNECE")
Private cLojDesp   := Posicione("SY5",1,xFilial("SY5")+cCodDesp,"Y5_LOJAF")
Private cContaDesp := Posicione("SA2",1,xFilial("SA2")+cForDesp+cLojDesp,"A2_CONTA")
RestArea(cAliasdesp)       

If AllTrim(SF1->F1_TIPO_NF) == "1" // Fernando - 21/01/2016
	cFlagTip := Posicione("SW6",1, xFilial("SW6")+_cHawb,"W6_XTPMAT")
Endif

RestArea(_F1Area)

Do Case 

    **** FOB - Invoice
    *************************************
	Case Substr(cTipoCT,1,3) == "FOB"

	    _cFor      := SF1->F1_FORNECE
	    _cLoj      := SF1->F1_LOJA
	    cContaForn := Posicione("SA2",1,xFilial("SA2")+_cFor+_cLoj,"A2_CONTA")

		If cFlagTip == '1'
			If Substr(cTipoCT,4,1) == "D"
				cNRConta := SB1->B1_CONTA
			ElseIF Substr(cTipoCT,4,1) == "C"
				cNRConta := cContaForn
			Endif
		ElseIF cFlagTip == '2'
			If Substr(cTipoCT,4,1) == "D"
				cNRConta := SB1->B1_CONTA
			ElseIF Substr(cTipoCT,4,1) == "C"
				cNRConta := cContaForn
			Endif
		ElseIF Alltrim(cFlagTip) == '3'
			If Substr(cTipoCT,4,1) == "D"
				cNRConta := SB1->B1_CONTA
			ElseIF Substr(cTipoCT,4,1) == "C"
				cNRConta := cContaForn
			Endif
		Endif                        
		
    **** Frete Internacional
    *************************************
	Case Substr(cTipoCT,1,3) == "FRE"
		If cFlagTip == '1'
			If Substr(cTipoCT,4,1) == "D"
				cNRConta := SB1->B1_CONTA
			ElseIF Substr(cTipoCT,4,1) == "C"
				cNRConta := cContaDesp
			Endif
		ElseIF cFlagTip == '2'
			If Substr(cTipoCT,4,1) == "D"
				cNRConta := SB1->B1_CONTA
			ElseIF Substr(cTipoCT,4,1) == "C"
				cNRConta := cContaDesp
			Endif
		ElseIF Alltrim(cFlagTip) == '3'
			If Substr(cTipoCT,4,1) == "D"
				cNRConta := SB1->B1_CONTA
			ElseIF Substr(cTipoCT,4,1) == "C"
				cNRConta := cContaDesp
			Endif
		Endif

    **** Imposto Import
    *************************************
	Case Substr(cTipoCT,1,3) == "IIM"
		If cFlagTip == '1'
			If Substr(cTipoCT,4,1) == "D"
				cNRConta := SB1->B1_CONTA
			ElseIF Substr(cTipoCT,4,1) == "C"
				cNRConta := "11030801"
			Endif
		ElseIF cFlagTip == '2'
			If Substr(cTipoCT,4,1) == "D"
				cNRConta := SB1->B1_CONTA
			ElseIF Substr(cTipoCT,4,1) == "C"
				cNRConta := "11050104"
			Endif
		ElseIF Alltrim(cFlagTip) == '3'
			If Substr(cTipoCT,4,1) == "D"
				cNRConta := SB1->B1_CONTA
			ElseIF Substr(cTipoCT,4,1) == "C"
				cNRConta := "17040396"
			Endif
		Endif                        

    **** Taxa Siscomex
    *************************************
	Case Substr(cTipoCT,1,3) == "TXS"
		If cFlagTip == '1'
			If Substr(cTipoCT,4,1) == "D"
				cNRConta := SB1->B1_CONTA
			ElseIF Substr(cTipoCT,4,1) == "C"
				cNRConta := "11030801"
			Endif
		ElseIF cFlagTip == '2'
			If Substr(cTipoCT,4,1) == "D"
				cNRConta := SB1->B1_CONTA
			ElseIF Substr(cTipoCT,4,1) == "C"
				cNRConta := "11050104"
			Endif
		ElseIF Alltrim(cFlagTip) == '3'
			If Substr(cTipoCT,4,1) == "D"
				cNRConta := SB1->B1_CONTA
			ElseIF Substr(cTipoCT,4,1) == "C"
				cNRConta := "17040396"
			Endif
		Endif                        

    **** Capatazias
    *************************************
	Case Substr(cTipoCT,1,3) == "CAP"
		If cFlagTip == '1'
			If Substr(cTipoCT,4,1) == "D"
				cNRConta := SB1->B1_CONTA
			ElseIF Substr(cTipoCT,4,1) == "C"
				cNRConta := cContaDesp
			Endif
		ElseIF cFlagTip == '2'
			If Substr(cTipoCT,4,1) == "D"
				cNRConta := SB1->B1_CONTA
			ElseIF Substr(cTipoCT,4,1) == "C"
				cNRConta := cContaDesp
			Endif
		ElseIF Alltrim(cFlagTip) == '3'
			If Substr(cTipoCT,4,1) == "D"
				cNRConta := SB1->B1_CONTA
			ElseIF Substr(cTipoCT,4,1) == "C"
				cNRConta := cContaDesp
			Endif
		Endif                        

    **** Seguro
    *************************************
	Case Substr(cTipoCT,1,3) == "SEG"
		If cFlagTip == '1'
			If Substr(cTipoCT,4,1) == "D"
				cNRConta := SB1->B1_CONTA
			ElseIF Substr(cTipoCT,4,1) == "C"
				cNRConta := "21012107"
			Endif
		ElseIF cFlagTip == '2'
			If Substr(cTipoCT,4,1) == "D"
				cNRConta := SB1->B1_CONTA
			ElseIF Substr(cTipoCT,4,1) == "C"
				cNRConta := "21012107"
			Endif
		ElseIF Alltrim(cFlagTip) == '3'
			If Substr(cTipoCT,4,1) == "D"
				cNRConta := SB1->B1_CONTA
			ElseIF Substr(cTipoCT,4,1) == "C"
				cNRConta := "21012107"
			Endif
		Endif                        

    **** COFINS
    *************************************
	Case Substr(cTipoCT,1,3) == "COF"
		If cFlagTip == '1'
			If Substr(cTipoCT,4,1) == "D"
				cNRConta := "1105060302"
			ElseIF Substr(cTipoCT,4,1) == "C"
				cNRConta := "11030801"
			Endif
		ElseIF cFlagTip == '2'
			If Substr(cTipoCT,4,1) == "D"
				cNRConta := "1105060302"
			ElseIF Substr(cTipoCT,4,1) == "C"
				cNRConta := "11050104"
			Endif
		ElseIF Alltrim(cFlagTip) == '3'
			If Substr(cTipoCT,4,1) == "D"
				cNRConta := "1105060302"
			ElseIF Substr(cTipoCT,4,1) == "C"
				cNRConta := "17040396"
			Endif
		Endif                        

    **** COFINS Majorado
    *************************************
	Case Substr(cTipoCT,1,3) == "CFM"
		If cFlagTip == '1'
			If Substr(cTipoCT,4,1) == "D"
				cNRConta := SB1->B1_CONTA
			ElseIF Substr(cTipoCT,4,1) == "C"
				cNRConta := "11030801"
			Endif
		ElseIF cFlagTip == '2'
			If Substr(cTipoCT,4,1) == "D"
				cNRConta := SB1->B1_CONTA
			ElseIF Substr(cTipoCT,4,1) == "C"
				cNRConta := "11050104"
			Endif
		ElseIF Alltrim(cFlagTip) == '3'
			If Substr(cTipoCT,4,1) == "D"
				cNRConta := SB1->B1_CONTA
			ElseIF Substr(cTipoCT,4,1) == "C"
				cNRConta := "17040396"
			Endif
		Endif                        

    **** ICMS
    *************************************
	Case Substr(cTipoCT,1,3) == "ICM"
		If cFlagTip == '1'
			If Substr(cTipoCT,4,1) == "D"
				cNRConta := "1105060501"
			ElseIF Substr(cTipoCT,4,1) == "C"
				cNRConta := "11030801"
			Endif
		ElseIF cFlagTip == '2'
			If Substr(cTipoCT,4,1) == "D"
				cNRConta := "1105060501"
			ElseIF Substr(cTipoCT,4,1) == "C"
				cNRConta := "11050104"
			Endif
		ElseIF Alltrim(cFlagTip) == '3'
			If Substr(cTipoCT,4,1) == "D"
				cNRConta := "17010903"
			ElseIF Substr(cTipoCT,4,1) == "C"
				cNRConta := "17040396"
			Endif
		Endif                        

    **** IPI
    *************************************
	Case Substr(cTipoCT,1,3) == "IPI"
		If cFlagTip == '1'
			If Substr(cTipoCT,4,1) == "D"
				cNRConta := "1105060201"
			ElseIF Substr(cTipoCT,4,1) == "C"
				cNRConta := "11030801"
			Endif
		ElseIF cFlagTip == '2'
			If Substr(cTipoCT,4,1) == "D"
				cNRConta := "1105060201"
			ElseIF Substr(cTipoCT,4,1) == "C"
				cNRConta := "11050104"
			Endif
		ElseIF Alltrim(cFlagTip) == '3'
			If Substr(cTipoCT,4,1) == "D"
				cNRConta := "1105060201"
			ElseIF Substr(cTipoCT,4,1) == "C"
				cNRConta := "17040396"
			Endif
		Endif                        

    **** PIS
    *************************************
	Case Substr(cTipoCT,1,3) == "PIS"
		If cFlagTip == '1'
			If Substr(cTipoCT,4,1) == "D"
				cNRConta := "1105060301"
			ElseIF Substr(cTipoCT,4,1) == "C"
				cNRConta := "11030801"
			Endif
		ElseIF cFlagTip == '2'
			If Substr(cTipoCT,4,1) == "D"
				cNRConta := "1105060301"
			ElseIF Substr(cTipoCT,4,1) == "C"
				cNRConta := "11050104"
			Endif
		ElseIF Alltrim(cFlagTip) == '3'
			If Substr(cTipoCT,4,1) == "D"
				cNRConta := "1105060301"
			ElseIF Substr(cTipoCT,4,1) == "C"
				cNRConta := "17040396"
			Endif
		Endif                        

    **** Marinha Mercante
    *************************************
	Case Substr(cTipoCT,1,3) == "MAR"
		If cFlagTip == '1'
			If Substr(cTipoCT,4,1) == "D"
				cNRConta := SB1->B1_CONTA
			ElseIF Substr(cTipoCT,4,1) == "C"
				cNRConta := cContaDesp
			Endif
		ElseIF cFlagTip == '2'
			If Substr(cTipoCT,4,1) == "D"
				cNRConta := SB1->B1_CONTA
			ElseIF Substr(cTipoCT,4,1) == "C"
				cNRConta := cContaDesp
			Endif
		ElseIF Alltrim(cFlagTip) == '3'
			If Substr(cTipoCT,4,1) == "D"
				cNRConta := SB1->B1_CONTA
			ElseIF Substr(cTipoCT,4,1) == "C"
				cNRConta := cContaDesp
			Endif
		Endif                        

EndCase

Return(cNRConta)