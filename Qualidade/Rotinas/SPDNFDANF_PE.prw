#include 'protheus.ch'
#include 'topconn.CH'

/*/{Protheus.doc} SPDNFDANF
Este ponto de entrada foi criado para atender a necessidade de impressão da DANFE 
automático após realizar monitoramento da Nota Fiscal Eletrônica, tanto pela rotina 
Nf-e Sefaz (SPEDNFE.PRX) como também pela funcionalidade do AutoNfe através da rotina 
AutoNfeMon, e atualização das tabelas SF3, SF2 ou SF1 e SFT.

Atualmente, o ponto de entrada é executada somente quando encontra o registro da 
SF2 ou SF1 e a espécie da nota seja SPED, ou seja, somente para notas autorizadas, 
pois ao excluir a nota o registro da tabela SF2 ou SF1 é excluído.

@type           Function
@author         Julio Lisboa
@since          07/12/2021
/*/
User Function SPDNFDANF()

	local aAreaSF2		:= SF2->(GetArea())
	local lOnOff		:= getnewpar("ZZ_AUTCERT",.F.)

	local cNota         := PARAMIXB[01]
	local cSerie        := PARAMIXB[02]
	local cClieFor      := PARAMIXB[05]
	local cLoja         := PARAMIXB[06]

    //Se o ambiente estiver dentro do parametro, nao executa a rotina
	If existblock("fCertQual") .and. lOnOff
		SF2->(DbSetOrder(1)) //F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO
		If SF2->(DbSeek( FwXFilial("SF2") + cNota + cSerie + cClieFor + cLoja ))
			U_fCertQual(SF2->F2_FILIAL,SF2->F2_DOC)
		endif
	EndIf

	restArea(aAreaSF2)

Return
