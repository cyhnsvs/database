/****** Object:  Procedure [export].[USP_BTX_BTXCDSO]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_BTX_BTXCDSO]
(
	@idteProcessDate DATETIME
)
AS
/* 
Daily Setoff Info Export to BTX SubSystem
EXEC [export].[USP_BTX_BTXCDSO] '2020-06-01'
*/
BEGIN
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
		,Filler3		 CHAR(87)
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
	VALUES ('H',FORMAT(CAST(@idteProcessDate AS DATE),'yyyyMMdd') , CONVERT(VARCHAR(8),@idteProcessDate,108),'','BTXCDSO','','BOS','','T');
	
	-- BATCH DETAILS
	CREATE TABLE #Detail
	(
		 RecordType				CHAR(1)
		,BranchCode				CHAR(3)
		,ClientCode				CHAR(15)
		,BFETradingCode			CHAR(9)
		,TransNo				CHAR(30)
		,TransDate				CHAR(10)
		,Amount					CHAR(16)
		,TransType				CHAR(1)
		,DueDate				CHAR(10)
		,OSAmount				CHAR(16)
		,IntAmount				CHAR(16)
		,Currency				CHAR(5)
		,Filler					CHAR(3)
		,LastPosition			CHAR(1)
	);

	INSERT INTO #Detail
	(
		 RecordType			
		,BranchCode			
		,ClientCode			
		,BFETradingCode		
		,TransNo			
		,TransDate			
		,Amount				
		,TransType			
		,DueDate			
		,OSAmount			
		,IntAmount			
		,Currency			
		,Filler				
		,LastPosition		
	)
	SELECT 
		1,
		BranchId,
		A.AcctNo,
		A.AcctNo,
		T.CloseOutRef,
		CONVERT(CHAR(10),T.CreatedDate,112),
		CASE WHEN U.TransType = 'TRBUY'
			 THEN RIGHT(REPLICATE('0',16)+CAST(CAST((SetoffAmount + SetoffInterest) AS DECIMAL(16,2)) AS VARCHAR(16)),16)
			 ELSE RIGHT(REPLICATE('0',16)+CAST(CAST(SetoffInterest AS DECIMAL(16,2)) AS VARCHAR(16)),16)
		END,
		CASE WHEN U.TransType = 'SCHGN'
			 THEN 'H'
			 WHEN U.TransType = 'SCHLS'
			 THEN 'M'
			 WHEN U.TransType = 'TRBUY'
			 THEN 'D'
			 ELSE 'C'
		END,
		CONVERT(CHAR(10),S.SetlDate,112),
		RIGHT(REPLICATE('0',16)+CAST(CAST(U.NetAmountSetl AS DECIMAL(16,2)) AS VARCHAR(16)),16),
		RIGHT(REPLICATE('0',16)+CAST(CAST(SetOffInterest AS DECIMAL(16,2)) AS VARCHAR(16)),16),
		S.SetlCurrCd,
		'',
		'T'
	FROM GlobalBOLocal.RPS.Tb_SetOffTransaction	S
	INNER JOIN GlobalBOLocal.transmanagement.Tb_TransactionsSettledPaid T 
		ON S.TransReference LIKE '%' +T.ContractNo+'%'
	INNER JOIN GlobalBOLocal.transmanagement.Tb_TransactionsSettledUnpaid U 
		ON T.CloseOutRef = U.ContractNo
	INNER JOIN GlobalBO.setup.Tb_Account A 
		ON A.AcctNo =  T.AcctNo
	INNER JOIN GlobalBO.setup.Tb_Instrument I 
		ON T.InstrumentId =  I.InstrumentId
	WHERE (CASE WHEN S.ModifiedOn IS NULL THEN S.CreatedOn ELSE S.ModifiedOn END) = @idteProcessDate;
		
	
	-- BATCH TRAILER

	DECLARE @Count INT;
	SET @Count = (SELECT COUNT(*) FROM #Detail);
	CREATE TABLE #Trailer
	(
		 RecordType			CHAR(1)
		,TrailerCount		CHAR(13)
		,ProcessingDate		CHAR(8)
		,HASHTotal			CHAR(13)
		,Filler				CHAR(100)
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
	VALUES(0,RIGHT(REPLICATE('0',13)+CAST(@Count as varchar(13)),13),FORMAT(CAST(@idteProcessDate AS DATE),'yyyyMMdd'),RIGHT(REPLICATE('0',13)+CAST(@Count as varchar(13)),13),'','T');
		
	-- RESULT SET
	SELECT 
		RecordType + HeaderDate + HeaderTime + Filler1 + InterfaceID + Filler2 + SystemID + Filler3 + LastPosition
	FROM #Header
	UNION ALL
	SELECT 
		RecordType + BranchCode + ClientCode + BFETradingCode + TransNo + TransDate + Amount + TransType + DueDate + OSAmount + IntAmount
		+ Currency + Filler + LastPosition
	FROM #Detail
	UNION ALL
	SELECT 
		RecordType + TrailerCount +	ProcessingDate + HASHTotal + Filler + LastPosition
	FROM #Trailer;

	DROP TABLE #Header;
	DROP TABLE #Detail;
	DROP TABLE #Trailer;

END