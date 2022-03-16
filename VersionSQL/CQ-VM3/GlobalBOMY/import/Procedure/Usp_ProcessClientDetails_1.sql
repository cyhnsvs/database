/****** Object:  Procedure [import].[Usp_ProcessClientDetails_1]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [import].[Usp_ProcessClientDetails]
	@iintCompanyId BIGINT,
    @ostrReturnMessage VARCHAR(4000) OUTPUT
AS
/*********************************************************************************** 

Name              : import.Usp_ProcessClientDetails
Created By        : Nishanth Chowdhary
Created Date      : 30/05/2017
Last Updated Date : 
Description       : this sp is used to import the clients from ClientData on a daily basis
Table(s) Used     : 
					

Modification History :  
 ModifiedBy :         Project Uin          ModifiedDate :           Reason :  
 
PARAMETERS 
	@iintCompanyId = the company id
    @ostrReturnMessage = the output message if there are any errors
		
Used By :
Exec [import].[Usp_ProcessClientDetails] 1, ''

************************************************************************************/
BEGIN

	SET NOCOUNT ON;
    
    BEGIN TRY
    	BEGIN TRANSACTION
        
		;WITH cte_ClientDetails AS (
            SELECT
                ROW_NUMBER() OVER (PARTITION BY A.custcode ORDER BY A.custcode) AS RowNo,
                custcode AS ClientCd,
				'' AS ExtRefKey,
				ISNULL(T.RefCd,'1') AS Title,
				--LEFT([Column 19], charindex('.', [Column 19]) - 1) AS Title,
				--LEFT([Column 19], 10) AS Title,
				ename AS FirstName,
				esurname AS LastName,
				sex AS Gender,
				cardidtype AS IdType,
				cardid AS IdNo,
				'TH' AS Nationality, --[Column 30] 
				'TH' AS PlaceOfBirth,
				'TH' AS CountryOfResidence,
				CONVERT(DATE,birthday,112) AS DateOfBirth,
				--LEFT(ISNULL(O.[Column 1],''),50) AS Occupation,
				'' AS Occupation,
				--ad.AddressId DefaultAddressId,
				LEFT(secondtelno2,20) AS HomeContactNo,
				LEFT(firstfaxno2,20) AS OfficeContactNo,
				LEFT(secondtelno1,20) MobileContactNo,
				'TH' AS TaxCountry
		   FROM import.Acc_Cust1 AS A
		   --LEFT JOIN import.Ref_Occupation AS O
		   --ON A.[Column 29] = O.[Column 0]
		   LEFT JOIN GlobalBO.setup.Tb_CodeReferenceInternal T 
		   ON RefType='ClTitle' AND T.CompanyId = 1 AND 
			(CASE WHEN charindex('.', etitle) > 0 THEN LEFT(etitle, charindex('.', etitle) - 1) ELSE etitle END) = RefDesc
		   WHERE A.personcode NOT IN ('0','2')
	  )
      MERGE INTO GlobalBO.setup.Tb_Personnel AS TRGT
      USING cte_ClientDetails AS SRC ON
		SRC.ClientCd = TRGT.ClientCd
        WHEN MATCHED THEN UPDATE SET
        	TRGT.Title = SRC.Title,
			TRGT.FirstName = SRC.FirstName,
            TRGT.LastName = SRC.LastName,
            TRGT.Gender = SRC.Gender,
            TRGT.IdType = SRC.IdType,
            TRGT.IdNo = SRC.IdNo,
            TRGT.Nationality = SRC.Nationality,
			TRGT.PlaceOfBirth = SRC.PlaceOfBirth,
            TRGT.CountryOfResidence = SRC.CountryOfResidence,
            TRGT.DateOfBirth = SRC.DateOfBirth,
            TRGT.Occupation = SRC.Occupation,
            TRGT.HomeContactNo = SRC.HomeContactNo,
            TRGT.OfficeContactNo = SRC.OfficeContactNo,
            TRGT.MobileContactNo = SRC.MobileContactNo,
			TRGT.TaxCountry = SRC.TaxCountry,
            TRGT.ModifiedBy = 'SYSBATCH',
            TRGT.ModifiedDate = GETDATE()
         WHEN NOT MATCHED BY TARGET THEN
         	INSERT (
            	CompanyId,
                ClientCd,
                ExtRefKey,
                Title,
                FirstName,
                LastName,
                Gender,
                IdType,
                IdNo,
                Nationality,
                PlaceOfBirth,
                CountryOfResidence,
                TaxInd,
                DefaultAddressId,
                HomeContactNo,
                OfficeContactNo,
                MobileContactNo,
                DateOfBirth,
                TaxCountry,
                Race,
                MaritalStatus,
                HomeOwnership,
                Occupation,
                Employer,
                YearsOfService,
                AnnualIncome,
                RecordId,
                ActionInd,
                CurrentUser,
                CreatedBy,
                CreatedDate
            ) VALUES (
				1,
            	SRC.ClientCd,
                SRC.ExtRefKey,
                SRC.Title,
				SRC.FirstName,
				SRC.LastName,
				SRC.Gender,
				SRC.IdType,
				SRC.IdNo,
				SRC.Nationality,
				SRC.PlaceOfBirth,
				SRC.CountryOfResidence,
				'Y',
				0,
				SRC.HomeContactNo,
				SRC.OfficeContactNo,
				SRC.MobileContactNo,
				SRC.DateOfBirth,
				SRC.TaxCountry,
				'Unspecified',
				'Unspecified',
				'Unspecified',
				SRC.Occupation,
				'Unspecified',
				0,
				0,
				NEWID(),
				'',
				'',
				'SYSBATCH',
				GETDATE()
				);
        
		--WITH cte_Addresses AS (
  --          SELECT
  --              3 AS [AddressCategory], --1 = Company, 2 = Corporate Client, 3 = Personnel 
		--		--,3 [CategoryId]
		--		@iintCompanyId AS [CompanyId],
		--		AccountNo AS ExtRefKey,
		--		'H' As [AddressType],
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
  --          	3,
  --              3,
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
			
			WITH cte_Addresses AS (
        		SELECT
            		AddressId,
					ExtRefKey
				FROM GlobalBO.setup.Tb_AddressMaster
				WHERE
            		AddressCategory = 3 AND
					DefaultInd = 'Y'
			)
			MERGE INTO GlobalBO.setup.Tb_Personnel AS TRGT
			USING cte_Addresses AS SRC ON
        		SRC.ExtRefKey = TRGT.ExtRefKey
			WHEN MATCHED AND TRGT.DefaultAddressId = 0 THEN UPDATE SET
        		TRGT.DefaultAddressId = SRC.AddressId;
			        		
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
		@istrMailSubject        = 'Usp_ProcessClientDetails: Failed', 
		@istrimportance         = 'high', 
		@istrfrom_address       = 'ITGBODeploymentDB@cyberquote.com.sg', 
		@istrreply_to           = '',   
		@istrbody_format        = 'HTML'; 
        
    END CATCH
	SET NOCOUNT OFF;
END