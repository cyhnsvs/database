/****** Object:  Procedure [import].[TS_UpdateRowCount]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE   PROCEDURE [import].[TS_UpdateRowCount]
	@iintCompanyId BIGINT = 1,  
    @istrCheckedFor varchar(255)='', -- SSIS NAME OR IMPORT PROCEDURE NAME
	@istrCol1 varchar(255)='', -- FILE NAME OR SOURCE TABLE NAME
	@istrCol2 varchar(255)='', -- DESTINATION TABLE NAME
	@iintCol3 bigint, -- FILE ROW COUNT OR SOURCE TABLE COUNT,
	@iintCol4 bigint , -- DESTINATION TABLE COUNT
	@strcol5 varchar(50) ='' -- additional info
AS
/*********************************************************************************** 

Name              : [import].[TS_UpdateRowCount]
Created By        : Anita Chavan
Created Date      : 13/11/2019
Last Updated Date : 
Description       : sp for updating row count
Table(s) Used     :  
                                         

Modification History :
	ModifiedBy :          Project UIN;		ModifiedDate :      Reason :


PARAMETERS 
	 

Used By : Job
execute [import].[TS_UpdateRowCount] 1, 'Import' ,'StockInfoAUS'  ,'import.PSPL_StockInfo ',0,0,''

EXECUTE [import].[TS_UpdateRowCount]
	 1, 
	 'PSPL StockInfo', 
    'BookkeepingCash_31-10-2019.txt', -- SSIS NAME OR IMPORT PROCEDURE NAME
	'[import].[SAXO_BookkeepingCash]', -- FILE NAME OR SOURCE TABLE NAME	
	813, -- FILE ROW COUNT OR SOURCE TABLE COUNT,
	0 , -- DESTINATION TABLE COUNT
	NULL 


************************************************************************************/ 
BEGIN

	
	BEGIN TRY	

	
		 DECLARE    @dteBusinessDate DATE ,							
					@strQuery Nvarchar(1000);
					

		DECLARE @TblRow as Table (Rowcnt int);

		SELECT @dteBusinessDate = DateValue  FROM GlobalBO.setup.Tb_Date  WHERE CompanyId = @iintCompanyId;

		if @iintCol4 = 0

		begin
		
			SET @strQuery = N'SELECT COUNT(1) FROM ' + @istrCol2;

			if @istrCol1 like '%.txt%' or @istrCol1 like '%.csv%' or @istrCol1 like '%.xls%'
			begin
				SET @strQuery = @strQuery + ' WHERE SourceFileName = ''' + RTRIM(LTRIM(@istrCol1)) + '''';

			end

			insert into @TblRow(Rowcnt)
			EXECUTE sp_executesql @strQuery;

			select @iintCol4 = Rowcnt from @TblRow ;
		end


		INSERT INTO GlobalBO.[global].[Tb_DataCheckingResult]
				   ([CompanyId]
				   ,[BusinessDate]
				   ,[CheckedFor]
				   ,[Col1]
				   ,[Col2]
				   ,[Col3]
				   ,[Col4]
				   ,[Col5]
				   ,[Col6]
				   ,[Col7]
				   ,[Col8]
				   ,[Col9]
				   ,[Col10]
				   ,[CreatedBy]
				   ,[CreatedDate])
		SELECT 
				1 AS [CompanyId]
				,@dteBusinessDate AS [BusinessDate]
				,@istrCheckedFor as [CheckedFor]
				,@istrCol1 AS [Col1]
				,@istrCol2 AS [Col2]
				,@iintCol3 AS [Col3]
				,@iintCol4 AS [Col4]
				,'' AS [Col5]
				,'' AS [Col6]
				,'' AS [Col7]
				,'' AS [Col8]
				,'' AS [Col9]
				,'' AS [Col10]
				,'Admin' AS [CreatedBy]  
				,GETDATE() AS[CreatedDate]

  END TRY  
    BEGIN CATCH  
      
	EXECUTE utilities.[usp_RethrowError] 'TS_UpdateRowCount';
       
    END CATCH  

end
  