/****** Object:  Procedure [export].[USP_AcctOpening_CFT910_Validation]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_AcctOpening_CFT910_Validation]
AS
/***********************************************************************************             
Name              : [export].[USP_AcctOpening_CFT910_Validation]
Created By        : Kristine
Created Date      : 2021-10-26
Last Updated Date :             
Description       : 
            
Table(s) Used     : 
            
Modification History :  	
 ModifiedBy : 			ModifiedDate : 			Reason : 

 
PARAMETERS
            
Used By : 
EXEC [export].[USP_AcctOpening_CFT910_Validation]

SELECT * FROM [GlobalBOMY].[export].[Tb_BURSA_CFT910] 
************************************************************************************/
BEGIN
	
	BEGIN TRY
		
		BEGIN TRANSACTION
		UPDATE E
		SET StatusRemarks = CONCAT(
		   CASE WHEN NULLIF([RecordType],'') IS NULL THEN '[ERROR]: "RecordType" is mandatory ; '
				WHEN LEN([RecordType]) > 1 THEN '[ERROR]: "RecordType" data length not passed; ' 
				WHEN [RecordType] <> '1' THEN '[ERROR]: "RecordType" must be 1 ;' 
				END 
		  ,CASE WHEN NULLIF([ParticiapantCode],'') IS NULL THEN '[ERROR]: "ParticipantCode" is mandatory ; '
				WHEN LEN([ParticiapantCode]) > 9 THEN '[ERROR]: "ParticipantCode" data length not passed; ' 
				END 
		  ,CASE WHEN NULLIF([AcctNo],'') IS NOT NULL AND LEN([AcctNo]) > 9 THEN '[ERROR]: "AcctNo" data length not passed; ' 
				END
		  ,CASE WHEN NULLIF([AcctType],'') IS NULL THEN '[ERROR]: "AcctType" is mandatory; ' 
				WHEN LEN([AcctType]) > 2 THEN '[ERROR]: "AcctType" data length not passed; ' 
				END 	  
		  ,CASE WHEN NULLIF([NRICId],'') IS NULL THEN '[ERROR]: "NRICId" is mandatory; ' 
				WHEN LEN([NRICId]) > 14 THEN '[ERROR]: "NRICId" data length not passed; ' 
				ELSE CASE WHEN CHARINDEX(E.NRICId, '-') > 0 -- NRIC ONLY
						  THEN CASE WHEN LEN(E.NRICId) <> 14  THEN '[ERROR]: "NRICId" format is invalid. Must be 14 digits with hyphen; ' 
									WHEN (CHARINDEX('-',E.NRICId) <> 7 AND CHARINDEX('-',E.NRICId,8) <> 10) THEN '[ERROR]: "NRICId" format is invalid. Must be 14 digits with hyphen; ' 
									END
						  END
				END 
		  ,CASE WHEN NULLIF([OldNRICId],'') IS NOT NULL AND LEN([OldNRICId]) > 14 THEN '[ERROR]: "OldNRICId" data length not passed; ' 
				END
		  ,CASE WHEN NULLIF([ExistInvInd],'') IS NOT NULL 
				THEN CASE WHEN LEN([ExistInvInd]) > 1 THEN '[ERROR]: "ExistInvInd" data length not passed; ' 
						  WHEN [ExistInvInd] NOT IN ('Y','N') THEN '[ERROR]: "ExistInvInd" value provided is not existing in spec options; ' 
					 END
				END 
		  ,CASE WHEN NULLIF([InvestorName],'') IS NULL THEN '[ERROR]: "InvestorName" is mandatory ; '
				WHEN LEN([InvestorName]) > 60 THEN '[ERROR]: "InvestorName" data length not passed; ' 
				END
		  ,CASE WHEN NULLIF([InvestorType],'') IS NULL THEN '[ERROR]: "InvestorType" is mandatory; ' 
				WHEN LEN([InvestorType]) > 2 THEN '[ERROR]: "InvestorType" data length not passed; ' 
				ELSE CONCAT( CASE WHEN E.InvestorType NOT IN ('C1', 'C2', 'C3', 'C4', 'C5', 'C6', 'C7', 'C8', 'C8', 'C9', 'I', 'O', 'T')	THEN '[ERROR]: "InvestorType" is an invalid option; ' END
							,CASE WHEN E.InvestorType = 'C8' AND ISNULL(E.BeneficialOwner,'') = ''	THEN '[ERROR]: "BeneficialOwner" is mandatory; 'END
							,CASE WHEN E.InvestorType = 'C8' AND ISNULL(E.Qualifier1,'') = ''	THEN '[ERROR]: "Qualifier1" is mandatory; ' END 
					)
				END 
		  ,CASE WHEN NULLIF([Nationality/POI],'') IS NULL THEN '[ERROR]: "Nationality/POI" is mandatory ; '
				WHEN LEN([Nationality/POI]) > 3 THEN '[ERROR]: "Nationality/POI" data length not passed; ' 
				ELSE CASE WHEN CM3.BursaCountryCode IS NULL	THEN '[ERROR]: "Nationality/POI" is an invalid option; ' END
				END
		  ,CASE WHEN NULLIF([Race],'') IS NULL THEN '[ERROR]: "Race" is mandatory; ' 
				WHEN LEN([Race]) > 1 THEN '[ERROR]: "Race" data length not passed; ' 
				ELSE CASE WHEN E.Race NOT IN ('B', 'C', 'F', 'N', 'I', 'K', 'M', 'D', 'O','J', 'K', 'L')	THEN '[ERROR]: "Race" is an invalid option; ' END
						  --WHEN 
						  --END
				END 
		  ,CASE WHEN NULLIF([Address1],'') IS NULL THEN '[ERROR]: "Address1" is mandatory; ' 
				WHEN LEN([Address1]) > 45 THEN '[ERROR]: "Address1" data length not passed; ' 
				END 
		  ,CASE WHEN NULLIF([Address2],'') IS NOT NULL AND LEN([Address2]) > 45 THEN '[ERROR]: "Address2" data length not passed; ' 
				END
		  ,CASE WHEN NULLIF([Town],'') IS NULL THEN '[ERROR]: "Town" is mandatory; ' 
				WHEN LEN([Town]) > 25 THEN '[ERROR]: "Town" data length not passed; ' 
				END 
		  ,CASE WHEN E.Country = 'MYS' AND NULLIF([State],'') IS NULL THEN '[ERROR]: "State" is mandatory; ' 
				WHEN LEN([State]) > 1 THEN '[ERROR]: "State" data length not passed; ' 
				WHEN NULLIF([State],'') IS NOT NULL 
					THEN CASE WHEN ISNULL(E.Country,'') NOT IN ('MYS','') THEN '[ERROR]: "State" should be empty for Non-Malaysia Country; ' 
							  WHEN E.Country = 'MYS' AND E.[State] NOT IN ('A', 'B', 'C', 'D', 'J', 'K', 'L', 'M', 'N', 'P', 'R', 'S', 'T', 'W', 'Y')	THEN '[ERROR]: "State" is invalid for Malaysia; ' 
							  END
				END 
		  ,CASE WHEN NULLIF([PostalCode],'') IS NULL THEN '[ERROR]: "PostalCode" is mandatory; ' 
				WHEN LEN([PostalCode]) > 5 THEN '[ERROR]: "PostalCode" data length not passed; ' 
				END 
		  ,CASE WHEN NULLIF([Country],'') IS NULL THEN '[ERROR]: "Country" is mandatory; ' 
				WHEN LEN([Country]) > 3 THEN '[ERROR]: "Country" data length not passed; ' 
				ELSE CASE WHEN CM1.BursaCountryCode IS NULL	THEN '[ERROR]: "Country" is an invalid option; ' END
				END 
		  ,CASE WHEN NULLIF([BeneficialOwner],'') IS NOT NULL AND LEN([BeneficialOwner]) > 1 THEN '[ERROR]: "BeneficialOwner" data length not passed; ' 
				END
		  ,CASE WHEN NULLIF([Qualifier1],'') IS NOT NULL AND LEN([Qualifier1]) > 60 THEN '[ERROR]: "Qualifier1" data length not passed; ' 
				END
		  ,CASE WHEN NULLIF([Qualifier2],'') IS NOT NULL AND LEN([Qualifier2]) > 60 THEN '[ERROR]: "Qualifier2" data length not passed; ' 
				END
		  ,CASE WHEN NULLIF([CorrAddress1],'') IS NOT NULL 
				THEN CONCAT( CASE WHEN LEN([CorrAddress1]) > 45 THEN '[ERROR]: "CorrAddress1" data length not passed; ' END 
							,CASE WHEN NULLIF([CorrAddress2],'') IS NULL THEN '[ERROR]: "CorrAddress2" is mandatory; ' 
								  WHEN LEN([CorrAddress2]) > 45 THEN '[ERROR]: "CorrAddress2" data length not passed; ' 
								  END
							,CASE WHEN NULLIF([CorrTown],'') IS NULL THEN '[ERROR]: "CorrTown" is mandatory; ' 
								  WHEN LEN([CorrTown]) > 25 THEN '[ERROR]: "CorrTown" data length not passed; ' 
								  END 
							,CASE WHEN E.CorrCountry = 'MYS' AND NULLIF(E.CorrState,'') IS NULL THEN '[ERROR]: "CorrState" is mandatory; ' 
								  WHEN NULLIF(E.CorrState,'') IS NOT NULL 
										THEN CASE WHEN LEN([CorrState]) > 1 THEN '[ERROR]: "CorrState" data length not passed; ' 
												  WHEN ISNULL(E.CorrCountry,'') NOT IN ('MYS','') THEN '[ERROR]: "CorrState" should be empty for Non-Malaysia Country; ' 
												  WHEN E.CorrCountry = 'MYS' AND E.CorrState NOT IN ('A', 'B', 'C', 'D', 'J', 'K', 'L', 'M', 'N', 'P', 'R', 'S', 'T', 'W', 'Y')	THEN '[ERROR]: "CorrState" is invalid for Malaysia; '
												  END
								  END 
							,CASE WHEN NULLIF([CorrPostalCode],'') IS NULL THEN '[ERROR]: "CorrPostalCode" is mandatory; ' 
								  WHEN LEN([CorrPostalCode]) > 5 THEN '[ERROR]: "CorrPostalCode" data length not passed; ' 
								  WHEN TRY_CAST([CorrPostalCode] AS int) IS NULL THEN '[ERROR]: "CorrPostalCode" data type not passed; ' 
								  WHEN LEN([CorrPostalCode]) > 5 THEN '[ERROR]: "CorrPostalCode" data length not passed; ' 
								  END 
							,CASE WHEN NULLIF([CorrCountry],'') IS NULL THEN '[ERROR]: "CorrCountry" is mandatory; ' 
								  WHEN LEN([CorrCountry]) > 3 THEN '[ERROR]: "CorrCountry" data length not passed; ' 
								  ELSE CASE WHEN CM2.BursaCountryCode IS NULL THEN '[ERROR]: "CorrCountry" is an invalid option; ' END
								  END 
							)
				  END 
		  ,CASE WHEN NULLIF([PhoneIdd],'') IS NOT NULL 
				THEN CASE WHEN TRY_CAST([PhoneIdd] AS int) IS NULL THEN '[ERROR]: "PhoneIdd" data type not passed; ' 
						  WHEN LEN([PhoneIdd]) > 3 THEN '[ERROR]: "PhoneIdd" data length not passed; ' 
					 END
				END 
		  ,CASE WHEN NULLIF([PhoneStd],'') IS NOT NULL AND LEN([PhoneStd]) > 5 THEN '[ERROR]: "PhoneStd" data length not passed; ' 
				END 
		  ,CASE WHEN NULLIF([PhoneLocal],'') IS NOT NULL 
				THEN CONCAT( CASE WHEN TRY_CAST([PhoneLocal] AS INT) IS NULL THEN '[ERROR]: "PhoneLocal" data type not passed; ' END
							,CASE WHEN LEN([PhoneLocal]) > 8 THEN '[ERROR]: "PhoneLocal" data length not passed; ' END )
				END 
		  ,CASE WHEN NULLIF([PhoneExt],'') IS NOT NULL 
				THEN CONCAT( CASE WHEN TRY_CAST([PhoneExt] AS INT) IS NULL THEN '[ERROR]: "PhoneExt" data type not passed; ' END 
							,CASE WHEN LEN([PhoneExt]) > 3 THEN '[ERROR]: "PhoneExt" data length not passed; ' END )
				END
		  ,CASE WHEN LEN([AcctStatus]) > 1 THEN '[ERROR]: "AcctStatus" data length not passed; ' 
				END
		  ,CASE WHEN NULLIF([BankAccount],'') IS NULL THEN '[ERROR]: "BankAccount" is mandatory; ' 
				WHEN LEN([BankAccount]) > 20 THEN '[ERROR]: "BankAccount" data length not passed; ' 
				END
		  ,CASE WHEN NULLIF([BankCode],'') IS NULL THEN '[ERROR]: "BankCode" is mandatory; ' 
				WHEN LEN([BankCode]) > 6 THEN '[ERROR]: "BankCode" data length not passed; ' 
				WHEN BM.BursaBankCode IS NULL	THEN '[ERROR]: "BankCode" is an invalid option' 
				END
		  ,CASE WHEN NULLIF([ConsolidateInd],'') IS NULL THEN '[ERROR]: "ConsolidateInd" is mandatory; ' 
				WHEN LEN([ConsolidateInd]) > 1 THEN '[ERROR]: "ConsolidateInd" data length not passed; ' 
				WHEN E.ConsolidateInd NOT IN ('Y','N')	THEN '[ERROR]: "ConsolidateInd" must be Y or N ' 
				END
		  ,CASE WHEN NULLIF([JointInd],'') IS NULL THEN '[ERROR]: "JointInd" is mandatory; ' 
				WHEN LEN([JointInd]) > 1 THEN '[ERROR]: "JointInd" data length not passed; ' 
				WHEN E.JointInd NOT IN ('Y','N')	THEN '[ERROR]: "JointInd" must be Y or N ' 
				END
		  ,CASE WHEN NULLIF([PhoneMobileIdd],'') IS NOT NULL 
				THEN CONCAT( CASE WHEN TRY_CAST([PhoneMobileIdd] AS INT) IS NULL THEN '[ERROR]: "PhoneMobileIdd" data type not passed; ' END 
							,CASE WHEN LEN([PhoneMobileIdd]) > 3 THEN '[ERROR]: "PhoneMobileIdd" data length not passed; ' END  )
				END
		  ,CASE WHEN NULLIF([PhoneMobileCode],'') IS NOT NULL AND LEN([PhoneMobileCode]) > 3 THEN '[ERROR]: "PhoneMobileCode" data length not passed; ' 
				END
		  ,CASE WHEN NULLIF([PhoneMobileNo],'') IS NOT NULL 
				THEN CONCAT( CASE WHEN TRY_CAST([PhoneMobileNo] AS BIGINT) IS NULL THEN '[ERROR]: "PhoneMobileNo" data type not passed; ' END 
							,CASE WHEN LEN([PhoneMobileNo]) > 8 THEN '[ERROR]: "PhoneMobileNo" data length not passed; ' END )
				END
		  ,CASE WHEN NULLIF([Email],'') IS NOT NULL AND LEN([Email]) > 200 THEN '[ERROR]: "Email" data length not passed; ' END
		  ,CASE WHEN NULLIF([DateConsentEnd],'') IS NOT NULL 
				THEN CASE WHEN LEN([DateConsentEnd]) > 8 THEN '[ERROR]: "DateConsentEnd" data length not passed; ' 
						  WHEN (ISDATE([DateConsentEnd]) = 0  OR (ISDATE([DateConsentEnd]) = 1 AND [DateConsentEnd] NOT LIKE '[0-3][0-9][0-1][0-9][1-2][0-9][0-9][0-9]' ))  
								THEN '[ERROR]: "DateConsentEnd" data type not passed; ' 
					 END
				END
		  ,CASE WHEN NULLIF([Remarks],'') IS NOT NULL AND LEN([Remarks]) > 30 THEN '[ERROR]: "Remarks" data length not passed; ' END
		  ,CASE WHEN NULLIF([TaggingCode],'') IS NOT NULL AND LEN([TaggingCode]) > 1 THEN '[ERROR]: "TaggingCode" data length not passed; ' END
		  ,CASE WHEN NULLIF([Filler],'') IS NOT NULL AND LEN([Filler]) > 44 THEN '[ERROR]: "Filler" data length not passed; ' END
		 )
		FROM [GlobalBOMY].[export].[Tb_BURSA_CFT910]  E
		LEFT JOIN GlobalBOMY.export.Tb_Bursa_Country_Mapping AS CM1
			ON E.Country = CM1.BursaCountryCode
		LEFT JOIN GlobalBOMY.export.Tb_Bursa_Country_Mapping AS CM2
			ON E.CorrCountry = CM2.BursaCountryCode
		LEFT JOIN GlobalBOMY.export.Tb_Bursa_Country_Mapping AS CM3
			ON E.[Nationality/POI] = CM3.BursaCountryCode
		LEFT JOIN GlobalBOMY.export.Tb_Bursa_Bank_Mapping AS BM
			ON E.BankCode = BM.BursaBankCode


		UPDATE [GlobalBOMY].[export].[Tb_BURSA_CFT910]
		SET [Status] = IIF(NULLIF(StatusRemarks,'') IS NOT NULL, 'R','C')


		COMMIT TRANSACTION

	END TRY
	BEGIN CATCH

		ROLLBACK TRANSACTION;
	    
        DECLARE @intErrorNumber INT
	        ,@intErrorLine INT
	        ,@intErrorSeverity INT
	        ,@intErrorState INT
	        ,@strObjectName VARCHAR(200)
			,@ostrReturnMessage VARCHAR(4000);

        SELECT @intErrorNumber = ERROR_NUMBER()
	        ,@ostrReturnMessage = ERROR_MESSAGE()
	        ,@intErrorLine = ERROR_LINE()
	        ,@intErrorSeverity = ERROR_SEVERITY()
	        ,@intErrorState = ERROR_STATE()
	        ,@strObjectName = ERROR_PROCEDURE();

        RAISERROR (
		        @ostrReturnMessage
		        ,@intErrorSeverity
		        ,@intErrorState
		        );
	END CATCH




	

END