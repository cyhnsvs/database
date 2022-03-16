/****** Object:  Procedure [export].[USP_ORMS_EIS_CLTMAS]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_ORMS_EIS_CLTMAS]
(
	@idteProcessDate DATE
)
AS
/*
Client Master
EXEC [export].[USP_ORMS_EIS_CLTMAS] '2020-06-01'
*/
BEGIN
	CREATE TABLE #Detail
	(
		 RecordType			VARCHAR(1)			
		,BranchCode			VARCHAR(2)
		,DealerCode			VARCHAR(4)
		,AccountNo			VARCHAR(10)
		,ClientName			VARCHAR(300)
		,IDNumber			VARCHAR(12)
		,CDSNo				VARCHAR(9)
		,TradingLimit		DECIMAL(8,2)
		,HomeContactNo		VARCHAR(12)
		,OfficeContactNo	VARCHAR(12)
		,ContactNumberHP	VARCHAR(20)
		,Address1			VARCHAR(40)
		,Address2			VARCHAR(40)
		,Address3			VARCHAR(40)
		,Address4			VARCHAR(40)
		,Email				VARCHAR(50)
		,CreationDate		VARCHAR(10)
		,LastUpdatedDate	VARCHAR(10)
		,AcctStatus			VARCHAR(1)
		,BatchMode			VARCHAR(1)
		,AvailableTrustBalance	DECIMAL(9,2)
		,CurrentTrustBalance	DECIMAL(9,2)

	)
	INSERT INTO #Detail
	(
		 RecordType			
		,BranchCode			
		,DealerCode			
		,AccountNo			
		,ClientName			
		,IDNumber			
		,CDSNo				
		,TradingLimit		
		,HomeContactNo		
		,OfficeContactNo	
		,ContactNumberHP	
		,Address1			
		,Address2			
		,Address3			
		,Address4			
		,Email				
		,CreationDate		
		,LastUpdatedDate	
		,AcctStatus			
		,BatchMode			
		,AvailableTrustBalance
		,CurrentTrustBalance		
	)
	SELECT 
		1,
		Branch.[BranchCode (textinput-42)],
		Account.[DealerCode (selectsource-21)],
		[AccountNumber (textinput-5)],
		[CustomerName (textinput-3)],
		[IDNumber (textinput-5)],
		[CDSNo (textinput-19)],
		[AvailableTradingLimit (textinput-55)],
		[MobilePhone (textinput-17)],
		[OfficeNumber (textinput-13)],
		'', -- Contact Number (HP)
		[Address1 (textinput-7)],
		[Address2 (textinput-8)],
		[Address3 (textinput-9)],
		[AddressCity (textinput-153)],
		[Email (textinput-58)],
		CONVERT(VARCHAR,Customer.CreatedTime,103),
		CONVERT(VARCHAR,Customer.UpdatedTime,103),
		[Tradingaccount (selectsource-31)],
		CASE 
			WHEN ISNULL(Customer.UpdatedTime,'') = '' 
			THEN 'N' 
			ELSE 'A' 
		END, -- Batch Mode
		C.Balance,
		C.UnavailableBalance
	FROM CQBTempDB.export.Tb_FormData_1409 Account 
	INNER JOIN CQBTempDB.export.Tb_FormData_1410 Customer 
		ON Account.[CustomerID (selectsource-1)] = Customer.[CustomerID (textinput-1)]
	INNER JOIN CQBTempDB.export.Tb_FormData_1377 Dealer 
		ON Dealer.[DealerCode (textinput-35)] = Account.[DealerCode (selectsource-21)]
	INNER JOIN CQBTempDB.export.Tb_FormData_1374 Branch 
		ON Dealer.[BranchID (selectsource-1)] = Branch.[BranchID (textinput-1)]
	INNER JOIN GlobalBO.holdings.Tb_Cash C 
		ON C.AcctNo = Account.[AccountNumber (textinput-5)]

	-- BATCH TRAILER	
	DECLARE @Count INT
	SET @Count = (SELECT COUNT(*) FROM #Detail)

	CREATE TABLE #Trailer
	(
		 RecordType				CHAR(1)
		,BatchDate				CHAR(10)
		,TotalRecord			INT
	)
	INSERT INTO #Trailer
	(
		 RecordType				
		,BatchDate	
		,TotalRecord							
	)
	VALUES(0,CONVERT(VARCHAR,@idteProcessDate,103),@Count)

	-- RESULT SET
	SELECT 
		  RecordType + '|' + BranchCode + '|' + DealerCode + '|' + AccountNo + '|' + ClientName + '|' + IDNumber			
		   + '|' + CDSNo + '|' + CAST(TradingLimit AS VARCHAR) + '|' + HomeContactNo	+ '|' + OfficeContactNo	+ '|' + ContactNumberHP	
		   + '|' + Address1 + '|' + Address2 + '|' + Address3 + '|' + Address4 + '|' + Email + '|' + CreationDate		
		   + '|' + LastUpdatedDate + '|' + AcctStatus + '|' + BatchMode	+ '|' + CAST(AvailableTrustBalance AS VARCHAR) + '|' + CAST(CurrentTrustBalance AS VARCHAR)	
	FROM 
		#Detail
	UNION ALL
	SELECT 
		RecordType + '|' + BatchDate + '|' + CAST(TotalRecord AS VARCHAR) 
	FROM 
		#Trailer

	DROP TABLE #Detail
	DROP TABLE #Trailer

END