/****** Object:  Procedure [export].[USP_BTX_Outstanding]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE  [export].[USP_BTX_Outstanding]
AS
BEGIN

--BATCH DETAILS

CREATE TABLE #Detail  (RecordType decimal(1,0)
 ,AccountCode varchar(15)
 ,StockCode decimal(8,2)
 ,TransactionDate decimal(10,2)
 ,TransactionNumber varchar(11)
 ,TransactionType varchar(5)
 ,OriginalQuantity decimal(13,2)
 ,OriginalAmount decimal(14,2)
 ,Quantity decimal(13,0)
 ,Price decimal(13,4)
 ,NetAmount decimal(13,4)
 ,Intererst decimal(17,4)
 ,DueDate decimal(10,0)
 ,Ageing decimal(6,0)
 ,StockName varchar(12)
 ,BranchCode decimal(3,0)
 ,Exchange varchar(5)
 ,TradedCurrency varchar(3)
 ,SettlementCurrency varchar(3)
 ,NetAmountMYR decimal(13,4)
 );
INSERT INTO #Detail(RecordType
,AccountCode
,StockCode
,TransactionDate
,TransactionNumber
,TransactionType
,OriginalQuantity
,OriginalAmount
,Quantity
,Price
,NetAmount
,Intererst
,DueDate
,Ageing
,StockName
,BranchCode
,Exchange
,TradedCurrency
,SettlementCurrency
,NetAmountMYR
)
VALUES(1 ,'AccountCode' ,1 ,1 ,'Transaction' ,'Trans' ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,1 ,'StockName' ,1 ,'Excha' ,'Tra' ,'Set' ,1 )
--BATCH TRAILER
 DECLARE @Count INT;
  SET @Count = (SELECT COUNT(*) FROM #Detail);

CREATE TABLE #Trailer  (RecordType decimal(1,0)
 ,Totalnumberofrecords decimal(6,0)
 ,ProcessingDate varchar(10)
 );
INSERT INTO #Trailer(RecordType
,Totalnumberofrecords
,ProcessingDate
)
VALUES(1 ,@Count ,'27022022' )
SELECT  RIGHT(REPLICATE('0', 1) + CAST(RecordType as varchar(1)), 1)+'|'+AccountCode+'|'+RIGHT(REPLICATE('0', 8) + CAST(StockCode as varchar(8)), 8)+'|'+RIGHT(REPLICATE('0', 10) + CAST(TransactionDate as varchar(10)), 10)+'|'+TransactionNumber+'|'+TransactionType+'|'+RIGHT(REPLICATE('0', 13) + CAST(OriginalQuantity as varchar(13)), 13)+'|'+RIGHT(REPLICATE('0', 14) + CAST(OriginalAmount as varchar(14)), 14)+'|'+RIGHT(REPLICATE('0', 13) + CAST(Quantity as varchar(13)), 13)+'|'+RIGHT(REPLICATE('0', 13) + CAST(Price as varchar(13)), 13)+'|'+RIGHT(REPLICATE('0', 13) + CAST(NetAmount as varchar(13)), 13)+'|'+RIGHT(REPLICATE('0', 17) + CAST(Intererst as varchar(17)), 17)+'|'+RIGHT(REPLICATE('0', 10) + CAST(DueDate as varchar(10)), 10)+'|'+RIGHT(REPLICATE('0', 6) + CAST(Ageing as varchar(6)), 6)+'|'+StockName+'|'+RIGHT(REPLICATE('0', 3) + CAST(BranchCode as varchar(3)), 3)+'|'+Exchange+'|'+TradedCurrency+'|'+SettlementCurrency+'|'+RIGHT(REPLICATE('0', 13) + CAST(NetAmountMYR as varchar(13)), 13)  FROM #Detail
UNION ALL

SELECT RIGHT(REPLICATE('0', 1) + CAST(RecordType as varchar(1)), 1)+'|'+RIGHT(REPLICATE('0', 6) + CAST(Totalnumberofrecords as varchar(6)), 6)+'|'+ProcessingDate  FROM #Trailer
 
DROP TABLE #Detail
DROP TABLE #Trailer
END