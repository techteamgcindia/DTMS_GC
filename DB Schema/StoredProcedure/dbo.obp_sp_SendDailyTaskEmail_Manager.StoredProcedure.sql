USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obp_sp_SendDailyTaskEmail_Manager]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create      proc [dbo].[obp_sp_SendDailyTaskEmail_Manager]                
as                
Begin                
                
Declare @var_emailto nvarchar(100),@var_uname nvarchar(100)                
                
Set @var_emailto='hemant.kalia@goldrattgroup.com;srinivasan.v@goldrattgroup.com'                   
/*Set @var_emailto='bharat.sharma@goldrattgroup.com'        */
Set @var_uname='Hemant'                
                
DECLARE @xml NVARCHAR(MAX)                                        
DECLARE @body NVARCHAR(MAX)                   
                
DECLARE @xml1 NVARCHAR(MAX)                                        
DECLARE @body1 NVARCHAR(MAX)                                      
  
/*                        
SET @xml = CAST(( SELECT [Owner] AS 'td','',[TaskType] AS 'td','', [Nos] AS 'td','' ,[NS] as 'td','' ,[IP] as 'td','' ,[Red] as 'td','' ,[Black] as 'td'                                         
FROM obp_tb_DailyTaskEmails_CountToEmail   
ORDER BY Owner,TaskType desc    
FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX))           
*/  
  
/*Get the Data for specific user - Ticket Count*/          
SET @xml = CAST(( SELECT [Owner] AS 'td','',[TaskType] AS 'td','', [Nos] AS 'td','' ,[NS] as 'td','' ,[IP] as 'td','' ,[Ttl_Red] as 'td','' ,[Ttl_Black] as 'td'                 
FROM obp_tb_DailyTaskEmails_CountToEmail   
ORDER BY Owner,TaskType desc                                          
FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX))                                                   
                
SET @xml1 = CAST(( SELECT [Owner] AS 'td','',[Type] AS 'td','',[Ticket] AS 'td','',[Client] AS 'td','', [TaskName] AS 'td','' ,[TaskStatus] as 'td','' ,[ColorPriority] as 'td',''                  
FROM obp_tb_DailyTaskEmails_SummaryToEmail                 
ORDER BY Owner,Type Desc,Ticket                                        
FOR XML PATH('tr'), ELEMENTS ) AS NVARCHAR(MAX))                                    
  
                                                                         
                                        
SET @body ='<html><body>Dear Sir/Madam'+' '+'<P><BR>Please find below Task Status Summary and Details for Tickets assigned to the Team.</BR><P> Task Summary: <P>      
<table border = 1>                                         
<tr bgcolor=Orange>                                        
<th> Owner </th> <th> TaskType </th> <th> Total </th><th> NS </th><th> IP </th><th> Red </th><th> Black </th></tr>'                        
                       
                
SET @body = @body + @xml                
                
Set @body1='<P></table><BR>Task Details:</BR><P><table border = 1>                                         
<tr bgcolor=Orange>                                        
<th>Owner </th><th>Type </th><th>Ticket </th> <th> Client </th> <th> TaskName </th><th> TaskStatus </th><th> ColorPriority </th></tr>'            
              
SET @body = @body +'<P>' + @body1 + @xml1+'</table><BR>Thanks</BR><BR>OneBeat Team</BR><BR>-----This is an auto generated email. Please Do not Reply-----</BR></body></html>'                   
                                
EXEC msdb.dbo.sp_send_dbmail                                        
@profile_name = 'Autoemails',                                        
@body = @body,                                        
@body_format ='HTML',                               
@recipients = @var_emailto,                               
@subject = 'DTMS : Task Summary & Details of your Team' ;                 
                
            
End           
      
GO
