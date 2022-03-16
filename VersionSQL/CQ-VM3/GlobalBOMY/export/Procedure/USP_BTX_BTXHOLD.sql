/****** Object:  Procedure [export].[USP_BTX_BTXHOLD]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_BTX_BTXHOLD]
(
	@idteProcessDate DATETIME
)
AS
/*
HOLIDAY INFO
EXEC [export].[USP_BTX_BTXHOLD] '2020-06-01'
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
		,Filler3		 CHAR(27)
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
	VALUES ('H',FORMAT(CAST(@idteProcessDate AS DATE),'yyyyMMdd'),CONVERT(VARCHAR(8),@idteProcessDate,108),'','BTXEF','','BOS','','T');
	
	-- BATCH DETAILS
	CREATE TABLE #Detail
	(
		 RecordType				CHAR(1)
		,HolidayDate			CHAR(10)
		,HolidayDesc			CHAR(50)
		,[Type]					CHAR(1)
		,ExchCode				CHAR(10)
		,Filler					CHAR(3)
		,LastPosition			CHAR(1)
	);

	INSERT INTO #Detail
	(
		 RecordType	
		,HolidayDate
		,HolidayDesc
		,[Type]		
		,ExchCode	
		,Filler		
		,LastPosition
	)
	SELECT 
		1,
		CONVERT(CHAR(10),CalendarDate,112),
		Remarks,
		CASE WHEN TradingInd ='F'
		     THEN 'N'
			 ELSE 'T'
		END,
		E.ExchCd,
		'',
		'T'
	FROM GlobalBO.setup.Tb_CalendarDate CD
	INNER JOIN GlobalBO.setup.Tb_Calendar C 
		On CD.CalendarId = C.CalendarId
	INNER JOIN GlobalBO.setup.Tb_Exchange E 
		ON C.CalendarCd = E.CountryCd
	WHERE C.CalendarCd = 'MY';
	
	-- BATCH TRAILER

	DECLARE @Count INT;
	SET @Count = (SELECT COUNT(*) FROM #Detail);
	CREATE TABLE #Trailer
	(
		 RecordType			CHAR(1)
		,TrailerCount		CHAR(13)
		,ProcessingDate		CHAR(8)
		,HASHTotal			CHAR(13)
		,Filler				CHAR(40)
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
		RecordType + HolidayDate + HolidayDesc + [Type] + ExchCode +  Filler + LastPosition
	FROM #Detail
	UNION ALL
	SELECT 
		RecordType + TrailerCount +	ProcessingDate + HASHTotal + Filler + LastPosition
	FROM #Trailer;

	DROP TABLE #Header;
	DROP TABLE #Detail;
	DROP TABLE #Trailer;

END