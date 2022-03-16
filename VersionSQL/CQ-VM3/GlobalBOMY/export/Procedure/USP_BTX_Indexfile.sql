/****** Object:  Procedure [export].[USP_BTX_Indexfile]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE  [export].[USP_BTX_Indexfile]
AS
BEGIN

--BATCH DETAILS

CREATE TABLE #Detail  (BranchCode char(3)
 ,Type char(2)
 ,DocumentDate char(8)
 ,ClientCode char(9)
 ,DocumentType char(4)
-- ,DocumentFileName char(50)
 );
INSERT INTO #Detail(BranchCode
,Type
,DocumentDate
,ClientCode
,DocumentType
--,DocumentFileName
)
VALUES('001' ,'ES' ,'20130326' ,'AB0123456' ,'.pdf'  )
 
SELECT BranchCode+Type+DocumentDate+ClientCode+DocumentType FROM #Detail
 

 
DROP TABLE #Detail 
END