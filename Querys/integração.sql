SELECT * FROM PROTHEUS12.DBO.SOD010 

--INDICE UNICO DA TABELA SOF OF_FILIAL+OF_TRANSAC+OF_REGIST+OF_STATUS+DTOS(OF_DTENVIO)+OF_HRENVIO                                                                                                                                                                                      

--## ATIVAR E DESATIVAR INTEGRAÇÃO PROTHEUS.

--UPDATE protheus12.dbo.SOD010 SET OD_ATIVO = '1' WHERE OD_FILIAL = '01'
--UPDATE protheus12.dbo.SOD010 SET OD_ATIVO = '2' WHERE OD_FILIAL = '01'

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--##CONSULTA POSIÇÃO DE PRODUTO X ERRO DE INTEGRAÇÃO.
SELECT Ext1Integrated, ISNULL((select CASE 
									WHEN C2.C2_DATRF = '' AND C2.D_E_L_E_T_ = '*' THEN 'ABERTA/DELETADA' 
									WHEN C2.C2_DATRF = '' AND C2.D_E_L_E_T_ = '' THEN 'ABERTA/ATIVA'
									WHEN C2.C2_DATRF < '2026-06-01 00:00:00.000' THEN 'OP MES ANTERIOR'
									END AS 'STATUSOP'
									from PROTHEUS12.DBO.sc2010 C2 
									where IT.WOCODE IS NOT NULL AND C2_NUM+C2_ITEM+C2_SEQUEN = IT.WOCode),'MOVIMENTACAO') AS STATUSOP  ,
MovTypeCode,ProductCode,  replace((it.Qty * (-1)), '.',',') Qty, PC.Name , IT.ErrDescription, IDTransactions, LotCode, TraceLotCode, WOCode, Address1Code, Address2Code, Comments,IDOutInteg, UserCode, it.DtCreation,Ext1DtIntegration, *
FROM PCF_Integ.dbo.TBLOutInteg IT,  PCFV4.DBO.TBLMovType PC (NOLOCK)
WHERE PC.Code = IT.MovTypeCode AND IT.DtCreation between '2026-10-01 00:00:00.000' and '2026-11-01 00:00:00.000' and Ext1Integrated IN (0,1,3) order by IT.DtCreation

SELECT Ext1Integrated, * FROM PCF_INTEG.DBO.TBLOutInteg  WHERE Ext1Integrated in (3,0,1) AND DtCreation between '2026-10-01 00:00:00.000' and '2026-10-31 00:00:00.000'

--update PCF_Integ.dbo.TBLOutInteg set Ext1Integrated = 0 WHERE DtCreation between '2026-10-01 00:00:00.000' and '2026-10-31 00:00:00.000' and Ext1Integrated in (3) 

SELECT count(ProductCode) AS Erros , ProductCode as Produto  FROM PCF_Integ.dbo.TBLOutInteg WHERE Ext1Integrated in (3) AND DtCreation between '2026-09-01 00:00:00.000' and '2026-10-01 00:00:00.000'
GROUP BY ProductCode ORDER BY 1 DESC

SELECT Ext1Integrated, MovTypeCode,ProductCode, replace((it.Qty * (-1)), '.',',') Qty, IdOutInteg, PC.Name , IT.ErrDescription, IDTransactions, LotCode, TraceLotCode, WOCode, Address1Code, Address2Code, Comments,IDOutInteg, UserCode, IT.DtCreation,Ext1DtIntegration
FROM PCF_Integ.dbo.TBLOutInteg IT,  PCFV4.DBO.TBLMovType PC (NOLOCK)
WHERE PC.Code = IT.MovTypeCode 
--AND IT.DtCreation between '2026-10-01 00:00:00.000' and '2026-11-01 00:00:00.000' 
and Ext1Integrated in (3,0,1) 
AND IT.ErrDescription IS NOT NULL
--AND ProductCode in ('1-240-0962') 
order by IT.DtCreation 
 

--update PCF_Integ.dbo.TBLOutInteg set Ext1Integrated = 0 WHERE DtCreation >= '2022-09-01 00:00:00.000' and Ext1Integrated in (3) AND ProductCode in  ('8-210-0100') 

--update PCF_INTEG.DBO.TBLOutInteg set Ext1Integrated = 4 where IDOutInteg in (5124645,5124761,5124804)

---------------PROTHEUS


DECLARE @LOTECLT varchar(11) SET @LOTECLT = 'P2610001841'

SELECT * FROM PROTHEUS12.DBO.SBF010 BF (NOLOCK) WHERE BF_LOTECTL = @LOTECLT AND D_E_L_E_T_ = ' ' ORDER BY BF_LOTECTL

SELECT * FROM Protheus12.DBO.SB8010 (NOLOCK) WHERE B8_LOTECTL = @LOTECLT AND D_E_L_E_T_ = ' ' ORDER BY B8_LOTECTL

--UPDATE Protheus12.DBO.SB8010 SET B8_DTVALID = '20330707' WHERE B8_LOTECTL IN ('P2504030841') AND D_E_L_E_T_ = ' ' 

--UPDATE Protheus12.DBO.SB8010 SET B8_DATA = '20260915' WHERE B8_LOTECTL IN ('P2609011796') AND D_E_L_E_T_ = ' ' 

SELECT DISTINCT PR.Code, LT.Code, AD.Code, (FN.InQty-OutQty) qty, FN.IDAddress, FN.IDProduct, FN.IDLot, fn.DtCreation
FROM PCFV4.DBO.TBLFinalBalance FN, PCFV4.DBO.TBLProduct PR, PCFV4.DBO.TBLLot LT, PCFV4.DBO.TBLAddress AD 
WHERE FN.IDProduct = PR.IDProduct AND LT.IDLot = FN.IDLot AND AD.IDAddress = FN.IDAddress AND LT.Code = @LOTECLT 


SELECT D3_COD, D3_OP,D3_CF, D3_TM, D3_EMISSAO, D3_DTVALID, D3_LOTECTL, D3_LOCALIZ,D3_QUANT, D3_NUMSEQ, D3_USUARIO, D3_OBSERVA, D3_DTVALID, D3_ESTORNO, D3_DOC, D3_TIPO, D3_ZZOP, D3_CUSTO1, D3_DOC, D3_OBSERVA FROM PROTHEUS12.DBO.SD3010 (NOLOCK) WHERE D3_LOTECTL = @LOTECLT ORDER BY R_E_C_N_O_

---------------PPI
SELECT Ext1Integrated, MovTypeCode, MovTypeExtCode,replace((Qty * (-1)), '.',',') quant, LotCode, TraceLotCode, UserCode,SUBSTRING(IDTransactions,20,25) Numseq, IDTransactions, IDMovEv, * FROM PCF_Integ.dbo.TBLOutInteg WHERE DtCreation >= '2025-01-01 00:00:00.000' 
AND LotCode = @LOTECLT and Ext1Integrated in (3) order by DtCreation

SELECT Ext1Integrated, MovTypeCode, MovTypeExtCode,replace((Qty * (-1)), '.',','), LotCode, TraceLotCode, UserCode, IDTransactions, IDMovEv, * FROM PCF_Integ.dbo.TBLOutInteg WHERE DtCreation >= '2022-01-01 00:00:00.000' 
AND TraceLotCode = @LOTECLT and Ext1Integrated in (3,0,2,4) order by DtCreation


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--##CONSULTAR E ALTERAR FEHAMENTO DA OP

select D_E_L_E_T_, C2_DATRF,  * 																																	 
from Protheus12.dbo.SC2010 																																		 
--UPDATE Protheus12.dbo.SC2010 SET C2_DATRF = ' '		
where c2_num IN ('176939') and D_E_L_E_T_ = ' ' AND C2_DATRF <> ''



SELECT D_E_L_E_T_, * FROM SD4010 WHERE D4_OP IN ('15340101001','15551901001')


SELECT D3_USUARIO, D3_NUMSEQ, D3_LOTECTL, D3_LOCALIZ, D3_OBSERVA, D3_ZZOP, * FROM PROTHEUS12.DBO.SD3010 WHERE D3_DOC in ('XXXXYTBV7') ORDER BY 2


SELECT D3_USUARIO, D3_NUMSEQ, D3_LOTECTL, D3_LOCALIZ, D3_OBSERVA, D3_ZZOP, * FROM PROTHEUS12.DBO.SD3010 WHERE D3_NUMSEQ in ('9EGZY6') ORDER BY 2




--update PROTHEUS12.DBO.SD3010 set d3_usuario = '' WHERE D3_NUMSEQ in ('9BTH03')



----DUPLICIDADE DE APONTAMENTO
SELECT COUNT(H6_LOTECTL) AS LOTE, H6_PRODUTO, H6_LOTECTL, SUM(H6_QTDPROD) AS QUANTIDADE, H6_OP
FROM PROTHEUS12.DBO.SH6010
WHERE H6_DTAPONT >= '20220901'
--AND H6_OP IN ('15646801001')
AND D_E_L_E_T_ = ''
GROUP BY H6_LOTECTL, H6_OP, H6_PRODUTO HAVING COUNT(H6_LOTECTL) > 1


-----CONSULTA DE MOVIMENTOS DIGITADOS
SELECT Ext1Integrated, PCF.IDOutInteg, PCF.ProductCode, MovTypeCode, ErrDescription, Address1Code, Address2Code, replace((Qty * (-1)), '.',',') qty, d3_quant, B8_LOCAL, B8_SALDO, D3_TM, D3_LOTECTL, D3_OBSERVA, D3_USUARIO
FROM PROTHEUS12.DBO.SD3010 D3 
INNER JOIN PCF_INTEG.DBO.TBLOutInteg PCF ON PCF.LotCode = D3.D3_LOTECTL AND PCF.ProductCode = D3.D3_COD 
INNER JOIN SB8010 B8 ON B8_LOTECTL = PCF.LotCode AND B8_PRODUTO = PCF.ProductCode AND PCF.WarehouseCode = B8_LOCAL
WHERE DtCreation between '2025-10-01 00:00:00.000' and '2025-11-01 00:00:00.000' 
AND PCF.Ext1Integrated IN (3) 
--AND D3.D3_USUARIO <> ''
--AND D3.D3_TM = '901'
--AND LotCode = 'P2508033945'
ORDER BY 7



SELECT D3_TM, D3_CF, D3_LOCAL, D3_COD, D3_QUANT, D3_LOCALIZ, D3_LOTECTL, D3_USUARIO, D3_NUMSEQ, D3_OBSERVA
	FROM PROTHEUS12.DBO.SD3010 (NOLOCK) 
	WHERE D3_LOTECTL IN 
	( 
	SELECT LotCode
FROM PCF_Integ.dbo.TBLOutInteg IT,  PCFV4.DBO.TBLMovType PC (NOLOCK)
WHERE PC.Code = IT.MovTypeCode AND IT.DtCreation between '2023-08-01 00:00:00.000' and '2023-09-01 00:00:00.000' and Ext1Integrated IN (0,1,3) and MovTypeCode in ('014')


	) 
	 AND D_E_L_E_T_ = '' 
	AND D3_ESTORNO <> 'S' 
	AND D3_EMISSAO BETWEEN '20230801' AND '20230901'
	--AND D3_CF NOT IN ('RE4', 'DE4')
	AND D3_USUARIO <> ''
	AND D_E_L_E_T_ = ''



SELECT Ext1Integrated, MovTypeCode,ProductCode,  replace((it.Qty * (-1)), '.',',') Qty, PC.Name , IT.ErrDescription, IDTransactions, LotCode, TraceLotCode, WOCode, Address1Code, Address2Code, Comments,IDOutInteg, UserCode, it.DtCreation,Ext1DtIntegration
FROM PCF_Integ.dbo.TBLOutInteg IT,  PCFV4.DBO.TBLMovType PC (NOLOCK)
WHERE PC.Code = IT.MovTypeCode AND IT.DtCreation between '2023-08-01 00:00:00.000' and '2023-09-01 00:00:00.000' and Ext1Integrated IN (0,1,3) and MovTypeCode in ('014') and LotCode not in



SELECT D3_TM, D3_COD, D3_LOTECTL, D3_USUARIO, D3_QUANT, D3_EMISSAO
FROM SD3010 
WHERE D3_OP = '16860001001' AND D3_TM IN ('912','901','010') AND D3_ESTORNO <> 'S'
GROUP BY D3_TM, D3_COD, D3_USUARIO


SELECT *
FROM SD3010 
WHERE D3_OP = '15551901001' 
AND D3_TM IN ('010')
GROUP BY D3_TM, D3_COD



SELECT D3_LOTECTL, * FROM SD3010 WHERE D3_ZZOP = '16354601001'


P2505027631




  select idresource, * from TBLResource where code ='000411'

  select * from tblretentiv where idresource= 1



  SELECT * FROM SD2010 WHERE D2_LOTECTL = 'P2603002794'





select * from protheus12.dbo.SB8010 

update protheus12.dbo.SB8010 set b8_data = '20260626' WHERE B8_LOTECTL IN (
'P2606026560',
'P2606026735',
'P2606027239',
'P2606027136',
'P2606026663',
'P2606027487',
'P2606027402',
'P2606027136',
'P2606028920')







