/****** Object:  Procedure [export].[USP_BTX_DailyBusinessDone]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE  [export].[USP_BTX_DailyBusinessDone]
AS
BEGIN

--BATCH DETAILS

CREATE TABLE #Detail  (RecordType decimal(1,0)
 ,ClientCode  char(20)
 ,Branchcode char(5)
 ,TransactionType char(5)
 ,PurchaseSell char(1)
 ,ContDocNo char(20)
 ,TransactionDate char(10)
 ,TransactionAmount decimal(20,2)
 ,TransactionQty decimal(9,0)
 ,StockCode char(8)
 ,MatchedPrice decimal(15,6)
 ,RemisierID char(3)
 ,NetAmount decimal(20,2)
 ,Brokerage decimal(20,2)
 ,StampDuty decimal(20,2)
 ,ClearingFee decimal(20,2)
 ,ExchangeRate decimal(20,6)
 ,Currency char(3)
 ,ForeignPrice decimal(20,6)
 ,ForeignContractValue decimal(20,2)
 ,OtherAmount decimal(20,2)
 ,StockName char(12)
 ,ExchangeCode char(10)
 ,AmountBeforeGST decimal(20,2)
 ,GSTonSupplies decimal(20,2)
 );
INSERT INTO #Detail(RecordType
,ClientCode
,Branchcode
,TransactionType
,PurchaseSell
,ContDocNo
,TransactionDate
,TransactionAmount
,TransactionQty
,StockCode
,MatchedPrice
,RemisierID
,NetAmount
,Brokerage
,StampDuty
,ClearingFee
,ExchangeRate
,Currency
,ForeignPrice
,ForeignContractValue
,OtherAmount
,StockName
,ExchangeCode
,AmountBeforeGST
,GSTonSupplies
)
VALUES(1 ,'ClientCode' ,'Branc' ,'Trans' ,'P' ,'ContDocNo' ,'Transactio' ,1 ,1 ,'StockCod' ,1 ,'Rem' ,1 ,1 ,1 ,1 ,1 ,'Cur' ,1 ,1 ,1 ,'StockName' ,'ExchangeCo' ,1 ,1 )
--BATCH TRAILER
 DECLARE @Count INT;
  SET @Count = (SELECT COUNT(*) FROM #Detail);

CREATE TABLE #Trailer  (RecordType decimal(1,0)
 ,TrailerCount decimal(12,0)
 ,ProcessingDate varchar(10)
 );
INSERT INTO #Trailer(RecordType
,TrailerCount
,ProcessingDate
)
VALUES(1 ,@Count ,'27022022' )
SELECT  RIGHT(REPLICATE('0', 1) + CAST(RecordType as varchar(1)), 1)+'|'+ClientCode+'|'+Branchcode+'|'+TransactionType+'|'+PurchaseSell+'|'+ContDocNo+'|'+TransactionDate+'|'+RIGHT(REPLICATE('0', 20) + CAST(TransactionAmount as varchar(20)), 20)+'|'+RIGHT(REPLICATE('0', 9) + CAST(TransactionQty as varchar(9)), 9)+'|'+StockCode+'|'+RIGHT(REPLICATE('0', 15) + CAST(MatchedPrice as varchar(15)), 15)+'|'+RemisierID+'|'+RIGHT(REPLICATE('0', 20) + CAST(NetAmount as varchar(20)), 20)+'|'+RIGHT(REPLICATE('0', 20) + CAST(Brokerage as varchar(20)), 20)+'|'+RIGHT(REPLICATE('0', 20) + CAST(StampDuty as varchar(20)), 20)+'|'+RIGHT(REPLICATE('0', 20) + CAST(ClearingFee as varchar(20)), 20)+'|'+RIGHT(REPLICATE('0', 20) + CAST(ExchangeRate as varchar(20)), 20)+'|'+Currency+'|'+RIGHT(REPLICATE('0', 20) + CAST(ForeignPrice as varchar(20)), 20)+'|'+RIGHT(REPLICATE('0', 20) + CAST(ForeignContractValue as varchar(20)), 20)+'|'+RIGHT(REPLICATE('0', 20) + CAST(OtherAmount as varchar(20)), 20)+'|'+StockName+'|'+ExchangeCode+'|'+RIGHT(REPLICATE('0', 20) + CAST(AmountBeforeGST as varchar(20)), 20)+'|'+RIGHT(REPLICATE('0', 20) + CAST(GSTonSupplies as varchar(20)), 20)  FROM #Detail
UNION ALL

SELECT  RIGHT(REPLICATE('0', 1) + CAST(RecordType as varchar(1)), 1)+'|'+RIGHT(REPLICATE('0', 12) + CAST(TrailerCount as varchar(12)), 12)+'|'+ProcessingDate  FROM #Trailer
 
DROP TABLE #Detail
DROP TABLE #Trailer
END