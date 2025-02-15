USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_ClientDetail]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   proc [dbo].[obp_sp_ClientDetail]      
(@var_user nvarchar(100)=''     
,@var_pid int=''     
,@var_clientid int=''      
,@var_par1 nvarchar(max)='',@var_par2 nvarchar(max)='',@var_par3 nvarchar(max)='',@var_par4 nvarchar(max)='',@var_par5 nvarchar(max)=''         
)                  
as                  
begin                  
                  
DECLARE @SearchLetter nvarchar(100)                  
SET @SearchLetter ='%'+ @var_user + '%'                  
                  
          
Select id  
,ClientName   
--,convert(varchar,LicenseValidityDate, 111) as 'licensevaliditydate__obp_clientmaster'  
,licensevaliditydate as 'licensevaliditydate__obp_clientmaster'  
,case when LicenseValidityDate is not null then datediff(dd,getdate(),LicenseValidityDate) else 0 end 'DaysLeftToExpireLicense'  
from obp_ClientMaster  
where id in (select value from string_split(@var_par1,','))   
and isActive=1  
order by ClientName      

End 

GO
