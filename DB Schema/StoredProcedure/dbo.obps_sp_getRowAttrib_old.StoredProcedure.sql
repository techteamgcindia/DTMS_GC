USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getRowAttrib_old]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_getRowAttrib_old]
--declare
@Gridname NVARCHAR(MAX)=NULL,
@LinkId NVARCHAR(MAX)=NULL
AS
BEGIN
	   DECLARE @tabquery NVARCHAR(MAX),
	   @gridid VARCHAR(MAX),
	   @query NVARCHAR(MAX)


    SET NOCOUNT ON;

	--SET @tabquery=('(SELECT @tabname='+@Gridname+' FROM Obps_LFLinks where '+@Gridname+'  is not null and LinkId='''+@LinkId+''')')
	--EXEC Sp_executesql  @tabquery,  N'@tabname NVARCHAR(MAX) output',  @tabname output

	SET @gridid=SUBSTRING(@Gridname,5,1)

	set  @query=('select LOWER(colname)+''__''+LOWER(TableName),LOWER(MappedCol),LOWER(IsBackground) 
	from obps_RowAttrib where GridId='+@gridid+' and (colname is not null or colname<>'''')') -- colname<>''''and  colname is not null)
	EXEC Sp_executesql @query
	--select @query

END
GO
