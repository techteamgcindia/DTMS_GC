USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_admin_DeleteChartSettings]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[obps_sp_admin_DeleteChartSettings]
@linkid int=''
AS
BEGIN

delete from obps_charts where LinkId=@linkid

END
GO
