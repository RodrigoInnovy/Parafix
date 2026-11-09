#include "Protheus.ch"
#include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออหอออออออัอออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบClasse    ณParafMBrowse บAutor  ณtuning Sistemas  บ Data ณ  14/07/14   บฑฑ
ฑฑฬออออออออออุอออออออออออออสอออออออฯอออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Classe para montagem de um MBrowse a partir de uma query.  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Microsiga Protheus                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Class ParafMBrowse

	Data cQuery		as String
	Data aSetFields	as Array	&& Array com os campos para executar o SetField
	Data aCoorden	as Array	&& Array com coordenadas de posicao
	Data cAreaOri	as String	&& Area da query a ser utilizada
	Data cAlias		as String	&& Alias da tabela temporaria a ser criada, padrao TRB
	Data aCampos	as Array	&& Descricao de campos a serem visualizados
	Data aCores		as Array	&& Cores a serem visualizadas
	Data aExtraCPO	as Array	&& Descricao de campos extras a serem visualizados
	Data aStructArq as Array	&& Estrutura do arquivo temporario criado
	Data aIndex		as Array	&& Indices a serem utilizado no arquivo temporario criado
	Data cCampoMark as String	&& Campo utilizado para a marcacao do MarkBrowse
	Data cMarca		as String	&& Informacao sobre a string da "Marca" utilizada
	Data nTimeRfsh	as Number	&& Tempo do Refresh em Segundos.
	Data bRfshBr 				&& Bloco de Codigo do Refresh
	Data oTimer		as Object   && Objeto Timer.
	Data oBrowse	as Object	&& Objeto do Browse

	Method New(aCoorden,cAreaOri,aCampos,aCores,aExtraCPO,cIndice) Constructor
	Method ExecQuery() 			&& Executa a query de consulta
	Method CriaTemporario()		&& Cria arquivo temporario para ser exibido
	Method PegaDescricao()		&& Busca a descricao dos campos no SX3, caso o parametro aCampos esteja vazio
	Method Pesquisa()			&& Monta tela de pesquisa para o arquivo de trabalho em questao
	Method MarcaBox() 			&& Metodo para marcacao de um item do MarkBrowse
	Method MarcaTudo() 			&& Metodo para marcacao de todos os itens do MarkBrowse
	Method Show(lMark) 			&& Monta a Tela com o MBrowse
	Method Close() 				&& Fecha o arquivo temporario
	Method SetTimeRefresh(nTime) && Seta o tempo do Refresh. Quando nao setado o padrao e 5 segundos.
	Method Refsh(oObj)			&& Faz o Refresh no mBrowse
	Method StartRefresh()		&& Faz o Refresh no mBrowse com Timer
	Method StopRefresh()		&& Para o Refresh no mBrowse com Timer
	Method Refresh()			&& Faz o Refresh Instantaneo

EndClass


*************************************************************************************************************************************************************************
&& Metodo construtor
&& aPedidos	- Array com coordenadas de posicao
&& cAreaOri	- Area a ser consultada ou exibida
&& aCampos	- Descricao de campos a serem visualizados
&& aCores	- Cores a serem visualizadas
Method New(aCoorden,cAreaOri,aCampos,aCores,aExtraCPO,aIndices) Class ParafMBrowse

	::cQuery	:= ""
	::aSetFields:= {}
	::cAlias	:= "TRB"
	::aCoorden	:= aCoorden
	::cAreaOri	:= cAreaOri
	::aCampos	:= iif( ValType(aCampos) == "A",aCampos,{})
	::aCores	:= iif( ValType(aCores) == "A",aCores,{})
	::aExtraCPO	:= iif( ValType(aExtraCPO) == "A",aExtraCPO,{})
	::aStructArq:= {}
	::aIndex	:= iif( ValType(aIndices) == "A",aIndices,{})
	::cCampoMark:= ""
	::cMarca	:= ""
	::nTimeRfsh := 5
	::oBrowse	:= Nil
	::bRfshBr 	:= {|x| ::Refsh(x), ::oBrowse := x }
	::oTimer	:= Nil

Return


*************************************************************************************************************************************************************************
&& Executa a query de pesquisa
Method ExecQuery() Class ParafMBrowse

Local nI := 0

	If Select(::cAlias) <> 0
		(::cAlias)->(dbCloseArea())
	Endif

	If Select(::cAreaOri) <> 0
		(::cAreaOri)->(dbCloseArea())
	Endif

	TcQuery ::cQuery New Alias (::cAreaOri)
	
	For nI := 1 to Len(::aSetFields)
		TcSetField( ::cAreaOri, ::aSetFields[nI,1], ::aSetFields[nI,2], ::aSetFields[nI,3], ::aSetFields[nI,4] )
	Next nI

	::CriaTemporario()
	::PegaDescricao()
	
Return


*************************************************************************************************************************************************************************
&& Cria arquivo temporario para ser exibido
Method CriaTemporario() Class ParafMBrowse

Local nI			:= 0
Local cTmp			:= ""
Local cNomeCampo	:= ""
Local cTipoCampo	:= ""
Local nTamanCampo	:= 0
Local nDecimCampo	:= 0
Local cArqTrab		:= ""
Local aTmpIndices	:= {}
Local cArqInd		:= ""
Local cIndice		:= ""
Local cAlias
Local aStructArq

&& Posiciono no primeiro registro da query
(::cAreaOri)->(dbGoTop())
    
&& Monto a estrutura do arquivo temporario com base na query informada
::aStructArq := {}
For nI:=1 To (::cAreaOri)->( FCount() )
	cNomeCampo	:= (::cAreaOri)->( FieldName(nI) )
	If !(cNomeCampo $ "D_E_L_E_T_/R_E_C_N_O_")
		cTipoCampo	:= ValType( &((::cAreaOri)->(cNomeCampo)) )
		If cTipoCampo == "C"	
			nTamanCampo	:= Len( &((::cAreaOri)->(cNomeCampo)) )
			nDecimCampo	:= 0
		Else
			nTamanCampo	:= 15
			nDecimCampo	:= 4
		Endif
		aadd( ::aStructArq, { cNomeCampo, cTipoCampo, nTamanCampo, nDecimCampo } )
	Endif
Next nI

&& Monta o indice
If Len(::aIndex) == 0
	For nI := 1 to Len(::aStructArq)
		If ::aStructArq[nI,2] == "C"
			cTmp += Iif(!Empty(AllTrim(cTmp)),"+","") + ::aStructArq[nI,1]
		Endif
	Next nI
	aadd(::aIndex, {"Padrao",cTmp} )
Endif

&& Crio o arquivo temporario

oTempTable := FWTemporaryTable():New(cAlias, aStructArq)

dbSelectArea(::cAlias)
For nI := 1 to Len(::aIndex)
	cArqInd := CriaTrab(,.F.)
	cIndice	:= ::aIndex[nI,2]
	
	aadd(aTmpIndices, cArqInd)
	
	(::cAlias)->(DbCreateIndex( cArqInd, cIndice, {|| &cIndice}, .F. ))
	(::cAlias)->(DbCommit())		     
Next nI

(::cAlias)->(DbClearInd())
For nI := 1 to Len(aTmpIndices)
	(::cAlias)->(DbSetIndex( aTmpIndices[nI] ))	
Next nI
	
(::cAlias)->(dbSetOrder(1))

&& Gravo o conteudo da query no arquivo temporario
Do While !(::cAreaOri)->(eof())

	RecLock((::cAlias),.T.)
		For nI := 1 To Len(::aStructArq)
			(::cAlias)->( FieldPut( FieldPos(::aStructArq[nI,1]), (::cAreaOri)->&(::aStructArq[nI,1]) ) )
		Next nI
	(::cAlias)->(MsUnlock())

	(::cAreaOri)->(dbSkip())
	
Enddo

(::cAlias)->(dbGoTop())

Return


*************************************************************************************************************************************************************************
&& Busca a descricao dos campos no SX3, caso o parametro aCampos esteja vazio
Method PegaDescricao() Class ParafMBrowse

Local nI		:= 0
Local nCpoExtra	:= 1

If Len(::aCampos) == 0

	dbSelectArea("SX3")
	dbSetOrder(2)
	
	If Len(::aStructArq) > 0
		For nI := 1 to Len(::aStructArq)
        	If SX3->( dbSeek(::aStructArq[nI,1]) )
        		aadd(::aCampos, {getSX3Cache(aStructArq[nI], "X3_TITULO"),;
        		::aStructArq[nI,1], ::aStructArq[nI,2], getSX3Cache(aStructArq[nI], "X3_TITULO"), ;
        		                                        getSX3Cache(aStructArq[nI], "X3_DECIMAL"), ;
        		                                        getSX3Cache(aStructArq[nI], "X3_PICTURE")} )
        	Else
        		If Len(::aExtraCPO) > 0 .and. Len(::aExtraCPO) >= nCpoExtra
        			aadd(::aCampos, {::aExtraCPO[nCpoExtra], ::aStructArq[nI,1], ::aStructArq[nI,2], ::aStructArq[nI,3], ::aStructArq[nI,4], "" } )
        			nCpoExtra ++
        		Else
	        		aadd(::aCampos, {capital(lower(alltrim(self:aStructArq[nI,1]))), ::aStructArq[nI,1], ::aStructArq[nI,2], ::aStructArq[nI,3], ::aStructArq[nI,4], "" } )
	        	Endif
        	Endif
		Next nI
		
	Else
		MsgStop("A estrutura do arquivo temporแrio nใo foi criada")
	Endif
Endif

Return


*************************************************************************************************************************************************************************
&& Monta a Tela com o MBrowse ou MarkBrowse
Method Show(lMark) Class ParafMBrowse

Local nI		:= 0
Local aCpoMark	:= {}

Default lMark	:= .F.

	If lMark
		&& Monta um array com os campos do MarkBrowse, esse array tem posicoes diferentes do mBrowse
		For nI := 1 to Len(::aCampos)
			aadd( aCpoMark, {::aCampos[nI,2] ,::aCampos[nI,1] , ::aCampos[nI,1], ::aCampos[nI,6]  } )
		Next nI
		::cMarca := GetMark(,(::cAlias),(::cCampoMark))
		MarkBrow( (::cAlias),(::cCampoMark),,aCpoMark,,::cMarca)
//		MarkBrow( (::cAlias),(::cCampoMark),,aCpoMark,,::cMarca,"oMBrowse:MarcaTudo()",,"u_SBFiltIFil()","u_SBFiltFFil()","oMBrowse:MarcaBox()")		
	Else
		MBrowse(::aCoorden[1],::aCoorden[2],::aCoorden[3],::aCoorden[4],(::cAlias),::aCampos,,,,,::aCores,,,,::bRfshBr,)	
	Endif	

Return


*************************************************************************************************************************************************************************
&& Monta a Tela com o MBrowse ou MarkBrowse
Method Pesquisa(lMark) Class ParafMBrowse

Local oDlgPesq, oComboInd, oGetPesq, oBtnCan, oBtnOK
Local nI			:= 0
Local aComboList	:= {}
Local cCombo		:= ""
Local nOrdem		:= 0
Local cPesquisa		:= Space(50)
Local lOk			:= .F.
Local nStyle		:= nOr(WS_CAPTION, WS_MAXIMIZEBOX, WS_CHILD)

	&& Agrupa a descricao dos indices
	For nI := 1 to Len(::aIndex)
	  	aadd(aComboList, ::aIndex[nI,1])
	Next nI

	&& Inicia a montagem do dialogo para pesquisa
	oDlgPesq := TDialog():New( 0, 0, 110, 420, "Pesquisa",,,,nStyle,,,,,.T.)
	oDlgPesq:lCentered := .T.
		oComboInd 	:= TComboBox():New(05,05,{|u|if(PCount()>0,cCombo:=u,cCombo)}, aComboList,200,008, oDlgPesq,, ,,,,.T.,,,,,,,,,)
		oGetPesq	:= TGet():New(020, 005, bSetGet(cPesquisa) , oDlgPesq, 200, 008, "@!",,,,,,,.T.,,,,,,)
		oBtnOK	:= TButton():New(35, 165 ,"Pesquisa", oDlgPesq, { || lOk := .T., oDlgPesq:End() }, 40, 15 ,,,,.T.,,,, { || } ,{ || .T. } )
		oBtnCan	:= TButton():New(35, 115 ,"Cancela" , oDlgPesq, { || oDlgPesq:End() } , 40, 15 ,,,,.T.,,,, { || } ,{ || .T. } )
	oDlgPesq:Activate()
	
	If lOk
		nOrdem := aScan( ::aIndex, { |x| x[1] == cCombo } )
		(::cAlias)->(dbSetOrder(nOrdem))
		(::cAlias)->(dbGoTop())
		If !Empty(AllTrim(cPesquisa))
			(::cAlias)->(dbSeek(cPesquisa,.T.))
		Endif
	Endif

Return


*************************************************************************************************************************************************************************
&& Marca o Registro posicionado no MarkBrowse
Method MarcaBox() Class ParafMBrowse

   RecLock((::cAlias),.F.)
	If IsMark(::cCampoMark,::cMarca )
	   (::cAlias)->&(::cCampoMark) := Space(2)
	Else
	   (::cAlias)->&(::cCampoMark) := ::cMarca
	Endif
   (::cAlias)->(MsUnLock())

Return .T.


*************************************************************************************************************************************************************************
&& Marca o Registro posicionado no MarkBrowse
Method MarcaTudo() Class ParafMBrowse

Local nRegistro := (::cAlias)->(Recno())

	(::cAlias)->(dbGoTop())	
	While !(::cAlias)->(Eof())
   		::MarcaBox()
		(::cAlias)->(dbSkip())
	Enddo   
	(::cAlias)->(dbGoTo(nRegistro))

Return .T.


*************************************************************************************************************************************************************************
&& Fecha o arquivo temporario
Method Close() Class ParafMBrowse

	(::cAreaOri)->(dbCloseArea())
	(::cAlias)->(dbCloseArea())

Return



//User Function SBFiltIFil() 
//Return("01")

//User Function SBFiltFFil()
//Return("99")


*******************************************************
&& Realiza o Refsh no mBrowse
Method Refsh(oObj) Class ParafMBrowse

	::oTimer := TTimer():New((::nTimeRfsh*1000)  , {|| ::ExecQuery(), oObj := GetObjBrow(), oObj:Default(), oObj:Refresh() }, oObj )

	
Return

Method Refresh() Class ParafMBrowse
    
	::ExecQuery()
	::oBrowse := GetObjBrow()
	if empty(::cCampoMark)
		::oBrowse:Default()
		::oBrowse:Refresh()
	else
		MarkBRefresh()
	endIf

Return

Method StartRefresh() Class ParafMBrowse
      
	::oTimer:lActive := .t.
	::oTimer:Activate()

Return

Method StopRefresh() Class ParafMBrowse

	::oTimer:lActive := .f.
	::oTimer:DeActivate()

Return

***********************************************
&& Set o Tempo do Refresh
Method SetTimeRefresh(nTime) Class ParafMBrowse
	
	If ValType(nTime) == "N" .And. nTime > 0
		::nTimeRfsh := nTime
	Endif

Return   

*************************************************************************************************************************************************
&& Fim da Clasee
*************************************************************************************************************************************************
