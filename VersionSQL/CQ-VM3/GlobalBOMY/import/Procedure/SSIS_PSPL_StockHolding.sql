/****** Object:  Procedure [import].[SSIS_PSPL_StockHolding]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [import].[SSIS_PSPL_StockHolding] AS 

BEGIN

INSERT INTO [import].[PSPL_StockHolding_Archive]
           ([Client Code]
           ,[Client Name]
           ,[Last Update]
           ,[Company Code]
           ,[ISIN code]
           ,[Security / Fund Name]
           ,[Stock / Unit On Hand]
           ,[Susp Qty]
           ,[Purchases Due]
           ,[Sales Due]
           ,[Outstanding Purchases]
           ,[Outstanding Sales]
           ,[Total]
           ,[Seccd]
           ,[Market]
           ,[LstDonePx]
           ,[Currcd]
           ,[AverageCost]
           ,[CurrcdAvgCost]
           ,[sourceFileName]
           ,[importDate]
		   ,[ArchiveDateTime])
    select 
			[Client Code]
           ,[Client Name]
           ,[Last Update]
           ,[Company Code]
           ,[ISIN code]
           ,[Security / Fund Name]
           ,[Stock / Unit On Hand]
           ,[Susp Qty]
           ,[Purchases Due]
           ,[Sales Due]
           ,[Outstanding Purchases]
           ,[Outstanding Sales]
           ,[Total]
           ,[Seccd]
           ,[Market]
           ,[LstDonePx]
           ,[Currcd]
           ,[AverageCost]
           ,[CurrcdAvgCost]
           ,[sourceFileName]
           ,[importDate]
		   ,GETDATE ()
	from 
		[import].[PSPL_StockHolding]

END