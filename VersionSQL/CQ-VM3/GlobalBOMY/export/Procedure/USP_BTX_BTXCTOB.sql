/****** Object:  Procedure [export].[USP_BTX_BTXCTOB]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_BTX_BTXCTOB]
(
	@idteProcessDate DATETIME
)
AS
/*
TurnOver and Brokerage by Client
EXEC [export].[USP_BTX_BTXCTOB] '2020-06-01'
*/
BEGIN
	DECLARE @idteMonthStart DATE = DATEADD(mm, DATEDIFF(mm, 0, @idteProcessDate), 0);
	DECLARE @idteMonthEnd DATE = DATEADD (dd, -1, DATEADD(mm, DATEDIFF(mm, 0, @idteProcessDate) + 1, 0));
	
	-- BATCH HEADER
	CREATE TABLE #Header
	(
		 RecordType		 CHAR(1)
		,HeaderDate		 CHAR(8)
		,HeaderTime		 CHAR(8)
		,Filler1		 CHAR(3)
		,InterfaceID	 CHAR(10)
		,Filler2		 CHAR(3)
		,SystemID		 CHAR(15)
		,Filler3		 CHAR(22)
		,LastPosition	 CHAR(1)
	);
	INSERT INTO #Header
	(
		 RecordType	
		,HeaderDate	
		,HeaderTime	
		,Filler1	
		,InterfaceID
		,Filler2	
		,SystemID	
		,Filler3	
		,LastPosition
	)
	VALUES ('H',FORMAT(CAST(@idteProcessDate AS DATE),'yyyyMMdd') , CONVERT(VARCHAR(8),@idteProcessDate,108),'','BTXEF','','BOS','','T');
	
	-- BATCH DETAILS
	CREATE TABLE #Detail
	(
		 RecordType				CHAR(1)
		,BranchCode				CHAR(3)
		,ClientCode				CHAR(15)
		,BFETradingCode			CHAR(9)
		,[Year]					CHAR(4)
		,[Month]				CHAR(2)
		,Turnover				DECIMAL(16,2)
		,Brokerage				DECIMAL(16,2)
		,[Source]				CHAR(1) 
		,Filler					CHAR(3)
		,LastPosition			CHAR(1)
	);
	INSERT INTO #Detail
	(
		 RecordType		
		,BranchCode		
		,ClientCode		
		,BFETradingCode	
		,[Year]			
		,[Month]		
		,Turnover		
		,Brokerage		
		,[Source]		
		,Filler			
		,LastPosition	
	)
	SELECT 
		1,
		BranchId,
		A.AcctNo,
		A.AcctNo,
		YEAR(@idteProcessDate),
		MONTH(@idteProcessDate),
		SUM(T.NetAmountSetl),
		SUM(T.ClientBrokerageSetl),
		CASE WHEN T.Channel = 'Online'
			 THEN 'I'
			 ELSE 'P'
		END,
		'',
		'T'
	FROM GlobalBO.setup.Tb_Account A
	INNER JOIN GlobalBO.transmanagement.Tb_TransactionsSettled T 
		ON T.AcctNo = A.AcctNo AND T.ContractDate BETWEEN DATEADD(MONTH, -2, @idteMonthEnd) AND @idteMonthEnd
	--WHERE 
	--	T.TransType  IN ('TRBUY','TRSELL')
	GROUP BY Channel,A.AcctNo,BranchId;


	-- BATCH TRAILER

	DECLARE @Count INT;
	SET @Count = (SELECT COUNT(*) FROM #Detail);
	CREATE TABLE #Trailer
	(
		 RecordType			CHAR(1)
		,TrailerCount		CHAR(13)
		,ProcessingDate		CHAR(8)
		,HASHTotal			CHAR(13)
		,Filler				CHAR(35)
		,LastPosition		CHAR(1)
	);
	INSERT INTO #Trailer
	(
		 RecordType		
		,TrailerCount	
		,ProcessingDate	
		,HASHTotal		
		,Filler			
		,LastPosition	
	)
	VALUES(0,RIGHT(REPLICATE('0',13) + CAST(@Count AS VARCHAR),13),FORMAT(CAST(@idteProcessDate AS DATE),'yyyyMMdd'),RIGHT(REPLICATE('0',13) + CAST(@Count AS VARCHAR),13),'','T') 
		
	-- RESULT SET
	SELECT 
		RecordType + HeaderDate + HeaderTime + Filler1 + InterfaceID + Filler2 + SystemID + Filler3 + LastPosition
	FROM #Header
	UNION ALL
	SELECT 
		RecordType + BranchCode + ClientCode + BFETradingCode + [Year] + [Month] + RIGHT(REPLICATE('0',16) + CAST(Turnover AS VARCHAR),16) + RIGHT(REPLICATE('0',16) + CAST(Brokerage AS VARCHAR),16) + [Source] + Filler + LastPosition
	FROM #Detail
	UNION ALL
	SELECT 
		RecordType + TrailerCount +	ProcessingDate + HASHTotal + Filler + LastPosition
	FROM #Trailer;

	DROP TABLE #Header;
	DROP TABLE #Detail;
	DROP TABLE #Trailer;

END