/****** Object:  Procedure [export].[USP_CQTrader_B2BClientInfo_]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE  [export].[USP_CQTrader_ClientInfo]
AS
BEGIN

--BATCH DETAILS

CREATE TABLE #Detail  (B2BAcctNo char(20)
 ,ClientName char(30)
 ,NRIC char(20)
 ,B2BDealerID char(5)
 ,BranchID char(3)
 ,BranchName char(20)
 ,AcctStatus char(1)
 ,AcctType char(5)
 ,DeleteStatus char(1)
 ,W8Ben char(1)
 );
INSERT INTO #Detail(B2BAcctNo
,ClientName
,NRIC
,B2BDealerID
,BranchID
,BranchName
,AcctStatus
,AcctType
,DeleteStatus
,W8Ben
)
VALUES('B2BAcctNo' ,'ClientName' ,'NRIC' ,'B2BDe' ,'Bra' ,'BranchName' ,'A' ,'AcctT' ,'1' ,'1' )
SELECT B2BAcctNo+ClientName+NRIC+B2BDealerID+BranchID+BranchName+AcctStatus+AcctType+DeleteStatus+W8Ben  FROM #Detail
 
  
DROP TABLE #Detail 
END