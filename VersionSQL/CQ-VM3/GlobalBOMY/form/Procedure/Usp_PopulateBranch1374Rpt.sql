/****** Object:  Procedure [form].[Usp_PopulateBranch1374Rpt]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [form].[Usp_PopulateBranch1374Rpt]        
 @iintCompanyId BIGINT,        
 @ostrReturnMessage VARCHAR(400) OUTPUT        
AS        
/***********************************************************************************         
        
Name              : [form].[Usp_PopulateBranch1374Rpt]      
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
        EXEC [form].[Usp_PopulateBranch1374Rpt]  1,''
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

		DELETE FROM GlobalBORpt.form.Tb_FormData_1374
		WHERE ReportDate = @dteBusinessDate;   

		INSERT INTO GlobalBORpt.[form].[Tb_FormData_1374]
		(
			[ReportDate]
			,RecordID
			,CreatedBy
			,CreatedTime
			,UpdatedBy
			,UpdatedTime
			,[BranchID (textinput-1)]
			,[BranchCode (textinput-42)]
			,[BranchLocation (textinput-2)]
			,[Address1 (textinput-7)]
			,[Address2 (textinput-8)]
			,[Address3 (textinput-9)]
			,[Town (textinput-10)]
			,[State (textinput-36)]
			,[State (selectsource-11)]
			,[Country (selectsource-12)]
			,[PostalCode (textinput-11)]
			,[Region (selectsource-10)]
			,[PICName (textinput-38)]
			,[OfficeNumber (textinput-13)]
			,[PICMobileNumber (textinput-14)]
			,[PICEmail (textinput-15)]
			,[MaxBuyLimit (textinput-39)]
			,[MaxSellLimit (textinput-40)]
			,[MaxNetLimit (textinput-41)]
        )
		SELECT
			@dteBusinessDate
			,RecordID
			,CreatedBy
			,CreatedTime
			,UpdatedBy
			,UpdatedTime
			,[BranchID (textinput-1)]
			,[BranchCode (textinput-42)]
			,[BranchLocation (textinput-2)]
			,[Address1 (textinput-7)]
			,[Address2 (textinput-8)]
			,[Address3 (textinput-9)]
			,[Town (textinput-10)]
			,[State (textinput-36)]
			,[State (selectsource-11)]
			,[Country (selectsource-12)]
			,[PostalCode (textinput-11)]
			,[Region (selectsource-10)]
			,[PICName (textinput-38)]
			,[OfficeNumber (textinput-13)]
			,[PICMobileNumber (textinput-14)]
			,[PICEmail (textinput-15)]
			,[MaxBuyLimit (textinput-39)]
			,[MaxSellLimit (textinput-40)]
			,[MaxNetLimit (textinput-41)]
		FROM CQBTempDB.export.Tb_FormData_1374;

		--DELETE FROM form.Tb_FormData_1409 WHERE ReportDate <= DATEADD(day, -7, GETDATE());
    COMMIT TRANSACTION        
    END TRY        
    BEGIN CATCH     
    
		ROLLBACK TRANSACTION;     
		
		SELECT @ostrReturnMessage = ERROR_MESSAGE();        
        EXECUTE GlobalBORpt.utilities.usp_RethrowError ',[form].[Usp_PopulateBranch1374Rpt] '; 
   
    END CATCH        
            
    SET NOCOUNT OFF;         
        
END 