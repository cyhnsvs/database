/****** Object:  Procedure [export].[USP_Bursa_IPDTERROR_WK]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_Bursa_IPDTERROR_WK]
(
	@idteProcessDate DATE
)
AS
/*
Description : INVESTMENT, PDT AND ERROR OR MISTAKE ACCOUNTS TO BURSA
Test Input	: EXEC [export].[USP_Bursa_IPDTERROR_WK] '2020-06-01'
*/
BEGIN

	DECLARE @ReportDate DATE;
	
	SELECT @ReportDate = MAX([ReportDate (dateinput-1)]) 
	FROM CQBTempDB.export.Tb_FormData_3174
	WHERE CAST([ReportDate (dateinput-1)] as date) <= @idteProcessDate;
	
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
		InvestmentCode		VARCHAR(3),
		BeginPositionValue	DECIMAL(15,2),
		AcquisitionValue	DECIMAL(15,2),
		DisposalValue		DECIMAL(15,2),
		MTMValue			DECIMAL(15,2)
	);

	INSERT INTO #Detail
	(
		 RecordType			
		,POCode				
		,PositionDate		
		,InvestmentCode		
		,BeginPositionValue	
		,AcquisitionValue	
		,DisposalValue		
		,MTMValue				
	)
	SELECT 
		1,
		'012',
		CONVERT(VARCHAR,@idteProcessDate,103),
		CASE WHEN [ParentGroup (selectsource-3)] = 'V'
		     THEN 'IVT'
			 WHEN [ParentGroup (selectsource-3)] = 'P'
			 THEN 'PDT'
			 WHEN [ParentGroup (selectsource-3)] = 'E'
			 THEN 'ERR' END,
		SUM(CustodyAssetsBalanceBF),
		CASE WHEN CO.TransType = 'TRBUY' THEN SUM(TradedQty) ELSE 0 END,
		CASE WHEN CO.TransType = 'TRSELL' THEN SUM(TradedQty) ELSE 0 END,
		SUM(MktValue)
	FROM [GlobalBORpt].[valuation].[Tb_CustodyAssetsRPValuationCollateralRpt] C
	INNER JOIN CQBTempDB.export.Tb_FormData_1409 A 
		ON C.AcctNo = A.[AccountNumber (textinput-5)]
	INNER JOIN GlobalBO.contracts.Tb_ContractOutstanding CO 
		ON A.[AccountNumber (textinput-5)] = CO.AcctNo
	WHERE A.[ParentGroup (selectsource-3)] IN ('V','P','E')
	GROUP BY CO.AcctNo, [ParentGroup (selectsource-3)], TransType

	UNION 

	SELECT 
		1,
		'012',
		CONVERT(VARCHAR,@idteProcessDate,103),
		'OTH',
		[PositionAsAtBeginningoftheWeekRM (textinput-1)],
		[AcquisitionduringtheweekRM (textinput-2)],
		[DisposalDuringTheWeekRM (textinput-3)],
		[MarkedToMarketValueAsAtEndoftheweekRM (textinput-5)]
	FROM CQBTempDB.export.Tb_FormData_3261 AS C
	WHERE [ReportDate (dateinput-1)] = @ReportDate;

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
		RecordType + ',' + POCode + ',' + PositionDate + ',' + InvestmentCode + ',' + CAST(BeginPositionValue AS VARCHAR) + ',' + CAST(AcquisitionValue AS VARCHAR) + ',' + 
		CAST(DisposalValue AS VARCHAR) + ',' + CAST(MTMValue AS VARCHAR)
	FROM #Detail;

	DROP TABLE #Header;
	DROP TABLE #Detail;

END