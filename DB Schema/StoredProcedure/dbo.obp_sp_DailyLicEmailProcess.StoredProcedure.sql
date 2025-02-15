USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_DailyLicEmailProcess]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   proc [dbo].[obp_sp_DailyLicEmailProcess]                                      
as                                      
begin    
print getdate()  
      
truncate table obp_EmailList                              
truncate table obp_UserLicMapping                              
                              
                              
/*Getting Valid Clients For Lic Email*/    

insert into obp_UserLicMapping(ClientId,UserName,UserEmail,Ind01,ClientName,Email,DaysLeft,LicenseValidityDate)
select a.id,a.Implementer ,US.EmailId,0,a.ClientName,US.EmailId
, datediff(dd,getdate(),a.LicenseValidityDate) 'DaysLeft' ,convert(date,a.LicenseValidityDate) 'LicenseDate'
from  obp_ClientMaster a
join obps_Users US on US.UserName=a.Implementer 
where datediff(dd,getdate(),LicenseValidityDate) between -30 and 10 and isDeleted=0 and isActive=1 and a.onebeatlicense =1 and len(isnull(a.Implementer,''))>3
order by ClientName
                          
                              
/*Insert All valid clients for Hemant and Bharat User*/
Insert into obp_UserLicMapping
Select ClientId,'Hemant','hemant.kalia@goldrattgroup.com',1,ClientName,'hemant.kalia@goldrattgroup.com',DaysLeft,LicenseValidityDate from obp_UserLicMapping 

Insert into obp_UserLicMapping
Select ClientId,'Bharat','bharat.sharma@goldrattgroup.com',1,ClientName,'bharat.sharma@goldrattgroup.com',DaysLeft,LicenseValidityDate from obp_UserLicMapping  where ind01=1

Delete from obp_UserLicMapping where ind01=0 and UserName in ('Hemant','Bharat')

Update obp_UserLicMapping set ind01=0 

/*End - Generating Records for Client Contract Date For Hemant and Bharat User*/       

--Select * from obp_UserLicMapping order by UserName


If object_Id('tempdb..#tb_EmailLic') is not null drop table #tb_EmailLic

Select distinct UserName,UserEmail,0 'ind01' into #tb_EmailLic from obp_UserLicMapping

/*End - Getting Valid Clients For Lic Email*/                         
                      
                             
                                
/*Start Email Sending Process*/                              
declare @var_cnt int, @var_user nvarchar(100),@var_email nvarchar(100)                                    
set @var_cnt=(select count(*) from #tb_EmailLic where ind01=0)                             
                        
                       
while @var_cnt<>0                                    
begin                                    
set @var_user=(select top 1 UserName from #tb_EmailLic where ind01=0)                                    
set @var_email =(select top 1 Useremail  from #tb_EmailLic where username=@var_user)                                    
                                    
exec obp_LicDailyEmail @var_email,@var_user                                  
                                    
update #tb_EmailLic set ind01=1 where username=@var_user                                    
set @var_cnt=@var_cnt-1                                    
end                               
/*End - Email Sending Process*/     
                           
       
end 

  
GO
