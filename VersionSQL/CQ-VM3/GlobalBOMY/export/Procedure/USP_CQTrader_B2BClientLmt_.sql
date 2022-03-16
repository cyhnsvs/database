﻿/****** Object:  Procedure [export].[USP_CQTrader_B2BClientLmt_]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE  [export].[USP_CQTrader_B2BClientLmt_]
AS
BEGIN

--BATCH DETAILS

CREATE TABLE #Detail  (B2BAcctNo char(20)
 ,BuyLmt decimal(21,4)
 ,SellLmt decimal(21,4)
 ,BypassLmtChk char(1)
 ,ReturnLmtChk char(1)
 ,DealerLmtChk char(1)
 );
INSERT INTO #Detail(B2BAcctNo
,BuyLmt
,SellLmt
,BypassLmtChk
,ReturnLmtChk
,DealerLmtChk
)
VALUES('B2BAcctNo' ,1 ,1 ,'1' ,'2' ,'1' )
---RESULT SET
SELECT B2BAcctNo+RIGHT(REPLICATE('0', 21) + CAST(BuyLmt as varchar(21)), 21)+RIGHT(REPLICATE('0', 21) + CAST(SellLmt as varchar(21)), 21)+BypassLmtChk+ReturnLmtChk+DealerLmtChk  FROM #Detail
 
DROP TABLE #Detail 
END