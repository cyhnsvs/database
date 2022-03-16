/****** Object:  Procedure [dbo].[Usp_ExpirationOfW8BEN_SendEmail]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Usp_ExpirationOfW8BEN_SendEmail]
AS  
/*
* Created by:      Nathiya
* Date:            12 Feb 2021
* Used by:         GBO Process 
* Called by:       GBO Batch Process Manager Monitor
* Project UIN:	   
* RFA:			   
*
* Purpose: This sp is used to send email alert for Expiration of W8Ben for Customers.
*
* Input Parameters:
* NONE
*
* Output Parameters:
* NONE
*
* Has been modified by + date + project UIN + note:
* 1.  
*/

BEGIN  
SET NOCOUNT ON;

	DECLARE @strMailBody VARCHAR(MAX);
	DECLARE @strFrom VARCHAR(200);  
	DECLARE @strTo VARCHAR(200);           
	DECLARE @strMailSubject VARCHAR(200); 
	
	SET @strMailBody = '';

	/* Testing - Start*/
	
	SET @strMailBody = '<html>
						<img style="float: right;" src="file://C:Logo/Logo.png"/> <br><br>
						<body>Dear Sir/ Madam,<br><br>
						This email is a friendly reminder that your <u>Declaration of W-8Ben</u> will be expiring on <b><u>02/12/2021.</b></u><br>
						If you wish to continue trading in the U.S. stock market, please submit the enclosed declaration form that was duly signed by you and send to your dealer representative or email to <font <font color="blue"><u>foreign@msec.com.my</u></font> .<br><br>
						The information is as follows : <br><br>
						a) Account Name :	WONG CHIA LOON<br>
						b) Account Code  :	WCL035X<br>
						c) Start date   :	01/12/2018 (Valid for 3 years) <br><br>
						Should you have forwarded the form to us for renewal of the aforesaid declaration, kindly disregard this notice. <br><br><br>
						Thank you. <br><br>
						Yours sincerely,<br><br><br><br><br><br><br>
						<b>Note</b> : The W-8Ben form will remain in effect for a period starting on the date the form is signed and submitted and ending on the last day of the third succeeding calendar year.
						</body></html>'

	SET @strTo = 'nathiya.palanisamy@phillip.com.sg'
	SET	@strMailSubject = 'Notifying of Expiring- <u>Declaration of W-8Ben</u>'
	SET	@strFrom = 'nathiya.palanisamy@phillip.com.sg'

	EXEC [master].[dbo].DBA_SendEmail
	@istrMailTo             = @strTo,
	@istrMailBody           = @strMailBody,
	@istrMailSubject        = @strMailSubject,
	@istrfrom_address       = @strFrom,
	@istrreply_to           = @strFrom,
	@istrbody_format        = 'HTML';

	/* Testing - End */

	/* WorkFlow
	
	CREATE TABLE #Client
	(
		AccountName		VARCHAR(200),
		AccountCode		VARCHAR(50),
		W8BENStartDate	DATE,
		W8BENExpiryDate DATE,
		CustomerEmail	VARCHAR(200),
		DealerEmail		VARCHAR(200),
		Processed		BIT
	) 
	INSERT INTO
	(
		 AccountName		
		,AccountCode		
		,W8BENStartDate	
		,W8BENExpiryDate 
		,CustomerEmail	
		,DealerEmail
		,Processed		
	)
	SELECT
		[CustomerName (textinput-3)],
		[CustomerID (textinput-1)],
		[W8BENStartDate (dateinput-14)],
		[W8BENExpiryDate (dateinput-18)],
		[Email (textinput-58)],
		[WorkEmail (textinput-20)],
		0
	FROM
		CQBTempDB.export.Tb_FormData_1410 Customer
	LEFT JOIN 
		CQBTempDB.export.Tb_FormData_1409 Account  ON Customer.[CustomerID (textinput-1)]  = Account. [CustomerID (selectsource-1)]
	LEFT JOIN 
		CQBTempDB.export.Tb_FormData_1377 Dealer ON Account.[DealerCode (selectsource-21)] = Dealer.[DealerCode (textinput-35)]
	WHERE 
		[W8BEN (multipleradiosinline-21)] = 'Y' -- AND [W8BENExpiryDate (dateinput-18)] < DATEADD(month, 1, GETDATE())


	WHILE (SELECT COUNT(*) FROM #Client WHERE Processed = 0) > 0
	BEGIN
		DECLARE @customer VARCHAR(200);
		SET @customer = (SELECT TOP 1 AccountName FROM #client)

		SET @strMailBody = '';

		SELECT @strMailBody = '<html>
							<img style="float: right;" src="file://C:Logo/Logo.png"/> <br><br>
							<body>Dear Sir/ Madam,<br><br>
							This email is a friendly reminder that your <u>Declaration of W-8Ben</u> will be expiring on <b><u>' + CONVERT(VARCHAR,W8BENExpiryDate,103) + '.</b></u><br>
							If you wish to continue trading in the U.S. stock market, please submit the enclosed declaration form that was duly signed by you and send to your dealer representative or email to <font <font color="blue"><u>foreign@msec.com.my</u></font> .<br><br>
							The information is as follows : <br><br>
							a) Account Name :	' + AccountName + '<br>
							b) Account Code :	' + AccountCode + '<br>
							c) Start date   :	' + CONVERT(VARCHAR,W8BENStartDate,103) + ' (Valid for ' + DATEDIFF(YEAR, CAST(W8BENExpiryDate AS DATETIME) - 912, CAST(W8BENStartDate AS DATETIME)) + ' years) <br><br>
							Should you have forwarded the form to us for renewal of the aforesaid declaration, kindly disregard this notice. <br><br><br>
							Thank you. <br><br>
							Yours sincerely,<br><br><br><br><br><br><br>
							<b>Note</b> : The W-8Ben form will remain in effect for a period starting on the date the form is signed and submitted and ending on the last day of the third succeeding calendar year.
							</body></html>',
				@strTo = CustomerEmail + ';' + DealerEmail
				
		WHERE
			AccountName = @customer

		SET	@strMailSubject = 'Notifying of Expiring- <u>Declaration of W-8Ben</u>'
		SET	@strFrom = 'nathiya.palanisamy@phillip.com.sg'
		
		IF ISNULL(@strFrom,'')=''  
		SET   @strFrom='nathiya.palanisamy@phillip.com.sg';  
		IF ISNULL(@strTo,'')=''  
		SET   @strTo='nishanth@phillip.com.sg';     
		IF ISNULL(@strMailSubject,'')=''            
		SET @strMailSubject='Notifying of Expiring- Declaration of W-8Ben';  

		EXEC [master].[dbo].DBA_SendEmail
		@istrMailTo             = @strTo,
		@istrMailBody           = @strMailBody,
		@istrMailSubject        = @strMailSubject,
		@istrfrom_address       = @strFrom,
		@istrreply_to           = @strFrom,
		@istrbody_format        = 'HTML';
	
		UPDATE #client SET Processed = 1 WHERE AccountName = @customer
	END	  
	 */ 

SET NOCOUNT OFF;
END