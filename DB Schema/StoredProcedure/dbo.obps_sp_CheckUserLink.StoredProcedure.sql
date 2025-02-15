USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_CheckUserLink]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_CheckUserLink]  
@id nvarchar(MAX)='',  
@linkid nvarchar(MAX)='',  
@sublinkid nvarchar(MAX)='',  
@userid nvarchar(MAX)=''  
AS  
BEGIN  
if @id<>''  
BEGIN  
 IF ((SELECT count(*) from obps_UserLinks where LinkId=@linkid and sublinkid=@sublinkid and UserName=@userid  
 and IsDeleted=0 and id<>@id)>0)  
 BEGIN  
  select 0---user type exist in the db  
 END  
 ELSE  
 BEGIN  
  select 1---user type not exist in the db  
 END          
END  
ELSE  
BEGIN  
 IF ((SELECT count(*) from obps_UserLinks where LinkId=@linkid and sublinkid=@sublinkid   
 and IsDeleted=0 and UserId=@userid)>0)  
 BEGIN  
  select 0---user type exist in the db  
 END  
 ELSE  
 BEGIN  
  select 1---user type not exist in the db  
 END   
END  
END  
GO
