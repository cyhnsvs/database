/****** Object:  Procedure [reports].[Usp_ShariahtoNonShariah _SendEmailUpdated]    Committed by VersionSQL https://www.versionsql.com ******/

  
CREATE PROCEDURE [reports].[Usp_ShariahtoNonShariah _SendEmailUpdated](    
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
EXEC [reports].[Usp_ShariahtoNonShariah _SendEmailUpdated] '2021-06-22','010037402'
*/  
  
BEGIN    
SET NOCOUNT ON;  
SET ANSI_PADDING ON;    
BEGIN TRY  

	--DECLARE @idteDate DATE = '2021-11-01';

   --Work Flow Start--
    DROP TABLE IF EXISTS #TempData1;
    DROP TABLE IF EXISTS #TempDataCombined;

	DECLARE @ClientName VARCHAR(100);

	SELECT @ClientName = ISNULL(C.[CustomerName (textinput-3)], '')
	FROM CQBTempDB.export.Tb_FormData_1409 A
	INNER JOIN CQBTempDB.export.Tb_FormData_1410 C
	ON C.[CustomerID (textinput-1)]  = A.[CustomerID (selectsource-1)]
	WHERE A.[AccountNumber (textinput-5)] = @istrAcctNo;
	
	SELECT DISTINCT
		IDENTITY (INT,1,1) AS No, 
		SUBSTRING(A.[textinput-49],0,CHARINDEX ('.', A.[textinput-49])) AS StockCode,
		A.[textinput-2] AS NameOfSecurities
	INTO #TempData1 
	FROM CQBuilder.form.Tb_FormData_1345 A 
	INNER JOIN CQBuilderAuditLog.log.Tb_FormData_1345 B
		ON A.RecordID = B.RecordID
	WHERE A.[multipleradiosinline-3] = 'N' AND JSON_VALUE(B.FormDetails,'$[0].multipleradiosinline3') = 'Y'
		AND B.LogEvent = 'O' AND B.AuditDateTime >= CAST(DATEADD(m, -6, @idteDate) as date);

	SELECT '<label>' + ISNULL(Cast(A.No AS varchar),'')  + ') '+ ISNULL(A.NameOfSecurities,'') + '('+ ISNULL(A.StockCode,'')  + ')</label><br>' AS data
	INTO #TempDataCombined FROM #TempData1 A;
	
	DECLARE @val1 NVARCHAR(MAX);
	SELECT @val1 = COALESCE(@val1 + '' + data, data) FROM #TempDataCombined;

	DECLARE @Logo VARCHAR(MAX)=(SELECT Files FROM reports.Tb_Logo WHERE Name='MonlineLogoForEmail');

	DECLARE @DatePart VARCHAR(50) = (SELECT FORMAT (@idteDate, 'MMMM yyyy') as date);

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
				Dear '+ISNULL(@ClientName,'')+',<br><br>

				As per '+ISNULL(@DatePart,'')+', an updated list of Shariah-compliant securities was released by the Securities
				Commission Malaysia (SC).<br><br>
				Please be informed that the following securities in which were previously Shariah-compliant securities has 
				now been categorized as Shariah non-compliant securities: <br>
				<br><div>'
				+ ISNULL(@val1,'') + '</div><br><br>
				You are required to take appropriate action in accordance with the <a href="https://www.bursamalaysia.com/sites/5bb54be15f36ca0af339077a/assets/5bb55b8a5f36ca0c38d98c08/Best_Practices_for_Shariah_Investing.pdf">Best Practices for Shariah Investing</a> 
				under content 6.1. <br>
				
				

                Kindly contact your Dealer’s Representatives (DR) should you have any enquiries.Please do not reply to this email.<br><br>
                 Thank you.



				</body></html>'

				--You are required to take appropriate action in accordance with the <u style="color:blue;">Best Practices for Shariah Investing</u> 
				--under content 6.1. <br>

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