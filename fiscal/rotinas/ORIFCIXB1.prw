#include 'protheus.ch'
#include "tbiconn.ch"
#include "topconn.ch"


/*/{Protheus.doc} ORIFCIXB1
//Programa busca a ultima apuracao da FCI e altera o campo B1_ORIGEM do cadastro de produto.
@author Patrick Araujo
@since 01/08/2018
@version 1.0
@return ${return}, ${return_description}

@type function
/*/

user function ORIFCIXB1()

Local cPercal := ''
Local cDtbase := Substr(dtos(dDatabase),1,6)
Local cQry 	:= ''
Local cQry2 := ''
Local cAliasSB1 := GetNextAlias()

If Pergunte("ORIFCI",.T.)

	cPercal := Alltrim(MV_PAR01)

	If MsgNoYes(OemToAnsi("Confirma atualização do campo B1_ORIGEM de acordo com apuracao da FCI ? "),OemToAnsi("Atenção"))


		If cDtbase >= cPercal

			cQry2 := "SELECT B1_FILIAL, B1_COD FROM "+RetSqlName("SB1")
			cQry2 += " INNER JOIN "+ RetSqlName("CFD")+" ON B1_FILIAL = CFD_FILIAL AND B1_COD = CFD_COD"
			cQry2 += " AND B1_ORIGEM <> CFD_ORIGEM AND CFD_PERCAL = '"+substr(cPercal,5,2)+substr(cPercal,1,4)+"' AND "
			cQry2 += RetSqlName("CFD")+".D_E_L_E_T_ = '' AND CFD_ORIGEM <> ''"
			cQry2 += " WHERE "+RetSqlName("SB1")+".D_E_L_E_T_ = ''"

			TCQuery cQry2 new Alias (cAliasSB1)  
		
			cQry := "UPDATE "+RetSqlName("SB1")+" SET B1_ORIGEM = CFD_ORIGEM FROM "+RetSqlName("SB1")
			cQry += " INNER JOIN "+ RetSqlName("CFD")+" ON B1_FILIAL = CFD_FILIAL AND B1_COD = CFD_COD"
			cQry += " AND B1_ORIGEM <> CFD_ORIGEM AND CFD_PERCAL = '"+substr(cPercal,5,2)+substr(cPercal,1,4)+"' AND "
			cQry += RetSqlName("CFD")+".D_E_L_E_T_ = '' AND CFD_ORIGEM <> ''"
			cQry += " WHERE "+RetSqlName("SB1")+".D_E_L_E_T_ = ''"
			
			TCSqlExec(cQry)

			dbSelectArea(cAliasSB1)
    		(cAliasSB1)->(DbGoTop())

    		If (cAliasSB1)->(!EOF())

				If(SB1->(DbSeek((cAliasSB1)->B1_FILIAL+(cAliasSB1)->B1_COD)))
					
					If SB1->B1_ORIGEM $ "0|5" .AND. SB1->B1_GRTRIB <> ''

						Reclock("SB1",.F.)
							SB1->B1_GRTRIB = ""
						SB1->(MsUnLock())
					
					Elseif SB1->B1_ORIGEM = "1|3|8" .AND. SB1->B1_GRTRIB <> '003'
	
						Reclock("SB1",.F.)
							SB1->B1_GRTRIB = "003"
						SB1->(MsUnLock())

					Endif

					(cAliasSB1)->(DbSkip())

				Endif	

			Endif	
		
			Msginfo("Produtos atualizados com sucesso !!!")
			
		
		Else
			MsgInfo("A data atual do sistema é menor que o periodo apurado na FCI !!!")
			
		Endif	
		

	Endif

Endif	
	
return