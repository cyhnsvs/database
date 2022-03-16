/****** Object:  Procedure [sync].[Usp_OneTime_CustomerFileToGBOPersonnel_Step1]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [sync].[Usp_OneTime_CustomerFileToGBOPersonnel_Step1]
	@iintCompanyId BIGINT,
    @ostrReturnMessage VARCHAR(4000) OUTPUT
AS
/*********************************************************************************** 

Name              : import.Usp_ProcessClientDetails
Created By        : Jansi
Created Date      : 19/03/2020
Last Updated Date : 
Description       : this sp is used to import the clients from ClientData onetime
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
                ROW_NUMBER() OVER (PARTITION BY A.CustomerID ORDER BY A.CustomerID) AS RowNo,
                CustomerID AS ClientCd,
				'' AS ExtRefKey,
				ISNULL(T.RefCd,'1') AS Title,
				CustomerName AS FirstName,
				'' AS LastName,
				Sex AS Gender,
				IDType AS IdType,
				IDNumber AS IdNo,
				Nationality AS Nationality, 
				'MY' AS PlaceOfBirth,
				Cast(CountryOfResidence As CHAR(2)) AS CountryOfResidence,
				DateOfBirth AS DateOfBirth,
				Occupation AS Occupation,
				--ad.AddressId DefaultAddressId,
				LEFT(PhoneHouse,20) AS HomeContactNo,
				LEFT(PhoneOffice,20) AS OfficeContactNo,
				LEFT(PhoneMobile,20) MobileContactNo,
				'MY' AS TaxCountry,
				Race,
				MaritalStatus,
				CAST(CONVERT(decimal(24,9),AnnualIncome) As INT) As AnnualIncome
		   FROM import.Tb_Customer AS A
		   --LEFT JOIN import.Ref_Occupation AS O
		   --ON A.[Column 29] = O.[Column 0]
		   LEFT JOIN GlobalBO.setup.Tb_CodeReferenceInternal T 
		   ON RefType='ClTitle' AND T.CompanyId = 1 AND 
			(CASE WHEN charindex('.', Title) > 0 THEN LEFT(Title, charindex('.', Title) - 1) ELSE Title END) = RefDesc
		   WHERE A.CustomerType = '1'
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
				SRC.Race,
                SRC.MaritalStatus,
                'Unspecified',
				SRC.Occupation,
				'Unspecified',
				0,
				SRC.AnnualIncome,
				NEWID(),
				'',
				'',
				'SYSBATCH',
				GETDATE()
				);
        
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

		SELECT @ostrReturnMessage;
		
		--EXEC [master].[dbo].DBA_SendEmail   
		--@istrMailTo             = 'nishanthc@cyberquote.com.sg',
		--@istrMailBody           = @ostrReturnMessage,  
		--@istrMailSubject        = 'Usp_ProcessClientDetails: Failed', 
		--@istrimportance         = 'high', 
		--@istrfrom_address       = 'ITGBODeploymentDB@cyberquote.com.sg', 
		--@istrreply_to           = '',   
		--@istrbody_format        = 'HTML'; 
        
    END CATCH
	SET NOCOUNT OFF;
END