/****** Object:  Procedure [export].[USP_Bursa_CRRDTCL]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_Bursa_CRRDTCL]
(
	@idteProcessDate DATE
)
AS
/*
Description : DEBT/CONTRA LOSS/OTHER AMOUNT DUE INFO EXPORT TO Bursa
Test Input	: EXEC [export].[USP_Bursa_CRRDTCL] '2020-06-01'
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
	CREATE TABLE #Data
	(
		RecordType				VARCHAR(1),
		SBCCode					VARCHAR(6),
		ReportingDate			VARCHAR(10),
		BranchCode				VARCHAR(6),
		DealerCode				VARCHAR(6),
		ClientCode				VARCHAR(12),
		ExposureType			VARCHAR(2),
		ISINCode				VARCHAR(12),
		TransRef				VARCHAR(20),
		TransDate				VARCHAR(10),
		OrgValue				NUMERIC(15,3),
		OutStandingValue		NUMERIC(15,3),
		CurrencyCode			VARCHAR(3),
		ProvisionType			VARCHAR(1),
		ProvisionValueMYR		NUMERIC(15,3),
		IntInSuspenseAcctMYR	NUMERIC(15,3)
	);
	INSERT INTO #Data
	(
		 RecordType			
		,SBCCode				
		,ReportingDate		
		,BranchCode			
		,DealerCode			
		,ClientCode			
		,ExposureType		
		,ISINCode			
		,TransRef			
		,TransDate			
		,OrgValue			
		,OutStandingValue	
		,CurrencyCode		
		,ProvisionType		
		,ProvisionValueMYR	
		,IntInSuspenseAcctMYR
	)
	SELECT 
		1,
		'012',
		CONVERT(VARCHAR,@idteProcessDate,103),
		[CDSACOpenBranch (selectsource-4)],
		[DealerCode (textinput-35)],
		A.[AccountNumber (textinput-5)],
		CASE WHEN TransType  = 'CHLS'
			 THEN 'CL'
			 WHEN TransType  = 'SCHLS'
			 THEN 'ST'
			 ELSE ''
		END,
		ISINCd,
		T.TransNo,
		CONVERT(VARCHAR,T.TransDate,103),
		T.Amount,
		'',
		T.CurrCd,
		'N',
		'0.000',
		''
	FROM GlobalBO.transmanagement.Tb_Transactions T
	INNER JOIN CQBTempDB.export.Tb_FormData_1409 A 
		ON T.AcctNo = A.[AccountNumber (textinput-5)]
	INNER JOIN CQBTempDB.export.tb_FormData_1377 D 
		ON D.[BranchID (selectsource-1)] = A.[CDSACOpenBranch (selectsource-4)]
	INNER JOIN GlobalBO.setup.Tb_Instrument I 
		ON T.InstrumentId = I.InstrumentId
	WHERE T.TransType IN ('CHLS','SCHLS') AND T.TransDate = @idteProcessDate
	AND 
		[ParentGroup (selectsource-3)] NOT IN ('V','P','E') AND [AccountGroup (selectsource-2)] NOT IN ('M','G')

	UNION 

	SELECT 
		1,
		'012',
		CONVERT(VARCHAR,@idteProcessDate,103),
		[CDSACOpenBranch (selectsource-4)],
		[DealerCode (textinput-35)],
		[AccountNumber (textinput-5)],
		CASE WHEN TransType  = 'CHLS'
			 THEN 'CL'
			 WHEN TransType  = 'SCHLS'
			 THEN 'ST'
			 ELSE ''
		END,
		ISINCd,
		T.ContractNo,
		CONVERT(VARCHAR,T.ContractDate,103),
		T.NetAmountSetl,
		'',
		T.TradedCurrCd,
		'N',
		'0.000',
		''
	FROM GlobalBO.transmanagement.Tb_TransactionsSettled T
	INNER JOIN CQBTempDB.export.Tb_FormData_1409 A 
		ON T.AcctNo = A.[AccountNumber (textinput-5)]
	INNER JOIN CQBTempDB.export.tb_FormData_1377 D 
		ON D.[BranchID (selectsource-1)] = A.[CDSACOpenBranch (selectsource-4)]
	INNER JOIN GlobalBO.setup.Tb_Instrument I 
		ON T.InstrumentId = I.InstrumentId
	WHERE T.TransType IN ('CHLS','SCHLS') AND T.ContractDate = @idteProcessDate
	AND [ParentGroup (selectsource-3)] NOT IN ('V','P','E') AND [AccountGroup (selectsource-2)] NOT IN ('M','G');


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
	FROM #Header

	UNION ALL

	SELECT 
		 RecordType			
		 + ',' + SBCCode				
		 + ',' + ReportingDate		
		 + ',' + BranchCode			
		 + ',' + DealerCode			
		 + ',' + ClientCode			
		 + ',' + ExposureType		
		 + ',' + ISINCode			
		 + ',' + TransRef			
		 + ',' + TransDate			
		 + ',' + CAST(OrgValue AS VARCHAR)		
		 + ',' + CAST(OutStandingValue AS VARCHAR)	
		 + ',' + CurrencyCode		
		 + ',' + ProvisionType		
		 + ',' + CAST(ProvisionValueMYR	AS VARCHAR)
		 + ',' + CAST(IntInSuspenseAcctMYR AS VARCHAR)
	FROM #Data;

	DROP TABLE #Header;
	DROP TABLE #Data;

END