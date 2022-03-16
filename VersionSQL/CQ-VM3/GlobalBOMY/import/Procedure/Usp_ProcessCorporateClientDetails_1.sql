/****** Object:  Procedure [import].[Usp_ProcessCorporateClientDetails_1]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [import].[Usp_ProcessCorporateClientDetails]
	@iintCompanyId BIGINT,
    @ostrReturnMessage VARCHAR(4000) OUTPUT
AS
/*********************************************************************************** 

Name              : import.Usp_ProcessCorporateClientDetails
Created By        : Nishanth Chowdhary
Created Date      : 19/06/2017
Last Updated Date : 
Description       : this sp is used to import the corporate clients from ClientData on a daily basis
Table(s) Used     : 
					

Modification History :  
 ModifiedBy :         Project Uin          ModifiedDate :           Reason :  
 
PARAMETERS 
	@iintCompanyId = the company id
    @ostrReturnMessage = the output message if there are any errors
		
Used By :
Exec [import].[Usp_ProcessCorporateClientDetails] 1, ''

************************************************************************************/
BEGIN

	SET NOCOUNT ON;
    
    BEGIN TRY
    	BEGIN TRANSACTION
        
		;WITH cte_ClientDetails AS (
            SELECT
                ROW_NUMBER() OVER (PARTITION BY A.custcode ORDER BY A.custcode) AS RowNo,
                custcode AS CorporateClientCd,
				'' AS ExtRefKey,
				ename + ' ' + esurname AS CompanyName,
				ISNULL(cardidtype,'RegNumber') AS IdType,
				ISNULL(cardid,'') AS IdNo,
				'TH' AS CountryOfRegistration,
				CONVERT(date,birthday,112) AS RegistrationDate,
				--LEFT(iif(email <> '', email, 'settlements@phillipcapital.com.au'),100) AS [ContactEmail],
				ISNULL(LEFT(secondtelno1,20),ISNULL(LEFT(secondtelno2,20),ISNULL(LEFT(firstfaxno2,20),''))) AS ContactNo,
				'TH' AS TaxCountry
		   FROM import.Acc_Cust1 AS A
		   --LEFT JOIN import.Ref_Occupation AS O
		   --ON A.[Column 29] = O.[Column 0]
		 --  LEFT JOIN GlobalBO.setup.Tb_CodeReferenceInternal T 
		 --  ON RefType='ClTitle' AND T.CompanyId = 1 AND 
			--(CASE WHEN charindex('.', [Column 19]) > 0 THEN LEFT([Column 19], charindex('.', [Column 19]) - 1) ELSE [Column 19] END) = RefDesc
		   WHERE A.personcode IN ('0','2') --AND [Column 101] IS NOT NULL
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
                'THB', -- BaseCurrCd
                'Y', -- TaxRegisteredInd
                NEWID(), -- RecordId
                '', -- ActionInd
                '', -- CurrentUser
                'SYSBATCH',
                GETDATE() -- CreatedDate
				);
        
		--WITH cte_Addresses AS (
  --          SELECT
  --              2 AS [AddressCategory], --1 = Company, 2 = Corporate Client, 3 = Personnel 
		--		--,3 [CategoryId]
		--		@iintCompanyId AS [CompanyId],
		--		AccountNo AS ExtRefKey,
		--		'O' As [AddressType],
		--	   	[Address1],
		--		[Address2],
		--		[Address3] + IIF(ISNULL([Address4],'') = '', '', ', ' + [Address4]) AS [Address3],
		--		LEFT([Suburb], 30) AS [City],
		--		[State],
		--		'AU' AS [CountryCd],
		--		[Postcode],
		--		'A' AS [AddressStatus],
		--		'Y' AS [DefaultInd] --default indicator; values Y or N 
		--	  FROM [ClientData].[dbo].[vAddress_Agility]
  --      )        
  --      MERGE INTO GlobalBO.setup.Tb_AddressMaster AS TRGT
  --      USING cte_Addresses AS SRC ON
  --      	--SRC.CategoryId = TRGT.CategoryId AND
  --          SRC.CompanyId = TRGT.CompanyId AND
  --          SRC.AddressCategory = TRGT.AddressCategory AND
  --          SRC.ExtRefKey collate Latin1_General_CI_AS = TRGT.ExtRefKey
  --      WHEN MATCHED THEN UPDATE SET
  --      	TRGT.AddressType = SRC.AddressType,
  --          TRGT.Address1 = SRC.Address1,
  --          TRGT.Address2 = SRC.Address2,
  --          TRGT.Address3 = SRC.Address3,
  --          TRGT.City = SRC.City,
		--	TRGT.[State] = SRC.[State],
  --          TRGT.CountryCd = SRC.CountryCd,
  --          TRGT.PostalCd = SRC.Postcode,
  --          TRGT.ModifiedBy = 'SYSBATCH',
  --          TRGT.ModifiedDate = GETDATE()
  --       WHEN NOT MATCHED BY TARGET THEN
  --       	INSERT (
  --          	AddressCategory,
  --              CategoryId,
  --              ExtRefKey,
  --              CompanyId,
  --              AddressType,
  --              Address1,
  --              Address2,
  --              Address3,
  --              City,
		--		[State],
  --              CountryCd,
  --              PostalCd,
  --              AddressStatus,
  --              DefaultInd,
  --              RecordId,
  --              CreatedBy,
  --              CreatedDate
  --          ) VALUES(
  --          	2,
  --              2,
  --              SRC.ExtRefKey,
  --              SRC.CompanyId,
  --              SRC.AddressType,
  --              SRC.Address1,
  --              SRC.Address2,
  --              SRC.Address3,
  --              SRC.City,
		--		SRC.[State],
  --              SRC.CountryCd,
  --              SRC.Postcode,
  --              'H', -- AddressStatus
  --             'Y',
  --              NEWID(), --RecordId
  --              'SYSBATCH', --CreatedBy
  --              GETDATE() --CreatedDate            
  --          );
						
			MERGE INTO GlobalBO.setup.Tb_AddressMaster AS TRGT
			USING GlobalBO.setup.Tb_CorporateClient AS SRC ON
        		SRC.ExtRefKey = TRGT.ExtRefKey 
			WHEN MATCHED AND TRGT.CategoryId = 2 THEN UPDATE SET
        		TRGT.CategoryId = SRC.CorporateClientId;

			WITH cte_Addresses AS (
        		SELECT
            		AddressId,
					ExtRefKey
				FROM GlobalBO.setup.Tb_AddressMaster
				WHERE
            		AddressCategory = 2 AND
					DefaultInd = 'Y'
			)
			MERGE INTO GlobalBO.setup.Tb_CorporateClient AS TRGT
			USING cte_Addresses AS SRC ON
        		SRC.ExtRefKey = TRGT.ExtRefKey
			WHEN MATCHED AND TRGT.CompanyAddressId IS NULL THEN UPDATE SET
        		TRGT.CompanyAddressId = SRC.AddressId;

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