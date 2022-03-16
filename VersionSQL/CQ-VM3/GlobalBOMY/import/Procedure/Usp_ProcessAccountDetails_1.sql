/****** Object:  Procedure [import].[Usp_ProcessAccountDetails_1]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [import].[Usp_ProcessAccountDetails]
	@iintCompanyId BIGINT,
    @ostrReturnMessage VARCHAR(4000) OUTPUT
AS
/*********************************************************************************** 

Name              : import.Usp_ProcessAccountDetails
Created By        : Nishanth Chowdhary
Created Date      : 24/02/2017
Last Updated Date : 
Description       : this sp is used to import the accounts from ClientData on a daily basis
Table(s) Used     : 
					

Modification History :  
 ModifiedBy :         Project Uin          ModifiedDate :           Reason :  
 --BK 20170329 Converted bit field TFNCollected to text

PARAMETERS 
	@iintCompanyId = the company id
    @ostrReturnMessage = the output message if there are any errors
		
Used By :
Exec [import].[Usp_ProcessAccountDetails] 1, ''

************************************************************************************/
BEGIN

	SET NOCOUNT ON;
    
    BEGIN TRY
    	BEGIN TRANSACTION
        
		;WITH cte_AccountDetails AS (
				SELECT 
					A.account AS AcctNo,
					1 AS CompanyId,
					A.branch AS BranchId,
					'Client' AS AcctSegregationType,
					'CL' AS AcctCategory,
					CASE WHEN A.custacct = '6' THEN 'Normal' 
						 ELSE 'Speculative' END AS AcctMarginType,
					A.custacct AS ServiceType,
					NULL AS GroupAccountNo,
					C.ClientID AS MainClientId,
					--A.[Column 1] AS AcctType,
					'I' AS AcctType,
					C.FirstName AS ChequeName,
					D.mktid AS AcctExecutiveCd,
					'THB' AS ClientBaseCurrCd,
					'THB' AS DefaultSetlCurrCd,
					ISNULL(C.DefaultAddressId, 0) AS ResidenceAddressId,
					ISNULL(C.DefaultAddressId, 0) AS MailingAddressId,
					'' AS Email,
					CAST(A.opendate AS DATE) AS AcctCreationDate,
					'AA' AS AcctStatus,
					'' AS AcctStatusRemarks,
					NULL AS Remarks
				FROM import.Acc_Acct AS A
				INNER JOIN GlobalBO.setup.Tb_Personnel AS C ON
					C.ClientCd = A.custcode AND
					C.CompanyId = 1
				INNER JOIN import.Acc_Cust1 AS D ON
					C.ClientCd = D.custcode

				UNION ALL			
					
				SELECT 
					A.account AS AcctNo,
					1 AS CompanyId,
					A.branch AS BranchId,
					'Corporate Client' AS AcctSegregationType,
					'CL' AS AcctCategory,
					CASE WHEN A.custacct = '6' THEN 'Normal' 
						 ELSE 'Speculative' END AS AcctMarginType,
					A.custacct AS ServiceType,
					NULL AS GroupAccountNo,
					C.CorporateClientId AS MainClientId,
					'CI' AS AcctType,
					C.CompanyName AS ChequeName,
					D.mktid AS AcctExecutiveCd,
					'AUD' AS ClientBaseCurrCd,
					'AUD' AS DefaultSetlCurrCd,
					ISNULL(C.CompanyAddressId,0) AS ResidenceAddressId,
					ISNULL(C.CompanyAddressId, 0) MailingAddressId,
					'' AS Email,
					CAST(A.opendate AS DATE) AS AcctCreationDate,
					'AA' AS AcctStatus,
					'' AS AcctStatusRemarks,
					NULL AS Remarks
				FROM import.Acc_Acct AS A
				INNER JOIN GlobalBo.setup.Tb_CorporateClient AS C ON
					C.CorporateClientCd = A.custcode collate Latin1_General_CI_AS AND
					C.CompanyId = 1
					INNER JOIN import.Acc_Cust1 AS D ON
					C.CorporateClientCd = D.custcode
		)
        MERGE INTO GlobalBO.setup.Tb_Account AS TRGT
        USING cte_AccountDetails AS SRC ON
        	SRC.AcctNo = TRGT.AcctNo AND
        	SRC.CompanyId = TRGT.CompanyId
        WHEN MATCHED THEN UPDATE SET
			TRGT.ExtRefKey = SRC.MainClientId,
			TRGT.BranchId = SRC.BranchId,
        	TRGT.AcctCategory = SRC.AcctCategory,
        	TRGT.AcctMarginType = SRC.AcctMarginType,
            TRGT.ServiceType = SRC.ServiceType,
            TRGT.MainClientId = SRC.MainClientId,
            TRGT.AcctSegregationType = SRC.AcctSegregationType,
            TRGT.AcctType = SRC.AcctType,
            TRGT.ChequeName = SRC.ChequeName,
            TRGT.AcctExecutiveCd = SRC.AcctExecutiveCd,
            TRGT.ResidenceAddressId = SRC.ResidenceAddressId,
			TRGT.MailingAddressId = SRC.MailingAddressId,
            TRGT.Email = SRC.Email,
            TRGT.AcctStatus = SRC.AcctStatus,
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
              SRC.MainClientId,
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
		
		EXEC [master].[dbo].DBA_SendEmail   
		@istrMailTo             = 'nishanthc@cyberquote.com.sg;',
		@istrMailBody           = @ostrReturnMessage,  
		@istrMailSubject        = 'Usp_ProcessAccountDetails: Failed', 
		@istrimportance         = 'high', 
		@istrfrom_address       = 'ITGBODeploymentDB@cyberquote.com.sg', 
		@istrreply_to           = '',   
		@istrbody_format        = 'HTML'; 
        
    END CATCH
	SET NOCOUNT OFF;
END