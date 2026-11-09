#Include "Protheus.ch"
#Include "TopConn.ch"
//#Include "MsObjects.ch"

/**                                                                               
* Rotina		:	fImpOrc - PARAFIX
* Autor			:	Leandro Camaçari - FSW TOTVS IP CAMPINAS
* Data			:   18/07/2013
* Descricao		:	Relatório de Orçamento
* Modulo		:	TMK
* Observações	:	Cria estrutura TReport
*/  

User Function fImpOrc()    

Local aAreaSM0	      := SM0->(GetArea())
Local aAreaSUA 	      := SUA->(GetArea())
Local aAreaSA1 	      := SA1->(GetArea())
Local aAreaSA3 	      := SA3->(GetArea())
Local aAreaSUB 	      := SUB->(GetArea())    
Local aAreaSB5 	      := SB5->(GetArea())
Local aAreaSB1 	      := SB1->(GetArea())
Local aAreaDA0 	      := DA0->(GetArea())
Local aAreaSE4 	      := SE4->(GetArea())  
Local aAreaSU5 	      := SU5->(GetArea())  
Local aAreaSYP 	      := SYP->(GetArea())

Local cPerg           := "RELTMK"    
                                      
Private cMemo1        := ""  
Private cMemo2        := ""   
Private cMemo2A       := "" 
Private cTituloPT     := ""
Private cTituloEN     := ""
Private cTituloSP     := ""
Private cDescricao    := ""  
// Português  
Private cInicio          := "Agradecemos o interesse pelos nossos produtos e de acordo com as nossas Condições Gerais de venda e Fornecimento. Temos o prazer de submeter à sua apreciação, "
Private cPortuguesFim    := "um orçamento sem compromisso."
// Inglês
Private cComeca          := "We appreciate the interest in our products and in accordance with our General Conditions of Sale and Delivery. We are pleased to present for your consideration, a free quote."
//Private cInglesFim       := "a free quote."
// Espanhol
Private cPrimeiro        := "Agradecemos el interés en nuestros productos y de conformidad con nuestras Condiciones Generales de Venta y Suministro. Tenemos el agrado de presentar a su consideración, un presupuesto sin compromiso."
//Private cEspanholFim     := "un presupuesto sin compromiso."

If MsgYesNo("Imprimir Orçamento?")
    If FindFunction("TRepInUse") 
        ValidPerg(cPerg)
        Pergunte(cPerg,.F.) 
        
        If Pergunte(cPerg,.T.)
			oReport:=ReportDef(cPerg)   
	        //oReport:PrintDialog()
	        lRet := oReport:PrintDialog() 
	    Endif      
    Else 
        If MV_PAR01 == 1
            MsgStop("Função TRepInUse NÃO ENCONTRADA no Repositório de Objetos [RPO].", cTituloPT) 
        ElseIf MV_PAR01 == 2
            MsgStop("Função TRepInUse NÃO ENCONTRADA no Repositório de Objetos [RPO].", cTituloEN) 
        ElseIf MV_PAR01 == 3
            MsgStop("Função TRepInUse NÃO ENCONTRADA no Repositório de Objetos [RPO].", cTituloSP) 
        EndIf
    EndIf       
EndIf	 


SUA->(RestArea(aAreaSUA))
SM0->(RestArea(aAreaSM0)) 
SA1->(RestArea(aAreaSA1))
SU5->(RestArea(aAreaSU5))  
SA3->(RestArea(aAreaSA3)) 
SUB->(RestArea(aAreaSUB))
SB5->(RestArea(aAreaSB5)) 
SB1->(RestArea(aAreaSB1)) 
DA0->(RestArea(aAreaDA0)) 
SE4->(RestArea(aAreaSE4)) 
SYP->(RestArea(aAreaSYP)) 

Return


/**
* Rotina		:	ReportDef
* Autor			:	Leandro - FSW TOTVS IP CAMPINAS.
* Data			:   18/07/2013
* Descricao		:	Impressão do Relatório
*/                  

Static Function ReportDef(cPerg)    
  	
Local oReport
Local oSect01 
Local oSect02
Local oSect03
Local oSect99  
Local oCell
Local oBreak1
Local nQtdPontos 	:= 20  
Local oFont14A   	:= TFont():New("Arial"	, 14, 14,, .F.,,,,, .F., .F.)  // Define a fonte 
Local oArial07	    := TFont():New("Arial", 07, 07, , .F., , , , , .F.)  
Local oArial08	    := TFont():New("Arial", 08, 08, , .F., , , , , .F.)
Local oArial08N	    := TFont():New("Arial", 08, 08, , .T., , , , , .F.)
Local oArial10N	    := TFont():New("Arial", 10, 10, , .T., , , , , .F.) 
Local oArial10 	    := TFont():New("Arial", 10, 10, , .F., , , , , .F.)
Local oArial12N	    := TFont():New("Arial", 12, 12, , .T., , , , , .F.) 
Local oArial12	    := TFont():New("Arial", 12, 12, , .F., , , , , .F.)
Local oArial14N 	:= TFont():New("Arial", 14, 14, , .T., , , , , .F.)
Local oArial16N 	:= TFont():New("Arial", 16, 16, , .T., , , , , .F.)
Local oArial20N 	:= TFont():New("Arial", 20, 20, , .T., , , , , .F.)
Local cNomeRel		:= FunName()
Private cClassif
Private cCodProd 	:= ""  
Private cCod        := ""
Private cDesProd	:= "" 
Private cDesProd1   := "" 
Private cDesProd2   := ""
Private cMontadora	:= ""
Private cFabricant	:= ""
Private nQtdeEnt	:= 0
Private cUnidMed	:= ""
Private nValUnit	:= 0
Private nDesconto   := 0
Private nTotBrut	:= 0
Private	nAcresc		:= 0
Private	nTotLiq		:= 0     
Private nX          := 0  

Private oPrint	 := TmsPrinter():New() 

If MV_PAR01 == 1
    cTituloPT := SUA->UA_NUM        // Português
ElseIf MV_PAR01 == 2     
    cTituloEN := SUA->UA_NUM        // Inglês
ElseIf MV_PAR01 == 3
    cTituloSP := SUA->UA_NUM        // Espanhol
EndIf


If MV_PAR01 == 1      // Português
    //oReport := TReport():New(cNomeRel,cTituloPT,cPerg,{|oReport| PrintRepor(oReport)},cTituloPT,.T./*lLandscape*/,,.F.,,.F.)  
    oReport := TReport():New(cPerg,cTituloPT,/*cPerg*/,{|oReport| PrintRepor( oReport )},cTituloPT,.F./*lLandscape*/,,.F.,,.F.)  
    oReport:SetTitle(cTituloPT)
    oReport:cFontBody	    := 'Courier New'
    oReport:nFontBody	    := 08
    oReport:lParamPage 	    := .F. 
    oReport:lHeaderVisible  := .F. //Define o cabeçalho como visible false 
    oReport:SetLineHeight(36)
    oReport:DisableOrientation(.T.)
ElseIf MV_PAR01 == 2  // Inglês
    //oReport := TReport():New(cNomeRel,cTitulo,,{|oReport| PrintRepor(oReport)},cTitulo,.T./*lLandscape*/,,.F.,,.F.)  
    oReport := TReport():New(cPerg,cTituloEN,/*cPerg*/,{|oReport| PrintRepor( oReport )},cTituloEN,.F./*lLandscape*/,,.F.,,.F.)  
    oReport:SetTitle(cTituloEN)
    oReport:cFontBody	    := 'Courier New'
    oReport:nFontBody	    := 08
    oReport:lParamPage 	    := .F. 
    oReport:lHeaderVisible  := .F. //Define o cabeçalho como visible false 
    oReport:SetLineHeight(36)
    oReport:DisableOrientation(.T.)
ElseIf MV_PAR01 == 3  // Espanhol
    //oReport := TReport():New(cNomeRel,cTitulo,,{|oReport| PrintRepor(oReport)},cTitulo,.T./*lLandscape*/,,.F.,,.F.)  
    oReport := TReport():New(cPerg,cTituloSP,/*cPerg*/,{|oReport| PrintRepor( oReport )},cTituloSP,.F./*lLandscape*/,,.F.,,.F.)  
    oReport:SetTitle(cTituloSP)
    oReport:cFontBody	    := 'Courier New'
    oReport:nFontBody	    := 08
    oReport:lParamPage 	    := .F. 
    oReport:lHeaderVisible  := .F. //Define o cabeçalho como visible false 
    oReport:SetLineHeight(36)
    oReport:DisableOrientation(.T.)
EndIf	                                                                                                                   
	

If MV_PAR01 == 1     // Português
    oSect01 := TRSection():New(oReport, "Dados da Nota Fiscal de Entrada",,,,,,,,,,,,.T.)       
ElseIf MV_PAR01 == 2 // Inglês
    oSect01 := TRSection():New(oReport, "Data Entry Invoice",,,,,,,,,,,,.T.)
ElseIf MV_PAR01 == 3 // Espanhol
    oSect01 := TRSection():New(oReport, "Los Datos de Entrada de Facturas",,,,,,,,,,,,.T.)
EndIf


DbSelectArea("SUB")
SUB->(dbGoTop())
SUB->(dbSetOrder(1)) 
SUB->(dbSeek(SUA->UA_FILIAL+SUA->UA_NUM)) 
    
DbSelectArea("SB1")	
SB1->(DbSetOrder(1))  
                     
If MV_PAR01 == 1	   // Português	
    oSect02 := TRSection():New(oSect01	, "Produtos NF")     
    oSect99 := TRSection():New(oSect02, "",,,,,,,,,,,,.T.)
    
    oCell := TRCell():New(oSect02, "UB_PRODUTO" 	, "SUB","Produto"			   		,,040,,{|| cCodProd	})     
    oCell:oFontBody := oArial08N
    oCell := TRCell():New(oSect02, "UB_ZZDESC" 	, "SUB","Descrição"	,,190,,{|| cDescricao }) 
    oCell:oFontBody := oArial08N
    oCell := TRCell():New(oSect02, "UB_QUANT" 	, "SUB","Qtde",,08,,{|| nQtdeEnt	},"Left",,"Left") 
    oCell:oFontBody := oArial08N
    oCell := TRCell():New(oSect02, "B1_UM"  		, "SB1","UN",,06,,{|| cUnidMed	},"Left",,"Left")
    oCell:oFontBody := oArial08N
    oCell := TRCell():New(oSect02, "UB_VRUNIT" 	, "SUB","Prc.Unit",,015,,{|| nValUnit	},"Left",,"Left") 
    oCell:oFontBody := oArial08N
    oCell := TRCell():New(oSect02, "TOTBRUT" 	, "   ",'Total'	,"@E 999,999,999.99",020,,{|| nTotBrut  },"Center",,"Left")    
    oCell:oFontBody := oArial08N
    
    oSect03 := TRSection():New(oSect01	, "Finalização",,,,,,,,,,,,.T.)                                                                       
    
ElseIf MV_PAR01 == 2   // Inglês
    oSect02 := TRSection():New(oSect01	, "Products NC")
    
    oCell := TRCell():New(oSect02, "UB_PRODUTO" 	, "SUB","Product/Service"			   		,,040,,{|| cCodProd	}) 
    oCell:oFontBody := oArial08N
    oCell := TRCell():New(oSect02, "UB_ZZDESC" 	, "SUB","Product Description/Service"	,,190,,{|| cDescricao }) 
    oCell:oFontBody := oArial08N
    oCell := TRCell():New(oSect02, "UB_QUANT" 	, "SUB","Amount",,08,,{|| nQtdeEnt	},"Left",,"Left") 
    oCell:oFontBody := oArial08N
    oCell := TRCell():New(oSect02, "B1_UM"  		, "SB1","UN",,06,,{|| cUnidMed	},"Left",,"Left")
    oCell:oFontBody := oArial08N
    oCell := TRCell():New(oSect02, "UB_ZZMOE2" 	, "SUB","Unt US$.",,015,,{|| nValUnit	},"Left",,"Left") 
    oCell:oFontBody := oArial08N
    oCell := TRCell():New(oSect02, "TOTBRUT" 	, "   ",'Tot US$'	,"@E 999,999,999.99",020,,{|| nTotBrut  },"Center",,"Left")
    oCell:oFontBody := oArial08N
    
    oSect03 := TRSection():New(oSect01	, "Finalization",,,,,,,,,,,,.T.)

ElseIf MV_PAR01 == 3   // Espanhol
    oSect02 := TRSection():New(oSect01	, "Productos NC")
    
    oCell := TRCell():New(oSect02, "UB_PRODUTO" 	, "SUB","Producto"			   		,,040,,{|| cCodProd	}) 
    oCell:oFontBody := oArial08N
    oCell := TRCell():New(oSect02, "UB_ZZDESC" 	, "SUB","Descripción"	,,190,,{|| cDescricao }) 
    oCell:oFontBody := oArial08N
    oCell := TRCell():New(oSect02, "UB_QUANT" 	, "SUB","Cant",,08,,{|| nQtdeEnt	},"Left",,"Left") 
    oCell:oFontBody := oArial08N
    oCell := TRCell():New(oSect02, "B1_UM"  		, "SB1","Unid",,06,,{|| cUnidMed	},"Left",,"Left")
    oCell:oFontBody := oArial08N
    oCell := TRCell():New(oSect02, "UB_ZZMOE2" 	, "SUB","Unt US$.",,015,,{|| nValUnit	},"Left",,"Left") 
    oCell:oFontBody := oArial08N
    oCell := TRCell():New(oSect02, "TOTBRUT" 	, "   ",'Tot US$'	,"@E 999,999,999.99",020,,{|| nTotBrut  },"Center",,"Left")
    oCell:oFontBody := oArial08N
    
    oSect03 := TRSection():New(oSect01	, "Finalización",,,,,,,,,,,,.T.)

EndIf  


TRCell():New(oSect03, "  " , "",Space(200),,180,,{|| Space(180)})   
TRCell():New(oSect03, "  " , "",Space(200),,180,,{|| Space(180)}) 
TRCell():New(oSect03, "  " , "",Space(200),,180,,{|| Space(180)}) 
TRCell():New(oSect03, "  " , "",Space(200),,180,,{|| Space(180)}) 


Return oReport


/**
* Rotina		:	ReportDef
* Autor			:	Leandro Camaçari - FSW TOTVS IP CAMPINAS
* Data			:   18/07/2013
* Descricao		:	Impressão do Relatório
*/

Static Function PrintRepor(oReport)
	
Local oSect01 	:= oReport:Section(1)
Local oSect02	:= oReport:Section(1):Section(1)                   
Local oSect99	:= oReport:Section(1):Section(1):Section(1)       
Local oSect03	:= oReport:Section(1):Section(2)      
Local oArial08	:= TFont():New("Arial", 08, 08, , .F., , , , , .F.)
Local nRegs		:= 0  
Local nTotal 	:= 0    
			
Count To nRegs        

//Chamando o Cabeçalho 
Cabec(oReport)  
oReport:SetRow(1200)  //Espaçamento de linhas para após a impressão do cabeçalho  
	
oSect01:Init()
oSect01:PrintLine()
 		
cFilSUB := SUB->UB_FILIAL
cNumSUB := SUB->UB_NUM    
		
Do While !SUB->(Eof("SUB")) .And.  SUB->UB_FILIAL == cFilSUB .And. SUB->UB_NUM == cNumSUB
		
    If oReport:Cancel()
        Exit
    EndIf		

    SB1->(dbSeek(xFilial("SB1")+SUB->UB_PRODUTO)) 
					
    cClassif 	:= SubStr(Posicione("SX5",1,xFilial("SX5")+"02"+SB1->B1_TIPO,"X5_DESCRI"), 1, 4)   
    
    DbSelectArea("SB5")
    SB5->(dbSetOrder(1)) 
    SB5->(dbSeek(xFilial("SB5")+SUB->UB_PRODUTO))  
    
    cCodProd   := SUB->UB_PRODUTO     
    cDescricao := SUB->UB_ZZDESC  
    
    cDesProd   := IIF(!Empty(cValTochar(SB5->B5_COMPR)),+" Comp.: "+cValTochar(SB5->B5_COMPR)," ") + IIF(!Empty(cValTochar(SB5->B5_ESPESS)),+" / Espes.: "+cValTochar(SB5->B5_ESPESS)," ") + IIF(!Empty(cValTochar(SB5->B5_LARG)),+" / Larg.: "+cValTochar(SB5->B5_LARG)," ")       
    cDesProd1  := "Quant2: " + cValToChar(SUB->UB_ZZQT2) + " / Unid2: " + Alltrim(SB1->B1_SEGUM) + " / Preço2: " + cValToChar(SUB->UB_ZZVRUN2) 
    
    
    If MV_PAR01 == 1 //Português
        nQtdeEnt	:= SUB->UB_QUANT
        cUnidMed	:= SB1->B1_UM                                                   
        nValUnit	:= SUB->UB_VRUNIT
        nTotal      := (SUB->UB_QUANT * SUB->UB_VRUNIT) 
        nTotBrut	:= nTotal
    Else //Inglês / Espanhol
        nQtdeEnt	:= SUB->UB_QUANT
        cUnidMed	:= SB1->B1_UM                                                   
        nValUnit	:= SUB->UB_ZZMOE2
        nTotal      := (SUB->UB_QUANT * SUB->UB_ZZMOE2)
        nTotBrut	:= nTotal
    EndIf 
    
	  		 
    oSect02:Init()     
    oSect02:PrintLine()
    
    nLinha := oReport:row()
    oReport:setrow(nLinha+10)
     
    oReport:Say(oReport:row(), 440, cDesProd ,oArial08)   
    //oReport:setrow(nLinha+75)
    oReport:setrow(nLinha+120)                       
    oReport:Say(nLinha+60, 440, cDesProd1 ,oArial08)         
    
    	 	
    oReport:IncMeter()

    SUB->(dbSkip())
EndDo
	
oSect02:Finish()		
oSect01:Finish()

oSect03:Init()
oSect03:PrintLine() 

oSect03:Finish()
PrintRoda(oReport)
			
Return    


/**
 * Rotina		:	Cabec
 * Autor		:	Leandro Camaçari - FSW TOTVS IP CAMPINAS
 * Data	   		:	27/08/2013
 * Descricao	:	Cria o Cabeçalho
 */	
Static Function Cabec(oReport)	
	
Local oFont14B 	:= TFont():New("Arial", 14, 14,, .T.,,,,, .F., .F.)  // Define a fonte
Local oFont14Bi	:= TFont():New("Calibri", 14, 14,, .T.,,,,, .T., .T.)  // Define a fonte
Local oFont14	:= TFont():New("Arial"  , 14, 14,, .F.,,,,, .F., .F.)  // Define a fonte
Local oFont12B 	:= TFont():New("Calibri", 12, 12,, .T.,,,,, .F., .F.)  // Define a fonte

Local oArial07	:= TFont():New("Arial", 07, 07, , .F., , , , , .F.)  
Local oArial08	:= TFont():New("Arial", 08, 08, , .F., , , , , .F.)
Local oArial08N	:= TFont():New("Arial", 08, 08, , .T., , , , , .F.)
Local oArial09	:= TFont():New("Arial", 09, 09, , .F., , , , , .F.)
Local oArial09N	:= TFont():New("Arial", 09, 09, , .T., , , , , .F.)
Local oArial10N	:= TFont():New("Arial", 10, 10, , .T., , , , , .F.) 
Local oArial10 	:= TFont():New("Arial", 10, 10, , .F., , , , , .F.)
Local oArial12N	:= TFont():New("Arial", 12, 12, , .T., , , , , .F.) 
Local oArial12	:= TFont():New("Arial", 12, 12, , .F., , , , , .F.)
Local oArial14N	:= TFont():New("Arial", 14, 14, , .T., , , , , .F.)
Local oArial16N	:= TFont():New("Arial", 16, 16, , .T., , , , , .F.)
Local oArial20N	:= TFont():New("Arial", 20, 20, , .T., , , , , .F.)

Local cLogo		:= "\system\logo.bmp" // caminho da imagem
Local cEnder	:= alltrim(SM0->M0_ENDCOB)
Local cCidade	:= alltrim(SM0->M0_CIDCOB)
Local cUF		:= alltrim(SM0->M0_ESTCOB)
Local cCep		:= substr(SM0->M0_CEPCOB,1,5) + "-" + substr(SM0->M0_CEPCOB,6,3)
Local cTel		:= alltrim(SM0->M0_TEL)
Local cPreenc	:= "" 
Local cMemoAgr  := "" 
Local cMensAgr  := ""
	
oReport:SayBitmap(100,1750,cLogo,600,200,,)
 
oReport:Say(200,  014,	"PARAFIX INDUSTRIA E COM. DE FITAS ADESIVAS LTDA."	  		,oArial08N)		
oReport:Say(240,  014,	"Alameda Flavia, 196 - Dois Córregos - Valinhos / SP - Fone: (19)3881-7191 / (19)3881-7189"	  	,oArial08N)
oReport:Say(280,  014,	"Visite nosso www.parafix.com.br"	  	                    ,oArial08N)
oReport:Say(330,  001, padr(cPreenc, (oReport:GetWidth()- 200), "_" ))	

&&Dados do Cliente
DbSelectArea("SA1")
SA1->(dbSetOrder(1))                                                                         
SA1->(dbSeek(xFilial("SA1")+SUA->(UA_CLIENTE+UA_LOJA)))	  
  
&&Dados do Contato
DbSelectArea("SU5")
SU5->(dbSetOrder(1))                                                                         
SU5->(dbSeek(xFilial("SU5")+SUA->UA_CODCONT))	

&&Dados do Vendedor / Condição de Pgto / Tabela de Preços
DbSelectArea("SA3")
SA3->(dbSetOrder(1)) 
SA3->(dbSeek(xFilial("SA3")+SUA->UA_VEND))		
		
DbSelectArea("SE4")
SE4->(dbSetOrder(1)) 
SE4->(dbSeek(xFilial("SE4")+SUA->UA_CONDPG))
		
DbSelectArea("DA0")
DA0->(dbSetOrder(1)) 
DA0->(dbSeek(xFilial("DA0")+SUA->UA_TABELA))

If MV_PAR01 == 1      // Português	 
    
    oReport:Say(400,  014,	"Endereço de Faturamento"	                                                                      ,oArial10)	
    oReport:Say(440,  014,	Alltrim(SA1->A1_NOME)	  		                                                                  ,oArial09N)	
    oReport:Say(480,  014,	Alltrim(SA1->A1_END)	  		                                                                  ,oArial09)
    oReport:Say(520,  014,	Alltrim(SA1->A1_BAIRRO)	  		                                                                  ,oArial09)
    oReport:Say(560,  014,	Alltrim(SA1->A1_MUN) +" Estado.: "+Alltrim(SA1->A1_EST) + " / Pais: "+ Alltrim(SA1->A1_ZZPAIS)    ,oArial09)
 
    oReport:Say(640,  014,	"Endereço de Entrega"	                                                                          ,oArial10)	
    oReport:Say(680,  014,	Alltrim(SA1->A1_NOME)	  		                                                                  ,oArial09N)	
    oReport:Say(720,  014,	Alltrim(SA1->A1_ENDENT)	  		                                                                  ,oArial09)
    oReport:Say(760,  014,	Alltrim(SA1->A1_BAIRROE)	  		                                                              ,oArial09)
    oReport:Say(800,  014,	Alltrim(SA1->A1_MUNE) +" Estado.: "+Alltrim(SA1->A1_ESTE) + " / Pais: "+ Alltrim(SA1->A1_ZZPAIS)  ,oArial09) 
    
    && Divisória das colunas
    oReport:Box(400, 1350, 960, 1350)
    
    oReport:Say(400,  1370,	"N. Orçamento: " + Alltrim(cTituloPT)	  		                         ,oArial09N)
    oReport:Say(440,  1370,	"Data:" + Alltrim(Transform(dDatabase,PesqPict('SUA', 'UA_EMISSAO')))	 ,oArial09N)    
    oReport:Say(520,  1370,	"Vendedor: " 	  		                                                 ,oArial09N)
    oReport:Say(560,  1370,	Alltrim(SA3->A3_NOME)	  		                                         ,oArial09)
    oReport:Say(600,  1370,	"E-mail: " + Alltrim(SA3->A3_EMAIL) 	  		                         ,oArial09N)
    
    oReport:Say(680,  1370,	"Suporte: " 	  		                                                 ,oArial09N)
    oReport:Say(720,  1370,	UsrRetName(__cUserID) 	  		                                         ,oArial09)
    oReport:Say(760,  1370,	"E-mail: "  	  		                                                 ,oArial09N)
    oReport:Say(800,  1370, UsrRetMail (__cUserID )	  		                                         ,oArial09)
    oReport:Say(880,  1370,	"Fone: "  	  		                                                     ,oArial09N) 
    oReport:Say(920,  1370, "("+Alltrim(SA3->A3_DDDTEL)+") " + Alltrim(SA3->A3_TEL)  	  		     ,oArial09)  
    
    && Mensagem 01 
    oReport:Say(1000, 014, PadR(cInicio ,350,' ')	  		                                         ,oArial09) 
    oReport:Say(1040, 014, PadR(cPortuguesFim ,350,' ')	  		                                     ,oArial09)
    && Complemento da Mensagem 01 - Agradecimentos
    cMemoAgr := RetField("SUA",1,XFILIAL("SUA")+SUA->UA_NUM,"SUA->UA_ZZAGRAD")   
    cMensAgr := StrTran( StrTran( cMemoAgr,CHR(13)," ") ,CHR(10)," ") 
    
    oReport:Say(1080, 014, PadR(SUBSTR(cMensAgr,1,161) ,200,' ')	  		                         ,oArial09) 
    oReport:Say(1120, 014, PadR(SUBSTR(cMensAgr,162,307) ,400,' ')	  		                         ,oArial09)                                                                           

ElseIf MV_PAR01 == 2      // Inglês	 
    
    oReport:Say(400,  014,	"Billing Address"	                                                     ,oArial10)	
    oReport:Say(440,  014,	Alltrim(SA1->A1_NOME)	  		                                         ,oArial09N)	
    oReport:Say(480,  014,	Alltrim(SA1->A1_END)	  		                                         ,oArial09)
    oReport:Say(520,  014,	Alltrim(SA1->A1_BAIRRO)	  		                                         ,oArial09)
    oReport:Say(560,  014,	Alltrim(SA1->A1_MUN)+" State.: "+Alltrim(SA1->A1_EST)                    ,oArial09)
 
    oReport:Say(640,  014,	"Delivery Address"	                                                     ,oArial10)	
    oReport:Say(680,  014,	Alltrim(SA1->A1_NOME)	  		                                         ,oArial09N)	
    oReport:Say(720,  014,	Alltrim(SA1->A1_ENDENT)	  		                                         ,oArial09)
    oReport:Say(760,  014,	Alltrim(SA1->A1_BAIRROE)	  		                                     ,oArial09)
    oReport:Say(800,  014,	Alltrim(SA1->A1_MUNE)	  +" State.: "+Alltrim(SA1->A1_ESTE)             ,oArial09) 
                                     
    && Divisória das colunas
    oReport:Box(400, 1350, 960, 1350)
    
    oReport:Say(400,  1370,	"Budget: " + Alltrim(cTituloEN)	  		                                 ,oArial09N)
    oReport:Say(440,  1370,	"Date:" + Alltrim(Transform(dDatabase,PesqPict('SUA', 'UA_EMISSAO')))	 ,oArial09N)    
    oReport:Say(520,  1370,	"Seller: " 	  		                                                     ,oArial09N)
    oReport:Say(560,  1370,	Alltrim(SA3->A3_NOME)	  		                                         ,oArial09)
    oReport:Say(600,  1370,	"E-mail: " + Alltrim(SA3->A3_EMAIL) 	  		                         ,oArial09N)
    
    oReport:Say(680,  1370,	"Suport: " 	  		                                                     ,oArial09N)
    oReport:Say(720,  1370,	UsrRetName(__cUserID) 	  		                                         ,oArial09)
    oReport:Say(760,  1370,	"E-mail: "  	  		                                                 ,oArial09N)
    oReport:Say(800,  1370, UsrRetMail (__cUserID )	  		                                         ,oArial09)
    oReport:Say(880,  1370,	"Phone: "  	  		                                                     ,oArial09N) 
    oReport:Say(920,  1370,	"(19) 3881-7191 / (19) 3881-7189 "  	  		                         ,oArial09)  
    
    && Mensagem 01 
    oReport:Say(1000, 014, PadR(cComeca ,350,' ')	  		                                         ,oArial09) 
    //oReport:Say(1040, 014, PadR(cInglesFim ,350,' ')	  		                                     ,oArial09)
    && Complemento da Mensagem 01 - Agradecimentos
    cMemoAgr := RetField("SUA",1,XFILIAL("SUA")+SUA->UA_NUM,"SUA->UA_ZZAGRAD")   
    cMensAgr := StrTran( StrTran( cMemoAgr,CHR(13)," ") ,CHR(10)," ") 
    
    oReport:Say(1040, 014, PadR(SUBSTR(cMensAgr,1,161) ,200,' ')	  		                         ,oArial09) 
    oReport:Say(1080, 014, PadR(SUBSTR(cMensAgr,162,307) ,400,' ')	  		                         ,oArial09)
     
ElseIf MV_PAR01 == 3      // Espanhol
    
    oReport:Say(400,  014,	"Dirección de Facturación"	                                             ,oArial10)	
    oReport:Say(440,  014,	Alltrim(SA1->A1_NOME)	  		                                         ,oArial09N)	
    oReport:Say(480,  014,	Alltrim(SA1->A1_END)	  		                                         ,oArial09)
    oReport:Say(520,  014,	Alltrim(SA1->A1_BAIRRO)	  		                                         ,oArial09)
    oReport:Say(560,  014,	Alltrim(SA1->A1_MUN)+" Estado.: "+Alltrim(SA1->A1_EST)                   ,oArial09)
 
    oReport:Say(640,  014,	"Dirección de Entrega"	                                                 ,oArial10)	
    oReport:Say(680,  014,	Alltrim(SA1->A1_NOME)	  		                                         ,oArial09N)	
    oReport:Say(720,  014,	Alltrim(SA1->A1_ENDENT)	  		                                         ,oArial09)
    oReport:Say(760,  014,	Alltrim(SA1->A1_BAIRROE)	  		                                     ,oArial09)
    oReport:Say(800,  014,	Alltrim(SA1->A1_MUNE)	  +" Estado.: "+Alltrim(SA1->A1_ESTE)            ,oArial09) 
       
    && Divisória das colunas
    oReport:Box(400, 1350, 960, 1350)
    
    oReport:Say(400,  1370,	"Presupuesto: " + Alltrim(cTituloSP)	  		                         ,oArial09N)
    oReport:Say(440,  1370,	"Fecha:" + Alltrim(Transform(dDatabase,PesqPict('SUA', 'UA_EMISSAO')))	 ,oArial09N)    
    oReport:Say(520,  1370,	"Vendedor: " 	  		                                                 ,oArial09N)
    oReport:Say(560,  1370,	Alltrim(SA3->A3_NOME)	  		                                         ,oArial09)
    oReport:Say(600,  1370,	"E-mail: " + Alltrim(SA3->A3_EMAIL) 	  		                         ,oArial09N)
    
    oReport:Say(680,  1370,	"Soporte: " 	  		                                                 ,oArial09N)
    oReport:Say(720,  1370,	UsrRetName(__cUserID) 	  		                                         ,oArial09)
    oReport:Say(760,  1370,	"E-mail: "  	  		                                                 ,oArial09N)
    oReport:Say(800,  1370, UsrRetMail (__cUserID )	  		                                         ,oArial09)
    oReport:Say(880,  1370,	"Teléfono: "  	  		                                                 ,oArial09N) 
    oReport:Say(920,  1370,	"(19) 3881-7191 / (19) 3881-7189 "  	  		                         ,oArial09)  
    
    && Mensagem 01 
    //oReport:Say(1000, 005, PadR(cPrimeiro ,350,' ')	  		                                         ,oArial10) 
    //oReport:Say(1040, 005, PadR(cEspanholFim ,350,' ')	  		                                     ,oArial10) 
    
    oReport:Say(1000, 014, Alltrim(cPrimeiro)	  		                                         ,oArial09) 
    //oReport:Say(1040, 014, Alltrim(cEspanholFim)	  		                                     ,oArial09)
    
    
    && Complemento da Mensagem 01 - Agradecimentos
    cMemoAgr := RetField("SUA",1,XFILIAL("SUA")+SUA->UA_NUM,"SUA->UA_ZZAGRAD")   
    cMensAgr := StrTran( StrTran( cMemoAgr,CHR(13)," ") ,CHR(10)," ") 
    
    oReport:Say(1040, 014, PadR(SUBSTR(cMensAgr,1,161) ,200,' ')	  		                         ,oArial09) 
    oReport:Say(1080, 014, PadR(SUBSTR(cMensAgr,162,307) ,400,' ')	  		                         ,oArial09) 

EndIf


Return


/**
 * Rotina		:	ValidPerg
 * Autor		:	Leandro Camaçari - FSW TOTVS IP CAMPINAS
 * Data	   		:	18/07/2013
 * Descricao	:	Cria as perguntas
 */	
Static Function ValidPerg(cPerg)
	
Local _sAlias := Alias()
Local aRegs := {}
Local i,j

aPergunte := FWSX1Util():GetGroup(cPerg)
cPerg := PADR(cPerg,Len(aPergunte[1,1] ))


&& Grupo,Ordem,Perg Port,Perg Engl,Perg Espan,Variavel,Tipo,Tamanho,Decimal,Presel,GSC,Valid,Var01,Def01,Defspa1,Defeng1,Cnt01,Var02,Def02,Defspa2,Defeng2,Cnt02,Var03,Def03,Defspa3,Defeng3,Cnt03,Var04,Def04,Defspa4,Defeng4,Cnt04,Var05,Def05,Defspa5,Defeng5,Cnt05,F3,Pyme,GrpSXG,Help,Picture,IdFil	
aAdd(aRegs,{cPerg,"01","Idioma: "	    ,"","","mv_ch1","N",01		,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})	           
                                                      	
FOR i := 1 to LEN(aRegs)
IF !dbSeek(cPerg+aRegs[i,2])
MsgAlert(" O item " + aRegs[i,2] + aRegs[i,3] + " do grupo de perguntas" + cPerg +  "não está cadastrado" + ", a partir de agora o grupo perguntas deverá ser criado pelo configurador")
   EndIf
NEXT
dbSelectArea(_sAlias)

Return()


/**
 * Rotina		:	PrintRoda
 * Autor		:	Leandro Camaçari - FSW TOTVS IP CAMPINAS
 * Data	   		:	12/09/2013
 * Descricao	:	Imprime o Rodapé Personalizado
 */
Static Function PrintRoda(oReport)
	
Local nLin        := 2800  
Local nLinOri	  := oReport:nRow
Local oArial08N	  := TFont():New("Arial", 08, 08, , .T., , , , , .F.)  
Local oArial09N	  := TFont():New("Arial", 09, 09, , .T., , , , , .F.)
Local oArial09	  := TFont():New("Arial", 09, 09, , .F., , , , , .F.) 
Local oArial11	  := TFont():New("Arial", 11, 11, , .F., , , , , .F.) 
Local oArial11N	  := TFont():New("Arial", 11, 11, , .T., , , , , .F.) 	
	
oReport:nRow := nLin
//	oReport:FatLine()
//oReport:nRow := nLinOri   

&& Mensagem para as Observações Gerais.
dbSelectArea("SYP")
dbSetOrder(1)
dbSeek( xFilial("SYP") + SUA->UA_CODOBS )

While !Eof() .and. SYP->YP_CHAVE==SUA->UA_CODOBS
   cMemo1 += TRIM(SYP->YP_TEXTO)
   dbSkip()
Enddo    

cMemo1 := StrTran(cMemo1,"\13"," ")
cMemo1 := StrTran(cMemo1,"\10","")                                                                                                         
     

If MV_PAR01 == 1        // Português
    If !Empty(cMemo1) 
        oReport:Say(nLin-660,   014, "OBSERVAÇÕES GERAIS "	,oArial09N,100,,,)
        oReport:Say(nLin-620,014, SUBSTR(cMemo1,3,191) ,oArial09,100,,,)   
        oReport:Say(nLin-580,014, SUBSTR(cMemo1,195,192) ,oArial09,100,,,)  
        oReport:Say(nLin-540,014, SUBSTR(cMemo1,388,178) ,oArial09,100,,,) 
        oReport:Say(nLin-500,014, SUBSTR(cMemo1,566,188) ,oArial09,100,,,)
        oReport:Say(nLin-460,014, SUBSTR(cMemo1,754,201) ,oArial09,100,,,)  
     
    EndIf 
ElseIf MV_PAR01 == 2    // Inglês
    If !Empty(cMemo1)    
        oReport:Say(nLin-660,   014, "GENERAL COMMENTS"	,oArial08N,100,,,)
        oReport:Say(nLin-620,014, SUBSTR(cMemo1,3,191) ,oArial09,100,,,)   
        oReport:Say(nLin-580,014, SUBSTR(cMemo1,195,192) ,oArial09,100,,,)  
        oReport:Say(nLin-540,014, SUBSTR(cMemo1,388,178) ,oArial09,100,,,) 
        oReport:Say(nLin-500,014, SUBSTR(cMemo1,566,188) ,oArial09,100,,,)
        oReport:Say(nLin-460,014, SUBSTR(cMemo1,754,201) ,oArial09,100,,,) 
    EndIf
ElseIf MV_PAR01 == 3    // Espanhol
    If !Empty(cMemo1)     
        oReport:Say(nLin-660,   014, "COMENTARIOS GENERALES"	,oArial08N,100,,,)
        oReport:Say(nLin-620,014, SUBSTR(cMemo1,3,191) ,oArial09,100,,,)   
        oReport:Say(nLin-580,014, SUBSTR(cMemo1,195,192) ,oArial09,100,,,)  
        oReport:Say(nLin-540,014, SUBSTR(cMemo1,388,178) ,oArial09,100,,,) 
        oReport:Say(nLin-500,014, SUBSTR(cMemo1,566,188) ,oArial09,100,,,)
        oReport:Say(nLin-460,014, SUBSTR(cMemo1,754,201) ,oArial09,100,,,)
    EndIf    
EndIf
         

cMemo2 := RetField("SUA",1,XFILIAL("SUA")+SUA->UA_NUM,"SUA->UA_ZZOBSGV")   
cMemo2A := StrTran( StrTran( cMemo2,CHR(13)," ") ,CHR(10)," ")

If MV_PAR01 == 1       // Português
    If !Empty(cMemo2)   
        oReport:Say(nLin-360,   014, "CONDIÇÕES GERAIS DE VENDA"	,oArial09N,100,,,)
        oReport:Say(nLin-320,014, SUBSTR(cMemo2A,3,191) ,oArial09,100,,,)   
        oReport:Say(nLin-280,014, SUBSTR(cMemo2A,195,194) ,oArial09,100,,,)  
        oReport:Say(nLin-240,014, SUBSTR(cMemo2A,391,179) ,oArial09,100,,,) 
        oReport:Say(nLin-200,014, SUBSTR(cMemo2A,570,189) ,oArial09,100,,,)
        oReport:Say(nLin-160,014, SUBSTR(cMemo2A,759,201) ,oArial09,100,,,)
    EndIf
ElseIf MV_PAR01 == 2   // Inglês
    If !Empty(cMemo2)
        oReport:Say(nLin-360,   014, "GENERAL CONDITIONS OF SALE"	,oArial09N,100,,,)
        oReport:Say(nLin-320,014, SUBSTR(cMemo2A,1,194) ,oArial09,100,,,)   
        oReport:Say(nLin-280,014, SUBSTR(cMemo2A,195,194) ,oArial09,100,,,)  
        oReport:Say(nLin-240,014, SUBSTR(cMemo2A,389,205) ,oArial09,100,,,) 
        oReport:Say(nLin-200,014, SUBSTR(cMemo2A,594,203) ,oArial09,100,,,)
        oReport:Say(nLin-160,014, SUBSTR(cMemo2A,797,201) ,oArial09,100,,,)
    EndIf
ElseIf MV_PAR01 == 3   // Espanhol
    If !Empty(cMemo2)  
        oReport:Say(nLin-360,   014, "CONDICIONES GENERALES DE VENTA"	,oArial09N,100,,,)
        oReport:Say(nLin-320,014, SUBSTR(cMemo2A,1,194) ,oArial09,100,,,)   
        oReport:Say(nLin-280,014, SUBSTR(cMemo2A,195,194) ,oArial09,100,,,)  
        oReport:Say(nLin-240,014, SUBSTR(cMemo2A,389,205) ,oArial09,100,,,) 
        oReport:Say(nLin-200,014, SUBSTR(cMemo2A,594,203) ,oArial09,100,,,)
        oReport:Say(nLin-160,014, SUBSTR(cMemo2A,797,201) ,oArial09,100,,,)        
    EndIf
EndIf


nLin+=050

	        
oReport:Say(nLin,   014, "__________________________________________ "	,oArial09N,100,,,)
oReport:Say(nLin+040,014, "PARAFIX INDUSTR.COM.DE FITAS ADESIVAS LTDA" ,oArial09N,100,,,)	

nLin+=300	
oReport:Say(nLin, 930, "Member of the Aplix Group, The Self-Gripping Fastener Specinlist"	,oArial08N,100,,,)
oReport:Say(nLin+40,840, "Visit our web site www.aplix.com. We are present in france, USA, China and Brazil" ,oArial08N,100,,,)
	
/*
oReport:Line(oReport:PageHeight()-2,230, oReport:PageHeight()-2, oReport:PageWidth()-30)
oReport:Line(oReport:PageHeight()-1,230, oReport:PageHeight()-1, oReport:PageWidth()-30)
oReport:Line(oReport:PageHeight()  ,230, oReport:PageHeight(), oReport:PageWidth()-30)   
*/
	
Return
