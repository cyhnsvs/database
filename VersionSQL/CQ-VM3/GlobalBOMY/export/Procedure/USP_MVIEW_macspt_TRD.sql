/****** Object:  Procedure [export].[USP_MVIEW_macspt_TRD]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_MVIEW_macspt_TRD]
(
	@idteProcessDate DATETIME
)
AS
/*

EXEC [export].[USP_N2N_macspt_TRD] '2020-06-01'
*/
BEGIN
	
	-- BATCH DETAILS
	CREATE TABLE #Details
	(
		 RecordType	   CHAR(1)       
		,ClientCode	   CHAR(15)       
		,ClientName    CHAR(50) --need lenght 60      
		,OrderEntry    CHAR(14)       
		,TradeControl  CHAR(14)      
		
	)

	INSERT INTO #Details
	(
			 RecordType	  
			,ClientCode	  
			,ClientName   
			,OrderEntry   
			,TradeControl 
	)
	SELECT 
	
		    1
		   ,[AccountNumber (textinput-5)]
		   ,LEFT([CustomerName (textinput-3)],50) AS ClientName
		   ,[ShortSellInd (selectsource-19)]
		   ,127 + CASE WHEN [LEAP (selectbasic-29)] = 'Y' THEN 256 ELSE 0 END + CASE WHEN [ETFLI (multipleradiosinline-20)] = 'Y' THEN 1024 ELSE 0 END
		FROM 
		CQBTempDB.export.tb_formdata_1410 CUS
		INNER JOIN CQBTempDB.export.Tb_FormData_1409 ACC ON ACC.[CustomerID (selectsource-1)] = CUS.[CustomerID (textinput-1)]
	
	-- BATCH TRAILER

	DECLARE @Count INT
	SET @Count = (SELECT COUNT(*) FROM #Details)

	CREATE TABLE #ControlRecord
	(
		 RecordType			CHAR(1)
		,TotalNumberRecord	CHAR(13)
		,ProcessingDate		CHAR(11)
	)
	INSERT INTO #ControlRecord
	(
		 RecordType			
		,TotalNumberRecord	
		,ProcessingDate		
	)
	VALUES(0,RIGHT(REPLICATE('0',13)+CAST(@Count as varchar(13)),13),FORMAT(CAST(@idteProcessDate AS DATE),'yyyyMMdd')) 
		
	SELECT 
		RecordType	+ '|' +  ClientCode + '|' +  ClientName + '|' +  OrderEntry + '|' +  TradeControl 
	FROM 
		#Details

		UNION ALL
    -- CONTROL RECORD - RESULT SET
	SELECT 
		 RecordType	+ '|' +  TotalNumberRecord	+ '|' +  ProcessingDate		
	FROM 
		#ControlRecord
	
END