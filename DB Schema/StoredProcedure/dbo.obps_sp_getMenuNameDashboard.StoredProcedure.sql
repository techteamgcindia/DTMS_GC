USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getMenuNameDashboard]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_getMenuNameDashboard]
AS
BEGIN

select T.Id 'Id',DisplayName from obps_toplinks T
inner join obps_MenuName M on T.MenuId=M.MenuId
where T.Type=55

END
GO
