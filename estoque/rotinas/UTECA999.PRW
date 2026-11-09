#Include "Protheus.Ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTECA999  บAutor  ณ Alexander Pereira da Silva	             บ Data ณ  30/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณZera custo das moedas 2, 3, 4 e 5                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Tecnolita                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TECA999()     

dbSelectArea("SB9")
dbSetOrder(1)  
dbgotop()
    alert ("Processando SB9")
	While !eof()
 		RecLock("SB9",.F.)
			B9_VINI2 		:= 0
			B9_VINI3		:= 0
			B9_VINI4		:= 0
			B9_VINI5 		:= 0
			B9_CM2	   	:= 0
			B9_CM3  		:= 0
			B9_CM4	   	:= 0
			B9_CM5  		:= 0 
			B9_VINIFF2	:= 0 
			B9_VINIFF3	:= 0 
			B9_VINIFF4	:= 0 
			B9_VINIFF5	:= 0 
		MsUnlock()
		dbSkip()
    enddo
    
dbSelectArea("SB6")
dbSetOrder(1)  
dbgotop()
 alert ("Processando SB6")
	While !eof()
 		RecLock("SB6",.F.)
			B6_CUSTO2	:=0
			B6_CUSTO3	:=0
			B6_CUSTO4	:=0
			B6_CUSTO5	:=0
			B6_CUSFF2	:=0
			B6_CUSFF3	:=0
			B6_CUSFF4	:=0
			B6_CUSFF5 	:=0
 		MsUnlock()
		dbSkip()
    enddo
    
dbSelectArea("SB2")
dbSetOrder(1)  
dbgotop()
 alert ("Processando SB2")
	While !eof()
 		RecLock("SB2",.F.)
			B2_VATU2  	:=0
			B2_VATU3  	:=0
			B2_VATU4  	:=0  	
			B2_VATU5  	:=0
			B2_VFIM2		:=0		
			B2_VFIM3  	:=0
			B2_VFIM4   	:=0
			B2_VFIM5   	:=0
			B2_CM2     	:=0
			B2_CM3     	:=0
			B2_CM4     	:=0
			B2_CM5		:=0  
			B2_CMFF2	:=0
			B2_CMFF3	:=0
			B2_CMFF4	:=0
			B2_CMFF5	:=0
			B2_CMFIM2	:=0
			B2_CMFIM3	:=0
			B2_CMFIM4	:=0
			B2_CMFIM5	:=0
			B2_VFIMFF2	:=0
			B2_VFIMFF3	:=0
			B2_VFIMFF4	:=0
			B2_VFIMFF5	:=0
		MsUnlock()
		dbSkip()
    enddo
    
dbSelectArea("SC2")
dbSetOrder(1)  
dbgotop()
 alert ("Processando SC2")
	While !eof()
 		RecLock("SC2",.F.)
			C2_APFIFF2    	:=0
			C2_APFIFF3    	:=0
			C2_APFIFF4    	:=0
			C2_APFIFF5    	:=0
			C2_APINFF2   	:=0
			C2_APINFF3    	:=0
			C2_APINFF4    	:=0
			C2_APINFF5   	:=0
			C2_APRATU2 	:=0
			C2_APRATU3	:=0
			C2_APRATU4	:=0
			C2_APRATU5	:=0
			C2_APRFIM2		:=0
			C2_APRFIM3		:=0
			C2_APRFIM4		:=0
			C2_APRFIM5		:=0
			C2_APRINI2		:=0
			C2_APRINI3 		:=0
			C2_APRINI4 		:=0
			C2_APRINI5 		:=0
			C2_VATU2  		:=0
			C2_VATU3  		:=0
			C2_VATU4 	 	:=0
			C2_VATU5   		:=0
			C2_VFIM2   		:=0
			C2_VFIM3    		:=0
			C2_VFIM4   		:=0
			C2_VFIM5    		:=0
			C2_VFIMFF2		:=0
			C2_VFIMFF3		:=0
			C2_VFIMFF4		:=0
			C2_VFIMFF5		:=0
			C2_VINI2     		:=0
			C2_VINI3	     	:=0
			C2_VINI4   	  	:=0
			C2_VINI5     		:=0
			C2_VINIFF2 		:=0
			C2_VINIFF3 		:=0
			C2_VINIFF4		:=0
			C2_VINIFF5		:=0
		MsUnlock()
		dbSkip()
    enddo
    
dbSelectArea("SD1")
dbSetOrder(1)  
dbgotop()
 alert ("Processando SD1")
	While !eof()
 		RecLock("SD1",.F.)
			D1_CUSTO2	:=0
			D1_CUSTO3	:=0
			D1_CUSTO4	:=0
			D1_CUSTO5 	:=0
			D1_CUSFF2	:=0
			D1_CUSFF3	:=0
			D1_CUSFF4	:=0
			D1_CUSFF5	:=0
		MsUnlock()
		dbSkip()
    enddo
    
dbSelectArea("SD2")
dbSetOrder(1)  
dbgotop()
 alert ("Processando SD2")
	While !eof()
 		RecLock("SD2",.F.)
			D2_CUSTO2	:=0
			D2_CUSTO3	:=0
			D2_CUSTO4	:=0
			D2_CUSTO5 	:=0
			D2_CUSFF2	:=0
			D2_CUSFF3	:=0
			D2_CUSFF4	:=0
			D2_CUSFF5	:=0
		MsUnlock()
		dbSkip()
    enddo
    
dbSelectArea("SD3")
dbSetOrder(1)  
dbgotop()
 alert ("Processando SD3")
	While !eof()
 		RecLock("SD3",.F.)
			D3_CUSTO2	:=0
			D3_CUSTO3	:=0
			D3_CUSTO4	:=0
			D3_CUSTO5 	:=0
			D3_CUSFF2	:=0
			D3_CUSFF3	:=0
			D3_CUSFF4	:=0
			D3_CUSFF5	:=0
		MsUnlock()
		dbSkip()
    enddo
  
Return