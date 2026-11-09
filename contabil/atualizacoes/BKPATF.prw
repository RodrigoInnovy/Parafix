#include "Protheus.ch"
#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  BKPATF  ³ Autor ³ DONIZETE              ³ Data ³ 12/01/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Este programa gera backup dos arquivos do Ativo.           ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Chamada atraves do menu miscelanea.                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Alterado ³ Data    ³ Motivo                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Diogo M. ³ 05/03/10³ Adaptado rotina para fazer backup de todos os re ³±±
±±³          ³         ³ gistros das tabelas, independente se o mesmo est ³±±
±±³          ³         ³ a deletado ou nao; Implementado opcao restore.   ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function BKPATF()
Local cTabSN1		:= ""
Local lEnd			:= .F.
Local aOpcoes		:= IIf(AllTrim(cUserName)=='Administrador',{"Backup","Restore"},{"Backup"})

Private aParamBox	:= {}         

// Declaração de variáveis.
Public _cNomArq		:= ""
Public _cArqDest1	:= ""
Public _cData		:= "_" + DTOS(ddatabase)
Public _aEmpresa	:= {}
Public _cPathDest	:= "\BkpAtivo\"
Public _lYesNo		:= .F.
Public _lExistArq	:= .F.  
Public _lOk			:= .F.
Public _cEmpFil		:= SM0->M0_CODIGO+"/"+SM0->M0_NOME

	aAdd(aParamBox,{3,"Opções",1,aOpcoes,50,"",.T.})
	If ParamBox(aParamBox,"Parametros",,,,.T.,,,,"BKPATF",.T.,.T.)
		If MV_PAR01 == 1
			_lYesNo := MsgBox("Confirma backup do ativo da empresa "+_cEmpFil+"?","Backup","YESNO")
			If _lYesNo	== .F.
				Return
			EndIf
			
			// Executa o processo principal.
			Processa( {|| RunBkp() },"Aguarde. Gerando backup dos arquivos ..." )
		Else
		   _lYesNo := MsgBox("Confirma restore do ativo da empresa "+_cEmpFil+"?","Restore","YESNO")
			If _lYesNo	== .F.
				Return
			EndIf
			
			cTabSN1 := cGetFile('Arquivo SN1 (sn1*.dtc) | sn1*.dtc','Selecione o arquivo SN1',0,'SERVIDOR\BKPAtivo\',.T.,GETF_NOCHANGEDIR,.T.)
			If !Empty(cTabSN1)
				Private oProcess := Nil

				oProcess := MsNewProcess():New( { |lEnd| RunRestore(@lEnd,cTabSN1) } , "Aguarde o processamento" , "" , .T.)
				oProcess:Activate()
			EndIf
		EndIf
   EndIf

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FUNCAO PRINCIPAL                                                    ³
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
Static Function RunBkp()
// Inicializa empresas a serem processadas.
aadd(_aEmpresa,SM0->M0_CODIGO)

// Define o número de arquivos a serem processados.
ProcRegua(15)

// Processa o backup.
For i=1 to len(_aEmpresa)
	
	//.. Backup das tabelas do Ativo Fixo ..//
	Backup("SN1")
	If _lOk
		Backup("SN2")
		Backup("SN3")
		Backup("SN4")
		Backup("SN5")
		Backup("SN6")
		Backup("SN7")
		Backup("SN8")
		Backup("SN9")
		Backup("SNA")
		Backup("SNB")
		Backup("SNC")
		Backup("SND")
		Backup("SNE")  
			
		If cEmpAnt == "00"
			Backup("SNG")
        End IF
        		
		MsgBox("Backup concluido. Arquivos gravados na raiz do server em "+_cPathDest+".")

	EndIf
	
Next

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FUNCAO DE BACKUP                                                    ³
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
Static Function Backup(_cTabela)
Local cQuery := ""
Local aAreaSX3 := {}
// Incrementa a régua.
IncProc("Processando tabela " + _cTabela)

// Verifica se o diretório de backup existe.
_cPathDest := Alltrim(_cPathDest)
If !File(Left(_cPathDest,Len(_cPathDest)-1))
	Alert("A Pasta [ " + _cPathDest + " ] não existe no servidor. Procure o administrador e peça para criá-la.")
	Return
EndIf

// Carrega o alias. Necessário para que o SIGA crie a tabela caso não exista.
dbSelectArea(_cTabela)

// Faz o backup.
_cNomArq	:=_cTabela-_aEmpresa[i]-"0"
_cArqDest1	:=_cPathDest+_cNomArq+_cData+".dtc"

// Verifica se já existe arquivo.
If File(_cArqDest1)
	_lExistArq := .T.
EndIf

_lYesNo := .T.
If _lExistArq .And. !_lOk
	_lYesNo := MsgBox("Backup efetuado anteriormente. Sobrepor?","Sobrescrever?","YESNO")
EndIf

If !_lYesNo 
	_lOk := .F.
Else
	_lOk := .T.
EndIf

If !_lExistArq .Or. _lOk
	/* Faz backup de todos os registros independente se o mesmo estiver deletado
	cQuery := " SELECT * FROM " + RetSqlName(_cTabela)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),_cNomArq,.T.,.F.)
   
   aAreaSX3 := SX3->(GetArea())
	SX3->(DbSelectArea("SX3"))
	SX3->(DbSetOrder(1))
	If SX3->(DbSeek(_cTabela))
		Do While SX3->(!Eof()) .AND. SX3->X3_ARQUIVO == _cTabela
	  		If SX3->X3_TIPO == "N"
	  			TcSetField(_cNomArq, SX3->X3_CAMPO, SX3->X3_TIPO, TamSx3(SX3->X3_CAMPO)[1], TamSx3(SX3->X3_CAMPO)[2])
   		EndIf
   		SX3->(DbSkip())
   	EndDo
   EndIf
   RestArea(aAreaSX3)
   
	DbSelectArea(_cNomArq)
	*/
	
	oTempTable := FWTemporaryTable():New(_cNomArq)
	copy to &_cArqDest1 VIA "CTREECDX"
	
	DbCloseArea(_cNomArq)
Else
	Alert("Backup não efetuado!")
EndIf

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ RunRestore³ Autor ³ Diogo Mesquita       ³ Data ³ 11/03/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Funcao responsavel por processar o restore dos arquivos.   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ RunRestore(< lPar01, cPar02 >)                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lPar01: Controle de processamento;                         ³±±
±±³          ³ cPar02: Arquivo SN1 (DBF / DTC) selecionado.               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ lReturn                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SIGAATF                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Analista ³ Data    ³ Motivo                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³         ³                                                  ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RunRestore(lEnd,cArquivo)
Local lReturn 		:= .T.
Local aTabelas		:= {'SN1','SN2','SN3','SN4','SN5','SN6','SN7','SN8','SN9','SNA','SNB','SNC','SND','SNE','SNG'}
Local nI := nY		:= 0	
Local cAux			:= ""
Local cMsg			:= ""
Local lOK			:= .T.
Local cTabela		:= ""
Local cAlias		:= ""
Local aEstrutura	:= {}
Local nQtdReg		:= 0
Local nReg			:= 0
Local aAux			:= {}

   For nI := Len(cArquivo) to 1 Step -1
   	If SubStr(cArquivo,nI,1) == '\'
   		Exit
   	EndIf
   	cAux := Substr(cArquivo,nI,1) + cAux      
	Next nI
   cAux := SubStr(cAux,4,16)
	
	For nI := 1 to Len(aTabelas)
		If !File("\BKPAtivo\"+aTabelas[nI]+cAux)
			cMsg += aTabelas[nI] + " "
		Else
			aAdd(aAux,aTabelas[nI])
		EndIf
	Next nI
	
	If !Empty(cMsg)
		cMsg := "Arquivo da(s) tabela(s): " + cMsg + " não encontrado(s). Deseja realmente continuar ?"
		If !MsgYesNo(cMsg,"ATENÇÃO")   
      	lOK := .F.
      EndIf
	EndIf
	
	If lOK
		oProcess:SetRegua1(Len(aAux))
		For nI := 1 to Len(aAux)
			oProcess:IncRegua1("Lendo tabela " + aAux[nI] + "...")
			
			cTabela := RetSqlName(aAux[nI])
			DbUseArea(.T.,"TOPCONN",cTabela,"TMP",.F.,.F.)
			TMP->(DbSelectArea("TMP"))
			If TMP->(NetErr())
				MSGSTOP("Nao foi possível abrir a tabela " + cTabela + " em modo EXCLUSIVO. O processo será abortado.","ERRO")
				Return .F.
			Else
				MsAguarde({|lEnd| fLimpaTabela(cTabela)},"Aguarde o processamento","Excluindo registros atuais da tabela " + cTabela + "...",.T.)
			EndIf
		   TMP->(DbCloseArea())
		   
			oTempTable := FWTemporaryTable():New('TMP')
			TMP->(DbSelectArea("TMP"))
			Count to nQtdReg
			TMP->(DbGoTop())
			oProcess:SetRegua2(nQtdReg)

			cAlias := aAux[nI]
			&(cAlias)->(DbSelectArea(cAlias))
			aEstrutura := &(cAlias)->(DbStruct())
			Do While TMP->(!Eof())
				oProcess:IncRegua2("Restaurando registro " + StrZero(++nReg,8) + " de " + StrZero(nQtdReg,8))

				&(cAlias)->(RecLock(cAlias,.T.))
				For nY := 1 to Len(aEstrutura)
					If TMP->(FieldPos(aEstrutura[nY,1])) > 0
						&(cAlias)->(FieldPut(&(cAlias)->(FieldPos(aEstrutura[nY,1])),TMP->(FieldGet(TMP->(FieldPos(aEstrutura[nY,1]))))))
					EndIf		
				Next nY
				&(cAlias)->(MsUnLock())

				TMP->(DbSkip())
			EndDo
			TMP->(DbCloseArea())
			nReg := 0
		Next nI
		
		MSGINFO("Processamento finalizado.","INFORMAÇÃO")
	Else
		MSGSTOP("Processamento abortado.", "ERRO")	
	EndIf
Return (lReturn)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ fLimpaTabela³ Autor ³ Diogo Mesquita     ³ Data ³ 12/03/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Funcao responsavel por limpar a tabela em processamento.   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fLimpaTabela(< cPar01 >)                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cPar01: Tabela em processamento.                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nil                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SIGAATF                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Analista ³ Data    ³ Motivo                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³         ³                                                  ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function fLimpaTabela(cTabela)
	
	TMP->(DbSelectArea("TMP"))
	ZAP
	
Return Nil