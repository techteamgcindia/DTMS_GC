USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getSublinkName]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_getSublinkName]
@linkid nvarchar(MAX)=''
AS
BEGIN
	select LinkName from obps_TopLinks where id=@linkid
END
GO
