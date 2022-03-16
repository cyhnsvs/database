/****** Object:  Procedure [import].[Usp_4_OnlineTrade_FileToFormXXXX]    Committed by VersionSQL https://www.versionsql.com ******/

create PROCEDURE [import].[Usp_4_OnlineTrade_FileToFormXXXX]
as 
	SET NOCOUNT ON;
	
	--BEGIN TRY
	
      --  BEGIN TRANSACTION; 

	/*	INSERT INTO CQBTempDB.[import].Tb_FormData_XXXX (
	*/
	SELECT  
	[ConDate]    ,
	[ClientNo] ,
	[StockNo]  ,
	[BuySell]  ,
	[MatchedPrice]  ,
	[OrderNo]  ,
	[TerminalNo]  ,
	[MatchedQty] ,
	[BranchId] ,
	[OnlineFlag] 
	FROM
	[import].[Tb_N2N_OnlineTrade] 
		--   COMMIT TRANSACTION;
        
 ---   END TRY