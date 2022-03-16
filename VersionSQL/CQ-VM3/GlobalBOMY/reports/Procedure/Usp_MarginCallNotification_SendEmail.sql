/****** Object:  Procedure [reports].[Usp_MarginCallNotification_SendEmail]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [reports].[Usp_MarginCallNotification_SendEmail]
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
EXEC [reports].[Usp_MarginCallNotification_SendEmail] '2020-12-31','015816102'
*/

BEGIN  
SET NOCOUNT ON;
       DECLARE @ostrMailContent NVARCHAR(MAX)='';
	  

/*	  /* Workflow - Start*/         
	
	
	DECLARE 
	  @Margin VARCHAR(100)
	 ,@Equity VARCHAR(100)
	 ,@Outstanding VARCHAR(100)
	 ,@PercentageOfEquity VARCHAR(100)
	 ,@Shortfall VARCHAR(100)
	 ,@ShortFallPercentage VARCHAR(100)
	 


	SELECT DISTINCT
	  @Margin			  = MRS.MarginRatio,
	  @Equity			  = MRS.Equity,
	  @OutStanding        = MRS.OutstandingAmount,
	  @PercentageOfEquity = CAST((MRS.Equity * 100.00)/MRS.OutstandingAmount AS VARCHAR(20)), 
	  @Shortfall		  = MRS.CallShortage,
	  @ShortFallPercentage= CAST((MRS.CallShortage * 100.00)/MRS.OutstandingAmount AS VARCHAR(20))
	 

		
    FROM
		GlobalBOMY.margin.Tb_MarginRptSummary MRS
	WHERE AcctNo = @istrAcctNo
	*/

	DECLARE 
	  @Margin VARCHAR(100) ='100.00'
	 ,@Equity VARCHAR(100) = '1000.00'
	 ,@Outstanding VARCHAR(100)  = '1002.00'
	 ,@PercentageOfEquity VARCHAR(100) ='149.00'
	 ,@Shortfall VARCHAR(100) = '71.00'
	 ,@ShortFallPercentage VARCHAR(100) = '0.51';

	DECLARE @ClientName VARCHAR(100);
	DECLARE @ClientAddress1 VARCHAR(MAX);
	DECLARE @ClientAddress2 VARCHAR(MAX);
	DECLARE @ClientAddress3 VARCHAR(MAX);
	DECLARE @ClientAddressTown VARCHAR(MAX);
	DECLARE @ClientAddressState VARCHAR(MAX);
	
		
	SELECT 
	@ClientName    = Customer.[CustomerName (textinput-3)],
	@ClientAddress1 = Customer.[Address1 (textinput-35)],
	@ClientAddress2 = Customer.[Address2 (textinput-36)],
	@ClientAddress3 = Customer.[Address3 (textinput-37)],
	@ClientAddressTown =Customer.[Town (textinput-38)],
	@ClientAddressState =Customer.[State (textinput-39)]
	from 
	CQBTempDB.export.Tb_FormData_1409 Account
	INNER JOIN CQBTempDB.export.Tb_FormData_1410 Customer
	ON Customer.[CustomerID (textinput-1)]  = Account.[CustomerID (selectsource-1)]
	Where Account.[AccountNumber (textinput-5)] = @istrAcctNo

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

						Date : '+CONVERT(VARCHAR,@dteBusinessDate,103)  +' <br><br>
						

						MALACCA EQUITY NOMINEES (TEMPATAN) SDN BHD <br>
						'+@ClientName+'<br>
						'+@ClientAddress1+'<br>
						'+@ClientAddress2+'<br>
						'+@ClientAddress3+'<br>
						'+@ClientAddressState+'<br>
						'+@ClientAddressTown+'<br><br>


						 Dear Sir/Madam, <br><br>
						 We wish to bring to your attention that as at '+CAST(CONVERT(VARCHAR(20), CAST(@idteDate AS Datetime2), 103) AS VARCHAR(20))+', your margin account has a Security 
						 Margin Value of '+ @PercentageOfEquity +' %. This is below the 150.00 % Required Security Value (RSV %)
						 as required by BMSB Rule 7.30(15) Your account summary is as follows : <br><br>
						 <table>
						 <tr><td>Margin (aggregate amount of collateral) </td> <td>: RM </td> <td style="text-align: right">'+ @Margin +'</td></tr>
						 <tr><td>Equity (sum of margin and purchased shares) </td><td>: RM </td><td style="text-align: right"> ' + @Equity + '</td></tr>
						 <tr><td>Outstanding </td><td>: RM </td><td style="text-align: right">'+ @Outstanding +'</td></tr>
						 <tr><td>Percentage of equity over outstanding </td><td>: </td><td style="text-align: right">'+ @PercentageOfEquity +' % </td></tr>
						 <tr><td>Minimum percentage as required by BMSB </td><td>: </td><td style="text-align: right">150.00 %</td></tr>
						 <tr><td>Shortfall </td><td>: RM </td><td style="text-align: right" >'+ @Shortfall +'</td><td> ( '+ @ShortFallPercentage +' %)</td></tr>
						 </table>
						 <br><br>
						 Kindly note that all future purchases are suspended until the above position is duly rectified
						 to 150.00 %.<br><br>
						 You are therefore requested either<br>
						 a) to top-up the shortfall, or<br>
						 b) to reduce the amount outstanding<br><br>
						 You are requested to take any one of the above actions within three ( 3) market days from
						 the date of this letter. Failing which, the Company shall have the absolute discretion to sell
						 your quoted shares in our custody without further notice to rectify your outstanding position.<br><br>
						 Please ignore this letter if the above position has been rectified.<br>
						 Thank you.<br><br>
						 Yours faithfully,<br>
						 MALACCA SECURITIES SDN BHD (COMPANY NO.16121-H)<br><br><br>

						 Operations Department<br>
						 This is computer generated, no signature is required.<br>

</body></html>'
						
	SELECT  @ostrMailContent;	

	/* WorkFlow - End */

	
SET NOCOUNT OFF;
END