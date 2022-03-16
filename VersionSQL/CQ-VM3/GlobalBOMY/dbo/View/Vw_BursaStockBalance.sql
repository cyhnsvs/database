/****** Object:  View [dbo].[Vw_BursaStockBalance]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[vW_BursaStockBalance]
AS
select
	AccountNumber = B.[AccountNumber (textinput-5)],
	CDSNo = B.[CDSNo (textinput-19)],
	StockCode,
	A.FreeBalance
from
	GlobalBOMY.import.Tb_BURSA_CFT003 A
	INNER JOIN CQbTempDb.export.Tb_FormData_1409 B WITH(NOLOCK) ON A.AcctNo = B.[CDSNo (textinput-19)]