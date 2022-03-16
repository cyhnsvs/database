/****** Object:  Procedure [process].[Usp_Daily_UpdateAccountDormantStatus]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [process].[Usp_Daily_UpdateAccountDormantStatus]
	@iintCompanyId BIGINT,
    @ostrReturnMessage VARCHAR(4000) OUTPUT
AS
/*********************************************************************************** 

Name              : [process].[Usp_Daily_UpdateAccountDormantStatus]
Created By        : Nathiya
Created Date      : 20/07/2021
Last Updated Date : 
Description       : this sp is used to update the Last Transaction Date and Dormant Status
Table(s) Used     : 
					
Modification History :  
 ModifiedBy :         Project Uin          ModifiedDate :           Reason :  
 
PARAMETERS 
	@iintCompanyId = the company id
    @ostrReturnMessage = the output message if there are any errors
		
Used By :
Exec [process].[Usp_Daily_UpdateAccountDormantStatus] 1, ''

************************************************************************************/
BEGIN

	SET NOCOUNT ON;

	DECLARE @dteBusinessDate DATE
	SELECT @dteBusinessDate = GlobalBO.setup.Udf_FetchSetupDate(1, 'BusDate')

    BEGIN TRY
    	BEGIN TRANSACTION
        
		/* MAIN FORM TABLE */
		-- Update Last Transaction Date & Last Trade Date -- 
		
		UPDATE	Acc 
		SET		FormDetails = JSON_MODIFY(
								JSON_MODIFY(
									JSON_MODIFY(
										JSON_MODIFY(
											FormDetails,
											'$[0].dateinput22',CAST(CASE WHEN [dateinput-22] < LastTransDate THEN LastTransDate ELSE [dateinput-22] END AS VARCHAR)),
											'$[1].dateinput22',CAST(CASE WHEN [dateinput-22] < LastTransDate THEN LastTransDate ELSE [dateinput-22] END AS VARCHAR)),
											'$[0].dateinput23',CAST(CASE WHEN [dateinput-23] < LastTransDate THEN LastTransDate ELSE [dateinput-23] END AS VARCHAR)),
											'$[1].dateinput23',CAST(CASE WHEN [dateinput-23] < LastTransDate THEN LastTransDate ELSE [dateinput-23] END AS VARCHAR))
		FROM 
			CQBuilder.form.Tb_FormData_1409 Acc 
		INNER JOIN 
		(
		SELECT 
			MAX(ContractDate) AS LastTransDate, AcctNo
		FROM
			GlobalBO.contracts.Tb_ContractOutstanding 
		GROUP BY
			AcctNo
		) AS C ON Acc.[textinput-5] = C.AcctNo
		WHERE [selectsource-31] <> 'C'
			
		UPDATE	Acc 
		SET		FormDetails = JSON_MODIFY(
								JSON_MODIFY(
									FormDetails,
									'$[0].dateinput22',CAST(CASE WHEN [dateinput-22] < LastTransDate THEN LastTransDate ELSE [dateinput-22] END AS VARCHAR)),
									'$[1].dateinput22',CAST(CASE WHEN [dateinput-22] < LastTransDate THEN LastTransDate ELSE [dateinput-22] END AS VARCHAR))
		FROM 
			CQBuilder.form.Tb_FormData_1409 Acc 
		INNER JOIN 
		(
		SELECT 
			MAX(TransDate) AS LastTransDate, AcctNo
		FROM
			GlobalBO.transmanagement.Tb_Transactions  
		GROUP BY
			AcctNo
		) AS C ON Acc.[textinput-5] = C.AcctNo AND [dateinput-22] < LastTransDate
		WHERE [selectsource-31] <> 'C'

		UPDATE	Acc 
		SET		FormDetails = JSON_MODIFY(
								JSON_MODIFY(
									FormDetails,
									'$[0].dateinput22',CAST(CASE WHEN [dateinput-22] < LastTransDate THEN LastTransDate ELSE [dateinput-22] END AS VARCHAR)),
									'$[1].dateinput22',CAST(CASE WHEN [dateinput-22] < LastTransDate THEN LastTransDate ELSE [dateinput-22] END AS VARCHAR))
		FROM 
			CQBuilder.form.Tb_FormData_1409 Acc 
		INNER JOIN 
		(
		SELECT 
			MAX(ContractDate) AS LastTransDate, AcctNo
		FROM
			GlobalBO.transmanagement.Tb_TransactionsSettled  
		WHERE
			TransType NOT IN ('TRBUY','TRSELL')
		GROUP BY
			AcctNo
		) AS C ON Acc.[textinput-5] = C.AcctNo
		WHERE [selectsource-31] <> 'C'

		UPDATE Acc 
		SET		FormDetails = JSON_MODIFY(
								JSON_MODIFY(
									JSON_MODIFY(
										JSON_MODIFY(
											FormDetails,
											'$[0].dateinput22',CAST(CASE WHEN [dateinput-22] < LastTransDate THEN LastTransDate ELSE [dateinput-22] END AS VARCHAR)),
											'$[1].dateinput22',CAST(CASE WHEN [dateinput-22] < LastTransDate THEN LastTransDate ELSE [dateinput-22] END AS VARCHAR)),
											'$[0].dateinput23',CAST(CASE WHEN [dateinput-23] < LastTransDate THEN LastTransDate ELSE [dateinput-23] END AS VARCHAR)),
											'$[1].dateinput23',CAST(CASE WHEN [dateinput-23] < LastTransDate THEN LastTransDate ELSE [dateinput-23] END AS VARCHAR))
		FROM 
			CQBuilder.form.Tb_FormData_1409 Acc 
		INNER JOIN 
		(
		SELECT 
			MAX(ContractDate) AS LastTransDate, AcctNo
		FROM
			GlobalBO.transmanagement.Tb_TransactionsSettled
		WHERE
			TransType IN ('TRBUY','TRSELL')  
		GROUP BY
			AcctNo
		) AS C ON Acc.[textinput-5] = C.AcctNo
		WHERE [selectsource-31] <> 'C'

		-- Update Dormant Status
		UPDATE	Acc
		SET		FormDetails = JSON_MODIFY(
								JSON_MODIFY(
									FormDetails,
									'$[0].multipleradiosinline26',CAST(CASE WHEN ([dateinput-22] < DATEADD(year, -3, @dteBusinessDate) AND [dateinput-19] < DATEADD(year, -3, @dteBusinessDate)) THEN 'Y' ELSE  'N' END AS VARCHAR)),
									'$[1].multipleradiosinline26',CAST(CASE WHEN ([dateinput-22] < DATEADD(year, -3, @dteBusinessDate) AND [dateinput-19] < DATEADD(year, -3, @dteBusinessDate)) THEN 'Y' ELSE  'N' END AS VARCHAR))
		FROM	CQBuilder.form.Tb_FormData_1409 Acc
		WHERE	[selectsource-31] <> 'C'

		/* EXPORT TABLE */
		-- Update Last Transaction Date & Last Trade Date -- 
		
		UPDATE	Acc 
		SET	    [LastTransactionDate (dateinput-22)] = CASE WHEN [LastTransactionDate (dateinput-22)] < LastTransDate THEN LastTransDate ELSE [LastTransactionDate (dateinput-22)] END,
				[LastTradingDate (dateinput-23)] = CASE WHEN [LastTradingDate (dateinput-23)] < LastTransDate THEN LastTransDate ELSE [LastTradingDate (dateinput-23)] END
		FROM 
			CQBTempDB.export.Tb_FormData_1409 Acc 
		INNER JOIN 
		(
		SELECT 
			MAX(ContractDate) AS LastTransDate, AcctNo
		FROM
			GlobalBO.contracts.Tb_ContractOutstanding 
		GROUP BY
			AcctNo
		) AS C ON Acc.[AccountNumber (textinput-5)] = C.AcctNo
		WHERE [Tradingaccount (selectsource-31)] <> 'C'
			
		UPDATE	Acc 
		SET		[LastTransactionDate (dateinput-22)] = LastTransDate
		FROM 
			CQBTempDB.export.Tb_FormData_1409 Acc 
		INNER JOIN 
		(
		SELECT 
			MAX(TransDate) AS LastTransDate, AcctNo
		FROM
			GlobalBO.transmanagement.Tb_Transactions  
		GROUP BY
			AcctNo
		) AS C ON Acc.[AccountNumber (textinput-5)] = C.AcctNo AND [LastTransactionDate (dateinput-22)] < LastTransDate
		WHERE [Tradingaccount (selectsource-31)] <> 'C'

		UPDATE Acc 
		SET [LastTransactionDate (dateinput-22)] = CASE WHEN [LastTransactionDate (dateinput-22)] < LastTransDate THEN LastTransDate ELSE [LastTransactionDate (dateinput-22)] END
		FROM 
			CQBTempDB.export.Tb_FormData_1409 Acc 
		INNER JOIN 
		(
		SELECT 
			MAX(ContractDate) AS LastTransDate, AcctNo
		FROM
			GlobalBO.transmanagement.Tb_TransactionsSettled  
		WHERE
			TransType NOT IN ('TRBUY','TRSELL')
		GROUP BY
			AcctNo
		) AS C ON Acc.[AccountNumber (textinput-5)] = C.AcctNo
		WHERE [Tradingaccount (selectsource-31)] <> 'C'

		UPDATE Acc 
		SET [LastTransactionDate (dateinput-22)] = CASE WHEN [LastTransactionDate (dateinput-22)] < LastTransDate THEN LastTransDate ELSE [LastTransactionDate (dateinput-22)] END,
		    [LastTradingDate (dateinput-23)] = CASE WHEN [LastTradingDate (dateinput-23)] < LastTransDate THEN LastTransDate ELSE [LastTradingDate (dateinput-23)] END
		FROM 
			CQBTempDB.export.Tb_FormData_1409 Acc 
		INNER JOIN 
		(
		SELECT 
			MAX(ContractDate) AS LastTransDate, AcctNo
		FROM
			GlobalBO.transmanagement.Tb_TransactionsSettled
		WHERE
			TransType IN ('TRBUY','TRSELL')  
		GROUP BY
			AcctNo
		) AS C ON Acc.[AccountNumber (textinput-5)] = C.AcctNo
		WHERE [Tradingaccount (selectsource-31)] <> 'C'

		-- Update Dormant Status
		UPDATE	Acc
		SET		[Dormant (multipleradiosinline-26)] = CASE WHEN ([LastTransactionDate (dateinput-22)] < DATEADD(year, -3, @dteBusinessDate) AND [AccountOpenedDate (dateinput-19)] < DATEADD(year, -3, @dteBusinessDate)) THEN 'Y'
														   ELSE  'N'
													  END
		FROM	CQBTempDB.export.Tb_FormData_1409 Acc
		WHERE	[Tradingaccount (selectsource-31)] <> 'C'

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
    
    	DECLARE @intErrorNumber INT
	    ,@intErrorLine INT
	    ,@intErrorSeverity INT
	    ,@intErrorState INT
	    ,@strObjectName VARCHAR(200);

        SELECT @intErrorNumber = ERROR_NUMBER()
	        ,@ostrReturnMessage = ERROR_MESSAGE()
	        ,@intErrorLine = ERROR_LINE()
	        ,@intErrorSeverity = ERROR_SEVERITY()
	        ,@intErrorState = ERROR_STATE()
	        ,@strObjectName = ERROR_PROCEDURE();

        EXEC GlobalBO.[utilities].[usp_ErrorLog] @intErrorNumber
	        ,@ostrReturnMessage
	        ,@intErrorLine
	        ,@strObjectName
	        ,NULL /*Code Section not available*/
	        ,'Process fail.';

        RAISERROR (@ostrReturnMessage,@intErrorSeverity,@intErrorState);
		      
		ROLLBACK TRANSACTION;

		Select @ostrReturnMessage;
		
		--EXEC [master].[dbo].DBA_SendEmail   
		--@istrMailTo             = 'nishanthc@cyberquote.com.sg;',
		--@istrMailBody           = @ostrReturnMessage,  
		--@istrMailSubject        = 'Usp_ProcessAccountDetails: Failed', 
		--@istrimportance         = 'high', 
		--@istrfrom_address       = 'ITGBODeploymentDB@cyberquote.com.sg', 
		--@istrreply_to           = '',   
		--@istrbody_format        = 'HTML'; 
        
    END CATCH
	SET NOCOUNT OFF;
END