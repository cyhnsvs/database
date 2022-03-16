/****** Object:  Procedure [import].[Usp_10_ShareGrade_FileToForm2866]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [import].[Usp_10_ShareGrade_FileToForm2866] 
AS
/***********************************************************************             
            
Created By        : Nishanth
Created Date      : 05/10/2020
Last Updated Date :             
Description       : this sp is used to insert 
					Share Grade List file data into CQForm
            
Table(s) Used     : 
            
Modification History :            
 ModifiedBy : 			ModifiedDate : 			Reason : 

PARAMETERS
EXEC [import].[Usp_10_ShareGrade_FileToForm2866] 
************************************************************************************/
BEGIN
  
	SET NOCOUNT ON;
	
	BEGIN TRY
	
        BEGIN TRANSACTION;
		
		Exec CQBTempDB.form.[Usp_CreateImportTable] 2866;

		TRUNCATE TABLE CQBTempDB.[import].Tb_FormData_2866;

		INSERT INTO CQBTempDB.[import].Tb_FormData_2866
		(
			[RecordID]
           ,[Action]
           ,[ShareGradeCode (textinput-1)]
           ,[Description (textinput-2)]
           ,[Marginable (multipleradiosinline-1)]
		)    
		SELECT
			NULL as [RecordID],
			'I' as [Action],
			REPLACE(ShareGradeCode, ' ', ''),
			[Description],
			MarginableIndicator
		FROM import.Tb_ShareGrade;

		UPDATE S
		SET [NetLimit (textinput-3)] = ISNULL(CASE WHEN SL.NetLimit = '.00' THEN '0.00' ELSE SL.NetLimit END,'0.00')
		FROM CQBTempDB.[import].Tb_FormData_2866 S
		LEFT JOIN import.Tb_Limit_MarketBoard AS SL
		ON S.[ShareGradeCode (textinput-1)] = 
			CASE SL.Board WHEN 'Main' THEN 'M'
						WHEN 'Ace Market' THEN 'Q'
						WHEN 'LEAP Market' THEN 'A'
						WHEN 'ETF' THEN 'T'
						WHEN 'Warrant' THEN 'W'
						WHEN 'Loan' THEN 'L'
						WHEN 'Structuted Warrant' THEN 'C'
						WHEN 'PN17' THEN 'P'
						WHEN 'GN3' THEN 'G' END
		
		--select * FROM CQBTempDB.[import].Tb_FormData_2866 S
		--select * from import.Tb_Limit_MarketBoard

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