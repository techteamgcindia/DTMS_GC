USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getUserId]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_getUserId]
@User_Name nvarchar(MAX)
AS
BEGIN
SELECT UserId FROM Obp_Users WHERE UserName='hanusha'
END
GO
