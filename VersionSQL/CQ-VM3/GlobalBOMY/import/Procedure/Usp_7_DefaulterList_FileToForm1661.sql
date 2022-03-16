/****** Object:  Procedure [import].[Usp_7_DefaulterList_FileToForm1661]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [import].[Usp_7_DefaulterList_FileToForm1661] 
AS
/***********************************************************************             
            
Created By        : Fadlin
Created Date      : 01/09/2020
Last Updated Date :             
Description       : this sp is used to insert 
					Defaulter List file data into CQForm Dealer
            
Table(s) Used     : 
            
Modification History :            
 ModifiedBy : 			ModifiedDate : 			Reason : 
 Kristine				2021-09-28				Added new fields (DefaultedDate, DefaultedAmount)
PARAMETERS
EXEC [import].[Usp_7_DefaulterList_FileToForm1661] 
************************************************************************************/
BEGIN
  
	SET NOCOUNT ON;
	
	BEGIN TRY
	
        BEGIN TRANSACTION;
		
		EXEC CQBTempDB.form.Usp_CreateImportTable 1661;

		TRUNCATE TABLE CQBTempDB.[import].Tb_FormData_1661;

		INSERT INTO CQBTempDB.[import].Tb_FormData_1661
		(
			[RecordID],
			[Action],
			[Type (selectsource-1)],
			[Name (textinput-1)],
			[IDType (selectsource-2)],
			[IDNumber (textinput-2)],
			[AlternateIDType (selectsource-3)],
			[AlternateIDNumber (textinput-3)],
			[Uplifted (multipleradiosinline-1)],
			[UpliftedDate (dateinput-1)],
			[Details (textarea-1)],
			[DefaultedDate (dateinput-2)],
			[DefaultedAmount (textinput-4)]
		)    
		SELECT
			null as [RecordID],
			'I' as [Action],
			CASE 
				WHEN EXCHDOCREF NOT IN ('UNSCR','PEP') THEN 'BD'
				ELSE EXCHDOCREF
			END as [Type],
			DFTNAME,
			IDTYPECD,
			IDNUMBER,
			IDTYPECD1,
			IDNUMBER1,
			'',
			'',
			REMARK1,
			DEFAULTDT as  [DefaultedDate (dateinput-2)], 
			TRXAMT as  [DefaultedAmount (textinput-4)]
		FROM import.Tb_DefaulterSanctionList;

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