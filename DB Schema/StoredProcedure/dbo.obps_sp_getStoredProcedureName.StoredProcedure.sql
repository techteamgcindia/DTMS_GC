USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getStoredProcedureName]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_getStoredProcedureName]
AS
BEGIN
	Select [NAME] as 'spname' from sysobjects where type = 'P' and category = 0 and name like '%obp_sp%'
END
GO
