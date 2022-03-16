/****** Object:  Procedure [export].[USP_SunGard_Pmo]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE  [export].[USP_SunGard_Pmo]
AS
BEGIN

--BATCH DETAILS

CREATE TABLE #Detail  (Line char(50)
 ,Path char(50)
 ,Userid char(50)
 ,Client char(50)
 ,ExchangeMarket char(50)
 ,OrderType char(50)
 ,FilterName char(50)
 ,OrderType2 char(50)
 ,TradingPhase char(50)
 );
INSERT INTO #Detail(Line
,Path
,Userid
,Client
,ExchangeMarket
,OrderType
,FilterName
,OrderType2
,TradingPhase
)
VALUES('Line' ,'Path' ,'Userid' ,'Client' ,'ExchangeMarket' ,'OrderType' ,'FilterName' ,'OrderType2' ,'TradingPhase' )
---RESULT SET
SELECT Line+Path+Userid+Client+ExchangeMarket+OrderType+FilterName+OrderType2+TradingPhase  FROM #Detail
 

 
DROP TABLE #Detail 
END