/****** Object:  Procedure [export].[USP_CQTrader_B2BClientInfo]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_CQTrader_B2BClientInfo]
(
	@idteProcessDate DATE
)
/*
CLIENT INFO TO CQ TRADER
EXEC [export].[USP_CQTrader_B2BClientInfo] '2020-06-01'
*/
AS
BEGIN
	
	-- BATCH DETAILS
	CREATE TABLE #ClientInfo
	(
		 B2BAcctNo				CHAR(20)
		,ClientName				CHAR(30)
		,NRIC					CHAR(20)
		,B2BDealerID			CHAR(5)
		,BranchID				CHAR(3)
		,BranchName				CHAR(20)
		,AcctStatus				CHAR(1)
		,AcctType				CHAR(5)
		,DeleteStatus			CHAR(1)
		,W8Ben					CHAR(1)
	)

	INSERT INTO #ClientInfo
	(
		 B2BAcctNo		
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
	SELECT 
		[AccountNumber (textinput-5)],
		LEFT([CustomerName (textinput-3)],30),
		[NRIC (uploadinput-1)],
		[BFEDealerCode (textinput-26)],
		[BranchID (selectsource-1)],
		[BranchLocation (textinput-2)],
		[Tradingaccount (selectsource-31)],
		[AccountType (selectsource-7)],
		CASE WHEN [Tradingaccount (selectsource-31)] = 'C'
			 THEN 1
			 ELSE 0
		END,
		[W8BEN (multipleradiosinline-21)]
	FROM 
		CQBTempDB.export.Tb_FormData_1410 Client
	INNER JOIN 
		CQBTempDB.export.Tb_FormData_1409 Account ON Client.[CustomerID (textinput-1)] =  Account.[CustomerID (selectsource-1)]
	INNER JOIN 
		CQBTempDB.export.Tb_FormData_1377 Dealer ON Account.[DealerCode (selectsource-21)] = Dealer.[DealerCode (textinput-35)]
	INNER JOIN
		CQBTempDB.export.Tb_FormData_1374 Branch ON Dealer.[BranchID (selectsource-1)] =  Branch.[BranchID (textinput-1)]
	
	 
		
	-- RESULT SET
	SELECT 
		B2BAcctNo + ClientName + NRIC + B2BDealerID + BranchID + BranchName + AcctStatus + AcctType + DeleteStatus + W8Ben 
	FROM 
		#ClientInfo

	DROP TABLE #ClientInfo
END