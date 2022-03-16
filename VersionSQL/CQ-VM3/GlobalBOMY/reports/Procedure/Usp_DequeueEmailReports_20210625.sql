/****** Object:  Procedure [reports].[Usp_DequeueEmailReports_20210625]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [reports].[Usp_DequeueEmailReports_20210625]
	@batchSize int,
	@ip varchar(50),
	@instanceName varchar(50),
	@thread varchar(50)
AS
BEGIN
	SET NOCOUNT ON;

	declare @retryAfterSeconds int = 120;
	declare @process table (processId bigint);

	    UPDATE TOP (@batchSize) a
	WITH (
			UPDLOCK
			,READPAST
			)
	SET STATUS = 4,
	a.ProcessByIP = @ip,
	a.ProcessByInstanceName = @instanceName,
	a.ProcessByThread = @thread,
	a.ProcessStarted = getdate(),
	a.RetryCount = RetryCount + 1
	OUTPUT inserted.IDD into @process
	FROM  reports.Tb_Process AS a
	inner join reports.Tb_ReportSetup S on a.ReportID= s.IDD 
		WHERE S.SendEmail='1'AND
		[Status] = 2-- or ([Status] = 5 and DATEDIFF(SECOND, a.UpdatedDate, GETDATE()) >= @retryAfterSeconds)) 

	
    DECLARE @istrEmailBody NVARCHAR(MAX);
	DECLARE @istrRecepient VARCHAR(MAX);
	DECLARE @istrEmailSp VARCHAR(200);

	DECLARE @istrBodyType VARCHAR(100);
	DECLARE @istrRecepientType VARCHAR(200);
	DECLARE @icharAttachReport CHAR(3);
	DECLARE @EmailSetupXML XML=(SELECT
								S.EmailSetup
								FROM 
								reports.Tb_ReportSetup S 																							
								inner join reports.Tb_Process Pr on Pr.ReportID=S.IDD
								Where pr.IDD in (SELECT processId FROM @process));

	SELECT
    @istrBodyType=a.value('(Body/@type)[1]', 'nvarchar(max)'),
    @istrRecepientType=a.value('(Recipient/@value)[1]', 'nvarchar(max)'),
    @icharAttachReport=a.value('(AttachReport/@value)[1]', 'Char(3)')

    from @EmailSetupXML.nodes('config') xmlData(a)

	IF(@istrBodyType ='SP')
	BEGIN
	
		SELECT
		@istrEmailSp=a.value('(Body/@value)[1]', 'nvarchar(max)')		
		from @EmailSetupXML.nodes('config') xmlData(a)
	END
	ELSE IF(@istrBodyType='SQLStatement')
	BEGIN
		SELECT
		@istrEmailSp=S.SQLStatement
		FROM 
		reports.Tb_ReportSetup S 																							
		inner join reports.Tb_Process Pr on Pr.ReportID=S.IDD
		Where pr.IDD in (SELECT processId FROM @process);
	END

		DECLARE @SqlQuery NVARCHAR(MAx) = '';

		SELECT  @SqlQuery = @SqlQuery + '@' + ParamName + ' = N''' + ParamValue + ''',' from reports.Tb_ProcessParam where ProcessID in (SELECT processId FROM @process)
		SELECT @SqlQuery = @istrEmailSp + ' ' + SUBSTRING(ISNULL(@SqlQuery,''), 0, len(@SqlQuery))
		FROM reports.Tb_ReportSetup AS a 
	    JOIN reports.Tb_Process as b ON 
		a.IDD = b.ReportID WHERE b.IDD in (SELECT processId FROM @process)
		
 

		  DECLARE @EmailBody table (BodyContent NVarchar(MAx))

		 INSERT INTO @EmailBody	EXEC (@SqlQuery);

		 SET @istrEmailBody =(SELECT BodyContent FROM @EmailBody )

	 

      drop table if exists #Email

		create table #Email
		( 
		Processid bigint
		,Recipient varchar(500)
		,CC varchar(500)
		,Subject varchar(500)
		,AttachReport varchar(500)
		,Body Nvarchar(MAX)
		,RecipientId varchar(500)
		,RecipientType varchar(8000)
        )

insert into #Email(Processid, Recipient, CC, Subject, AttachReport, Body ,RecipientId,RecipientType)
select Pr.IDD ProcessID ,'fadlin@phillip.com.sg','',S.Name, CASE WHEN(@icharAttachReport='1')THEN S.DestinationPath+S.FileNameSetup ELSE NULL END,@istrEmailBody, PrP.ParamValue RecipientId , prp.ParamName RecipientType
from reports.Tb_ReportSetup S 																							
inner join reports.Tb_Process Pr on Pr.ReportID=S.IDD
inner join reports.Tb_ProcessParam PrP on Pr.IDD=PrP.ProcessID
 Where S.SendEmail=1 and PrP.ParamName='istrAcctNo' and pr.IDD in (select processId from @process);
 
 
 
 
 --IF (@istrRecepientType = 'AcctNo,RemisierCode')
 --BEGIN
	--UPDATE T
	--SET T.Recipient= C.[Email (textinput-58)]+','+D.[WorkEmail (textinput-20)]
	--FROM #Email T
	--INNER JOIN CQBTempDB.export.Tb_FormData_1409 A 
	--	ON t.RecipientId=A.[AccountNumber (textinput-5)] 
	--INNER JOIN CQBTempDB.export.Tb_FormData_1410 C
	--	ON C.[CustomerID (textinput-1)]  = A.[CustomerID (selectsource-1)]	
	
	--INNER JOIN
	--	CQBTempDB.export.Tb_FormData_1377 D ON A.[DealerCode (selectsource-21)] = D.[DealerCode (textinput-35)]
	--WHERE T.RecipientType='istrAcctNo' 
 --END
 --ELSE IF(@istrRecepientType = 'AcctNo')
 --BEGIN
	-- UPDATE T
	--	SET T.Recipient= C.[Email (textinput-58)]
	--	FROM #Email T
	--	INNER JOIN CQBTempDB.export.Tb_FormData_1409 A 
	--		ON t.RecipientId=A.[AccountNumber (textinput-5)] 
	--	INNER JOIN CQBTempDB.export.Tb_FormData_1410 C
	--		ON C.[CustomerID (textinput-1)]  = A.[CustomerID (selectsource-1)]	
	--	WHERE T.RecipientType='istrAcctNo'
 --END
 --ELSE IF(@istrRecepientType = 'RemisierCode')
 --BEGIN
 --UPDATE T
	--SET T.Recipient= D.[WorkEmail (textinput-20)]
	--FROM #Email T
	--INNER JOIN CQBTempDB.export.Tb_FormData_1409 A 
	--	ON t.RecipientId=A.[AccountNumber (textinput-5)] 
	--INNER JOIN
	--	CQBTempDB.export.Tb_FormData_1377 D ON A.[DealerCode (selectsource-21)] = D.[DealerCode (textinput-35)]
	--WHERE T.RecipientType='istrAcctNo'
 --END
 
 

drop table if exists #temp 
select T.*,ROW_NUMBER() OVER(PARTITION BY PrP.ProcessID ORDER BY PrP.IDD desc) AS RowNo
into #temp
		from #Email T
		join reports.Tb_ProcessParam as PrP on t.ProcessID=PrP.ProcessID
		order by PrP.ProcessID,PrP.IDD asc



DECLARE  @params TABLE (ParamName VARCHAR(200),ParamValue VARCHAR(200))

INSERT INTO @params
SELECT 
Prp.ParamName AS ParamName,
PrP.ParamValue AS ParamValue
FROM  reports.Tb_Process Pr
INNER JOIN reports.Tb_ProcessParam PrP ON Pr.IDD=PrP.ProcessID
WHERE pr.IDD in (SELECT processId FROM @process);

IF(@icharAttachReport = '1')
BEGIN
	DECLARE @FileNameSetup VARCHAR(MAX)=(SELECT TOP 1 AttachReport FROM #temp);

	SELECT @FileNameSetup=REPLACE(@FileNameSetup,'{'+a.ParamName+'}',a.ParamValue) from @params a

	UPDATE #temp SET AttachReport=@FileNameSetup

END

		select * From #temp where RowNo=1
END