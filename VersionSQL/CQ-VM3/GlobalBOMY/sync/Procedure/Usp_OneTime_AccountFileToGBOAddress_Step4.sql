/****** Object:  Procedure [sync].[Usp_OneTime_AccountFileToGBOAddress_Step4]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [import].[Usp_ProcessAddressDetails]
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
    	BEGIN TRANSACTION
        
		;WITH cte_Addresses AS (
            SELECT
				3 AS [AddressCategory], --1 = Company, 2 = Corporate Client, 3 = Personnel 
				--,3 [CategoryId]
				1 AS [CompanyId],
				AccountNumber AS ExtRefKey,
				'H' As [AddressType],
				CorrAdd1 As [Address1],
				CorrAdd2 As [Address2],
				CorrAdd3 + IIF(ISNULL(CorrAdd4,'') = '', '', ', ' + CorrAdd4) AS [Address3],
				'' AS [City],
				'' As [State],
				'MY' AS [CountryCd],
				CorrPostCode As PostCode,
				'A' AS [AddressStatus],
				'Y' AS [DefaultInd] --default indicator; values Y or N 
			FROM import.Tb_Account
			WHERE CustomerType = '1'
			UNION
			SELECT
				2 AS [AddressCategory], --1 = Company, 2 = Corporate Client, 3 = Personnel 
				--,3 [CategoryId]
				1 AS [CompanyId],
				AccountNumber AS ExtRefKey,
				'O' As [AddressType],
				OffAdd1 As [Address1],
				OffAdd2 As [Address2],
				'' AS [Address3],
				'' AS [City],
				'' As [State],
				OffCountry AS [CountryCd],
				OffPostCode As PostCode,
				'A' AS [AddressStatus],
				'Y' AS [DefaultInd] --default indicator; values Y or N 
			FROM import.Tb_Account
			WHERE CustomerType IN ('2','3','5','6','9','A','B','C','D')
        )       
        MERGE INTO GlobalBO.setup.Tb_AddressMaster AS TRGT
        USING cte_Addresses AS SRC ON
        	--SRC.CategoryId = TRGT.CategoryId AND
            SRC.CompanyId = TRGT.CompanyId AND
            SRC.AddressCategory = TRGT.AddressCategory AND
            SRC.ExtRefKey collate Latin1_General_CI_AS = TRGT.ExtRefKey
        WHEN MATCHED THEN UPDATE SET
        	TRGT.AddressType = SRC.AddressType,
            TRGT.Address1 = SRC.Address1,
            TRGT.Address2 = SRC.Address2,
            TRGT.Address3 = SRC.Address3,
            TRGT.City = SRC.City,
			TRGT.[State] = SRC.[State],
            TRGT.CountryCd = SRC.CountryCd,
            TRGT.PostalCd = SRC.Postcode,
            TRGT.ModifiedBy = 'SYSBATCH',
            TRGT.ModifiedDate = GETDATE()
         WHEN NOT MATCHED BY TARGET THEN
         	INSERT (
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
            ) VALUES(
            	SRC.AddressCategory,
                1,
                SRC.ExtRefKey,
                SRC.CompanyId,
                SRC.AddressType,
                SRC.Address1,
                SRC.Address2,
                SRC.Address3,
                SRC.City,
				SRC.[State],
                SRC.CountryCd,
                SRC.Postcode,
                AddressStatus,
                DefaultInd,
                NEWID(), --RecordId
                'SYSBATCH', --CreatedBy
                GETDATE() --CreatedDate            
            );
		
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
			DefaultInd = 'Y';

		UPDATE A
		SET A.ResidenceAddressId = B.AddressId
		FROM GlobalBO.setup.Tb_Account As A
		INNER JOIN #tmpAddress As B
		ON B.ExtRefKey = A.AcctNo -- 140979

		UPDATE A
		SET A.DefaultAddressId = B.ResidenceAddressId,A.ExtRefKey=C.ExtRefKey
		FROM GlobalBO.setup.Tb_Personnel As A
		INNER JOIN GlobalBO.setup.Tb_Account As B
		ON A.ClientId = B.MainClientId AND B.AcctType = 'I'
		INNER JOIN #tmpAddress As C
		ON C.ExtRefKey = B.AcctNo; -- 92472

		UPDATE A
		SET A.CompanyAddressId = B.ResidenceAddressId,A.ExtRefKey=C.ExtRefKey
		FROM GlobalBO.setup.Tb_CorporateClient As A
		INNER JOIN GlobalBO.setup.Tb_Account As B
		ON A.CorporateClientId = B.MainClientId AND B.AcctType = 'CI'
		INNER JOIN #tmpAddress As C
		ON C.ExtRefKey = B.AcctNo; -- 24219
		
		DROP TABLE #tmpAddress;
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