/****** Object:  Procedure [export].[USP_Bursa_OUTSTDNG]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_Bursa_OUTSTDNG]
(
	@idteProcessDate DATE
)
AS
/*
Description : Outstanding Liabilities INFO EXPORT TO Bursa
Test Input	: EXEC [export].[USP_Bursa_INSEQTY] '2020-06-01'
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
		TDaySales				NUMERIC(15,3),
		TDayPurchase			NUMERIC(15,3),
		[TDay-1Sales]			NUMERIC(15,3),
		[TDay-1Purchase]		NUMERIC(15,3),
		[TDay-2Sales]			NUMERIC(15,3),
		[TDay-2Purchase]		NUMERIC(15,3)
	)

	INSERT INTO #Data
	(
		 RecordType		
		,SBCCode			
		,ReportingDate	
		,TDaySales		
		,TDayPurchase	
		,[TDay-1Sales]	
		,[TDay-1Purchase]
		,[TDay-2Sales]	
		,[TDay-2Purchase]
	)
	SELECT 
		1,
		'012',
		CONVERT(VARCHAR,@idteProcessDate,103),
		SUM(CASE WHEN T.NetAmountSetl > 0
		     THEN T.NetAmountSetl
		     ELSE 0
		END),
		SUM(CASE WHEN T.NetAmountSetl < 0
		     THEN T.NetAmountSetl
		     ELSE 0
		END),
		SUM(CASE WHEN T1.NetAmountSetl > 0
		     THEN T1.NetAmountSetl
		     ELSE 0
		END),
		SUM(CASE WHEN T1.NetAmountSetl < 0
		     THEN T1.NetAmountSetl
		     ELSE 0
		END),
		SUM(CASE WHEN T2.NetAmountSetl > 0
		     THEN T2.NetAmountSetl
		     ELSE 0
		END),
		SUM(CASE WHEN T2.NetAmountSetl < 0
		     THEN T2.NetAmountSetl
		     ELSE 0
		END)
	FROM GlobalBOLocal.transmanagement.Tb_TransactionsSettledUnpaid T
	INNER JOIN GlobalBOLocal.transmanagement.Tb_TransactionsSettledUnpaid T1 
		ON T1.TradeDate = DATEADD(day, -1, @idteProcessDate)
	INNER JOIN GlobalBOLocal.transmanagement.Tb_TransactionsSettledUnpaid T2 
		ON T2.TradeDate = DATEADD(day, -2, @idteProcessDate)
	WHERE T.TradeDate = @idteProcessDate
	GROUP BY T.AcctNo,T.InstrumentId,T.TransType;

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
		+ ',' + CAST(TDaySales AS VARCHAR)	
		+ ',' + CAST(TDayPurchase AS VARCHAR)	
		+ ',' + CAST([TDay-1Sales] AS VARCHAR)	
		+ ',' + CAST([TDay-1Purchase] AS VARCHAR)
		+ ',' + CAST([TDay-2Sales] AS VARCHAR)	
		+ ',' + CAST([TDay-2Purchase] AS VARCHAR)		
	FROM #Data;

	DROP TABLE #Header;
	DROP TABLE #Data;

END