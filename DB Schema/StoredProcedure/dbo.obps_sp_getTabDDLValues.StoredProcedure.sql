USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getTabDDLValues]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_getTabDDLValues]
@linkid int='',
@gridid int='',
@ddlno int='',
@username nvarchar(MAX)=''
AS
BEGIN

DECLARE @spname nvarchar(MAX)=''

if @ddlno=1
	SET @spname=(select ToolBarDDLSp1 from obps_TopLinkExtended where Linkid=@linkid and GridId=@gridid)
else if @ddlno=2
	SET @spname=(select ToolBarDDLSp2 from obps_TopLinkExtended where Linkid=@linkid and GridId=@gridid)
else
	SET @spname=(select ToolBarDDLSp3 from obps_TopLinkExtended where Linkid=@linkid and GridId=@gridid)

if len(rtrim(ltrim(@spname)))>0      
 exec @spname @username,@linkid,@gridid

END
GO
