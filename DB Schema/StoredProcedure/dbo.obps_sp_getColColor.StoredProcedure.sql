USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getColColor]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_getColColor]
@Gridname NVARCHAR(MAX)=NULL,
@colname NVARCHAR(MAX)=NULL,
@LinkId NVARCHAR(MAX)=NULL
AS
BEGIN
		DECLARE @query NVARCHAR(MAX),
	   @query_colorid NVARCHAR(MAX),
	   @tabname NVARCHAR(MAX),
	   @cid NVARCHAR(MAX),
	   @spquery NVARCHAR(MAX) ,
	   @spname NVARCHAR(MAX),
	   @query_color NVARCHAR(MAX),
	   @colorname NVARCHAR(MAX)

    SET NOCOUNT ON;
 
	SET @spquery=('(SELECT @spname='+@Gridname+' FROM Obp_LFLinks where '+@Gridname+'  is not null and LinkId='''+@LinkId+''')')
	EXEC Sp_executesql  @spquery,  N'@spname NVARCHAR(MAX) output',  @spname output

	SET @tabname=(SELECT DISTINCT t.name 
	FROM sys.sql_dependencies d 
	INNER JOIN sys.procedures p ON p.object_id = d.object_id
	INNER JOIN sys.tables     t ON t.object_id = d.referenced_major_id
	where p.name=@spname )

	SET @query_colorid=('SELECT @colorid = ColColor FROM Obp_ColAttrib WHERE TableName='''+@tabname+''' and ColName='''+@colname+'''')
	EXEC Sp_executesql  @query_colorid,  N'@colorid int output',  @cid output
	
	SET @query_color=('select @colourname=Color from Obp_ColorPicker where id='''+@cid+'''')
	EXEC Sp_executesql  @query_color,  N'@colourname NVARCHAR(MAX) output',  @colorname output
	select @colorname

END
GO
