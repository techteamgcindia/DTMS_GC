USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getSubLink]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_getSubLink]      
@Username  NVARCHAR(MAX)='' ,    
@linkid int='',
@IsMob NVARCHAR(MAX)=''
AS      
BEGIN      
 if @Username<>'' and @linkid<>'' and @IsMob=''
 BEGIN    
 select Id,linkname from obps_toplinks where Id in(    
 select sublinkid from Obps_UserLinks where userid =      
 (select Id from Obps_Users where UserName=@Username) 
 and IsDeleted=0 and linkid=@linkid)  order by SortOrder    
END    
else if @Username<>'' and @linkid='' and @IsMob='' 
BEGIN    
 select Id,linkname from obps_toplinks where Id in(    
 select sublinkid from Obps_UserLinks where userid =      
 (select Id from Obps_Users where UserName=@Username)and IsDeleted=0 )  order by SortOrder    
END    
else if @Username<>'' and @linkid='' and @IsMob='yes' 
BEGIN    
 select Id,linkname from obps_toplinks where Id in(    
 select sublinkid from Obps_UserLinks where userid =      
 (select Id from Obps_Users where UserName=@Username)and IsDeleted=0 )
 and IsMobile=1 order by SortOrder    
END 
ELSE    
BEGIN    
 select  Id,linkname from obps_toplinks where MenuId=@linkid  order by SortOrder  
END    
END   
GO
