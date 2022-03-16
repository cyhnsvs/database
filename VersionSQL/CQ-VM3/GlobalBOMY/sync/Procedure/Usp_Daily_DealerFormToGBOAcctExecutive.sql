/****** Object:  Procedure [sync].[Usp_Daily_DealerFormToGBOAcctExecutive]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [sync].[Usp_Daily_DealerFormToGBOAcctExecutive]
	@iintCompanyId BIGINT,
    @ostrReturnMessage VARCHAR(4000) OUTPUT
AS
/*********************************************************************************** 

Name              : import.[Usp_Daily_DealerFormToGBOAcctExecutive]
Created By        : Nathiya
Created Date      : 15/03/2021
Last Updated Date : 
Description       : this sp is used to Sync Dealer data to Account Executive Daily
Table(s) Used     : 
					

Modification History :  
 ModifiedBy :         Project Uin          ModifiedDate :           Reason :  
 
PARAMETERS 
	@iintCompanyId = the company id
    @ostrReturnMessage = the output message if there are any errors
		
Used By :
Exec [sync].[Usp_Daily_DealerFormToGBOAcctExecutive] 1, ''

************************************************************************************/
BEGIN

	SET NOCOUNT ON;
    
    BEGIN TRY
    	BEGIN TRANSACTION
        
		;WITH cte_DealerDetails AS (
            SELECT
                ROW_NUMBER() OVER (ORDER BY [DealerCode (textinput-35)]) AS RowNo,
                [DealerCode (textinput-35)] AS DealerCode,
				[IDNumberType (selectsource-2)] AS IDType,
				[IDNumber (textinput-9)] AS IDNumber,
				[Name (textinput-3)] AS FirstName,
				[DealerType (selectsource-3)] AS AeCategoryCd,
				'' AS AeRefNo,
				[CodeDisplay (textinput-2)] AS AeCategoryCdDesc,
				'' AS AeChannelId,
				'' AS AeChannelDesc,
				[Sex (multipleradiosinline-2)] AS Gender,
				'' AS DateOfBirth,
				'' AS MaritalStatus,
				[Address1 (textinput-11)] AS Address1,
				[Address2 (textinput-14)] AS Address2,
				[Address3 (textinput-13)] AS Address3,
				[PostCode (textinput-15)] AS PostalCd,
				[WorkEmail (textinput-20)] AS EmailId,
				[Status (selectsource-12)] AS StatusInd,
				[BranchId (selectsource-1)] AS BranchCd,
				'' AeBranchDesc,
				'' AeFirmId,
				'' TeamManagerInd,
				'' TeamManagerName,
				'' TeamSupervisorInd,
				'' TeamSupervisorName,
				'' FADate,
				'' MASRepNo,
				[Phone (textinput-16)] AS HomeContactNo,
				[TelephoneExtension (textinput-18)] AS OfficeContactNo,
				[MobilePhone (textinput-17)] AS MobileContactNo
		   FROM 
				CQBTempDB.export.Tb_FormData_1377 AS A -- Dealer Form
		   INNER JOIN
				CQbTempDB.export.Tb_FormData_1319 AS B ON A.[DealerType (selectsource-3)] = B.[Value (textinput-3)] AND [CodeType (selectbasic-1)] = 'DealerType'-- Code Reference Form 
		   
 
	  )
      MERGE INTO GlobalBO.setup.Tb_AcctExecutive AS TRGT
      USING cte_DealerDetails AS SRC ON
		SRC.DealerCode = TRGT.AeCd
        WHEN MATCHED THEN UPDATE SET
        	TRGT.AeCd = SRC.DealerCode,
			TRGT.IdType = SRC.IDType,
            TRGT.IdNumber = SRC.IDNumber,
            TRGT.FirstName = SRC.FirstName,
            TRGT.AeCategoryCd = SRC.AeCategoryCd,
            TRGT.AeCategoryCdDesc = SRC.AeCategoryCdDesc,
            TRGT.AeRefNo = SRC.AeRefNo,
			TRGT.AeChannelId = SRC.AeChannelId,
            TRGT.AeChannelDesc = SRC.AeChannelDesc,
            TRGT.Gender = SRC.Gender,
            TRGT.DateOfBirth = SRC.DateOfBirth,
            TRGT.MaritalStatus = SRC.MaritalStatus,
            TRGT.Address1 = SRC.Address1,
			TRGT.Address2 = SRC.Address2,
			TRGT.Address3 = SRC.Address3,
            TRGT.EmailId = SRC.EmailId,
			TRGT.StatusInd = SRC.StatusInd,
			TRGT.BranchCd = SRC.BranchCd,
			TRGT.AeBranchDesc = SRC.AeBranchDesc,
			TRGT.AeFirmId = SRC.AeFirmId,
			TRGT.TeamManagerInd = SRC.TeamManagerInd,
			TRGT.TeamManagerName = SRC.TeamManagerName,
			TRGT.TeamSupervisorInd = SRC.TeamSupervisorInd,
			TRGT.TeamSupervisorName = SRC.TeamSupervisorName,
			TRGT.FADate = SRC.FADate,
			TRGT.MASRepNo = SRC.MASRepNo,
			TRGT.HomeContactNo = SRC.HomeContactNo,
			TRGT.OfficeContactNo = SRC.OfficeContactNo,
			TRGT.MobileContactNo = SRC.MobileContactNo,
            TRGT.ModifiedBy = 'SYSBATCH',
            TRGT.ModifiedDate = GETDATE()
         WHEN NOT MATCHED BY TARGET THEN
         	INSERT (
				 CompanyId
				,AeCd
				,IdType
				,IdNumber
				,FirstName
				,AeCategoryCd
				,AeRefNo
				,AeCategoryCdDesc
				,AeChannelId
				,AeChannelDesc
				,Gender
				,DateOfBirth
				,MaritalStatus
				,Address1
				,Address2
				,Address3
				,PostalCd
				,EmailId
				,StatusInd
				,BranchCd
				,AeBranchDesc
				,AeFirmId
				,TeamManagerInd
				,TeamManagerName
				,TeamSupervisorInd
				,TeamSupervisorName
				,FADate
				,MASRepNo
				,HomeContactNo
				,OfficeContactNo
				,MobileContactNo
				,CreatedBy
				,CreatedDate
            ) VALUES (
				 @iintCompanyId
            	,SRC.DealerCode
				,SRC.IdType
				,SRC.IdNumber
				,SRC.FirstName
				,SRC.AeCategoryCd
				,SRC.AeRefNo
				,SRC.AeCategoryCdDesc
				,SRC.AeChannelId
				,SRC.AeChannelDesc
				,SRC.Gender
				,SRC.DateOfBirth
				,SRC.MaritalStatus
				,SRC.Address1
				,SRC.Address2
				,SRC.Address3
				,SRC.PostalCd
				,SRC.EmailId
				,SRC.StatusInd
				,SRC.BranchCd
				,SRC.AeBranchDesc
				,SRC.AeFirmId
				,SRC.TeamManagerInd
				,SRC.TeamManagerName
				,SRC.TeamSupervisorInd
				,SRC.TeamSupervisorName
				,SRC.FADate
				,SRC.MASRepNo
				,SRC.HomeContactNo
				,SRC.OfficeContactNo
				,SRC.MobileContactNo
				,'SYSBATCH'
				,GETDATE()
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

		SELECT @ostrReturnMessage;
		
		--EXEC [master].[dbo].DBA_SendEmail   
		--@istrMailTo             = 'nishanthc@cyberquote.com.sg',
		--@istrMailBody           = @ostrReturnMessage,  
		--@istrMailSubject        = 'Usp_DailySynch_CustomerToClient: Failed', 
		--@istrimportance         = 'high', 
		--@istrfrom_address       = 'ITGBODeploymentDB@cyberquote.com.sg', 
		--@istrreply_to           = '',   
		--@istrbody_format        = 'HTML'; 
        
    END CATCH
	SET NOCOUNT OFF;
END