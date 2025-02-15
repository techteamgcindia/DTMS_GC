USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obp_SP_GMSScheduler]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create procedure [dbo].[obp_SP_GMSScheduler]
(
@var_user nvarchar(100)=''                                                                                 
,@var_pid int=''                                                                                 
,@var_clientid int=''                                                                                  
,@var_par1 nvarchar(max)='',@var_par2 nvarchar(max)='',@var_par3 nvarchar(max)='',@var_par4 nvarchar(max)='',@var_par5 nvarchar(max)=''  
)
as
Begin

DECLARE @SearchLetter nvarchar(100)                                                                                              
SET @SearchLetter ='%'+ @var_user + '%'                                                                     

Select 
id,
PlannedStartDt as 'start',
TaskActEstDt as 'end',
th_taskheader as 'text',
0 as 'allday'
from 
obp_taskheader
where taskstatus<> 'CP'
and ClientID>1 and ParentId=0
and PlannedStartDt is not null
and Createdby=@var_user

End
GO
