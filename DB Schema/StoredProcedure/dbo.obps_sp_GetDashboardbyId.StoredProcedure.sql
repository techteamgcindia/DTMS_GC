USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_GetDashboardbyId]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_GetDashboardbyId]
@id nvarchar(MAX)=''
AS
BEGIN

select D.id 'id',M.DisplayName 'mainmenu',LinkName 'sublink',caption 
		from obps_Dashboards D 
		inner join obps_TopLinks T
		on T.id=D.LinkId 
		left join obps_MenuName M
		on M.MenuId=T.MenuId where D.id=@id

END
GO
