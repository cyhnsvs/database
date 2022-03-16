/****** Object:  Procedure [export].[USP_AML_DailyBusinessDone]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE  [export].[USP_AML_DailyBusinessDone]
AS
BEGIN

--BATCH DETAILS

CREATE TABLE #Detail  (
  RecordType decimal(1,0)
 ,ClientCode char(9)
 ,Branchcode char(3)
 ,TransactionType char(3)
 ,PurchaseSell char(1)
 ,ContDocNo char(11)
 ,TransactionDate char(10)
 ,TransactionAmount decimal(14,2)
 ,TransactionQty decimal(10,0)
 ,StockCode char(10)
 ,MatchedPrice decimal(17,6)
 ,RemisierID char(5)
 ,NetAmount decimal(14,2)
 ,Brokerage decimal(11,2)
 ,StampDuty decimal(10,2)
 ,ClearingFee decimal(10,2)
 ,ExchangeRate decimal(11,6)
 ,Currency char(3)
 ,ForeignPrice decimal(17,6)
 ,ForeignContractValue decimal(14,2)
 ,OtherAmount decimal(10,2)
 ,StockName char(16)
 ,ExchangeCode char(10)
 ,AmountBeforeGST decimal(14,2)
 ,GSTonSupplies decimal(14,2)
 ,MarginIndicator char(1)
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
,MarginIndicator
)
VALUES(1 ,'ClientCod' ,'Bra' ,'Tra' ,'P' ,'ContDocNo' ,'Transactio' ,1 ,1 ,'StockCode' ,1 ,'Remis' ,1 ,1 ,1 ,1 ,1 ,'Cur' ,1 ,1 ,1 ,'StockName' ,'ExchangeCo' ,1 ,1 ,'M' )
--BATCH TRAILER
 DECLARE @Count INT;
  SET @Count = (SELECT COUNT(*) FROM #Detail);

CREATE TABLE #Trailer  (RecordType decimal(1,0)
 ,TrailerCount decimal(6,0)
 ,ProcessingDate char(8)
 ,BatchNumber decimal(6,0)
 );
INSERT INTO #Trailer(RecordType
,TrailerCount
,ProcessingDate
,BatchNumber
)
VALUES(1 ,@Count ,'16022022' ,1 )
---RESULT SET
SELECT RIGHT(REPLICATE('0', 1) + CAST(RecordType as varchar(1)), 1)+'|'+ClientCode+'|'+Branchcode+'|'+
TransactionType+'|'+PurchaseSell+'|'+ContDocNo+'|'+TransactionDate+'|'+RIGHT(REPLICATE('0', 14) + 
CAST(TransactionAmount as varchar(14)), 14)+'|'+RIGHT(REPLICATE('0', 10) + 
CAST(TransactionQty as varchar(10)), 10)+'|'+StockCode+'|'+RIGHT(REPLICATE('0', 17) + 
CAST(MatchedPrice as varchar(17)), 17)+'|'+RemisierID+'|'+RIGHT(REPLICATE('0', 14) + 
CAST(NetAmount as varchar(14)), 14)+'|'+RIGHT(REPLICATE('0', 11) + 
CAST(Brokerage as varchar(11)), 11)+'|'+RIGHT(REPLICATE('0', 10) + 
CAST(StampDuty as varchar(10)), 10)+'|'+RIGHT(REPLICATE('0', 10) + 
CAST(ClearingFee as varchar(10)), 10)+'|'+RIGHT(REPLICATE('0', 11) + 
CAST(ExchangeRate as varchar(11)), 11)+'|'+Currency+'|'+RIGHT(REPLICATE('0', 17) + 
CAST(ForeignPrice as varchar(17)), 17)+'|'+RIGHT(REPLICATE('0', 14) + 
CAST(ForeignContractValue as varchar(14)), 14)+'|'+RIGHT(REPLICATE('0', 10) + 
CAST(OtherAmount as varchar(10)), 10)+'|'+StockName+'|'+ExchangeCode+'|'+RIGHT(REPLICATE('0', 14) + 
CAST(AmountBeforeGST as varchar(14)), 14)+'|'+RIGHT(REPLICATE('0', 14) +
CAST(GSTonSupplies as varchar(14)), 14)+'|'+MarginIndicator  FROM #Detail
UNION ALL

---RESULT SET
SELECT RIGHT(REPLICATE('0', 1) + CAST(RecordType as varchar(1)), 1)+'|'+RIGHT(REPLICATE('0', 6) +
CAST(TrailerCount as varchar(6)), 6)+'|'+ProcessingDate+'|'+RIGHT(REPLICATE('0', 6) + CAST(BatchNumber as varchar(6)), 6)  FROM #Trailer
 
DROP TABLE #Detail
DROP TABLE #Trailer
END