/****** Object:  Procedure [export].[USP_BTX_btxcurr_]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE  [export].[USP_BTX_btxcurr_]
AS
BEGIN
--BATCH HEADER

CREATE TABLE #Header  (RecordType char(1)
 ,HeaderDate date
 ,Filler1 char(3)
 ,InterfaceID char(6)
 ,Filler2 char(3)
 ,SystemID char(4)
 ,Filler3 char(20)
 );
INSERT INTO #Header(RecordType
,HeaderDate
,Filler1
,InterfaceID
,Filler2
,SystemID
,Filler3
)
VALUES('H' ,getdate() ,'Fil' ,'btxeff' ,'Fil' ,'BOS' ,'Filler3' )
--BATCH DETAILS

CREATE TABLE #Detail  (RecordType decimal(1,0)
 ,CurrencyCode char(5)
 ,BuyRate decimal(11,8)
 ,SellRate decimal(11,8)
 );
INSERT INTO #Detail(RecordType
,CurrencyCode
,BuyRate
,SellRate
)
VALUES(1 ,'Curre' ,1 ,1 )
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

SELECT RIGHT(REPLICATE('0', 1) + CAST(RecordType as varchar(1)), 1)+CurrencyCode+RIGHT(REPLICATE('0', 11) + CAST(BuyRate as varchar(11)), 11)+RIGHT(REPLICATE('0', 11) + CAST(SellRate as varchar(11)), 11)  FROM #Detail
UNION ALL

SELECT RIGHT(REPLICATE('0', 1) + CAST(RecordType as varchar(1)), 1)+RIGHT(REPLICATE('0', 6) + CAST(Totalnumberofrecords as varchar(6)), 6)+ProcessingDate+RIGHT(REPLICATE('0', 6) + CAST(BatchNumber as varchar(6)), 6)  FROM #Trailer

DROP TABLE #Header
DROP TABLE #Detail
DROP TABLE #Trailer
END