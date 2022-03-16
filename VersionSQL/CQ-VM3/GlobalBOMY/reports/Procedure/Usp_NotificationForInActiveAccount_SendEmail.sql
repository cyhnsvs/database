/****** Object:  Procedure [reports].[Usp_NotificationForInActiveAccount_SendEmail]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [reports].[Usp_NotificationForInActiveAccount_SendEmail]
	
	@istrAcctNo VARCHAR(100)
AS  
/*
* Created by:      SRIRAM
* Date:            12 Feb 2021
* Used by:         GBO Process 
* Called by:       GBO Batch Process Manager Monitor
* Project UIN:	   
* RFA:			   
*
* Purpose: This sp is used to send email alert for OverDue outstanding Losses in Client's Trading Account.
*
* Input Parameters:
* NONE
*
* Output Parameters:
* NONE
*
* Has been modified by + date + project UIN + note:
* 
EXEC  [reports].[Usp_NotificationForInActiveAccount_SendEmail] '010037402' 
*/

BEGIN  
SET NOCOUNT ON;

		DECLARE @strMailBody VARCHAR(MAX)='';

		DECLARE 
		@AccountName	VARCHAR(200),
		@AccountCode	VARCHAR(50),
		@AccountOpenDate DATE,
		@DealerContactNo VARCHAR(20);
		


	

	SELECT 
		@AccountName	= C.[CustomerName (textinput-3)],
		@AccountCode	= C.[CustomerID (textinput-1)],
		@AccountOpenDate= CAST(A.CreatedTime AS DATE),
		@DealerContactNo= DEA.[Phone (textinput-16)]
	FROM 
		CQBTempDB.export.Tb_FormData_1409 A 
	INNER JOIN 
		CQBTempDB.export.Tb_FormData_1410 C ON C.[CustomerID (textinput-1)] = A.[CustomerID (selectsource-1)]
	LEFT JOIN 
		CQBTempDB.export.Tb_FormData_1377 DEA ON A.[DealerCode (selectsource-21)] =DEA.[DealerCode (textinput-35)]

	WHERE A.[AccountNumber (textinput-5)] = @istrAcctNo
		

	   DECLARE @Logo VARCHAR(MAX)=(SELECT Files FROM reports.Tb_Logo WHERE Name='MonlineLogo')

		SET @strMailBody = '<html><body>
	                       <img src="'+ @Logo +'" /> <br><br>

						   Dear Sir/ Madam,<br><br>
						   We are writing to inform you that your trading account maintained with us is <u>dormant</u> or <u>invalid</u> for a period. 
						   After 30 days from the date of this letter, we will charge your account a service fee of up to RM10.
						   You can have at least one trading transaction within 30 days from the date of this letter to negate this service fee.<br><br>

							If you wish to continue trading, please contact your dealer representative at '+ @DealerContactNo +'  or activate your account by 
							downloading the <b>Bursa Anywhere</b> app either from the Play Store or App Store.<br><br>

							The information is as follows : <br><br>

							<table>
							<tr ><td> a) Account Name </td><td> : '+ @AccountName +'</td> </tr>
							<tr> <td> b) Account Code </td><td> : '+ @AccountCode +'</td> </tr>
							<tr> <td> c) Start date  </td><td> : '+ CAST( FORMAT(@AccountOpenDate, 'dd/MM/yyyy') AS VARCHAR(20)) +'</td></tr>
							</table><br><br> 

							Should you have re-activate of the aforesaid account, kindly disregard this notice. <br><br>


							Thank you. <br><br>

							Yours sincerely,<br><br>
							</body></html>';

		SELECT @strMailBody
		
	

SET NOCOUNT OFF;
END