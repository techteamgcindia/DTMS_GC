USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getTopLink]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_getTopLink]      
@Username  NVARCHAR(MAX)=NULL      
AS      
BEGIN      
select MenuId,DisplayName from obps_menuname where MenuId in(      
select LinkId from Obps_UserLinks where userid =      
(select Id from Obps_Users where UserName=@Username) and isdeleted=0)      
END 
GO
