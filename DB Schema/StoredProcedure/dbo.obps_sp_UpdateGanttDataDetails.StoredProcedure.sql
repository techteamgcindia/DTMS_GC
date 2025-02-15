USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_UpdateGanttDataDetails]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_UpdateGanttDataDetails]
@key nvarchar(10)='',
@LinkId int='',
@usr nvarchar(MAX)='',
@start nvarchar(MAX)='',
@end nvarchar(MAX)='',
@subject nvarchar(MAX)=''
AS
BEGIN

DECLARE @startcol nvarchar(MAX)='',@endcol nvarchar(MAX)=''
,@tabname nvarchar(MAX)='',@subjectcol nvarchar(MAX)=''
,@string1 nvarchar(MAX)=''

SET @startcol=(SELECT StartColName from obps_GanttConfig where linkid=@LinkId)
SET @endcol=(SELECT EndColName from obps_GanttConfig where linkid=@LinkId)
SET @subjectcol=(SELECT SubjectColName from obps_GanttConfig where linkid=@LinkId)
SET @tabname=(SELECT Tablename from obps_GanttConfig where linkid=@LinkId)

SET @string1='update '+@tabname+' set '+@startcol+'='''+@start+''','+@endcol+'='''+@end+''','+@subjectcol+'='''+@subject+''' where id='+@key
exec (@string1)

END
GO
