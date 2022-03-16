/****** Object:  View [dbo].[Vw_HouseStockBalance]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[vW_HouseStockBalance]
AS
select 
	A.CompanyId,
	AcctNo,
	InstrumentCd = SUBSTRING(B.InstrumentCd,0,CHARINDEX('.',B.InstrumentCd)) ,
	A.Balance
from 
	GlobalBO.holdings.Tb_CustodyAssets A
	inner join GlobalBO.setup.Tb_Instrument B on  A.CompanyId = B.CompanyId and  A.InstrumentId = B.InstrumentId