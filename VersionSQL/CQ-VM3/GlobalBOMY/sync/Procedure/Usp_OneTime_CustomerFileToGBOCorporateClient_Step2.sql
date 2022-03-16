/****** Object:  Procedure [sync].[Usp_OneTime_CustomerFileToGBOCorporateClient_Step2]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [sync].[Usp_OneTime_CustomerFileToGBOCorporateClient_Step2]
	@iintCompanyId BIGINT,
    @ostrReturnMessage VARCHAR(4000) OUTPUT
AS
/*********************************************************************************** 

Name              : import.Usp_ProcessCorporateClientDetails
Created By        : Jansi
Created Date      : 19/03/2020
Last Updated Date : 
Description       : this sp is used to import the corporate clients from ClientData onetime
Table(s) Used     : 
					

Modification History :  
 ModifiedBy :         Project Uin          ModifiedDate :           Reason :  
 
PARAMETERS 
	@iintCompanyId = the company id
    @ostrReturnMessage = the output message if there are any errors
		
Used By :
Exec [sync].[Usp_OneTime_CustomerFileToGBOCorporateClient_Step2] 1, ''

************************************************************************************/
BEGIN

	SET NOCOUNT ON;
    
    BEGIN TRY
    	BEGIN TRANSACTION
        
		;WITH cte_ClientDetails AS (
            SELECT
    --            ROW_NUMBER() OVER (PARTITION BY A.CustomerID ORDER BY A.CustomerID) AS RowNo,
    --            CustomerID AS CorporateClientCd,
				--'' AS ExtRefKey,
				--CustomerName AS CompanyName,
				--ISNULL(IDType,'RegNumber') AS IdType,
				--ISNULL(IDNumber,'') AS IdNo,
				--'MY' AS CountryOfRegistration,
				--DateOfBirth AS RegistrationDate,
				----LEFT(iif(email <> '', email, 'settlements@phillipcapital.com.au'),100) AS [ContactEmail],
				--ISNULL(LEFT(PhoneHouse,20),ISNULL(LEFT(PhoneMobile,20),ISNULL(LEFT(PhoneOffice,20),''))) AS ContactNo,
				ROW_NUMBER() OVER (PARTITION BY A.[OldCustomerID (textinput-131)] ORDER BY A.[OldCustomerID (textinput-131)]) AS RowNo,
                [CustomerID (textinput-1)] AS CorporateClientCd,
				[OldCustomerID (textinput-131)] AS ExtRefKey,
				[CustomerName (textinput-3)] AS CompanyName,
				ISNULL([IDType (selectsource-1)],'RegNumber') AS IdType,
				ISNULL([IDNumber (textinput-5)],'') AS IdNo,
				'MY' AS CountryOfRegistration,
				[DateofBirth (dateinput-1)] AS RegistrationDate,
				--LEFT(iif(email <> '', email, 'settlements@phillipcapital.com.au'),100) AS [ContactEmail],
				ISNULL(LEFT([PhoneOffice (textinput-17)],20),ISNULL(LEFT([PhoneMobile (textinput-57)],20),ISNULL(LEFT([PhoneHouse (textinput-55)],20),''))) AS ContactNo,
				'MY' AS TaxCountry
			FROM CQBTempDB.export.Tb_FormData_1410 AS A
			INNER JOIN import.Tb_CustomerIDMapping AS CM
			ON A.[OldCustomerID (textinput-131)] = CM.OldCustomerID
		   --FROM import.Tb_Customer AS A
		   --LEFT JOIN import.Ref_Occupation AS O
		   --ON A.[Column 29] = O.[Column 0]
		 --  LEFT JOIN GlobalBO.setup.Tb_CodeReferenceInternal T 
		 --  ON RefType='ClTitle' AND T.CompanyId = 1 AND 
			--(CASE WHEN charindex('.', [Column 19]) > 0 THEN LEFT([Column 19], charindex('.', [Column 19]) - 1) ELSE [Column 19] END) = RefDesc
		   --WHERE A.CustomerType IN ('2','3','5','6','9','A','B','C','D') -- 4,7,8,9 No data for this type in file
		   WHERE [ClientType (selectbasic-26)]='C'
	  )
      MERGE INTO GlobalBO.setup.Tb_CorporateClient AS TRGT
      USING cte_ClientDetails AS SRC ON
		SRC.CorporateClientCd = TRGT.CorporateClientCd
        WHEN MATCHED THEN UPDATE SET
        	TRGT.CompanyName = SRC.CompanyName,
        	TRGT.IdNo = SRC.IdNo,
            TRGT.CountryOfRegistration = SRC.CountryOfRegistration,
            TRGT.RegistrationDate = SRC.RegistrationDate,
			TRGT.ContactPerson = SRC.CompanyName,
            TRGT.ContactNo = SRC.ContactNo,
			--TRGT.ContactEmail = SRC.ContactEmail,
            TRGT.ModifiedBy = 'SYSBATCH',
            TRGT.ModifiedDate = GETDATE()
         WHEN NOT MATCHED BY TARGET THEN
         	INSERT (
				CompanyId,
            	CorporateClientCd,
                ExtRefKey,
				CompanyName,
                CompanyLogo,
                CompanyLetterHead,
                CompanyAddressId,
                CorporateType,
                IdType,
                IdNo,
                CountryOfRegistration,
                RegistrationDate,
                TaxInd,
                LicensedBrokerInd,
                LicensedClearingInd,
                ContactPerson,
                ContactEmail,
                ContactNo,
                BaseCurrCd,
                TaxRegisteredInd,
                RecordId,
                ActionInd,
                CurrentUser,
                CreatedBy,
                CreatedDate
            ) VALUES (
				1,
            	SRC.CorporateClientCd,
                SRC.ExtRefKey,
                SRC.CompanyName,
				'', -- CompanyLogo
                '', -- CompanyLetterHead
                NULL, -- CompanyAddressId
                'Both', -- CorporateType
                SRC.IdType, -- IdType
				SRC.IdNo, -- IdNo
                SRC.CountryOfRegistration, -- CountryOfRegistration
                SRC.RegistrationDate,
                'Y', -- TaxInd
                'N', -- LicensedBrokerInd
                'N', -- LicensedClearingInd
                SRC.CompanyName, --ContactPerson
                '',--SRC.ContactEmail, -- ContactEmail
                SRC.ContactNo, -- ContactNo
                'MYR', -- BaseCurrCd
                'Y', -- TaxRegisteredInd
                NEWID(), -- RecordId
                '', -- ActionInd
                '', -- CurrentUser
                'SYSBATCH',
                GETDATE() -- CreatedDate
				);
						
			--MERGE INTO GlobalBO.setup.Tb_AddressMaster AS TRGT
			--USING GlobalBO.setup.Tb_CorporateClient AS SRC ON
   --     		SRC.ExtRefKey = TRGT.ExtRefKey 
			--WHEN MATCHED AND TRGT.CategoryId = 2 THEN UPDATE SET
   --     		TRGT.CategoryId = SRC.CorporateClientId;

			--WITH cte_Addresses AS (
   --     		SELECT
   --         		AddressId,
			--		ExtRefKey
			--	FROM GlobalBO.setup.Tb_AddressMaster
			--	WHERE
   --         		AddressCategory = 2 AND
			--		DefaultInd = 'Y'
			--)
			--MERGE INTO GlobalBO.setup.Tb_CorporateClient AS TRGT
			--USING cte_Addresses AS SRC ON
   --     		SRC.ExtRefKey = TRGT.ExtRefKey
			--WHEN MATCHED AND TRGT.CompanyAddressId IS NULL THEN UPDATE SET
   --     		TRGT.CompanyAddressId = SRC.AddressId;

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
		@istrMailTo             = 'nishanthc@cyberquote.com.sg',   
		@istrMailBody           = @ostrReturnMessage,  
		@istrMailSubject        = 'UAT: Usp_ProcessCorporateClientDetails: Failed', 
		@istrimportance         = 'high', 
		@istrfrom_address       = 'ITGBODeploymentDB@cyberquote.com.sg', 
		@istrreply_to           = '',   
		@istrbody_format        = 'HTML'; 
        
    END CATCH
	SET NOCOUNT OFF;
END