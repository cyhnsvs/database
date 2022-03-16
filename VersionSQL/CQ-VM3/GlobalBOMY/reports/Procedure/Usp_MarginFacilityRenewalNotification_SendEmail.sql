/****** Object:  Procedure [reports].[Usp_MarginFacilityRenewalNotification_SendEmail]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [reports].[Usp_MarginFacilityRenewalNotification_SendEmail]
   
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
EXEC [reports].[Usp_MarginFacilityRenewalNotification_SendEmail] '025932209'
*/

BEGIN  
SET NOCOUNT ON;
       DECLARE @ostrMailContent NVARCHAR(MAX)='';
	 
	DECLARE @Nominees1Name VARCHAR(100);
	DECLARE @Nominees2Name VARCHAR(100);
	DECLARE @ClientName VARCHAR(100);
	DECLARE @ClientAddress1 VARCHAR(MAX);
	DECLARE @ClientAddress2 VARCHAR(MAX);
	DECLARE @ClientAddress3 VARCHAR(MAX);
	DECLARE @ClientAddressTown VARCHAR(MAX);
	DECLARE @ClientAddressState VARCHAR(MAX);

	DECLARE @dteCommencementDate DATE;
	DECLARE @dteTenorExpiryDate DATE;


	
		
	SELECT
	@Nominees1Name = A.[NomineesName1 (selectsource-20)],
	@Nominees2Name = A.[NomineesName2 (textinput-7)],
	@ClientName    = C.[CustomerName (textinput-3)],
	@ClientAddress1 = C.[Address1 (textinput-41)],
	@ClientAddress2 = C.[Address2 (textinput-42)],
	@ClientAddress3 = C.[Address3 (textinput-43)],
	@ClientAddressTown =C.[Town (textinput-44)],
	@ClientAddressState =C.[State (textinput-45)],
	@dteCommencementDate = A.[CommencementDate (dateinput-4)],
	@dteTenorExpiryDate = A.[TenorExpiryDate (dateinput-5)]
	from 
	CQBTempDB.export.Tb_FormData_1409 A
	INNER JOIN CQBTempDB.export.Tb_FormData_1410 C
	ON C.[CustomerID (textinput-1)]  = A.[CustomerID (selectsource-1)]
	Where A.[AccountNumber (textinput-5)] = @istrAcctNo




    DECLARE @Logo1 VARCHAR(MAX)=(SELECT Files FROM reports.Tb_Logo WHERE Name='MonlineLogo')
	DECLARE @Logo2 VARCHAR(MAX)=(SELECT Files FROM reports.Tb_Logo WHERE Name='MalaccaSecuritiesLogo')
	DECLARE @dteBusinessDate VARCHAR(20)= (SELECT CONVERT(VARCHAR(20), CAST((SELECT GlobalBO.setup.Udf_FetchSetupDate(1, 'BusDate')) AS Datetime2), 103));

	
	SET @ostrMailContent= '<html>
						<body><img style="float: Left;" src="'+@Logo1+'"/> <br><br><br>

						<div style="width:50%;text-align:Left"> <img style="float: Left;" src="'+@Logo2+'"/> </div><br><br><br>
						Our Ref :  <br><br>
						Date : '+CONVERT(VARCHAR,@dteBusinessDate,103)  +' <br><br>
						

						'+CASE WHEN @Nominees1Name <> '' THEN CAST(@Nominees1Name AS VARCHAR(100))+' <br>' ELSE '' END 
						 +CASE WHEN @Nominees2Name <> '' THEN CAST(@Nominees2Name AS VARCHAR(100))+' <br><br>' ELSE '' END		
						 +CASE WHEN @ClientName <> '' THEN @ClientName+' <br>' ELSE '' END
						 +CASE WHEN @ClientAddress1 <> '' THEN @ClientAddress1+' <br>' ELSE '' END
						 +CASE WHEN @ClientAddress2 <> '' THEN @ClientAddress2+' <br>' ELSE '' END
						 +CASE WHEN @ClientAddress3 <> '' THEN @ClientAddress3+' <br>' ELSE '' END
						 +CASE WHEN @ClientAddressState <> '' THEN @ClientAddressState+' <br>' ELSE '' END
						 +CASE WHEN @ClientAddressTown <> '' THEN @ClientAddressTown+' <br>' ELSE '' END+'<br>
					
						 Dear Sir/Madam, <br><br>

						 <b style="text-decoration: underline">Renewal Of Margin Financing Facility</b><br><br>

						 We are pleased to advise that the company shall renew the above facility for a further
						 period of 3 months (commencing from '+ CAST(FORMAT(@dteTenorExpiryDate,'dd MMMM yyyy') AS varchar(50)) +' to '+ CAST(FORMAT(DATEADD(day, 90, CAST(@dteTenorExpiryDate as date)),'dd MMMM yyyy') AS varchar(50)) +')
						 The terms and conditions of the facility remained as per the Letter of Offer, Margin
						 Account Agreement and Memorandum of Deposit.
						 Kindly inform us within Fourteen (14) days from the date of this letter if you do not
						 wish to renew the above facility.
						 Should you require further information, please contact our margin department at 06-3371533.
						 Thank you.<br><br>
						 Yours faithfully,<br>
						 MALACCA SECURITIES SDN BHD (COMPANY NO.16121-H)<br><br><br>

						 This is computer generated, no signature is required.<br>

</body></html>'
						

	

	SELECT  @ostrMailContent;	

	/* WorkFlow - End */

	
SET NOCOUNT OFF;
END