//-------------------------------------------------------------------

/*/{Protheus.doc} GatSN3
Gatilho do objeto SN3
@since 02/08/2017
@version 12.17
/*/
//-------------------------------------------------------------------

User Function GatSN3()

Local lRet := .T.
Local oModel    := FWModelActive()
Local cDesc     := oModel:GetValue('SN1MASTER','N1_DESCRIC')
Local ddate		:= oModel:GetValue('SN1MASTER','N1_AQUISIC')

oModel:SetValue('SN3DETAIL','N3_HISTOR',cDesc)
oModel:SetValue('SN3DETAIL','N3_AQUISIC',ddate)

Return lRet