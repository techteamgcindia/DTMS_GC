USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_UpdateUser]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[obps_sp_UpdateUser]    
@UserName nvarchar(MAX)='',    
@RoleId nvarchar(MAX)='',    
@Company nvarchar(MAX)='', 
@email  nvarchar(MAX)='', 
@Division nvarchar(MAX)='',    
@Department nvarchar(MAX)='',    
@SubDept nvarchar(MAX)='',    
@UserTypeId nvarchar(MAX)='',    
@DefaultLinkId nvarchar(MAX)='',    
@id nvarchar(MAX)=''  ,  
@AfterLoginSp nvarchar(MAX)='' ,
@reportingmanager nvarchar(MAX)='' 
AS    
BEGIN    
    
DECLARE @count nvarchar(MAX)    
DECLARE @userselcount nvarchar(MAX)    
DECLARE @userlinkid nvarchar(MAX)=''    
    
 SET @count=(select count(*) from obps_Users where id=@id)    
 IF @count>0     
 BEGIN    
  update obps_Users set UserName=@UserName,RoleId=@RoleId,Company=@Company,Division=@Division,    
  Department=@Department,SubDept=@SubDept,emailid=@email,UserTypeId=@UserTypeId,DefaultLinkId=@DefaultLinkId,  
  AfterLoginSP=@AfterLoginSp,reportingmanager=@reportingmanager where ID=@id    
    
  SET @userselcount=(select count(*) from obps_UserLinks where UserId=@id and RoleId=@RoleId)    
  IF @userselcount=0    
  BEGIN    
   update obps_UserLinks set RoleId=@RoleId where UserId=@id    
       
   DECLARE CUR_TESTRoleMap CURSOR FAST_FORWARD FOR    
   select id from obps_UserLinks where UserId=@id and IsDeleted=0    
   OPEN CUR_TESTRoleMap    
   FETCH NEXT FROM CUR_TESTRoleMap INTO @userlinkid    
   WHILE @@FETCH_STATUS = 0    
   BEGIN    
    select @userlinkid    
    exec obps_sp_InsertRoleMapping @userlinkid    
    FETCH NEXT FROM CUR_TESTRoleMap INTO @userlinkid    
   END    
   CLOSE CUR_TESTRoleMap    
   DEALLOCATE CUR_TESTRoleMap    
   END    
 END    
END    
    
GO
