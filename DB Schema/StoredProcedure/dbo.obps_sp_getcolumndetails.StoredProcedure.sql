USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getcolumndetails]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[obps_sp_getcolumndetails]
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
	   @colorname NVARCHAR(MAX),
	   @dispname NVARCHAR(MAX),
	   @ParmDefinition NVARCHAR(500),
	   @ctrltype NVARCHAR(MAX),
	   @PrefLang int=0
    SET NOCOUNT ON;

	/* Need to check how to get Current User Display Name Setting to @PrefLang -- 1 OR 0*/
 
	SET @spquery=('(SELECT @spname='+@Gridname+' FROM Obp_LFLinks where '+@Gridname+'  is not null and LinkId='''+@LinkId+''')')
	EXEC Sp_executesql  @spquery,  N'@spname NVARCHAR(MAX) output',  @spname output

	SET @tabname=(SELECT DISTINCT t.name 
	FROM sys.sql_dependencies d 
	INNER JOIN sys.procedures p ON p.object_id = d.object_id
	INNER JOIN sys.tables     t ON t.object_id = d.referenced_major_id
	where p.name=@spname )
	------,@dispname=ColControlType
	/*
	SET @query_colorid=('SELECT @cid = ColColor,@dispname=DisplayName,@ctrltype=ColControlType
	FROM Obp_ColAttrib WHERE TableName='''+@tabname+''' and ColName='''+@colname+'''')
	*/

	SET @query_colorid=('SELECT @cid = ColColor,@dispname=case when @PrefLang=1 then isnull(AltLang,DisplayName) else DisplayName end ,@ctrltype=ColControlType
	FROM Obp_ColAttrib WHERE TableName='''+@tabname+''' and ColName='''+@colname+'''')

	SET @ParmDefinition=N'@cid int output,@dispname nvarchar(MAX) output,@ctrltype nvarchar(MAX)OUTPUT'

	EXEC Sp_executesql  @query_colorid,  @ParmDefinition,  @cid output,@dispname output,@ctrltype output

	SET @query_color=('select @colourname=Color from Obp_ColorPicker where id='''+@cid+'''')
	EXEC Sp_executesql  @query_color,  N'@colourname NVARCHAR(MAX) output',  @colorname output

	select @colorname,@dispname,@ctrltype

END

GO
