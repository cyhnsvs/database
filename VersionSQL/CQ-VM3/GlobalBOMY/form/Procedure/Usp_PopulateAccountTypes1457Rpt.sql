/****** Object:  Procedure [form].[Usp_PopulateAccountTypes1457Rpt]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [form].[Usp_PopulateAccountTypes1457Rpt]        
 @iintCompanyId BIGINT,        
 @ostrReturnMessage VARCHAR(400) OUTPUT        
AS        
/***********************************************************************************         
        
Name              : [form].[Usp_PopulateAccountTypes1457Rpt]      
Created By        : Fadlin        
Created Date      : 09/12/2020
Last Updated Date :         
Description       : this sp transfers the account from main CQB database to the reporting database        
					uses a same server/different server switch to determine which source database to use        
Table(s) Used     :         
        
Modification History :        
 ModifiedBy :   Project UIN:		ModifiedDate :  Reason :        
 
 
													
PARAMETERS         
 @iintCompanyId - the company id        
 @ostrReturnMessage - output any info/error message generated        
        
Used By :        
        EXEC [form].[Usp_PopulateAccountTypes1457Rpt]  1,''
************************************************************************************/        
BEGIN        
        
 SET NOCOUNT ON;        
        
 BEGIN TRY        
     BEGIN TRANSACTION        
                
		DECLARE @dteBusinessDate DATE;       
		    
		SELECT @dteBusinessDate = DateValue        
		FROM GlobalBORpt.setup.Tb_Date        
		WHERE CompanyId = @iintCompanyId AND  DateCd = 'BusDate' ;              
		
		--SET @dteBusinessDate = '2020-12-08';

		DELETE FROM GlobalBORpt.form.Tb_FormData_1457
		WHERE ReportDate = @dteBusinessDate;   

		INSERT INTO GlobalBORpt.[form].[Tb_FormData_1457]
		(
			[ReportDate]
           ,[RecordID]
           ,[CreatedBy]
           ,[CreatedTime]
           ,[UpdatedBy]
           ,[UpdatedTime]
           ,[2DigitCode (textinput-1)]
           ,[Description (textinput-2)]
           ,[CharCode (textinput-3)]
           ,[AlgoSystem (selectsource-1)]
           ,[ExternalMarginFinancier (selectsource-2)]
           ,[NomineesInd (selectbasic-2)]
        )
		SELECT
			@dteBusinessDate
			[ReportDate]
           ,[RecordID]
           ,[CreatedBy]
           ,[CreatedTime]
           ,[UpdatedBy]
           ,[UpdatedTime]
           ,[2DigitCode (textinput-1)]
           ,[Description (textinput-2)]
           ,[CharCode (textinput-3)]
           ,[AlgoSystem (selectsource-1)]
           ,[ExternalMarginFinancier (selectsource-2)]
           ,[NomineesInd (selectbasic-2)]
		FROM CQBTempDB.export.Tb_FormData_1457;

		--DELETE FROM form.Tb_FormData_1409 WHERE ReportDate <= DATEADD(day, -7, GETDATE());
    COMMIT TRANSACTION        
    END TRY        
    BEGIN CATCH     
    
		ROLLBACK TRANSACTION;     
		
		SELECT @ostrReturnMessage = ERROR_MESSAGE();        
        EXECUTE GlobalBORpt.utilities.usp_RethrowError ',[form].[Usp_PopulateAccountTypes1457Rpt] '; 
   
    END CATCH        
            
    SET NOCOUNT OFF;         
        
END 