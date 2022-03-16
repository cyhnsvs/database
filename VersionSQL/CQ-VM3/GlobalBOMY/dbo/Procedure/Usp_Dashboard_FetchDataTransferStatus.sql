/****** Object:  Procedure [dbo].[Usp_Dashboard_FetchDataTransferStatus]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Usp_Dashboard_FetchDataTransferStatus]
AS
/*
* Created by: Nishanth Chowdhary
* Date		: 14 NOV 2016
* Used by	: GBOSG Dashboard
* Called by	: GBOSG Dashboard Application
*
* Purpose: This sp is used to fetch the status of the data transfer process.
*
* Input Parameters:
* NONE
* Output Parameters:
* NONE
*
* Has been modified by + date + project UIN + note:
*/
BEGIN
SET NOCOUNT ON;
	
	SELECT [DBName] AS [Database]
		  ,[TbSchema] + '.' + [TableName] AS [Table]
		  ,[TransferType] AS [Transfer Type]
		  ,[JobName] AS [Job]
		  ,[BatchNo] AS [Batch]
		  ,[SourceRowCount] AS [Source Count]
		  ,[DestRowCount] AS [Destination Count]
		  ,CASE WHEN ISNULL([LastSuccessRun],'1900-01-01') > ISNULL([LastFailedRun],'1900-01-01') THEN '<font color="green">Success</font>'
				ELSE '<font color="red">Failed</font>' END AS [Status]
		  ,CASE WHEN ISNULL([LastSuccessRun],'1900-01-01') > ISNULL([LastFailedRun],'1900-01-01') THEN [LastSuccessRun]
				ELSE [LastFailedRun] END AS [Status Time]
		  ,[Remarks] AS [Remarks]
	FROM [dbo].[Tb_DataTransferDetails] WHERE EnableArchive = 1
	ORDER BY BatchNo, [Status], [Status Time] DESC;

SET NOCOUNT OFF;
END