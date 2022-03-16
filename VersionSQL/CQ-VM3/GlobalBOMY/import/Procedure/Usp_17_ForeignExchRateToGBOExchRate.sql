/****** Object:  Procedure [import].[Usp_17_ForeignExchRateToGBOExchRate]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [import].[Usp_17_ForeignExchRateToGBOExchRate]
AS
/***********************************************************************             
            
Created By        : Jansi
Created Date      : 14/04/2020
Last Updated Date :             
Description       : this sp is used to insert foreign exchange rate into GBO exchange rate table
            
Table(s) Used     : 
            
Modification History :            
 ModifiedBy : 			ModifiedDate : 			Reason : 

PARAMETERS
EXEC [import].[Usp_17_ForeignExchRateToGBOExchRate];
************************************************************************************/
BEGIN
  
	SET NOCOUNT ON;
	
	BEGIN TRY
	
        BEGIN TRANSACTION;
		
		--DECLARE @dteBusinessDate DATE = GlobalBO.setup.Udf_FetchSetupDate(1, 'BusDate');
		TRUNCATE TABLE GlobalBO.[setup].[Tb_ExchangeRateHistory];
		TRUNCATE TABLE GlobalBO.[setup].[Tb_ExchangeRate];

		INSERT INTO GlobalBO.[setup].[Tb_ExchangeRateHistory]
           ([BusinessDate]
           ,[BaseCurrCd]
           ,[OtherCurrCd]
           ,[TimeSlotId]
           ,[CompanyId]
           ,[BuyExchRate]
           ,[SellExchRate]
           ,[AvgExchRate]
           ,[CreatedBy]
           ,[CreatedDate])
		SELECT 
			ForexAsAt,
			BaseCurrency,
			CurrencyCode As OtherCurrCd,
			'ExchRate_0000_0000' As TimeSlotId,
			1 As CompanyId,
			BuyRate,
			SellRate,
			BuyRate As AvgExchRate,
			'DataMigration',
			GETDATE() 
		FROM [import].[Tb_ForeignExchangeRate] ;

		INSERT INTO GlobalBO.[setup].[Tb_ExchangeRate]
           ([BaseCurrCd]
           ,[OtherCurrCd]
           ,[TimeSlotId]
           ,[CompanyId]
           ,[BuyExchRate]
           ,[SellExchRate]
           ,[AvgExchRate]
           ,[CreatedBy]
           ,[CreatedDate]
		   ,[CurrentUser]
		   ,[RecordId]
		   ,[ActionInd])
		SELECT 
			A.BaseCurrency,
			A.CurrencyCode As OtherCurrCd,
			'ExchRate_0000_0000' As TimeSlotId,
			1 As CompanyId,
			A.BuyRate,
			A.SellRate,
			A.BuyRate As AvgExchRate,
			'DataMigration',
			GETDATE() ,
			'',
			newid(),
			''
		FROM [import].[Tb_ForeignExchangeRate] A 
		LEFT OUTER JOIN [import].[Tb_ForeignExchangeRate] B
			ON A.BaseCurrency = B.BaseCurrency  AND A.CurrencyCode = B.CurrencyCode
		AND A.ForexAsAt < B.ForexAsAt
		WHERE B.BaseCurrency IS NULL AND B.CurrencyCode IS NULL 
		ORDER BY A.ForexAsAt desc;
		
		UPDATE GlobalBO.[setup].[Tb_ExchangeRate]
		SET BuyExchRate = 1, SellExchRate = 1, AvgExchRate = 1
		WHERE BaseCurrCd = OtherCurrCd;

        COMMIT TRANSACTION;
        
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

   --     EXEC GlobalBO.[utilities].[usp_ErrorLog] @intErrorNumber
	  --      --,@ostrReturnMessage
			--,''
	  --      ,@intErrorLine
	  --      ,@strObjectName
	  --      ,NULL /*Code Section not available*/
	  --      ,'Process fail.';

        RAISERROR 
		(
			@ostrReturnMessage
			,@intErrorSeverity
			,@intErrorState
		);

    END CATCH
    
    SET NOCOUNT OFF;
END