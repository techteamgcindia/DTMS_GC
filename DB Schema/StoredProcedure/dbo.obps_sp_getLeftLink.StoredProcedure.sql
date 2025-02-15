USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getLeftLink]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_getLeftLink]
@Username  NVARCHAR(MAX)=NULL
AS
BEGIN
select LinkId,LinkName,Type from Obps_LFLinks where LinkId in(
select LinkId from Obps_UserLinks where userid =
(select Id from Obps_Users where UserName=@Username))
END
GO
