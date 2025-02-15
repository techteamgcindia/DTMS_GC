USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_readRoleMap]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_readRoleMap]
AS
BEGIN

select R.id,R.RoleId,M.DisplayName,R.LinkId,T.LinkName,R.TableID,
TableName,ColName,IsEditable,
R.Displayorder,R.gridid,R.IsMobile,R.IsVisible,VisibilityIndex 
from obps_RoleMap R
inner join obps_TopLinks T on T.id=R.LinkId 
inner join obps_MenuName M on M.MenuId=T.MenuId
--inner join obps_UserLinks U on T.id=U.sublinkid and R.RoleId=U.RoleId
where R.RoleId in(select distinct RoleId from obps_UserLinks where IsRoleAttached=1)
and R.LinkId in(select distinct sublinkid from obps_UserLinks where IsRoleAttached=1)

END
GO
