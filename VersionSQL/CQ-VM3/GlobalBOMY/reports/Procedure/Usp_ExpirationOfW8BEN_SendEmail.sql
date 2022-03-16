/****** Object:  Procedure [reports].[Usp_ExpirationOfW8BEN_SendEmail]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [reports].[Usp_ExpirationOfW8BEN_SendEmail]
    @idteDate DATE,
	@istrAcctNo VARCHAR(100)
AS  
/*
* Created by:      Sriram
* Date:            28 April 2021
* Used by:         
* Called by:       
* Project UIN:	   
* RFA:			   
*
*
* Input Parameters:
* NONE
*
* Output Parameters:
* NONE
*
* Has been modified by + date + project UIN + note:
* 1.  
EXEC [reports].[Usp_ExpirationOfW8BEN_SendEmail] '2020-10-27', '015621401'
*/

BEGIN  
SET NOCOUNT ON;
       DECLARE @ostrMailContent NVARCHAR(MAX)='';
	  

	  /* Workflow - Start*/         
	
	
	DECLARE @CustomerName VARCHAR(100);
	DECLARE @CustomerID VARCHAR(100);
	DECLARE @W8BENStartDate DATETIME;
	DECLARE @W8BENExpiryDate DATETIME;

	
	SELECT DISTINCT
		@CustomerName=[CustomerName (textinput-3)],
		@CustomerID=[CustomerID (textinput-1)],
		@W8BENStartDate=CAST([W8BENStartDate (dateinput-14)] AS DateTime),
		@W8BENExpiryDate=CAST([W8BENExpiryDate (dateinput-18)] AS DateTime)
    FROM
		CQBTempDB.export.Tb_FormData_1410 C
	    INNER JOIN 
		CQBTempDB.export.Tb_FormData_1409 A  ON
		C.[CustomerID (textinput-1)]  = A. [CustomerID (selectsource-1)] 
		WHERE [W8BENExpiryDate (dateinput-18)] < DATEADD(month, 1, '2020-10-27') AND [W8BEN (multipleradiosinline-21)] = 'Y'
		AND  A.[AccountNumber (textinput-5)]  = @istrAcctNo

    DECLARE @Logo VARCHAR(MAX)=(SELECT Files FROM reports.Tb_Logo WHERE Name='MonlineLogo')


	
	SET @ostrMailContent= '<html>
						<body><img style="float: right;" src="'+@Logo+'"/> <br><br>
						Dear Sir/ Madam,<br><br>
						This email is a friendly reminder that your <u>Declaration of W-8Ben</u> will be expiring on <b><u>'++ CONVERT(VARCHAR,@W8BENExpiryDate,103) + +'</b></u><br>
						If you wish to continue trading in the U.S. stock market, please submit the enclosed declaration form that was duly signed by you and send to your dealer representative or email to <font <font color="blue"><u>foreign@msec.com.my</u></font> .<br><br>
						The information is as follows : <br><br>
						<table>
						<tr> <td> a) Account Name </td> <td>: '+@CustomerName+'</td></tr>
						<tr> <td> b) Account Code </td><td>: '+@CustomerID+'</td></tr>
                        <tr> <td> c) Start date </td><td>:	' + CASE WHEN (@W8BENExpiryDate > @W8BENStartDate ) THEN CONVERT(VARCHAR,@W8BENStartDate,103) + ' (Valid for '+ CAST( DATEDIFF(YEAR, CAST(@W8BENStartDate AS DATETIME), CAST(@W8BENExpiryDate AS DATETIME)) AS VARCHAR)  +  'years)' ELSE ' ' END +' </td></tr>
						</table>
						<br><br>						
						
						Should you have forwarded the form to us for renewal of the aforesaid declaration, kindly disregard this notice. <br><br><br>
						Thank you. <br><br>
						Yours sincerely,<br><br><br><br><br><br>
						<b>Note</b> : The W-8Ben form will remain in effect for a period starting on the date the form is signed and submitted and ending on the last day of the third succeeding calendar year.
						</body></html>'
						

	

	SELECT  @ostrMailContent;	

	/* WorkFlow - End */

	
SET NOCOUNT OFF;
END