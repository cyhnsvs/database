/****** Object:  Procedure [import].[Usp_FileToForm_Withdraw_Response]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [import].[Usp_FileToForm_Withdraw_Response]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ROWCOUNT BIGINT;

	SET @ROWCOUNT = (select count(*) FROM [GLOBALBO].[transmanagement].[Tb_Transactions] TTC
	LEFT JOIN [GLOBALBO].[transmanagement].[Tb_TransactionsRejected] TTR ON TTR.AcctNo = TTC.AcctNo
	WHERE	
		TTR.AcctNo IS NULL)

	CREATE TABLE #CashWithdraw
	(
		RecordType	CHAR(1),
		TransactionDate		VARCHAR(MAX),
		TransactionNo		VARCHAR(MAX),
		TransactionType VARCHAR(MAX),
		AccountNo	VARCHAR(MAX),
		[Status]	VARCHAR(MAX),
		Rmarks VARCHAR(MAX)
	)

	IF (@ROWCOUNT = 0 )
	BEGIN
	---INSERT STATEMENT FOR SUCCESS 
	INSERT INTO #CashWithdraw
	(
		 RecordType,
		 TransactionDate,
		 TransactionNo,
		 TransactionType,
		 AccountNo,
		 [Status],
		 Rmarks
	)
	SELECT
	'1' AS RecordType,
	TR.TransDate AS TransactionDate,
	TR.TransNo AS TransactionNo,
	TR.TransType AS TransactionType,
	TR.AcctNo AS AccountNo,
	'' AS [Status],
	'' AS Rmarks
	FROM [GLOBALBO].[transmanagement].[Tb_Transactions] AS TR 

	END

	ELSE
	BEGIN
	-- INSERT STATEMENT FOR FAILURE

		INSERT INTO #CashWithdraw
	(
		 RecordType,
		 TransactionDate,
		 TransactionNo,
		 TransactionType,
		 AccountNo,
		 [Status],
		 Rmarks
	)
	SELECT
	'1' AS RecordType,
	TR.TransDate AS TransactionDate,
	TR.TransNo AS TransactionNo,
	TR.TransType AS TransactionType,
	TR.AcctNo AS AccountNo,
	'R' AS [Status],
	'' AS Rmarks
	FROM [GLOBALBO].[transmanagement].[Tb_Transactions] AS TR 

	END

	SELECT * FROM #CashWithdraw

    
END