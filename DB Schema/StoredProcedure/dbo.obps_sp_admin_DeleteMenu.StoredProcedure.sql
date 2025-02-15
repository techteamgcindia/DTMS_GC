USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_sp_admin_DeleteMenu]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_sp_admin_DeleteMenu]
@linkid nvarchar(MAX)=''
AS
BEGIN

delete from obps_TopLinks where id=@linkid
delete from obps_ColAttrib where LinkId=@linkid
delete from obps_UserLinks where sublinkid=@linkid
delete from obps_RowAttrib where LinkId=@linkid
delete from obps_ExcelImportConfig where LinkId=@linkid
delete from obps_ValidColumnsForImport where LinkId=@linkid
delete from obps_FileUpload where LinkId=@linkid
delete from obps_GanttConfiguration where LinkId=@linkid
delete from obps_CalculatedColAttrib where LinkId=@linkid

END
GO
