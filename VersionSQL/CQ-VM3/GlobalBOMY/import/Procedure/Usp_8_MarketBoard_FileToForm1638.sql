/****** Object:  Procedure [import].[Usp_8_MarketBoard_FileToForm1638]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [import].[Usp_8_MarketBoard_FileToForm1638] 
AS
/***********************************************************************             
            
Created By        : Fadlin
Created Date      : 15/09/2020
Last Updated Date :             
Description       : this sp is used to insert 
					Market Board List file data into CQForm
            
Table(s) Used     : 
            
Modification History :            
 ModifiedBy : 			ModifiedDate : 			Reason : 

PARAMETERS
EXEC [import].[Usp_8_MarketBoard_FileToForm1638] 
************************************************************************************/
BEGIN
  
	SET NOCOUNT ON;
	
	BEGIN TRY
	
        BEGIN TRANSACTION;
		
		EXEC CQBTempDB.form.[Usp_CreateImportTable] 1638;

		TRUNCATE TABLE CQBTempDB.[import].Tb_FormData_1638;

		INSERT INTO CQBTempDB.[import].Tb_FormData_1638
		(
			[RecordID]
           ,[Action]
           ,[MarketBoardCode (textinput-1)]
           ,[Description (textinput-3)]
           ,[MultiplierforSharePledged (textinput-4)]
           ,[DiscountFactor (textinput-5)]
           ,[MarketCode (selectsource-1)]
		)    
		SELECT
			null as [RecordID],
			'I' as [Action],
			MarketBoardCode,
			Description,
			MultiplierForSharePledged,
			DiscountFactor,
			CASE 
				WHEN MarketCode = 'AUSE' THEN 'XASX'
				WHEN MarketCode = 'BMSB' THEN 'XKLS'
				WHEN MarketCode = 'HKSE' THEN 'XHKG'
				WHEN MarketCode = 'IDX' THEN 'XIDX'
				WHEN MarketCode = 'LSE' THEN 'XLON'
				WHEN MarketCode = 'NASD' THEN 'XNAS'
				WHEN MarketCode = 'OTC' THEN 'UOTC'
				WHEN MarketCode = 'SGX' THEN 'XSES'
				WHEN MarketCode = 'SSE' THEN 'XSHG'
				WHEN MarketCode = 'TH' THEN 'XBKK'
				WHEN MarketCode = 'TKY' THEN 'XTKS'
				WHEN MarketCode = 'TO' THEN 'XTSE'
				WHEN MarketCode = 'US' THEN 'XNYS'
				ELSE MarketCode
			END AS MarketCode
		FROM import.Tb_MarketBoard;

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

        RAISERROR (
		        @ostrReturnMessage
		        ,@intErrorSeverity
		        ,@intErrorState
		        );

    END CATCH
    
    SET NOCOUNT OFF;
END