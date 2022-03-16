/****** Object:  Procedure [export].[USP_BTX_btxauthALL]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE  [export].[USP_BTX_btxauthALL]
AS
BEGIN
--BATCH HEADER

CREATE TABLE #Header  (RecordType char(1)
 ,HeaderDate date
 ,Filler1 char(3)
 ,InterfaceID char(5)
 ,Filler2 char(3)
 ,SystemID char(4)
 ,Filler3 char(48)
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

CREATE TABLE #Detail  (CDSNo decimal(10,0)
 ,BranchCode decimal(4,0)
 ,PortfolioAuthorizationIndicator varchar(2)
 ,PortfolioAuthorizationRegistrationDate datetime
 );
INSERT INTO #Detail(CDSNo
,BranchCode
,PortfolioAuthorizationIndicator
,PortfolioAuthorizationRegistrationDate
)
VALUES(1 ,1 ,'Po' ,getdate() )
--BATCH TRAILER
 DECLARE @Count INT;
  SET @Count = (SELECT COUNT(*) FROM #Detail);

CREATE TABLE #Trailer  (RecordType decimal(1,0)
 ,Totalnumberofrecords decimal(6,0)
 ,ProcessingDate char(8)
 ,BatchNumber decimal(4,0)
 );
INSERT INTO #Trailer(RecordType
,Totalnumberofrecords
,ProcessingDate
,BatchNumber
)
VALUES(1 ,@Count ,'27022022' ,1 )
SELECT RecordType+FORMAT(HeaderDate , 'ddMMyyyyhhmmss')+Filler1+InterfaceID+Filler2+SystemID+Filler3  FROM #Header
UNION ALL

SELECT  RIGHT(REPLICATE('0', 10) + CAST(CDSNo as varchar(10)), 10)+'|'+RIGHT(REPLICATE('0', 4) + CAST(BranchCode as varchar(4)), 4)+'|'+PortfolioAuthorizationIndicator+'|'+FORMAT(PortfolioAuthorizationRegistrationDate , 'ddMMyyyyhhmmss')  FROM #Detail
UNION ALL

SELECT RIGHT(REPLICATE('0', 1) + CAST(RecordType as varchar(1)), 1)+RIGHT(REPLICATE('0', 6) + CAST(Totalnumberofrecords as varchar(6)), 6)+ProcessingDate+RIGHT(REPLICATE('0', 4) + CAST(BatchNumber as varchar(4)), 4)  FROM #Trailer

DROP TABLE #Header
DROP TABLE #Detail
DROP TABLE #Trailer
END