USE [obp_dtms]
GO
/****** Object:  StoredProcedure [dbo].[obps_getImportDeleteTable]    Script Date: 2024-04-27 8:03:16 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[obps_getImportDeleteTable]        
@tablename nvarchar(MAX)=''   ,    
@linkid nvarchar(MAX)='',
@userName nvarchar(MAX)=''
AS        
BEGIN        
DECLARE @DeleteSp nvarchar(MAX)=''

set @DeleteSp=(select ltrim(rtrim(DeleteSp)) from obps_ExcelImportConfig where LinkId=@linkid)        
    
if len(ltrim(rtrim(@DeleteSp)))>1      
begin      
/*Implementer SP will have userid as parameter*/    
exec @DeleteSp   @Username     
end        
END

GO
