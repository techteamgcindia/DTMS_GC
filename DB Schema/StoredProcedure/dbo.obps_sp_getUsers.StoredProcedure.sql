USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getUsers]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[obps_sp_getUsers]          
@id  nvarchar(MAX)='',          
@populateddl nvarchar(50)='',          
@bindGrid nvarchar(50)=''          
AS          
BEGIN          
if @bindGrid=''          
begin          
 if @id<>'' and @populateddl='no'           
  select U.ID,UserId,UserName,RoleId,Company,Division,Department,SubDept,Password,U.UserTypeId,DefaultLinkId,AfterLoginSP           
  from obps_Users U          
  inner join obps_usertype T on U.UserTypeId=T.UserTypeId          
  where U.id=@id and UserName<>'admin'          
 else           
 begin          
  if @populateddl='yes'          
   select id,username from obps_Users where UserName<>'admin'          
  else          
   select * from obps_Users where UserName<>'admin'          
 end          
end          
else          
begin          
select U.id 'id',UserId,UserName    
  ,R.RoleId 'roleid',    
  emailId,    
  Company,Division,    
  Department,SubDept,    
  U.UserTypeId,UserType,    
  t.MenuId,DisplayName,    
  DefaultLinkId,T.LinkName 'submenu',    
  AfterLoginSP ,ReportingManager          
  from obps_Users U      
  inner join obps_RoleMaster R on  U.RoleId=R.ID     
  inner join obps_usertype UT on U.UserTypeId=UT.UserTypeId    
  left join obps_TopLinks T on t.id=DefaultLinkId    
  left join obps_MenuName M on M.id=T.MenuId    
   where UserName<>'admin'          
end          
END   

GO
