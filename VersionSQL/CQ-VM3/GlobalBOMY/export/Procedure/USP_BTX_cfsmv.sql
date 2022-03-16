/****** Object:  Procedure [export].[USP_BTX_cfsmv]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE  [export].[USP_BTX_cfsmv]
AS
BEGIN
--BATCH HEADER

CREATE TABLE #Header  (RecordType char(1)
 ,HeaderDate date
 ,Filler1 char(3)
 ,InterfaceID char(5)
 ,Filler2 char(3)
 ,SystemID char(4)
 ,Filler3 char(22)
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
 ,BranchCode decimal(3,0)
 ,ClientCode char(15)
 ,ExchangeCode char(10)
 ,StockCode char(10)
 ,ShareMovement decimal(13,0)
 ,TransactionType char(3)
 ,ReferenceNo char(20)
 );
INSERT INTO #Detail(RecordType
,BranchCode
,ClientCode
,ExchangeCode
,StockCode
,ShareMovement
,TransactionType
,ReferenceNo
)
VALUES(1 ,1 ,'ClientCode' ,'ExchangeCo' ,'StockCode' ,1 ,'Tra' ,'ReferenceNo' )
--BATCH TRAILER
 DECLARE @Count INT;
  SET @Count = (SELECT COUNT(*) FROM #Detail);

CREATE TABLE #Trailer  (RecordType decimal(1,0)
 ,Totalnumberofrecords decimal(6,0)
 ,ProcessingDate char(8)
 ,BatchNumber decimal(6,0)
 );
INSERT INTO #Trailer(RecordType
,Totalnumberofrecords
,ProcessingDate
,BatchNumber
)
VALUES(1 ,@Count ,'23022022' ,1 )
SELECT RecordType+FORMAT(HeaderDate , 'ddMMyyyyhhmmss')+Filler1+InterfaceID+Filler2+SystemID+Filler3  FROM #Header
UNION ALL

SELECT RIGHT(REPLICATE('0', 1) + CAST(RecordType as varchar(1)), 1)+RIGHT(REPLICATE('0', 3) + CAST(BranchCode as varchar(3)), 3)+ClientCode+ExchangeCode+StockCode+RIGHT(REPLICATE('0', 13) + CAST(ShareMovement as varchar(13)), 13)+TransactionType+TransactionType  FROM #Detail
UNION ALL

SELECT RIGHT(REPLICATE('0', 1) + CAST(RecordType as varchar(1)), 1)+RIGHT(REPLICATE('0', 6) + CAST(Totalnumberofrecords as varchar(6)), 6)+ProcessingDate+RIGHT(REPLICATE('0', 6) + CAST(BatchNumber as varchar(6)), 6)  FROM #Trailer

DROP TABLE #Header
DROP TABLE #Detail
DROP TABLE #Trailer
END