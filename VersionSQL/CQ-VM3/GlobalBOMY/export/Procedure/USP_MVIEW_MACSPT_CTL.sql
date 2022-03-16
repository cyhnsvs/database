/****** Object:  Procedure [export].[USP_MVIEW_MACSPT_CTL]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_MVIEW_MACSPT_CTL]
(
	@idteProcessDate DATE
)
AS
-- CLIENT TRADING LIMIT - ONLINE CLIENT TO MVIEW
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
		Form.[MaxNetLimit (textinput-70)],
		Form.[MaxBuyLimit (textinput-68)],
		Form.[MaxSellLimit (textinput-69)],
		Form.[MaxNetLimit (textinput-70)],
		C.Balance
	FROM	
		CQBTempDB.export.Tb_FormData_1409 Form 
	--INNER JOIN 
	--	GlobalBOMY.import.Tb_AccountNoMapping AM ON AM.NewAccountNo = Form.[AccountNumber (textinput-5)] 
	LEFT JOIN 
		GlobalBO.holdings.Tb_Cash C ON C.AcctNo = Form.[AccountNumber (textinput-5)]
	INNER JOIN 
		CQBTempDB.export.Tb_FormData_1410 Customer ON Form.[CustomerID (selectsource-1)] = Customer.[CustomerID (textinput-1)]
	WHERE
		[OnlineSystemIndicator (multiplecheckboxesinline-2)] LIKE '%MV%' AND ISNULL([CDSNo (textinput-19)],'') <> ''
	

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
		ISNULL(RecordType,'') + '|' + ISNULL(ClientCode,'') + '|' +  CAST(ISNULL(MaxNetLimit,'') AS CHAR(14)) + '|' +  CAST(ISNULL(MaxBuyLimit,'') AS CHAR(14)) + '|' + 
		CAST(ISNULL(MaxSellLimit,'') AS CHAR(14)) + '|' +  CAST(ISNULL(MaxTotalLimit,'') AS CHAR(14)) + '|' +  CAST(ISNULL(TrustAmount,'') AS CHAR(14))
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