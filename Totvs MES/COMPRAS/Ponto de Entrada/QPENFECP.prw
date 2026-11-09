/*/{Protheus.doc} User Function QPENFECP
    (Rotina para adição de campos customizados do XML em campos customizados da SD1 (itens) do documento de entrada)
    @type  Function
    @author Heitor dos Santos
    @since 12/06/2020
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function QPENFECP
//{oxml:_NFEPROC:_NFE:_INFNFE:_DET,_nI,aClone(aLinha)}
//Local _oItXml  := Paramixb[1]
//Local _nIt     := Paramixb[2]
Local _aLinha  := Paramixb[3]
Local _cLote   := ""
Local _dDtVal  := date()
Local _nPosCod := AScan( _aLinha,  { |x| x[1] =="D1_COD"})
Local _nPosPed := AScan( _aLinha,  { |x| x[1] =="D1_PEDIDO"})
Local _nPosItP := AScan( _aLinha,  { |x| x[1] =="D1_ITEMPC"})
Local _cPedido := IIF(_nPosPed>0,_aLinha[_nPosPed][2],"")
Local _cItemPc := IIF(_nPosPed>0,_aLinha[_nPosItP][2],"")
Local _cProd   := _aLinha[_nPosCod][2]

    if !Empty(_cPedido+_cItemPc) .and. SB1->B1_RASTRO == "L"
  //      _cLote:= Staticcall(IMPXML13_pe,retlote,_cPedido,_cItemPc)  //retlote(_cPedido,_cItemPc)
        _cLote := retlote(_cPedido,_cItemPc) 
        aadd(_aLinha,{"D1_LOTECTL"  , _cLote 		,Nil})

        //_dDtVal:= Staticcall(IMPXML13_pe,retValid,_cProd)  //retValid(_cProd) 
         _dDtVal:= retValid(_cProd) 
        aadd(_aLinha,{"D1_DTVALID"  , _dDtVal 		,Nil})
    endif

Return _aLinha



 /*/{Protheus.doc} retlote
	 (long_description)
	 @type  Static Function
	 @author user
	 @since 13/08/2021
	 @version version
	 @param param_name, param_type, param_descr
	 @return return_var, return_type, return_description
	 @example
	 (examples)
	 @see (links_or_references)
 /*/
 Static Function retlote(_cPedido,_cItemPc)
 Local cRet
	 cRet := "P"+_cPedido + _cItemPc
 Return cRet


 /*/{Protheus.doc} retValid
	 (long_description)
	 @type  Static Function
	 @author user
	 @since 13/08/2021
	 @version version
	 @param param_name, param_type, param_descr
	 @return return_var, return_type, return_description
	 @example
	 (examples)
	 @see (links_or_references)
 /*/

 Static Function retValid(_cProd)
 Local _nPrzVal:= Posicione("SB1",1,xFilial("SB1") + _cProd,"B1_PRVALID")
 Local _dRet:= dDatabase + _nPrzVal
	 
 Return _dRet
