/****** Object:  Procedure [export].[USP_BTX_ClntChangeBranch]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE  [export].[USP_BTX_ClntChangeBranch]
AS
BEGIN
--BATCH HEADER

CREATE TABLE #Header  (RecordType char(1)
 ,HeaderDate date
 ,Filler1 char(3)
 ,InterfaceID char(5)
 ,Filler2 char(3)
 ,SystemID char(4)
 ,Filler3 char(15)
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
 ,AccountCode char(15)
 ,OldBranchCode char(3)
 ,NewBranchCode char(3)
 ,DealerID decimal(5,0)
 ,Filler char(19)
 );
INSERT INTO #Detail(RecordType
,AccountCode
,OldBranchCode
,NewBranchCode
,DealerID
,Filler
)
VALUES(1 ,'AccountCode' ,'Old' ,'New' ,1 ,'Filler' )
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
VALUES(1 ,@Count ,'24022022' ,1 )
SELECT RecordType+FORMAT(HeaderDate , 'ddMMyyyyhhmmss')+Filler1+InterfaceID+Filler2+SystemID+Filler3  FROM #Header
UNION ALL

SELECT RIGHT(REPLICATE('0', 1) + CAST(RecordType as varchar(1)), 1)+AccountCode+OldBranchCode+NewBranchCode+RIGHT(REPLICATE('0', 5) + CAST(DealerID as varchar(5)), 5)+Filler  FROM #Detail
UNION ALL

SELECT RIGHT(REPLICATE('0', 1) + CAST(RecordType as varchar(1)), 1)+RIGHT(REPLICATE('0', 6) + CAST(TrailerCount as varchar(6)), 6)+ProcessingDate+RIGHT(REPLICATE('0', 6) + CAST(BatchNumber as varchar(6)), 6)  FROM #Trailer

DROP TABLE #Header
DROP TABLE #Detail
DROP TABLE #Trailer
END