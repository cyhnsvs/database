/****** Object:  Procedure [export].[USP_Bursa_CTRLDATA]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_Bursa_CTRLDATA]
(
	@idteProcessDate DATE
)
AS
/*
Description : CASH AND STOCK COLLATERAL FOR NON MARGIN ACCOUNTS
Test Input	: EXEC [export].[USP_Bursa_CTRLDATA] '2020-06-01'
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
	CREATE TABLE #Detail
	(
		RecordType			VARCHAR(1),
		SBCCode				VARCHAR(6),
		ReportingDate		VARCHAR(10),
		BranchCode			VARCHAR(6),
		CollateralSource	VARCHAR(1), -- length error
		DelearCode			VARCHAR(6),
		ClientCode			VARCHAR(12),
		CollateralType		VARCHAR(2),
		CollateralISIN		VARCHAR(12),
		CollateralCurrency	VARCHAR(3),
		CollateralReference	VARCHAR(12),
		CollateralVolume	DECIMAL(15,3),
		CollateralValueMYR	DECIMAL(15,3),
	);
	INSERT INTO #Detail
	(	
	 RecordType			
	,SBCCode				
	,ReportingDate		
	,BranchCode			
	,CollateralSource	
	,DelearCode			
	,ClientCode			
	,CollateralType		
	,CollateralISIN		
	,CollateralCurrency
	,CollateralReference
	,CollateralVolume	
	,CollateralValueMYR
	
	)
	SELECT 
		1,
		'012',
		CONVERT(VARCHAR,@idteProcessDate,103),
		BranchCd,
		FundSourceId,
		[DealerCode (selectsource-21)],
		AcctNo,
		FundSourceCd,
		'',
		CurrCd,
		CollateralId,
		0,
		CollateralCurrCutCompanyBased
	FROM [GlobalBORpt].[valuation].[Tb_CashRPValuationCollateralRpt] Rpt
	INNER JOIN CQBTempDB.export.tb_formdata_1409 ACC 
		ON  ACC.[AccountNumber (textinput-5)] = Rpt.AcctNo
	WHERE [AccountGroup (selectsource-2)] NOT IN ('M','G')

	UNION ALL

	SELECT  
		1,
		'012',
		CONVERT(VARCHAR,@idteProcessDate,103),
		BranchCd,
		Collateral,
		[DealerCode (selectsource-21)],
		AcctNo,
		ProductCd,
		ISINCd,
		TradedCurrCd,
		CollateralId,
		CustodyAssetsFBalance,
		CollateralCompanyBased
	FROM [GlobalBORpt].[valuation].[Tb_CustodyAssetsRPValuationCollateralRpt] CustRpt
	INNER JOIN CQBTempDB.export.tb_formdata_1409 ACCF 
			ON  ACCF.[AccountNumber (textinput-5)] = CustRpt.AcctNo
	WHERE [AccountGroup (selectsource-2)] NOT IN ('M','G');

	--GROUP BY AcctNo

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
		 RecordType + ',' + SBCCode + ',' + ReportingDate+ ',' +BranchCode + ',' +CAST(CollateralSource AS VARCHAR(50)) + ',' + DelearCode	+ ',' +ClientCode	+ ',' +CollateralType+ ',' +CollateralISIN+ ',' +CollateralCurrency + ',' + CollateralReference + ',' + 

		 CAST(CollateralVolume AS VARCHAR(30)) + ',' + CAST(CollateralValueMYR AS VARCHAR(30))
	FROM #Detail;

	DROP TABLE #Header;
	DROP TABLE #Detail;

END