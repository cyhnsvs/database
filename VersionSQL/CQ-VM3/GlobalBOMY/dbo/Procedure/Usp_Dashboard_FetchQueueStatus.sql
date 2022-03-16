/****** Object:  Procedure [dbo].[Usp_Dashboard_FetchQueueStatus]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Usp_Dashboard_FetchQueueStatus]
AS
/*
* Created by: Nishanth Chowdhary
* Date		: 29 SEP 2016
* Used by	: GBOSG Dashboard
* Called by	: GBOSG Dashboard Application
*
* Purpose: This sp is used to fetch the status of the inbound and outbound messages in the queue.
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
	
	--Summary
	--SELECT cast(getdate() as date) as [Queue Date], 'N/A' as [Msg Type], 'Success' as [Request Status], '0' as [Msg Count]
	
	SELECT * 
	FROM (
		SELECT 'IN' AS MessageDirection, QueueID, QueueDateTime AS [Queue Date], MessageData, Priority, Status, Remarks
		FROM Queue.MBMSInBound
		UNION
		SELECT 'OUT' AS MessageDirection, QueueID, QueueDateTime AS [Queue Date], MessageData, Priority, Status, Remarks
		FROM Queue.MBMSOutBound
	) AS M
	ORDER BY [Queue Date] DESC, Priority, QueueID

	----SELECT * FROM Queue.MBMSOutBound;

	return null;

SET NOCOUNT OFF;
END