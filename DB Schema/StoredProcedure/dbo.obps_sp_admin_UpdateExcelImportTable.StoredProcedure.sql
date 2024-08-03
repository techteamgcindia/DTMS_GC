USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_admin_UpdateExcelImportTable]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[obps_sp_admin_UpdateExcelImportTable]
@LinkId nvarchar(MAX)='',
@TableName nvarchar(MAX)='',
@TempTableName nvarchar(MAX)='',
@InsertSp nvarchar(MAX)='',
@id int
AS
BEGIN
	update obps_ExcelImportConfig set LinkId=@LinkId,TableName=@TableName,TempTableName=@TempTableName,InsertSp=@InsertSp where id=@id
END
GO
