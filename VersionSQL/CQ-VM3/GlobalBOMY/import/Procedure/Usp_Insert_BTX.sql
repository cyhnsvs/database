/****** Object:  Procedure [import].[Usp_Insert_BTX]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [import].[Usp_Insert_BTX]
as

begin

DELETE FROM [import].[Tb_BTX_YYYYMMDD];


INSERT INTO [import].[Tb_BTX_YYYYMMDD]
(
 [StockExchange]
      ,[StockCode]
      ,[StockName]
      ,[StockLongName]
      ,[ISIN]
      ,[ListedOn]
      ,[Sector]
      ,[MemberOfIndices]
      ,[ShareIssued]
      ,[LotSize]
      ,[Delivery]
      ,[Currency]
      ,[IDSS]
      ,[PDT]
      ,[RSS] 
       ,[PreviousClosingPrice]
      ,[HighestPrice]
     ,[LowestPrice]
      ,[LastDonePrice]
      ,[PriceChange]
      ,[VolumeTraded]
      ,[VWAP]
      ,[StockStatus]
      ,[Entitlement]
      ,[CoversionMethod]
      ,[ConversionPeriod]
      ,[DaysToExpire]
      ,[MaturityDate]
      ,[ExercisePrice]
      ,[Gearing]
     ,[Premium]
      ,[Remarks]
      ,[MotherSharePrice] 
)
SELECT 
[StockExchange]
      ,[StockCode]
      ,[StockName]
      ,[StockLongName]
      ,[ISIN]
      ,[ListedOn]
      ,[Sector]
      ,[MemberOfIndices]
	  , CASE when  ShareIssued='-'  then '0.00' else ShareIssued end
      ,CASE when  LotSize='-'  then '0.00' else  LotSize end
      ,[Delivery]
      ,[Currency]
      ,[IDSS]
      ,[PDT]
      ,[RSS]      
	  ,PreviousClosingPrice
      ,CASE when  HighestPrice='-'  then '0.00' else  HighestPrice  end
	 ,  CASE when  LowestPrice='-'  then '0.00' else  LowestPrice  end
     ,CASE when  LastDonePrice='-'  then '0.00'  else LastDonePrice  end
     ,CASE when  PriceChange='-'  then '0.00' else  PriceChange  end
     ,CASE when  VolumeTraded='-'  then '0.00' else  VolumeTraded end
      , CASE when  VWAP='-'  then '0.00' else VWAP  end
      ,[StockStatus]
      ,[Entitlement]
      ,[CoversionMethod]
      ,[ConversionPeriod]
      ,CASE when  DaysToExpire='-'  then '0.00' else  DaysToExpire  end
      ,[MaturityDate]
      ,CASE when  ExercisePrice='-'  then '0.00' else  ExercisePrice end
     ,CASE when  Gearing='-'  then '0.00' else Gearing end
     ,[Premium]
	 ,[Remarks]
    ,     CASE when  MotherSharePrice='-'  then  '0.00' else MotherSharePrice  end
  FROM [GlobalBOMY].[import].[Tb_BTX_YYYYMMDD_Temp]

  end