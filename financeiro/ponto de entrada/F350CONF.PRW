//define se vai contabilizar a inclusao ou estorno da Variação Monetaria
#INCLUDE "PROTHEUS.CH"
 
User Function F350CONF()
    Local lRet := .T.
    Local CONTABILIZA := If(MV_PAR11=1,'INCLUSAO','ESTORNO')
 
    If MsgYesNo("Certeza que deseja contabilizar "+CONTABILIZA+" ?")
        IF(MV_PAR11=1) //Se for Inclusão
		
		//LP´s de Contas a Pagar
		DbSelectArea("CT5")
		DbSetOrder(1)
		DbSeek(xFilial("CT5")+'599'+'001')
			RecLock("CT5",.F.)
			CT5->CT5_STATUS  :='1'
            CT5->(MsUnlock())
    	DbSelectArea("CT5")
		DbSetOrder(1)
		DbSeek(xFilial("CT5")+'599'+'002')
			RecLock("CT5",.F.)
			CT5->CT5_STATUS  :='1'
            CT5->(MsUnlock())
    	DbSelectArea("CT5")
		DbSetOrder(1)
		DbSeek(xFilial("CT5")+'599'+'003')
			RecLock("CT5",.F.)
			CT5->CT5_STATUS  :='2'
            CT5->(MsUnlock())
    	DbSelectArea("CT5")
		DbSetOrder(1)
		DbSeek(xFilial("CT5")+'599'+'004')
			RecLock("CT5",.F.)
			CT5->CT5_STATUS  :='2'
            CT5->(MsUnlock())

		// LP´s de Contas a Receber
		DbSelectArea("CT5")
		DbSetOrder(1)
		DbSeek(xFilial("CT5")+'598'+'001')
			RecLock("CT5",.F.)
			CT5->CT5_STATUS  :='1'
            CT5->(MsUnlock())
    	DbSelectArea("CT5")
		DbSetOrder(1)
		DbSeek(xFilial("CT5")+'598'+'002')
			RecLock("CT5",.F.)
			CT5->CT5_STATUS  :='1'
            CT5->(MsUnlock())
    	DbSelectArea("CT5")
		DbSetOrder(1)
		DbSeek(xFilial("CT5")+'598'+'003')
			RecLock("CT5",.F.)
			CT5->CT5_STATUS  :='2'
            CT5->(MsUnlock())
    	DbSelectArea("CT5")
		DbSetOrder(1)
		DbSeek(xFilial("CT5")+'598'+'004')
			RecLock("CT5",.F.)
			CT5->CT5_STATUS  :='2'
            CT5->(MsUnlock())
        endif
		        
		IF(MV_PAR11=2) // se for Estorno
		//LP´s de Contas a Pagar
		DbSelectArea("CT5")
		DbSetOrder(1)
		DbSeek(xFilial("CT5")+'599'+'001')
			RecLock("CT5",.F.)
			CT5->CT5_STATUS  :='2'
            CT5->(MsUnlock())
    	DbSelectArea("CT5")
		DbSetOrder(1)
		DbSeek(xFilial("CT5")+'599'+'002')
			RecLock("CT5",.F.)
			CT5->CT5_STATUS  :='2'
            CT5->(MsUnlock())
    	DbSelectArea("CT5")
		DbSetOrder(1)
		DbSeek(xFilial("CT5")+'599'+'003')
			RecLock("CT5",.F.)
			CT5->CT5_STATUS  :='1'
            CT5->(MsUnlock())
    	DbSelectArea("CT5")
		DbSetOrder(1)
		DbSeek(xFilial("CT5")+'599'+'004')
			RecLock("CT5",.F.)
			CT5->CT5_STATUS  :='1'
            CT5->(MsUnlock())

		//Lp´s de Contas a Receber

		DbSelectArea("CT5")
		DbSetOrder(1)
		DbSeek(xFilial("CT5")+'598'+'001')
			RecLock("CT5",.F.)
			CT5->CT5_STATUS  :='2'
            CT5->(MsUnlock())
    	DbSelectArea("CT5")
		DbSetOrder(1)
		DbSeek(xFilial("CT5")+'598'+'002')
			RecLock("CT5",.F.)
			CT5->CT5_STATUS  :='2'
            CT5->(MsUnlock())
    	DbSelectArea("CT5")
		DbSetOrder(1)
		DbSeek(xFilial("CT5")+'598'+'003')
			RecLock("CT5",.F.)
			CT5->CT5_STATUS  :='1'
            CT5->(MsUnlock())
    	DbSelectArea("CT5")
		DbSetOrder(1)
		DbSeek(xFilial("CT5")+'598'+'004')
			RecLock("CT5",.F.)
			CT5->CT5_STATUS  :='1'
            CT5->(MsUnlock())	
        endif
        lRet := .T.
    Else
        lRet := .F.
    Endif 
 
return lRet
