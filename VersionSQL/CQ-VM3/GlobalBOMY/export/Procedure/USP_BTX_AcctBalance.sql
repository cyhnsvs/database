/****** Object:  Procedure [export].[USP_BTX_AcctBalance]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE  [export].[USP_BTX_AcctBalance]
AS
BEGIN

--BATCH DETAILS

CREATE TABLE #Detail  (RecordType decimal(1,0)
 ,AccountCode  char(15)
 ,OtherOutstandingBalance decimal(14,2)
 ,TrustAmount decimal(14,2)
 ,BranchCode  char(3)
 ,Currency  char(3)
 ,AvailableTrustAmount decimal(14,2)
 ,FloatAmount decimal(14,2)
 );
INSERT INTO #Detail(RecordType
,AccountCode
,OtherOutstandingBalance
,TrustAmount
,BranchCode
,Currency
,AvailableTrustAmount
,FloatAmount
)
VALUES(1 ,'Acco' ,1 ,1 ,'001' ,'SGD' ,1 ,1 )
--BATCH TRAILER
 DECLARE @Count INT;
  SET @Count = (SELECT COUNT(*) FROM #Detail);

CREATE TABLE #Trailer  (RecordType decimal(1,0)
 ,Totalnumberofrecords decimal(6,0)
 ,ProcessingDate varchar(10)
 );
INSERT INTO #Trailer(RecordType
,Totalnumberofrecords
,ProcessingDate
)
VALUES(1 ,@Count ,'27022022' )
SELECT  RIGHT(REPLICATE('0', 1) + CAST(RecordType as varchar(1)), 1)+'|'+
	AccountCode+'|'+RIGHT(REPLICATE('0', 14) + CAST(OtherOutstandingBalance as varchar(14)), 14)+'|'+
	RIGHT(REPLICATE('0', 14) + CAST(TrustAmount as varchar(14)), 14)+'|'+ 
	BranchCode  +'|'+Currency+'|'+ RIGHT(REPLICATE('0', 14) + CAST(AvailableTrustAmount as varchar(14)), 14)+'|'+
	RIGHT(REPLICATE('0', 14) + CAST(FloatAmount as varchar(14)), 14)  FROM #Detail
UNION ALL

SELECT  RIGHT(REPLICATE('0', 1) + CAST(RecordType as varchar(1)), 1)+'|'+
		RIGHT(REPLICATE('0', 6) + CAST(Totalnumberofrecords as varchar(6)), 6)+'|'+
		ProcessingDate  FROM #Trailer
 
DROP TABLE #Detail
DROP TABLE #Trailer
END