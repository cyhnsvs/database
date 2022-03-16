/****** Object:  Procedure [export].[USP_BURSA_MARGINACCOUNT_MTH]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [export].[USP_BURSA_MARGINACCOUNT_MTH]
	-- Add the parameters for the stored procedure here
	(
		@idteProcessDate DATE
    )
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	-- EXEC [export].[USP_BURSA_MARGINACCOUNT_MTH] '2020-06-01'
	SET NOCOUNT ON;

	SET NOCOUNT ON;
	IF OBJECT_ID(N'tempdb..#MARGINACCOUNT_MTH') IS NOT NULL
	BEGIN
		DROP TABLE #MARGINACCOUNT_MTH;
	END

    -- Insert statements for procedure here
	--SELECT <@Param1, sysname, @p1>, <@Param2, sysname, @p2>

	CREATE TABLE #MARGINACCOUNT_MTH
	(
		RecordType		VARCHAR(1),
		POCode			VARCHAR(6),
		PositionDate	DATE,
		ClientID		VARCHAR(12),
		ClientName		VARCHAR(60),
		LimitValue		NUMERIC(15,2),
		OutstandingValue NUMERIC(15,2),
		EquityValue		NUMERIC(15,2)
	);
    -- Insert statements for procedure here

	INSERT INTO #MARGINACCOUNT_MTH
	(
		RecordType,
		POCode,
		PositionDate,
		ClientID,
		ClientName,
		LimitValue,
		OutstandingValue,
		EquityValue
	)

	SELECT 
		1,
		'012',
		CONVERT(varchar,@idteProcessDate,103) as [DD/MM/YYYY],
		Customer.[CustomerID (textinput-1)],
		Customer.[CustomerName (textinput-3)],
		(CASE WHEN [ApproveTradingLimit (textinput-54)] = '' THEN CAST ('0' AS NUMERIC(24,4)) ELSE Replace([ApproveTradingLimit (textinput-54)],',','') END ),--[ApprovedLimit (textinput-64)],
		TCRV.CustodyAssetsBalance,
		TM.Equity
		FROM CQBTEMPDB.EXPORT.TB_FORMDATA_1410 Customer
		INNER JOIN CQBTempDB.export.Tb_FormData_1409 Account 
			ON Customer.[CustomerID (textinput-1)] = Account.[CustomerID (selectsource-1)]
		LEFT JOIN GLOBALBORPT.[valuation].[Tb_CustodyAssetsRPValuationCollateralRpt] TCRV 
			ON Account.[AccountNumber (textinput-5)] = TCRV.AcctNo
		LEFT JOIN GLOBALBOMY.[margin].[Tb_MarginRptSummary] TM ON Account.[AccountNumber (textinput-5)] = TM.AcctNo
		WHERE
			Account.[AccountGroup (selectsource-2)] IN ('M','G');


	DECLARE @Count INT;
	SET @Count = (SELECT COUNT(*) FROM #MARGINACCOUNT_MTH);

	CREATE TABLE #MARGINACCOUNT_MTHControl
	(
		RecordType  varchar(50),
		CurrentApplicateDate Varchar(50),
		TotalRecord int
	);
	INSERT INTO #MARGINACCOUNT_MTHControl
	(
		RecordType,
		CurrentApplicateDate,
		TotalRecord
	)
	VALUES (0,CONVERT(VARCHAR,@idteProcessDate,103),@Count);

	-- CONTROL RECORD - RESULT SET
	SELECT 
		RecordType + ',' + CurrentApplicateDate +  ',' + CAST(TotalRecord AS VARCHAR)
	FROM
		#MARGINACCOUNT_MTHControl

	UNION ALL
	SELECT 
		CAST(RecordType AS VARCHAR) + ',' + POCode + ',' +  CONVERT(varchar,PositionDate,120) + ',' + ClientID + ',' 
		+ ',' + ClientName + ',' + CAST(LimitValue AS VARCHAR) + ',' + CAST(OutstandingValue AS VARCHAR) + ',' + CAST(EquityValue AS VARCHAR) 
	FROM #MARGINACCOUNT_MTH;

	DROP TABLE #MARGINACCOUNT_MTHControl;
	DROP TABLE #MARGINACCOUNT_MTH;

END