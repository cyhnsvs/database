/****** Object:  Procedure [sync].[Usp_Personnel]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [sync].[Usp_Personnel]
	--@iintCompanyId BIGINT,
    --@ostrReturnMessage VARCHAR(4000) OUTPUT
AS
/*********************************************************************************** 

Name              : sync.[Usp_Personnel]
Created By        : Nishanth Chowdhary
Created Date      : 12/03/2020
Last Updated Date : 
Description       : this sp is used to sync client details from CQB to GBO
Table(s) Used     : 
					

Modification History :  
 ModifiedBy :         Project Uin          ModifiedDate :           Reason :  

PARAMETERS 
	@iintCompanyId = the company id
    @ostrReturnMessage = the output message if there are any errors
		
Used By :
Exec [sync].[Usp_Personnel] 1, ''

************************************************************************************/
BEGIN

	SET NOCOUNT ON;
	BEGIN TRY
		
		;WITH cte_ClientDetails AS (
            SELECT DISTINCT 
                ROW_NUMBER() OVER (PARTITION BY CI.[Customerno (textinput-119)] ORDER BY CI.[Customerno (textinput-119)]) AS RowNo,
                [Customerno (textinput-119)] AS ClientCd,
				'' AS ExtRefKey,
				'1' AS Title,
				--LEFT([Column 19], charindex('.', [Column 19]) - 1) AS Title,
				--LEFT([Column 19], 10) AS Title,
				LEFT(AOF.[FirstName (selectsource-8)],100) AS FirstName,
				LEFT(AOF.[Surname (selectsource-9)],100) AS LastName,
				LEFT([Gender (multipleradios-3)],1) AS Gender,
				LEFT(AOF.[CardType (selectsource-10)],1) AS IdType,
				LEFT(AOF.[CardNo (textinput-6)],50) AS IdNo,
				'TH' AS Nationality, --[Column 30] 
				'TH' AS PlaceOfBirth,
				'TH' AS CountryOfResidence,
				--CONVERT(date,[DateofBirth (dateinput-0)],105) AS DateOfBirth,
				CASE WHEN ISDATE([DateofBirth (dateinput-0)]) = 1 THEN [DateofBirth (dateinput-0)] ELSE '' END AS DateOfBirth,
				--LEFT(ISNULL(O.[Column 1],''),50) AS Occupation,
				left([Occupation (selectsource-5)],50) AS Occupation,
				--ad.AddressId DefaultAddressId,
				LEFT([TelHome (textinput-13)],20) AS HomeContactNo,
				LEFT([TelOffice (textinput-31)],20) AS OfficeContactNo,
				LEFT([MobileNumbertoreceiveOnetimepasswordOTP (textinput-33)],20) MobileContactNo,
				'TH' AS TaxCountry
		   FROM form.Tb_ExportFormData_106 AS CI
		   INNER JOIN form.Tb_ExportFormData_199 AS AOF
		   ON CI.[Customerno (textinput-119)] = AOF.[Customerno (textinput-47)] and [Customerno (textinput-119)] != ''
		 --  LEFT JOIN GlobalBO.setup.Tb_CodeReferenceInternal T 
		 --  ON RefType='ClTitle' AND T.CompanyId = 1 AND 
			--(CASE WHEN charindex('.', etitle) > 0 THEN LEFT(etitle, charindex('.', etitle) - 1) ELSE etitle END) = RefDesc
		   WHERE CI.[PersonCode (selectbasic-16)] IN ('1','3')
		   --WHERE CI.[PersonCode (selectbasic-16)] IN ('Local Natural person','Foreign Natural person','Local Provident Fund','Foreign Provident Fund')
		   --AND CI.[Customerno (textinput-119)] <> '81322'
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

	END TRY
    BEGIN CATCH
    
    	DECLARE @intErrorNumber INT
	    ,@intErrorLine INT
	    ,@intErrorSeverity INT
	    ,@intErrorState INT
	    ,@strObjectName VARCHAR(200)
		,@ostrReturnMessage VARCHAR(4000);

		DECLARE @strEmailSubj VARCHAR(100) = (SELECT Value1 FROM setup.Tb_Lookup WHERE CodeType='EmailSubject' AND CodeName='Environment'),
				@strEmailTo VARCHAR(200) = (SELECT ToEmails FROM setup.Tb_EmailAlert WHERE ModeDefinition='ErrorEmail'),
				@strEmailFrom VARCHAR(200) = (SELECT Sendername FROM setup.Tb_EmailAlert WHERE ModeDefinition='ErrorEmail');
		
		SET @strEmailSubj = @strEmailSubj + ' - Usp_Personnel: Failed';

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
		@istrMailTo             = @strEmailTo,
		@istrMailBody           = @ostrReturnMessage,  
		@istrMailSubject        = @strEmailSubj, 
		@istrimportance         = 'high', 
		@istrfrom_address       = @strEmailFrom, 
		@istrreply_to           = '',   
		@istrbody_format        = 'HTML'; 
        
    END CATCH
	SET NOCOUNT OFF;
END