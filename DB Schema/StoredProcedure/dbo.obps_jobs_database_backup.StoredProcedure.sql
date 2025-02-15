USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_jobs_database_backup]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*Created to take backup every day*/              
CREATE   proc [dbo].[obps_jobs_database_backup]              
as              
begin              
              
Declare @var_dt varchar(10),@var_path varchar(500)              
Declare @var_timestamp varchar(10)            
            
set @var_dt=(select convert(varchar(10),convert(date,getdate())))              
set @var_timestamp=convert(varchar(4),datepart(hh,getdate()))+'_'+convert(varchar(4),datepart(mi,getdate()))            
set @var_path='C:\GCData\DbBackup\SQLDBAutoBkup\obp_dtms_'+@var_dt+'_'+@var_timestamp+'.bak'              
              
BACKUP DATABASE [obp_dtms]              
TO  DISK = @var_path              
WITH CHECKSUM;              
end 
GO
