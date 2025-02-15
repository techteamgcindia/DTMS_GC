USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[opb_sp_TruckAvailablity]    Script Date: 2024-04-27 8:03:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
   CREATE proc [dbo].[opb_sp_TruckAvailablity] -- 'GC',100,'',''               
   (          
@var_user nvarchar(100)=''                                                       
,@var_pid int=''                                                       
,@var_clientid int=''          
,@par1 nvarchar(MAX)=''           
          
)          
   as          
   begin          
        
        
  --  if exists(select 1 from obp_avltruckcapacity where mainid=@var_pid  )        
  --  begin        
           
  --   select id,          
  --   sentfrom as sentfrom__obp_avltruckcapacity,          
  --   tolocation as tolocation__obp_avltruckcapacity,          
  --   truckno as truckno__obp_avltruckcapacity,          
  --   truckcap as truckcap__obp_avltruckcapacity,          
  --   percentagefill as percentagefill__obp_avltruckcapacity from obp_avltruckcapacity where mainid=@var_pid     
	 --and convert(nvarchar(10),CreatedDate,103)=convert(nvarchar(10),GETDATE(),103)  
  -- end     
  --  else        
  --  begin 
		declare @plant nvarchar(200),@branch nvarchar(200)
	     select @plant=SentFrom,@branch=ToLocation from obp_TotalLoad where id= @var_pid
		 and convert(nvarchar(10),CreatedDate,103)=convert(nvarchar(10),GETDATE(),103) 
         if not exists(select 1 from obp_avltruckcapacity where SentFrom=@plant and ToLocation=@branch and 
		 convert(nvarchar(10),CreatedDate,103)=convert(nvarchar(10),GETDATE(),103) )
		 begin
		   print 'i am in'
			insert into  obp_avltruckcapacity(SentFrom,ToLocation) values(@plant,@branch)    
		 end
		 select id,    
		 sentfrom as sentfrom__obp_avltruckcapacity,          
		 tolocation as tolocation__obp_avltruckcapacity,          
		 truckno as truckno__obp_avltruckcapacity,          
		 truckcap as truckcap__obp_avltruckcapacity,          
		 percentagefill as percentagefill__obp_avltruckcapacity from obp_avltruckcapacity where SentFrom=@plant and ToLocation=@branch
		 and convert(nvarchar(10),CreatedDate,103)=convert(nvarchar(10),GETDATE(),103) 
  --  end        
   end 
GO
