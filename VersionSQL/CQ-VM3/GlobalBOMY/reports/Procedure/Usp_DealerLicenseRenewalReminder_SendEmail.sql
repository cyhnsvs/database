/****** Object:  Procedure [reports].[Usp_DealerLicenseRenewalReminder_SendEmail]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [reports].[Usp_DealerLicenseRenewalReminder_SendEmail]	
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
 EXEC [reports].[Usp_DealerLicenseRenewalReminder_SendEmail] 'D0003819'	
*/

BEGIN  
SET NOCOUNT ON;

		DECLARE @strMailBody VARCHAR(MAX)='';

		DECLARE @DealerName VARCHAR(200),
				@ExpiryDate VARCHAR(20),
				@CPEPoints VARCHAR(10),
				@MaxCPEPoints VARCHAR(20)
		
		--Testing--
	--	SET @DealerName = 'Sriram';
	--	SET @ExpiryDate = '2021-06-09';
	--	SET @CPEPoints  = '19';

    SET @MaxCPEPoints = (SELECT GlValue FROM GlobalBO.setup.Tb_GlobalValues WHERE GlType = 'DealerMinCPEPoints')

	----WorkFlow----

	SELECT 
		@DealerName = DEA.[Name (textinput-3)],
		@ExpiryDate = 	CAST(FORMAT(CAST([LicenseAnniversaryDate (dateinput-2)] AS Datetime2), 'dd.MM.yy') AS varchar(20)),
		@CPEPoints  = ISNULL(CPE.[Approved Points (TextBox)],'')
	FROM CQBTempDB.export.Tb_FormData_1377 DEA 
	LEFT JOIN CQBTempDB.export.Tb_FormData_1377_grid5 CPE
		ON DEA.RecordId = CPE.RecordId
	WHERE DEA.[DealerAccountNo (textinput-37)] =@istrAcctNo
	
	DECLARE @Logo VARCHAR(MAX)=(SELECT Files FROM reports.Tb_Logo WHERE Name='MonlineLogo')

		SET @strMailBody = '<html><body>
	                    <img src="'+@Logo+'" /> <br><br>
						  

						Hi '+@DealerName+', <br><br>
						Please be reminded that your license will be expired on <b style="color:red;">'+CAST(@ExpiryDate AS VARCHAR)+'</b><br><br>
						CPE points needed before '+CAST(@ExpiryDate AS VARCHAR)+' : '+@MaxCPEPoints+'<br>
						Your Current CPE points : '+ CASE WHEN @CPEPoints ='' THEN '0' ELSE @CPEPoints END +'<br> 
						SC does not grant any extension of time for non-compliance to CPE requirement as the license 
						holders are expected to observe the following clauses in Chapter 8 of the Licensing Handbook: <br><br>
						1. 8.01(5) where, "All  CMSRL  holders <b style="text-decoration: underline">must</b>  obtain  '+@MaxCPEPoints+'  CPE  points  in  a  year  on  or  before  
						the anniversary date of their licence or cycle period as required in order to continue carrying out 
						the relevant regulated activity." <br><br>
						You may refer to the link below to check the <b>Instructor-LED or Online</b> course that suit your 
						availability and register yourself with the training provider.<br><br>
						http://ers.seccom.com.my/cpepublic/SearchTrainingCalendar.aspx?ActiveTab=1 <br>
						Kindly revert soonest possible.<br><br>
 
						Thank you.<br>
						Best Regards,<br>
						Licensing Team<br>
						</body></html>';

	SELECT @strMailBody
		
SET NOCOUNT OFF;
END