/****** Object:  Procedure [Queue].[AddMessageToOutBoundQueue]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [Queue].[AddMessageToOutBoundQueue] (
	@JsonMessageData [varchar](max)
	,@MsgType [varchar](50)
	)
AS
/*********************************************************************************** 

Created By        : 
Created Date      : 
Last Updated Date : 
Description       : To insert the message to outbound queue table

*	Modification History :
*	ModifiedBy :      Project UIN :        ModifiedDate :    Reason :
*	
*	Has been modified by [who] + [date] + [Project UIN] + [notes]:
*     
 	
PARAMETERS 

************************************************************************************/ 
BEGIN
SET NOCOUNT ON;

BEGIN TRY
	Declare 
@Protocol_STX char(1)=2, --<STX>
@Record_Type char(1)='U', --U / I
@Market_Type char(1)='R', --R - Ready, C - Cash, G - General, T - Test, D - Demo
@Message_Type char(2)='',
@Message_Status_Code char(2)='00',
@Data_Content Nvarchar(4000)='',
@Protocol_ETX char(1)=3 --<ETX>


	
	if (@MsgType ='601')	--UserInformation
	begin
	SET @Message_Type = 'B1';

	INSERT INTO [Queue].[MBMSOutBound] ([MessageData],[Status])
	select 
	'#~'+ @Protocol_STX
	+'|'+ @Record_Type 		
	+'|'+  @Market_Type 		
	+'|'+  @Message_Type 		
	+'|'+  @Message_Status_Code + 
	+'|#~'+'30'+'|#~'+'032'+'|601'										
	+'|#~'+'31'+'|#~'+'130'+'|##QUEUE_ID##'
	+'|#~'+'31'+'|#~'+'131'+'|'+		RIGHT(REPLICATE('0',2) + CAST(ServerID as varchar(2) ),2) 
	+'|#~'+'31'+'|#~'+'186'+'|'+		RIGHT(REPLICATE('0',3) + CAST(BranchID as varchar(3) ),3)
	+'|#~'+'31'+'|#~'+'123'+'|'+		RIGHT(REPLICATE('0',5) + CAST(UserID as varchar(5) ),5)
	+'|#~'+'31'+'|#~'+'133'+'|'+		CAST(UserShortName as varchar(10) )	
	+'|#~'+'31'+'|#~'+'134'+'|'+		CAST(UserName as varchar(30) )	
	+'|#~'+'31'+'|#~'+'135'+'|'+		CAST(UserAddress as varchar(160) )	
	+'|#~'+'31'+'|#~'+'100'+'|'+		CAST(UserICNumber as varchar(14) )	
	+'|#~'+'31'+'|#~'+'136'+'|'+		CAST(UserType as varchar(01) )	
	+'|#~'+'31'+'|#~'+'137'+'|'+		CAST(ShortSellingTradingAllowed as varchar(01) )	
	+'|#~'+'31'+'|#~'+'045'+'|'+		CAST(DealerCode as varchar(03) )	
	+ '|#~' + @Protocol_ETX as Msg,
	9 as [Status]
	FROM OPENJSON(@JsonMessageData)
	WITH (
	ServerID  decimal (02)
	,BranchID  decimal (03)
	,UserID  decimal (05)
	,UserShortName  varchar (10)
	,UserName  varchar (30)
	,UserAddress  varchar (160)
	,UserICNumber  varchar (14)
	,UserType  varchar (01)
	,ShortSellingTradingAllowed  decimal (01)
	,DealerCode  varchar (03)
	) 
	end

	else if (@MsgType ='602')	--ClientInformation
	begin
	SET @Message_Type = 'B2';

	INSERT INTO [Queue].[MBMSOutBound] ([MessageData],[Status])
	select 
	'#~' + @Protocol_STX
	+  '|' + @Record_Type 		
	+  '|' +  @Market_Type 		
	+  '|' +  @Message_Type 		
	+  '|' +  @Message_Status_Code + 
	+ '|#~' + '30' + '|#~' +'032'  + '|602'										
	+ '|#~' + '31' + '|#~' +'130'  + '|##QUEUE_ID##'
	+'|#~'+'31'+'|#~'+'051'+'|'+		CAST(ISNULL(A.[textinput-5],'') as varchar(09) )	--ClientNumber
	+'|#~'+'31'+'|#~'+'133'+'|'+		CAST(ISNULL(A.[textinput-5],'') as varchar(10) )	--ClientShortName
	+'|#~'+'31'+'|#~'+'098'+'|'+		CAST(ClientName as varchar(30) )	
	+'|#~'+'31'+'|#~'+'135'+'|'+		CAST(ClientAddress as varchar(160) )	
	+'|#~'+'31'+'|#~'+'150'+'|'+		CAST(TelephoneNumber as varchar(12) )	
	+'|#~'+'31'+'|#~'+'047'+'|'+		RIGHT(REPLICATE('0',9) + CAST(ISNULL(A.[textinput-19],'') as varchar(09) ),9)
	+'|#~'+'31'+'|#~'+'100'+'|'+		CAST(ClientICNumber as varchar(14) )	
	+'|#~'+'31'+'|#~'+'186'+'|'+		RIGHT(REPLICATE('0',3) + CAST(ISNULL(D.[selectsource-1],'') as varchar(03) ),3)
	+'|#~'+'31'+'|#~'+'052'+'|'+		RIGHT(REPLICATE('0',5) + CAST(ISNULL(D.[textinput-26],'') as varchar(05) ),5)
	+'|#~'+'31'+'|#~'+'140'+'|'+		RIGHT(REPLICATE('0',2) + CAST(ISNULL(A.[selectsource-29],'') as varchar(02) ),2)
	+'|#~'+'31'+'|#~'+'141'+'|'+		CAST(CASE WHEN ISNULL(A.[selectbasic-7],'') = 'Y' THEN 1 ELSE 0 END AS varchar(01) )				--CallWarrantTradingAllowed
	+'|#~'+'31'+'|#~'+'142'+'|'+		CAST(CASE WHEN ISNULL(A.[multipleradiosinline-13],'') = 'Y' THEN 1 ELSE 0 END  as varchar(01) )	--ClientAssociateAllowedFlag	
	+'|#~'+'31'+'|#~'+'137'+'|'+		CAST(ISNULL(NULLIF(A.[selectbasic-43],''),0)as varchar(01) )										--ShortSellingTradingAllowed
	+ '|#~' + @Protocol_ETX as Msg,
	9 as [Status]
	FROM OPENJSON(@JsonMessageData)
	WITH (
	 ClientName  varchar (30)
	,ClientAddress  varchar (160)
	,TelephoneNumber  varchar (12)
	,ClientICNumber  varchar (14),
	 ClientId varchar (12)
	) 
	AS json
	LEFT JOIN CQBuilder.form.Tb_FormData_1410 AS C
	ON C.[textinput-1] = json.ClientId
	LEFT JOIN CQBuilder.form.Tb_FormData_1409 AS A
	ON A.[selectsource-1] = C.[textinput-1]
	LEFT JOIN CQBuilder.form.Tb_FormData_1377 AS D
	ON A.[selectsource-21] = D.[textinput-35];
	
	end

	else if (@MsgType ='604')	--UserDeletion
	begin
	SET @Message_Type = 'B4';

	INSERT INTO [Queue].[MBMSOutBound] ([MessageData],[Status])
	select 
	'#~' + @Protocol_STX
	+  '|' + @Record_Type 		
	+  '|' +  @Market_Type 		
	+  '|' +  @Message_Type 		
	+  '|' +  @Message_Status_Code + 
	+ '|#~' + '30' + '|#~' +'032'  + '|604'										
	+ '|#~' + '31' + '|#~' +'130'  + '|##QUEUE_ID##'
	+'|#~'+'31'+'|#~'+'123'+'|'+		RIGHT(REPLICATE('0',5) + CAST(UserID as varchar(05) ),5)
	+'|#~'+'31'+'|#~'+'186'+'|'+		RIGHT(REPLICATE('0',3) + CAST(BranchID as varchar(03) ),3)
	+'|#~'+'31'+'|#~'+'147'+'|'+		CAST(DeleteIndicator as varchar(01) )
	+ '|#~' + @Protocol_ETX as Msg,
	9 as [Status]
	FROM OPENJSON(@JsonMessageData)
	WITH (
	UserID  decimal (05)
	,BranchID  decimal (03)
	,DeleteIndicator  decimal (01) 
	) 
	end

	else if (@MsgType ='606')	--ClientDeletion
	begin
	SET @Message_Type = 'B6';

	INSERT INTO [Queue].[MBMSOutBound] ([MessageData],[Status])
	select 
	'#~' + @Protocol_STX
	+  '|' + @Record_Type 		
	+  '|' +  @Market_Type 		
	+  '|' +  @Message_Type 		
	+  '|' +  @Message_Status_Code + 
	+ '|#~' + '30' + '|#~' +'032'  + '|606'										
	+ '|#~' + '31' + '|#~' +'130'  + '|##QUEUE_ID##'
	+'|#~'+'31'+'|#~'+'051'+'|'+		CAST(ClientNumber as varchar(09) )
	+'|#~'+'31'+'|#~'+'186'+'|'+		RIGHT(REPLICATE('0',3) + CAST(ISNULL(D.[selectsource-1],'') as varchar(03) ),3)
	+'|#~'+'31'+'|#~'+'147'+'|'+		CAST(DeleteIndicator as varchar(01) )
	+ '|#~' + @Protocol_ETX as Msg,
	9 as [Status]
	FROM OPENJSON(@JsonMessageData)
	WITH (
	ClientNumber  varchar (09)
	,DeleteIndicator  decimal (01)
	) AS json
	LEFT JOIN CQBuilder.form.Tb_FormData_1409 A
	 ON A.[textinput-5] = json.ClientNumber
	LEFT JOIN CQBuilder.form.Tb_FormData_1410 AS C

	ON A.[selectsource-1] = C.[textinput-1]
	LEFT JOIN CQBuilder.form.Tb_FormData_1377 AS D
	ON A.[selectsource-21] = D.[textinput-35];
	
	end


	else if (@MsgType ='611')	--BrokerExposureLimit
	begin
	SET @Message_Type = 'B7';

	INSERT INTO [Queue].[MBMSOutBound] ([MessageData],[Status])
	select 
	'#~' + @Protocol_STX
	+  '|' + @Record_Type 		
	+  '|' +  @Market_Type 		
	+  '|' +  @Message_Type 		
	+  '|' +  @Message_Status_Code + 
	+ '|#~' + '30' + '|#~' +'032'  + '|611'										
	+ '|#~' + '31' + '|#~' +'130'  + '|##QUEUE_ID##'
	+'|#~'+'31'+'|#~'+'131'+'|'+		RIGHT(REPLICATE('0',2) + CAST(ServerID as varchar(02) ),2)
	+'|#~'+'31'+'|#~'+'186'+'|'+		RIGHT(REPLICATE('0',3) + CAST(BranchID as varchar(03) ),3)
	+'|#~'+'31'+'|#~'+'156'+'|'+		CAST(WithLimitIndicator as varchar )	
	+'|#~'+'31'+'|#~'+'157'+'|'+		RIGHT(REPLICATE('0',12) + CAST(MaxBuyExposureLimit as varchar(12) ),12)
	+'|#~'+'31'+'|#~'+'158'+'|'+		RIGHT(REPLICATE('0',12) + CAST(MaxSellExposureLimit as varchar(12) ),12)
	+'|#~'+'31'+'|#~'+'159'+'|'+		RIGHT(REPLICATE('0',12) + CAST(MaxNettExposureLimit as varchar(12) ),12)
	+'|#~'+'31'+'|#~'+'160'+'|'+		RIGHT(REPLICATE('0',12) + CAST(MaxTotalExposureLimit as varchar(12) ),12)
	+'|#~'+'31'+'|#~'+'161'+'|'+		RIGHT(REPLICATE('0',3) + CAST(ExceedLimit as varchar(03) ),3)
	+'|#~'+'31'+'|#~'+'162'+'|'+		CAST(ClearPreviousDayOrder as varchar )
	+ '|#~' + @Protocol_ETX as Msg,
	9 as [Status]
	FROM OPENJSON(@JsonMessageData)
	WITH (
	ServerID  decimal (02)
	,BranchID  decimal (03)
	,WithLimitIndicator  decimal (01)
	,MaxBuyExposureLimit  decimal (12)
	,MaxSellExposureLimit  decimal (12)
	,MaxNettExposureLimit  decimal (12)
	,MaxTotalExposureLimit  decimal (12)
	,ExceedLimit  decimal (03)
	,ClearPreviousDayOrder  decimal (01)
	) 
	end

	else if (@MsgType ='612')	--BranchExposureLimit
	begin
	SET @Message_Type = 'B8';

	INSERT INTO [Queue].[MBMSOutBound] ([MessageData],[Status])
	select 
	'#~' + @Protocol_STX
	+  '|' + @Record_Type 		
	+  '|' +  @Market_Type 		
	+  '|' +  @Message_Type 		
	+  '|' +  @Message_Status_Code + 
	+ '|#~' + '30' + '|#~' +'032'  + '|612'										
	+ '|#~' + '31' + '|#~' +'130'  + '|##QUEUE_ID##'
	+'|#~'+'31'+'|#~'+'131'+'|'+		RIGHT(REPLICATE('0',2) + CAST(ServerID as varchar(02) ),2)
	+'|#~'+'31'+'|#~'+'186'+'|'+		RIGHT(REPLICATE('0',3) + CAST(BranchID as varchar(03) ),3)
	+'|#~'+'31'+'|#~'+'156'+'|'+		CAST(WithLimitIndicator as varchar )	
	+'|#~'+'31'+'|#~'+'157'+'|'+		RIGHT(REPLICATE('0',12) + CAST(MaxBuyExposureLimit as varchar(12) ),12)
	+'|#~'+'31'+'|#~'+'158'+'|'+		RIGHT(REPLICATE('0',12) + CAST(MaxSellExposureLimit as varchar(12) ),12)
	+'|#~'+'31'+'|#~'+'159'+'|'+		RIGHT(REPLICATE('0',12) + CAST(MaxNettExposureLimit as varchar(12) ),12)
	+'|#~'+'31'+'|#~'+'160'+'|'+		RIGHT(REPLICATE('0',12) + CAST(MaxTotalExposureLimit as varchar(12) ),12)
	+'|#~'+'31'+'|#~'+'161'+'|'+		RIGHT(REPLICATE('0',3) + CAST(ExceedLimit as varchar(03) ),3)
	+'|#~'+'31'+'|#~'+'162'+'|'+		CAST(ClearPreviousDayOrder as varchar )
	+ '|#~' + @Protocol_ETX as Msg,
	9 as [Status]
	FROM OPENJSON(@JsonMessageData)
	WITH (
	ServerID  decimal (02)
	,BranchID  decimal (03)
	,WithLimitIndicator  decimal (01)
	,MaxBuyExposureLimit  decimal (12)
	,MaxSellExposureLimit  decimal (12)
	,MaxNettExposureLimit  decimal (12)
	,MaxTotalExposureLimit  decimal (12)
	,ExceedLimit  decimal (03)
	,ClearPreviousDayOrder  decimal (01)
	) 
	end

	else if (@MsgType ='613')	--DealerExposureLimit
	begin
	SET @Message_Type = 'B9';

	INSERT INTO [Queue].[MBMSOutBound] ([MessageData],[Status])
	select 
	'#~' + @Protocol_STX
	+  '|' + @Record_Type 		
	+  '|' +  @Market_Type 		
	+  '|' +  @Message_Type 		
	+  '|' +  @Message_Status_Code + 
	+ '|#~' + '30' + '|#~' +'032'  + '|613'										
	+ '|#~' + '31' + '|#~' +'130'  + '|##QUEUE_ID##'			 
	+'|#~'+'31'+'|#~'+'186'+'|'+		RIGHT(REPLICATE('0',3) + CAST(ISNULL(D.[selectsource-1],'') as varchar(03) ),3)
	+'|#~'+'31'+'|#~'+'052'+'|'+		RIGHT(REPLICATE('0',5) + CAST(ISNULL(D.[textinput-26],'' )as varchar(05) ),5)
	+'|#~'+'31'+'|#~'+'156'+'|'+		CAST(CASE WHEN ISNULL(D.[selectsource-1],'') = 'Y' THEN 1 ELSE 0 END as varchar )	
	+'|#~'+'31'+'|#~'+'157'+'|'+		RIGHT(REPLICATE('0',12) + CAST(MaxBuyExposureLimit as varchar(12) ),12)
	+'|#~'+'31'+'|#~'+'158'+'|'+		RIGHT(REPLICATE('0',12) + CAST(MaxSellExposureLimit as varchar(12) ),12)
	+'|#~'+'31'+'|#~'+'159'+'|'+		RIGHT(REPLICATE('0',12) + CAST(MaxNettExposureLimit as varchar(12) ),12)
	+'|#~'+'31'+'|#~'+'160'+'|'+		RIGHT(REPLICATE('0',12) + CAST(MaxTotalExposureLimit as varchar(12) ),12)
	+'|#~'+'31'+'|#~'+'161'+'|'+		RIGHT(REPLICATE('0',3)  + CAST(ISNULL(DM.[textinput-10],'' ) as varchar(03) ),3)
	+'|#~'+'31'+'|#~'+'162'+'|'+		CAST(ISNULL(DM.[multipleradiosinline-2],'') as varchar )	
	+ '|#~' + @Protocol_ETX as Msg,
	9 as [Status]
	FROM OPENJSON(@JsonMessageData)
	WITH (
	 BranchID  decimal (03)
	,DealerID  decimal (05)
	,WithLimitIndicator  decimal (01)
	,MaxBuyExposureLimit  decimal (12)
	,MaxSellExposureLimit  decimal (12)
	,MaxNettExposureLimit  decimal (12)
	,MaxTotalExposureLimit  decimal (12)
	,DealerCode varchar(12)
	) as json
	LEFT JOIN CQBuilder.form.Tb_FormData_1377 AS D 
	ON D.[textinput-35] = json.DealerCode
	LEFT JOIN CQBuilder.form.Tb_FormData_1379 AS DM
	ON D.[textinput-35] = DM.[selectsource-14];
	
	end


	else if (@MsgType ='614')	--ClientCreditLimit
	begin
	SET @Message_Type = 'BA';

	INSERT INTO [Queue].[MBMSOutBound] ([MessageData],[Status])
	select 
	'#~' + @Protocol_STX
	+  '|' + @Record_Type 		
	+  '|' +  @Market_Type 		
	+  '|' +  @Message_Type 		
	+  '|' +  @Message_Status_Code + 
	+ '|#~' + '30' + '|#~' +'032'  + '|614'										
	+ '|#~' + '31' + '|#~' +'130'  + '|##QUEUE_ID##' 
	+'|#~'+'31'+'|#~'+'051'+'|'+		CAST(ClientNumber as varchar(09) )
	+'|#~'+'31'+'|#~'+'186'+'|'+		RIGHT(REPLICATE('0',3) + CAST(D.[selectsource-1] as varchar(03) ),3)
	+'|#~'+'31'+'|#~'+'156'+'|'+		CAST(WithLimitIndicator as varchar )	
	+'|#~'+'31'+'|#~'+'157'+'|'+		RIGHT(REPLICATE('0',12) + CAST(MaxBuyCreditLimit as varchar(12) ),12)
	+'|#~'+'31'+'|#~'+'158'+'|'+		RIGHT(REPLICATE('0',12) + CAST(MaxSellCreditLimit as varchar(12) ),12)
	+'|#~'+'31'+'|#~'+'159'+'|'+		RIGHT(REPLICATE('0',12) + CAST(MaxNettCreditLimit as varchar(12) ),12)
	+'|#~'+'31'+'|#~'+'160'+'|'+		RIGHT(REPLICATE('0',12) + CAST(MaxTotalCreditLimit as varchar(12) ),12)
	+'|#~'+'31'+'|#~'+'161'+'|'+		RIGHT(REPLICATE('0',3) + CAST(A.[textinput-71] as varchar(03) ),3)
	+'|#~'+'31'+'|#~'+'162'+'|'+		CAST(A.[multipleradiosinline-19] as varchar )	
	+ '|#~' + @Protocol_ETX as Msg,
	9 as [Status]
	FROM OPENJSON(@JsonMessageData)
	WITH (
	ClientNumber  varchar (09)
	,WithLimitIndicator  decimal (01)
	,MaxBuyCreditLimit  decimal (12)
	,MaxSellCreditLimit  decimal (12)
	,MaxNettCreditLimit  decimal (12)
	,MaxTotalCreditLimit  decimal (12)
	
	) AS json
	LEFT JOIN CQBuilder.form.Tb_FormData_1409 A
	 ON A.[textinput-5] = json.ClientNumber
	LEFT JOIN CQBuilder.form.Tb_FormData_1410 AS C
	ON A.[selectsource-1] = C.[textinput-1]
	LEFT JOIN CQBuilder.form.Tb_FormData_1377 AS D
	ON A.[selectsource-21] = D.[textinput-35];
	end

	else if (@MsgType ='621')	--DealerSuspension
	begin
	SET @Message_Type = 'BF';

	INSERT INTO [Queue].[MBMSOutBound] ([MessageData],[Status])
	select 
	'#~' + @Protocol_STX
	+  '|' + @Record_Type 		
	+  '|' +  @Market_Type 		
	+  '|' +  @Message_Type 		
	+  '|' +  @Message_Status_Code + 
	+ '|#~' + '30' + '|#~' +'032'  + '|621'										
	+ '|#~' + '31' + '|#~' +'130'  + '|##QUEUE_ID##' 
	+'|#~'+'31'+'|#~'+'052'+'|'+		RIGHT(REPLICATE('0',5) + CAST(DealerID as varchar(05) ),5)
	+'|#~'+'31'+'|#~'+'186'+'|'+		RIGHT(REPLICATE('0',3) + CAST(BranchID as varchar(03) ),3)
	+'|#~'+'31'+'|#~'+'167'+'|'+		CAST(ISNULL(DM.[multipleradiosinline-3],'') as varchar )		--AccessSuspendResume
	+'|#~'+'31'+'|#~'+'168'+'|'+		CAST(ISNULL(DM.[multipleradiosinline-4],'') as varchar )	        --BuySuspendResume
	+'|#~'+'31'+'|#~'+'169'+'|'+		CAST(ISNULL(DM.[multipleradiosinline-5],'') as varchar )		--SellSuspendResume
	+'|#~'+'31'+'|#~'+'170'+'|'+		CAST(Remark as varchar )	
	+ '|#~' + @Protocol_ETX as Msg,
	9 as [Status]
	FROM OPENJSON(@JsonMessageData)
	WITH (
	DealerID  decimal (05)
	,BranchID  decimal (03)
	,Remark  varchar (120),
	DealerCode varchar(12)
	) as json
	LEFT JOIN CQBuilder.form.Tb_FormData_1377 AS D 
	ON D.[textinput-35] = json.DealerCode
	LEFT JOIN CQBuilder.form.Tb_FormData_1379 AS DM
	ON D.[textinput-35] = DM.[selectsource-14];
	 
	end

	else if (@MsgType ='622')	--622 ClientSuspension 
	begin
	SET @Message_Type = 'BG';

	INSERT INTO [Queue].[MBMSOutBound] ([MessageData],[Status])
	select 
	'#~' + @Protocol_STX
	+  '|' + @Record_Type 		
	+  '|' +  @Market_Type 		
	+  '|' +  @Message_Type 		
	+  '|' +  @Message_Status_Code + 
	+ '|#~' + '30' + '|#~' +'032'  + '|622'									
	+ '|#~' + '31' + '|#~' +'130'  + '|##QUEUE_ID##' 
	+'|#~'+'31'+'|#~'+'051'+'|'+		CAST(ClientNumber as varchar(09) )
	+'|#~'+'31'+'|#~'+'186'+'|'+		RIGHT(REPLICATE('0',3) + CAST(ISNULL(D.[selectsource-1],'') as varchar(03) ),3)
	+'|#~'+'31'+'|#~'+'167'+'|'+		CAST(AccessSuspendResume as varchar )	
	+'|#~'+'31'+'|#~'+'168'+'|'+		CAST(BuySuspendResume as varchar )	
	+'|#~'+'31'+'|#~'+'169'+'|'+		CAST(SellSuspendResume as varchar )	
	+'|#~'+'31'+'|#~'+'170'+'|'+		CAST(Remark as varchar )	
	+ '|#~' + @Protocol_ETX as Msg,
	9 as [Status]
	FROM OPENJSON(@JsonMessageData)
	WITH (
	ClientNumber  varchar (09)
	,AccessSuspendResume  varchar (01)
	,BuySuspendResume  varchar (01)
	,SellSuspendResume  varchar (01)
	,Remark  varchar (120)
	) AS json
	LEFT JOIN CQBuilder.form.Tb_FormData_1409 A
	 ON A.[textinput-5] = json.ClientNumber
	LEFT JOIN CQBuilder.form.Tb_FormData_1410 AS C
	ON A.[selectsource-1] = C.[textinput-1]
	LEFT JOIN CQBuilder.form.Tb_FormData_1377 AS D
	ON A.[selectsource-21] = D.[textinput-35];

	end
	else if (@MsgType ='706')	
	begin
	SET @Message_Type = 'U5';

		INSERT INTO [Queue].[MBMSOutBound] ([MessageData],[Status])
		select 
		'#~' + @Protocol_STX
		+  '|' + @Record_Type 		
		+  '|' +  @Market_Type 		
		+  '|' +  @Message_Type 		
		+  '|' +  @Message_Status_Code + 
		+ '|#~' + '30' + '|#~' +'032'  + '|706'+										--706' +           --032, 'Transaction Code'
		+ '|#~' + '31' + '|#~' +'130'  + '|##QUEUE_ID##'+										--60228018' +			--130, 'Transaction Sequence Number'
		+ '|#~' + '31' + '|#~' +'051'  + '|'+		CAST(ClientNumber 	 as varchar)					--PHC002I  ' +			--051, 'Client Number'
		+ '|#~' + '31' + '|#~' +'052'  + '|'+		CAST(DealerID        as varchar)						--991' +		 	--052, 'Dealer ID'
		+ '|#~' + '31' + '|#~' +'186'  + '|'+		CAST(BranchID        as varchar)						--1' +			--186, 'Branch ID'
		+ '|#~' + '31' + '|#~' +'037'  + '|'+		CAST(TerminalID      as varchar)						--901' +			--037, 'Terminal ID'
		+ '|#~' + '31' + '|#~' +'038'  + '|'+		CAST(OrderNumber     as varchar)						--79561' +			--038, 'Order Number'
		+ '|#~' + '31' + '|#~' +'055'  + '|'+		CAST(ActionCode      as varchar)						--0' +			--055, 'Action Code'
		+ '|#~' + '31' + '|#~' +'039'  + '|'+		CAST(StockCode 		 as varchar)				--3182  ' +			--039, 'Stock Code'
		+ '|#~' + '31' + '|#~' +'080'  + '|'+		CAST(SettlementCode  as varchar)						--1' +			--080, 'Settlement Code'
		+ '|#~' + '31' + '|#~' +'040'  + '|'+		CAST(BuySellCode     as varchar)						--1' +			--040, 'Buy Sell Code'
		+ '|#~' + '31' + '|#~' +'056'  + '|'+		CAST(QuantityBefore  as varchar)						--0' +			--056, 'Quantity Before'
		+ '|#~' + '31' + '|#~' +'042'  + '|'+		CAST(OrderQuantity   as varchar)						--10000' +			--042, 'Order Quantity'
		+ '|#~' + '31' + '|#~' +'041'  + '|'+		CAST(OrderType       as varchar)						--0' +			--041, 'Order Type'
		+ '|#~' + '31' + '|#~' +'044'  + '|'+		CAST(OrderPrice      as varchar)						--4.400' +			--044, 'Order Price'
		+ '|#~' + '31' + '|#~' +'109'  + '|'+		CAST(OrderDate       as varchar)						--20200727' +			--109, 'Order Date'
		+ '|#~' + '31' + '|#~' +'057'  + '|'+		CAST(OrderTime       as varchar)						--14494233' +			--057, 'Order Time'
		+ '|#~' + '31' + '|#~' +'047'  + '|'+		CAST(ClientCDSNumber as varchar)						--21964'  			---047, 'Client CDS Number'
		+ '|#~' + @Protocol_ETX as Msg,
		9 as [Status]
		FROM OPENJSON(@JsonMessageData)
		WITH (
		[ClientNumber] [varchar](9) ,
		[DealerID] [decimal](5, 0) ,
		[BranchID] [decimal](3, 0) ,
		[TerminalID] [decimal](3, 0) ,
		[OrderNumber] [decimal](8, 0) ,
		[ActionCode] [decimal](1, 0) ,
		[StockCode] [varchar](6) ,
		[SettlementCode] [decimal](1, 0) ,
		[BuySellCode] [decimal](1, 0) ,
		[QuantityBefore] [decimal](12, 0) ,
		[OrderQuantity] [decimal](12, 0) ,
		[OrderType] [decimal](2, 0) ,
		[OrderPrice] [decimal](6, 3) ,
		[OrderDate] [decimal](8, 0) ,
		[OrderTime] [decimal](8, 0) ,
		[ClientCDSNumber] [decimal](9, 0) 
	) 
	end


	update [Queue].[MBMSOutBound] set [Status]=0, MessageData = REPLACE(MessageData,'##QUEUE_ID##',RIGHT(REPLICATE('0',8)+CAST(QueueID AS VARCHAR),8)) where [Status]=9
	
END TRY
BEGIN CATCH
		
	DECLARE @strErrMsg Varchar(4000)=''
	DECLARE @ErrorMessage NVARCHAR(4000), 
		@ErrorNumber INT, 
		@ErrorSeverity INT, 
		@ErrorState INT, 
		@ErrorLine INT, 
		@ErrorProcedure NVARCHAR(200);

	SET @ErrorMessage = @ErrorMessage
		+ QUOTENAME(N'ERROR_MESSAGE(): '		+ CAST(ISNULL(ERROR_MESSAGE(), '-') AS NVARCHAR(1000)), N'(')
		+ QUOTENAME(N'ERROR_NUMBER(): '			+ CAST(ISNULL(ERROR_NUMBER(), '-') AS NVARCHAR(10)), N'(')
		+ QUOTENAME(N'ERROR_SEVERITY(): '		+ CAST(ISNULL(ERROR_SEVERITY(), '-') AS NVARCHAR(10)), N'(')
		+ QUOTENAME(N'ERROR_STATE(): '			+ CAST(ISNULL(ERROR_STATE(), '-') AS NVARCHAR(10)), N'(')
		+ QUOTENAME(N'ERROR_PROCEDURE(): '		+ CAST(ISNULL(ERROR_PROCEDURE(), '-') AS NVARCHAR(200)), N'(')
		+ QUOTENAME(N'ERROR_LINE(): '			+ CAST(ISNULL(ERROR_LINE(), '-')AS NVARCHAR(50)), N'(');
								 
		SELECT  @strErrMsg = @ErrorMessage, 
				@ErrorSeverity = ERROR_SEVERITY(),
				@ErrorState = ERROR_STATE();

		RAISERROR ( @strErrMsg,	/* Message text.*/
					@ErrorSeverity,	/* Severity.	*/
					@ErrorState		/* State.		*/

				   );
					   
END CATCH

SET NOCOUNT OFF;
END