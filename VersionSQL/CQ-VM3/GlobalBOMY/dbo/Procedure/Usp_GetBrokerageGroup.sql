/****** Object:  Procedure [dbo].[Usp_GetBrokerageGroup]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE dbo.Usp_GetBrokerageGroup
    @iintCompanyId int
AS
BEGIN

SET NOCOUNT ON;
    
	SELECT CAST(BrokerageGroupId as varchar(20)) ItemValue,
		   BrokerageGroupCd ItemLabel,
		   '<table><tr><td colspan=''4''> <b> TierGroupCd : </b> ' + G.TierGroupCd +'&nbsp;&nbsp;<b> TierCategory : </b> '+ G.TierCategory +'&nbsp;&nbsp;<b>Remarks : </b> '+ G.Remarks + '</td>' + --AS HeaderLabel,
		   CAST('<tr><th>TierCategory</th><th>FromValue</th><th>ToValue</th><th>Rate</th></tr>' + 
				(select replace (REPLACE(STUFF((select '<tr>' +'<td>' + cast ( TierCategory as varchar) + '</td>' 
													+'<td class=''r''>' + cast ( CAST(ROUND(FromValue,2) as decimal(24,2)) as varchar) + '</td>' 
													+'<td class=''r''>' + cast ( CAST(ROUND(ToValue,2,1) as decimal(24,2)) as varchar) + '</td>' 
													+'<td class=''r''>' + cast ( CAST(ROUND(Rate,4) as decimal(24,4))	 as varchar) + '</td>' +
													'</tr>' 
				from GlobalBO.setup.Tb_Tier T where T.TierGroupId= G.TierGroupId FOR XML PATH('')), 1, 0, ''),'&lt;','<'),'&gt;','>')+ '</table>') as varchar(4000)) AS DetailedInfo
    FROM GlobalBO.setup.Tb_BrokerageGroup AS B
	INNER JOIN GlobalBO.setup.Tb_TierGroup AS G
	ON B.TierGroupId = G.TierGroupId AND B.CompanyId = G.CompanyId
	WHERE B.CompanyId = @iintCompanyId;

	--select replace (REPLACE(STUFF((select '<tr>' +'<td>' + cast ( TierCategory as varchar) + '</td>' +'<td class=''r''>' + cast ( FromValue 	 as varchar) + '</td>' +'<td class=''r''>' + cast ( ToValue 	 as varchar) + '</td>' +'<td class=''r''>' + cast ( Rate  		 as varchar) + '</td>' + 
	--'</tr>' from setup.Tb_Tier T where T.TierGroupId= #result.NewValue            FOR XML PATH('')         ), 1, 0, ''),'&lt;','<'),'&gt;','>')+ '</table>') 
	--,
	--OldValuedesc= OldValuedesc + (
	--select replace (REPLACE(STUFF((select '<tr>' +'<td>' + cast ( TierCategory as varchar) + '</td>' +'<td class=''r''>' + cast ( FromValue 	 as varchar) + '</td>' +'<td class=''r''>' + cast ( ToValue 	 as varchar) + '</td>' +'<td class=''r''>' + cast ( Rate  		 as varchar) + '</td>' + 
	--'</tr>' from setup.Tb_Tier T where T.TierGroupId= #result.OldValue            FOR XML PATH('')         ), 1, 0, ''),'&lt;','<'),'&gt;','>')+ '</table>') 
	--where ColumnName='TierGroupId'

SET NOCOUNT OFF;

END