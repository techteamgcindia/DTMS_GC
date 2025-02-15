USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_InsertUserType]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[obps_sp_InsertUserType]  
@type nvarchar(MAX),
@typeDesc nvarchar(MAX)
AS    
BEGIN    
DECLARE @UserTypeExist int=0,@UserTypeId int=0;
set @UserTypeExist=(select count(*) from obps_UserType where UserType=@type)
set @UserTypeId=(select max(usertypeid) from obps_UserType)+1
if @UserTypeExist>0
select 'User Type already exist'
else
BEGIN
insert into  obps_UserType(UserTypeId,UserType,UserTypeDesc)
values
(@UserTypeId,@type,@typeDesc)
select 'User Type Added'
END
END
GO
