#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#INCLUDE "apvt100.ch"
#DEFINE cEOL CHR(13) + CHR(10)

/*	
	Programa	:	PlacaTrans
	Autor		:	Evandro Simenes
	Data		:	17/11/2017
	Descricao	:	Rotina para usuario informar a placa do caminhao da transportadora no Embarque
*/

User Function PlacaTrans()
	Local cPlaca 	:= Space(8)	&& Etiqueta
	Local aAuxTela	:= {}			&& Array tela
	
	&& Salvar tela
	VTSave Screen To aAuxTela

	&& Exibir tela para ler etiqueta
	//VtClear()
		@04,00 VtSay "Placa:"
		@04,07 VtGet cPlaca Pict "@!"
	VtRead
	
	&& Salvar tela
	VTSave Screen To aAuxTela
	
	If 	VtLastkey() == 27
		Return .F.
	Else	
		RECLOCK("CB7",.F.)
		CB7->CB7_ZZPLAC := cPlaca
		MSUNLOCK()
	EndIf
	
	&& Restaurar tela
	VTRestore Screen From aAuxTela   
	
Return
