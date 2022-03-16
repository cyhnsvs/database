/****** Object:  Procedure [export].[USP_ECOS_MACSEFRMS_CTLM]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_ECOS_MACSEFRMS_CTLM]
(
	@idteProcessDate DATE
)
AS
-- CLIENT TRADING LIMIT FOR EXTERNAL MARGIN CLIENT (OFFLINE CLIENT)
-- EXEC [export].[USP_ECOS_MACSEFRMS_CTLM] '2020-06-01'
BEGIN
	CREATE TABLE #CTL
	(
		RecordType			CHAR(1),
		BranchID			CHAR(3),
		ClientCode			CHAR(9),
		MaxNetLimit			DECIMAL(14,2),
		MaxBuyLimit			DECIMAL(14,2),
		MaxSellLimit		DECIMAL(14,2),
		MaxTotalLimit		DECIMAL(14,2),
		TrustAmount			DECIMAL(14,2)
	)
	INSERT INTO #CTL
	(
		 RecordType
		,BranchID
		,ClientCode		
		,MaxNetLimit		
		,MaxBuyLimit		
		,MaxSellLimit	
		,MaxTotalLimit	
		,TrustAmount			
	)
	SELECT 
		1,
		'001',
		Form.[AccountNumber (textinput-5)],
		CASE WHEN Form.[MaxNetLimit (textinput-70)] = ''  THEN '0.00' ELSE ISNULL(Form.[MaxNetLimit (textinput-70)],0) END,
		CASE WHEN Form.[MaxBuyLimit (textinput-68)] = ''  THEN '0.00' ELSE ISNULL(Form.[MaxBuyLimit (textinput-68)],0) END,
		CASE WHEN Form.[MaxSellLimit (textinput-69)] = '' THEN '0.00' ELSE ISNULL(Form.[MaxSellLimit (textinput-69)],0) END,
		CASE WHEN Form.[MaxNetLimit (textinput-70)] = ''  THEN '0.00' ELSE ISNULL(Form.[MaxNetLimit (textinput-70)],0) END,
		ISNULL(C.Balance,0)
	FROM	
		CQBTempDB.export.Tb_FormData_1409	Form 
	INNER JOIN 
		GlobalBO.setup.Tb_Account A ON A.AcctNo = Form.[AccountNumber (textinput-5)] 
	LEFT JOIN 
		GlobalBO.holdings.Tb_Cash C ON C.AcctNo = Form.[AccountNumber (textinput-5)] 
	WHERE
		(CHARINDEX('M+',[MRIndicator (multipleradiosinline-4)]) = 0 OR ISNULL([CDSNo (textinput-19)],'') = '')
	AND 
		A.ServiceType = 'G'
	

		-- CONTROL RECORD 
	DECLARE @Count INT
	SET @Count = (SELECT COUNT(*) FROM #CTL)
	
	CREATE TABLE #CTLControl
	(
		RecordType  CHAR(1),
		RecordCount CHAR(12),
		ProcessDate CHAR(10)
	)
	INSERT INTO #CTLControl
	(
		RecordType,
		RecordCount,
		ProcessDate
	)
	VALUES (0,@Count,CONVERT(VARCHAR,@idteProcessDate, 105))

	-- TRANSACTION RECORD - RESULT SET
	SELECT 
		ISNULL(RecordType,'') + '|' + ISNULL(BranchID,'') + '|' + ISNULL(ClientCode,'') + '|' +  CAST(MaxNetLimit AS CHAR(14)) + '|' +  CAST(MaxBuyLimit AS CHAR(14)) + '|' + 
		CAST(MaxSellLimit AS CHAR(14)) + '|' +  CAST(MaxTotalLimit AS CHAR(14)) + '|' +  CAST(TrustAmount AS CHAR(14))
	FROM 
		#CTL
	UNION ALL
	-- CONTROL RECORD - RESULT SET
	SELECT 
		RecordType + '|' +  RIGHT(REPLICATE('0',12) + RTRIM(RecordCount),12) + '|' +  ProcessDate
	FROM
		#CTLControl

	DROP TABLE #CTL
	DROP TABLE #CTLControl
END