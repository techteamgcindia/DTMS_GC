USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_SpRowConditioning_old]    Script Date: 2024-04-27 8:03:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[obps_SpRowConditioning_old]  
(@var_tableid int,@var_id int)  
as  
begin  
if @var_tableid=301  
begin  
update obp_TaskHeader set Color1=case when priority='H' then 'Red' when priority='M' then 'Yellow' else 'White' end where id=@var_id  
update obp_TaskHeader set Color2=case when TaskStatus='IP' then 'LightGreen' when TaskStatus='CP' then 'DarkOrange'  when TaskStatus='NS' then 'SkyBlue'  else 'White' end   
where   
id=@var_id and   
th_TaskHeader<>'Click + Sign to Add Records'  
end  
  
if @var_tableid=302  
begin  
--update obp_TaskDetails set Color1=case when TaskStatus='IP' then 'LightGreen' when TaskStatus='NS' then 'Red' else 'White' end where id=@var_id  
update obp_TaskDetails set Color2=case when TaskStatus='IP' then 'LightGreen' when TaskStatus='CP' then 'DarkOrange'  when TaskStatus='NS' then 'SkyBlue'  else 'White' end   
where   
id=@var_id and   
TaskDetail<>'Click + Sign to Add Records'  
end  
  
end  
GO
