/****** Object:  Procedure [export].[USP_BTX_DCF]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE  [export].[USP_BTX_DCF]
AS
BEGIN
--BATCH HEADER

CREATE TABLE #Header  (RecordType CHAR(1)
 ,HeaderDate DateTime
 ,Filler1 CHAR(3)
 ,InterfaceID CHAR(10)
 ,Filler2 CHAR(3)
 ,SystemID CHAR(15)
 ,Filler3 CHAR(10)
 );
INSERT INTO #Header(RecordType
,HeaderDate
,Filler1
,InterfaceID
,Filler2
,SystemID
,Filler3
)
VALUES('R' ,getdate() ,'Fil' ,'InterfaceI' ,'Fil' ,'SystemID' ,'Filler3' )
--BATCH DETAILS

CREATE TABLE #Detail  (RecordType DECIMAL(1,0)
 ,BranchCode CHAR(3)
 ,ClientCode CHAR(10)
 ,DCFRemainingBalance DECIMAL(16,2)
 );
INSERT INTO #Detail(RecordType
,BranchCode
,ClientCode
,DCFRemainingBalance
)
VALUES(1 ,'Bra' ,'ClientCode' ,1 )
--BATCH TRAILER
 DECLARE @Count INT;
  SET @Count = (SELECT COUNT(*) FROM #Detail);

CREATE TABLE #Trailer  (RecordType DECIMAL(1,0)
 ,TrailerCount DECIMAL(6,0)
 ,ProcessingDate CHAR(10)
 );
INSERT INTO #Trailer(RecordType
,TrailerCount
,ProcessingDate
)
VALUES(1 ,@Count ,'23022022' )
SELECT RecordType+FORMAT(HeaderDate , 'ddMMyyyyhhmmss')+Filler1+InterfaceID+Filler2+SystemID+Filler3  FROM #Header
UNION ALL

SELECT RIGHT(REPLICATE('0', 1) + CAST(RecordType as varchar(1)), 1)+BranchCode+ClientCode+RIGHT(REPLICATE('0', 16) + CAST(DCFRemainingBalance as varchar(16)), 16)  FROM #Detail
UNION ALL

SELECT RIGHT(REPLICATE('0', 1) + CAST(RecordType as varchar(1)), 1)+RIGHT(REPLICATE('0', 6) + CAST(TrailerCount as varchar(6)), 6)+ProcessingDate  FROM #Trailer

DROP TABLE #Header
DROP TABLE #Detail
DROP TABLE #Trailer
END