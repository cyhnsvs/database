/****** Object:  Procedure [form].[Usp_PopulateDealer1377Rpt]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [form].[Usp_PopulateDealer1377Rpt]        
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
        EXEC [form].[Usp_PopulateDealer1377Rpt] 1,''
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

		DELETE FROM GlobalBORpt.form.Tb_FormData_1377
		WHERE ReportDate = @dteBusinessDate;   

		INSERT INTO GlobalBORpt.[form].[Tb_FormData_1377]
		(
			[ReportDate]
			,RecordID
			,CreatedBy
			,CreatedTime
			,UpdatedBy
			,UpdatedTime
			,[DealerAccountNo (textinput-37)]
			,[DealerCode (textinput-35)]
			,[BranchID (selectsource-1)]
			,[Name (textinput-3)]
			,[DealerType (selectsource-3)]
			,[DealerGradeCode (selectsource-13)]
			,[LicenseNumber (textinput-6)]
			,[LicenseSince (dateinput-1)]
			,[LicenseAnniversaryDate (dateinput-2)]
			,[CPEPointsAccumulation (grid-5)]
			,[CollateralAccountNo (textinput-7)]
			,[CommissionAccountNo (textinput-8)]
			,[IDNumberType (selectsource-2)]
			,[IDNumber (textinput-9)]
			,[AlternateIDnoType (selectsource-4)]
			,[AlternateIDno (textinput-10)]
			,[Race (selectsource-5)]
			,[BumiputraStatus (multipleradiosinline-1)]
			,[Sex (multipleradiosinline-2)]
			,[Address1 (textinput-11)]
			,[Address2 (textinput-14)]
			,[Address3 (textinput-13)]
			,[Town (textinput-12)]
			,[State (textinput-36)]
			,[State (selectsource-14)]
			,[Country (selectsource-15)]
			,[PostCode (textinput-15)]
			,[Phone (textinput-16)]
			,[MobilePhone (textinput-17)]
			,[TelephoneExtension (textinput-18)]
			,[Fax (textinput-19)]
			,[WorkEmail (textinput-20)]
			,[InitialDeposit (textinput-21)]
			,[MultiplierMethod (selectsource-6)]
			,[MultiplierMethodValue (textinput-23)]
			,[DealerCommissionRate (textinput-24)]
			,[DealerRolloverRate (textinput-25)]
			,[AssociateDealerCode (textinput-30)]
			,[BFEDealerCode (textinput-26)]
			,[BFEUserType (selectsource-16)]
			,[ShortSellInd (selectsource-17)]
			,[TeamID (textinput-29)]
			,[MainDealerCodeIndicator (multipleradiosinline-3)]
			,[PersonalEmail (textinput-27)]
			,[IncomeTaxNo (textinput-28)]
			--,[SCLevy (textinput-38)]
			,[Status (selectsource-12)]
			,[multipleradiosinline4 (multipleradiosinline-4)]
			,[Directorship (grid-3)]
			,[multipleradiosinline5 (multipleradiosinline-5)]
			,[Ownership (grid-4)]
        )
		SELECT
			@dteBusinessDate
			,RecordID
			,CreatedBy
			,CreatedTime
			,UpdatedBy
			,UpdatedTime
			,[DealerAccountNo (textinput-37)]
			,[DealerCode (textinput-35)]
			,[BranchID (selectsource-1)]
			,[Name (textinput-3)]
			,[DealerType (selectsource-3)]
			,[DealerGradeCode (selectsource-13)]
			,[LicenseNumber (textinput-6)]
			,[LicenseSince (dateinput-1)]
			,[LicenseAnniversaryDate (dateinput-2)]
			,[CPEPointsAccumulation (grid-5)]
			,[CollateralAccountNo (textinput-7)]
			,[CommissionAccountNo (textinput-8)]
			,[IDNumberType (selectsource-2)]
			,[IDNumber (textinput-9)]
			,[AlternateIDnoType (selectsource-4)]
			,[AlternateIDno (textinput-10)]
			,[Race (selectsource-5)]
			,[BumiputraStatus (multipleradiosinline-1)]
			,[Sex (multipleradiosinline-2)]
			,[Address1 (textinput-11)]
			,[Address2 (textinput-14)]
			,[Address3 (textinput-13)]
			,[Town (textinput-12)]
			,[State (textinput-36)]
			,[State (selectsource-14)]
			,[Country (selectsource-15)]
			,[PostCode (textinput-15)]
			,[Phone (textinput-16)]
			,[MobilePhone (textinput-17)]
			,[TelephoneExtension (textinput-18)]
			,[Fax (textinput-19)]
			,[WorkEmail (textinput-20)]
			,[InitialDeposit (textinput-21)]
			,[MultiplierMethod (selectsource-6)]
			,[MultiplierMethodValue (textinput-23)]
			,[DealerCommissionRate (textinput-24)]
			,[DealerRolloverRate (textinput-25)]
			,[AssociateDealerCode (textinput-30)]
			,[BFEDealerCode (textinput-26)]
			,[BFEUserType (selectsource-16)]
			,[ShortSellInd (selectsource-17)]
			,[TeamID (textinput-29)]
			,[MainDealerCodeIndicator (multipleradiosinline-3)]
			,[PersonalEmail (textinput-27)]
			,[IncomeTaxNo (textinput-28)]
			--,[SCLevy (textinput-38)]
			,[Status (selectsource-12)]
			,[multipleradiosinline4 (multipleradiosinline-4)]
			,[Directorship (grid-3)]
			,[multipleradiosinline5 (multipleradiosinline-5)]
			,[Ownership (grid-4)]
		FROM CQBTempDB.export.Tb_FormData_1377;

		--DELETE FROM form.Tb_FormData_1409 WHERE ReportDate <= DATEADD(day, -7, GETDATE());
    COMMIT TRANSACTION        
    END TRY        
    BEGIN CATCH     
    
		ROLLBACK TRANSACTION;     
		
		SELECT @ostrReturnMessage = ERROR_MESSAGE();        
        EXECUTE GlobalBORpt.utilities.usp_RethrowError ',[form].[Usp_PopulateDealer1377Rpt] '; 
   
    END CATCH        
            
    SET NOCOUNT OFF;         
        
END 