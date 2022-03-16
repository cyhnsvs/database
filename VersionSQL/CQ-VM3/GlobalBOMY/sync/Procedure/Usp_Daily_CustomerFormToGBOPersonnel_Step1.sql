/****** Object:  Procedure [sync].[Usp_Daily_CustomerFormToGBOPersonnel_Step1]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [sync].[Usp_Daily_CustomerFormToGBOPersonnel_Step1]
	@iintCompanyId BIGINT,
    @ostrReturnMessage VARCHAR(4000) OUTPUT
AS
/*********************************************************************************** 

Name              : import.[Usp_Daily_CustomerFormToGBOPersonnel_Step1]
Created By        : Jansi
Created Date      : 09/04/2020
Last Updated Date : 
Description       : this sp is used to Synch Customer data to Personnel Daily
Table(s) Used     : 
					

Modification History :  
 ModifiedBy :         Project Uin          ModifiedDate :           Reason :  
 
PARAMETERS 
	@iintCompanyId = the company id
    @ostrReturnMessage = the output message if there are any errors
		
Used By :
Exec [sync].[Usp_Daily_CustomerFormToGBOPersonnel_Step1] 1, ''

************************************************************************************/
BEGIN

	SET NOCOUNT ON;
    
    BEGIN TRY
    	BEGIN TRANSACTION
        
		;WITH cte_ClientDetails AS (
            SELECT
                ROW_NUMBER() OVER (ORDER BY [CustomerID (textinput-1)]) AS RowNo,
                [CustomerID (textinput-1)] AS ClientCd,
				OldCustomerID AS ExtRefKey,
				ISNULL(T.RefCd,'1') AS Title,
				[CustomerName (textinput-3)] AS FirstName,
				'' AS LastName,
				[Gender (selectbasic-1)] AS Gender,
				[IDType (selectsource-1)] AS IdType,
				[IDNumber (textinput-5)] AS IdNo,
				[Nationality (selectsource-4)] AS Nationality, 
				'MY' AS PlaceOfBirth,
				Cast([CountryofResidence (selectsource-5)] As CHAR(2)) AS CountryOfResidence,
				CASE WHEN ISDATE(ISNULL(NULLIF(NULLIF([DateofBirth (dateinput-1)],''),'0001-01-01'),'1900-01-01')) = 0
					 THEN '1900-01-01'
					 ELSE CAST(ISNULL(NULLIF(NULLIF([DateofBirth (dateinput-1)],''),'0001-01-01'),'1900-01-01') as date) END AS DateOfBirth,
				[OccupationDesignation (selectsource-40)] AS Occupation,
				--ad.AddressId DefaultAddressId,
				LEFT([PhoneHouse (textinput-55)],20) AS HomeContactNo,
				LEFT([PhoneOffice (textinput-17)],20) AS OfficeContactNo,
				LEFT([PhoneMobile (textinput-57)],20) MobileContactNo,
				'MY' AS TaxCountry,
				[Race (selectsource-3)] As Race,
				[MaritalStatus (selectsource-11)] As MaritalStatus,
				CAST(CONVERT(decimal(24,9),[GrossAnnualIncome (multipleradios-3)]) As INT) As AnnualIncome
		   FROM CQBTempDB.export.Tb_FormData_1410 AS A -- Customer Form
			LEFT JOIN import.Tb_CustomerIDMapping AS CM
			ON A.[OldCustomerID (textinput-131)] = CM.OldCustomerID
		   --LEFT JOIN import.Ref_Occupation AS O
		   --ON A.[Column 29] = O.[Column 0]
		   LEFT JOIN GlobalBO.setup.Tb_CodeReferenceInternal T 
		   ON RefType='ClTitle' AND T.CompanyId = 1 AND 
			(CASE WHEN charindex('.', [Title (textinput-2)]) > 0 THEN LEFT([Title (textinput-2)], charindex('.', [Title (textinput-2)]) - 1) ELSE [Title (textinput-2)] END) = RefDesc
			WHERE [ClientType (selectbasic-26)]='I'
		   --WHERE  = '1'

		   UNION

		   SELECT
                ROW_NUMBER() OVER (ORDER BY [DealerCode (textinput-35)]) AS RowNo,
                [DealerCode (textinput-35)] AS ClientCd,
				[DealerAccountNo (textinput-37)] AS ExtRefKey,
				'' AS Title,
				[Name (textinput-3)] AS FirstName,
				'' AS LastName,
				[Sex (multipleradiosinline-2)] AS Gender,
				[IDNumberType (selectsource-2)] AS IdType,
				[IDNumber (textinput-9)] AS IdNo,
				'MY' AS Nationality, 
				'MY' AS PlaceOfBirth,
				[Country (selectsource-15)] AS CountryOfResidence,
				'1900-01-01' AS DateOfBirth,
				'' AS Occupation,
				'' AS HomeContactNo,
				LEFT([Phone (textinput-16)],20) AS OfficeContactNo,
				LEFT([MobilePhone (textinput-17)],20) MobileContactNo,
				'MY' AS TaxCountry,
				[Race (selectsource-5)] As Race,
				'' As MaritalStatus,
				'' As AnnualIncome
		   FROM CQBTempDB.export.Tb_FormData_1377 AS A -- Dealer Form
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
        
			--WITH cte_Addresses AS (
   --     		SELECT
   --         		AddressId,
			--		ExtRefKey
			--	FROM GlobalBO.setup.Tb_AddressMaster
			--	WHERE
   --         		AddressCategory = 3 AND
			--		DefaultInd = 'Y'
			--)
			--MERGE INTO GlobalBO.setup.Tb_Personnel AS TRGT
			--USING cte_Addresses AS SRC ON
   --     		SRC.ExtRefKey = TRGT.ExtRefKey
			--WHEN MATCHED AND TRGT.DefaultAddressId = 0 THEN UPDATE SET
   --     		TRGT.DefaultAddressId = SRC.AddressId;
			        		
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