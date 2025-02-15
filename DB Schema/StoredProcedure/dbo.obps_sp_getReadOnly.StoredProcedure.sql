USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getReadOnly]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_getReadOnly]
@clientid NVARCHAR(MAX)=NULL,
@RoleId NVARCHAR(MAX)=NULL,
@LinkId NVARCHAR(MAX)=NULL,
@GridId nvarchar(5)=''
AS
BEGIN
 
		DECLARE @query NVARCHAR(MAX),
	   @query_colorid NVARCHAR(MAX),
	   @tabname NVARCHAR(MAX),
	   @cid NVARCHAR(MAX),
	   @sptablequery NVARCHAR(MAX) ,
	   @spname NVARCHAR(MAX),
	   @query_color NVARCHAR(MAX),
	   @colorname NVARCHAR(MAX),
	   @iRoleId int,
	   @GridTabName nvarchar(max)='',
	   @Gridname nvarchar(MAX),
	   @GridTableName nvarchar(MAX),
	   @tasktype nvarchar(MAX)

    SET NOCOUNT ON;
 
	set @GridTabName='Grid'+@GridId+'Table'
	SET @sptablequery=('(SELECT @GridTableName='+@GridTabName+' FROM Obps_TopLinks where Id='''+@LinkId+''')')
	EXEC Sp_executesql  @sptablequery,  N'@GridTableName NVARCHAR(MAX) output',  @GridTableName output

	SET @sptablequery=('(SELECT @tasktype=th_tasktype FROM '+@GridTableName+' where clientid='''+@clientid+''')')
	EXEC Sp_executesql  @sptablequery,  N'@tasktype NVARCHAR(MAX) output',  @tasktype output
	--select @tasktype
	IF @tasktype='Demo Task'
	BEGIN
		Select '1'
	END
	ELSE
	BEGIN
		Select '0'
	END

END
GO
