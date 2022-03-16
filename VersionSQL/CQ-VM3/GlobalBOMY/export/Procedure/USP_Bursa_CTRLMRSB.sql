/****** Object:  Procedure [export].[USP_Bursa_CTRLMRSB]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_Bursa_CTRLMRSB]
(
	@idteProcessDate DATE
)
AS
/*
Description : CASH AND STOCK COLLATERAL FOR MARGIN ACCOUNTS
Test Input	: EXEC [export].[USP_Bursa_CTRLMRSB] '2020-06-01'
*/
BEGIN
	-- Header Record
	CREATE TABLE #Header
	(
		RecordType		VARCHAR(1),
		ReportingDate	VARCHAR(10),
		RecordCount		VARCHAR(10)
	)

	-- Data Record
	CREATE TABLE #Data
	(
		RecordType				VARCHAR(1),
		SBCCode					VARCHAR(6),
		ReportingDate			VARCHAR(10),
		BranchCode				VARCHAR(6),
		TransType				VARCHAR(2),
		TransRef				VARCHAR(20),
		CollateralSource		VARCHAR(1),
		DealerCode				VARCHAR(6),
		ClientCode				VARCHAR(12),
		CollateralType			VARCHAR(2),
		CollateralISIN			VARCHAR(12),
		CollateralCurrency		VARCHAR(3),
		CollateralRef			VARCHAR(12),
		CollateralVolume	    DECIMAL(15,3),
		CollateralValueMYR	    DECIMAL(15,3),
	)

	DECLARE @Count INT
	SET @Count = (SELECT COUNT(*) FROM #Data)

	INSERT INTO #Header
	(
		RecordType,
		ReportingDate,
		RecordCount
	)
	VALUES(0,CONVERT(VARCHAR,@idteProcessDate,103),@Count)

	INSERT INTO #Data
	(
	
	 RecordType			
	,SBCCode				
	,ReportingDate		
	,BranchCode			
	,TransType			
	,TransRef				
	,CollateralSource	-- length error
	,DealerCode			
	,ClientCode			
	,CollateralType		
	,CollateralISIN		
	,CollateralCurrency
	,CollateralRef		
	,CollateralVolume	
	,CollateralValueMYR
	
	)
	
	SELECT 
		1,
		'012',
		CONVERT(VARCHAR,@idteProcessDate,103),
		BranchCd,
		'',
		'',
		0,
		[DealerCode (selectsource-21)],
		AcctNo,
		'',
		'',
		'',
		CollateralId,
		0,
	    0
	FROM [GlobalBORpt].[valuation].[Tb_CashRPValuationCollateralRpt] Rpt
	INNER JOIN CQBTempDB.export.tb_formdata_1409 ACC 
		ON  ACC.[AccountNumber (textinput-5)] = Rpt.AcctNo
	WHERE [AccountGroup (selectsource-2)] IN ('M','G') --AND [AccountGroup (selectsource-2)] !='G'

		UNION ALL

	SELECT  
		1,
		'012',
		CONVERT(VARCHAR,@idteProcessDate,103),
		BranchCd,
		'',
		'',
		Collateral,
		[DealerCode (selectsource-21)],
		AcctNo,
		'',
		ISINCd,
		TradedCurrCd,
		CollateralId,
		0,
		CollateralCompanyBased
	FROM [GlobalBORpt].[valuation].[Tb_CustodyAssetsRPValuationCollateralRpt] CustRpt
	INNER JOIN CQBTempDB.export.tb_formdata_1409 ACCF 
		ON  ACCF.[AccountNumber (textinput-5)] = CustRpt.AcctNo
	WHERE [AccountGroup (selectsource-2)] IN ('M','G')
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
		+ ',' + TransType
		+ ',' + TransRef
		+ ',' + CAST(CollateralSource AS VARCHAR)
		+ ',' + DealerCode			
		+ ',' + ClientCode			
		+ ',' + CollateralType		
		+ ',' + CollateralISIN		
		+ ',' + CollateralCurrency	
		+ ',' + CollateralRef		
		+ ',' + CAST(CollateralVolume AS VARCHAR)
		+ ',' + CAST(CollateralValueMYR	AS VARCHAR)	
	FROM #Data

	DROP TABLE #Header;
	DROP TABLE #Data;

END