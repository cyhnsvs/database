/****** Object:  Procedure [import].[Usp_2_Financier_FileToForm1479_3040]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [import].[Usp_2_Financier_FileToForm1479_3040]
AS
/***********************************************************************             
            
Created By        : Nishanth
Created Date      : 07/12/2020
Last Updated Date :             
Description       : this sp is used to insert 
					Financier file data into CQForm Dealer
					Financier Market file data into CQForm Dealer 
            
Table(s) Used     : 
            
Modification History :            
 ModifiedBy : 			ModifiedDate : 			Reason : 

PARAMETERS
EXEC [import].[Usp_2_Financier_FileToForm1479_3040]
************************************************************************************/
BEGIN
  
	SET NOCOUNT ON;
	
	BEGIN TRY
	
        BEGIN TRANSACTION;
		
		Exec CQBTempDB.form.[Usp_CreateImportTable] 1479;
		Exec CQBTempDB.form.[Usp_CreateImportTable] 3040;

		TRUNCATE TABLE CQBTempDB.[import].Tb_FormData_1479;

		INSERT INTO CQBTempDB.[import].Tb_FormData_1479
			([RecordID], [Action],     [FinancierCode (textinput-1)],    [FinancierName (textinput-2)],    [ContactPerson (grid-1)],    [GroupEmailID (textinput-16)],    
			[Address1 (textinput-4)],    [Address2 (textinput-5)],    [Address3 (textinput-6)],    [Town (textinput-7)],    [State (textinput-15)],    
			[PostalCode (textinput-8)],    [State (selectsource-2)],    [Country (selectsource-1)],    [TelephoneNo (textinput-9)],    [FaxNo (textinput-10)],    
			[EmailAddress (textinput-11)],    [DialUpNo (textinput-12)],    [SWIFTAccount (textinput-13)],    [HandlingFeePercentage (textinput-17)],    
			[HandlingFeeAmount (textinput-18)],    [RestrictedStocklist (selectsourcemultiple-1)])    
		SELECT null as [RecordID],
				'I' as [Action],    
				FinancierCode as  [FinancierCode (textinput-1)],     
				FinancierName as  [FinancierName (textinput-2)],     
				'' as  [ContactPerson (grid-1)],     
				'' as  [GroupEmailID (textinput-16)],     
				Address1 as  [Address1 (textinput-4)],     
				Address2 as  [Address2 (textinput-5)],     
				Address3 as  [Address3 (textinput-6)],     
				Address4 as  [Town (textinput-7)],     
				'' as  [State (textinput-15)],     
				ZipOrPostalCode as  [PostalCode (textinput-8)],     
				'' as  [State (selectsource-2)],     
				Country as  [Country (selectsource-1)],     
				TelephoneNo as  [TelephoneNo (textinput-9)],     
				FaxNo as  [FaxNo (textinput-10)],     
				'' as  [EmailAddress (textinput-11)],     
				DialupNo as  [DialUpNo (textinput-12)],     
				SWIFTAccount as  [SWIFTAccount (textinput-13)],     
				'' as  [HandlingFeePercentage (textinput-17)],     
				'' as  [HandlingFeeAmount (textinput-18)],     
				'' as  [RestrictedStocklist (selectsourcemultiple-1)]
		FROM import.Tb_Financier;

		--INSERT INTO [import].[Tb_FormData_1479_grid1] --[ContactPerson (grid-1)]
  --         ([RecordID],[Action],[RowIndex],[Name (TextBox)],[Email (TextBox)],[Phone Number (TextBox)])

		TRUNCATE TABLE CQBTempDB.[import].Tb_FormData_3040;

		INSERT INTO CQBTempDB.[import].Tb_FormData_3040
			([RecordID], [Action],     [FinancierCode (selectsource-1)],    [MarketCode (selectsource-2)],    [ContraInd (selectbasic-1)],    [ContraforShortSelling (selectbasic-2)],    
			[ContraForOddLots (selectbasic-3)],    [ContraForIntraday (selectbasic-4)],    [ContraOnTDaysDays (textinput-1)],    [ContraOnTDaysWorkingCalendar (selectsource-3)],    
			[ComputeServiceCharges (selectsource-4)],    [ContraServiceChargesDayDifferenceBasedOn (selectsource-5)],    [PurchaseDaysDays (textinput-2)],    [SalesDaysDays (textinput-3)],    
			[PurchaseDaysWorkingCalendar (selectsource-6)],    [SalesDaysWorkingCalendar (selectsource-7)])    
		SELECT null as [RecordID],
				'I' as [Action],    
				FINANCECD as  [FinancierCode (selectsource-1)],     
				'XKLS' as  [MarketCode (selectsource-2)],     
				CONTRAIND as  [ContraInd (selectbasic-1)],     
				'' as  [ContraforShortSelling (selectbasic-2)],     
				'' as  [ContraForOddLots (selectbasic-3)],     
				'' as  [ContraForIntraday (selectbasic-4)],     
				'' as  [ContraOnTDaysDays (textinput-1)],     
				'' as  [ContraOnTDaysWorkingCalendar (selectsource-3)],     
				'' as  [ComputeServiceCharges (selectsource-4)],     
				'' as  [ContraServiceChargesDayDifferenceBasedOn (selectsource-5)],     
				'' as  [PurchaseDaysDays (textinput-2)],     
				'' as  [SalesDaysDays (textinput-3)],     
				'' as  [PurchaseDaysWorkingCalendar (selectsource-6)],     
				'' as  [SalesDaysWorkingCalendar (selectsource-7)]
		FROM import.Tb_FinancierMarket;

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