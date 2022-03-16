/****** Object:  Procedure [export].[USP_Bursa_OFFBSHEET_MTH]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_Bursa_OFFBSHEET_MTH]
(
	@idteProcessDate DATE
)
AS
/*
Description : OFF BALANCE SHEET TRANSACTIONS TO BURSA
Test Input	: EXEC [export].[USP_Bursa_OFFBSHEET_MTH] '2020-06-01'
*/
BEGIN

	DECLARE @ReportDate DATE;
	
	SELECT @ReportDate = MAX([ReportDate (dateinput-4)]) 
	FROM CQBTempDB.export.Tb_FormData_3218
	WHERE CAST([ReportDate (dateinput-4)] as date) <= @idteProcessDate;

	-- Header Record
	CREATE TABLE #Header
	(
		RecordType		VARCHAR(1),
		ReportingDate	VARCHAR(10),
		RecordCount		VARCHAR(10)
	);

	-- Data Record
	CREATE TABLE #Detail
	(
		RecordType			VARCHAR(1),
		POCode				VARCHAR(6),
		PositionDate		VARCHAR(10),
		TransDate			VARCHAR(10),
		TransType			VARCHAR(3),
		SecurityName		VARCHAR(60),
		Qty					DECIMAL(15,2),
		[Value]				DECIMAL(15,2),
		CounterParty		VARCHAR(300),
		TransPeriodStart	VARCHAR(10),
		TransPeriodExpiry	VARCHAR(10),
		FinancialNature		VARCHAR(100)
	);

	INSERT INTO #Detail
	(
		  RecordType			
		 ,POCode				
		 ,PositionDate		
		 ,TransDate			
		 ,TransType			
		 ,SecurityName		
		 ,Qty					
		 ,[Value]				
		 ,CounterParty		
		 ,TransPeriodStart	
		 ,TransPeriodExpiry	
		 ,FinancialNature							
	)
	SELECT 
		1,
		[POCode (textinput-1)],
		CONVERT(VARCHAR,@idteProcessDate,103),
		[TransactionDate (dateinput-1)],
		[TransactionType (selectbasic-1)],
		[SecuritiesName (textinput-2)],
		[Quantity (textinput-3)],
		[Value (textinput-4)],
		[Counterparty (textinput-5)],
		[TransactionPeriodStart (dateinput-2)],
		[TransactionPeriodExpiry (dateinput-3)],
		[FinancialNature (textinput-6)]
	FROM CQBTempDB.export.Tb_FormData_3218
	WHERE [ReportDate (dateinput-4)] = @ReportDate;

	DECLARE @Count INT;
	SET @Count = (SELECT COUNT(*) FROM #Detail);

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
	FROM #Header
	UNION ALL
	SELECT 
		RecordType + ',' + POCode + ',' + PositionDate + ',' + TransDate + ',' + TransType  + ',' + SecurityName  + ',' + CAST(Qty AS VARCHAR) + ',' + CAST([Value] AS VARCHAR)
		 + ',' + CounterParty  + ',' + TransPeriodStart  + ',' + TransPeriodExpiry  + ',' + FinancialNature
	FROM #Detail;
	
	DROP TABLE 	#Header;
	DROP TABLE 	#Detail;
END