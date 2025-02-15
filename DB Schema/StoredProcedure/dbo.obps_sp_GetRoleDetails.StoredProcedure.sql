USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_GetRoleDetails]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_GetRoleDetails]
@sublink int=0,
@roleid int=0,
@gid int=0
AS
BEGIN

select R.ID,RoleId 'role',M.DisplayName 'mainmenu',T.LinkName 'sublink',Tid.TableID,ColName 'colname',IsEditable,
R.TableName 'tabname',R.gridid 'gid',R.IsMobile,R.LinkId,COALESCE(R.IsVisible,0) 'IsVisible',VisibilityIndex 
from obps_RoleMap R
inner join obps_TopLinks T on T.id=R.LinkId
inner join obps_MenuName M on M.MenuId=T.MenuId
inner join obps_TableId Tid on Tid.TableID=R.tableid
where R.LinkId=@sublink and R.gridid=@gid and R.RoleId=@roleid

END

GO
