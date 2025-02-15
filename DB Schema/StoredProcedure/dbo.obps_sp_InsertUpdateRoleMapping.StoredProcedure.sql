USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_InsertUpdateRoleMapping]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[obps_sp_InsertUpdateRoleMapping]    
@tabname nvarchar(MAX)='',    
@roleid nvarchar(MAX),    
@ColName nvarchar(MAX),    
@IsVisible nvarchar(MAX),    
@Ismobile nvarchar(MAX),    
@VisibilityIndex nvarchar(MAX) ,
@linkid int=0,
@gridid nvarchar(MAX)    
AS    
BEGIN    
    
DECLARE @count nvarchar(MAX)    
 SET @count=(select count(*) from obps_rolemap where tablename=@tabname and RoleId=@roleid)    
 IF @count>0     
 BEGIN    
  update obps_rolemap set    
  IsMobile=@Ismobile,IsVisible=@IsVisible,VisibilityIndex=@VisibilityIndex  
  where tablename=@tabname and RoleId=@roleid and ColName=@ColName
		and LinkId=@linkid and gridid=@gridid
 END    
END    
GO
