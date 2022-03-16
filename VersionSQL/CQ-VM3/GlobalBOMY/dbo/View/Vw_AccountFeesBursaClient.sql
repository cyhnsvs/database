/****** Object:  View [dbo].[Vw_AccountFeesBursaClient]    Committed by VersionSQL https://www.versionsql.com ******/

    
    
    
    
    
    
CREATE VIEW [dbo].[Vw_AccountFeesBursaClient]    
AS    
    
select CAST(RIGHT(BillingDate,4)+'-'+RIGHT(LEFT(BillingDate,4),2)+'-'+LEFT(BillingDate,2) as date) AS BillingDate,    
  AccountNumber,    
  CAST(RIGHT(Date1,4)+'-'+RIGHT(LEFT(Date1,4),2)+'-'+LEFT(Date1,2) as date) AS ActivationDate,    
  CAST(RIGHT(Date2,4)+'-'+RIGHT(LEFT(Date2,4),2)+'-'+LEFT(Date2,2) as date) AS OpeningDormantDate,    
  CAST(LEFT(FeeAmount,9)+'.'+RIGHT(FeeAmount,2) as decimal(11,2)) AS FeeAmount,    
  CAST(LEFT(GSTRate,2)+'.'+RIGHT(GSTRate,1) as decimal(3,2)) AS GSTRate,    
  CAST(LEFT(GSTAmount,2)+'.'+RIGHT(GSTAmount,2) as decimal(4,2)) AS GSTAmount,    
  CAST(LEFT(Rebate,2)+'.'+RIGHT(Rebate,2) as decimal(4,2)) AS RebateAmount,    
  CAST(LEFT(NetAmount,9)+'.'+RIGHT(NetAmount,2) as decimal(11,2)) AS NetAmount,    
  CAST(FeeType as bigint) AS FeeType,    
  TaxInvoice,    
  Status,    
  Name    
from GlobalBOMY.import.Tb_BURSA_CFT053 AS A     
--INNER JOIN CQbTempDb.export.Tb_FormData_1409 B WITH(NOLOCK)     
-- ON A.AccountNumber = B.[CDSNo (textinput-19)]    