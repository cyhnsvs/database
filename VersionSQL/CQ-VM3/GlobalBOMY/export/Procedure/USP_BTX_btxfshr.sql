/****** Object:  Procedure [export].[USP_BTX_btxfshr]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE  [export].[USP_BTX_btxfshr]
AS
BEGIN
--BATCH HEADER

CREATE TABLE #Header  (RecordType char(1)
 ,HeaderDate date
 ,Filler1 char(3)
 ,InterfaceID char(10)
 ,Filler2 char(3)
 ,SystemID char(15)
 ,Filler3 char(30)
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

CREATE TABLE #Detail  (RecordType decimal(1,0)
 ,BranchCode decimal(3,0)
 ,AccountCode char(15)
 ,ExchangeCode char(10)
 ,StockCode char(10)
 ,OpeningFreeQty decimal(13,0)
 ,OpeningPurchaseQty decimal(13,0)
 ,OpeningSalesQty decimal(13,0)
 );
INSERT INTO #Detail(RecordType
,BranchCode
,AccountCode
,ExchangeCode
,StockCode
,OpeningFreeQty
,OpeningPurchaseQty
,OpeningSalesQty
)
VALUES(1 ,1 ,'AccountCode' ,'ExchangeCo' ,'StockCode' ,1 ,1 ,1 )
--BATCH TRAILER
 DECLARE @Count INT;
  SET @Count = (SELECT COUNT(*) FROM #Detail);

CREATE TABLE #Trailer  (RecordType decimal(1,0)
 ,Totalnumberofrecords decimal(7,0)
 ,ProcessingDate char(8)
 ,BatchNumber decimal(7,0)
 ,Filler char(57)
 );
INSERT INTO #Trailer(RecordType
,Totalnumberofrecords
,ProcessingDate
,BatchNumber
,Filler
)
VALUES(1 ,@Count ,'23022022' ,1 ,'Filler' )
SELECT RecordType+FORMAT(HeaderDate , 'ddMMyyyyhhmmss')+Filler1+InterfaceID+Filler2+SystemID+Filler3  FROM #Header
UNION ALL

SELECT RIGHT(REPLICATE('0', 1) + CAST(RecordType as varchar(1)), 1)+RIGHT(REPLICATE('0', 3) + CAST(BranchCode as varchar(3)), 3)+AccountCode+ExchangeCode+StockCode+RIGHT(REPLICATE('0', 13) + CAST(OpeningFreeQty as varchar(13)), 13)+RIGHT(REPLICATE('0', 13) + CAST(OpeningPurchaseQty as varchar(13)), 13)+RIGHT(REPLICATE('0', 13) + CAST(OpeningSalesQty as varchar(13)), 13)  FROM #Detail
UNION ALL

SELECT RIGHT(REPLICATE('0', 1) + CAST(RecordType as varchar(1)), 1)+RIGHT(REPLICATE('0', 7) + CAST(Totalnumberofrecords as varchar(7)), 7)+ProcessingDate+RIGHT(REPLICATE('0', 7) + CAST(BatchNumber as varchar(7)), 7)+Filler  FROM #Trailer

DROP TABLE #Header
DROP TABLE #Detail
DROP TABLE #Trailer
END