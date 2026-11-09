/*/
+---------------------------------------------------------------------------+
|  Programa  |  Boleta |Autor  |Sergio Luiz - Inntecnet | Data |  22/12/10  |
+---------------------------------------------------------------------------+
|  Descricao | Emissão da boleta de cobrança com codigo de barras, nosso    |
|            | numero e linha digitavel conforme manual do Banco do Brasil  |
+---------------------------------------------------------------------------+          
|  Uso       | Faturamento / Financeiro              	                      |
+---------------------------------------------------------------------------+
|     Alterações Sofridas desde a sua Construcao Inicial                    |
+---------------------------------------------------------------------------+
| Programador | Data  |                 Alteracao                           |
+---------------------------------------------------------------------------+
| Sergio Luiz   31/03/2011  -- Ajustes geral nosso numero e calculo digito  |
| Sergio Luiz   05/04/2011  -- ajuste linha digitavel Bbrasil               |
+---------------------------------------------------------------------------+
|                            [ Atenção ]                                    |
|Este rdmake foi desenvolvido de modo a ser generico e servir para impressão|
|da boleta de todos os bancos, bastando apenas que inclus-se os calculos que|
|forem espeficios a cada banco. Para isto existem estruturas case de para se|
|tratar o banco em uso no momento.                                          |
+---------------------------------------------------------------------------+
/*/

#include "rwmake.ch"
User Function Boleta_BB()

SetPrvt("DV_NNUM,DV_BARRA,CBARRA,LINEDIG,NFI,NFF")
SetPrvt("SERIE,BANCO,NUMBOLETA,NDIGITO,PEDACO,CHAVE")
SetPrvt("FATORVCTO,B_CAMPO,CHAVE,NCONT,CCAMPO,I")
SetPrvt("NVAL,DEZENA,RESTO,NCONT,CPESO,RESULT")
SetPrvt("ARQ,CGRUPO,PERG")
SetPrvt("TIT,DESC1,DESC2,DESC3,ORDEM")
SetPrvt("TAMANHO,FILTIMP,ARETURN,AINFO,NLASTKEY,CSTRING")
SetPrvt("WNREL,TELA,BANCO,SERIE,NFI,NFF")
SetPrvt("CSAVSCR1,CSAVCUR1,CSAVROW1,CSAVCOL1,CCAMPO,NDIGITO")
SetPrvt("NCONT,XI,NVAL,CPESO,RESTO,APERGUNTAS")
SetPrvt("NXZ,NXY,cgrupo,xrow,Nvia,Nnumero")


// Define Variaveis

// Variaveis da boleta
M->DV_NNUM   := SPACE(1)
M->DV_BARRA  := SPACE(1)
M->cBARRA    := ""
M->LineDig   := ""
M->NumBoleta := ""
M->nDigito   := ""
M->Pedaco    := ""


//Paramentros de Impressao
M->NFi       := IF(Empty(GETMV("MV_BOLTITD")),Space(9),PADR(GETMV("MV_BOLTITD"),9))
M->NFf       := IF(Empty(GETMV("MV_BOLTITA")),Space(9),PADR(GETMV("MV_BOLTITA"),9))
M->Serie     := IF(Empty(GETMV("MV_BOLPREF")),Space(3),PADR(GETMV("MV_BOLPREF"),3))
M->Banco     := IF(Empty(GETMV("MV_BOLBCO")),Space(3),PADR(GETMV("MV_BOLBCO"),3))
M->Ag        := IF(Empty(GETMV("MV_BOLAGEN")),Space(5),PADR(GETMV("MV_BOLAGEN"),5))
M->CC        := IF(Empty(GETMV("MV_BOLCC")),Space(10),PADR(GETMV("MV_BOLCC"),10))

//Cadastro de Clientes
DbSelectArea("SA1")
DbSetOrder(1)

@ 00,00 TO 250,450 DIALOG oDlgX TITLE "Impressão de Boletas de Cobrança"
@ 05,05 TO 120,205 TITLE " Parametros "

@ 20,008 SAY "Prefixo do Título"
@ 35,008 SAY "Título Inicial"
@ 50,008 SAY "Título Final"
@ 65,008 Say "Código do Banco"
@ 80,008 SAY "Agencia"
@ 95,008 SAY "Conta Corrente"

@ 20,100 SAY "Bancos Homologados"
@ 30,100 SAY  "003 - Banco do Brasil"
@ 37,100 SAY  "001 - Banco Bradesco"
@ 44,100 SAY  "004 - Banco Itau"
//Atenção: Coloque aqui o código dos demais Bancos
//@ 44,100 SAY  "XXX - XXXXXXXXXXXXXXX"
//@ 51,100 SAY  "XXX - XXXXXXXXXXXXXXX"
//@ 58,100 SAY  "XXX - XXXXXXXXXXXXXXX"

@ 20,060 GET M->Serie PICTURE "@!"         VALID !Empty(M->Serie)
@ 35,060 GET M->NFi   PICTURE "@!"  VALID !Empty(M->NFi)
@ 50,060 GET M->NFf   PICTURE "@!"  VALID !Empty(M->NFf)
@ 65,060 GET M->Banco F3 "SA6"             VALID !Empty(M->Banco)
@ 80,060 GET M->Ag
@ 95,060 GET M->CC

@ 100,120 BMPBUTTON TYPE 01 ACTION BoletaOK()
@ 100,160 BMPBUTTON TYPE 02 ACTION Close(oDlgX)

ACTIVATE  DIALOG oDlgX CENTER

Return


Static Function BoletaOK()
Close(oDlgX)
aCB_RN_NN    := {}

PUTMV("MV_BOLPREF",PADR(M->Serie,3))
PUTMV("MV_BOLTITD",PADR(M->NFi,9))
PUTMV("MV_BOLTITA",PADR(M->NFf,9))
PUTMV("MV_BOLBCO",PADR(M->Banco,3))
PUTMV("MV_BOLAGEN",PADR(M->Ag,5))
PUTMV("MV_BOLCC",PADR(M->CC,10))

//Titulos dos Campos
oFont1 :=     TFont():New("Arial"      		,09,08,,.F.,,,,,.F.)
//Conteudo dos Campos
oFont2 :=     TFont():New("Arial"      		,09,10,,.F.,,,,,.F.)
//Nome do Banco
oFont3Bold := TFont():New("Arial"			,09,13,,.T.,,,,,.F.)
//Dados do Recibo de Entrega
oFont4 := 	  TFont():New("Arial"      		,09,12,,.T.,,,,,.F.)
//Codigo de Compensação do Banco
oFont5 := 	  TFont():New("Arial"      		,09,14,,.T.,,,,,.F.)
//Codigo de Compensação do Banco
oFont6 := 	  TFont():New("Arial"      	    ,09,14,,.T.,,,,,.F.)
//Conteudo dos Campos em Negrito
oFont7 := 	  TFont():New("Arial"           ,09,10,,.T.,,,,,.F.)
//Dados do Cliente
oFont8 := 	  TFont():New("Arial"           ,09,09,,.F.,,,,,.F.)
//Linha Digitavel
oFont9 := 	  TFont():New("Times New Roman" ,09,14,,.T.,,,,,.F.)

oPrn:=TMSPrinter():New()


//Cadastro de Contas a Receber
//Posicionar no titulo Incial do Paramentro
DbSelectArea("SE1")
DbSetOrder(1)
DbGoTop()
DbSeek(xFilial("SE1")+ M->Serie + M->NFi)

If !Found()
	MsgBox("Titulo não Encontrado, verifique os paramentros digitados!!")
	Return
Endif

oprn:setup()

Do While !Eof()
	
	If Val(SE1->E1_NUM) > Val(M->NFf) .or. SE1->E1_PREFIXO != M->Serie
		Exit
	Endif
	
	//Incrementar o Numero da Boleta(1a. Impressão) ou buscar no arquivo(reimpressão)
	M->RegSE1 := Recno()
	
	//Posicionar no Cliente
	DbSelectArea("SA1")
	DbSetOrder(1)
	DbGoTop()
	DbSeek(xFilial("SA1") + SE1->E1_CLIENTE + SE1->E1_LOJA)
	
	If Empty(SE1->E1_NUMBCO)
		RecLock("SE1",.F.)
		SE1->E1_DVNBCO := ""  // Faço isso, pois como é um campo customizado, se o titulo for retirado de um bordero, este campo nao zera automaticamente
		MsUnlock()
		
		dbselectarea("SEE")
		dbgotop(1)
		IF dbseek(xFilial("SEE")+M->Banco+M->Ag+M->CC+"001")


			//Grava o Numero Bancario no Titulo
			IF M->Banco == "001" //Bradesco
			  	M->NumBoleta := STRZERO(val(SEE->EE_FAXATU),11)		
			   	RecLock("SE1",.F.)
				SE1->E1_NUMBCO  := STRZERO(Val(M->NumBoleta),11)
				MsUnlock()
			
				RecLock("SEE",.F.)
				SEE->EE_FAXATU := STRZERO(Val(M->NumBoleta)+1,11)			
				MsUnlock()                     
			ELSEIF M->Banco == "003" //Brasil
				M->NumBoleta := STRZERO(val(SEE->EE_FAXATU),10)		
				RecLock("SE1",.F.)
				SE1->E1_NUMBCO  := STRZERO(Val(M->NumBoleta),10)
				MsUnlock()
			
				RecLock("SEE",.F.)
				SEE->EE_FAXATU := STRZERO(Val(M->NumBoleta)+1,10)			
				MsUnlock()             
			ELSEIF M->Banco == "004" //Itau                   
				M->NumBoleta := STRZERO(val(SEE->EE_FAXATU),8)		
				RecLock("SE1",.F.)
				SE1->E1_NUMBCO  := STRZERO(Val(M->NumBoleta),8)
				MsUnlock()
			
				RecLock("SEE",.F.)
				SEE->EE_FAXATU := STRZERO(Val(M->NumBoleta)+1,8)			
				MsUnlock()             
			ENDIF
		ELSE
		    msgalert("Parametro de Banco nao Encontrado!")
		    return
		ENDIF	
	Else
		M->NumBoleta := AllTrim(SE1->E1_NUMBCO)
	Endif

	DbSelectArea("SE1")
	DbGoto(M->RegSE1)
	
	//Calcular o DV do N.Numero (1a. Impressão) ou buscar no arquivo(reimpressão)
	If Empty(SE1->E1_DVNBCO)//NUMBCO)
		NNumDV()
		
		//Grava o Numero Bancario no Titulo
		RecLock("SE1",.F.)
		SE1->E1_DVNBCO  := M->DV_NNUM  //DV DO NOSSO NUMERO
		MsUnlock()
		
	Else
		
		M->DV_NNUM := AllTrim(SE1->E1_DVNBCO)
		
	Endif

	oprn:startpage()
	
	//Calculos a serem impressos na boleta e gravados no SE1
	//Atenção: Acrescentar aqui os codigos dos demais bancos
	
	Do Case
		Case M->Banco == "001" //Banco Bradesco
			//Calculo de Juros Diarios
			M->Percentual := 0.1834
			M->Mora_Dia   := ( ( SE1->E1_VALOR * M->Percentual ) / 100 )
			
			RecLock("SE1",.F.)
			SE1->E1_PORCJUR := M->Percentual
			SE1->E1_VALJUR  := M->Mora_Dia
			DbCommit()
			MsUnlock()
	EndCase
	
	//Primeira Parte da Boleta
	Do Case
		
		//Atenção: Acrescentar aqui os codigos dos demais bancos
		
		// Banco do Brasil
		Case M->Banco == "003"
			M->Nome_Bco := "BANCO DO BRASIL"
			M->Cod_Comp := "|001-9|"
			M->Ag_Conta := "3081-3 / 0090020-6"
			M->Carteira := "17"
			M->Aceite   := "N"
					
			// Bradesco
		Case M->Banco == "001"
			M->Nome_Bco := "BRADESCO"
			M->Cod_Comp := "|237-2|"
			M->Ag_Conta := "3389-8 / 0014085-6"
			M->Carteira := "009"
			M->Aceite   := "N"
			// Itau
		Case M->Banco == "004"
			M->Nome_Bco := "ITAU"
			M->Cod_Comp := "|341-2|"
			M->Ag_Conta := "0658/22490-2"
			M->Carteira := "109"
			M->Aceite   := "N"
	EndCase
//-- controle de versao do boleto
_cVerbol:="v.110504.1550"
	
oPrn:Box(060,0100,1020,2200)
	oPrn:Say(065,0115,M->Nome_Bco,oFont3Bold,100)
	oprn:say(065,0700,M->Cod_Comp,oFont5,100)
	oPrn:Say(066,1550,"RECIBO DE ENTREGA",oFont3Bold,100)
	
	oPrn:Box(130,0100,0210,1500)
	oPrn:Box(130,1500,0210,2200)
	oprn:box(210,0100,0290,1500)
	oprn:box(210,1500,0370,2200)
	oprn:box(290,0100,0370,0350)
	oprn:box(290,0350,0370,0700)
	oprn:box(290,0700,0370,0850)
	oprn:box(290,0850,0370,1060)
	oprn:box(290,1060,0370,1500)
	oprn:box(290,1500,0370,2200)
	oprn:box(370,0100,0450,0350)
	oprn:box(370,0350,0450,0500)
	oprn:box(370,0500,0450,0650)
	oprn:box(370,0650,0450,1060)
	oprn:box(370,1060,0450,1500)
	oprn:box(370,1500,0450,2200)
	oprn:box(850,0100,1020,2200)
	
	oprn:say(130,0120,"Local de Pagamento",oFont1,100)
	oprn:say(130,1520,"Vencimento",oFont1,100)
	If M->Banco == "001" // Bradesco	
		oprn:say(160,0120,"PAGAVEL PREFERENCIALMENTE NAS AGENCIAS BRADESCO",oFont2,100)
	ElseIf M->Banco == "003" // Banco Brasil                                           
        oprn:say(160,0120,"PAGAVEL EM QUALQUER BANCO ATE O VENCIMENTO",oFont2,100)	
    ElseIf M->Banco == "004" // Banco Itau                                         
        oprn:say(160,0120,"PAGAVEL EM QUALQUER BANCO ATE O VENCIMENTO",oFont1,100)	    
//        oprn:say(160,0120,"ATE O VENCIMENTO, PREFERENCIALMENTE NO ITAU E APOS O VENCIMENTO, SOMENTE NO ITAU",oFont1,100)	    
    endif
			
	oprn:say(160,2000,substr(dtoc(SE1->E1_VENCTO),1,6)+"20"+substr(dtoc(SE1->E1_VENCTO),7,2),oFont7,100)
	oprn:say(210,0120,"Cedente",oFont1,100)
	oprn:say(210,1520,"Agência/Código Cedente",oFont1,100)
	oprn:say(240,0120,SM0->M0_NOMECOM,oFont2,100)
	oprn:say(240,1700,M->Ag_Conta,oFont7,100)
	oprn:say(290,0120,"Dt Documento",oFont1,100)
	oprn:say(290,0370,"Número do Documento",oFont1,100)
	oprn:say(290,0720,"Esp.Doc.",oFont1,100)
	oprn:say(290,0870,"Aceite",oFont1,100)
	oprn:say(290,1080,"Data Processamento",oFont1,100)
	oprn:say(290,1520,"Nosso Número",oFont1,100)
	oprn:say(320,0120,substr(dtoc(SE1->E1_EMISSAO),1,6)+"20"+substr(dtoc(SE1->E1_EMISSAO),7,2),oFont2,100)
	oprn:say(320,0370,SE1->E1_PREFIXO + "-" + SE1->E1_NUM + "-" +SE1->E1_PARCELA,oFont2,100)
	oprn:say(320,0720,"DM",oFont2,100)
	oprn:say(320,0870,M->Aceite,oFont2,100,4)
	oprn:say(320,1090,substr(dtoc(SE1->E1_EMISSAO),1,6)+"20"+substr(dtoc(SE1->E1_EMISSAO),7,2),oFont2,100)
	
	//Coloque aqui os demais bancos
	Do Case
		Case M->Banco == "003" //Banco do Brasil
			oprn:say(320,1700,"1551800"+M->NumBoleta,oFont7,100)
		Case M->Banco == "001" //Bradesco
			oprn:say(320,1700,"009/"+M->NumBoleta+"-"+M->DV_NNUM,oFont7,100)
		Case M->Banco == "004" //Itau
			oprn:say(320,1700,"009/"+M->NumBoleta+"-"+M->DV_NNUM,oFont7,100)
	EndCase
	
	oprn:say(370,0120,"Uso do Banco",oFont1,100)
	oprn:say(370,0370,"Carteira",oFont1,100)
	oprn:say(370,0520,"Espécie",oFont1,100)
	oprn:say(370,0670,"Quantidade",oFont1,100)
	oprn:say(370,1090,"Valor",oFont1,100)
	oprn:say(370,1520,"(=) Valor do Documento",oFont1,100)
	oprn:say(400,150,"08650",oFont2,100)
	oprn:say(400,370,M->Carteira,oFont2,100)
	oprn:say(400,520,"R$",oFont2,100)
	oprn:say(400,1750,Transform(SE1->E1_VALOR,"@E 999,999,999.99"),oFont7,100)
	
	oprn:say(530,0200,"NOME DO RECEBEDOR (legivel)",oFont4,100)
	oprn:say(530,0900,Repl("_",50),oFont4,100)
	oprn:say(630,0200,"ASSINATURA DO RECEBEDOR",oFont4,100)
	oprn:say(630,0900,Repl("_",50),oFont4,100)
	oprn:say(730,0200,"DATA DO RECEBIMENTO",oFont4,100)
	oprn:say(730,0900,Repl("_",50),oFont4,100)
	oprn:say(800,0120,_cVerbol,oFont1,100)
	
	
	oprn:say(850,0120,"Sacado",oFont1,100)
	oprn:say(0870,0250,SA1->A1_NOME,oFont8,100)
//	If SA1->A1_PESSOA == "J"
//		oprn:say(0870,1500,transform(SA1->A1_CGC,"@R 99.999.999/9999-99"),oFont8,100)
//	ElseIf SA1->A1_PESSOA == "F"
		oprn:say(0870,1500,transform(SA1->A1_CGC,"@R 999.999.999-99"),oFont8,100)
//	Endif
	oprn:say(0910,0250,SA1->A1_ENDCOB+" "+SA1->A1_BAIRROC,oFont8,100)
	oprn:say(0950,0250,SA1->A1_CEPC+" "+SA1->A1_MUNC+SA1->A1_ESTC,oFont8,100)
	oprn:say(0990,0120,"Sacador/Avalista",oFont1,100)	
	oprn:say(1010,0010,Repl("-",1800),oFont1,100)
	
	//Segunda Parte da Boleta
	oPrn:Say(001055,0100,M->Nome_Bco,oFont3Bold,100)
	oprn:say(001055,0700,M->Cod_Comp,oFont5,100)
	oPrn:Say(001055,1700,"RECIBO DO SACADO",oFont4,100)
	
	oPrn:Box(001110,0100,1190,1500)
	oPrn:Box(001110,1500,1190,2200)
	oprn:box(001190,0100,1270,1500)
	oprn:box(001190,1500,1270,2200)
	oprn:box(001270,0100,1350,0350)
	oprn:box(001270,0350,1350,0700)
	oprn:box(001270,0700,1350,0850)
	oprn:box(001270,0850,1350,1060)
	oprn:box(001270,1060,1350,1500)
	oprn:box(001270,1500,1350,2200)
	oprn:box(001350,0100,1430,0350)
	oprn:box(001350,0350,1430,0500)
	oprn:box(001350,0500,1430,0650)
	oprn:box(001350,0650,1430,1060)
	oprn:box(001350,1060,1430,1500)
	oprn:box(001350,1500,1430,2200)
	oprn:box(001430,1500,1510,2200)
	oprn:box(001430,0100,2020,1500)
	oprn:box(001430,0100,1510,1500)
	oprn:box(001430,0650,1510,1500)
	oprn:box(001430,1060,1510,2200)
	oprn:box(001510,1500,1590,2200)
	oprn:box(001590,1500,1670,2200)
	oprn:box(001670,1500,1750,2200)
	oprn:box(001750,1500,1830,2200)
	oprn:box(001830,0100,2020,2200)
	
	oprn:say(001110,0120,"Local de Pagamento",oFont1,100)
	oprn:say(001110,1520,"Vencimento",oFont1,100)
	IF M->Banco == "001"  // BRADESCO
		oprn:say(001140,0120,"PAGAVEL PREFERENCIALMENTE NAS AGENCIAS BRADESCO",oFont2,100)
	ELSEIF M->Banco == "003" // BRASIL		
		oprn:say(001140,0120,"PAGAVEL EM QUALQUER BANCO ATE A DATA DE VENCIMENTO",oFont2,100)
	ELSEIF M->Banco == "004" // ITAU		
//		oprn:say(001140,0120,"ATE O VENCIMENTO, PREFERENCIALMENTE NO ITAU E APOS O VENCIMENTO, SOMENTE NO ITAU",oFont1,100)	    	
		oprn:say(001140,0120,"PAGAVEL EM QUALQUER BANCO ATE O VENCIMENTO",oFont1,100)	    	
	ENDIF
	oprn:say(001140,2000,substr(dtoc(SE1->E1_VENCTO),1,6)+"20"+substr(dtoc(SE1->E1_VENCTO),7,2),oFont7,100)
	oprn:say(001190,0120,"Cedente",oFont1,100)
	oprn:say(001190,1520,"Agência/Código Cedente",oFont1,100)
	oprn:say(001220,0120,SM0->M0_NOMECOM,oFont2,100)
	oprn:say(001220,1700,M->Ag_Conta,oFont7,100)
	
	oprn:say(001270,0120,"Dt Documento",oFont1,100)
	oprn:say(001270,0370,"Número do Documento",oFont1,100)
	oprn:say(001270,0720,"Esp.Doc.",oFont1,100)
	oprn:say(001270,0870,"Aceite",oFont1,100)
	oprn:say(001270,1080,"Data Processamento",oFont1,100)
	oprn:say(001270,1520,"Nosso Número",oFont1,100)
	oprn:say(001300,0120,substr(dtoc(SE1->E1_EMISSAO),1,6)+"20"+substr(dtoc(SE1->E1_EMISSAO),7,2),oFont2,100)
	oprn:say(001300,0370,SE1->E1_PREFIXO + "-" + SE1->E1_NUM + "-" +SE1->E1_PARCELA,oFont2,100)
	oprn:say(001300,0720,"DM",oFont2,100)
	oprn:say(001300,0870,M->Aceite,oFont2,100)
	oprn:say(001300,1090,substr(dtoc(SE1->E1_EMISSAO),1,6)+"20"+substr(dtoc(SE1->E1_EMISSAO),7,2),oFont2,100)
	
	//Coloque aqui os demais bancos
	Do Case
		Case M->Banco == "003" //Banco do Brasil
			oprn:say(001300,1700,"1551800"+M->NumBoleta,oFont7,100)
		Case M->Banco == "001" //Bradesco
			oprn:say(001300,1700,"009/"+M->NumBoleta+"-"+M->DV_NNUM,oFont7,100)
		Case M->Banco == "004" //Itau
			oprn:say(001300,1700,"009/"+M->NumBoleta+"-"+M->DV_NNUM,oFont7,100)
	EndCase
	
	oprn:say(001350,0120,"Uso do Banco",oFont1,100)
	oprn:say(001350,0370,"Carteira",oFont1,100)
	oprn:say(001350,0520,"Espécie",oFont1,100)
	oprn:say(001350,0670,"Quantidade",oFont1,100)
	oprn:say(001350,1090,"Valor",oFont1,100)
	oprn:say(001350,1520,"(=) Valor do Documento",oFont1,100)
	oprn:say(001380,370,M->Carteira,oFont2,100)
	oprn:say(001380,520,"R$",oFont2,100)
	oprn:say(001380,1750,Transform(SE1->E1_VALOR,"@E 999,999,999.99"),oFont7,100)
	oprn:say(001430,0670,"Desconto de",oFont1,100)
	oprn:say(001430,1090,"Comis. Permanencia",oFont1,100)
	oprn:say(001430,1520,"(-) Desconto/Abatimento",oFont1,100)
	oprn:say(001460,0670,"R$ "+Transform(SE1->E1_DESCONT+SE1->E1_DESCFIN,"@E 999,999.99"),oFont1,100)
	oprn:say(001460,1090,"R$ "+alltrim(Transform(((SE1->E1_VALOR*1.5/30))/100,"@E 999,999.99"))+"    AO DIA",oFont1,100)
	oprn:say(001510,1520,"(-) Outras Deduções",oFont1,100)    
	IF M->Banco == "004" //ITAU
		oprn:say(001520,0120,"Instruções (Todas as Informacoes deste bloqueto sao de exclusiva responsabilidade do cedente)",oFont1,100)
	ELSE
		oprn:say(001520,0120,"Instruções",oFont1,100)
	ENDIF
	oprn:say(001600,1520,"(+) Mora/Multa",oFont1,100)
	oprn:say(001670,1520,"(+) Outros Acréscimos",oFont1,100)
	oprn:say(001750,1520,"(=) Valor Cobrado",oFont1,100)
	
	
	//Atenção: Caso queira imprimir observações na boleta, utilizar as linhas abaixo
	//Atenção: Colocar aqui os codigos dos demais bancos
//	Do Case
//		Case M->Banco == "001" //Bradesco
			oprn:say(001600,0120,"APÓS O VENCIMENTO COBRAR A TAXA",oFont2,100)
			oprn:say(001640,0120,"DE 1,5% DE JUROS AO MÊS",oFont2,100)
			oprn:say(001680,0120,"ATRASO DE 03 DIAS ENVIAR PARA CARTÓRIO",oFont2,100)
			
//	EndCase
	
	//If !Empty(SE1->E1_DSCTOBL)
	//	oprn:say(001610,0120,"CONCEDER DESCONTO NO VALOR DE   " + Transform(SE1->E1_DSCTOBL,"@E 9,999,999.99"),oFont2,100)
	//	oprn:say(001650,0120,"SOMENTE ATE A DATA DE VENCIMENTO (" + DtoC(SE1->E1_VENCTO)+")",oFont2,100)
	//Endif
	
	oprn:say(001830,0120,"Sacado:",oFont1,100)                        
	oprn:say(001830,0250,SA1->A1_NOME,oFont8,100)
	oprn:say(001880,0120,"End:",oFont1,100)
	IF EMPTY(SA1->A1_ENDCOB) .or. EMPTY(SA1->A1_CEPC)
		oprn:say(001880,0250,Alltrim(SA1->A1_END),oFont8,100)
	ELSE
		oprn:say(001880,0250,Alltrim(SA1->A1_ENDCOB),oFont8,100)
	ENDIF	

	oprn:say(001930,0120,"Cep:",oFont1,100)
	IF EMPTY(SA1->A1_ENDCOB) .or. EMPTY(SA1->A1_CEPC)
		oprn:say(001930,0250,Transform("@R 99999-999",SA1->A1_CEP),oFont8,100)
	ELSE
		oprn:say(001930,0250,Transform("@R 99999-999",SA1->A1_CEPC),oFont8,100)
	ENDIF	
//	oprn:say(001970,1720,"Autenticação Mecânica",oFont1,100)
	
	If SA1->A1_PESSOA == "J"
		oprn:say(001900,1550,"CNPJ: "+transform(SA1->A1_CGC,"@R 99.999.999/9999-99"),oFont8,100)
	ElseIf SA1->A1_PESSOA == "F"
		oprn:say(001900,1550,"CPF: "+transform(SA1->A1_CGC,"@R 999.999.999-99"),oFont8,100)
	Endif
	
	oprn:say(001980,0120,"Sacador/Avalista",oFont1,100)
	oprn:say(001980,1520,"Cód.Baixa",oFont1,100)
	oprn:say(002030,0010,replicate("-",1800),oFont1,100)
	
	
	//Terceira parte da Boleta
	
	M->FatorVcto := Str( ( SE1->E1_VENCTO - Ctod("07/10/1997") ),4 )
	
	//Montagem do Codigo de Barras da Boleta
	Do Case
		
		//Atenção: Coloque aqui os codigos dos demais bancos
		
		Case M->BANCO == "003" // Banco do Brasil
			
			M->B_Campo := "001"  + "9" + M->FatorVcto
			M->B_Campo := M->B_Campo + StrZero(Int(SE1->E1_VALOR*100),10)
			M->B_Campo := M->B_Campo + "000000"+"1551800"
			M->B_Campo := M->B_Campo + M->Numboleta + "17"
		
			//Calculo do Digito do Codigo de Barras
			BarraDV()
			
			//Compor a barra com o Digito verificador
			M->CodBarras := "001"  + "9" + M->DV_BARRA + M->FatorVcto
			M->CodBarras := M->CodBarras + StrZero(Int(SE1->E1_VALOR*100),10)
			M->CodBarras := M->CodBarras + "000000"+"1551800"
			M->CodBarras := M->CodBarras + M->Numboleta + "17"
			
		Case M->BANCO == "004" // Itau
			
			M->B_Campo := "341"  + "9" + M->FatorVcto
			M->B_Campo := M->B_Campo + StrZero(Int(SE1->E1_VALOR*100),10)
			M->B_Campo := M->B_Campo + "109"+M->Numboleta+M->DV_NNUM + "0658" + "224902" + "000"
			
			//Calculo do Digito do Codigo de Barras
			BarraDV()
			
			//Compor a barra com o Digito verificador
			M->CodBarras := "341"  + "9" + M->DV_BARRA + M->FatorVcto
			M->CodBarras := M->CodBarras + StrZero(Int(SE1->E1_VALOR*100),10)
			M->CodBarras := M->CodBarras + "109"+M->Numboleta+M->DV_NNUM + "0658" + "224902" + "000"
			
		Case M->BANCO == "001" // Bradesco
			
			M->B_Campo := "237"  + "9" + M->FatorVcto
			M->B_Campo := M->B_Campo + StrZero(Int(SE1->E1_VALOR*100),10)
			M->B_Campo := M->B_Campo + "3389" +"09"+M->Numboleta + "0014085" + "0"
			
			//Calculo do Digito do Codigo de Barras
			BarraDV()
			
			//Compor a barra com o Digito verificador
			M->CodBarras := "237"  + "9" + M->DV_BARRA + M->FatorVcto
			M->CodBarras := M->CodBarras + StrZero(Int(SE1->E1_VALOR*100),10)
			M->CodBarras := M->CodBarras + "3389" +"09"+M->Numboleta + "0014085" + "0"
	EndCase
	
	//Montar a Linha Digitavel da Boleta
	MontaLinha()
	
	//Terceira Parte da Boleta
	oPrn:Say(002080,0100,M->Nome_Bco,oFont3Bold,100)
	oprn:say(002080,0700,M->Cod_Comp,oFont6,100)
	
	
	
	//Impressão da Linha Digitavel
	oPrn:Say(002085,0890,M->LineDig,oFont9,100)

	oPrn:Box(002160,0100,2240,1500)
	oPrn:Box(002160,1500,2240,2200)
	oprn:box(002240,0100,2320,1500)
	oprn:box(002240,1500,2320,2200)
	oprn:box(002320,0100,2400,0350)
	oprn:box(002320,0350,2400,0700)
	oprn:box(002320,0700,2400,0850)
	oprn:box(002320,0850,2400,1060)
	oprn:box(002320,1060,2400,1500)
	oprn:box(002320,1500,2400,2200)
	oprn:box(002400,0100,2480,0350)
	oprn:box(002400,0350,2480,0500)
	oprn:box(002400,0500,2480,0650)
	oprn:box(002400,0650,2480,1060)
	oprn:box(002400,1060,2480,1500)
	oprn:box(002400,1500,2480,2200)
	oprn:box(002480,1500,2560,2200)
	oprn:box(002480,0100,3055,1500)
	oprn:box(002480,0100,2560,1500)
	oprn:box(002480,0650,2560,1500)
	oprn:box(002480,1060,2560,1500)
	oprn:box(002560,1500,2800,2200)
	oprn:box(002640,1500,2720,2200)
	oprn:box(002720,1500,2800,2200)
	oprn:box(002800,1500,2880,2200)
	oprn:box(002880,0100,3055,2200)

	oprn:say(002160,0120,"Local de Pagamento",oFont1,100)
	oprn:say(002160,1520,"Vencimento",oFont1,100)
	IF M->Banco == "001" //BRADESCO
		oprn:say(002190,0120,"PAGAVEL PREFERENCIALMENTE NAS AGENCIAS BRADESCO",oFont2,100)
	ELSEIF M->Banco == "003" // BRASIL		
		oprn:say(002190,0120,"PAGAVEL EM QUALQUER BANCO ATE A DATA DE VENCIMENTO",oFont2,100)
	ELSEIF M->Banco == "004" // ITAU		
//		oprn:say(002190,0120,"ATE O VENCIMENTO, PREFERENCIALMENTE NO ITAU E APOS O VENCIMENTO, SOMENTE NO ITAU",oFont1,100)	    	
		oprn:say(002190,0120,"PAGAVEL EM QUALQUER BANCO ATE O VENCIMENTO",oFont1,100)	    	
	ENDIF
	oprn:say(002190,2000,substr(dtoc(SE1->E1_VENCTO),1,6)+"20"+substr(dtoc(SE1->E1_VENCTO),7,2),oFont7,100)
	oprn:say(002240,0120,"Cedente",oFont1,100)
	oprn:say(002240,1520,"Agência/Código Cedente",oFont1,100)
	oprn:say(002270,0120,SM0->M0_NOMECOM,oFont2,100)
	oprn:say(002270,1700,M->Ag_Conta,oFont7,100)
	oprn:say(002320,0120,"Dt Documento",oFont1,100)
	oprn:say(002320,0370,"Número do Documento",oFont1,100)
	oprn:say(002320,0720,"Esp.Doc.",oFont1,100)
	oprn:say(002320,0870,"Aceite",oFont1,100)
	oprn:say(002320,1080,"Data Processamento",oFont1,100)
	oprn:say(002320,1520,"Nosso Número",oFont1,100)
	oprn:say(002350,0120,substr(dtoc(SE1->E1_EMISSAO),1,6)+"20"+substr(dtoc(SE1->E1_EMISSAO),7,2),oFont2,100)
	oprn:say(002350,0370,SE1->E1_PREFIXO + "-" + SE1->E1_NUM + "-" +SE1->E1_PARCELA,oFont2,100)
	oprn:say(002350,0720,"DM",oFont2,100)
	oprn:say(002350,0870,M->Aceite,oFont2,100)
	oprn:say(002350,1090,substr(dtoc(SE1->E1_EMISSAO),1,6)+"20"+substr(dtoc(SE1->E1_EMISSAO),7,2),oFont2,100)
	
	//Coloque aqui os demais bancos
	Do Case
		Case M->Banco == "003" //Banco do Brasil
			oprn:say(002350,1700,"1551800"+M->NumBoleta,oFont7,100)
		Case M->Banco == "001" //Bradesco
			oprn:say(002350,1700,"009/"+M->NumBoleta + "-" + DV_NNUM,oFont7,100)
		Case M->Banco == "004" //ITAU
			oprn:say(002350,1700,"009/"+M->NumBoleta + "-" + DV_NNUM,oFont7,100)	
	EndCase
	
	
	oprn:say(002400,0120,"Uso do Banco",oFont1,100)
	oprn:say(002400,0370,"Carteira",oFont1,100)
	oprn:say(002400,0520,"Espécie",oFont1,100)
	oprn:say(002400,0670,"Quantidade",oFont1,100)
	oprn:say(002400,1090,"Valor",oFont1,100)
	oprn:say(002400,1520,"(=) Valor do Documento",oFont1,100)
	oprn:say(002430,0370,M->Carteira,oFont2,100)
	oprn:say(002430,0520,"R$",oFont2,100)
	oprn:say(002430,1750,transform(SE1->E1_VALOR,"@E 999,999,999.99"),oFont7,100)
	oprn:say(002480,0670,"Desconto de",oFont1,100)
	oprn:say(002510,0670,"R$ "+Transform(SE1->E1_DESCONT+SE1->E1_DESCFIN,"@E 999,999.99"),oFont1,100)
	oprn:say(002480,1090,"Comis. Permanencia",oFont1,100)
	oprn:say(002510,1090,"R$ "+alltrim(Transform(((SE1->E1_VALOR*1.5/30))/100,"@E 999,999.99"))+"    AO DIA",oFont1,100)	
	oprn:say(002480,1520,"(-) Desconto/Abatimento",oFont1,100)
	oprn:say(002560,1520,"(-) Outras Deduções",oFont1,100)
	IF M->Banco == "004" //ITAU
		oprn:say(002570,0120,"Instruções (Todas as Informacoes deste bloqueto sao de exclusiva responsabilidade do cedente)",oFont1,100)
	ELSE
		oprn:say(002570,0120,"Instruções",oFont1,100)
	ENDIF
	oprn:say(002640,1520,"(+) Mora/Multa",oFont1,100)
	oprn:say(002720,1520,"(+) Outros Acréscimos",oFont1,100)
	oprn:say(002800,1520,"(=) Valor Cobrado",oFont1,100)
	
	//Atenção: Caso queira imprimir observações na boleta, utilizar as linhas abaixo
	//Atenção: Coloque aqui o codigo dos demais Bancos
//	Do Case
//		Case M->Banco == "001"
			oprn:say(002640,0120,"APÓS O VENCIMENTO COBRAR A TAXA",oFont2,100)
			oprn:say(002680,0120,"DE 1,5% DE JUROS AO MÊS.",oFont2,100)
			oprn:say(002720,0120,"ATRASO DE 03 DIAS ENVIAR PARA CARTÓRIO",oFont2,100)
//	EndCase
	                                                           
	//If !Empty(SE1->E1_DSCTOBL)
	//	oprn:say(002660,0120,"CONCEDER DESCONTO NO VALOR DE   " + Transform(SE1->E1_DSCTOBL,"@E 9,999,999.99"),oFont2,100)
	//	oprn:say(002700,0120,"SOMENTE ATE A DATA DE VENCIMENTO (" + DtoC(SE1->E1_VENCTO)+")",oFont2,100)
	//Endif
	
	oprn:say(002880,0120,"Sacado:",oFont1,100)                        
	oprn:say(002880,0250,SA1->A1_NOME,oFont8,100)
	oprn:say(002930,0120,"End:",oFont1,100)
	IF EMPTY(SA1->A1_ENDCOB) .or. EMPTY(SA1->A1_CEPC)
		oprn:say(002930,0250,Alltrim(SA1->A1_END),oFont8,100)
	ELSE
		oprn:say(002930,0250,Alltrim(SA1->A1_ENDCOB),oFont8,100)
	ENDIF	

	oprn:say(002980,0120,"Cep:",oFont1,100)
	IF EMPTY(SA1->A1_ENDCOB) .or. EMPTY(SA1->A1_CEPC)
		oprn:say(002980,0250,Transform("@R 99999-999",SA1->A1_CEP),oFont8,100)
	ELSE
		oprn:say(002980,0250,Transform("@R 99999-999",SA1->A1_CEPC),oFont8,100)
	ENDIF	

	
	If SA1->A1_PESSOA == "J"
		oprn:say(002950,1550,"CNPJ: "+transform(SA1->A1_CGC,"@R 99.999.999/9999-99"),oFont8,100)
	ElseIf SA1->A1_PESSOA == "F"
		oprn:say(002950,1550,"CPF: "+transform(SA1->A1_CGC,"@R 999.999.999-99"),oFont8,100)
	Endif
	
	oprn:say(003020,0120,"Sacador/Avalista",oFont1,100)
	oprn:say(003020,1520,"Cód.Baixa",oFont1,100)
	oprn:say(003060,1730,"FICHA DE COMPENSAÇÃO",oFont2,100)
	oprn:say(003060,1120,"AUTENTICAÇÃO MECANICA",oFont2,100)	
	//Impressao do Codigo de Barras
	MSBAR("INT25",27,1.5,M->CodBarras,oprn,.F.,,.T.,0.025,1.3,NIL,NIL,NIL,.F.)

	eject
	DbSkip()
	
	oprn:endpage()
	
EndDo

//Para Obter um preview da impressão, desabilite a linha abaixo
oprn:PREVIEW()

//oPrn:Print()

//MsgBox("Impessão Completa!!")

oprn:end()

Ms_Flush()

Return

//*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
//                              F U N Ç Õ E S                                         *
//*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
//Montagem da Linha Digitavel                                  |
Static Function MontaLinha()
M->LineDig := ""
M->nDigito := ""
M->Pedaco  := ""

Do Case
	
	//Atenção: Acrescentar aqui os codigos dos demais bancos
	
	
	Case M->Banco == "003" // Banco do Brasil
		
		M->LineDig := ""
		M->nDigito := ""
		M->Pedaco  := ""
		
		//Primeiro Campo
		//Codigo do Banco + Moeda + 5 primeiras posições do campo livre do Cod Barras
		M->Pedaco := Substr(M->CodBarras,01,03) + Substr(M->CodBarras,04,01) + Substr(M->CodBarras,20,5)
		DV_LINHA()
		M->LineDig := Substr(M->CodBarras,1,3)+Substr(M->CodBarras,4,1)+Substr(M->CodBarras,20,1)+"."+;
		Substr(M->CodBarras,21,4) + M->nDigito + Space(2)
		
		//Segundo Campo
		M->Pedaco  := Substr(M->CodBarras,25,10)
		DV_LINHA()
		M->LineDig := M->LineDig+Substr(M->Pedaco,1,5)+"."+Substr(M->Pedaco,6,5)+;
		M->nDigito+Space(2)
		
		//Terceiro Campo
		M->Pedaco  := Substr(M->CodBarras,35,10)
		DV_LINHA()
		M->LineDig := M->LineDig + Substr(M->Pedaco,1,5)+"."+Substr(M->Pedaco,6,5)+;
		M->nDigito+Space(2)
		
		//Quarto Campo
		M->LineDig := M->LineDig + DV_BARRA + Space(2)
		
		//Quinto Campo
		M->LineDig  := M->LineDig + M->FatorVcto + StrZero(Int(SE1->E1_Valor*100),10)
	Case M->Banco == "004" //ITAU
		
		M->LineDig := ""
		M->nDigito := ""
		M->Pedaco  := ""
		
		//Primeiro Campo
		//Codigo do Banco + Moeda + 2 primeiras posições do NossoNumero + DAC do campo
		M->Pedaco := "341"  + "9"  + M->Carteira + SUBSTR(M->Numboleta,1,2)
		DV_LINHA()
		M->LineDig := Substr(M->Pedaco,1,4)+Substr(M->Carteira,1,1)+"."+;
		Substr(M->Carteira,2,2) + SUBSTR(M->Numboleta,1,2) + M->nDigito + Space(2)
		
		//Segundo Campo
		M->Pedaco  := SUBSTR(M->Numboleta,3,6) + M->DV_NNUM + SUBSTR(M->Ag,1,3)
		DV_LINHA()
		M->LineDig := M->LineDig+Substr(M->Pedaco,1,5)+"."+Substr(M->Pedaco,6,5)+;
		M->nDigito+Space(2)
		
		//Terceiro Campo                      
		M->Pedaco  := STRZERO(VAL(SUBSTR(M->Ag,1,4)),4) + STRZERO(VAL(SUBSTR(M->Cc,1,5)),5)
		DV_LINHA()
		
		//M->Pedaco  := SUBSTR(M->Ag,4,1) + STRZERO(VAL(SUBSTR(M->Cc,1,5)),5) +M->DV_NNUM + "000"
		M->Pedaco  := SUBSTR(M->Ag,4,1) + STRZERO(VAL(SUBSTR(M->Cc,1,5)),5) +M->nDigito + "000"
		DV_LINHA()
		
		M->LineDig := M->LineDig + Substr(M->Pedaco,1,5)+"."+Substr(M->Pedaco,6,5)+;
		M->nDigito+Space(2)
		
		//Quarto Campo
		M->LineDig := M->LineDig + M->DV_BARRA + Space(2)
		
		//Quinto Campo
		M->LineDig  := M->LineDig + M->FatorVcto + STRZERO((SE1->E1_VALOR)*100,10)
		                                             
		
		// Bradesco
	Case M->Banco == "001" // Bradesco
		
		M->LineDig := ""
		M->nDigito := ""
		M->Pedaco  := ""
		
		//Primeiro Campo
		//Codigo do Banco + Moeda + 5 primeiras posições do campo livre do Cod Barras
		M->Pedaco := Substr(M->CodBarras,01,03) + Substr(M->CodBarras,04,01) + Substr(M->CodBarras,20,5)
		DV_LINHA()
		M->LineDig := Substr(M->CodBarras,1,3)+Substr(M->CodBarras,4,1)+Substr(M->CodBarras,20,1)+"."+;
		Substr(M->CodBarras,21,4) + M->nDigito + Space(2)
		
		//Segundo Campo
		M->Pedaco  := Substr(M->CodBarras,25,10)
		DV_LINHA()
		M->LineDig := M->LineDig+Substr(M->Pedaco,1,5)+"."+Substr(M->Pedaco,6,5)+;
		M->nDigito+Space(2)
		
		//Terceiro Campo
		M->Pedaco  := Substr(M->CodBarras,35,10)
		DV_LINHA()
		M->LineDig := M->LineDig + Substr(M->Pedaco,1,5)+"."+Substr(M->Pedaco,6,5)+;
		M->nDigito+Space(2)
		
		//Quarto Campo
		M->LineDig := M->LineDig + DV_BARRA + Space(2)
		
		//Quinto Campo
		M->LineDig  := M->LineDig + M->FatorVcto + StrZero(Int(SE1->E1_Valor*100),10)
EndCase

Return


//Calculo do Digito da Linha Digitavel
Static Function DV_LINHA()
Do Case
	
	//Atenção: Acrescentar aqui os codigos dos demais bancos
	
	Case M->Banco == "003"  // Banco do Brasil
		nCont  := 0
		Peso   := 2
		
		For i := Len(M->Pedaco) to 1 Step -1
			
			If M->Peso == 3
				M->Peso := 1
			Endif
			
			If Val(SUBSTR(M->Pedaco,i,1))*M->Peso >= 10
				nVal  := Val(SUBSTR(M->Pedaco,i,1)) * M->Peso
				nCont := nCont+(Val(SUBSTR(Str(nVal,2),1,1))+Val(SUBSTR(Str(nVal,2),2,1)))
			Else
				nCont:=nCont+(Val(SUBSTR(M->Pedaco,i,1))* M->Peso)
			Endif
			
			M->Peso := M->Peso + 1
		Next
		
		M->Dezena  := Substr(Str(nCont,2),1,1)
		M->Resto   := ( (Val(Dezena)+1) * 10) - nCont
		If M->Resto   == 10
			M->nDigito := "0"
		Else
			M->nDigito := Str(M->Resto,1)
		Endif
		
	Case M->Banco == "001"  // Bradesco
		nCont  := 0
		Peso   := 2
		
		For i := Len(M->Pedaco) to 1 Step -1
			
			If M->Peso == 3
				M->Peso := 1
			Endif
			
			If Val(SUBSTR(M->Pedaco,i,1))*M->Peso >= 10
				nVal  := Val(SUBSTR(M->Pedaco,i,1)) * M->Peso
				nCont := nCont+(Val(SUBSTR(Str(nVal,2),1,1))+Val(SUBSTR(Str(nVal,2),2,1)))
			Else
				nCont:=nCont+(Val(SUBSTR(M->Pedaco,i,1))* M->Peso)
			Endif
			
			M->Peso := M->Peso + 1
		Next
		
		M->Dezena  := Substr(Str(nCont,2),1,1)
		M->Resto   := ( (Val(Dezena)+1) * 10) - nCont
		If M->Resto   == 10
			M->nDigito := "0"
		Else
			M->nDigito := Str(M->Resto,1)
		Endif 
		
	Case M->Banco == "004" //Anexo 3 Itau MOD 10
	
		M->nCont   := 0
		M->cPeso   := 2    		
		//M->nBoleta :="02" + M->NumBoleta
		
		For i := Len(M->Pedaco) to 1 Step -1    
		
			nTamVal := 0
			nTamVal := (Val(SUBSTR(M->Pedaco,i,1))) * M->cPeso 
				
			if len(CVALTOCHAR(nTamVal)) = 2
				nTamVal := VAL(SUBSTR(CVALTOCHAR(nTamVal),1,1)) + VAL(SUBSTR(CVALTOCHAR(nTamVal),2,1))
				M->nCont := M->nCont + nTamVal   
			else
				M->nCont := M->nCont + (Val(SUBSTR(M->Pedaco,i,1))) * M->cPeso
			endif
					
			
			M->cPeso := M->cPeso + 1
			
			If M->cPeso > 2
				M->cPeso := 1
			Endif
			
		Next
		
		M->Resto := ( M->nCont % 10 )       
		
		If M->Resto   == 10
			M->nDigito := "0"
		Else  
		     M->nDigito := 10 - M->Resto
			 M->nDigito := Str(M->nDigito,1)
		Endif                 
		
		if M->Resto == 0
			M->nDigito := "0"
		endif	
	
EndCase
Return


//Calculo do Digito Verificador do Nosso Numero
Static Function NNumDV()
Do Case
	
	//Atenção: Acrescentar aqui os codigos dos demais bancos
	
	
	Case M->BANCO == "004"   // ITAU
	cTamBole := len(M->Numboleta)

		
		DAC= STRZERO(VAL(M->Ag),4) + SUBSTR(M->Cc,1,5) + "109" + SUBSTR(M->Numboleta,1,8)
		
		M->nCont   := 0
		M->cPeso   := 2
		
		For i := 20 To 1 Step -1  
		
		
			nTamPNnu := 0
			nTamPNnu := (Val(SUBSTR(DAC,i,1))) * M->cPeso 
				
			if len(CVALTOCHAR(nTamPNnu)) = 2
				nTamPNnu := VAL(SUBSTR(CVALTOCHAR(nTamPNnu),1,1)) + VAL(SUBSTR(CVALTOCHAR(nTamPNnu),2,1))
				M->nCont := M->nCont + nTamPNnu   
			else
				M->nCont := M->nCont + (Val(SUBSTR(DAC,i,1))) * M->cPeso
			endif
					
			
			M->cPeso := M->cPeso + 1
			
			If M->cPeso > 2
				M->cPeso := 1
			Endif
			
		Next
		
		M->Resto := ( M->nCont % 10 )       
		
		M->Resto := IF(M->Resto == 0,0,10 - M->Resto)
		
		M->DV_NNUM = AllTrim(Str(M->Resto))
		
	Case M->BANCO == "003" // Banco do Brasil
		
		M->nCont := 0
		M->cPeso := 9
		
		For i := 11 To 1 Step -1
			M->nCont := M->nCont + (Val(SUBSTR(M->NumBoleta,i,1))) * M->cPeso
			M->cPeso := M->cPeso - 1
			If M->cPeso == 1
				M->cPeso := 9
			Endif
		Next
		M->Resto := ( M->nCont % 11 )
		If M->Resto < 10
			M->DV_NNUM := Str(Resto,1)
		Else
			M->DV_NNUM := "X"
		EndIf
		
		// Bradesco
	Case M->BANCO == "001"	// Bradesco
		
		M->nCont   := 0
		M->cPeso   := 2
		M->nBoleta :="09" + M->NumBoleta
		
		For i := 13 To 1 Step -1
			
			M->nCont := M->nCont + (Val(SUBSTR(M->nBoleta,i,1))) * M->cPeso
			
			M->cPeso := M->cPeso + 1
			
			If M->cPeso == 8
				M->cPeso := 2
			Endif
			
		Next
		
		M->Resto := ( M->nCont % 11 )
		
		Do Case
			Case M->Resto == 1
				M->DV_NNUM := "P"
			Case M->Resto == 0
				M->DV_NNUM := "0"
			OtherWise
				M->Resto   := ( 11 - M->Resto )
				M->DV_NNUM := AllTrim(Str(M->Resto))
		EndCase
EndCase
Return

//Calculo do Digito do Codigo de Barras
Static Function BarraDV()

Do Case
	
	//Atenção: Coloque aqui o codigo dos demais bancos
	
	Case M->BANCO == "003"  // Banco do Brasil
		
		M->nCont := 0
		M->cPeso := 2
		For i := 43 To 1 Step -1
			M->nCont := M->nCont + ( Val( SUBSTR( M->B_Campo,i,1 )) * M->cPeso )
			M->cPeso := M->cPeso + 1
			If M->cPeso >  9
				M->cPeso := 2
			Endif
		Next
		M->Resto  := ( M->nCont % 11 )
		M->Result := ( 11 - M->Resto )
		Do Case
			Case M->Result == 10 .or. M->Result == 11
				M->DV_BARRA := "1"
			OtherWise
				M->DV_BARRA := Str(M->Result,1)
		EndCase
		
		
	Case M->BANCO == "001"  // Bradesco
		
		M->nCont := 0
		M->cPeso := 2
		For i := 43 To 1 Step -1
			M->nCont := M->nCont + ( Val( SUBSTR( M->B_Campo,i,1 )) * M->cPeso )
			M->cPeso := M->cPeso + 1
			If M->cPeso >  9
				M->cPeso := 2
			Endif
		Next
		M->Resto  := ( M->nCont % 11 )
		M->Result := ( 11 - M->Resto )
		Do Case
			Case M->Result == 10 .or. M->Result == 11
				M->DV_BARRA := "1"
			OtherWise
				M->DV_BARRA := Str(M->Result,1)
		EndCase
	Case M->BANCO == "004" // itau
//		M->DV_BARRA := Ret_cBarra("341","0658","22490","2","00000102",1,cTod("18/04/2011"))

		M->nCont := 0
		M->cPeso := 2
		For i := 43 To 1 Step -1
			M->nCont := M->nCont + ( Val( SUBSTR( M->B_Campo,i,1 )) * M->cPeso )
			M->cPeso := M->cPeso + 1
			If M->cPeso >  9
				M->cPeso := 2
			Endif
		Next
		M->Resto  := ( M->nCont % 11 )
		M->Result := ( 11 - M->Resto )
		Do Case
			Case M->Result == 10 .or. M->Result == 11
				M->DV_BARRA := "1"
			OtherWise
				M->DV_BARRA := Str(M->Result,1)
		EndCase               
		
EndCase

Return

Static Function Ret_cBarra(cBanco,cAgencia,cConta,cDacCC,cNroDoc,nValor,dVencto)
//
LOCAL bldocnufinal := strzero(val(cNroDoc),8)
LOCAL blvalorfinal := strzero(int(nValor*100),10)
LOCAL dvnn         := 0
LOCAL dvcb         := 0
LOCAL dv           := 0
LOCAL NN           := ''
LOCAL RN           := ''
LOCAL CB           := ''
LOCAL s            := ''
LOCAL _cfator      := strzero(dVencto - ctod("07/10/97"),4)
LOCAL _cCart	   := "109" //carteira de cobranca
//
//-------- Definicao do NOSSO NUMERO
s    :=  cAgencia + cConta + _cCart + bldocnufinal
dvnn := modulo10(s) // digito verifacador Agencia + Conta + Carteira + Nosso Num
NN   := _cCart + bldocnufinal + '-' + AllTrim(Str(dvnn))
//
//	-------- Definicao do CODIGO DE BARRAS
s    := cBanco + _cfator + blvalorfinal + _cCart + bldocnufinal + AllTrim(Str(dvnn)) + cAgencia + cConta + cDacCC + '000'
dvcb := modulo11(s)
CB   := SubStr(s, 1, 4) + AllTrim(Str(dvcb)) + SubStr(s,5)
//
//-------- Definicao da LINHA DIGITAVEL (Representacao Numerica)
//	Campo 1			Campo 2			Campo 3			Campo 4		Campo 5
//	AAABC.CCDDX		DDDDD.DEFFFY	FGGGG.GGHHHZ	K			UUUUVVVVVVVVVV
//
// 	CAMPO 1:
//	AAA	= Codigo do banco na Camara de Compensacao
//	  B = Codigo da moeda, sempre 9
//	CCC = Codigo da Carteira de Cobranca
//	 DD = Dois primeiros digitos no nosso numero
//	  X = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
//
s    := cBanco + _cCart + SubStr(bldocnufinal,1,2)
dv   := modulo10(s)
RN   := SubStr(s, 1, 5) + '.' + SubStr(s, 6, 4) + AllTrim(Str(dv)) + '  '
//
// 	CAMPO 2:
//	DDDDDD = Restante do Nosso Numero
//	     E = DAC do campo Agencia/Conta/Carteira/Nosso Numero
//	   FFF = Tres primeiros numeros que identificam a agencia
//	     Y = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
//
s    := SubStr(bldocnufinal, 3, 6) + AllTrim(Str(dvnn)) + SubStr(cAgencia, 1, 3)
dv   := modulo10(s)
RN   := RN + SubStr(s, 1, 5) + '.' + SubStr(s, 6, 5) + AllTrim(Str(dv)) + '  '
//
// 	CAMPO 3:
//	     F = Restante do numero que identifica a agencia
//	GGGGGG = Numero da Conta + DAC da mesma
//	   HHH = Zeros (Nao utilizado)
//	     Z = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
s    := SubStr(cAgencia, 4, 1) + cConta + cDacCC + '000'
dv   := modulo10(s)
RN   := RN + SubStr(s, 1, 5) + '.' + SubStr(s, 6, 5) + AllTrim(Str(dv)) + '  '
//
// 	CAMPO 4:
//	     K = DAC do Codigo de Barras
RN   := RN + AllTrim(Str(dvcb)) + '  '
//
// 	CAMPO 5:
//	      UUUU = Fator de Vencimento
//	VVVVVVVVVV = Valor do Titulo
RN   := RN + _cfator + StrZero(Int(nValor * 100),14-Len(_cfator))
//
Return({CB,RN,NN})

Static Function Modulo10(cData)
LOCAL L,D,P := 0
LOCAL B     := .F.
L := Len(cData)
B := .T.
D := 0
While L > 0
	P := Val(SubStr(cData, L, 1))
	If (B)
		P := P * 2
		If P > 9
			P := P - 9
		End
	End
	D := D + P
	L := L - 1
	B := !B
End
D := 10 - (Mod(D,10))
If D = 10
	D := 0
End
Return(D)

Static Function Modulo11(cData)
LOCAL L, D, P := 0
L := Len(cdata)
D := 0
P := 1
While L > 0
	P := P + 1
	D := D + (Val(SubStr(cData, L, 1)) * P)
	If P = 9
		P := 1
	End
	L := L - 1
End
D := 11 - (mod(D,11))
If (D == 0 .Or. D == 1 .Or. D == 10 .Or. D == 11)
	D := 1
End
Return(D)