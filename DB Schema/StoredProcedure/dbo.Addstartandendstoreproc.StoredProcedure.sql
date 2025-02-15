USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[Addstartandendstoreproc]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*SP created to update obp_taskheader from sharepoint*/  
CREATE   PROCEDURE [dbo].[Addstartandendstoreproc]  
-- Add the parameters for the stored procedure here 
 @TaskStartDate Datetime,  @TaskEndEstDate Datetime,  @Ticketid int,  @Duration float,  @assignto varchar(50),  @assigntoEmail varchar(50),  @Remakers Varchar(50),  @Sprint varchar(50),  @FKBY Varchar(50)   
AS BEGIN  
-- SET NOCOUNT ON added to prevent extra result sets from  
-- interfering with SELECT statements.  SET NOCOUNT ON;   
Declare @Prev@TaskStartDate date,@PrevTaskEndEstDate date  
set @Prev@TaskStartDate=(Select top 1 TaskActStartDt from obp_Taskheader_test WHERE id = @Ticketid)  set @PrevTaskEndEstDate=(Select top 1 TaskActEstDt from obp_Taskheader_test WHERE id = @Ticketid)       
-- Insert statements for procedure here  
UPDATE [dbo].[obp_Taskheader_test]  SET TaskActStartDt = @TaskStartDate,  TaskActEstDt = @TaskEndEstDate,  TaskDuration = @Duration,  FKBy = @FKBY,  th_Remarks=@Remakers,  Sprint=@Sprint,  AssignTo =@assignto,Assigntoemail =@assigntoEmail
WHERE id = @Ticketid;
exec obp_sp_MainTaskCompletionCheck @Ticketid 
/*Update the Log  insert into obp_tasksupdatedfromOutside(TaskId,Column
Name,CurrentValue,NewCurrentValue,ProcessDate)  Select id,'TaskActStartDt',cast(@Prev@TaskStartDate as varchar(21)),cast(TaskActStartDt as varchar(21)),getdate() from obp_Taskheader where id=@Ticketid   insert into obp_tasksupdatedfromOutside(TaskId,Colum
nName,CurrentValue,NewCurrentValue,ProcessDate)  Select id,'TaskActEstDt',cast(@PrevTaskEndEstDate as varchar(21)),cast(TaskActEstDt as varchar(21)),getdate() from obp_Taskheader where id=@Ticketid   */  

END 
GO
