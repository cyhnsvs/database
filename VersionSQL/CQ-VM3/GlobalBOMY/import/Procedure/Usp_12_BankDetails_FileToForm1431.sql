/****** Object:  Procedure [import].[Usp_12_BankDetails_FileToForm1431]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [import].[Usp_12_BankDetails_FileToForm1431] 
AS
/***********************************************************************             
            
Created By        : Fadlin
Created Date      : 05/10/2020
Last Updated Date :             
Description       : this sp is used to insert 
					Bank Detail List file data into CQForm
            
Table(s) Used     : 
            
Modification History :            
 ModifiedBy : 			ModifiedDate : 			Reason : 

PARAMETERS
EXEC  [import].[Usp_12_BankDetails_FileToForm1431] 
************************************************************************************/
BEGIN
  
	SET NOCOUNT ON;
	
	BEGIN TRY
	
        BEGIN TRANSACTION;
		
		Exec CQBTempDB.form.[Usp_CreateImportTable] 1431;

		TRUNCATE TABLE CQBTempDB.[import].Tb_FormData_1431;

		INSERT INTO CQBTempDB.[import].[Tb_FormData_1431]
        (
			[RecordID]
			,[Action]
			,[BankCode (textinput-1)]
			,[BankBranch (textinput-2)]
			,[BankName (textinput-4)]
			,[MainBranch (multipleradiosinline-1)]
			,[BaseLendingRate (textinput-18)]
			,[Suspend (multipleradiosinline-2)]
			,[DateSuspend (dateinput-1)]
			,[CommitmentFeeRate (textinput-19)]
			,[ContactPerson (grid-1)]
			,[Address1 (textinput-6)]
			,[Address2 (textinput-7)]
			,[Address3 (textinput-8)]
			,[Town (textinput-9)]
			,[State (selectsource-2)]
			,[State (textinput-20)]
			,[ZipPostalCode (textinput-11)]
			,[TelephoneNo (textinput-12)]
			,[FaxNo (textinput-13)]
			,[Country (selectsource-1)]
			,[DialUpNo (textinput-14)]
			,[SWIFTAccount (textinput-16)]
			,[CorrespondenceMethod (textinput-3)]
			,[GroupEmailID (textinput-21)]
		)   
		SELECT
			NULL as [RecordID],
			'I' as [Action],
			RTRIM(BANKCD),
			BANKBRANCH,
			BANKNAME,
			MAINBRANCH,
			CASE WHEN BASELENDRT = 0.000000000 THEN 0 ELSE BASELENDRT END,
			[SUSPEND],
			CASE WHEN DTSUSPND = '0001-01-01' THEN null ELSE DTSUSPND END,
			CASE WHEN COMMFEERT = 0.000000000 THEN 0 ELSE COMMFEERT END,
			--CORRNAME,
			'' AS [ContactPerson (grid-1)],
			CORRADDR1,
			CORRADDR2,
			CORRADDR3,
			CORRADDR4,
			'',
			'',
			CORRPOSTCD,
			PHONE,
			FAX,
			REPLACE(COUNTRYCD,' ',''),
			DIALUPNO,
			SWIFTADD,
			CORRMTHD,
			''
		FROM import.Tb_Bank;
		
		INSERT INTO CQBTempDB.import.Tb_FormData_1431_grid1 --FinancialDetails (grid-6)
			 ([RecordID],[Action],[RowIndex],[Name (TextBox)],[Email (TextBox)],[Phone Number (TextBox)])
		SELECT C.IDD, C.Action, 1, B.CORRNAME, '', ''
		FROM CQBTempDB.import.Tb_FormData_1410 AS C
		INNER JOIN import.Tb_Bank AS B
			ON C.[OldCustomerID (textinput-131)] = B.BANKCD
		WHERE CORRNAME <> '';

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