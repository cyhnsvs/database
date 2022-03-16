/****** Object:  Procedure [export].[USP_BTX_btxclacinfo]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE  [export].[USP_BTX_btxclacinfo]
AS
BEGIN
--BATCH HEADER

CREATE TABLE #Header  (RecordType char(1)
 ,HeaderDate date
 ,Filler1 char(3)
 ,InterfaceID char(5)
 ,Filler2 char(3)
 ,SystemID char(4)
 ,Filler3 char(595)
 );
INSERT INTO #Header(RecordType
,HeaderDate
,Filler1
,InterfaceID
,Filler2
,SystemID
,Filler3
)
VALUES('R' ,getdate() ,'Fil' ,'Inter' ,'Fil' ,'Syst' ,'Filler3' )
--BATCH DETAILS

CREATE TABLE #Detail  (RecordType decimal(1,0)
 ,ClientCode char(15)
 ,BranchCode decimal(3,0)
 ,OICPassportOthers char(30)
 ,DateofBirth char(10)
 ,MobileNo char(50)
 ,Race char(1)
 ,EmailAddress char(255)
 ,Gender char(1)
 ,OutboundIndicator char(1)
 ,W8BenIndicator char(1)
 ,W8benExpiryDate char(10)
 ,BursaMultiCurrencyIndicator char(1)
 ,DCFIndicator char(1)
 ,OnlineIndicator char(1)
 ,GTDMode char(5)
 ,AllowforTrustWithdrawal char(1)
 ,LeapMarket char(1)
 ,Filler char(15)
 );
INSERT INTO #Detail(RecordType
,ClientCode
,BranchCode
,OICPassportOthers
,DateofBirth
,MobileNo
,Race
,EmailAddress
,Gender
,OutboundIndicator
,W8BenIndicator
,W8benExpiryDate
,BursaMultiCurrencyIndicator
,DCFIndicator
,OnlineIndicator
,GTDMode
,AllowforTrustWithdrawal
,LeapMarket
,Filler
)
VALUES(1 ,'ClientCode' ,1 ,'OICPassportOthers' ,'DateofBirt' ,'MobileNo' ,'R' ,'EmailAddress' ,'G' ,'O' ,'W' ,'W8benExpir' ,'B' ,'D' ,'O' ,'GTDMo' ,'A' ,'L' ,'Filler' )
--BATCH TRAILER
 DECLARE @Count INT;
  SET @Count = (SELECT COUNT(*) FROM #Detail);

CREATE TABLE #Trailer  (RecordType decimal(1,0)
 ,TrailerCount decimal(6,0)
 ,ProcessingDate char(8)
 ,BatchNumber decimal(6,0)
 );
INSERT INTO #Trailer(RecordType
,TrailerCount
,ProcessingDate
,BatchNumber
)
VALUES(1 ,@Count ,'27022022' ,1 )
SELECT RecordType+FORMAT(HeaderDate , 'ddMMyyyyhhmmss')+Filler1+InterfaceID+Filler2+SystemID+Filler3  FROM #Header
UNION ALL

SELECT RIGHT(REPLICATE('0', 1) + CAST(RecordType as varchar(1)), 1)+ClientCode+RIGHT(REPLICATE('0', 3) + CAST(BranchCode as varchar(3)), 3)+OICPassportOthers+DateofBirth+MobileNo+Race+EmailAddress+Gender+OutboundIndicator+W8BenIndicator+W8benExpiryDate+W8benExpiryDate+DCFIndicator+DCFIndicator+GTDMode+AllowforTrustWithdrawal+LeapMarket+Filler  FROM #Detail
UNION ALL

SELECT RIGHT(REPLICATE('0', 1) + CAST(RecordType as varchar(1)), 1)+RIGHT(REPLICATE('0', 6) + CAST(TrailerCount as varchar(6)), 6)+ProcessingDate+RIGHT(REPLICATE('0', 6) + CAST(BatchNumber as varchar(6)), 6)  FROM #Trailer

DROP TABLE #Header
DROP TABLE #Detail
DROP TABLE #Trailer
END