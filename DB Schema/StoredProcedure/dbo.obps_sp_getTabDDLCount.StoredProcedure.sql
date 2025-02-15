USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getTabDDLCount]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_getTabDDLCount]
@linkid int='',
@gridid int='',
@username nvarchar(MAX)=''
AS
BEGIN
declare @count int=0;

SET @count=@count+(select case when len(ToolBarDDLTxt1)>0 then 1 else 0 end from obps_toplinkextended where linkid=@linkid and gridid=@gridid)
SET @count=@count+(select case when len(ToolBarDDLTxt2)>0 then 1 else 0 end from obps_toplinkextended where linkid=@linkid and gridid=@gridid)
SET @count=@count+(select case when len(ToolBarDDLTxt3)>0 then 1 else 0 end from obps_toplinkextended where linkid=@linkid and gridid=@gridid)

SELECT @count

END
GO
