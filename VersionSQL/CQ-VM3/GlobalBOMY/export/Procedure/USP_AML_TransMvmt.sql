/****** Object:  Procedure [export].[USP_AML_TransMvmt]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE  [export].[USP_AML_TransMvmt]
AS
BEGIN

--BATCH DETAILS

CREATE TABLE #Detail  (RecordType decimal(1,0)
 ,ClientCode char(9)
 ,DealerCode char(5)
 ,Branchcode char(3)
 ,PrincipalTransactionNo char(11)
 ,TransactionReferenceNo char(11)
 ,TransactionDescription char(50)
 ,ListingSequenceNo char(3)
 ,MovementSequenceNo char(3)
 ,TransactionReferenceType char(3)
 ,PrincipalTransactionType char(5)
 ,TransactionDate decimal(8,0)
 ,TransactionTimestamp decimal(17,0)
 ,Price decimal(14,0)
 ,Quantity decimal(9,0)
 ,Currency char(3)
 ,ExchangeRate decimal(10,0)
 ,ForeignAmount decimal(13,0)
 ,Debit decimal(13,0)
 ,Credit decimal(13,0)
 ,OverdueInterest decimal(15,0)
 ,MarginIndicator char(1)
 ,TransactionMethod char(1)
 ,ThirdPartyName char(50)
 ,ThirdPartyRelationship char(30)
 ,ChequeNumber char(6)
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
,TransactionTimestamp
,Price
,Quantity
,Currency
,ExchangeRate
,ForeignAmount
,Debit
,Credit
,OverdueInterest
,MarginIndicator
,TransactionMethod
,ThirdPartyName
,ThirdPartyRelationship
,ChequeNumber
)
VALUES(1 ,'ClientCod' ,'Deale' ,'Bra' ,'PrincipalTr' ,'Transaction' ,'TransactionDescription' ,'Lis' ,'Mov' ,'Tra' ,'Princ' ,1 ,1 ,1 ,1 ,'Cur' ,1 ,1 ,1 ,1 ,1 ,'M' ,'T' ,'ThirdPartyName' ,'ThirdPartyRelationship' ,'Cheque' )
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
VALUES(1 ,@Count ,'16-02-2022' )
---RESULT SET
SELECT  RIGHT(REPLICATE('0', 1) + CAST(RecordType as varchar(1)), 1)+'|'+ClientCode+'|'+DealerCode+'|'+Branchcode+'|'+PrincipalTransactionNo+'|'+TransactionReferenceNo+'|'+TransactionDescription+'|'+ListingSequenceNo+'|'+MovementSequenceNo+'|'+TransactionReferenceType+'|'+PrincipalTransactionType+'|'+RIGHT(REPLICATE('0', 8) + CAST(TransactionDate as varchar(8)), 8)+'|'+RIGHT(REPLICATE('0', 17) + CAST(TransactionTimestamp as varchar(17)), 17)+'|'+RIGHT(REPLICATE('0', 14) + CAST(Price as varchar(14)), 14)+'|'+RIGHT(REPLICATE('0', 9) + CAST(Quantity as varchar(9)), 9)+'|'+Currency+'|'+RIGHT(REPLICATE('0', 10) + CAST(ExchangeRate as varchar(10)), 10)+'|'+RIGHT(REPLICATE('0', 13) + CAST(ForeignAmount as varchar(13)), 13)+'|'+RIGHT(REPLICATE('0', 13) + CAST(Debit as varchar(13)), 13)+'|'+RIGHT(REPLICATE('0', 13) + CAST(Credit as varchar(13)), 13)+'|'+RIGHT(REPLICATE('0', 15) + CAST(OverdueInterest as varchar(15)), 15)+'|'+MarginIndicator+'|'+TransactionMethod+'|'+ThirdPartyName+'|'+ThirdPartyRelationship+'|'+ChequeNumber  FROM #Detail
UNION ALL

---RESULT SET
SELECT RIGHT(REPLICATE('0', 1) + CAST(RecordType as varchar(1)), 1)+'|'+RIGHT(REPLICATE('0', 6) + CAST(Totalnumberofrecords as varchar(6)), 6)+'|'+ProcessingDate  FROM #Trailer
 
DROP TABLE #Detail
DROP TABLE #Trailer
END