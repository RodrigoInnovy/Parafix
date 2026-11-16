SELECT 
	  Ext1Integrated
	, MovTypeCode
	, ProductCode
	, replace((it.Qty * (-1)), '.',',') Qty
	, IdOutInteg
	, PC.Name 
	, IT.ErrDescription
	, IDTransactions
	, LotCode
	, TraceLotCode
	, WOCode
	, Address1Code
	, Address2Code
	, Comments
	, IDOutInteg
	, UserCode
	, IT.DtCreation
	, Ext1DtIntegration

FROM PCF_Integ.dbo.TBLOutInteg IT,  PCFV4.DBO.TBLMovType PC (NOLOCK)

WHERE PC.Code = IT.MovTypeCode 
and Ext1Integrated in (3,0,1) 
AND IT.ErrDescription IS NOT NULL

order by IT.DtCreation	

-- update PCF_Integ.dbo.TBLOutInteg set Ext1Integrated = 0 WHERE DtCreation >= '2022-09-01 00:00:00.000' and Ext1Integrated in (3) AND ProductCode in  ('8-210-0100') 