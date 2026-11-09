#Include "PROTHEUS.CH"
#Include "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*--------------------------------------------------------------------------------|
| Pocicionamento correto para validação do sispag itau                            | 
|---------------------------------------------------------------------------------|                                          
| Desenvolvido para PARAFIX                   | Desenvolvedor: RENAN FREITAS      |
|---------------------------------------------|----------------------------------*/



//cTrailer := '341'+STRZERO(FA240LOTE(),4)+'5'+SPACE(9)+STRZERO(M->NSEQ+2,6)+STRZERO(SOMAVALOR(),18)+REPL("0",18)+SPACE(171)+SPACE(10)


User Function cHeader1()

	//Local cFpag 	:= LEFT(SEA->EA_TIPOPAG,2)
	Local cModPag   := LEFT(SEA->EA_MODELO,2)
	Local cBanck 	:= LEFT(SE2->E2_CODBAR,3)
	Local cHeader1  := ""
	
	//Local cNameFactory := PADR(SM0->M0_NOMECOM,30)  
			If (cModPag := 31 .and. cBanck $ "341")
					
				    cHeader1:= '341'
						
			Else 
					
					cHeader1:= '341'
					
			endIF
			
Return (cHeader1)	
			
User Function cHeader2()

	//Local cFpag 	:= LEFT(SEA->EA_TIPOPAG,2)
	Local cModPag   := LEFT(SEA->EA_MODELO,2)
	Local cBanck 	:= LEFT(SE2->E2_CODBAR,3)
	Local cHeader2  	:= ""		
		
			If (cModPag := 31 .and. cBanck $ "341")
				
				cModPag := 30
				cHeader2:= STRZERO(FA240LOTE(),4)
			
			Else

				cModPag := 31
				cHeader2:= STRZERO(FA240LOTE(),4)
							
			endIF

Return (cHeader2)

User Function cHeader3()

	//Local cFpag 	:= LEFT(SEA->EA_TIPOPAG,2)
	Local cModPag   := LEFT(SEA->EA_MODELO,2)
	Local cBanck 	:= LEFT(SE2->E2_CODBAR,3)
	Local cHeader3  	:= ""	

			If (cModPag := 31 .and. cBanck $ "341")
				
				cModPag  := 30
				cHeader3 := '1'
			
			Else

				cModPag  := 31
				cHeader3 := '1'
			
			endIF

return (cHeader3)

User Function cHeader4()
	//Local cFpag 	:= LEFT(SEA->EA_TIPOPAG,2)
	Local cModPag   := LEFT(SEA->EA_MODELO,2)
	Local cBanck 	:= LEFT(SE2->E2_CODBAR,3)
	Local cHeader4  	:= ""	

			If (cModPag := 31 .and. cBanck $ "341")	

				cModPag := 30
				cHeader4:='C'
			Else

				cModPag := 31
				cHeader4:='C'		
			
			endIF

return (cHeader4)

User Function cHeader5()
	Local cFpag 	:= LEFT(SEA->EA_TIPOPAG,2)
	Local cModPag   := LEFT(SEA->EA_MODELO,2)
	Local cBanck 	:= LEFT(SE2->E2_CODBAR,3)
	Local cHeader5   := ""	

			If (cModPag := 31 .and. cBanck $ "341")	

				cModPag := 30
				cHeader5:= cFpag
			else

				cModPag := 31
				cHeader5:= cFpag
			ENDIF

return(cHeader5)

User Function cHeader6()
	//Local cFpag 	:= LEFT(SEA->EA_TIPOPAG,2)
	Local cModPag   := LEFT(SEA->EA_MODELO,2)
	Local cBanck 	:= LEFT(SE2->E2_CODBAR,3)
	Local cHeader6   := ""	

			If (cModPag := 31 .and. cBanck $ "341")	

				cHeader6:= '30'
			
			ELSEIF (cModPag := 31 .and. cBanck <> "341")

				cHeader6:= '31'
			
			
			ENDIF

return(cHeader6)

User Function cHeader7()
	//Local cFpag 	:= LEFT(SEA->EA_TIPOPAG,2)
	Local cModPag   := LEFT(SEA->EA_MODELO,2)
	Local cBanck 	:= LEFT(SE2->E2_CODBAR,3)
	Local cHeader7  := ""

			If (cModPag := 31 .and. cBanck $ "341")	

				cModPag := 30
				cHeader7:= '030'
			else

				cModPag := 31
				cHeader7:= '030'
			ENDIF

return(cHeader7)


User Function  cHeader8()
	//Local cFpag 	:= LEFT(SEA->EA_TIPOPAG,2)
	Local cModPag   := LEFT(SEA->EA_MODELO,2)
	Local cBanck 	:= LEFT(SE2->E2_CODBAR,3)
	Local cHeader8  := ""

			If (cModPag := 31 .and. cBanck $ "341")	

				cModPag := 30
				cHeader8:= ' '
			else

				cModPag := 31
				cHeader8:= ' '
			ENDIF

return (cHeader8)


User Function  cHeader9()
	//Local cFpag 	:= LEFT(SEA->EA_TIPOPAG,2)
	Local cModPag   := LEFT(SEA->EA_MODELO,2)
	Local cBanck 	:= LEFT(SE2->E2_CODBAR,3)
	Local cHeader9  := ""

			If (cModPag := 31 .and. cBanck $ "341")	

				cModPag := 30
				cHeader9:= '2'
			else

				cModPag := 31
				cHeader9:= '2'
			ENDIF

return (cHeader9)

User Function  cHeader()
	//Local cFpag 	:= LEFT(SEA->EA_TIPOPAG,2)
	Local cModPag   := LEFT(SEA->EA_MODELO,2)
	Local cBanck 	:= LEFT(SE2->E2_CODBAR,3)
	Local cHeader  := ""

			If (cModPag := 31 .and. cBanck $ "341")	

				cModPag := 30
				cHeader:= PADL(ALLTRIM(SM0->M0_CGC),14,"0")
			else

				cModPag := 31
				cHeader:= PADL(ALLTRIM(SM0->M0_CGC),14,"0")
			ENDIF

return (cHeader)

User Function  cHeader0()
	//Local cFpag 	:= LEFT(SEA->EA_TIPOPAG,2)
	Local cModPag   := LEFT(SEA->EA_MODELO,2)
	Local cBanck 	:= LEFT(SE2->E2_CODBAR,3)
	Local cHeader0  := ""

			If (cModPag := 31 .and. cBanck $ "341")	

				cModPag := 30
				cHeader0:= SPACE(20) 
			else

				cModPag := 31
				cHeader0:= SPACE(20)
			ENDIF



return (cHeader0)










				
				

/*




User Function ctrailer()
	
	Local cFpag 	:= LEFT(SEA->EA_TIPOPAG,2)
	Local cModPag   := LEFT(SEA->EA_MODELO,2)
	Local cBanck 	:= LEFT(SE2->E2_CODBAR,3)
	Local cTrailer 	:= ""
				

					cTrailer := '341'+STRZERO(FA240LOTE(),4)+'5'+SPACE(9)+STRZERO(M->NSEQ+2,6)+STRZERO(SOMAVALOR(),18)+REPL("0",18)+SPACE(171)+SPACE(10)
				
					+
		
		
		
			/*	
				
				IF (cModPag := 31 .and. cBanck $ "341")
		
				cTrailer := '341'+STRZERO(FA240LOTE(),4)+'5'+SPACE(9)+STRZERO(M->NSEQ+2,6)+STRZERO(SOMAVALOR(),18)+REPL("0",18)+SPACE(171)+SPACE(10)		                                      
			
			Return cTrailer
				
					IF (cModPag := 31 .and. cBanck <> "341")
							cModPag := 31
							cHeader := '341'+STRZERO(FA240LOTE(),4)+'1'+'C'+cFpag+cModPag+'030'+" "+'2'+PADL(ALLTRIM(SM0->M0_CGC),14,"0")+SPACE(20)
			Return	 cHeader
					
	//	IF (cModPag := 31 .and. cBanck <> "341")
				
			//		cTrailer := '341'+STRZERO(FA240LOTE(),4)+'5'+SPACE(9)+STRZERO(M->NSEQ+2,6)+STRZERO(SOMAVALOR(),18)+REPL("0",18)+SPACE(171)+SPACE(10)
					
		//	Return cTrailer		
		ELSE 
		
		cRetCNAB := ""
			
		ENDIF
		ENDIF
		
			
			
	Return SJSISPAG()*/
