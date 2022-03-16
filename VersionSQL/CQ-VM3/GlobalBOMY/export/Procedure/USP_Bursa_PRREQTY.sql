/****** Object:  Procedure [export].[USP_Bursa_PRREQTY]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_Bursa_PRREQTY]
(
	@idteProcessDate DATE
)
AS
/*
Description : PRR Data – Principal Trades – Equities & Depository Receipts INFO EXPORT TO Bursa
Test Input	: EXEC [export].[USP_Bursa_PRREQTY] '2020-06-01'
*/
BEGIN

	DECLARE @ReportDate DATE;
	
	SELECT @ReportDate = MAX([ReportDate (dateinput-1)]) 
	FROM CQBTempDB.export.Tb_FormData_3173
	WHERE CAST([ReportDate (dateinput-1)] as date) <= @idteProcessDate;

	-- Header Record
	CREATE TABLE #Header
	(
		RecordType		VARCHAR(1),
		ReportingDate	VARCHAR(10),
		RecordCount		VARCHAR(10)
	);

	-- Data Record
	CREATE TABLE #Data
	(
		RecordType				VARCHAR(1),
		SBCCode					VARCHAR(6),
		ReportingDate			VARCHAR(10),
		BranchCode				VARCHAR(6),
		DealerCode				VARCHAR(6),
		AccountType				VARCHAR(3),
		ISINCode				VARCHAR(12),
		PositionType			VARCHAR(1),
		CurrencyCode			VARCHAR(3),
		ContractVolume			VARCHAR(10),
		ContractValue			NUMERIC(15,3),
		PRRMethod				VARCHAR(3)
	);
	
	INSERT INTO #Data
	(
		 RecordType			
		,SBCCode			
		,ReportingDate	
		,BranchCode		
		,DealerCode		
		,AccountType 		
		,ISINCode 		
		,PositionType	
		,CurrencyCode	
		,ContractVolume	
		,ContractValue	
		,PRRMethod									
	)
	SELECT 
		 1
		,[SBCCode (textinput-1)]
		,CONVERT(VARCHAR,@idteProcessDate,103)
		,[BranchCode (textinput-2)]
		,[DealerCode (textinput-3)]
		,[AccountType (selectbasic-1)]	
		,[ISINCode (textinput-4)]
		,[PositionType (selectbasic-2)]
		,[CurrencyCode (textinput-5)]
		,[ContractVolume (textinput-6)]
		,[ContractValue (textinput-7)]
		,[PRRMethod (textinput-8)]		
	FROM CQBTempDB.export.Tb_FormData_3173
	WHERE [ReportDate (dateinput-1)] = @ReportDate;

	DECLARE @Count INT;
	SET @Count = (SELECT COUNT(*) FROM #Data);

	INSERT INTO #Header
	(
		RecordType,
		ReportingDate,
		RecordCount
	)
	VALUES(0,CONVERT(VARCHAR,@idteProcessDate,103),@Count);
	
	-- RESULT SET 
	SELECT 
		RecordType + ',' + ReportingDate + ',' + RecordCount
	FROM 
		#Header
	UNION ALL
	SELECT 
		RecordType		
		+ ',' + SBCCode			
		+ ',' + ReportingDate	
		+ ',' + BranchCode		
		+ ',' + DealerCode		
		+ ',' + AccountType		
		+ ',' + ISINCode		
		+ ',' + PositionType	
		+ ',' + CurrencyCode	
		+ ',' + ContractVolume	
		+ ',' + CAST(ContractValue AS VARCHAR)	
		+ ',' + PRRMethod					
	FROM #Data;

	DROP TABLE #Data;
	DROP TABLE #Header;

END