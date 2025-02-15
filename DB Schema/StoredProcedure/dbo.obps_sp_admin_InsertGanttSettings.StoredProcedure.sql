USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_admin_InsertGanttSettings]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE PROCEDURE [dbo].[obps_sp_admin_InsertGanttSettings]
  @linkid nvarchar(MAX)='',
  @ganttsp nvarchar(MAX)='',
  @dependencysp nvarchar(MAX)=''
  AS
  BEGIN
  DECLARE @count int=0
  SET @count=(SELECT count(*) from obps_GanttConfiguration where LinkId=@linkid) 
  if @count>0
  BEGIN
		update obps_GanttConfiguration set GanttSp=@ganttsp,DependencySp=@dependencysp where LinkId=@linkid
		select '1'
  END
  else
  BEGIN
	  INSERT INTO obps_GanttConfiguration(GanttSp,DependencySp,LinkId)
	  values(@ganttsp,@dependencysp,@linkid)
	  select '1'
  END
  END
GO
