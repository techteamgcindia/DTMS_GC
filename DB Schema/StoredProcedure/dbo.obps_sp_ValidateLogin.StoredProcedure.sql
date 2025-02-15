USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_ValidateLogin]    Script Date: 2024-04-27 8:03:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_ValidateLogin]  
 @usrname nvarchar(MAX),  
 @pass nvarchar(MAX),  
 @usrtype nvarchar(MAX)=''  
AS  
BEGIN  
 IF @usrtype=''  
 BEGIN  
  select Password from [dbo].[obps_Users] U inner join [dbo].[obps_UserType] UT   
  on U.UserTypeId=UT.UserTypeId  
  where UserName=@usrname COLLATE Latin1_General_CS_AS   
 END  
 ELSE  
 BEGIN  
  select Password from [dbo].[obps_Users] U inner join [dbo].[obps_UserType] UT   
  on U.UserTypeId=UT.UserTypeId and UT.UserType=@usrtype  
  where UserName=@usrname COLLATE Latin1_General_CS_AS 
 END  
END  
GO
