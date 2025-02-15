USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[SP_SendNewOrderEmail]    Script Date: 2024-04-27 8:03:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[SP_SendNewOrderEmail]      
as      
Begin     
/*    
truncate table tb_NewOrdersEmail      
    
    
/*Populate the tb_NewOrdersEmail with valid records*/      
insert into tb_NewOrdersEmail       
Select Distributor,DealerName,DemandNo,MaterialDescription,Quantity      
,case when ModifiedDate is null then cast(createddate as date) else cast(ModifiedDate as date) end      
--,'bharat.sharma@goldrattgroup.com,punit.mulley@goldrattgroup.com'    
,''    
,0    
,WhetherApproved    
from obp_DemandEntry     
where WhetherApproved is not null     
--and DemandNo in ('10012','D-502446-3')      
*/    
    
/*Distibutor EMail*/    
;With Cte_01 as    
(    
Select DistributorName,max(isnull(EmailID,'bharat.sharma@goldrattgroup.com')) 'Email' from obp_ddlDistributors group by   DistributorName    
)    
update a set a.Email=b.Email   
from tb_NewOrdersEmail a,Cte_01 b where a.Distributor=b.DistributorName     
    
/*Dealer EMail*/    
;With Cte_02 as    
(    
Select CustomerName,max(isnull(EmailID,'punit.mulley@goldrattgroup.com')) 'Email' from obp_ddlCustomerMaster group by   CustomerName    
)    
update a set a.Email=a.Email+case when len(ltrim(rtrim(a.Email)))>1 then (';'+b.Email) else b.Email end    
from tb_NewOrdersEmail a,Cte_02 b where a.DealerName=b.CustomerName     
    
/*Accounts EMail*/    
update tb_NewOrdersEmail set email=email+case when len(ltrim(rtrim(Email)))>1 then (';hemant.kalia@goldrattgroup.com') else 'hemant.kalia@goldrattgroup.com' end    
    
/*Count No of Distributors*/      
Declare @var_cntdist int,@var_dist nvarchar(200),@var_email nvarchar(200)      
      
set @var_cntdist=(select count(distinct DealerName+'_'+Distributor) from tb_NewOrdersEmail)      
      
While @var_cntdist<>0      
 Begin      
 set @var_dist=(select top 1 (DealerName+'_'+Distributor) from tb_NewOrdersEmail where ind01=0)      
 set @var_email=(select top 1 Email from tb_NewOrdersEmail where (DealerName+'_'+Distributor)=@var_dist and ind01=0)      
      
 exec obp_NewOrdersEmail @var_email,@var_dist      
      
 update tb_NewOrdersEmail set ind01=1 where (DealerName+'_'+Distributor)=@var_dist      
 set @var_cntdist=@var_cntdist-1      
 End      
      
  
End 
GO
