/****** Object:  Procedure [export].[USP_SunGard_SpecificFilter]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE  [export].[USP_SunGard_SpecificFilter]
AS
BEGIN

--BATCH DETAILS

CREATE TABLE #Detail  (Line char(50)
 ,Path char(50)
 ,Name char(50)
 ,Exchange char(50)
 ,Market char(50)
 ,Value char(50)
 ,Status char(50)
 ,FilterName char(50)
 );
INSERT INTO #Detail(Line
,Path
,Name
,Exchange
,Market
,Value
,Status
,FilterName
)
VALUES('Line' ,'Path' ,'Name' ,'Exchange' ,'Market' ,'Value' ,'Status' ,'FilterName' )
---RESULT SET
SELECT Line+Path+Name+Exchange+Market+Value+Status+FilterName  FROM #Detail
   
DROP TABLE #Detail 
END