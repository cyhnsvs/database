/****** Object:  Procedure [export].[USP_ORMS_EIS_IORDER]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_ORMS_EIS_IORDER]
(
	@idteProcessDate DATE
)
AS
/*
Internet Orders
EXEC [export].[USP_ORMS_EIS_IORDER] '2020-05-27'
*/
BEGIN
	CREATE TABLE #Detail
	(
		 TradeDate			VARCHAR(10)			
		,BranchGroupingCode	VARCHAR(5)
		,InternetOrders		DECIMAL(9,0)
	)
	INSERT INTO #Detail
	(
		 TradeDate			
		,BranchGroupingCode	
		,InternetOrders		
	)
	SELECT
		 T.ContractDate
		,Branch.[BranchCode (textinput-42)]
		,SUM(ABS(TradedQty))
	FROM GlobalBO.transmanagement.Tb_TransactionsSettled	T
	--INNER JOIN 
	--	GlobalBOMY.import.Tb_AccountNoMapping AM ON T.AcctNo = AM.OldAccountNo 
	INNER JOIN CQBTempDB.export.Tb_FormData_1409 Account 
		ON Account.[AccountNumber (textinput-5)] = T.AcctNo
	INNER JOIN CQBTempDB.export.Tb_FormData_1377 Dealer 
		ON Dealer.[DealerCode (textinput-35)] = Account.[DealerCode (selectsource-21)]
	INNER JOIN CQBTempDB.export.Tb_FormData_1374 Branch 
		ON Dealer.[BranchID (selectsource-1)] = Branch.[BranchID (textinput-1)] 
	WHERE
		T.Channel = 'Online' AND T.ContractDate = @idteProcessDate
	GROUP BY
		T.ContractDate, Branch.[BranchCode (textinput-42)]

	UNION

	SELECT
		 T.TransDate
		,Branch.[BranchCode (textinput-42)]
		,SUM(ABS(TradedQty))
	FROM GlobalBO.transmanagement.Tb_Transactions	T
	--INNER JOIN 
	--	GlobalBOMY.import.Tb_AccountNoMapping AM ON T.AcctNo = AM.OldAccountNo 
	INNER JOIN CQBTempDB.export.Tb_FormData_1409 Account 
		ON Account.[AccountNumber (textinput-5)] = T.AcctNo
	INNER JOIN CQBTempDB.export.Tb_FormData_1377 Dealer 
		ON Dealer.[DealerCode (textinput-35)] = Account.[DealerCode (selectsource-21)]
	INNER JOIN CQBTempDB.export.Tb_FormData_1374 Branch 
		ON Dealer.[BranchID (selectsource-1)] = Branch.[BranchID (textinput-1)] 
	WHERE
		T.Channel = 'Online' AND T.TransDate = @idteProcessDate
	GROUP BY
		T.TransDate, Branch.[BranchCode (textinput-42)]
	UNION
	SELECT
		 T.ContractDate
		,Branch.[BranchCode (textinput-42)]
		,SUM(ABS(TradedQty))
	FROM GlobalBO.contracts.Tb_Contract	T
	INNER JOIN GlobalBOMY.import.Tb_AccountNoMapping AM 
		ON T.AcctNo = AM.OldAccountNo 
	INNER JOIN CQBTempDB.export.Tb_FormData_1409 Account 
		ON Account.[AccountNumber (textinput-5)] = AM.NewAccountNo
	INNER JOIN CQBTempDB.export.Tb_FormData_1377 Dealer 
		ON Dealer.[DealerCode (textinput-35)] = Account.[DealerCode (selectsource-21)]
	INNER JOIN CQBTempDB.export.Tb_FormData_1374 Branch 
		ON Dealer.[BranchID (selectsource-1)] = Branch.[BranchID (textinput-1)] 
	WHERE
		T.Channel = 'Online' AND T.ContractDate = @idteProcessDate
	GROUP BY
		T.ContractDate, Branch.[BranchCode (textinput-42)]
	UNION
	SELECT
		 T.ContractDate
		,Branch.[BranchCode (textinput-42)]
		,SUM(ABS(TradedQty))
	FROM GlobalBO.contracts.Tb_ContractOutstanding	T
	INNER JOIN GlobalBOMY.import.Tb_AccountNoMapping AM 
		ON T.AcctNo = AM.OldAccountNo 
	INNER JOIN CQBTempDB.export.Tb_FormData_1409 Account 
		ON Account.[AccountNumber (textinput-5)] = AM.NewAccountNo
	INNER JOIN CQBTempDB.export.Tb_FormData_1377 Dealer 
		ON Dealer.[DealerCode (textinput-35)] = Account.[DealerCode (selectsource-21)]
	INNER JOIN CQBTempDB.export.Tb_FormData_1374 Branch 
		ON Dealer.[BranchID (selectsource-1)] = Branch.[BranchID (textinput-1)] 
	WHERE
		T.Channel = 'Online' AND T.ContractDate = @idteProcessDate
	GROUP BY
		T.ContractDate, Branch.[BranchCode (textinput-42)]
		
	--RESULT SET
	SELECT 
		TradeDate + '|' + BranchGroupingCode + '|' + CAST(InternetOrders AS VARCHAR)
	FROM 
		#Detail

	DROP TABLE #Detail
END