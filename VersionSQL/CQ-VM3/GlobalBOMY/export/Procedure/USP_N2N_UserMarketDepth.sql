/****** Object:  Procedure [export].[USP_N2N_UserMarketDepth]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [export].[USP_N2N_UserMarketDepth]  
(  
 @idteProcessDate DATETIME  
)  
AS  
/*  
EXEC [export].[USP_N2N_lobcrlimit] '2020-06-01'  
*/  
BEGIN  
   
 -- CASH BALANCE  
 CREATE TABLE #Detail  
 (  
     BROKERCODE      CHAR(3)
	,USERTYPE        CHAR(1)
	,USERCODE        CHAR(6)
	,BROKERBRANCH    CHAR(3)
	,MARKETDEPTSIZE  CHAR(1)
	,CHANGEDATE      CHAR(8)
	,EXCHANGECODE    CHAR(2)
 )  
  
 INSERT INTO #Detail  
 (  
    BROKERCODE     
   ,USERTYPE       
   ,USERCODE       
   ,BROKERBRANCH   
   ,MARKETDEPTSIZE 
   ,CHANGEDATE     
   ,EXCHANGECODE   
 )  
 SELECT   
	[BrokerCode (textinput-1)]
	,'' 
	 ,'' 
	,'' 
	,'' 
	,'' 
	,HomeExchCd 
 FROM   
		CQBTempDB.export.tb_formdata_2795 BRO
 INNER JOIN 
		GlobalBO.setup.Tb_Instrument INS ON INS.HomeCountryCd  = BRO.[Country (selectsource-5)]
  WHERE [Country (selectsource-5)]='MY'
    
 -- RESULT SET  
 SELECT   
       BROKERCODE + USERTYPE + USERCODE + BROKERBRANCH + MARKETDEPTSIZE + CHANGEDATE + EXCHANGECODE   
 FROM   
  #Detail  

  DROP TABLE #Detail
  
END  
  