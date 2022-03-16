/****** Object:  Procedure [export].[USP_BTX_TransMvmt]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE  [export].[USP_BTX_TransMvmt]
AS
BEGIN

--BATCH DETAILS

CREATE TABLE #Detail  (RecordType decimal(1,0)
 ,ClientCode varchar(9)
 ,DealerCode varchar(5)
 ,Branchcode varchar(3)
 ,PrincipalTransactionNo varchar(11)
 ,TransactionReferenceNo varchar(11)
 ,TransactionDescription varchar(50)
 ,ListingSequenceNo varchar(3)
 ,MovementSequenceNo varchar(3)
 ,TransactionReferenceType varchar(3)
 ,PrincipalTransactionType varchar(5)
 ,TransactionDate decimal(8,0)
 ,TansactionTimestamp decimal(17,0)
 ,Price decimal(14,6)
 ,Quantity decimal(9,0)
 ,Currency varchar(3)
 ,ExchangeRate decimal(10,6)
 ,ForeignAmount decimal(13,2)
 ,Debit decimal(13,2)
 ,Credit decimal(13,2)
 ,OverdueInterest decimal(15,6)
 );
INSERT INTO #Detail(RecordType
,ClientCode
,DealerCode
,Branchcode
,PrincipalTransactionNo
,TransactionReferenceNo
,TransactionDescription
,ListingSequenceNo
,MovementSequenceNo
,TransactionReferenceType
,PrincipalTransactionType
,TransactionDate
,TansactionTimestamp
,Price
,Quantity
,Currency
,ExchangeRate
,ForeignAmount
,Debit
,Credit
,OverdueInterest
)
VALUES(1 ,'ClientCod' ,'Deale' ,'Bra' ,'PrincipalTr' ,'Transaction' ,'TransactionDescription' ,'Lis' ,'Mov' ,'Tra' ,'Princ' ,1 ,1 ,1 ,1 ,'Cur' ,1 ,1 ,1 ,1 ,1 )
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
SELECT  RIGHT(REPLICATE('0', 1) + CAST(RecordType as varchar(1)), 1)+'|'+ClientCode+'|'+DealerCode+'|'+Branchcode+'|'+Branchcode+'|'+TransactionReferenceNo+'|'+TransactionDescription+'|'+ListingSequenceNo+'|'+MovementSequenceNo+'|'+TransactionReferenceType+'|'+PrincipalTransactionType+'|'+RIGHT(REPLICATE('0', 8) + CAST(TransactionDate as varchar(8)), 8)+'|'+RIGHT(REPLICATE('0', 17) + CAST(TansactionTimestamp as varchar(17)), 17)+'|'+RIGHT(REPLICATE('0', 14) + CAST(Price as varchar(14)), 14)+'|'+RIGHT(REPLICATE('0', 9) + CAST(Quantity as varchar(9)), 9)+'|'+Currency+'|'+RIGHT(REPLICATE('0', 10) + CAST(ExchangeRate as varchar(10)), 10)+'|'+RIGHT(REPLICATE('0', 13) + CAST(ForeignAmount as varchar(13)), 13)+'|'+RIGHT(REPLICATE('0', 13) + CAST(Debit as varchar(13)), 13)+'|'+RIGHT(REPLICATE('0', 13) + CAST(Credit as varchar(13)), 13)+'|'+RIGHT(REPLICATE('0', 15) + CAST(OverdueInterest as varchar(15)), 15)  FROM #Detail
UNION ALL

SELECT  RIGHT(REPLICATE('0', 1) + CAST(RecordType as varchar(1)), 1)+'|'+RIGHT(REPLICATE('0', 6) + CAST(Totalnumberofrecords as varchar(6)), 6)+'|'+ProcessingDate  FROM #Trailer
 
DROP TABLE #Detail
DROP TABLE #Trailer
END