USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_admin_InsertImportDetails]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_admin_InsertImportDetails]
@LinkId nvarchar(MAX)='',
@TableName nvarchar(MAX)='',
@TempTableName nvarchar(MAX)='',
@InsertSp nvarchar(MAX)=''
AS
BEGIN

	insert into obps_ExcelImportConfig(LinkId,TableName,TempTableName,InsertSp) values(@LinkId,@TableName,@TempTableName,@InsertSp)
END

GO
