/****** Object:  Procedure [export].[USP_ORMS_DT_CSH]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_ORMS_DT_CSH]
(
	@idteProcessDate DATE
)
	
AS
--EXEC [export].[USP_ORMS_DT_CSH] '2020-06-01'
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @idtePreviousBusinessDate AS DATE,
			@idteNextBusinessDate AS DATE

	SET @idtePreviousBusinessDate = (SELECT PreviousBusinessDate FROM GlobalBO.global.Udf_GetPreviousBusinessDate(@idteProcessDate))
	SET @idteNextBusinessDate = (SELECT NextBusinessDate FROM GlobalBO.global.Udf_GetNextBusinessDate(@idteProcessDate))
	
	--declare @idteProcessDate date = '2021-07-30'

	SELECT *
	INTO #DTAccounts
	FROM GlobalBO.setup.Tb_Account
	WHERE ServiceType IN ('CD1','CD2','CD3','CE1','CE2','CE3');

	CREATE TABLE #CashMovement
	(
		RecordType           VARCHAR(1),
		TradingAccountNumber VARCHAR(10),
		TrxRef				 VARCHAR(13),
		TrxRefSX			 VARCHAR(3),
		TrxRefSVS			 VARCHAR(3),
		ATrxRef				 VARCHAR(10),
		ATrxRefSX			 VARCHAR(3),
		ATrxRefVS			 VARCHAR(3),
		CurAppDt			 VARCHAR(10),
		TransDate			 VARCHAR(10),
		NetAmount			 DECIMAL(15,2),
		CancelIndicator		 VARCHAR(1),
		ChargeCode			 VARCHAR(3)
	);

	INSERT INTO #CashMovement
	(
		RecordType,
		TradingAccountNumber,
		TrxRef,
		TrxRefSVS,
		TrxRefSX,
		ATrxRef,
		ATrxRefVS,
		ATrxRefSX,
		CurAppDt,
		TransDate,
		NetAmount,
		CancelIndicator,
		ChargeCode			 	
	)

	-- CONTRACTS
	SELECT 
		1,
		C.AcctNo,
		CASE WHEN C.NetAmountSetl < 0
		     THEN 'WC ' + C.ContractNo
			 ELSE 'BF ' + REPLACE(CONVERT(VARCHAR,@idteProcessDate, 105),'-','') 
		END,
		0,
		'',
		'',
		0,
		'',
		CONVERT(varchar,@idteProcessDate,120),
		CONVERT(varchar,C.ContractDate,120),
		C.NetAmountSetl,
		(CASE 
			WHEN C.ContractAmendNo=0 
			THEN 'N' 
			WHEN C.ContractAmendNo!=0 
			THEN 'Y' 
		END) AS CancelIndicator,		
		''
	FROM GlobalBO.contracts.Tb_Contract C

 UNION
	-- CASH BALANCE CARRY FORWARD 
	SELECT 
		1,
		C.AcctNo,		
		'BF ' + CONVERT(VARCHAR,@idteNextBusinessDate, 105),		
		0,
		'',
		'',
		0,
		'',
		CONVERT(varchar,@idteProcessDate,120),
		CONVERT(varchar,C.ContractDate,120),
		SUM(Cash.CashBalance + C.NetAmountSetl),
		(CASE WHEN C.ContractAmendNo=0 THEN 'N' WHEN C.ContractAmendNo!=0 THEN 'Y' END) AS CancelIndicator,
		''
	FROM GlobalBO.contracts.Tb_Contract C
	INNER JOIN GlobalBORpt.valuation.Tb_CashRPValuationCollateralRpt Cash 
		ON Cash.AcctNo = C.AcctNo AND Cash.BusinessDate = @idtePreviousBusinessDate
	--INNER JOIN
	--	CQBTempDB.export.Tb_FormData_1409 Account ON AM.NewAccountNo = Account.[AccountNumber (textinput-5)]
	GROUP BY C.AcctNo,ContractDate,C.TransType,C.ContractAmendNo

	UNION

	-- UNSETTLED CONTRACTS
	SELECT 
		1,
		C.AcctNo,
		CASE WHEN C.NetAmountSetl < 0
		     THEN 'WC ' + C.ContractNo
			 ELSE 'BF ' + REPLACE(CONVERT(VARCHAR,@idteProcessDate, 105),'-','') 
		END,
		0,
		'',
		'',
		0,
		'',
		CONVERT(varchar,@idteProcessDate,120),
		CONVERT(varchar,C.ContractDate,120),
		C.NetAmountSetl,
		(CASE 
			WHEN C.ContractAmendNo=0 
			THEN 'N' 
			WHEN C.ContractAmendNo!=0 
			THEN 'Y' 
		END) AS CancelIndicator,			
		'0'
	FROM GlobalBO.contracts.Tb_ContractOutStanding C
	
	UNION

	-- CASH BALANCE CARRY FORWARD 
	SELECT 
		1,
		C.AcctNo,		
		'BF ' + CONVERT(VARCHAR,@idteNextBusinessDate, 105),		
		0,
		'',
		'',
		0,
		'',
		CONVERT(varchar,@idteProcessDate,120),
		CONVERT(varchar,C.ContractDate,120),
		SUM(Cash.CashBalance + C.NetAmountSetl),
		(CASE 
			WHEN C.ContractAmendNo=0 
			THEN 'N'
			WHEN C.ContractAmendNo!=0 
			THEN 'Y' 
		END) AS CancelIndicator,
		'0'
	FROM GlobalBO.contracts.Tb_ContractOutStanding C
	INNER JOIN GlobalBORpt.valuation.Tb_CashRPValuationCollateralRpt Cash 
		ON Cash.AcctNo = C.AcctNo AND Cash.BusinessDate = @idtePreviousBusinessDate
	GROUP BY C.AcctNo,ContractDate,C.TransType,C.ContractAmendNo

	UNION
	-- SETTLED TRANSACTIONS
	SELECT 
		1,
		C.AcctNo,
		CASE WHEN C.NetAmountSetl < 0
		     THEN 'WC ' + RIGHT(C.ContractNo,10)
			 ELSE 'BF ' + REPLACE(CONVERT(VARCHAR,@idteProcessDate, 105),'-','') 
		END,
		0,
		'',
		'',
		0,
		'',
		CONVERT(varchar,@idteProcessDate,120),
		CONVERT(varchar,C.ContractDate,120),
		C.NetAmountSetl,
		(CASE 
			WHEN C.ContractAmendNo=0 
			THEN 'N' 
			WHEN C.ContractAmendNo!=0 
			THEN 'Y' 
		END) AS CancelIndicator,		
		'0'
	FROM GlobalBO.transmanagement.Tb_TransactionsSettled C
	
	UNION

	-- CASH BALANCE CARRY FORWARD 
	SELECT 
		1,
		C.AcctNo,		
		'BF ' + CONVERT(VARCHAR,@idteNextBusinessDate, 105),		
		0,
		'',
		'',
		0,
		'',
		CONVERT(varchar,@idteProcessDate,120),
		CONVERT(varchar,C.ContractDate,120),
		SUM(Cash.CashBalance + C.NetAmountSetl),
		(CASE 
			WHEN C.ContractAmendNo=0 
			THEN 'N' 
			WHEN C.ContractAmendNo!=0 
			THEN 'Y' 
		END) AS CancelIndicator,	
		'0'
	FROM GlobalBO.transmanagement.Tb_TransactionsSettled C
	INNER JOIN GlobalBORpt.valuation.Tb_CashRPValuationCollateralRpt Cash 
		ON Cash.AcctNo = C.AcctNo AND Cash.BusinessDate = @idtePreviousBusinessDate
	GROUP BY C.AcctNo,ContractDate,C.TransType,C.ContractAmendNo

	UNION

	-- TRANSACTIONS
	SELECT 
		1,
		C.AcctNo,
		CASE WHEN Amount < 0
		     THEN 'WC ' + RIGHT(C.TransNo,10)
			 ELSE 'BF ' + REPLACE(CONVERT(VARCHAR,@idteProcessDate, 105),'-','') 
		END,
		0,
		'',
		'',
		0,
		'',
		CONVERT(varchar,@idteProcessDate,120),
		CONVERT(varchar,C.TransDate,120),
		C.Amount,
		'N',--(CASE WHEN C.ContractAmendNo=0 THEN 'N' WHEN C.ContractAmendNo!=0 THEN 'Y' END) AS CancelIndicator,	
		'0'
	FROM GlobalBO.transmanagement.Tb_Transactions C
	
	UNION
	
	-- CASH BALANCE CARRY FORWARD 
	SELECT 
		1,
		C.AcctNo,		
		'BF ' + CONVERT(VARCHAR,@idteNextBusinessDate, 105),		
		0,
		'',
		'',
		0,
		'',
		CONVERT(varchar,@idteProcessDate,120),
		CONVERT(varchar,C.TransDate,120),
		SUM(Cash.CashBalance + C.Amount),
		'N',--(CASE WHEN C.ContractAmendNo=0 THEN 'N' WHEN C.ContractAmendNo!=0 THEN 'Y' END) AS CancelIndicator,	
		'0'
	FROM GlobalBO.transmanagement.Tb_Transactions C
	INNER JOIN GlobalBORpt.valuation.Tb_CashRPValuationCollateralRpt Cash 
		ON Cash.AcctNo = C.AcctNo AND Cash.BusinessDate = @idtePreviousBusinessDate
	GROUP BY C.AcctNo,TransDate,C.TransType

	-- CONTROL RECORD 
	DECLARE @Count INT
	SET @Count = (SELECT COUNT(*) FROM #CashMovement)

	DECLARE @TotalNetAmount DECIMAL(15,2)
	SET @TotalNetAmount = (SELECT SUM(NetAmount) FROM #CashMovement)
	
	CREATE TABLE #CashMovementControl
	(
		RecordType  VARCHAR(1),
		CurrentApplicateDate VARCHAR(10),
		TotalRecord INT,
		TotalNetAmount DECIMAL(15,2)
	);

	INSERT INTO #CashMovementControl
	(
		RecordType,
		CurrentApplicateDate,
		TotalRecord,
		TotalNetAmount
	)
	VALUES (0,CONVERT(VARCHAR,@idteProcessDate,105),@Count,@TotalNetAmount);


	-- TRANSACTION RECORD - RESULT SET

	SELECT 
		RecordType + '|' + TradingAccountNumber + '|' +  TrxRef + '|' + CASE WHEN TrxRefSVS=0 THEN '' ELSE CAST(TrxRefSVS AS VARCHAR) END + '|' +  TrxRefSX + '|' +  ATrxRef + '|' +  
		CASE WHEN ATrxRefVS=0 THEN '' ELSE CAST(ATrxRefVS AS VARCHAR) END + '|' +  ATrxRefSX + '|' + CurAppDt + '|' + TransDate + '|' + CAST(NetAmount AS VARCHAR) + '|' + CancelIndicator + '|' + ChargeCode
	FROM #CashMovement	
	
	UNION ALL
	-- CONTROL RECORD - RESULT SET
	SELECT 
		RecordType + '|' + CONVERT(varchar,CurrentApplicateDate,120) +  '|' + CAST(TotalRecord AS VARCHAR) + '|' + CAST(TotalNetAmount AS VARCHAR)
	FROM #CashMovementControl
	
	DROP TABLE #DTAccounts;
	DROP TABLE #CashMovement;
	DROP TABLE #CashMovementControl;

END