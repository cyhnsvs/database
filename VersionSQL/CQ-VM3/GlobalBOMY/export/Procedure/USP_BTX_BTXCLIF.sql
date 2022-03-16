/****** Object:  Procedure [export].[USP_BTX_BTXCLIF]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_BTX_BTXCLIF]
(
	@idteProcessDate DATETIME
)
AS
/*
CLIENT INFO
EXEC [export].[USP_BTX_BTXCLIF] '2020-06-01'
*/
BEGIN
	-- BATCH HEADER
	CREATE TABLE #Header
	(
		 RecordType		 CHAR(1)
		,HeaderDate		 CHAR(16)
		,Filler1		 CHAR(3)
		,InterfaceID	 CHAR(10)
		,Filler2		 CHAR(3)
		,SystemID		 CHAR(15)
		,Filler3		 CHAR(1097)
		,LastPosition	 CHAR(1)
	);
	INSERT INTO #Header
	(
		 RecordType	
		,HeaderDate	
		,Filler1	
		,InterfaceID
		,Filler2	
		,SystemID	
		,Filler3	
		,LastPosition
	)
	VALUES ('H',FORMAT(CAST(@idteProcessDate AS DATE),'yyyyMMdd') + CONVERT(VARCHAR(8),@idteProcessDate,108),'','BTXCLIF','','BOS','','T');
	
	-- BATCH DETAILS
	CREATE TABLE #Detail
	(
		 RecordType				CHAR(1)
		,NewICNo				CHAR(30)
		,OldICNo				CHAR(30)
		,DOB					CHAR(10)
		,AccountCode			CHAR(15)
		,GCIF					CHAR(20)
		,ClientName				CHAR(255)
		,TelPhNo				CHAR(50)
		,MobileNo				CHAR(50)
		,OfficeNo				CHAR(50)
		,FaxNo					CHAR(50)
		,[Address]				CHAR(250)
		,Race					CHAR(50)
		,CountryCode			CHAR(5)
		,Bumiputera				CHAR(1)
		,Email					CHAR(255)
		,BranchCode				CHAR(3)
		,Gender					CHAR(1)
		,Filler					CHAR(19)
		,LastPosition			CHAR(1)
	);
	INSERT INTO #Detail
	(
		 RecordType		
		,NewICNo		
		,OldICNo		
		,DOB			
		,AccountCode	
		,GCIF			
		,ClientName		
		,TelPhNo		
		,MobileNo		
		,OfficeNo		
		,FaxNo			
		,[Address]		
		,Race			
		,CountryCode	
		,Bumiputera		
		,Email			
		,BranchCode		
		,Gender			
		,Filler			
		,LastPosition		
	)
	SELECT 
		1,
		[IDNumber (textinput-5)],
		[AlternateIDNumber (textinput-6)],
		CONVERT(CHAR(8),REPLACE([DateofBirth (dateinput-1)],'-',''),105),
		Account.[AccountNumber (textinput-5)],
		[IDNumber (textinput-5)],
		[CustomerName (textinput-3)],
		Customer.[PhoneHouse (textinput-55)],
		[PhoneMobile (textinput-57)],
		[PhoneOffice (textinput-17)],
		'',
		[Address1 (textinput-35)] + [Address2 (textinput-36)] + [Address3 (textinput-37)] + [Town (textinput-38)] + [Postcode (textinput-40)],
		[Race (selectsource-3)],
		[CountryofResidence (selectsource-5)],
		[BumiputraStatus (multipleradiosinline-1)],
		[Email (textinput-58)],
		A.BranchId,
		[Gender (selectbasic-1)],
		'',
		'T'
	FROM CQBTempDB.export.Tb_FormData_1409	Account
	INNER JOIN CQBTempDB.export.Tb_FormData_1410 Customer 
		ON Account.[CustomerID (selectsource-1)] = Customer.[CustomerID (textinput-1)]
	INNER JOIN GlobalBO.setup.Tb_Account A 
		ON Account.[AccountNumber (textinput-5)] = A.AcctNo;

	-- BATCH TRAILER

	DECLARE @Count INT
	SET @Count = (SELECT COUNT(*) FROM #Detail)
	CREATE TABLE #Trailer
	(
		 RecordType			CHAR(1)
		,TrailerCount		CHAR(13)
		,ProcessingDate		CHAR(8)
		,HASHTotal			CHAR(13)
		,Filler				CHAR(1110)
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
		RecordType + HeaderDate + Filler1 + InterfaceID + Filler2 + SystemID + Filler3 + LastPosition
	FROM #Header
	UNION ALL
	SELECT 
		RecordType + NewICNo + OldICNo + DOB + AccountCode + GCIF + ClientName + TelPhNo + MobileNo + OfficeNo + FaxNo + [Address] + Race + CountryCode
		+ Bumiputera + Email + BranchCode + Gender + Filler + LastPosition
	FROM #Detail
	UNION ALL
	SELECT 
		RecordType + TrailerCount +	ProcessingDate + HASHTotal + Filler + LastPosition
	FROM #Trailer;

	DROP TABLE #Header;
	DROP TABLE #Detail;
	DROP TABLE #Trailer;

END