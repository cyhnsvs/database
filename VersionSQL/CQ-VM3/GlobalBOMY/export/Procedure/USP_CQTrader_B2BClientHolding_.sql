/****** Object:  Procedure [export].[USP_CQTrader_B2BClientHolding_]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE  [export].[USP_CQTrader_ClientHolding]
AS
BEGIN

--BATCH DETAILS

CREATE TABLE #Detail  (B2BAcctNo char(20)
 ,Market char(2)
 ,CompanyCode char(10)
 ,Quantity char(11)
 ,SecurityCode char(4)
 );
INSERT INTO #Detail(B2BAcctNo
,Market
,CompanyCode
,Quantity
,SecurityCode
)
VALUES('B2BAcctNo' ,'SG' ,'CompanyCod' ,'12' ,'Secu' )

	-- RESULT SET
SELECT B2BAcctNo+Market+CompanyCode+Quantity+SecurityCode  FROM #Detail
 
  
DROP TABLE #Detail 
END