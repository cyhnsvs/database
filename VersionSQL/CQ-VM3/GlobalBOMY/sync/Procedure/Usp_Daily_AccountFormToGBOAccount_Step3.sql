/****** Object:  Procedure [sync].[Usp_Daily_AccountFormToGBOAccount_Step3]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [sync].[Usp_Daily_AccountFormToGBOAccount_Step3]
	@iintCompanyId BIGINT,
    @ostrReturnMessage VARCHAR(4000) OUTPUT
AS
/*********************************************************************************** 

Name              : import.Usp_Daily_AccountFormToGBOAccount
Created By        : Jansi
Created Date      : 14/04/2020
Last Updated Date : 
Description       : this sp is used to synch the accounts from CQAccount Form to GBO Account table
Table(s) Used     : 
					

Modification History :  
 ModifiedBy :         Project Uin          ModifiedDate :           Reason :  
 

PARAMETERS 
	@iintCompanyId = the company id
    @ostrReturnMessage = the output message if there are any errors
		
Used By :
Exec [sync].[Usp_Daily_AccountFormToGBOAccount_Step3] 1, ''

************************************************************************************/
BEGIN

	SET NOCOUNT ON;
    
    BEGIN TRY
    	BEGIN TRANSACTION
        
		;WITH cte_AccountDetails AS (
				SELECT 
					AM.OldAccountNo,
					A.[AccountNumber (textinput-5)] AS AcctNo,
					1 AS CompanyId,
					A.[CDSACOpenBranch (selectsource-4)] AS BranchId,
					'Client' AS AcctSegregationType,
					'CL' AS AcctCategory,
					CASE WHEN A.[AccountType (selectsource-7)] = '6' THEN 'Normal' 
						 ELSE 'Speculative' END AS AcctMarginType, -- Need to check which field has to use
					--A.AccountType AS ServiceType,
					A.[AccountGroup (selectsource-2)] AS ServiceType,
					A.[CDSNo (textinput-19)] AS GroupAccountNo,
					C.ClientID AS MainClientId,
					--A.[Column 1] AS AcctType,
					'I' AS AcctType,
					C.FirstName AS ChequeName,
					A.[DealerCode (selectsource-21)] AS AcctExecutiveCd,
					'MYR' AS ClientBaseCurrCd,
					'MYR' AS DefaultSetlCurrCd,
					ISNULL(C.DefaultAddressId, 0) AS ResidenceAddressId,
					ISNULL(C.DefaultAddressId, 0) AS MailingAddressId,
					CI.[Email (textinput-58)] AS Email,
					--CASE 
					--	WHEN Len(A.[DateJoined (dateinput-1)]) = 9 THEN '2'+ A.[DateJoined (dateinput-1)] 
					--	WHEN CHARINDEX('N', A.[DateJoined (dateinput-1)]) > 0 THEN '2'+ REPLACE(A.[DateJoined (dateinput-1)],'N','')
					--	ELSE '1900-01-01' 
					--END AS AcctCreationDate,
					CASE WHEN [Tradingaccount (selectsource-31)]='A' OR ISNULL([Tradingaccount (selectsource-31)],'')='' THEN 'AA' 
						 ELSE [Tradingaccount (selectsource-31)] END  AS AcctStatus,
					A.[DateofTradingAccountOpened (dateinput-20)] AS AcctCreationDate,
					'' AS AcctStatusRemarks,
					NULL AS Remarks
				FROM CQBTempDB.export.Tb_FormData_1409 AS A
				LEFT JOIN GlobalBOMY.import.Tb_AccountNoMapping AS AM
				ON A.[AccountNumber (textinput-5)] = AM.NewAccountNo 
					AND (AM.AccountStatus<>'C' OR (AM.AccountStatus='C' AND AM.AccountStatusDate>='2021-01-01') OR AM.OldAccountNo IN ('ALB001C','CKF008A','MBM105C','TBF003A','WSK005A'))
				INNER JOIN GlobalBO.setup.Tb_Personnel AS C ON
					C.ClientCd = A.[CustomerID (selectsource-1)] AND
					C.CompanyId = 1
				INNER JOIN CQBTempDB.export.Tb_FormData_1410 AS CI
				ON A.[CustomerID (selectsource-1)] = CI.[CustomerID (textinput-1)]
				--WHERE [AccountNumber (textinput-5)] NOT IN ('031901107','031903102','031957407','031901307','032198207')

				UNION ALL			
					
				SELECT 
					AM.OldAccountNo,
					A.[AccountNumber (textinput-5)] AS AcctNo,
					1 AS CompanyId,
					A.[CDSACOpenBranch (selectsource-4)] AS BranchId,
					'Client' AS AcctSegregationType,
					'CL' AS AcctCategory,
					CASE WHEN A.[AccountType (selectsource-7)] = '6' THEN 'Normal' 
						 ELSE 'Speculative' END AS AcctMarginType, -- need to check which filed has to be used
					--A.AccountType AS ServiceType,
					A.[AccountGroup (selectsource-2)] AS ServiceType,
					A.[CDSNo (textinput-19)] AS GroupAccountNo,
					C.CorporateClientId AS MainClientId,
					'CI' AS AcctType,
					C.CompanyName AS ChequeName,
					A.[DealerCode (selectsource-21)] AS AcctExecutiveCd,
					'MYR' AS ClientBaseCurrCd,
					'MYR' AS DefaultSetlCurrCd,
					ISNULL(C.CompanyAddressId,0) AS ResidenceAddressId,
					ISNULL(C.CompanyAddressId, 0) MailingAddressId,
					CI.[Email (textinput-58)] AS Email,
					--CAST(A.DateJoined AS DATE) AS AcctCreationDate,
					--CASE 
					--	WHEN Len(A.[DateJoined (dateinput-1)]) = 9 THEN '2'+ A.[DateJoined (dateinput-1)] 
					--	WHEN CHARINDEX('N', A.[DateJoined (dateinput-1)]) > 0 THEN '2'+ REPLACE(A.[DateJoined (dateinput-1)],'N','')
					--	ELSE '1900-01-01' 
					--END AS AcctCreationDate,
					CASE WHEN [Tradingaccount (selectsource-31)]='A'  OR ISNULL([Tradingaccount (selectsource-31)],'')=''
						 THEN 'AA' ELSE [Tradingaccount (selectsource-31)] END AS AcctStatus,
					A.[DateofTradingAccountOpened (dateinput-20)] AS AcctCreationDate,
					'' AS AcctStatusRemarks,
					NULL AS Remarks
				FROM CQBTempDB.export.Tb_FormData_1409 AS A
				LEFT JOIN GlobalBOMY.import.Tb_AccountNoMapping AS AM
				ON A.[AccountNumber (textinput-5)] = AM.NewAccountNo AND (AM.AccountStatus<>'C' OR (AM.AccountStatus='C' AND AM.AccountStatusDate>='2021-01-01'))
				INNER JOIN GlobalBO.setup.Tb_CorporateClient AS C ON
					C.CorporateClientCd = A.[CustomerID (selectsource-1)] collate Latin1_General_CI_AS AND
					C.CompanyId = 1
				INNER JOIN CQBTempDB.export.Tb_FormData_1410 AS CI
				ON A.[CustomerID (selectsource-1)] = CI.[CustomerID (textinput-1)]

				UNION ALL
				
				SELECT 
					'',
					A.[BrokerCode (textinput-1)] AS AcctNo,
					1 AS CompanyId,
					1 AS BranchId,
					'Client' AS AcctSegregationType,
					'CL' AS AcctCategory,
					'Normal' AS AcctMarginType, -- need to check which filed has to be used
					--A.AccountType AS ServiceType,
					'B' AS ServiceType,
					NULL AS GroupAccountNo,
					C.CorporateClientId AS MainClientId,
					'CI' AS AcctType,
					C.CompanyName AS ChequeName,
					'BRK' AS AcctExecutiveCd,
					'MYR' AS ClientBaseCurrCd,
					'MYR' AS DefaultSetlCurrCd,
					ISNULL(C.CompanyAddressId,0) AS ResidenceAddressId,
					ISNULL(C.CompanyAddressId,0) MailingAddressId,
					'' AS Email,
					--CAST(A.DateJoined AS DATE) AS AcctCreationDate,
					--CASE 
					--	WHEN Len(A.[DateJoined (dateinput-1)]) = 9 THEN '2'+ A.[DateJoined (dateinput-1)] 
					--	WHEN CHARINDEX('N', A.[DateJoined (dateinput-1)]) > 0 THEN '2'+ REPLACE(A.[DateJoined (dateinput-1)],'N','')
					--	ELSE '1900-01-01' 
					--END AS AcctCreationDate,
					'AA' AS AcctStatus,
					'' AS AcctCreationDate,
					'' AS AcctStatusRemarks,
					NULL AS Remarks
				FROM CQBTempDB.export.Tb_FormData_2795 AS A
				INNER JOIN GlobalBO.setup.Tb_CorporateClient AS C ON
					C.CorporateClientCd = A.[BrokerCode (textinput-1)] collate Latin1_General_CI_AS AND
					C.CompanyId = 1

				UNION ALL

				SELECT 
					'',
					A.[DealerAccountNo (textinput-37)] AS AcctNo,
					1 AS CompanyId,
					A.[BranchID (selectsource-1)] AS BranchId,
					'Remisier' AS AcctSegregationType,
					'CL' AS AcctCategory,
					'' AS AcctMarginType,
					'' AS ServiceType,
					NULL AS GroupAccountNo,
					C.ClientID AS MainClientId,
					'I' AS AcctType,
					C.FirstName AS ChequeName,
					'' AS AcctExecutiveCd,
					'MYR' AS ClientBaseCurrCd,
					'MYR' AS DefaultSetlCurrCd,
					ISNULL(C.DefaultAddressId, 0) AS ResidenceAddressId,
					ISNULL(C.DefaultAddressId, 0) AS MailingAddressId,
					A.[WorkEmail (textinput-20)] AS Email,
					'AA' AS AcctStatus,
					'' AS AcctCreationDate,
					'' AS AcctStatusRemarks,
					NULL AS Remarks
				FROM CQBTempDB.export.Tb_FormData_1377 AS A
				INNER JOIN GlobalBO.setup.Tb_Personnel AS C ON
					C.ClientCd = A.[DealerCode (textinput-35)] AND
					C.CompanyId = 1
				WHERE [DealerAccountNo (textinput-37)] <> ''
		)
        MERGE INTO GlobalBO.setup.Tb_Account AS TRGT
        USING cte_AccountDetails AS SRC ON
        	SRC.AcctNo = TRGT.AcctNo AND
        	SRC.CompanyId = TRGT.CompanyId
        WHEN MATCHED THEN UPDATE SET
			TRGT.ExtRefKey = SRC.OldAccountNo,--SRC.MainClientId,
			TRGT.BranchId = SRC.BranchId,
        	TRGT.AcctCategory = SRC.AcctCategory,
        	TRGT.AcctMarginType = SRC.AcctMarginType,
            TRGT.ServiceType = SRC.ServiceType,
            TRGT.GroupAccountNo = SRC.GroupAccountNo,
            TRGT.MainClientId = SRC.MainClientId,
            TRGT.AcctSegregationType = SRC.AcctSegregationType,
            TRGT.AcctType = SRC.AcctType,
            TRGT.ChequeName = SRC.ChequeName,
            TRGT.AcctExecutiveCd = SRC.AcctExecutiveCd,
            TRGT.ResidenceAddressId = SRC.ResidenceAddressId,
			TRGT.MailingAddressId = SRC.MailingAddressId,
            TRGT.Email = SRC.Email,
            TRGT.AcctStatus = SRC.AcctStatus,
			TRGT.AcctCreationDate = SRC.AcctCreationDate,
            TRGT.AcctStatusRemarks = SRC.AcctStatusRemarks,
            TRGT.ModifiedBy = 'SYSBATCH',
            TRGT.ModifiedDate = GETDATE()
        WHEN NOT MATCHED BY TARGET THEN
			INSERT (
              AcctNo,
              CompanyId,
              ExtRefKey,
              BranchId,
              AcctSegregationType,
              AcctCategory,
              AcctMarginType,
              ServiceType,
              GroupAccountNo,
              MainClientId,
              AcctType,
              ChequeName,
              AcctExecutiveCd,
              ClientBaseCurrCd,
              DefaultSetlCurrCd,
              ResidenceAddressId,
              MailingAddressId,
              Email,
              AcctCreationDate,
              AcctStatus,
              AcctStatusRemarks,
              Remarks,
              RecordId,
              ActionInd,
              CurrentUser,
              CreatedBy,
              CreatedDate
            ) 
            VALUES (			
              SRC.AcctNo,
              SRC.CompanyId,
              SRC.OldAccountNo,
              SRC.BranchId,
              SRC.AcctSegregationType,
              SRC.AcctCategory,
              SRC.AcctMarginType,
              SRC.ServiceType,
              SRC.GroupAccountNo,
              SRC.MainClientId,              
              SRC.AcctType,
              SRC.ChequeName,
              SRC.AcctExecutiveCd,
              SRC.ClientBaseCurrCd,
              SRC.DefaultSetlCurrCd,
              SRC.ResidenceAddressId,
              SRC.MailingAddressId,
              SRC.Email,
              SRC.AcctCreationDate,
              SRC.AcctStatus,
              SRC.AcctStatusRemarks,
              SRC.Remarks,
              NEWID(), --RecordId
              '', --ActionInd
              '', --CurrentUser
              'SYSBATCH', --CreatedBy
              GETDATE() --CreatedDate
            );
			
        --ROLLBACK TRANSACTION
        COMMIT TRANSACTION;

    END TRY
    BEGIN CATCH
		
		IF @@TRANCOUNT> 0
			ROLLBACK TRANSACTION

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