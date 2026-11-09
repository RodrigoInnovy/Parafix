SELECT Ext1Integrated, MovTypeCode,ProductCode, replace((it.Qty * (-1)), '.',',') Qty, IdOutInteg, PC.Name , IT.ErrDescription, IDTransactions, LotCode, TraceLotCode, WOCode, Address1Code, Address2Code, Comments,IDOutInteg, UserCode, IT.DtCreation,Ext1DtIntegration
FROM PCF_Integ.dbo.TBLOutInteg IT,  PCFV4.DBO.TBLMovType PC (NOLOCK)
WHERE PC.Code = IT.MovTypeCode 
--AND IT.DtCreation between '2026-10-01 00:00:00.000' and '2026-11-01 00:00:00.000' 
and Ext1Integrated in (3,0,1) 
AND IT.ErrDescription IS NOT NULL
--AND ProductCode in ('1-240-0962') 
order by IT.DtCreation	