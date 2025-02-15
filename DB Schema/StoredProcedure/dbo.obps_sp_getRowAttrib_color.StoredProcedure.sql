USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_getRowAttrib_color]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_getRowAttrib_color]
@Gridname NVARCHAR(MAX)=NULL,
@LinkId NVARCHAR(MAX)=NULL
AS
BEGIN
SET NOCOUNT ON;

DECLARE @col NVARCHAR(MAX)='',
		@query_colorid NVARCHAR(MAX)='',
		@columnname NVARCHAR(MAX)='',
		@spquery NVARCHAR(MAX)='',
		@tabname NVARCHAR(MAX)=''

IF OBJECT_ID('tempdb..#temp1') IS NOT NULL 
BEGIN 
    DROP TABLE #temp1 
END
CREATE TABLE #temp1
(
	Id INT,
	columns NVARCHAR(MAX),
	hexacode NVARCHAR(MAX),
	columnname NVARCHAR(MAX)

)
SET @spquery=('(SELECT @tabname='+@Gridname+' FROM Obps_LFLinks where '+@Gridname+'  is not null and LinkId='''+@LinkId+''')')
EXEC Sp_executesql  @spquery,  N'@tabname NVARCHAR(MAX) output',  @tabname output

DECLARE CUR_TEST CURSOR FAST_FORWARD FOR
SELECT MappedCol,colname+'__'+@tabname FROM obps_RowAttrib where TableName=@tabname and MappedCol like '%_color'
 
OPEN CUR_TEST
FETCH NEXT FROM CUR_TEST INTO @col,@columnname
 
WHILE @@FETCH_STATUS = 0
BEGIN

		SET @query_colorid=('insert into #temp1 select th.id,'+@col+',Hexcode,'''+@columnname+'''
		 from obp_TaskHeader th inner join obps_colorpicker clr on '+@col+'=clr.ColorID  where '+@col+' is not null and '+@col+'!='' ''')
		EXEC Sp_executesql @query_colorid

	   FETCH NEXT FROM CUR_TEST INTO @col,@columnname
	 
END
CLOSE CUR_TEST
DEALLOCATE CUR_TEST
SELECT * FROM #temp1
END
GO
