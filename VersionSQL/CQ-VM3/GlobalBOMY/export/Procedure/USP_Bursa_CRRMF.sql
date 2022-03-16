/****** Object:  Procedure [export].[USP_Bursa_CRRMF]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_Bursa_CRRMF]
(
	@idteProcessDate DATE
)
AS
/*
Description : MARGIN FINANCING INFO EXPORT TO Bursa
Test Input	: EXEC [export].[USP_Bursa_CRRMF] '2020-06-01'
*/
BEGIN
	-- Header Record
	CREATE TABLE #Header
	(
		RecordType		VARCHAR(1),
		ReportingDate	VARCHAR(10),
		RecordCount		VARCHAR(10)
	);

	-- Data Record
	CREATE TABLE #MarginFinancing
	(
		RecordType				VARCHAR(1),
		SBCCode					VARCHAR(6),
		ReportingDate			VARCHAR(10),
		BranchCode				VARCHAR(6),
		ClientCode				VARCHAR(12),
		ExchCode				VARCHAR(10),
		MFApprovedLimit			NUMERIC(15,3),
		MarginBalance			NUMERIC(15,3),
		TransDate				VARCHAR(10),
		TransRef				VARCHAR(20),
		ExpirtDate				VARCHAR(10),
		ProvisionType			VARCHAR(1),
		ProvisionValueMYR		NUMERIC(15,3)
	);
	INSERT INTO #MarginFinancing
	(
		 RecordType			
		,SBCCode				
		,ReportingDate		
		,BranchCode			
		,ClientCode			
		,ExchCode			
		,MFApprovedLimit		
		,MarginBalance		
		,TransDate			
		,TransRef			
		,ExpirtDate			
		,ProvisionType		
		,ProvisionValueMYR	
	)
	SELECT 
		'1',
		'012',
		@idteProcessDate,
		[CDSACOpenBranch (selectsource-4)],
		[AccountNumber (textinput-5)],
		HomeExchCd,
		[ApproveTradingLimit (textinput-54)],
		CustodyAssetsBalance,
		ContractDate,
		ContractNo,
		[TenorExpirydate (dateinput-5)],
		'N',
		'0.000'
	FROM GlobalBO.contracts.Tb_ContractOutstanding CO
	INNER JOIN CQBTempDB.export.Tb_FormData_1409 A 
		ON CO.AcctNo = A.[AccountNumber (textinput-5)]
	INNER JOIN GlobalBO.setup.Tb_Instrument I 
		ON CO.InstrumentId = I.InstrumentId
	LEFT JOIN GLOBALBORPT.[valuation].[Tb_CustodyAssetsRPValuationCollateralRpt] C 
		ON A.[AccountNumber (textinput-5)] = C.AcctNo AND I.InstrumentId = C.InstrumentId
	WHERE [AccountGroup (selectsource-2)] IN ('M','G') AND CO.ContractDate = @idteProcessDate

	UNION

	SELECT 
		'1',
		'012',
		@idteProcessDate,
		[CDSACOpenBranch (selectsource-4)],
		[AccountNumber (textinput-5)],
		HomeExchCd,
		[ApproveTradingLimit (textinput-54)],
		CustodyAssetsBalance,
		TransDate,
		TransNo,
		[TenorExpirydate (dateinput-5)],
		'N',
		'0.000'
	FROM GlobalBO.transmanagement.Tb_Transactions CO
	INNER JOIN CQBTempDB.export.Tb_FormData_1409 A 
		ON CO.AcctNo = A.[AccountNumber (textinput-5)]
	INNER JOIN GlobalBO.setup.Tb_Instrument I 
		ON CO.InstrumentId = I.InstrumentId
	LEFT JOIN GLOBALBORPT.[valuation].[Tb_CustodyAssetsRPValuationCollateralRpt] C 
		ON A.[AccountNumber (textinput-5)] = C.AcctNo AND I.InstrumentId = C.InstrumentId
	WHERE [AccountGroup (selectsource-2)] IN ('M','G') AND CO.TransDate = @idteProcessDate;

	DECLARE @Count INT;
	SET @Count = (SELECT COUNT(*) FROM #MarginFinancing);

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
		 RecordType		
		 + ',' + SBCCode			
		 + ',' + ReportingDate	
		 + ',' + BranchCode		
		 + ',' + ClientCode		
		 + ',' + ExchCode		
		 + ',' + CAST(MFApprovedLimit AS VARCHAR)
		 + ',' + CAST(MarginBalance	AS VARCHAR)
		 + ',' + TransDate		
		 + ',' + TransRef		
		 + ',' + ExpirtDate		
		 + ',' + ProvisionType	
		 + ',' + CAST(ProvisionValueMYR	AS VARCHAR)	 
	FROM #MarginFinancing;

		DROP TABLE #Header;
		DROP TABLE #MarginFinancing;

END