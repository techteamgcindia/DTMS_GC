USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_admin_updateuserlink]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_admin_updateuserlink]
@linkid nvarchar(MAX)='',
@MenuId nvarchar(MAX)=''
AS
BEGIN
DECLARE @sublinkname nvarchar(MAX)='',@mainmenuname nvarchar(MAX)=''
SET @mainmenuname=(select DisplayName from obps_MenuName where MenuId=@MenuId)

update obps_UserLinks set linkname=@mainmenuname,LinkId=@MenuId where sublinkId=@linkid

END
GO
