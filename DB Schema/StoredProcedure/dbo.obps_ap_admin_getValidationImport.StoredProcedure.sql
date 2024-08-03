USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_ap_admin_getValidationImport]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_ap_admin_getValidationImport]
@linkid nvarchar(MAX)='',
@tablename nvarchar(MAX)=''
AS
BEGIN
 
 SELECT id,ColumnName,Datatype FROM obps_ValidColumnsForImport
 WHERE LinkId=@linkid AND TableName=@tablename

END
GO
