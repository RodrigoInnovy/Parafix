DECLARE @LOTECLT varchar(11) SET @LOTECLT = 'P2610010822'

SELECT DISTINCT PR.Code, LT.Code, AD.Code, (FN.InQty-OutQty) qty, FN.IDAddress, FN.IDProduct, FN.IDLot, fn.DtCreation

FROM PCFV4.DBO.TBLFinalBalance FN, 
PCFV4.DBO.TBLProduct PR, 
PCFV4.DBO.TBLLot LT, 
PCFV4.DBO.TBLAddress AD 

WHERE FN.IDProduct = PR.IDProduct 
AND LT.IDLot = FN.IDLot 
AND AD.IDAddress = FN.IDAddress 
AND LT.Code = @LOTECLT 