/****** Object:  Procedure [reports].[Usp_MarginRenewalNotification_SendEmail]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [reports].[Usp_MarginRenewalNotification_SendEmail]
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
EXEC [reports].[Usp_MarginRenewalNotification_SendEmail] '2020-12-31','015816102'
*/

BEGIN  
SET NOCOUNT ON;
       DECLARE @ostrMailContent NVARCHAR(MAX)='';
	  
	DECLARE @ClientName VARCHAR(100);
	DECLARE @ClientAddress1 VARCHAR(MAX);
	DECLARE @ClientAddress2 VARCHAR(MAX);
	DECLARE @ClientAddress3 VARCHAR(MAX);
	DECLARE @ClientAddressTown VARCHAR(MAX);
	DECLARE @ClientAddressState VARCHAR(MAX);
	
		
	SELECT 
	@ClientName    = C.[CustomerName (textinput-3)],
	@ClientAddress1 = C.[Address1 (textinput-35)],
	@ClientAddress2 = C.[Address2 (textinput-36)],
	@ClientAddress3 = C.[Address3 (textinput-37)],
	@ClientAddressTown =C.[Town (textinput-38)],
	@ClientAddressState =C.[State (textinput-39)]
	from 
	CQBTempDB.export.Tb_FormData_1409 A
	INNER JOIN CQBTempDB.export.Tb_FormData_1410 C
	ON C.[CustomerID (textinput-1)]  = A.[CustomerID (selectsource-1)]
	Where A.[AccountNumber (textinput-5)] = @istrAcctNo




    DECLARE @Logo VARCHAR(MAX)=(SELECT Files FROM reports.Tb_Logo WHERE Name='MonlineLogo')
	DECLARE @dteBusinessDate VARCHAR(20)= (SELECT CONVERT(VARCHAR(20), CAST((SELECT GlobalBO.setup.Udf_FetchSetupDate(1, 'BusDate')) AS Datetime2), 103));

	
	SET @ostrMailContent= '<html>
						<body><img style="float: Left;" src="'+@Logo+'"/> <br><br><br>

						<p style = "text-align: center">MALACCA SECURITIES SDN BHD (COMPANY NO.16121-H) <br>
														NO 1, 3 & 5 JALAN PPM 9 <br>
														PLAZA PANDAN MALIM BUSINESS PARK <br> 
														BALAI PANJANG, P.O. BOX 248<br>
														75250 MELAKA <br>
													    Tel No : 06-3371533 Fax No : 06-3371577</p> <br><br>
						Our Ref :  <br><br>
						Date : '+CONVERT(VARCHAR,@dteBusinessDate,103)  +' <br><br>
						

						MALACCA EQUITY NOMINEES (TEMPATAN) SDN BHD <br>
						PLEDGED SECURITIES ACCOUNT FOR <br>
						'+@ClientName+'<br>
						'+@ClientAddress1+'<br>
						'+@ClientAddress2+'<br>
						'+@ClientAddress3+'<br>
						'+@ClientAddressState+'<br>
						'+@ClientAddressTown+'<br><br>


						 Dear Sir/Madam, <br><br>

						 <b style="text-decoration: underline">Renewal Of Margin Financing Facility</b><br><br>

						 We are pleased to advise that the company shall renew the above facility for a further
						 period of 3 months (commencing from '+ CAST(FORMAT(@idteDate,'dd MMMM yyyy') AS varchar(50)) +' to '+CAST( FORMAT(DATEADD(MONTH, 3, @idteDate),'dd MMMM yyyy') AS VARCHAR(50))+')
						 The terms and conditions of the facility remained as per the Letter of Offer, Margin
						 Account Agreement and Memorandum of Deposit.
						 Kindly inform us within Fourteen (14) days from the date of this letter if you do not
						 wish to renew the above facility.
						 Should you require further information, please contact CIK MARIAH / MS TAN POI CHIN
						 at 06-3371533 EXT 19

						 Thank you.<br><br>
						 Yours faithfully,<br>
						 MALACCA SECURITIES SDN BHD (COMPANY NO.16121-H)<br><br><br>

						 This is computer generated, no signature is required.<br>

</body></html>'
						

	

	SELECT  @ostrMailContent;	

	/* WorkFlow - End */

	
SET NOCOUNT OFF;
END