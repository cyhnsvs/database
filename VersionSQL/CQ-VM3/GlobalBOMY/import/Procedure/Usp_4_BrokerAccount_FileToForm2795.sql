/****** Object:  Procedure [import].[Usp_4_BrokerAccount_FileToForm2795]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [import].[Usp_4_BrokerAccount_FileToForm2795]
AS
/***********************************************************************             
            
Created By        : Nishanth
Created Date      : 14/09/2020
Last Updated Date :             
Description       : this sp is used to insert Broker Account file data into CQForm Broker Account
            i
Table(s) Used     : 
            
Modification History :            
 ModifiedBy : 			ModifiedDate : 			Reason : 

PARAMETERS
EXEC [import].[Usp_4_BrokerAccount_FileToForm2795]
************************************************************************************/
BEGIN
  
	SET NOCOUNT ON;
	
	BEGIN TRY
	
        BEGIN TRANSACTION;
		
		Exec CQBTempDB.form.[Usp_CreateImportTable] 2795;
		
		TRUNCATE TABLE CQBTempDB.[import].[Tb_FormData_2795];
		
		INSERT INTO CQBTempDB.[import].Tb_FormData_2795
			([RecordID], 
			 [Action],     
			 [BrokerCode (textinput-1)],    
			 [BrokerName (textinput-2)],    
			 [Address1 (textinput-7)],    
			 [Address2 (textinput-8)],    
			 [Address3 (textinput-9)],    
			 [Town (textinput-10)],
			 [State (textinput-12)],
			 [State (selectsource-4)],
			 [Country (selectsource-5)],
			 [PostCode (textinput-11)],
			 [DefaultEmail (textinput-4)],    
			 [DefaultPhoneNumber (textinput-5)],    
			 [StockExchange (selectsource-2)],    
			 [AccountStatus (selectsource-1)],
			 [ContactPerson (grid-1)])
		SELECT null as [RecordID], 
			   'I' as [Action],
			   A.AccountNumber as  [BrokerCode (textinput-1)],
			   A.AccountName as  [BrokerName (textinput-2)],         
			   A.CorrAdd1 as  [Address1 (textinput-7)],    
			   A.CorrAdd2 as  [Address2 (textinput-8)],    
			   A.CorrAdd3 as  [Address3 (textinput-9)],    
			   A.CorrAdd4 as  [Town (textinput-10)],
			   '' as [State (textinput-12)],
			   '' as [State (selectsource-4)],
			   'MY' as [Country (selectsource-5)],
			   A.CorrPostCode as  [PostCode (textinput-11)],
			   '' as  [DefaultEmail (textinput-4)],     
			   ISNULL(NULLIF(A.PhoneHouse,''),A.PhoneOffice) as  [DefaultPhoneNumber (textinput-5)],     
			   'XKLS' as  [StockExchange (textinput-6)],     
				AccountStatus as  [AccountStatus (selectsource-9)],
				'' as  [ContactPerson (grid-1)]
		FROM import.TB_Account As A
		INNER JOIN import.Tb_Customer AS C
		ON A.CustomerKey = C.CustomerID
		WHERE A.AccountStatus<>'C' AND A.AccountGroup IN ('B');

		--ContactPerson (grid-1)

		--Select * from CQBTempDB.[import].[Tb_FormData_2795]
		--select * from CQBuilder.form.Tb_FormData_2795;
		--Select * from CQBTempDB.[export].[Tb_FormData_2795]
		
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