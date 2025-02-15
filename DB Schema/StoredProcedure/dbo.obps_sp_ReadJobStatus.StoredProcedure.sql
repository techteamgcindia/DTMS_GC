USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_ReadJobStatus]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_ReadJobStatus]
@linkid nvarchar(10)=''
,@username nvarchar(MAX)=''
AS
BEGIN

	DECLARE @jname nvarchar(MAX)=''

	SET @jname=(select gridsp from obps_TopLinkExtended where linkid=@linkid)

	SELECT j.name AS job_name, 
		   ja.start_execution_date AS StartTime,
		   COALESCE(CONVERT(VARCHAR(5),ABS(DATEDIFF(DAY,(GETDATE()-ja.start_execution_date),'1900-01-01'))) + ' '
				   +CONVERT(VARCHAR(10),(GETDATE()-ja.start_execution_date),108),'00 00:00:00') AS [Duration] 
	FROM msdb.dbo.sysjobactivity ja 
	LEFT JOIN msdb.dbo.sysjobhistory jh ON ja.job_history_id = jh.instance_id
	JOIN msdb.dbo.sysjobs j ON ja.job_id = j.job_id
	WHERE ja.session_id = (SELECT TOP 1 session_id FROM msdb.dbo.syssessions ORDER BY session_id DESC)
	  AND start_execution_date is not null
	  AND stop_execution_date is null
	  and j.name=@jname

END
GO
