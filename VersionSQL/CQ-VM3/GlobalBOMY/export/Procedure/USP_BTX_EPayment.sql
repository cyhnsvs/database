/****** Object:  Procedure [export].[USP_BTX_EPayment]    Committed by VersionSQL https://www.versionsql.com ******/

create PROCEDURE  [export].[USP_BTX_EPayment] 
AS
BEGIN
--BATCH HEADER

CREATE TABLE #Header  (RecordType char(1)
 ,HeaderDate date
 ,Filler1 char(3)
 ,InterfaceID char(5)
 ,Filler2 char(3)
 ,SystemID char(4)
 ,Filler3 char(80)
 );
INSERT INTO #Header(RecordType
,HeaderDate
,Filler1
,InterfaceID
,Filler2
,SystemID
,Filler3
)
VALUES('R' ,getdate() ,'Fil' ,'Inter' ,'Fil' ,'Syst' ,'Filler3' )
--BATCH DETAILS

CREATE TABLE #Detail  (RecordType decimal(1,0)
 ,Branchcode char(3)
 ,ClientCode char(9)
 ,EFTransactionNo decimal(20,0)
 ,TransactionType char(2)
 ,ContractNo char(11)
 ,AvailableTrustBal decimal(12,2)
 ,TransactionStatus char(5)
 ,SettlementStatus char(5)
 ,OSQuantity decimal(13,0)
 ,OSInterest decimal(17,4)
 ,OSAmount decimal(13,4)
 ,OSAmountMYR decimal(13,4)
 ,Remarks char(30)
 ,systemtime datetime
 );
INSERT INTO #Detail(RecordType
,Branchcode
,ClientCode
,EFTransactionNo
,TransactionType
,ContractNo
,AvailableTrustBal
,TransactionStatus
,SettlementStatus
,OSQuantity
,OSInterest
,OSAmount
,OSAmountMYR
,Remarks
,systemtime
)
VALUES(1 ,'Bra' ,'ClientCod' ,1 ,'Tr' ,'ContractNo' ,1 ,'Trans' ,'Settl' ,1 ,1 ,1 ,1 ,'Remarks' ,getdate() )
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
VALUES(1 ,1 ,'Processi' ,1 )
SELECT RecordType+FORMAT(HeaderDate , 'ddMMyyyyhhmmss')+Filler1+InterfaceID+Filler2+SystemID+Filler3  FROM #Header
UNION ALL

SELECT RIGHT(REPLICATE('0', 1) + CAST(RecordType as varchar(1)), 1)+Branchcode+ClientCode+RIGHT(REPLICATE('0', 20) + CAST(EFTransactionNo as varchar(20)), 20)+TransactionType+ContractNo+RIGHT(REPLICATE('0', 12) + CAST(AvailableTrustBal as varchar(12)), 12)+TransactionStatus+SettlementStatus+RIGHT(REPLICATE('0', 13) + CAST(OSQuantity as varchar(13)), 13)+RIGHT(REPLICATE('0', 17) + CAST(OSInterest as varchar(17)), 17)+RIGHT(REPLICATE('0', 13) + CAST(OSAmount as varchar(13)), 13)+RIGHT(REPLICATE('0', 13) + CAST(OSAmountMYR as varchar(13)), 13)+Remarks+FORMAT(systemtime , 'ddMMyyyyhhmmss')  FROM #Detail
UNION ALL

SELECT RIGHT(REPLICATE('0', 1) + CAST(RecordType as varchar(1)), 1)+RIGHT(REPLICATE('0', 6) + CAST(TrailerCount as varchar(6)), 6)+ProcessingDate+RIGHT(REPLICATE('0', 6) + CAST(BatchNumber as varchar(6)), 6)  FROM #Trailer

DROP TABLE #Header
DROP TABLE #Detail
DROP TABLE #Trailer
END