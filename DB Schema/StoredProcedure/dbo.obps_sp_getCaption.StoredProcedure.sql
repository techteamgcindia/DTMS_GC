USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getCaption]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_getCaption]
AS
BEGIN

select id,caption 'DisplayName' from obps_Dashboards

END
GO
