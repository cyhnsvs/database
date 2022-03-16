/****** Object:  Procedure [import].[Usp_18_SettlementDayNonTrade_FileToForm3380]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [import].[Usp_18_SettlementDayNonTrade_FileToForm3380]
AS
/***********************************************************************             
            
Created By        : Nishanth
Created Date      : 07/06/2021
Last Updated Date :             
Description       : this sp is used to insert 
            
Table(s) Used     : 
            
Modification History :            
 ModifiedBy : 			ModifiedDate : 			Reason : 

PARAMETERS
EXEC [import].[Usp_18_SettlementDayNonTrade_FileToForm3380]
************************************************************************************/
BEGIN
  
	SET NOCOUNT ON;
	
	BEGIN TRY
	
        BEGIN TRANSACTION;
		
		--Use CQBTempDB
		Exec CQBTempDB.form.[Usp_CreateImportTable] 3380;
		
		TRUNCATE TABLE CQBTempDB.[import].Tb_FormData_3380;

		INSERT INTO CQBTempDB.[import].Tb_FormData_3380
		([RecordID], [Action],
		 [ExchangeCode (selectsource-2)],
		 [AccountGroupCode (selectsource-1)],
		 [TransactionType (selectsourcemultiple-1)],
		 [DayTypeIndicator (selectbasic-1)],
		 [DefaultSettlementDays (textinput-1)]) 
		SELECT null as [RecordID],'I' as [Action],
			CASE 
				WHEN A.MRKTCD = 'AUSE' THEN 'XASX'
				WHEN A.MRKTCD = 'BMSB' THEN 'XKLS'
				WHEN A.MRKTCD = 'HKSE' THEN 'XHKG'
				WHEN A.MRKTCD = 'IDX' THEN 'XIDX'
				WHEN A.MRKTCD = 'LSE' THEN 'XLON'
				WHEN A.MRKTCD = 'NASD' THEN 'XNAS'
				WHEN A.MRKTCD = 'OTC' THEN 'UOTC'
				WHEN A.MRKTCD = 'SGX' THEN 'XSES'
				WHEN A.MRKTCD = 'SSE' THEN 'XSHG'
				WHEN A.MRKTCD = 'TH' THEN 'XBKK'
				WHEN A.MRKTCD = 'TKY' THEN 'XTKS'
				WHEN A.MRKTCD = 'TO' THEN 'XTSE'
				WHEN A.MRKTCD = 'US' THEN 'XNYS'
				ELSE A.MRKTCD
			END AS [MarketCode (selectsource-6)],
			A.ACCTGRPCD as  [AccountGroupCode (selectsource-1)], 
			CAST((SELECT ',' + AD.TRXCD
			FROM (SELECT TOP 500 * FROM import.Tb_AccountGroup_SettlementDay ORDER BY MRKTCD, ACCTGRPCD, DAYSSETTAM, DAYTYPIND, TRXCD) AD
			WHERE AD.MRKTCD = A.MRKTCD AND AD.ACCTGRPCD = A.ACCTGRPCD AND AD.DAYSSETTAM = A.DAYSSETTAM AND AD.DAYTYPIND = A.DAYTYPIND AND TRXCD <> 'JN'
			FOR XML PATH('')) as varchar(100)) AS [TransactionType (selectsource-3)],
			DAYTYPIND as  [DayTypeIndicator (selectbasic-1)], 
			DAYSSETTAM as  [DefaultSettlementDays (textinput-1)]
		 FROM import.Tb_AccountGroup_SettlementDay AS A
		 WHERE DAYSSETTAM<>0
		 GROUP BY MRKTCD, ACCTGRPCD, DAYSSETTAM, DAYTYPIND
		 ORDER BY MRKTCD, ACCTGRPCD, DAYSSETTAM, DAYTYPIND;

		 UPDATE CQBTempDB.[import].Tb_FormData_3380
		 SET [TransactionType (selectsourcemultiple-1)]=REPLACE([TransactionType (selectsourcemultiple-1)], ',CT', ',CHGN,CHLS');
		 
		 UPDATE CQBTempDB.[import].Tb_FormData_3380
		 SET [TransactionType (selectsourcemultiple-1)]=REPLACE([TransactionType (selectsourcemultiple-1)], ',CR', ',CHCN');
		 
		 UPDATE CQBTempDB.[import].Tb_FormData_3380
		 SET [TransactionType (selectsourcemultiple-1)]=REPLACE([TransactionType (selectsourcemultiple-1)], ',DR', ',CHDN');

		 UPDATE CQBTempDB.[import].Tb_FormData_3380
		 SET [TransactionType (selectsourcemultiple-1)]=REPLACE([TransactionType (selectsourcemultiple-1)], ',CS', ',SCHGN,SCHLS');

		 UPDATE CQBTempDB.[import].Tb_FormData_3380
		 SET [TransactionType (selectsourcemultiple-1)]=SUBSTRING([TransactionType (selectsourcemultiple-1)],2,LEN([TransactionType (selectsourcemultiple-1)]));
		 
		 SELECT * FROM CQBTempDB.[import].Tb_FormData_3380;

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