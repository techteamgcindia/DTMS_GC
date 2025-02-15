USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_GetUserLinkbyId]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_GetUserLinkbyId]  
@id nvarchar(MAX)=''
AS  
BEGIN  
 select L.id,linkid,sublinkid,L.LinkName,T.LinkName
  from obps_UserLinks L inner join obps_TopLinks T  
 on L.LinkId=T.MenuId and T.ID=L.sublinkid
 where LOWER(UserName)<>'admin'  and IsDeleted=0 and L.id=@id
END
GO
