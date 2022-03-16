/****** Object:  Procedure [import].[Usp_1_BranchRef_FileToForm1374]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [import].[Usp_1_BranchRef_FileToForm1374]
AS
/***********************************************************************             
            
Created By        : Nishanth
Created Date      : 22/06/2020
Last Updated Date :             
Description       : this sp is used to insert Branch Ref file data into CQForm Branch
            
Table(s) Used     : 
            
Modification History :            
 ModifiedBy : 			ModifiedDate : 			Reason : 

PARAMETERS
EXEC [import].[Usp_1_BranchRef_FileToForm1374]
************************************************************************************/
BEGIN
  
	SET NOCOUNT ON;
	
	BEGIN TRY
	
        BEGIN TRANSACTION;
		
		Exec CQBTempDB.form.[Usp_CreateImportTable] 1374
		--Select * from CQBTempDB.[import].[Tb_FormData_1374]

		TRUNCATE TABLE CQBTempDB.[import].Tb_FormData_1374;
				
		INSERT INTO CQBTempDB.[import].Tb_FormData_1374
			([RecordID], [Action], [BranchID (textinput-1)], [BranchCode (textinput-42)], [BranchLocation (textinput-2)], [Address1 (textinput-7)], [Address2 (textinput-8)], [Address3 (textinput-9)], 
			 [Town (textinput-10)], [PostalCode (textinput-11)], [State (textinput-36)], [State (selectsource-11)], [Country (selectsource-12)], [Region (selectsource-10)], [PICName (textinput-38)], 
			 [OfficeNumber (textinput-13)], [PICMobileNumber (textinput-14)], [PICEmail (textinput-15)])    
		SELECT null as [RecordID],
			   'I' as [Action],
			   '001' as  [BranchID (textinput-1)],
			   'HQ' as  [BranchCode (textinput-42)],
			   'Main Branch' as  [BranchLocation (textinput-2)],
			   'NO 1, 3 & 5 JALAN PPM 9' as  [Address1 (textinput-7)],
			   'PLAZA PANDAN MALIM BUSINESS PARK' as  [Address2 (textinput-8)],
			   'BALAI PANJANG, P.O. BOX 248' as  [Address3 (textinput-9)],
			   'MELAKA' as  [Town (textinput-10)],
			   '75250' as  [PostalCode (textinput-11)],
			   'MELAKA' as  [State (textinput-36)],
			   'MLC' as  [State (selectsource-11)],
			   'MY' as  [Country (selectsource-12)],
			   'Northern' as  [Region (selectsource-10)],
			   '' as  [PICName (textinput-38)],
			   '06-3371533' as  [OfficeNumber (textinput-13)],
			   '06-3371577' as  [PICMobileNumber (textinput-14)],
			   'enqiury@malaccasecurities.com.my' as  [PICEmail (textinput-15)]

		--CREATE TABLE import.Tb_BranchMapping
		--(
		--	SBranch VARCHAR(20),
		--	BranchID VARCHAR(3)
		--);

		TRUNCATE TABLE import.Tb_BranchMapping;

		INSERT INTO import.Tb_BranchMapping
		SELECT 'HQ' AS SBranch, '001' as BranchID UNION 
		SELECT 'SJ' AS SBranch, '002' as BranchID UNION 
		SELECT 'PJ' AS SBranch, '003' as BranchID UNION 
		SELECT 'PP' AS SBranch, '004' as BranchID UNION 
		SELECT 'JB' AS SBranch, '005' as BranchID UNION 
		SELECT 'SB' AS SBranch, '006' as BranchID UNION 
		SELECT 'BT' AS SBranch, '007' as BranchID UNION 
		SELECT 'BL' AS SBranch, '008' as BranchID UNION 
		SELECT 'KP' AS SBranch, '009' as BranchID UNION 
		SELECT 'KJ' AS SBranch, '010' as BranchID UNION 
		SELECT 'MC' AS SBranch, '011' as BranchID UNION 
		SELECT 'WM1' AS SBranch, '012' as BranchID UNION 
		SELECT 'WM2' AS SBranch, '012' as BranchID UNION 
		SELECT 'IP' AS SBranch, '013' as BranchID UNION 
		SELECT 'VP' AS SBranch, '014' as BranchID UNION 
		SELECT 'MU' AS SBranch, '015' as BranchID UNION 
		SELECT 'BP' AS SBranch, '016' as BranchID UNION 
		SELECT 'AS' AS SBranch, '017' as BranchID UNION 
		SELECT 'SA' AS SBranch, '018' as BranchID UNION 
		SELECT 'EC' AS SBranch, '019' as BranchID UNION 
		SELECT 'DP' AS SBranch, '020' as BranchID;

		--select * FROM import.Tb_BranchRef order by group1
		--SELECT SBranch, RIGHT('000'+CAST((ROW_NUMBER() OVER (ORDER BY SBranch)+1) as varchar(3)),3) as  BranchID
		--FROM import.Tb_BranchRef;
		
		INSERT INTO CQBTempDB.[import].Tb_FormData_1374
			([RecordID], [Action], [BranchID (textinput-1)], [BranchCode (textinput-42)], [BranchLocation (textinput-2)], [Address1 (textinput-7)], [Address2 (textinput-8)], [Address3 (textinput-9)], 
			 [Town (textinput-10)], [PostalCode (textinput-11)], [State (selectsource-11)], [State (textinput-36)], [Country (selectsource-12)], [Region (selectsource-10)], [PICName (textinput-38)], 
			 [OfficeNumber (textinput-13)], [PICMobileNumber (textinput-14)], [PICEmail (textinput-15)])    
		SELECT null as [RecordID],
			   'I' as [Action],
			   BM.BranchID as  [BranchID (textinput-1)],
			   BM.SBranch as  [BranchCode (textinput-42)],
			   SBranchName as  [BranchLocation (textinput-2)],
			   '' as  [Address1 (textinput-7)],
			   '' as  [Address2 (textinput-8)],
			   '' as  [Address3 (textinput-9)],
			   '' as  [Town (textinput-10)],
			   '' as  [PostalCode (textinput-11)],
			   ISNULL(C.[Value (textinput-3)], State) as  [State (selectsource-11)],
			   State as  [State (textinput-36)],
			   'MY' as  [Country (selectsource-12)],
			   Region as  [Region (selectsource-10)],
			   '' as  [PICName (textinput-38)],
			   '' as  [OfficeNumber (textinput-13)],
			   '' as  [PICMobileNumber (textinput-14)],
			   '' as  [PICEmail (textinput-15)]
		FROM import.Tb_BranchRef AS BR
		INNER JOIN import.Tb_BranchMapping AS BM
		ON BR.SBranch = BM.SBranch
		INNER JOIN CQBTempDB.import.Tb_FormData_1319 AS C
		ON REPLACE(BR.State,'KUALA LUMPUR','SELANGOR') = C.[CodeDisplay (textinput-2)] AND C.[CodeType (selectbasic-1)]='State'
		WHERE BranchID <> '001';
		
		--select *
		--FROM import.Tb_BranchRef;

		-- UPDATE LIMIT INFO
		UPDATE Form
		SET 
			[MaxBuyLimit (textinput-39)] = ISNULL(CASE WHEN B.MAXBUYLIM = '.00' THEN '0.00' ELSE B.MAXBUYLIM END,'0.00'),
			[MaxSellLimit (textinput-40)] = ISNULL(CASE WHEN B.MAXSELLLIM = '.00' THEN '0.00' ELSE B.MAXSELLLIM END,'0.00'),
			[MaxNetLimit (textinput-41)] = ISNULL(CASE WHEN B.MAXNETLIM = '.00' THEN '0.00' ELSE B.MAXNETLIM END,'0.00')
		FROM
			CQBTempDB.[import].Tb_FormData_1374 Form
		LEFT JOIN 
			import.Tb_Limit_Branch B ON Form.[BranchID (textinput-1)] = B.BRANCHID;
		
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