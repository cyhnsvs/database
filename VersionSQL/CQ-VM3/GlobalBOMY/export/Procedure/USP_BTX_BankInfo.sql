/****** Object:  Procedure [export].[USP_BTX_BankInfo]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE  [export].[USP_BTX_BankInfo]
AS
BEGIN
--BATCH HEADER

CREATE TABLE #Header  (RecordType char(1)
 ,HeaderDate date
 ,Filler1 char(3)
 ,InterfaceID char(5)
 ,Filler2 char(3)
 ,SystemID char(4)
 ,Filler3 char(186)
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
 ,ClientCode char(15)
 ,BranchCode decimal(3,0)
 ,BankName char(50)
 ,BankBranch char(100)
 ,BankAccount char(30)
 ,[Default] char(1)
 ,MCA char(1)
 ,Filler char(15)
 );
INSERT INTO #Detail(RecordType
,ClientCode
,BranchCode
,BankName
,BankBranch
,BankAccount
,[Default]
,MCA
,Filler
)
VALUES(1 ,'ClientCode' ,1 ,'BankName' ,'BankBranch' ,'BankAccount' ,'D' ,'M' ,'Filler' )
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
VALUES(1 ,@Count ,'27022022' ,1 )
SELECT RecordType+FORMAT(HeaderDate , 'ddMMyyyyhhmmss')+Filler1+InterfaceID+Filler2+SystemID+Filler3  FROM #Header
UNION ALL

SELECT RIGHT(REPLICATE('0', 1) + CAST(RecordType as varchar(1)), 1)+ClientCode+RIGHT(REPLICATE('0', 3) + CAST(BranchCode as varchar(3)), 3)+BankName+BankBranch+BankAccount+[Default]+MCA+Filler  FROM #Detail
UNION ALL

SELECT RIGHT(REPLICATE('0', 1) + CAST(RecordType as varchar(1)), 1)+RIGHT(REPLICATE('0', 6) + CAST(TrailerCount as varchar(6)), 6)+ProcessingDate+RIGHT(REPLICATE('0', 6) + CAST(BatchNumber as varchar(6)), 6)  FROM #Trailer

DROP TABLE #Header
DROP TABLE #Detail
DROP TABLE #Trailer
END