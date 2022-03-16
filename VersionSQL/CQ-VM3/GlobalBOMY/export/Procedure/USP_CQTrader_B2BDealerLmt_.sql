/****** Object:  Procedure [export].[USP_CQTrader_B2BDealerLmt_]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE  [export].[USP_CQTrader_B2BDealerLmt_]
AS
BEGIN

--BATCH DETAILS

CREATE TABLE #Detail  (B2BDealerID char(5)
 ,BuyLmt decimal(21,4)
 ,SellLmt decimal(21,4)
 ,BypassLmtChk char(1)
 );
INSERT INTO #Detail(B2BDealerID
,BuyLmt
,SellLmt
,BypassLmtChk
)
VALUES('B2BDe' ,1 ,1 ,'1' )
---RESULT SET
SELECT B2BDealerID+RIGHT(REPLICATE('0', 21) + CAST(BuyLmt as varchar(21)), 21)+
RIGHT(REPLICATE('0', 21) + CAST(SellLmt as varchar(21)), 21)+
BypassLmtChk  FROM #Detail
 
DROP TABLE #Detail 
END