USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_admin_InsertImportValidation]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_admin_InsertImportValidation]
@linkid nvarchar(MAX)='',
@tablename nvarchar(MAX)='',
@colname nvarchar(MAX)='',
@datatype nvarchar(MAX)=''
AS
BEGIN

insert into obps_ValidColumnsForImport(Tablename,ColumnName,Datatype,linkid) 
values(@tablename,@colname,@datatype,@linkid)

END
GO
