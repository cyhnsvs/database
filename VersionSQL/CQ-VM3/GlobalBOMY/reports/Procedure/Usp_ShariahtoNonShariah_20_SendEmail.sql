/****** Object:  Procedure [reports].[Usp_ShariahtoNonShariah _SendEmail]    Committed by VersionSQL https://www.versionsql.com ******/

  
 CREATE PROCEDURE [reports].[Usp_ShariahtoNonShariah _SendEmail](    
	@idteDate DATE,
	@istrAcctNo VARCHAR(20)
	
  )  
AS    
/*  
* Created by:      SRIRAM  
* Date:            12-05-2021  
* Used by:                
* Called by:        
* Project UIN :   
* RFA No.   :   
* Modified BY :    SRIRAM.R  
*
* Purpose: This sp is used to generate the PDF after successful receipt  
*  
* 
* Has been modified by + date + project UIN + note:  
*   
EXEC [reports].[Usp_ShariahtoNonShariah _SendEmail] '2020-12-31','010037402'
*/  
  
BEGIN    
SET NOCOUNT ON;  
SET ANSI_PADDING ON;    
BEGIN TRY  
	
	--DECLARE @idteDate DATE = '2021-11-01';

	--Work Flow Start--
	DROP TABLE IF EXISTS #TempData1;
	DROP TABLE IF EXISTS #TempData2;
	DROP TABLE IF EXISTS ##TempDataCombined;

	DECLARE @istrClientName VARCHAR(100);
	DECLARE @istrClientCode VARCHAR(100);
	DECLARE @istrDealerCode VARCHAR(100);

	DECLARE @Logo1 VARCHAR(MAX)=(SELECT Files FROM reports.Tb_Logo WHERE Name='MonlineLogo');

	SELECT 
		DISTINCT IDENTITY (INT,1,1) AS No, 
		SUBSTRING(A.[textinput-49],0,CHARINDEX ('.', A.[textinput-49])) AS StockCode,
		A.[textinput-2] AS NameOfSecurities
	INTO #TempData1 
	FROM CQBuilder.form.Tb_FormData_1345 A 
	INNER JOIN CQBuilderAuditLog.log.Tb_FormData_1345 B
		ON A.RecordID = B.RecordID
	WHERE A.[multipleradiosinline-3] = 'N' AND JSON_VALUE(B.FormDetails,'$[0].multipleradiosinline3') = 'Y' 
		AND B.LogEvent = 'O' AND B.AuditDateTime >= CAST(DATEADD(m, -6, @idteDate) as date);
		
	DECLARE @TableCount INT =(SELECT COUNT(1) FROM #TempData1);

	SELECT
		No AS No,
		StockCode AS StockCode,
		NameOfSecurities AS NameOfSecurities,
		ROW_NUMBER() OVER(ORDER BY No) AS RowNum
	INTO #TempData2 
	FROM #TempData1 
	WHERE No > CEILING(CAST(@TableCount/2.0 AS DECIMAL(24,2)));

	DELETE FROM #TempData1 WHERE No > CEILING(CAST(@TableCount/2.0 AS DECIMAL(24,2)))

	SELECT '<tr>' + '<td>' + ISNULL(Cast(A.No AS varchar),'')  + '</td>'
				  + '<td>' + ISNULL(A.StockCode,'') + '</td>'
				  + '<td>' + ISNULL(A.NameOfSecurities,'')  + '</td>'
				  + '<td>' +  ISNULL(Cast(B.No AS varchar),'')+ '</td>'
				  + '<td>' + ISNULL(B.StockCode,'')  + '</td>'
				  + '<td>' + ISNULL(B.NameOfSecurities,'')  + '</td>'

				  + '</tr>' AS data
	INTO #TempDataCombined 
	FROM #TempData1 A
	LEFT JOIN #TempData2 B
	ON A.No = B.RowNum;

	DECLARE @val1 NVARCHAR(MAX);
	SELECT @val1 = COALESCE(@val1 + '' + data, data) FROM #TempDataCombined;
	
	DECLARE @header1 VARCHAR(MAX)
	SELECT @header1 = '<tr><th style="width:30px">No</th><th style="width:120px">Stock Code</th><th style="width:150px">Name of Securities</th><th style="width:30px">No</th><th style="width:120px">Stock Code</th><th style="width:150px">Name of Securities</th></tr>'

	DECLARE @Logo VARCHAR(MAX)=(SELECT Files FROM reports.Tb_Logo WHERE Name='MonlineLogo');

	DECLARE @myDate DATE = @idteDate;
	DECLARE @day INT;
	DECLARE @DatePart VARCHAR(50);

	SELECT  @day = DAY(@myDate);
	SELECT @DatePart = (CASE WHEN @day IN ( 11, 12, 13 ) THEN CAST(@day AS VARCHAR(10)) + 'th'
				 WHEN @day % 10 = 1 THEN CAST(@day AS VARCHAR(10)) + 'st'
				 WHEN @day % 10 = 2 THEN CAST(@day AS VARCHAR(10)) + 'nd'
				 WHEN @day % 10 = 3 THEN CAST(@day AS VARCHAR(10)) + 'rd'
				 ELSE CAST(@day AS VARCHAR(10)) + 'th'
        END) + ' '+(SELECT FORMAT (@idteDate, 'MMMM yyyy') as date)
	
	DECLARE @html VARCHAR(MAX);
	SET @html = '<html><head><style>
				table {
				  font-family: arial, sans-serif;
				  border-collapse: collapse;
				  font-size:12px;
				}
				
				td,th{
				 border: 1px solid #dddddd;
				  text-align: center;
				  padding: 8px;
				}
				
				img{
				width: 20%;
				height: auto;
				}

				
				.center 
				{
				  margin: auto;
				  width: 100%;
				  padding: 2px;
				  font-size:20px;

				}
				
				</style>
				</head>
				<body>
				<img src="'+@Logo+'" /> <br><br>
				Dear Client,<br><br>

				As per '+@DatePart+', an updated list of Shariah-compliant securities was released by the Securities
				Commission Malaysia (SC).<br><br>
				Please be informed that the following securities in which were previously Shariah-compliant securities has 
				now been categorized as Shariah non-compliant securities: <br>
				<br><div class="center">
				<table><tbody>' + @header1 + @val1 + '</tbody></table></div><br><br>

				You are required to take appropriate action in accordance with the Best Practices for Shariah Investing 
				attached herein should you own any of these securities 
                Kindly contact your Dealer’s Representatives (DR) should you have any enquiries.<br><br>
                 Thank you.



				</body></html>'
	SELECT @html;
	
END TRY  
BEGIN CATCH   
        --print 'error'  
  IF ERROR_NUMBER() IS NULL  
   RETURN;  
  
  DECLARE @ErrorMessage NVARCHAR(4000), @ErrorNumber INT, @ErrorSeverity INT, @ErrorState INT, @ErrorLine INT, @ErrorProcedure NVARCHAR(200);  
  SELECT @ErrorMessage=ERROR_MESSAGE(), @ErrorNumber = ERROR_NUMBER(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE(), @ErrorLine = ERROR_LINE(), @ErrorProcedure = ISNULL(ERROR_PROCEDURE(), '-');  
  SELECT @ErrorMessage = N'Error %d, Level %d, State %d, Procedure %s, Line %d, Message: '+ @ErrorMessage;  
  RAISERROR(@ErrorMessage, @ErrorSeverity, 1, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine);  
           
 END CATCH  
  
SET NOCOUNT OFF;  
END