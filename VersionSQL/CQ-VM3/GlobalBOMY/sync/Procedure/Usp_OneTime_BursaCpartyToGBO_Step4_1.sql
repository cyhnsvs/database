/****** Object:  Procedure [sync].[Usp_OneTime_BursaCpartyToGBO_Step4_1]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [sync].[Usp_OneTime_BursaCpartyToGBO_Step4_1]
	@iintCompanyId BIGINT,
    @ostrReturnMessage VARCHAR(4000) OUTPUT
AS
/*********************************************************************************** 

Name              : import.Usp_ProcessAddressDetails
Created By        : Jansi
Created Date      : 31/03/2020
Last Updated Date : 
Description       : this sp is used to import the address from ClientData onetime
Table(s) Used     : 
					

Modification History :  
 ModifiedBy :         Project Uin          ModifiedDate :           Reason :  
 
PARAMETERS 
	@iintCompanyId = the company id
    @ostrReturnMessage = the output message if there are any errors
		
Used By :
Exec [import].[Usp_ProcessAddressDetails] 1, ''

************************************************************************************/
BEGIN

	SET NOCOUNT ON;
    
    BEGIN TRY
        
			INSERT INTO GlobalBO.setup.Tb_CorporateClient(
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
            ) 
			SELECT 
				1,
            	'001' As CorporateClientCd,
                '001' As ExtRefKey,
                'BURSA' As CompanyName,
				'' As CompanyLogo,
                '' As CompanyLetterHead,
                NULL As CompanyAddressId,
                'Both' As CorporateType,
                'BR' As IdType, 
				'BRK001' As IdNo, 
                'MY' As CountryOfRegistration,
                '0001-01-01' As RegistrationDate,
                'Y' As  TaxInd,
                'N' As  LicensedBrokerInd,
                'N' As  LicensedClearingInd,
                'BURSA' As ContactPerson,
                '' As ContactEmail,
                '' As ContactNo,
                'MYR' As BaseCurrCd,
                'Y' As TaxRegisteredInd,
                NEWID() As RecordId,
                '' As ActionInd,
                '' As CurrentUser,
                'SYSBATCH',
                GETDATE() As CreatedDate;

			INSERT INTO GlobalBO.setup.Tb_Account(
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
            SELECT		
              'CPBURSA001'  As AcctNo,
              1 As CompanyId,
              SCOPE_IDENTITY() As ExtRefKey,
              1 As BranchId,
              'Corporate Client' As AcctSegregationType,
              'CL' As AcctCategory,
              'Speculative' As AcctMarginType,
              'B' As ServiceType,
              NULL As GroupAccountNo,
              SCOPE_IDENTITY() As MainClientId,              
              'CI' As AcctType,
              'Bursa' As ChequeName,
              'BMSB' As AcctExecutiveCd,
              'MYR' As ClientBaseCurrCd,
              'MYR' As DefaultSetlCurrCd,
              0 As ResidenceAddressId,
              0 As MailingAddressId,
              '' As Email,
              '1900-01-01' As AcctCreationDate,
              'AA' As AcctStatus,
              '' As AcctStatusRemarks,
              Null As Remarks,
              NEWID() As RecordId,
              '' As ActionInd,
              '' As CurrentUser,
              'SYSBATCH' As CreatedBy,
              GETDATE() As CreatedDate;

        	INSERT INTO GlobalBO.Setup.Tb_AddressMaster (
            	AddressCategory,
                CategoryId,
                ExtRefKey,
                CompanyId,
                AddressType,
                Address1,
                Address2,
                Address3,
                City,
				[State],
                CountryCd,
                PostalCd,
                AddressStatus,
                DefaultInd,
                RecordId,
                CreatedBy,
                CreatedDate
            ) 
			SELECT
            	2 As AddressCategory,
                1,
                '001' As ExtRefKey,
                1 As CompanyId,
                'O' As AddressType,
                '' As Address1,
                '' As Address2,
                '' As Address3,
                '' As City,
				'' As [State],
                'MY' As CountryCd,
                '' As PostalCd,
                'A' As AddressStatus,
                'Y' As DefaultInd,
                NEWID() As RecordId,
                'SYSBATCH' As CreatedBy,
                GETDATE() As CreatedDate            
			
		IF OBJECT_ID('tempdb.dbo.#tmpAddress') IS NOT NULL DROP TABLE #tmpAddress

		CREATE TABLE dbo.#tmpAddress (
		AddressId BIGINT,
		ExtRefKey VARCHAR(50)
		)
		INSERT INTO #tmpAddress
		SELECT
			AddressId, 
			ExtRefKey 
		FROM GlobalBO.setup.Tb_AddressMaster
		WHERE
			DefaultInd = 'Y' AND ExtRefKey = '001';

		UPDATE A
		SET A.ResidenceAddressId = B.AddressId
		FROM GlobalBO.setup.Tb_Account As A
		INNER JOIN #tmpAddress As B
		ON B.ExtRefKey = A.AcctNo;

		UPDATE A
		SET A.CompanyAddressId = B.ResidenceAddressId,A.ExtRefKey=C.ExtRefKey
		FROM GlobalBO.setup.Tb_CorporateClient As A
		INNER JOIN GlobalBO.setup.Tb_Account As B
		ON A.CorporateClientId = B.MainClientId AND B.AcctType = 'CI'
		INNER JOIN #tmpAddress As C
		ON C.ExtRefKey = B.AcctNo; -- 24219
		
		DROP TABLE #tmpAddress;
		
		INSERT INTO GlobalBO.[setup].[Tb_CounterPartyAccount]
           ([CompanyId]
           ,[CorporateClientId]
           ,[CPartyAcctNo]
           ,[DepositoryAcctNo]
           ,[TradingAcctNo]
           ,[CPartyAcctType]
           ,[RecordId]
           ,[ActionInd]
           ,[CurrentUser]
           ,[CreatedBy]
           ,[CreatedDate])
		SELECT 
			1 As CompanyId,
			A.MainClientId As CorporateClientId,--C.CorporateClientId, -- Id matching with personnel table not with corpclient table, need to check why
			A.AcctNo As CPartyAcctNo,
			'' As DepositoryAcctNo,
			A.AcctNo As TradingAcctNo, -- one to many mapping ie., one CpartyAcctNo to multiple CDSNo
			'' As CPartyAcctType, -- Not sure what is the value for this
			NewID(),'','','DataMigration',getdate()
		FROM GlobalBO.setup.Tb_Account As A --Where AccountNumber Like '0%'
		INNER JOIN GlobalBO.setup.Tb_CorporateClient As C
		ON A.MainClientId = C.CorporateClientId
		WHERE A.AcctNo = 'CPBURSA001';

		
		INSERT INTO GlobalBO.[setup].[Tb_CounterPartySetup]
           ([CPartyAcctId]
           ,[CompanyId]
           ,[ProdExchId]
           ,[AcctAttributeCd]
           ,[AcctAttributeValue]
           ,[TaxBracketCd]
           ,[IncorporationCountryCd]
           ,[WHTax]
           ,[RecordId]
           ,[ActionInd]
           ,[CurrentUser]
           ,[CreatedBy]
           ,[CreatedDate])

		SELECT 
			[CPartyAcctId]
			,1 As [CompanyId]
			,B.[ProdExchId]
			,'DEFAULT' As [AcctAttributeCd]
			,'' As [AcctAttributeValue]
			,'' As [TaxBracketCd]
			,'' As [IncorporationCountryCd]
			,0 As [WHTax]
			,NewID() As [RecordId]
			,'' As [ActionInd]
			,'' As [CurrentUser]
			,'DataMigration' As [CreatedBy]
			,getdate() As [CreatedDate]
		FROM GlobalBO.setup.Tb_CounterPartyAccount As A
		INNER JOIN GlobalBO.setup.Tb_ProductExchange As B
		ON B.ExchCd = 'XKLS';
     
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