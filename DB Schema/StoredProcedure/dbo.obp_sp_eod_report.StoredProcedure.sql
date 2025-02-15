USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_eod_report]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

  
CREATE proc [dbo].[obp_sp_eod_report]            
(@var_user nvarchar(100)=''                                                         
,@var_pid int=''                                                         
,@var_clientid int=''                                                          
,@var_par1 nvarchar(max)='',@var_par2 nvarchar(max)='',@var_par3 nvarchar(max)='',@var_par4 nvarchar(max)='',@var_par5 nvarchar(max)=''                                                             
)                                                                      
as                                                                      
begin                                                                      
                                                                      
DECLARE @SearchLetter nvarchar(100)                                                                      
SET @SearchLetter ='%'+ @var_user + '%'                                             
                                            
Declare @var_usertype int,@var_userid int                                            
Set @var_usertype=(Select UserTypeId from obps_Users where UserName=@var_user)      
Set @var_userid= (Select id from obps_Users where UserName=@var_user)      
    
Declare @var_reccount int              
Set @var_reccount=0              
Set @var_reccount=(Select count(*) from obp_eod where id <> 1878 )         
    
/*Data: 2023-09-16 ; Desc:User created tasks will be show to below users */    
If (@var_userid in (12,13,17,64))    
Begin    
 If isnull(@var_reccount,0)=0              
 Begin        
 Select             
  1 as 'id'            
  ,Name as 'Name'            
  ,Project as 'Project'            
  ,TaskCategory as 'TaskCategory'            
  ,TaskType as 'TaskType'            
  --,TimeSpent as 'TimeSpent(HH:MM)'            
  ,Hours 'TimeSpent(Hours)'      
  ,Minutes 'TimeSpent(Minutes)'      
  ,Comments as 'Comments'            
  ,CONVERT(VARCHAR(10), EOD_Date, 111) as 'EOD Date'            
  --,cast((convert(date,CreatedDate,111)) as datetime)'EOD Punch Date'        
  ,null as 'EOD Punch Date'        
  from obp_eod        
  order by [EOD_Date] desc,Createdby        
 End        
 Else        
 Begin            
 Select             
  id            
  ,Createdby as 'Name'            
  ,Project as 'Project'            
  ,TaskCategory as 'TaskCategory'            
  ,TaskType as 'TaskType'            
  --,TimeSpent as 'TimeSpent(HH:MM)'            
  ,Hours 'TimeSpent(Hours)'      
  ,Minutes 'TimeSpent(Minutes)'      
  ,Comments as 'Comments'            
  --,CONVERT(VARCHAR(10), EOD_Date, 111) as 'EOD Date'                  
  --,CONVERT(VARCHAR(10), CreatedDate, 111) as 'EOD Punch Date'        
  ,cast(EOD_Date as date) as 'eod_date__obp_eod'  
  ,cast(CreatedDate as date) as 'createddate__obp_eod'  
  from obp_eod where id <> 1878   
  order by [EOD_Date] desc,Createdby        
 End        
End    
    
/*Data: 2023-09-16 ; Desc:All Tasks will be show to below users ; Reason: Validation and Report Analysis*/    
If (@var_userid not in (12,13,17,64))    
Begin    
 If isnull(@var_reccount,0)=0              
 Begin        
 Select             
  1 as 'id'            
  ,Name as 'Name'            
  ,Project as 'Project'            
  ,TaskCategory as 'TaskCategory'            
  ,TaskType as 'TaskType'            
  --,TimeSpent as 'TimeSpent(HH:MM)'            
  ,Hours 'TimeSpent(Hours)'      
  ,Minutes 'TimeSpent(Minutes)'      
  ,Comments as 'Comments'            
  ,CONVERT(VARCHAR(10), EOD_Date, 111) as 'EOD Date'            
  --,cast((convert(date,CreatedDate,111)) as datetime)'EOD Punch Date'        
  ,null as 'EOD Punch Date'        
  from obp_eod        
  order by [EOD_Date] desc,Createdby        
 End        
 Else        
 Begin            
 Select             
  id            
  ,Createdby as 'Name'            
  ,Project as 'Project'            
  ,TaskCategory as 'TaskCategory'            
  ,TaskType as 'TaskType'            
  --,TimeSpent as 'TimeSpent(HH:MM)'            
  ,Hours 'TimeSpent(Hours)'      
  ,Minutes 'TimeSpent(Minutes)'      
  ,Comments as 'Comments'            
  --,CONVERT(VARCHAR(10), EOD_Date, 111) as 'EOD Date'                  
  --,CONVERT(VARCHAR(10), CreatedDate, 111) as 'EOD Punch Date'        
  ,cast(EOD_Date as date) as 'eod_date__obp_eod'  
  ,cast(CreatedDate as date) as 'createddate__obp_eod'  
  from obp_eod where id > 100 and Createdby=@var_user       
  order by [EOD_Date] desc,Createdby        
 End     
End    
    
        
    
          
End       
GO
