USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_ReadHelpContent]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_ReadHelpContent]      
@UserName nvarchar(MAX)=''      
AS      
BEGIN     
DECLARE @usertype nvarchar(MAX)=''

SET @usertype=(select UserTypeId from obps_users where UserName=@UserName)
  
select id,Displayname,GroupId,GroupName from obps_helpdoc 
where isactive=1  
and (userType='' 
or (CHARINDEX(@usertype,userType, 0)!=0)
or (UserType is null)
)
END 
GO
