/****** Object:  Procedure [export].[USP_ORMS_EIS_DLRMAS]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_ORMS_EIS_DLRMAS]
(
	@idteProcessDate DATE
)
AS
/*
Dealer Master
EXEC [export].[USP_ORMS_EIS_DLRMAS] '2020-06-01'
*/
BEGIN
	CREATE TABLE #Detail
	(
		 RecordType			VARCHAR(1)			
		,BranchCode			VARCHAR(2)
		,DealerType			VARCHAR(1)
		,DealerCode			VARCHAR(4)
		,DealerName			VARCHAR(50)
		,TradingLimit		DECIMAL(8,2)
		,HomeContactNo		VARCHAR(12)
		,OfficeContactNo	VARCHAR(12)
		,ContactNumberHP	VARCHAR(13)
		,Address1			VARCHAR(40)
		,Address2			VARCHAR(40)
		,Address3			VARCHAR(40)
		,Address4			VARCHAR(40)
		,Email				VARCHAR(50)
		,CreationDate		VARCHAR(10)
		,LastUpdatedDate	VARCHAR(10)
		,[Status]			VARCHAR(1)
		,BatchMode			VARCHAR(1)

	)
	INSERT INTO #Detail
	(
		 RecordType		
		,BranchCode		
		,DealerType		
		,DealerCode		
		,DealerName		
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
		,[Status]		
		,BatchMode				
	)
	SELECT 
		1,
		Branch.[BranchCode (textinput-42)],
		Dealer.[DealerType (selectsource-3)],
		Dealer.[DealerCode (textinput-35)],
		[Name (textinput-3)],
		[AvailableTradingLimit (textinput-55)],
		[MobilePhone (textinput-17)],
		[Phone (textinput-16)],
		'', -- Contact Number (HP)
		Dealer.[Address1 (textinput-11)],
		Dealer.[Address2 (textinput-14)],
		Dealer.[Address3 (textinput-13)],
		Dealer.[Town (textinput-12)],
		[WorkEmail (textinput-20)],
		CONVERT(VARCHAR,Dealer.CreatedTime,103),
		CONVERT(VARCHAR,Dealer.UpdatedTime,103),
		Dealer.[Status (selectsource-12)],
		CASE 
			WHEN ISNULL(Dealer.UpdatedTime,'') = '' 
			THEN 'N' 
			ELSE 'A' 
		END -- Batch Mode
	FROM CQBTempDB.export.Tb_FormData_1377 Dealer 
	INNER JOIN CQBTempDB.export.Tb_FormData_1374 Branch 
		ON Dealer.[BranchID (selectsource-1)] = Branch.[BranchID (textinput-1)]
	INNER JOIN CQBTempDB.export.Tb_FormData_1409 Account 
		ON Dealer.[DealerCode (textinput-35)] = Account.[DealerCode (selectsource-21)]
	INNER JOIN CQBTempDB.export.Tb_FormData_1410 Customer 
		ON Account.[CustomerID (selectsource-1)] = Customer.[CustomerID (textinput-1)]

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
		  RecordType + '|' + BranchCode + '|' + DealerType + '|' + DealerCode + '|' + DealerName + '|' + CAST(TradingLimit AS VARCHAR) 
		  + '|' + HomeContactNo	+ '|' + OfficeContactNo	+ '|' + ContactNumberHP	
		   + '|' + Address1 + '|' + Address2 + '|' + Address3 + '|' + Address4 + '|' + Email + '|' + CreationDate		
		   + '|' + LastUpdatedDate + '|' + [Status] + '|' + BatchMode
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